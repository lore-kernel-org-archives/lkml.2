Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab1KUN5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 08:57:31 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64006 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab1KUN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 08:56:30 -0500
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>, sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RFCv1 6/9] xshm: Platform driver for XSHM
Date: Mon, 21 Nov 2011 14:56:01 +0100
Message-Id: <1321883764-1958-7-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the configuration handling and interface to XSHM
drivers. Specifically:
- reception of gen-netlink requests from user-space.
- calculating address of where to put information in shared memory, i.e
  the offset of: IPC-TOC, channel-descriptors, read/write indexes for each
  directional channel, and data area of each channel.
- formatting of the shared memory area, so modem can read out configuration
  data.
- Creation of configuration data given to the XSHM drivers: xshm_chr and
  caif_xshm.
- Platform device management.
- Channel management such as open/close.
- Modem start-up synchronization events.
- C2C power request indications, requesting power-on when transmit is ongoing,
  and power-off upon inactivity timeout.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/xshm/xshm_boot.c | 1176 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/xshm/xshm_pdev.c |  459 ++++++++++++++++++
 2 files changed, 1635 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xshm/xshm_boot.c
 create mode 100644 drivers/xshm/xshm_pdev.c

diff --git a/drivers/xshm/xshm_boot.c b/drivers/xshm/xshm_boot.c
new file mode 100644
index 0000000..0cdbbcf
--- /dev/null
+++ b/drivers/xshm/xshm_boot.c
@@ -0,0 +1,1176 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2010
+ * Author:	Sjur Brændeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s :" fmt, __func__
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/ctype.h>
+#include <linux/crc-ccitt.h>
+#include <linux/kdev_t.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#include <linux/xshm/xshm_ipctoc.h>
+#include <linux/xshm/xshm_pdev.h>
+#include <linux/xshm/xshm_netlink.h>
+#include <linux/xshm/genio.h>
+
+#define XSHM_VERSION	0x1
+#define XSHM_SUBVER	0x0
+#define TOC_SZ		512
+#define IMG_MAX_SZ	65536
+#define XSHM_ALIGNMT	sizeof(u32)
+#define XSHM_MAX_CHANNELS 7
+#define XSHM_MIN_CHSZ 3
+#define XSHM_PAYL_ALIGN max(32, L1_CACHE_BYTES)
+
+#define GET_OFFSET(base, ptr) (((u8 *)(ptr)) - ((u8 *)(base)))
+#define OFFS2PTR(base, offs) ((void *) ((u8 *)base + offs))
+#define LEOFFS2PTR(base, offs) ((void *) ((u8 *)base + le32_to_cpu(offs)))
+
+/* Structure use in debug mode for integrity checking */
+struct ipctoc_hash {
+	u16 img_hash;
+	u16 ch_hash;
+	u16 ch_size;
+};
+
+static bool commited;
+static bool registered;
+static bool addr_set;
+static unsigned long xshm_base_address;
+static long xshm_size;
+static u32 modem_bootimg_size;
+static void *shm_start;
+static u32 xshm_channels;
+static struct xshm_dev *xshmdevs[XSHM_MAX_CHANNELS + 1];
+static struct xshm_ipctoc *ipctoc;
+static struct platform_device *pldev;
+
+module_param(xshm_base_address, ulong, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(xshm_base_address, "External Shared Memory base address.");
+
+module_param(xshm_size, long, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(xshm_size, "Size of External Shared Memory area.");
+
+#ifdef DEBUG
+
+/* In debug mode we pad around all payload area in order to detect overwrite */
+#define MAGIC_PAD_LEN 32
+#define MAGIC_PAD 0xbc
+
+/* Verify a magic-pad area */
+static inline bool padok(void *mag)
+{
+	u32 *p = mag, v = 0xbcbcbcbc;
+	int i;
+
+	for (i = 0; i < 8; i++)
+		if (*p++ != v)
+			return false;
+	return true;
+}
+
+/* Insert a magic-pad area */
+static inline void add_magic_pad(u32 *offset, void *base)
+{
+	if (*offset < xshm_size)
+		memset(base + *offset, MAGIC_PAD, MAGIC_PAD_LEN);
+	*offset += MAGIC_PAD_LEN;
+}
+
+/* Abuse the pad area to create a checksum of the ipc-toc and descriptors */
+static inline void store_checksum(struct xshm_ipctoc *ipctoc, u32 size)
+{
+	struct ipctoc_hash *hash = (void *)ipctoc;
+	--hash;
+	hash->img_hash =
+		crc_ccitt(0xffff, (u8 *) shm_start, modem_bootimg_size);
+	hash->ch_hash = crc_ccitt(0xffff, (u8 *) ipctoc, size);
+	hash->ch_size = size;
+}
+
+/* Verify that shm config has not been accidently tampered. */
+static inline bool ok_checksum(struct xshm_ipctoc *ipctoc)
+{
+	struct ipctoc_hash *hash = (void *) ipctoc;
+	u16 new_hash, new_imghash;
+	int i;
+	u8 *p;
+
+	if (!commited)
+		return false;
+
+	for (i = 0; i < xshm_channels; i++) {
+		struct xshm_ipctoc_channel *ch;
+
+		ch = LEOFFS2PTR(shm_start, ipctoc->channel_offsets[i].rx);
+		p = LEOFFS2PTR(shm_start, ch->ipc);
+		if (!padok(p - MAGIC_PAD_LEN))
+			return false;
+		p = LEOFFS2PTR(shm_start, ch->offset);
+		if (!padok(p - MAGIC_PAD_LEN))
+			return false;
+		ch = LEOFFS2PTR(shm_start, ipctoc->channel_offsets[i].tx);
+		p = LEOFFS2PTR(shm_start, ch->ipc);
+		if (!padok(p - MAGIC_PAD_LEN))
+			return false;
+		p = LEOFFS2PTR(shm_start, ch->offset);
+		if (!padok(p - MAGIC_PAD_LEN))
+			return false;
+	}
+
+	--hash;
+	new_hash = crc_ccitt(0xffff, (u8 *) ipctoc, hash->ch_size);
+	new_imghash =
+		crc_ccitt(0xffff, (u8 *) shm_start, modem_bootimg_size);
+	pr_debug("Hash result:size:%d chksm:%u/%u img:%u/%u\n",
+			hash->ch_size, hash->ch_hash, new_hash,
+			hash->img_hash, new_imghash);
+	return hash->ch_hash == new_hash && hash->img_hash == new_imghash;
+}
+
+static inline void init_data(u32 offset, int ch, u32 size)
+{
+	memset((u8 *)shm_start + offset, ch + 1, size);
+}
+#else
+#define MAGIC_PAD_LEN 0
+static inline void add_magic_pad(u32 *offset, void *base)
+{
+}
+static inline void store_checksum(void *ipctoc, u32 size)
+{
+}
+static inline bool ok_checksum(void *ipctoc)
+{
+	return true;
+}
+static inline void init_data(u32 offs, int ch, u32 size)
+{
+}
+#endif
+
+/* write_to_shm - Write SHM Channel descriptors to SHM.
+ *
+ * Based on the configuration data channel configuration
+ * is written to the shared memory area.
+ * This is the data layout:
+ *
+ * +------------+  <---- xshm_base_address
+ * |	TOC	|
+ * +------------+
+ * | Boot IMG	|
+ * +------------+ <---- rw_start
+ * | RW Data	|
+ * +------------+
+ * | RW Buf idx |
+ * +------------+ <---- ipctoc
+ * | IPC TOC	|
+ * +------------+
+ * | RW Ch Decr |
+ * +------------+ <---- ro_start
+ * | RO Ch Decr |
+ * +------------+
+ * | RO Buf idx |
+ * +------------+
+ * | RO Data	|
+ * +------------+
+ */
+
+static int write_to_shm(void)
+{
+	int i, pri, bitno;
+	u32 offset, ro_start, rw_start, ipctoc_offs, ipcro_offs;
+	bool found;
+	struct xshm_ipctoc_channel *ch;
+	struct toc_entry *toc_entry;
+	struct xshm_bufidx *bix;
+
+	/*
+	 * Find where to put IPC-TOC by adding up
+	 * the size of Payload buffers pluss buf-indices
+	 */
+	ipctoc_offs = ALIGN(modem_bootimg_size, XSHM_PAYL_ALIGN);
+	rw_start = ipctoc_offs;
+	for (i = 0; i < xshm_channels; i++) {
+		int n = xshmdevs[i]->cfg.tx.buffers;
+		ipctoc_offs += MAGIC_PAD_LEN;
+		ipctoc_offs += offsetof(struct xshm_bufidx, size[n + 2]);
+		ipctoc_offs = ALIGN(ipctoc_offs, XSHM_PAYL_ALIGN);
+		ipctoc_offs += MAGIC_PAD_LEN;
+		ipctoc_offs += xshmdevs[i]->cfg.tx.ch_size;
+		ipctoc_offs = ALIGN(ipctoc_offs, XSHM_PAYL_ALIGN);
+	}
+	add_magic_pad(&ipctoc_offs, shm_start);
+	pr_debug("IPC toc @ %08x\n", ipctoc_offs);
+
+	/*
+	 * Allocate the IPC-TOC and, initiatlize it.
+	 * The IPC toc will be located after the RW Data and
+	 * buffer indices.
+	 */
+	offset = ipctoc_offs;
+	ipctoc = OFFS2PTR(shm_start, ipctoc_offs);
+	ipctoc->magic[0] = XSHM_IPCTOC_MAGIC1;
+	ipctoc->magic[1] = XSHM_IPCTOC_MAGIC2;
+	ipctoc->version = XSHM_VERSION;
+	ipctoc->subver = XSHM_SUBVER;
+	memset(ipctoc->channel_offsets, 0, sizeof(ipctoc->channel_offsets));
+
+	/* Find start of first channel descriptor */
+	offset += sizeof(struct xshm_ipctoc);
+
+	/*
+	 * Allocate the location for the RW Channel descriptors.
+	 * It will be located after the IPC-TOC.
+	 */
+	offset = ALIGN(offset, XSHM_ALIGNMT);
+	for (i = 0; i < xshm_channels; i++) {
+		pr_debug("Channel descriptor %d RW @ 0x%08x\n", i, offset);
+		ipctoc->channel_offsets[i].tx = cpu_to_le32(offset);
+		offset += sizeof(struct xshm_ipctoc_channel);
+		offset = ALIGN(offset, XSHM_ALIGNMT);
+		if (offset > xshm_size)
+			goto badsize;
+	}
+	ro_start = offset;
+
+	/*
+	 * Allocate the location for the RO Channel descriptors.
+	 * It will be located after the RW Channels.
+	 */
+	for (i = 0; i < xshm_channels; i++) {
+		pr_debug("Channel descriptor %d RO @ 0x%08x\n", i, offset);
+		ipctoc->channel_offsets[i].rx = cpu_to_le32(offset);
+		offset += sizeof(struct xshm_ipctoc_channel);
+		offset = ALIGN(offset, XSHM_ALIGNMT);
+		if (offset > xshm_size)
+			goto badsize;
+	}
+
+	/*
+	 * Allocate the location for the RO Buffer Indices.
+	 * It will be located after the RO Channels.
+	 */
+	offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+	ipcro_offs = offset;
+	for (i = 0; i < xshm_channels; i++) {
+		int n = xshmdevs[i]->cfg.rx.buffers;
+		ch = LEOFFS2PTR(shm_start, ipctoc->channel_offsets[i].rx);
+		add_magic_pad(&offset, shm_start);
+		ch->ipc = cpu_to_le32(offset);
+
+		bix = OFFS2PTR(shm_start, offset);
+		bix->read_index = cpu_to_le32(0);
+		bix->write_index = cpu_to_le32(0);
+		bix->state = cpu_to_le32(XSHM_CLOSED);
+		bix->size[0] = cpu_to_le32(0);
+
+		pr_debug("IPC RO[%d] @: 0x%08x\n",  i, offset);
+		offset += offsetof(struct xshm_bufidx, size[n + 2]);
+		offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+		if (offset > xshm_size)
+			goto badsize;
+	}
+
+	/*
+	 * Allocate RO Data Area. This will located after
+	 * the RO Buffer Indices at the end of the Share Memory
+	 * area.
+	 */
+	offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+	for (i = 0; i < xshm_channels; i++) {
+		u8 align;
+		u32 size;
+		ch = LEOFFS2PTR(shm_start, ipctoc->channel_offsets[i].rx);
+		add_magic_pad(&offset, shm_start);
+		ch->offset = cpu_to_le32(offset);
+
+		BUILD_BUG_ON(sizeof(ch->mode) != 1);
+		ch->mode = xshmdevs[i]->cfg.mode & XSHM_MODE_MASK;
+		ch->buffers = cpu_to_le32(xshmdevs[i]->cfg.rx.buffers);
+		align = rounddown_pow_of_two(xshmdevs[i]->cfg.rx.alignment);
+		ch->alignment =	align;
+		ch->packets = xshmdevs[i]->cfg.rx.packets;
+		ch->mtu = xshmdevs[i]->cfg.rx.mtu;
+		size = xshmdevs[i]->cfg.tx.ch_size;
+		if (xshmdevs[i]->cfg.mode & XSHM_PACKET_MODE) {
+			u32 buf_size;
+			buf_size = size / xshmdevs[i]->cfg.tx.buffers;
+			buf_size = rounddown(buf_size, align);
+			size = buf_size * xshmdevs[i]->cfg.tx.buffers;
+		}
+		pr_debug("Buffer area RO for Channel[%d] at: 0x%08x size:%d\n",
+				i, offset, size);
+		ch->size = cpu_to_le32(size);
+
+		init_data(offset, i, xshmdevs[i]->cfg.rx.ch_size);
+		offset += xshmdevs[i]->cfg.rx.ch_size;
+		offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+		if (offset > xshm_size)
+			goto badsize;
+	}
+
+	/*
+	 * Allocate RW Data Area. This will located in the beginning
+	 * just after the Modem Boot Image.
+	 */
+	offset = rw_start;
+	for (i = 0; i < xshm_channels; i++) {
+		u8 align;
+		u32 size;
+		ch = LEOFFS2PTR(shm_start, ipctoc->channel_offsets[i].tx);
+		add_magic_pad(&offset, shm_start);
+		ch->offset = cpu_to_le32(offset);
+		init_data(offset, i, xshmdevs[i]->cfg.tx.ch_size);
+		ch->mode = xshmdevs[i]->cfg.mode &
+				XSHM_MODE_MASK;
+		ch->buffers = cpu_to_le32(xshmdevs[i]->cfg.tx.buffers);
+		align = rounddown_pow_of_two(xshmdevs[i]->cfg.rx.alignment);
+		ch->alignment =	align;
+		ch->packets = xshmdevs[i]->cfg.rx.packets;
+		ch->mtu = xshmdevs[i]->cfg.rx.mtu;
+		size = xshmdevs[i]->cfg.tx.ch_size;
+		if (xshmdevs[i]->cfg.mode & XSHM_PACKET_MODE) {
+			u32 buf_size;
+			buf_size = size / xshmdevs[i]->cfg.tx.buffers;
+			buf_size = rounddown(buf_size, align);
+			size = buf_size * xshmdevs[i]->cfg.tx.buffers;
+		}
+		ch->size = cpu_to_le32(size);
+		pr_debug("Buffer area RW for Channel[%d] at: 0x%08x size:%d\n",
+				i, offset, size);
+		offset += xshmdevs[i]->cfg.tx.ch_size;
+		offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+		if (offset > ro_start)
+			goto badsize;
+	}
+
+	/*
+	 * Allocate RW IPC Area. This will located after RW data area,
+	 * just before the IPC-TOC.
+	 */
+	offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+	for (i = 0; i < xshm_channels; i++) {
+		int n = xshmdevs[i]->cfg.tx.buffers;
+		ch = LEOFFS2PTR(shm_start, ipctoc->channel_offsets[i].tx);
+		add_magic_pad(&offset, shm_start);
+		ch->ipc = cpu_to_le32(offset);
+		bix = OFFS2PTR(shm_start, offset);
+		bix->read_index = cpu_to_le32(0);
+		bix->write_index = cpu_to_le32(0);
+		bix->state = cpu_to_le32(XSHM_CLOSED);
+		bix->size[0] = cpu_to_le32(0);
+
+		pr_debug("IPC RW[%d] @: 0x%08x\n",  i, offset);
+		offset += offsetof(struct xshm_bufidx, size[n + 2]);
+		offset = ALIGN(offset, XSHM_PAYL_ALIGN);
+		if (offset > xshm_size)
+			goto badsize;
+	}
+
+	/* Allocate genio bits for each channel according to priority*/
+	bitno = 0;
+	for (pri = 0; pri < 8; pri++) {
+		for (i = 0; i < xshm_channels; i++) {
+			if (xshmdevs[i]->cfg.priority == pri) {
+				ch = LEOFFS2PTR(shm_start,
+						ipctoc->channel_offsets[i].tx);
+				ch->write_bit = cpu_to_le16(bitno * 4);
+				ch->read_bit = cpu_to_le16(bitno * 4 + 2);
+				ch = LEOFFS2PTR(shm_start,
+						ipctoc->channel_offsets[i].rx);
+				ch->write_bit = cpu_to_le16(bitno * 4 + 1);
+				ch->read_bit = cpu_to_le16(bitno * 4 + 3);
+				bitno++;
+			}
+		}
+	}
+
+	/*
+	 * The Master TOC points out the boot images for the modem,
+	 * Use the first avilable entry in the toc to write the pointer,
+	 * to the IPC-TOC defined above.
+	 */
+	found = false;
+	for (toc_entry = shm_start, i = 0; i < 16; i++, toc_entry++)
+		if (toc_entry->start == cpu_to_le32(0xffffffff)) {
+			pr_debug("IPCTOC address written into Master TOC"
+					" @ 0x%08x\n", i * 32);
+			toc_entry->start =
+				cpu_to_le32(GET_OFFSET(shm_start, ipctoc));
+			toc_entry->size = cpu_to_le32(0);
+			toc_entry->flags = cpu_to_le32(0);
+			toc_entry->entry_point = cpu_to_le32(0);
+			toc_entry->load_addr = cpu_to_le32(0xffffffff);
+			memset(toc_entry->name, 0, sizeof(toc_entry->name));
+			sprintf(toc_entry->name, "ipc-toc");
+			found = true;
+			break;
+		}
+	if (!found) {
+		pr_debug("Cannot insert IPC-TOC in toc\n");
+		goto bad_config;
+	}
+
+	store_checksum(ipctoc, ipcro_offs - ipctoc_offs);
+
+	return 0;
+
+badsize:
+	pr_debug("IPCTOC not enough space offset (size:0x%lx offset:0x%x\n",
+			xshm_size, offset);
+	return -ENOSPC;
+
+bad_config:
+	pr_debug("IPCTOC bad configuration data\n");
+	return -EINVAL;
+}
+
+static int xshm_verify_config(struct xshm_channel *xcfg)
+{
+	int j;
+
+	if ((xcfg->mode & XSHM_MODE_MASK) != XSHM_PACKET_MODE &&
+			(xcfg->mode & XSHM_MODE_MASK) != XSHM_STREAM_MODE) {
+		pr_debug("Bad config:"
+				"channel mode must be set\n");
+		return -EINVAL;
+	}
+	if (xcfg->mode & XSHM_PACKET_MODE && xcfg->rx.buffers < 2) {
+		pr_debug("Bad config:minimum 2 buffers "
+				"must be set for packet mode\n");
+		return -EINVAL;
+	}
+
+	if (xcfg->rx.ch_size < XSHM_MIN_CHSZ) {
+		pr_debug("Bad config:"
+				"Channel size must be larger than %d\n",
+				XSHM_MIN_CHSZ);
+		return -EINVAL;
+	}
+
+	if (xcfg->mode & XSHM_PACKET_MODE) {
+		if (xcfg->tx.buffers < 2) {
+			pr_debug("Bad config:"
+				"buffers must be minimum 2 packet mode\n");
+			return -EINVAL;
+		}
+		if (xcfg->tx.packets < 1) {
+			pr_debug("Bad config:"
+				"packets must be set for packet mode\n");
+			return -EINVAL;
+		}
+	}
+
+	if (xcfg->tx.ch_size < XSHM_MIN_CHSZ) {
+		pr_debug("Bad config:"
+				"Channel size must be larger than %d\n",
+				XSHM_MIN_CHSZ);
+		return -EINVAL;
+	}
+
+	if (xcfg->name[0] == '\0') {
+		pr_debug("Channel must be named\n");
+		return -EINVAL;
+	}
+	for (j = 0; j < xshm_channels; j++) {
+		struct xshm_channel *xcfg2 = &xshmdevs[j]->cfg;
+		if (xcfg != xcfg2 && strcmp(xcfg->name, xcfg2->name) == 0) {
+			pr_debug("Channels has same name:%s\n",
+					 xcfg->name);
+			return -EINVAL;
+		}
+	}
+	return 0;
+}
+
+static int verify_config(void)
+{
+	int i;
+
+	if (xshm_channels == 0) {
+		pr_debug("Bad config: minimum one channel must be defined\n");
+		return -EINVAL;
+	}
+	for (i = 0; i < xshm_channels; i++) {
+		int err = xshm_verify_config(&xshmdevs[i]->cfg);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
+/*
+ * Create Configuration data for the platform devices.
+ */
+static void create_devs(void)
+{
+	int i;
+
+	for (i = 0; i < xshm_channels; i++) {
+		struct xshm_bufidx *buf_rx, *buf_tx;
+		struct xshm_ipctoc_channel *ch_rx, *ch_tx;
+		struct xshm_channel *xcfg = &xshmdevs[i]->cfg;
+		ch_rx = LEOFFS2PTR(shm_start,
+				ipctoc->channel_offsets[i].rx);
+		buf_rx = LEOFFS2PTR(shm_start, ch_rx->ipc);
+		ch_tx = LEOFFS2PTR(shm_start,
+				ipctoc->channel_offsets[i].tx);
+		buf_tx = LEOFFS2PTR(shm_start, ch_tx->ipc);
+
+		/*
+		 * Due to restricted read-only access
+		 * we swap positions for read/write
+		 * pointers.
+		 */
+		xcfg->tx.write = &buf_tx->write_index;
+		xcfg->tx.read = &buf_rx->read_index;
+
+		xcfg->rx.write = &buf_rx->write_index;
+		xcfg->rx.read = &buf_tx->read_index;
+
+		xcfg->rx.addr = LEOFFS2PTR(shm_start, ch_rx->offset);
+		xcfg->tx.addr = LEOFFS2PTR(shm_start, ch_tx->offset);
+		xcfg->rx.state = &buf_rx->state;
+		xcfg->tx.state = &buf_tx->state;
+		xcfg->tx.buf_size = buf_tx->size;
+		xcfg->rx.buf_size = buf_rx->size;
+
+		xcfg->rx.xfer_bit = le16_to_cpu(ch_rx->write_bit);
+		xcfg->tx.xfer_bit = le16_to_cpu(ch_tx->write_bit);
+		xcfg->rx.xfer_done_bit = le16_to_cpu(ch_rx->read_bit);
+		xcfg->tx.xfer_done_bit = le16_to_cpu(ch_tx->read_bit);
+
+		if (xcfg->mode & XSHM_PAIR_MODE) {
+			struct xshm_channel *pair;
+			pr_debug("Channel[%d] is in PAIR mode\n", i);
+			if (i < 1) {
+				pr_debug("No channel to pair with\n");
+				continue;
+			}
+			/* Cross couple rx/tx on the pair */
+			pair = &xshmdevs[i - 1]->cfg;
+
+			/* Copy everything but the kobj which is at the end */
+			memcpy(&xcfg->tx, &pair->rx,
+					offsetof(struct xshm_udchannel, kobj));
+			memcpy(&xcfg->rx, &pair->tx,
+					offsetof(struct xshm_udchannel, kobj));
+		} else if (xcfg->mode & XSHM_LOOP_MODE) {
+			pr_debug("Channel[%d] is in LOOP mode\n", i);
+			/*
+			 * Connect rx/tx in a pair. Copy everything,
+			 * but the kobj which is at the end
+			 */
+			memcpy(&xcfg->tx, &xcfg->rx,
+					offsetof(struct xshm_udchannel, kobj));
+		}
+
+		pr_devel("RX[%d] wi:%p ri:%p\n", i, xcfg->rx.read,
+				xcfg->rx.write);
+		pr_devel("TX[%d] wi:%p ri:%p\n", i, xcfg->tx.read,
+				xcfg->tx.write);
+	}
+}
+
+static int do_commit(void)
+{
+	int err;
+
+	if (commited) {
+		pr_devel("already commited\n");
+		return -EINVAL;
+	}
+	err = verify_config();
+	if (err) {
+		pr_devel("bad config\n");
+		return err;
+	}
+	err = write_to_shm();
+	if (err) {
+		pr_devel("writei to SHM failed\n");
+		return err;
+	}
+	commited = true;
+	create_devs();
+	return 0;
+}
+
+static int do_register(void)
+{
+	int i, err;
+
+	if (registered) {
+		pr_devel("bad sequence of requests\n");
+		return -EINVAL;
+	}
+	err = verify_config();
+	if (err) {
+		pr_devel("bad config\n");
+		return err;
+	}
+	registered = true;
+
+	for (i = 0; i < xshm_channels; i++) {
+		if (xshmdevs[i]->cfg.mode & XSHM_PACKET_MODE)
+			xshmdevs[i]->pdev.name = "xshmp";
+		xshm_register_dev(xshmdevs[i]);
+	}
+	return 0;
+}
+
+static void do_reset(void)
+{
+	xshm_reset();
+	ready_for_ipc = false;
+	registered = false;
+	commited = false;
+	addr_set = false;
+	modem_bootimg_size = TOC_SZ;
+	xshm_channels = 0;
+}
+
+static int do_set_addr(void)
+{
+	int err;
+	if (!commited || addr_set) {
+		pr_devel("bad sequence of requests\n");
+		return -EINVAL;
+	}
+	err = verify_config();
+	if (err) {
+		pr_devel("bad config\n");
+		return err;
+	}
+	addr_set = true;
+	return genio_set_shm_addr(xshm_base_address, genio_ipc_ready_cb);
+}
+
+inline struct xshm_dev *get_dev2xshm(struct device *dev)
+{
+	struct platform_device *pdev;
+	struct xshm_dev *xshmdev;
+	pdev = container_of(dev, struct platform_device, dev);
+	xshmdev = container_of(pdev, struct xshm_dev, pdev);
+	return xshmdev;
+}
+
+void xshm_put(struct xshm_dev *xshmdev)
+{
+}
+
+inline struct xshm_dev *get_ko2xshm(struct kobject *ko)
+{
+	if (ko)
+		return get_dev2xshm(container_of(ko, struct device, kobj));
+	else
+		return NULL;
+}
+
+static int copy_name(const char *src, char *d, size_t count)
+{
+	const char *s, *end = src + count;
+	for (s = src; *s && s < end; s++, d++)
+		if (*s == '\0' || *s == '\n')
+			break;
+		else if (!isalnum(*s)) {
+			pr_debug("Illegal chr:'%c' in name:'%s'\n", *s, src);
+			return -EINVAL;
+		} else if (s - src >= XSHM_NAMESZ - 1) {
+			pr_debug("Name '%s'too long\n", src);
+			return -EINVAL;
+		} else
+			*d = *s;
+	*d = '\0';
+
+	return count;
+}
+
+static void xshmdev_release(struct device *dev)
+{
+	struct xshm_dev *xshm = get_dev2xshm(dev);
+	kfree(xshm);
+}
+
+static struct xshm_dev *xshmdev_create(int ch_id, struct device *parent, int mode)
+{
+
+	struct xshm_dev *xshmdev;
+
+	xshmdev = xshmdev_alloc();
+	if (!xshmdev)
+		return NULL;
+
+	if (mode == XSHM_PACKET_MODE)
+		xshmdev->pdev.name = "xshmp";
+	else
+		xshmdev->pdev.name = "xshms";
+	xshmdev->pdev.id = ch_id;
+	xshmdev->pdev.dev.parent = parent;
+	xshmdev->pdev.dev.release = xshmdev_release;
+	xshmdevs[ch_id] = xshmdev;
+	return xshmdev;
+}
+
+static int xshmdev_register(struct xshm_dev *xshmdev)
+{
+	int err;
+
+	err = platform_device_register(&xshmdev->pdev);
+	if (err) {
+		pr_debug("registration failed (%d)\n", err);
+		goto error;
+	}
+error:
+	return err;
+}
+
+
+/* sysfs: Read the modem firmware (actually the whole shared memory area) */
+static ssize_t modemfw_read(struct file *file, struct kobject *kobj,
+			struct bin_attribute *attr,
+			char *buf, loff_t off, size_t count)
+{
+#ifdef DEBUG
+	/* Read shm area is usefull for debug */
+	if (off > xshm_size)
+		return 0;
+	if (off + count > xshm_size)
+		count = xshm_size - off;
+	memcpy(buf, shm_start + off, count);
+	return count;
+#else
+	return -EINVAL;
+#endif
+}
+
+/* sysfs: Write the modem firmware including TOC */
+static ssize_t modemfw_write(struct file *f, struct kobject *kobj,
+			struct bin_attribute *attr,
+			char *buf, loff_t off, size_t count)
+{
+	if (commited)
+		return -EBUSY;
+
+	if (off + count > xshm_size)
+		return -ENOSPC;
+	memcpy(shm_start + off, buf, count);
+	modem_bootimg_size = off + count;
+	return count;
+}
+
+/* sysfs: Modem firmware attribute */
+static struct bin_attribute modemfw_attr = {
+	.attr = {
+		 .name = "bootimg",
+		 .mode = S_IRUGO | S_IWUSR,
+		 },
+	.size = IMG_MAX_SZ,
+	.read = modemfw_read,
+	.write = modemfw_write
+};
+
+/* sysfs: ipc_ready file */
+static ssize_t ipc_ready_show(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	return sprintf(buf, "%d\n", ready_for_ipc);
+}
+
+/* sysfs: ipc_ready file */
+static ssize_t caif_ready_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", ready_for_caif);
+}
+
+static DEVICE_ATTR(ipc_ready, S_IRUSR | S_IRUGO, ipc_ready_show, NULL);
+static DEVICE_ATTR(caif_ready, S_IRUSR | S_IRUGO, caif_ready_show, NULL);
+
+/* sysfs: notification on change of ipc_ready to user space */
+void xshm_ipc_ready(void)
+{
+	sysfs_notify(&pldev->dev.kobj, NULL, dev_attr_ipc_ready.attr.name);
+}
+
+/* sysfs: notification on change of caif_ready to user space */
+void xshm_caif_ready(void)
+{
+	sysfs_notify(&pldev->dev.kobj, NULL, dev_attr_caif_ready.attr.name);
+}
+
+/* XSHM Generic NETLINK family */
+static struct genl_family xshm_gnl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "XSHM",
+	.version = XSHM_PROTO_VERSION,
+	.maxattr = XSHM_A_MAX,
+};
+
+/* XSHM Netlink attribute policy */
+static const struct nla_policy xshm_genl_policy[XSHM_A_MAX + 1] = {
+	[XSHM_A_VERSION] = { .type = NLA_U8 },
+	[XSHM_A_SUB_VERSION] = { .type = NLA_U8 },
+	[__XSHM_A_FLAGS] = { .type = NLA_U32 },
+	[XSHM_A_NAME] = { .type = NLA_NUL_STRING, .len = XSHM_NAMESZ},
+	[XSHM_A_RX_CHANNEL] = { .type = NLA_NESTED },
+	[XSHM_A_TX_CHANNEL] = { .type = NLA_NESTED },
+	[XSHM_A_PRIORITY] = { .type = NLA_U8 },
+	[XSHM_A_LATENCY] = { .type = NLA_U8 },
+};
+
+/* Policy for uni-directional attributes for stream */
+static const struct nla_policy stream_policy[XSHM_A_MAX + 1] = {
+	[XSHM_A_CHANNEL_SIZE] = { .type = NLA_U32 },
+};
+
+/* Policy for uni-directional attributes for packet */
+static const struct nla_policy packet_policy[XSHM_A_MAX + 1] = {
+	[XSHM_A_CHANNEL_SIZE] = { .type = NLA_U32 },
+	[XSHM_A_CHANNEL_BUFFERS] = { .type = NLA_U32 },
+	[XSHM_A_MTU] = { .type = NLA_U16 },
+	[XSHM_A_ALIGNMENT] = { .type = NLA_U8 },
+};
+
+static int xshm_add_udchannel(struct xshm_udchannel *chn, int attr,
+			struct genl_info *info, struct nla_policy const *policy)
+{
+	struct nlattr *nla;
+	int nla_rem;
+
+	if (!info->attrs[attr])
+		return -EINVAL;
+
+	if (nla_validate_nested(info->attrs[attr],
+					XSHM_A_MAX,
+					policy) != 0) {
+		pr_info("Invalid RX channel attributes\n");
+		return -EINVAL;
+	}
+
+	nla_for_each_nested(nla, info->attrs[attr], nla_rem) {
+
+		if (nla_type(nla) == XSHM_A_CHANNEL_SIZE)
+			chn->ch_size = nla_get_u32(nla);
+
+		if (nla_type(nla) == XSHM_A_CHANNEL_BUFFERS)
+			chn->buffers = nla_get_u32(nla);
+
+		if (nla_type(nla) == XSHM_A_MTU)
+			chn->mtu = nla_get_u16(nla);
+
+		if (nla_type(nla) == XSHM_A_PACKETS)
+			chn->packets = nla_get_u8(nla);
+
+		if (nla_type(nla) == XSHM_A_ALIGNMENT) {
+			chn->alignment = nla_get_u8(nla);
+			chn->alignment = rounddown_pow_of_two(chn->alignment);
+		}
+
+	}
+	return 0;
+}
+
+static int xshm_add_channel(struct xshm_channel *cfg, struct genl_info *info,
+			int mode)
+{
+	int len, err;
+	struct nla_policy const *policy;
+	char name[XSHM_NAMESZ];
+
+	policy = (mode == XSHM_PACKET_MODE) ? packet_policy : stream_policy;
+
+	if (info->attrs[XSHM_A_VERSION]) {
+		u8 version;
+		u8 sub_version;
+
+		version = nla_get_u8(info->attrs[XSHM_A_VERSION]);
+		if (!info->attrs[XSHM_A_SUB_VERSION])
+			return -EINVAL;
+		sub_version = nla_get_u8(info->attrs[XSHM_A_SUB_VERSION]);
+		if (version != 1 || sub_version != 0) {
+			pr_info("Bad version or sub_version\n");
+			return -EINVAL;
+		}
+	}
+
+	if (!info->attrs[XSHM_A_NAME]) {
+		pr_debug("Name not specified\n");
+		return -EINVAL;
+	}
+
+	len = nla_strlcpy(name, info->attrs[XSHM_A_NAME],
+			XSHM_NAMESZ);
+
+	if (len > XSHM_NAMESZ)
+		return -EINVAL;
+
+	err = copy_name(name, cfg->name, sizeof(name));
+	if (err < 0)
+		return err;
+
+	cfg->excl_group = 1;
+	if (info->attrs[XSHM_A_EXCL_GROUP])
+		cfg->excl_group = nla_get_u8(info->attrs[XSHM_A_EXCL_GROUP]);
+
+	err = xshm_add_udchannel(&cfg->rx, XSHM_A_RX_CHANNEL, info, policy);
+
+	if (err)
+		return err;
+	err = xshm_add_udchannel(&cfg->tx, XSHM_A_TX_CHANNEL, info, policy);
+
+	if (err)
+		return err;
+
+	if (info->attrs[XSHM_A_PRIORITY]) {
+		cfg->priority = nla_get_u8(info->attrs[XSHM_A_PRIORITY]);
+		/* silently fixup bad value */
+		if (cfg->priority > 7)
+			cfg->priority = 0;
+	}
+
+	if (info->attrs[XSHM_A_LATENCY])
+		cfg->latency = nla_get_u8(info->attrs[XSHM_A_LATENCY]);
+
+	if (info->attrs[__XSHM_A_FLAGS])
+		cfg->mode |= nla_get_u32(info->attrs[__XSHM_A_FLAGS]);
+
+
+	return 0;
+}
+
+static int do_reply(struct genl_info *info, int result)
+{
+	struct sk_buff *msg;
+	int err;
+	void *reply;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (msg == NULL)
+		return -ENOMEM;
+
+	reply = genlmsg_put_reply(msg, info, &xshm_gnl_family, 0, result);
+	if (reply == NULL) {
+		kfree_skb(msg);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(msg, reply);
+	err = genlmsg_reply(msg, info);
+	return err;
+}
+
+static int xshm_add_ch(struct sk_buff *skb, struct genl_info *info, int mode)
+{
+	int err;
+	struct xshm_channel cfg;
+	struct xshm_dev *xshmdev;
+
+	if (xshm_channels + 1 > XSHM_MAX_CHANNELS) {
+		pr_debug("Too many channels added\n");
+		return -EINVAL;
+	}
+
+	memset(&cfg, 0, sizeof(cfg));
+	cfg.mode = mode;
+	err = xshm_add_channel(&cfg, info, mode);
+	if (err)
+		return err;
+	xshmdev = xshmdev_create(xshm_channels, &pldev->dev, mode);
+	if (xshmdev == NULL)
+		return -ENOMEM;
+	xshmdevs[xshm_channels] = xshmdev;
+	xshmdevs[xshm_channels]->cfg = cfg;
+
+	++xshm_channels;
+
+	err = xshm_verify_config(&xshmdev->cfg);
+	if (err)
+		goto error;
+	err = xshmdev_register(xshmdev);
+	if (err)
+		goto error;
+	err = do_reply(info, 0);
+	if (err)
+		goto error;
+	return err;
+
+error:
+	--xshm_channels;
+	xshmdev_free(xshmdev);
+	return err;
+}
+
+static int xshm_add_packet_ch(struct sk_buff *skb, struct genl_info *info)
+{
+	return xshm_add_ch(skb, info, XSHM_PACKET_MODE);
+}
+
+static int xshm_add_stream_ch(struct sk_buff *skb, struct genl_info *info)
+{
+	return xshm_add_ch(skb, info, XSHM_STREAM_MODE);
+}
+
+
+static int xshm_c_commit(struct sk_buff *skb, struct genl_info *info)
+{
+	int err = do_commit();
+	if (!err)
+		do_reply(info, 0);
+	return err;
+}
+
+static int xshm_c_register(struct sk_buff *skb, struct genl_info *info)
+{
+	int err = do_register();
+	if (!err)
+		do_reply(info, 0);
+	return err;
+}
+
+static int xshm_c_set_addr(struct sk_buff *skb, struct genl_info *info)
+{
+	int err = do_set_addr();
+	if (!err)
+		do_reply(info, 0);
+	return err;
+}
+
+static int xshm_c_reset(struct sk_buff *skb, struct genl_info *info)
+{
+	do_reset();
+	do_reply(info, 0);
+	return 0;
+}
+
+static struct genl_ops xshm_genl_ops[] = {
+	{
+	.cmd = XSHM_C_ADD_STREAM_CHANNEL,
+	.flags = GENL_ADMIN_PERM,
+	.policy = xshm_genl_policy,
+	.doit = xshm_add_stream_ch,
+	.dumpit = NULL,
+	},
+	{
+	.cmd = XSHM_C_ADD_PACKET_CHANNEL,
+	.flags = GENL_ADMIN_PERM,
+	.policy = xshm_genl_policy,
+	.doit = xshm_add_packet_ch,
+	.dumpit = NULL,
+	},
+	{
+	.cmd = XSHM_C_COMMIT,
+	.flags = GENL_ADMIN_PERM,
+	.doit = xshm_c_commit,
+	.dumpit = NULL,
+	},
+	{
+	.cmd = XSHM_C_REGISTER,
+	.flags = GENL_ADMIN_PERM,
+	.doit = xshm_c_register,
+	.dumpit = NULL,
+	},
+	{
+	.cmd = XSHM_C_SET_ADDR,
+	.flags = GENL_ADMIN_PERM,
+	.doit = xshm_c_set_addr,
+	.dumpit = NULL,
+	},
+	{
+	.cmd = XSHM_C_RESET,
+	.flags = GENL_ADMIN_PERM,
+	.doit = xshm_c_reset,
+	.dumpit = NULL,
+	},
+
+};
+
+static bool gennetl_reg;
+
+/* Initialize boot handling and create sysfs entries*/
+int xshm_boot_init(void)
+{
+	int err = -EINVAL;
+	bool xshm_fake = false;
+
+	/* Negative xshm_size indicates module test without real SHM */
+	if (xshm_size < 0) {
+		xshm_fake = true;
+		xshm_size = abs(xshm_size);
+	}
+
+	if (xshm_size < TOC_SZ)
+		goto bad_config;
+
+	if (xshm_fake) {
+		shm_start = kzalloc(xshm_size, GFP_KERNEL);
+		err = -ENOMEM;
+		if (!shm_start)
+			goto error;
+		xshm_base_address = (unsigned long) shm_start;
+		memset(shm_start, 0xaa, xshm_size);
+	} else {
+		if (xshm_base_address == 0)
+			goto bad_config;
+		shm_start = ioremap(xshm_base_address, xshm_size);
+	}
+
+	/* Initiate the Master TOC to 0xff for the first 512 bytes */
+	if (xshm_size > TOC_SZ)
+		memset(shm_start, 0xff, TOC_SZ);
+
+	modem_bootimg_size = TOC_SZ;
+
+	pr_debug("Boot image addr: %p size:%d\n", shm_start,
+			modem_bootimg_size);
+
+	pldev = platform_device_register_simple("xshm", -1, NULL, 0);
+
+	err = device_create_bin_file(&pldev->dev, &modemfw_attr);
+	if (err)
+		goto error;
+	err = device_create_file(&pldev->dev, &dev_attr_ipc_ready);
+	if (err)
+		goto error;
+	err = device_create_file(&pldev->dev, &dev_attr_caif_ready);
+	if (err)
+		goto error;
+
+	err = genl_register_family_with_ops(&xshm_gnl_family,
+		xshm_genl_ops, ARRAY_SIZE(xshm_genl_ops));
+	if (err)
+		goto error;
+
+	gennetl_reg = 1;
+	return err;
+error:
+	pr_debug("initialization failed\n");
+	platform_device_unregister(pldev);
+	return err;
+bad_config:
+	pr_err("Bad module configuration:"
+			" xshm_base_address:%lu xshm_size:%lu err:%d\n",
+			xshm_base_address, xshm_size, err);
+	/* Buildin module should not return error */
+	return -EINVAL;
+}
+
+void xshm_boot_exit(void)
+{
+	platform_device_unregister(pldev);
+	if (gennetl_reg)
+		genl_unregister_family(&xshm_gnl_family);
+	gennetl_reg = 0;
+}
diff --git a/drivers/xshm/xshm_pdev.c b/drivers/xshm/xshm_pdev.c
new file mode 100644
index 0000000..fd26585
--- /dev/null
+++ b/drivers/xshm/xshm_pdev.c
@@ -0,0 +1,459 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2010
+ * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <linux/platform_device.h>
+#include <linux/xshm/genio.h>
+#include <linux/xshm/xshm_ipctoc.h>
+#include <linux/xshm/xshm_pdev.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sjur Brændland <sjur.brandeland@stericsson.com>");
+MODULE_DESCRIPTION("External Shared Memory - Supporting direct boot and IPC");
+MODULE_VERSION("XSHM 0.5 : " __DATE__);
+
+static int xshm_inactivity_timeout = 1000;
+module_param(xshm_inactivity_timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(xshm_inactivity_timeout, "Inactivity timeout, ms.");
+
+bool ready_for_ipc;
+bool ready_for_caif;
+static spinlock_t list_lock;
+static LIST_HEAD(pdev_list);
+static spinlock_t timer_lock;
+static int inactivity_timeout;
+static struct timer_list inactivity_timer;
+static bool power_on;
+
+#define xdev_dbg(dev, fmt, arg...) printk(KERN_DEBUG "%s%d: %s - " fmt, \
+			dev->pdev.name, dev->pdev.id, __func__, ##arg)
+#define xdev_devl(dev, fmt, arg...) printk(KERN_DEBUG "%s%d: %s - " fmt, \
+			dev->pdev.name, dev->pdev.id, __func__, ##arg)
+#define pr_xshmstate(dev,str) printk(KERN_DEBUG "xshm%d: %s state: %s\n", \
+			dev->pdev.id, str,			\
+			dev->state == XSHM_DEV_OPEN ? "open" : "close")
+
+static void inactivity_tout(unsigned long arg)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&timer_lock, flags);
+	/*
+	 * This is paranoia, but if timer is reactivated
+	 * before this tout function is scheduled,
+	 * we just ignore this timeout.
+	 */
+	if (timer_pending(&inactivity_timer))
+		goto out;
+
+	if (power_on) {
+		pr_devel("genio power req(off)\n");
+		genio_power_req(false);
+		power_on = false;
+	}
+out:
+	spin_unlock_irqrestore(&timer_lock, flags);
+}
+
+static void activity(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&timer_lock, flags);
+	if (!power_on) {
+		pr_devel("genio power req(on)\n");
+		genio_power_req(true);
+		power_on = true;
+	}
+	mod_timer(&inactivity_timer,
+			jiffies + inactivity_timeout);
+	spin_unlock_irqrestore(&timer_lock, flags);
+}
+
+static void reset_activity_tout(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&timer_lock, flags);
+	if (power_on) {
+		genio_power_req(false);
+		power_on = false;
+	}
+	del_timer_sync(&inactivity_timer);
+	spin_unlock_irqrestore(&timer_lock, flags);
+}
+
+static int xshmdev_ipc_tx(struct xshm_dev *dev)
+{
+	xdev_devl(dev, "call genio_set_bit(%d)\n", dev->cfg.tx.xfer_bit);
+	activity();
+	return genio_set_bit(dev->cfg.tx.xfer_bit);
+}
+
+static int xshmdev_ipc_rx_release(struct xshm_dev *dev, bool more)
+{
+	xdev_devl(dev, "call genio_set_bit(%d)\n", dev->cfg.tx.xfer_bit);
+	activity();
+	return genio_set_bit(dev->cfg.rx.xfer_done_bit);
+}
+
+static int do_open(struct xshm_dev *dev)
+{
+	int err;
+
+	err = dev->open_cb(dev->driver_data);
+	if (err < 0) {
+		xdev_dbg(dev, "Error - open_cb failed\n");
+
+		/* Make sure ring-buffer is empty i RX and TX direction */
+		*dev->cfg.rx.read = *dev->cfg.rx.write;
+		*dev->cfg.tx.write = *dev->cfg.tx.read;
+		*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+		xdev_devl(dev, "set state = XSHM_DEV_CLOSED\n");
+		dev->state = XSHM_DEV_CLOSED;
+		return err;
+	}
+
+	/* Check is we already have any data in the pipe */
+	if (*dev->cfg.rx.write != *dev->cfg.rx.read) {
+		pr_devel("Received data during opening\n");
+		dev->ipc_rx_cb(dev->driver_data);
+	}
+
+	return err;
+}
+
+static void genio_rx_cb(void *data)
+{
+	struct xshm_dev *dev = data;
+
+	if (likely(dev->state == XSHM_DEV_OPEN)) {
+		if (unlikely(!ready_for_ipc)) {
+			xdev_devl(dev, "ready_for_ipc is not yet set\n");
+			return;
+		}
+
+		if (dev->ipc_rx_cb) {
+			int err = dev->ipc_rx_cb(dev->driver_data);
+			if (unlikely(err < 0))
+				goto remote_close;
+		}
+
+	} else if (*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN)) {
+		pr_xshmstate(dev, "");
+		dev->state = XSHM_DEV_OPEN;
+		if (!ready_for_ipc) {
+			xdev_devl(dev, "ready_for_ipc is not yet set\n");
+			return;
+		}
+		if (do_open(dev) < 0)
+			goto open_fail;
+	}
+	return;
+open_fail:
+	pr_xshmstate(dev, "exit open failed");
+	/* Make sure ring-buffer is empty i RX and TX direction */
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.write = *dev->cfg.tx.read;
+remote_close:
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+	dev->state = XSHM_DEV_CLOSED;
+	dev->close_cb(dev->driver_data);
+}
+
+static void genio_tx_release_cb(void *data)
+{
+	struct xshm_dev *dev = data;
+
+	if (!ready_for_ipc) {
+		xdev_devl(dev, "not ready_for_ipc\n");
+		return;
+	}
+	if (dev->ipc_tx_release_cb)
+		dev->ipc_tx_release_cb(dev->driver_data);
+}
+
+static int xshmdev_open(struct xshm_dev *dev)
+{
+	int err = -EINVAL;
+	struct list_head *node;
+	struct list_head *n;
+
+	if (WARN_ON(dev->ipc_rx_cb == NULL) ||
+			WARN_ON(dev->ipc_tx_release_cb == NULL) ||
+			WARN_ON(dev->open_cb == NULL) ||
+			WARN_ON(dev->close_cb == NULL))
+		goto err;
+
+	list_for_each_safe(node, n, &pdev_list) {
+		struct xshm_dev *dev2;
+		dev2 = list_entry(node, struct xshm_dev, node);
+		if (dev2 == dev)
+			continue;
+
+		if (dev2->state == XSHM_DEV_OPEN &&
+				dev2->cfg.excl_group != dev->cfg.excl_group) {
+			xdev_dbg(dev, "Exclusive group "
+					"prohibits device open\n");
+			err = -EPERM;
+			goto err;
+		}
+	}
+	pr_devel("call genio_subscribe(%d)\n", dev->cfg.rx.xfer_bit);
+	err = genio_subscribe(dev->cfg.rx.xfer_bit, genio_rx_cb, dev);
+	if (err)
+		goto err;
+
+	pr_devel("call genio_subscribe(%d)\n", dev->cfg.tx.xfer_done_bit);
+	err = genio_subscribe(dev->cfg.tx.xfer_done_bit,
+			genio_tx_release_cb, dev);
+	if (err)
+		goto err;
+
+	/* Indicate that our side is open and ready for action */
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.write = *dev->cfg.tx.read;
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_OPEN);
+
+	if (ready_for_ipc)
+		err = xshmdev_ipc_tx(dev);
+
+	if (err < 0) {
+		xdev_dbg(dev, "can't update geno\n");
+		goto err;
+	}
+	/* If other side is ready as well we're ready to role */
+	if (*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN) && ready_for_ipc) {
+		if (do_open(dev) < 0)
+			goto err;
+		dev->state = XSHM_DEV_OPEN;
+	}
+
+	return 0;
+err:
+	pr_xshmstate(dev, "exit error");
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.write = *dev->cfg.tx.read;
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+	return err;
+}
+
+static void xshmdev_close(struct xshm_dev *dev)
+{
+
+	dev->state = XSHM_DEV_CLOSED;
+	*dev->cfg.rx.read = *dev->cfg.rx.write;
+	*dev->cfg.tx.state = cpu_to_le32(XSHM_CLOSED);
+	xshmdev_ipc_tx(dev);
+	if (dev->close_cb)
+		dev->close_cb(dev->driver_data);
+
+	pr_devel("call genio_unsubscribe(%d)\n", dev->cfg.rx.xfer_bit);
+	genio_unsubscribe(dev->cfg.rx.xfer_bit);
+	pr_devel("call genio_unsubscribe(%d)\n", dev->cfg.tx.xfer_done_bit);
+	genio_unsubscribe(dev->cfg.tx.xfer_done_bit);
+}
+
+struct xshm_dev *xshmdev_alloc(void)
+{
+	struct xshm_dev *xshmdev = kzalloc(sizeof(*xshmdev), GFP_KERNEL);
+	unsigned long flags;
+	if (xshmdev) {
+		spin_lock_irqsave(&list_lock, flags);
+		list_add_tail(&xshmdev->node, &pdev_list);
+		spin_unlock_irqrestore(&list_lock, flags);
+	}
+	return xshmdev;
+}
+
+void xshmdev_free(struct xshm_dev *xshmdev)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&list_lock, flags);
+	list_del(&xshmdev->node);
+	spin_unlock_irqrestore(&list_lock, flags);
+	kfree(xshmdev);
+}
+
+int xshm_register_dev(struct xshm_dev *dev)
+{
+	int err;
+	dev->state = XSHM_DEV_CLOSED;
+	dev->open = xshmdev_open;
+	dev->close = xshmdev_close;
+	dev->ipc_rx_release = xshmdev_ipc_rx_release;
+	dev->ipc_tx = xshmdev_ipc_tx;
+	/* Driver should only use this when platform_data is set */
+	dev->pdev.dev.platform_data = dev;
+	xdev_devl(dev, "re-register SHM platform device %s\n", dev->pdev.name);
+	err = device_reprobe(&dev->pdev.dev);
+
+	if (err) {
+		xdev_dbg(dev, "registration failed (%d)\n", err);
+		goto clean;
+	}
+	return err;
+clean:
+	kfree(dev);
+	return err;
+}
+
+static void genio_caif_ready_cb(bool ready)
+{
+
+	/* Set global variable ready_for_caif true */
+	if (ready_for_caif != ready) {
+		ready_for_caif = ready;
+		xshm_caif_ready();
+	}
+}
+
+static void genio_errhandler(int errno)
+{
+	/* Fake CAIF_READY low to trigger modem restart */
+	pr_warn("Driver reported error:%d\n", errno);
+	ready_for_caif = 0;
+	xshm_caif_ready();
+}
+
+void genio_ipc_ready_cb(void)
+{
+	struct xshm_dev *dev, *tmp;
+	unsigned long flags;
+	int err;
+	u32 getter = 0;
+	u32 setter = 0;
+
+	/* Set global variable ready_for_ipc true */
+	ready_for_ipc = true;
+	xshm_ipc_ready();
+
+	genio_register_errhandler(genio_errhandler);
+
+	pr_devel("call genio_subscribe_caif_ready()\n");
+	err = genio_subscribe_caif_ready(genio_caif_ready_cb);
+	if (err < 0)
+		pr_debug("genio_subscribe_caif_ready failed:%d\n", err);
+
+	/* Take a refcount to the device so it doesn't go away */
+	spin_lock_irqsave(&list_lock, flags);
+	list_for_each_entry_safe(dev, tmp, &pdev_list, node)
+		get_device(&dev->pdev.dev);
+	spin_unlock_irqrestore(&list_lock, flags);
+
+	/* Collect the bit-mask for GENIO bits */
+	list_for_each_entry_safe(dev, tmp, &pdev_list, node) {
+		setter |= 1 << dev->cfg.tx.xfer_bit;
+		setter |= 1 << dev->cfg.rx.xfer_done_bit;
+		getter |= 1 << dev->cfg.rx.xfer_bit;
+		getter |= 1 << dev->cfg.tx.xfer_done_bit;
+	}
+	pr_devel("call genio_bit_alloc(%x,%x)\n", setter, getter);
+	err = genio_bit_alloc(setter, getter);
+	if (err < 0)
+		pr_debug("genio_bit_alloc failed:%d\n", err);
+
+	list_for_each_entry_safe(dev, tmp, &pdev_list, node) {
+		if (dev->cfg.rx.state != NULL && dev->cfg.tx.state != NULL &&
+				*dev->cfg.rx.state == cpu_to_le32(XSHM_OPEN) &&
+				*dev->cfg.tx.state == cpu_to_le32(XSHM_OPEN)) {
+			dev->state = XSHM_DEV_OPEN;
+			do_open(dev);
+		}
+		put_device(&dev->pdev.dev);
+	}
+}
+
+static int __init xshm_init(void)
+{
+	int err;
+
+	pr_devel("Initializing\n");
+
+	/* Pre-calculate inactivity timeout. */
+	if (xshm_inactivity_timeout != -1) {
+		inactivity_timeout =
+				xshm_inactivity_timeout * HZ / 1000;
+		if (inactivity_timeout == 0)
+			inactivity_timeout = 1;
+		else if (inactivity_timeout > NEXT_TIMER_MAX_DELTA)
+			inactivity_timeout = NEXT_TIMER_MAX_DELTA;
+	} else
+		inactivity_timeout = NEXT_TIMER_MAX_DELTA;
+
+	spin_lock_init(&list_lock);
+	INIT_LIST_HEAD(&pdev_list);
+
+	spin_lock_init(&timer_lock);
+	init_timer(&inactivity_timer);
+	inactivity_timer.data = 0L;
+	inactivity_timer.function = inactivity_tout;
+
+	pr_devel("call genio_init()\n");
+	genio_init();
+
+	err = xshm_boot_init();
+	if (err)
+		goto err;
+
+	return err;
+err:
+	pr_devel("call genio_exit()\n");
+	genio_exit();
+	return err;
+}
+
+void close_devices(void)
+{
+	struct xshm_dev *dev, *tmp;
+
+	list_for_each_entry_safe(dev, tmp, &pdev_list, node)
+		if (dev->close_cb)
+			dev->close_cb(dev->driver_data);
+}
+
+void xshm_reset(void)
+{
+	struct xshm_dev *dev, *tmp;
+	unsigned long flags;
+
+	list_for_each_entry_safe(dev, tmp, &pdev_list, node) {
+		get_device(&dev->pdev.dev);
+		if (dev->close_cb)
+			dev->close_cb(dev->driver_data);
+		platform_device_unregister(&dev->pdev);
+		spin_lock_irqsave(&list_lock, flags);
+		dev->pdev.dev.platform_data = NULL;
+		spin_unlock_irqrestore(&list_lock, flags);
+		xshm_put(dev);
+	}
+
+	spin_lock_irqsave(&list_lock, flags);
+	list_for_each_entry_safe(dev, tmp, &pdev_list, node) {
+		list_del(&dev->node);
+		put_device(&dev->pdev.dev);
+	}
+	spin_unlock_irqrestore(&list_lock, flags);
+	reset_activity_tout();
+	genio_reset();
+}
+
+static void __exit xshm_exit(void)
+{
+	xshm_reset();
+	genio_unsubscribe(READY_FOR_IPC_BIT);
+	genio_unsubscribe(READY_FOR_CAIF_BIT);
+	xshm_boot_exit();
+	genio_exit();
+}
+
+module_init(xshm_init);
+module_exit(xshm_exit);
-- 
1.7.1


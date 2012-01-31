Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2AaI5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:57:32 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:58324 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab2AaI5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:57:30 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jan 2012 03:57:29 EST
From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [RESEND PATCHv5 11/11] caif_shm: Add CAIF driver for Shared memory for M7400
Date: Tue, 31 Jan 2012 09:48:46 +0100
Message-Id: <1327999726-8774-12-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1327999726-8774-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a caif shared memory link layer driver for ST-Ericsson's Thor M7400
LTE modem.

M7400 uses a ring-buffer in shared memory for transporting data from the modem.
Each ring-buffer element contains an array of caif frames. caif_shm calls
napi_schedule() when receiving notification about incoming data.
The napi-poll function copies data from the ring-buffer to SKBs until
ring-buffer is empty, or quota is exceeded.

If transmit ring-buffer is full, it also uses napi for scheduling transmission
of queued transmit buffer.

cc: David S. Miller <davem@davemloft.net>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/net/caif/Kconfig    |   12 +-
 drivers/net/caif/Makefile   |    3 +-
 drivers/net/caif/caif_shm.c |  900 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 913 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/caif/caif_shm.c

diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
index abf4d7a..5a8912b 100644
--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -32,7 +32,7 @@ config CAIF_SPI_SYNC
 	help to synchronize to the next transfer in case of over or under-runs.
 	This option also needs to be enabled on the modem.
 
-config CAIF_SHM
+config CAIF_SHM_MBX
 	tristate "CAIF shared memory protocol driver"
 	depends on CAIF && U5500_MBOX
 	default n
@@ -47,3 +47,13 @@ config CAIF_HSI
        The caif low level driver for CAIF over HSI.
        Be aware that if you enable this then you also need to
        enable a low-level HSI driver.
+
+config CAIF_SHM
+	tristate "CAIF shared memory protocol driver"
+	depends on MODEM_SHM_BUS && CAIF
+	default n
+	---help---
+	Say "Y" if you want to support CAIF over Modem Shared Memory
+	IPC mechanism (e.g. over Chip to Chip). Only say M here if you want to
+	test CAIF over SHM and need to load and unload its module.
+	If unsure say N.
diff --git a/drivers/net/caif/Makefile b/drivers/net/caif/Makefile
index 91dff86..2837c56 100644
--- a/drivers/net/caif/Makefile
+++ b/drivers/net/caif/Makefile
@@ -8,7 +8,8 @@ cfspi_slave-objs := caif_spi.o caif_spi_slave.o
 obj-$(CONFIG_CAIF_SPI_SLAVE) += cfspi_slave.o
 
 # Shared memory
-caif_shm-objs := caif_shmcore.o caif_shm_u5500.o
+caif_shmmbx-objs := caif_shmcore.o caif_shm_u5500.o
+obj-$(CONFIG_CAIF_SHM_MBX) += caif_shmmbx.o
 obj-$(CONFIG_CAIF_SHM) += caif_shm.o
 
 # HSI interface
diff --git a/drivers/net/caif/caif_shm.c b/drivers/net/caif/caif_shm.c
new file mode 100644
index 0000000..f6ce486
--- /dev/null
+++ b/drivers/net/caif/caif_shm.c
@@ -0,0 +1,900 @@
+/*
+ * Copyright (C) ST-Ericsson AB 2011
+ * Contact: Sjur Brændeland / sjur.brandeland@stericsson.com
+ * Authors: Sjur Brændeland / sjur.brandeland@stericsson.com
+ *	   Daniel Martensson / daniel.martensson@stericsson.com
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ":" fmt
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/netdevice.h>
+#include <linux/if_arp.h>
+#include <linux/modem_shm/shm_dev.h>
+#include <net/rtnetlink.h>
+#include <net/caif/caif_device.h>
+#include <net/caif/caif_layer.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Daniel Martensson <daniel.martensson@stericsson.com>");
+MODULE_AUTHOR("Sjur Brændeland <sjur.brandeland@stericsson.com>");
+MODULE_DESCRIPTION("CAIF SHM driver");
+
+#define CONNECT_TIMEOUT (3 * HZ)
+#define CAIF_NEEDED_HEADROOM	32
+#define CAIF_FLOW_ON		1
+#define CAIF_FLOW_OFF		0
+
+#define LOW_XOFF_WATERMARK	50
+#define HIGH_XOFF_WATERMARK	70
+#define STUFF_MARK		30
+
+struct ringbuf {
+	__le32	*rip;
+	__le32	*wip;
+	u32	size;
+	__le32	*bufsize;
+};
+
+struct shm_pck_desc {
+	/* Offset from start of channel to CAIF frame. */
+	u32 offset;
+	u32 length;
+} __packed;
+
+struct shm_caif_frm {
+	/* Number of bytes of padding before the CAIF frame. */
+	u8 hdr_ofs;
+} __packed;
+
+#define SHM_HDR_LEN sizeof(struct shm_caif_frm)
+
+struct shmbuffer {
+/* Static part: */
+	u8 *addr;
+	u32 index;
+	u32 len;
+/* Dynamic part: */
+	u32 frames;
+	/* Offset from start of buffer to CAIF frame. */
+	u32 frm_ofs;
+};
+
+enum CFSHM_STATE {
+	CFSHM_CLOSED = 1,
+	CFSHM_OPENING,
+	CFSHM_OPEN
+};
+
+struct cfshm {
+	/* caif_dev_common must always be first in the structure*/
+	struct caif_dev_common cfdev;
+	struct shm_dev *shm;
+	struct napi_struct napi;
+	struct ringbuf tx;
+	struct sk_buff_head sk_qhead;
+	spinlock_t lock;
+	struct ringbuf rx;
+	u8 *rx_ringbuf;
+	u32 rx_frms_pr_buf;
+	u32 rx_alignment;
+	struct shmbuffer **rx_bufs;
+	struct net_device *ndev;
+
+	u32 tx_frms_pr_buf;
+	u32 tx_alignment;
+	struct shmbuffer **tx_bufs;
+	u8 *tx_ringbuf;
+	u32 tx_flow_on;
+	u32 high_xoff_water;
+	u32 low_xoff_water;
+	u32 stuff_mark;
+	atomic_t dbg_smp_rxactive;
+	enum CFSHM_STATE state;
+	wait_queue_head_t netmgmt_wq;
+};
+
+static unsigned int ringbuf_used(struct ringbuf *rb)
+{
+	if (le32_to_cpu(*rb->wip) >= le32_to_cpu(*rb->rip))
+		return le32_to_cpu(*rb->wip) - le32_to_cpu(*rb->rip);
+	else
+		return rb->size - le32_to_cpu(*rb->rip) + le32_to_cpu(*rb->wip);
+}
+
+static int ringbuf_get_writepos(struct ringbuf *rb)
+{
+	if ((le32_to_cpu(*rb->wip) + 1) % rb->size == le32_to_cpu(*rb->rip))
+		return -1;
+	else
+		return le32_to_cpu(*rb->wip);
+}
+
+static int ringbuf_get_readpos(struct ringbuf *rb)
+{
+
+	if (le32_to_cpu(*rb->wip) == le32_to_cpu(*rb->rip))
+		return -1;
+	else
+		return le32_to_cpu(*rb->rip);
+}
+
+static int ringbuf_upd_writeptr(struct ringbuf *rb)
+{
+	if (!WARN_ON((le32_to_cpu(*rb->wip) + 1) % rb->size ==
+					le32_to_cpu(*rb->rip))) {
+
+		*rb->wip = cpu_to_le32((le32_to_cpu(*rb->wip) + 1) % rb->size);
+		/* Do write barrier before updating index */
+		smp_wmb();
+	}
+	return le32_to_cpu(*rb->wip);
+}
+
+static void ringbuf_upd_readptr(struct ringbuf *rb)
+{
+	if (!WARN_ON(le32_to_cpu(*rb->wip) == le32_to_cpu(*rb->rip))) {
+		*rb->rip = cpu_to_le32((le32_to_cpu(*rb->rip) + 1) % rb->size);
+		/* Do write barrier before updating index */
+		smp_wmb();
+	}
+}
+
+
+
+static struct shmbuffer *get_rx_buf(struct cfshm *cfshm)
+{
+	struct shmbuffer *pbuf = NULL;
+	int idx = ringbuf_get_readpos(&cfshm->rx);
+
+	if (idx < 0)
+		goto out;
+	pbuf = cfshm->rx_bufs[idx];
+out:
+	return pbuf;
+}
+
+static struct shmbuffer *new_rx_buf(struct cfshm *cfshm)
+{
+	struct shmbuffer *pbuf = get_rx_buf(cfshm);
+
+	WARN_ON(!spin_is_locked(&cfshm->lock));
+	if (pbuf)
+		pbuf->frames = 0;
+
+	return pbuf;
+}
+
+static struct shmbuffer *get_tx_buf(struct cfshm *cfshm)
+{
+	int idx = ringbuf_get_writepos(&cfshm->tx);
+
+	if (idx < 0)
+		return NULL;
+	return cfshm->tx_bufs[idx];
+}
+
+inline struct shmbuffer *tx_bump_buf(struct cfshm *cfshm,
+			struct shmbuffer *pbuf)
+{
+	u32 desc_size;
+	struct shmbuffer *newpbuf = pbuf;
+
+	WARN_ON(!spin_is_locked(&cfshm->lock));
+	if (pbuf) {
+		cfshm->shm->cfg.tx.buf_size[pbuf->index] =
+			cpu_to_le32(pbuf->frm_ofs);
+		ringbuf_upd_writeptr(&cfshm->tx);
+		newpbuf = get_tx_buf(cfshm);
+		/* Reset buffer parameters. */
+		desc_size = (cfshm->tx_frms_pr_buf + 1) *
+			sizeof(struct shm_pck_desc);
+		pbuf->frm_ofs = desc_size + (desc_size % cfshm->rx_alignment);
+		pbuf->frames = 0;
+
+	}
+	return newpbuf;
+}
+
+static struct shmbuffer *shm_rx_func(struct cfshm *cfshm, int quota)
+{
+	struct shmbuffer *pbuf;
+	struct sk_buff *skb;
+	int ret;
+	unsigned long flags;
+
+	pbuf = get_rx_buf(cfshm);
+	while (pbuf) {
+		/* Retrieve pointer to start of the packet descriptor area. */
+		struct shm_pck_desc *pck_desc =
+			((struct shm_pck_desc *) pbuf->addr) + pbuf->frames;
+		u32 offset;
+
+		/* Loop until descriptor contains zero offset */
+		while ((offset = pck_desc->offset)) {
+			unsigned int caif_len;
+			struct shm_caif_frm *frm;
+			u32 length = pck_desc->length;
+			u8 hdr_ofs;
+			frm = (struct shm_caif_frm *)(pbuf->addr + offset);
+			hdr_ofs = frm->hdr_ofs;
+			caif_len =
+				length - SHM_HDR_LEN -
+				hdr_ofs;
+
+			pr_devel("copy data buf:%d frm:%d offs:%d @%x len:%d\n",
+					pbuf->index, pbuf->frames, offset,
+					(u32) (SHM_HDR_LEN + hdr_ofs + offset +
+						pbuf->addr - cfshm->rx_ringbuf),
+					length);
+
+			/* Check whether number of frames is below limit */
+			if (pbuf->frames > cfshm->rx_frms_pr_buf) {
+				pr_warn("Too many frames in buffer.\n");
+				++cfshm->ndev->stats.rx_frame_errors;
+				goto desc_err;
+			}
+
+			/* Check whether offset is below low limits */
+			if (pbuf->addr + offset
+					<= (u8 *)(pck_desc + 1)) {
+				pr_warn("Offset in desc. below buffer area.\n");
+				++cfshm->ndev->stats.rx_frame_errors;
+				goto desc_err;
+			}
+
+			/* Check whether offset above upper limit */
+			if (offset + length > pbuf->len) {
+				pr_warn("Offset outside buffer area:\n");
+				++cfshm->ndev->stats.rx_frame_errors;
+				goto desc_err;
+			}
+
+			skb = netdev_alloc_skb(cfshm->ndev,
+							caif_len + 1);
+			if (skb == NULL) {
+				pr_debug("Couldn't allocate SKB\n");
+				++cfshm->ndev->stats.rx_dropped;
+				goto out;
+			}
+
+			memcpy(skb_put(skb, caif_len),
+					SHM_HDR_LEN + hdr_ofs +
+					offset + pbuf->addr,
+					caif_len);
+
+			skb->protocol = htons(ETH_P_CAIF);
+			skb_reset_mac_header(skb);
+			skb->dev = cfshm->ndev;
+
+			/* Push received packet up the stack. */
+			ret = netif_receive_skb(skb);
+
+			if (!ret) {
+				cfshm->ndev->stats.rx_packets++;
+				cfshm->ndev->stats.rx_bytes +=
+					length;
+			} else
+				++cfshm->ndev->stats.rx_dropped;
+			/* Move to next packet descriptor. */
+			pck_desc++;
+
+			pbuf->frames++;
+			if (--quota <= 0) {
+				pr_devel("Quota exeeded (pbuf:%p)\n", pbuf);
+				goto out;
+			}
+		}
+desc_err:
+		pbuf->frames = 0;
+
+		spin_lock_irqsave(&cfshm->lock, flags);
+		ringbuf_upd_readptr(&cfshm->rx);
+		pbuf = new_rx_buf(cfshm);
+		spin_unlock_irqrestore(&cfshm->lock, flags);
+
+	}
+	cfshm->shm->ipc_rx_release(cfshm->shm, false);
+out:
+	return pbuf;
+}
+
+static int insert_skb_in_buf(struct cfshm *cfshm, struct sk_buff *skb,
+					struct shmbuffer *pbuf)
+{
+	struct shm_pck_desc *pck_desc;
+	unsigned int frmlen;
+	struct shm_caif_frm *frm;
+	u8 hdr_ofs;
+	struct caif_payload_info *info = (struct caif_payload_info *)&skb->cb;
+
+	WARN_ON(!spin_is_locked(&cfshm->lock));
+
+	if (unlikely(pbuf->frames >= cfshm->tx_frms_pr_buf)) {
+		pr_devel("-ENOSPC exeeded frames: %d >= %d\n",
+				pbuf->frames, cfshm->tx_frms_pr_buf);
+		return -ENOSPC;
+	}
+
+	/*
+	 * Align the address of the entire CAIF frame (incl padding),
+	 * so the modem can do efficient DMA of this frame
+	 * FIXME: Alignment is power of to, so it could use binary ops.
+	 */
+	pbuf->frm_ofs = roundup(pbuf->frm_ofs, cfshm->tx_alignment);
+
+
+	/* Make the payload (IP packet) inside the frame aligned */
+	hdr_ofs = (unsigned long) &pbuf->frm_ofs;
+	hdr_ofs = roundup(hdr_ofs + SHM_HDR_LEN + info->hdr_len,
+			cfshm->tx_alignment);
+
+	frm = (struct shm_caif_frm *)
+		(pbuf->addr + pbuf->frm_ofs);
+
+	frmlen = SHM_HDR_LEN + hdr_ofs + skb->len;
+
+	/*
+	 * Verify that packet, header and additional padding
+	 * can fit within the buffer frame area.
+	 */
+	if (pbuf->len < pbuf->frm_ofs + frmlen) {
+		pr_devel("-ENOSPC exeeded offset %d < %d\n",
+				pbuf->len, pbuf->frm_ofs + frmlen);
+		return -ENOSPC;
+	}
+
+	/* Copy in CAIF frame. */
+	frm->hdr_ofs = hdr_ofs;
+	skb_copy_bits(skb, 0, pbuf->addr +
+			pbuf->frm_ofs + SHM_HDR_LEN +
+			hdr_ofs, skb->len);
+
+	pr_devel("copy data buf:%d frm:%d offs:%d @%d len:%d\n",
+			pbuf->index, pbuf->frames,
+			pbuf->frm_ofs,
+			(u32) (pbuf->addr + pbuf->frm_ofs +
+				SHM_HDR_LEN + hdr_ofs - cfshm->tx_ringbuf),
+			skb->len);
+
+	cfshm->ndev->stats.tx_packets++;
+	cfshm->ndev->stats.tx_bytes += frmlen;
+	/* Fill in the shared memory packet descriptor area. */
+	pck_desc = (struct shm_pck_desc *) (pbuf->addr);
+	/* Forward to current frame. */
+	pck_desc += pbuf->frames;
+	pck_desc->offset = pbuf->frm_ofs;
+	pck_desc->length = frmlen;
+	/* Terminate packet descriptor area. */
+	pck_desc++;
+	pck_desc->offset = 0;
+	pck_desc->length = 0;
+	/* Update buffer parameters. */
+	pbuf->frames++;
+	pbuf->frm_ofs += frmlen;
+
+	return 0;
+}
+
+static struct shmbuffer *queue_to_ringbuf(struct cfshm *cfshm, int *new_bufs)
+{
+	struct shmbuffer *pbuf;
+	struct sk_buff *skb;
+	int err;
+
+	WARN_ON(!spin_is_locked(&cfshm->lock));
+
+	pbuf = get_tx_buf(cfshm);
+	while (pbuf != NULL) {
+		skb = skb_peek(&cfshm->sk_qhead);
+		if (skb == NULL)
+			break;
+		err = insert_skb_in_buf(cfshm, skb, pbuf);
+		if (unlikely(err == -ENOSPC)) {
+			pr_devel("No more space in buffer\n");
+			++(*new_bufs);
+			pbuf = tx_bump_buf(cfshm, pbuf);
+			continue;
+		}
+		skb = skb_dequeue(&cfshm->sk_qhead);
+		/* We're always in NET_*_SOFTIRQ */
+		dev_kfree_skb(skb);
+	}
+	return pbuf;
+}
+
+static int shm_netdev_open(struct net_device *netdev)
+{
+	struct cfshm *cfshm = netdev_priv(netdev);
+	int ret, err = 0;
+
+	cfshm->state = CFSHM_OPENING;
+	if (cfshm->shm != NULL && cfshm->shm->open != NULL)
+		err = cfshm->shm->open(cfshm->shm);
+	if (err)
+		goto error;
+
+	rtnl_unlock();  /* Release RTNL lock during connect wait */
+	ret = wait_event_interruptible_timeout(cfshm->netmgmt_wq,
+			cfshm->state != CFSHM_OPENING,
+			CONNECT_TIMEOUT);
+	rtnl_lock();
+
+	if (ret == 0) {
+		pr_debug("connect timeout\n");
+		err = -ETIMEDOUT;
+		goto error;
+	}
+
+	if (cfshm->state !=  CFSHM_OPEN) {
+		pr_debug("connect failed\n");
+		err = -ECONNREFUSED;
+		goto error;
+	}
+
+	napi_enable(&cfshm->napi);
+	return 0;
+error:
+	if (cfshm->shm != NULL && cfshm->shm->close != NULL)
+		cfshm->shm->close(cfshm->shm);
+	return err;
+}
+
+static int shm_netdev_close(struct net_device *netdev)
+{
+	struct cfshm *cfshm = netdev_priv(netdev);
+
+	napi_disable(&cfshm->napi);
+
+	if (cfshm->shm != NULL && cfshm->shm->close != NULL)
+		cfshm->shm->close(cfshm->shm);
+
+	return 0;
+}
+
+static int open_cb(void *drv)
+{
+	struct cfshm *cfshm = drv;
+
+	cfshm->state = CFSHM_OPEN;
+	netif_carrier_on(cfshm->ndev);
+	wake_up_interruptible(&cfshm->netmgmt_wq);
+	return 0;
+}
+
+static void close_cb(void *drv)
+{
+	struct cfshm *cfshm = drv;
+
+	cfshm->state = CFSHM_CLOSED;
+	netif_carrier_off(cfshm->ndev);
+	wake_up_interruptible(&cfshm->netmgmt_wq);
+}
+
+static int caif_shmdrv_rx_cb(void *drv)
+{
+	struct cfshm *cfshm = drv;
+
+	if (unlikely(*cfshm->shm->cfg.rx.state == cpu_to_le32(SHM_CLOSED)))
+		return -ESHUTDOWN;
+
+	napi_schedule(&cfshm->napi);
+	return 0;
+}
+
+static int send_pending_txbufs(struct cfshm *cfshm, int usedbufs)
+{
+	/* Send the started buffer if used buffers are low enough */
+	WARN_ON(!spin_is_locked(&cfshm->lock));
+	if (likely(usedbufs < cfshm->stuff_mark)) {
+		struct shmbuffer *pbuf = get_tx_buf(cfshm);
+		if (unlikely(pbuf->frames > 0)) {
+			pbuf = get_tx_buf(cfshm);
+			tx_bump_buf(cfshm, pbuf);
+			cfshm->shm->ipc_tx(cfshm->shm);
+			return 0;
+		}
+	}
+	return 0;
+}
+
+static int caif_shmdrv_tx_release_cb(void *drv)
+{
+	struct cfshm *cfshm = drv;
+	int usedbufs;
+
+	usedbufs = ringbuf_used(&cfshm->tx);
+
+	/* Send flow-on if we have sent flow-off and get below low-water */
+	if (usedbufs <= cfshm->low_xoff_water && !cfshm->tx_flow_on) {
+		pr_debug("Flow on\n");
+		cfshm->tx_flow_on = true;
+		cfshm->cfdev.flowctrl(cfshm->ndev, CAIF_FLOW_ON);
+	}
+
+	/* If ringbuf is full, schedule NAPI to start sending */
+	if (skb_peek(&cfshm->sk_qhead) != NULL) {
+		pr_debug("Schedule NAPI to empty queue\n");
+		napi_schedule(&cfshm->napi);
+	}
+
+	return 0;
+}
+
+static int shm_rx_poll(struct napi_struct *napi, int quota)
+{
+	struct cfshm *cfshm = container_of(napi, struct cfshm, napi);
+	int new_bufs;
+	struct shmbuffer *pbuf;
+	int usedbufs;
+	unsigned long flags;
+
+	/* Simply return if rx_poll is already called on other CPU */
+	if (atomic_read(&cfshm->dbg_smp_rxactive) > 0)
+		return quota;
+
+	WARN_ON(atomic_inc_return(&cfshm->dbg_smp_rxactive) > 1);
+
+	pbuf = shm_rx_func(cfshm, quota);
+
+	usedbufs = ringbuf_used(&cfshm->tx);
+
+	if (spin_trylock_irqsave(&cfshm->lock, flags)) {
+
+		/* Check if we're below "Stuff" limit, and send pending data */
+		send_pending_txbufs(cfshm, usedbufs);
+
+		/* Check if we have queued packets */
+		if (unlikely(skb_peek(&cfshm->sk_qhead) != NULL)) {
+			struct shmbuffer *txbuf;
+			WARN_ON(!spin_is_locked(&cfshm->lock));
+			pr_debug("Try to empty tx-queue\n");
+			new_bufs = 0;
+			txbuf = queue_to_ringbuf(cfshm, &new_bufs);
+
+			/* Bump out if we are configured with few buffers */
+			if (txbuf && cfshm->shm->cfg.tx.buffers < 3) {
+				tx_bump_buf(cfshm, txbuf);
+
+				spin_unlock_irqrestore(&cfshm->lock, flags);
+				cfshm->shm->ipc_tx(cfshm->shm);
+				goto txdone;
+			}
+		}
+		spin_unlock_irqrestore(&cfshm->lock, flags);
+	}
+txdone:
+
+	if (pbuf == NULL)
+		napi_complete(&cfshm->napi);
+
+	atomic_dec(&cfshm->dbg_smp_rxactive);
+	return 0;
+}
+
+static int shm_netdev_tx(struct sk_buff *skb, struct net_device *shm_netdev)
+{
+	struct shmbuffer *pbuf = NULL;
+	int usedbufs;
+	int new_bufs = 0;
+	struct cfshm *cfshm = netdev_priv(shm_netdev);
+	unsigned long flags;
+
+	/*
+	 * If we have packets in queue, keep queueing to avoid
+	 * out-of-order delivery
+	 */
+	spin_lock_irqsave(&cfshm->lock, flags);
+
+	skb_queue_tail(&cfshm->sk_qhead, skb);
+	pbuf = queue_to_ringbuf(cfshm, &new_bufs);
+
+	usedbufs = ringbuf_used(&cfshm->tx);
+
+	if (usedbufs > cfshm->high_xoff_water && cfshm->tx_flow_on) {
+		pr_debug("Flow off\n");
+		cfshm->tx_flow_on = false;
+		spin_unlock_irqrestore(&cfshm->lock, flags);
+		cfshm->cfdev.flowctrl(cfshm->ndev, CAIF_FLOW_OFF);
+		return 0;
+	}
+
+	/* Check if we should accumulate more packets */
+	if (new_bufs == 0 && usedbufs > cfshm->stuff_mark) {
+		spin_unlock_irqrestore(&cfshm->lock, flags);
+		return 0;
+	}
+	tx_bump_buf(cfshm, pbuf);
+	spin_unlock_irqrestore(&cfshm->lock, flags);
+	cfshm->shm->ipc_tx(cfshm->shm);
+	return 0;
+}
+
+static const struct net_device_ops netdev_ops = {
+	.ndo_open = shm_netdev_open,
+	.ndo_stop = shm_netdev_close,
+	.ndo_start_xmit = shm_netdev_tx,
+};
+
+static void shm_netdev_setup(struct net_device *pshm_netdev)
+{
+	struct cfshm *cfshm;
+
+	cfshm = netdev_priv(pshm_netdev);
+	pshm_netdev->netdev_ops = &netdev_ops;
+	pshm_netdev->type = ARPHRD_CAIF;
+	pshm_netdev->hard_header_len = CAIF_NEEDED_HEADROOM;
+	pshm_netdev->tx_queue_len = 0;
+	pshm_netdev->destructor = free_netdev;
+
+	/* Initialize structures in a clean state. */
+	memset(cfshm, 0, sizeof(struct cfshm));
+}
+
+static void deinit_bufs(struct cfshm *cfshm)
+{
+	int j;
+
+	if (cfshm == NULL)
+		return;
+
+	for (j = 0; j < cfshm->shm->cfg.rx.buffers; j++)
+		kfree(cfshm->rx_bufs[j]);
+	kfree(cfshm->rx_bufs);
+
+	for (j = 0; j < cfshm->shm->cfg.tx.buffers; j++)
+		kfree(cfshm->tx_bufs[j]);
+	kfree(cfshm->tx_bufs);
+}
+
+static int cfshm_probe(struct shm_dev *shm)
+{
+	int err, j;
+	struct cfshm *cfshm = NULL;
+	struct net_device *netdev;
+	u32 buf_size;
+	unsigned long flags;
+
+	if (shm == NULL)
+		return -EINVAL;
+	if (shm->cfg.tx.addr == NULL || shm->cfg.rx.addr == NULL) {
+		pr_debug("Shared Memory are not configured\n");
+		return -EINVAL;
+	}
+
+	if (shm->cfg.tx.ch_size / shm->cfg.tx.buffers <
+			shm->cfg.tx.packets * sizeof(struct shm_pck_desc) +
+				shm->cfg.tx.mtu) {
+		pr_warn("Bad packet TX-channel size");
+		return -EINVAL;
+	}
+
+	if (shm->cfg.rx.ch_size / shm->cfg.rx.buffers <
+			sizeof(struct shm_pck_desc) + shm->cfg.rx.mtu) {
+		pr_warn("Bad packet RX-channel size");
+		return -EINVAL;
+	}
+
+	if (shm->cfg.rx.buffers < 2 || shm->cfg.tx.buffers < 2) {
+		pr_warn("Too few buffers in channel");
+		return -EINVAL;
+	}
+
+	err = -ENOMEM;
+	netdev = alloc_netdev(sizeof(struct cfshm), shm->cfg.name,
+			shm_netdev_setup);
+
+	if (netdev == NULL)
+		goto error;
+
+	cfshm = netdev_priv(netdev);
+	cfshm->state = CFSHM_CLOSED;
+	init_waitqueue_head(&cfshm->netmgmt_wq);
+
+	cfshm->shm = shm;
+	shm->driver_data = cfshm;
+	cfshm->ndev = netdev;
+	netdev->mtu = shm->cfg.tx.mtu;
+	cfshm->high_xoff_water =
+		(shm->cfg.rx.buffers * HIGH_XOFF_WATERMARK) / 100;
+	cfshm->low_xoff_water =
+		(shm->cfg.rx.buffers * LOW_XOFF_WATERMARK) / 100;
+	cfshm->stuff_mark = (shm->cfg.rx.buffers * STUFF_MARK) / 100;
+
+	cfshm->tx_frms_pr_buf = shm->cfg.tx.packets;
+	cfshm->rx_frms_pr_buf = shm->cfg.rx.packets;
+	cfshm->rx_alignment = shm->cfg.rx.alignment;
+	cfshm->tx_alignment = shm->cfg.tx.alignment;
+
+	if (shm->cfg.latency)
+		cfshm->cfdev.link_select = CAIF_LINK_LOW_LATENCY;
+	else
+		cfshm->cfdev.link_select = CAIF_LINK_HIGH_BANDW;
+
+	cfshm->tx.rip = shm->cfg.tx.read;
+	cfshm->tx.wip = shm->cfg.tx.write;
+	cfshm->tx.bufsize = shm->cfg.tx.buf_size;
+	cfshm->tx.size = shm->cfg.tx.buffers;
+
+	cfshm->rx.rip = shm->cfg.rx.read;
+	cfshm->rx.wip = shm->cfg.rx.write;
+	cfshm->rx.bufsize = shm->cfg.rx.buf_size;
+	cfshm->rx.size = shm->cfg.rx.buffers;
+	pr_devel("RX ri:%d wi:%d size:%d\n",
+		le32_to_cpu(*cfshm->rx.rip),
+			le32_to_cpu(*cfshm->rx.wip), cfshm->rx.size);
+	pr_devel("TX ri:%d wi:%d size:%d\n",
+		le32_to_cpu(*cfshm->tx.rip),
+			le32_to_cpu(*cfshm->tx.wip), cfshm->rx.size);
+	pr_devel("frms_pr_buf:%d %d\n", cfshm->rx_frms_pr_buf,
+			cfshm->tx_frms_pr_buf);
+
+	spin_lock_init(&cfshm->lock);
+	netif_carrier_off(netdev);
+	skb_queue_head_init(&cfshm->sk_qhead);
+
+	pr_devel("SHM DEVICE[%p] PROBED BY DRIVER, NEW SHM DRIVER"
+			" INSTANCE AT cfshm =0x%p\n",
+			cfshm->shm, cfshm);
+
+	cfshm->tx_ringbuf = shm->cfg.tx.addr;
+	cfshm->rx_ringbuf = shm->cfg.rx.addr;
+
+	pr_devel("TX-BASE:%p RX-BASE:%p\n",
+			cfshm->tx_ringbuf,
+			cfshm->rx_ringbuf);
+
+	cfshm->tx_bufs = kzalloc(sizeof(struct shmbuffer *) *
+			shm->cfg.tx.buffers, GFP_KERNEL);
+	if (cfshm->tx_bufs == NULL)
+		goto error;
+	buf_size = shm->cfg.tx.ch_size / shm->cfg.tx.buffers;
+
+	pr_devel("TX: buffers:%d buf_size:%d frms:%d mtu:%d\n",
+			shm->cfg.tx.buffers, buf_size,
+			cfshm->tx_frms_pr_buf, netdev->mtu);
+
+	for (j = 0; j < shm->cfg.tx.buffers; j++) {
+		u32 desc_size;
+		struct shmbuffer *tx_buf =
+				kzalloc(sizeof(struct shmbuffer), GFP_KERNEL);
+
+		if (tx_buf == NULL) {
+			pr_warn("ERROR, Could not"
+					" allocate dynamic mem. for tx_buf, "
+					" Bailing out ...\n");
+			goto error;
+		}
+
+		tx_buf->index = j;
+
+		tx_buf->addr = cfshm->tx_ringbuf + (buf_size * j);
+		tx_buf->len = buf_size;
+		tx_buf->frames = 0;
+		desc_size = (cfshm->tx_frms_pr_buf + 1) *
+				sizeof(struct shm_pck_desc);
+
+		tx_buf->frm_ofs = desc_size + (desc_size % cfshm->tx_alignment);
+
+		cfshm->tx_bufs[j] = tx_buf;
+
+		pr_devel("tx_buf[%d] addr:%p len:%d\n",
+				tx_buf->index,
+				tx_buf->addr,
+				tx_buf->len);
+	}
+
+	cfshm->rx_bufs = kzalloc(sizeof(struct shmbuffer *) *
+				shm->cfg.rx.buffers, GFP_KERNEL);
+	if (cfshm->rx_bufs == NULL)
+		goto error;
+	buf_size = shm->cfg.tx.ch_size / shm->cfg.tx.buffers;
+	pr_devel("RX: buffers:%d buf_size:%d frms:%d mtu:%d\n",
+			shm->cfg.rx.buffers, buf_size,
+			cfshm->rx_frms_pr_buf, netdev->mtu);
+
+	for (j = 0; j < shm->cfg.rx.buffers; j++) {
+		struct shmbuffer *rx_buf =
+				kzalloc(sizeof(struct shmbuffer), GFP_KERNEL);
+
+		if (rx_buf == NULL) {
+			pr_warn("ERROR, Could not"
+					" allocate dynamic mem.for rx_buf, "
+					" Bailing out ...\n");
+			goto error;
+		}
+
+		rx_buf->index = j;
+
+		rx_buf->addr = cfshm->rx_ringbuf + (buf_size * j);
+		rx_buf->len = buf_size;
+		cfshm->rx_bufs[j] = rx_buf;
+		pr_devel("rx_buf[%d] addr:%p len:%d\n",
+				rx_buf->index,
+				rx_buf->addr,
+				rx_buf->len);
+	}
+
+	cfshm->tx_flow_on = 1;
+	cfshm->shm->ipc_rx_cb = caif_shmdrv_rx_cb;
+	cfshm->shm->ipc_tx_release_cb = caif_shmdrv_tx_release_cb;
+	cfshm->shm->open_cb = open_cb;
+	cfshm->shm->close_cb = close_cb;
+
+	spin_lock_irqsave(&cfshm->lock, flags);
+	get_tx_buf(cfshm);
+	new_rx_buf(cfshm);
+	spin_unlock_irqrestore(&cfshm->lock, flags);
+
+	netif_napi_add(netdev, &cfshm->napi, shm_rx_poll,
+			2 * cfshm->rx_frms_pr_buf);
+
+	netdev->dev.parent = &shm->dev;
+	err = register_netdev(netdev);
+	if (err) {
+		pr_warn("ERROR[%d], SHM could not, "
+			"register with NW FRMWK Bailing out ...\n", err);
+		goto error;
+	}
+	return err;
+error:
+	deinit_bufs(cfshm);
+	free_netdev(netdev);
+	return err;
+}
+
+static void cfshm_remove(struct shm_dev *shm)
+{
+	struct cfshm *cfshm;
+
+	if (shm == NULL || shm->driver_data == NULL)
+		return;
+
+	cfshm = shm->driver_data;
+	deinit_bufs(cfshm);
+	unregister_netdev(cfshm->ndev);
+
+	shm->ipc_rx_cb = NULL;
+	shm->ipc_tx_release_cb = NULL;
+	shm->open_cb = NULL;
+	shm->close_cb = NULL;
+	shm->driver_data = NULL;
+}
+
+static struct shm_driver cfshm_drv = {
+	.mode = SHM_PACKET_MODE,
+	.probe = cfshm_probe,
+	.remove = cfshm_remove,
+	.driver = {
+		.name = KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static void __exit cfshm_exit_module(void)
+{
+	modem_shm_unregister_driver(&cfshm_drv);
+}
+
+static int __init cfshm_init_module(void)
+{
+	int err;
+
+	err = modem_shm_register_driver(&cfshm_drv);
+	if (err) {
+		printk(KERN_ERR "Could not register SHM driver: %d.\n",
+			err);
+		goto err_dev_register;
+	}
+	return err;
+
+ err_dev_register:
+	return err;
+}
+
+module_init(cfshm_init_module);
+module_exit(cfshm_exit_module);
-- 
1.7.0.4


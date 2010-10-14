Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0JNAr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 20:47:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56721 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab0JNAry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 20:47:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VljoevpylRHUf42DUvedMwyLtD49rMztTEeJS4nrEY+MGStpojPylwHhNfSO1sI2K3
         fxT5Jw3IeyLeuK4dWj118x1PuyRm7l7dInB4Y66BXW57iHRLhHD7YFCcEZafZpzs8c1S
         JwGWAdoKuoJIEPN44C7aA2essOXSro3GGl8oo=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 3/6] memstick: jmb38x: Driver rework.
Date: Thu, 14 Oct 2010 02:40:02 +0200
Message-Id: <1287016805-5175-4-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
References: <1287016805-5175-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many of driver parts were rewritten, code simplified,
a lot of debbuging code added.

Tested with ms standard and ms pro cards.

DMA is now used for all transfers by default.
(except < 8 TPC that are written through TPC_P0/1)
That is used to work around hardware bug.

Clock setup fixed as suggested, serial IO works now.


And besides, a lot of work was put into that driver to make
it simple and clean.

No performance regressions (even a small improvement).

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c | 1185 ++++++++++++++++++-------------------
 drivers/memstick/host/jmb38x_ms.h |  200 +++++++
 2 files changed, 761 insertions(+), 624 deletions(-)
 create mode 100644 drivers/memstick/host/jmb38x_ms.h

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index f2b894c..32ffd24 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -2,6 +2,7 @@
  *  jmb38x_ms.c - JMicron jmb38x MemoryStick card reader
  *
  *  Copyright (C) 2008 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -17,746 +18,657 @@
 #include <linux/highmem.h>
 #include <linux/memstick.h>
 #include <linux/slab.h>
-
-#define DRIVER_NAME "jmb38x_ms"
+#include "jmb38x_ms.h"
 
 static int no_dma;
-module_param(no_dma, bool, 0644);
-
-enum {
-	DMA_ADDRESS       = 0x00,
-	BLOCK             = 0x04,
-	DMA_CONTROL       = 0x08,
-	TPC_P0            = 0x0c,
-	TPC_P1            = 0x10,
-	TPC               = 0x14,
-	HOST_CONTROL      = 0x18,
-	DATA              = 0x1c,
-	STATUS            = 0x20,
-	INT_STATUS        = 0x24,
-	INT_STATUS_ENABLE = 0x28,
-	INT_SIGNAL_ENABLE = 0x2c,
-	TIMER             = 0x30,
-	TIMER_CONTROL     = 0x34,
-	PAD_OUTPUT_ENABLE = 0x38,
-	PAD_PU_PD         = 0x3c,
-	CLOCK_DELAY       = 0x40,
-	ADMA_ADDRESS      = 0x44,
-	CLOCK_CONTROL     = 0x48,
-	LED_CONTROL       = 0x4c,
-	VERSION           = 0x50
-};
+static int debug;
 
-struct jmb38x_ms_host {
-	struct jmb38x_ms        *chip;
-	void __iomem            *addr;
-	spinlock_t              lock;
-	struct tasklet_struct   notify;
-	int                     id;
-	char                    host_id[32];
-	int                     irq;
-	unsigned int            block_pos;
-	unsigned long           timeout_jiffies;
-	struct timer_list       timer;
-	struct memstick_request *req;
-	unsigned char           cmd_flags;
-	unsigned char           io_pos;
-	unsigned int            io_word[2];
-};
+/* Read a register*/
+static inline u32 j38ms_read_reg(struct j38ms_host *host, int address)
+{
+	u32 value =  readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x == 0x%08x", address, value);
+	return value;
+}
 
-struct jmb38x_ms {
-	struct pci_dev        *pdev;
-	int                   host_cnt;
-	struct memstick_host  *hosts[];
-};
+/* Write a register */
+static inline void j38ms_write_reg(struct j38ms_host *host,
+						int address, u32 value)
+{
+	dbg_reg(host, "reg 0x%02x <- 0x%08x", address, value);
+	writel(value, host->addr + address);
+}
 
-#define BLOCK_COUNT_MASK       0xffff0000
-#define BLOCK_SIZE_MASK        0x00000fff
-
-#define DMA_CONTROL_ENABLE     0x00000001
-
-#define TPC_DATA_SEL           0x00008000
-#define TPC_DIR                0x00004000
-#define TPC_WAIT_INT           0x00002000
-#define TPC_GET_INT            0x00000800
-#define TPC_CODE_SZ_MASK       0x00000700
-#define TPC_DATA_SZ_MASK       0x00000007
-
-#define HOST_CONTROL_TDELAY_EN 0x00040000
-#define HOST_CONTROL_HW_OC_P   0x00010000
-#define HOST_CONTROL_RESET_REQ 0x00008000
-#define HOST_CONTROL_REI       0x00004000
-#define HOST_CONTROL_LED       0x00000400
-#define HOST_CONTROL_FAST_CLK  0x00000200
-#define HOST_CONTROL_RESET     0x00000100
-#define HOST_CONTROL_POWER_EN  0x00000080
-#define HOST_CONTROL_CLOCK_EN  0x00000040
-#define HOST_CONTROL_REO       0x00000008
-#define HOST_CONTROL_IF_SHIFT  4
-
-#define HOST_CONTROL_IF_SERIAL 0x0
-#define HOST_CONTROL_IF_PAR4   0x1
-#define HOST_CONTROL_IF_PAR8   0x3
-
-#define STATUS_BUSY             0x00080000
-#define STATUS_MS_DAT7          0x00040000
-#define STATUS_MS_DAT6          0x00020000
-#define STATUS_MS_DAT5          0x00010000
-#define STATUS_MS_DAT4          0x00008000
-#define STATUS_MS_DAT3          0x00004000
-#define STATUS_MS_DAT2          0x00002000
-#define STATUS_MS_DAT1          0x00001000
-#define STATUS_MS_DAT0          0x00000800
-#define STATUS_HAS_MEDIA        0x00000400
-#define STATUS_FIFO_EMPTY       0x00000200
-#define STATUS_FIFO_FULL        0x00000100
-#define STATUS_MS_CED           0x00000080
-#define STATUS_MS_ERR           0x00000040
-#define STATUS_MS_BRQ           0x00000020
-#define STATUS_MS_CNK           0x00000001
-
-#define INT_STATUS_TPC_ERR      0x00080000
-#define INT_STATUS_CRC_ERR      0x00040000
-#define INT_STATUS_TIMER_TO     0x00020000
-#define INT_STATUS_HSK_TO       0x00010000
-#define INT_STATUS_ANY_ERR      0x00008000
-#define INT_STATUS_FIFO_WRDY    0x00000080
-#define INT_STATUS_FIFO_RRDY    0x00000040
-#define INT_STATUS_MEDIA_OUT    0x00000010
-#define INT_STATUS_MEDIA_IN     0x00000008
-#define INT_STATUS_DMA_BOUNDARY 0x00000004
-#define INT_STATUS_EOTRAN       0x00000002
-#define INT_STATUS_EOTPC        0x00000001
-
-#define INT_STATUS_ALL          0x000f801f
-
-#define PAD_OUTPUT_ENABLE_MS  0x0F3F
-
-#define PAD_PU_PD_OFF         0x7FFF0000
-#define PAD_PU_PD_ON_MS_SOCK0 0x5f8f0000
-#define PAD_PU_PD_ON_MS_SOCK1 0x0f0f0000
-
-#define CLOCK_CONTROL_40MHZ   0x00000001
-#define CLOCK_CONTROL_50MHZ   0x0000000a
-#define CLOCK_CONTROL_60MHZ   0x00000008
-#define CLOCK_CONTROL_62_5MHZ 0x0000000c
-#define CLOCK_CONTROL_OFF     0x00000000
-
-#define PCI_CTL_CLOCK_DLY_ADDR   0x000000b0
-#define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
-#define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
-
-enum {
-	CMD_READY    = 0x01,
-	FIFO_READY   = 0x02,
-	REG_DATA     = 0x04,
-	DMA_DATA     = 0x08
-};
+/* Set specific bits in a register (little endian) */
+static inline void j38ms_set_reg_mask(struct j38ms_host *host,
+						int address, u32 mask)
+{
+	u32 reg = readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x |= 0x%08x (old =0x%08x)", address, mask, reg);
+	writel(reg | mask , host->addr + address);
+}
 
-static unsigned int jmb38x_ms_read_data(struct jmb38x_ms_host *host,
-					unsigned char *buf, unsigned int length)
+/* Clear specific bits in a register (little endian) */
+static inline void j38ms_clear_reg_mask(struct j38ms_host *host,
+						int address, u32 mask)
 {
-	unsigned int off = 0;
+	u32 reg = readl(host->addr + address);
+	dbg_reg(host, "reg 0x%02x &= 0x%08x (old = 0x%08x, mask = 0x%08x)",
+						address, ~mask, reg, mask);
+	writel(reg & ~mask, host->addr + address);
+}
 
-	while (host->io_pos && length) {
-		buf[off++] = host->io_word[0] & 0xff;
-		host->io_word[0] >>= 8;
-		length--;
-		host->io_pos--;
+/* Reads one DWORD via PIO. returns -EAGAIN if fifo is empty */
+static inline int j38ms_read_fifo_dword_pio(struct j38ms_host *host, u32 *dword)
+{
+	if (unlikely(j38ms_read_reg(host, STATUS) & STATUS_FIFO_EMPTY)) {
+		dbg(host, "PIO: FIFO empty");
+		return -EAGAIN;
 	}
 
-	if (!length)
-		return off;
+	*dword = j38ms_read_reg(host, DATA);
+	dbg(host, "PIO: read: %08x", *dword);
+	return 0;
+}
 
-	while (!(STATUS_FIFO_EMPTY & readl(host->addr + STATUS))) {
-		if (length < 4)
-			break;
-		*(unsigned int *)(buf + off) = __raw_readl(host->addr + DATA);
-		length -= 4;
-		off += 4;
-	}
-
-	if (length
-	    && !(STATUS_FIFO_EMPTY & readl(host->addr + STATUS))) {
-		host->io_word[0] = readl(host->addr + DATA);
-		for (host->io_pos = 4; host->io_pos; --host->io_pos) {
-			buf[off++] = host->io_word[0] & 0xff;
-			host->io_word[0] >>= 8;
-			length--;
-			if (!length)
-				break;
-		}
+/* Writes one DWORD via PIO. returns -EAGAIN if fifo is full */
+static inline int j38ms_write_fifo_dword_pio(struct j38ms_host *host, u32 dword)
+{
+	if (unlikely(j38ms_read_reg(host, STATUS) & STATUS_FIFO_FULL)) {
+		dbg(host, "PIO: FIFO full");
+		return -EAGAIN;
 	}
 
-	return off;
+	dbg(host, "PIO: writing: %08x", dword);
+	j38ms_write_reg(host, DATA, dword);
+	return 0;
 }
 
-static unsigned int jmb38x_ms_read_reg_data(struct jmb38x_ms_host *host,
-					    unsigned char *buf,
-					    unsigned int length)
+/* Read TPC data using PIO */
+static unsigned int j38ms_read_fifo_pio(struct j38ms_host *host,
+				unsigned char *buf, unsigned int length)
 {
-	unsigned int off = 0;
+	unsigned int orig_len = length;
+	unsigned char tmp_buf[4];
 
-	while (host->io_pos > 4 && length) {
-		buf[off++] = host->io_word[0] & 0xff;
-		host->io_word[0] >>= 8;
-		length--;
-		host->io_pos--;
+	/* Read bytes from last saved part */
+	if (host->pio_tmp_buf_len) {
+		int count = min(host->pio_tmp_buf_len, length);
+		memcpy(buf, host->pio_tmp_buf, count);
+		buf += count;
+		length -= count;
 	}
 
-	if (!length)
-		return off;
+	/* Read aligned data*/
+	for (; length >= 4 ; buf += 4, length -= 4)
+		if (j38ms_read_fifo_dword_pio(host, (u32 *)buf))
+			return orig_len - length;
 
-	while (host->io_pos && length) {
-		buf[off++] = host->io_word[1] & 0xff;
-		host->io_word[1] >>= 8;
-		length--;
-		host->io_pos--;
+	/* Read last 4 bytes, and
+			save unconsumed part of it to the pio_tmp_buf */
+	if (length && !j38ms_read_fifo_dword_pio(host, (u32 *)tmp_buf)) {
+
+		host->pio_tmp_buf_len = 4 - length;
+		memcpy(buf, tmp_buf, length);
+		memcpy(host->pio_tmp_buf,
+				tmp_buf + length, host->pio_tmp_buf_len);
+		length = 0;
 	}
 
-	return off;
+	return orig_len - length;
 }
 
-static unsigned int jmb38x_ms_write_data(struct jmb38x_ms_host *host,
+/* Write TPC data through normal PIO fifo */
+static unsigned int j38ms_write_fifo_pio(struct j38ms_host *host,
 					 unsigned char *buf,
 					 unsigned int length)
 {
-	unsigned int off = 0;
-
-	if (host->io_pos) {
-		while (host->io_pos < 4 && length) {
-			host->io_word[0] |=  buf[off++] << (host->io_pos * 8);
-			host->io_pos++;
-			length--;
+	unsigned int orig_len = length;
+
+	/* Complete the last saved bytes*/
+	if (host->pio_tmp_buf_len) {
+		int count = min(4 - host->pio_tmp_buf_len, length);
+		memcpy(host->pio_tmp_buf + host->pio_tmp_buf_len, buf, count);
+		buf += count;
+		length -= count;
+
+		if (host->pio_tmp_buf_len == 4) {
+			if (j38ms_write_fifo_dword_pio(
+					host, *(u32 *)host->pio_tmp_buf))
+				return orig_len - length;
+			else
+				host->pio_tmp_buf_len = 0;
 		}
 	}
 
-	if (host->io_pos == 4
-	    && !(STATUS_FIFO_FULL & readl(host->addr + STATUS))) {
-		writel(host->io_word[0], host->addr + DATA);
-		host->io_pos = 0;
-		host->io_word[0] = 0;
-	} else if (host->io_pos) {
-		return off;
-	}
-
-	if (!length)
-		return off;
-
-	while (!(STATUS_FIFO_FULL & readl(host->addr + STATUS))) {
-		if (length < 4)
-			break;
+	/* Write aligned data to hardware */
+	for (; length >= 4 ; length -= 4, buf += 4)
+		if (j38ms_write_fifo_dword_pio(host, *(u32 *)buf))
+			return orig_len - length;
 
-		__raw_writel(*(unsigned int *)(buf + off),
-			     host->addr + DATA);
-		length -= 4;
-		off += 4;
+	/* Save last 3-1 bytes to buffer, because we can't send them now*/
+	if (length) {
+		memset(host->pio_tmp_buf, 0, 4);
+		memcpy(host->pio_tmp_buf, buf, length);
+		host->pio_tmp_buf_len = length;
 	}
 
-	switch (length) {
-	case 3:
-		host->io_word[0] |= buf[off + 2] << 16;
-		host->io_pos++;
-	case 2:
-		host->io_word[0] |= buf[off + 1] << 8;
-		host->io_pos++;
-	case 1:
-		host->io_word[0] |= buf[off];
-		host->io_pos++;
-	}
-
-	off += host->io_pos;
-
-	return off;
+	return orig_len - length;
 }
 
-static unsigned int jmb38x_ms_write_reg_data(struct jmb38x_ms_host *host,
-					     unsigned char *buf,
-					     unsigned int length)
-{
-	unsigned int off = 0;
-
-	while (host->io_pos < 4 && length) {
-		host->io_word[0] &= ~(0xff << (host->io_pos * 8));
-		host->io_word[0] |=  buf[off++] << (host->io_pos * 8);
-		host->io_pos++;
-		length--;
-	}
-
-	if (!length)
-		return off;
-
-	while (host->io_pos < 8 && length) {
-		host->io_word[1] &= ~(0xff << (host->io_pos * 8));
-		host->io_word[1] |=  buf[off++] << (host->io_pos * 8);
-		host->io_pos++;
-		length--;
-	}
 
-	return off;
-}
-
-static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
+/* Transfer data between current request and FIFO */
+static void j38ms_transfer_pio(struct j38ms_host *host)
 {
-	unsigned int length;
-	unsigned int off;
-	unsigned int t_size, p_cnt;
 	unsigned char *buf;
-	struct page *pg;
+	unsigned int len;
 	unsigned long flags = 0;
 
-	if (host->req->long_data) {
-		length = host->req->sg.length - host->block_pos;
-		off = host->req->sg.offset + host->block_pos;
-	} else {
-		length = host->req->data_len - host->block_pos;
-		off = 0;
-	}
+	if (host->req->long_data)
+		local_irq_save(flags);
 
-	while (length) {
-		unsigned int uninitialized_var(p_off);
+	dbg_v(host, "PIO: new transfer");
 
+	while (1) {
 		if (host->req->long_data) {
-			pg = nth_page(sg_page(&host->req->sg),
-				      off >> PAGE_SHIFT);
-			p_off = offset_in_page(off);
-			p_cnt = PAGE_SIZE - p_off;
-			p_cnt = min(p_cnt, length);
-
-			local_irq_save(flags);
-			buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + p_off;
+			if (!sg_miter_next(&host->pio_sg_iter))
+				break;
+
+			buf = host->pio_sg_iter.addr;
+			len = host->pio_sg_iter.length;
 		} else {
-			buf = host->req->data + host->block_pos;
-			p_cnt = host->req->data_len - host->block_pos;
+			buf = host->req->data + host->pio_offset;
+			len = host->req->data_len - host->pio_offset;
+
+			if (!len)
+				break;
 		}
 
-		if (host->req->data_dir == WRITE)
-			t_size = !(host->cmd_flags & REG_DATA)
-				 ? jmb38x_ms_write_data(host, buf, p_cnt)
-				 : jmb38x_ms_write_reg_data(host, buf, p_cnt);
-		else
-			t_size = !(host->cmd_flags & REG_DATA)
-				 ? jmb38x_ms_read_data(host, buf, p_cnt)
-				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
+		len = host->req->data_dir == WRITE ?
+			j38ms_write_fifo_pio(host, buf, len) :
+			j38ms_read_fifo_pio(host, buf, len);
 
-		if (host->req->long_data) {
-			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
-			local_irq_restore(flags);
-		}
+		if (host->req->long_data)
+			host->pio_sg_iter.consumed = len;
+		else
+			host->pio_offset += len;
 
-		if (!t_size)
-			break;
-		host->block_pos += t_size;
-		length -= t_size;
-		off += t_size;
+		dbg(host, "PIO: transfered %d bytes", len);
+		if (!len)
+			goto exit;
 	}
 
-	if (!length && host->req->data_dir == WRITE) {
-		if (host->cmd_flags & REG_DATA) {
-			writel(host->io_word[0], host->addr + TPC_P0);
-			writel(host->io_word[1], host->addr + TPC_P1);
-		} else if (host->io_pos) {
-			writel(host->io_word[0], host->addr + DATA);
-		}
+	/* Write last non-complete dword of the data */
+	if (host->req->data_dir == WRITE && host->pio_tmp_buf_len) {
+		if (!j38ms_write_fifo_dword_pio(host,
+						*(u32 *)host->pio_tmp_buf))
+			host->pio_tmp_buf_len = 0;
 	}
+exit:
+	if (host->req->long_data) {
+		sg_miter_stop(&host->pio_sg_iter);
+		local_irq_restore(flags);
+	}
+}
 
-	return length;
+/* Read short TPC data (up to 8 bytes) via 2 special registers*/
+static void j38ms_read_tpc_inline(struct j38ms_host *host)
+{
+       *(u32 *)(host->req->data + 0) = j38ms_read_reg(host, TPC_P0);
+       *(u32 *)(host->req->data + 4) = j38ms_read_reg(host, TPC_P1);
 }
 
-static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
+/* Write short TPC data (up to 8 bytes) through 2 special registers */
+static void j38ms_write_tpc_inline(struct j38ms_host *host)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
-	unsigned char *data;
-	unsigned int data_len, cmd, t_val;
+	j38ms_write_reg(host, TPC_P0, *(u32 *)(host->req->data + 0));
+	j38ms_write_reg(host, TPC_P1, *(u32 *)(host->req->data + 4));
+}
 
-	if (!(STATUS_HAS_MEDIA & readl(host->addr + STATUS))) {
-		dev_dbg(&msh->dev, "no media status\n");
+/*
+ * Start execution of a TPC:
+ * NOTES:
+ *
+ * PIO writes trigger wierd hardware bug that causes DMA writes
+ *  to fail.
+ *
+ * length alignmemt:
+ *	Short (<=8) TPC don't have any alignment problems.
+ *	DMA read/writes must be 4 aligned
+ *	PIO _reads_ must be aligned. Writes can be not aligned
+ *
+ */
+
+static int j38ms_execute_tpc(struct j38ms_host *host)
+{
+	u32 cmd = 0, t_val;
+	unsigned int data_len = host->req->long_data ?
+		host->req->sg.length : host->req->data_len;
+	bool is_read = host->req->data_dir == READ;
+	dma_addr_t dma_address;
+
+	if (host->dead) {
 		host->req->error = -ETIME;
+		return 0;
+	}
+
+	if (!(j38ms_read_reg(host, STATUS) & STATUS_HAS_MEDIA)) {
+		dbg(host, "IO: card removed, refusing to send TPC");
+		host->req->error = -ENODEV;
 		return host->req->error;
 	}
 
-	dev_dbg(&msh->dev, "control %08x\n", readl(host->addr + HOST_CONTROL));
-	dev_dbg(&msh->dev, "status %08x\n", readl(host->addr + INT_STATUS));
-	dev_dbg(&msh->dev, "hstatus %08x\n", readl(host->addr + STATUS));
+	if (data_len > BLOCK_SIZE_MASK) {
+		dbg(host, "IO: too long TPC (len: %d)", data_len);
+		host->req->error = -ENOSYS;
+		return host->req->error;
+	}
 
-	host->cmd_flags = 0;
-	host->block_pos = 0;
-	host->io_pos = 0;
-	host->io_word[0] = 0;
-	host->io_word[1] = 0;
+	dbg(host, "IO: Start execution of %s",
+		memstick_debug_get_tpc_name(host->req->tpc));
 
-	cmd = host->req->tpc << 16;
-	cmd |= TPC_DATA_SEL;
 
-	if (host->req->data_dir == READ)
-		cmd |= TPC_DIR;
-	if (host->req->need_card_int)
-		cmd |= TPC_WAIT_INT;
+	dbg_v(host, "host control: %08x", j38ms_read_reg(host, HOST_CONTROL));
+	dbg_v(host, "int status: %08x", j38ms_read_reg(host, INT_STATUS));
+	dbg_v(host, "card status: %08x", j38ms_read_reg(host, STATUS));
 
-	data = host->req->data;
+	host->req->error = 0;
+	host->cmd_flags = 0;
 
-	if (!no_dma)
-		host->cmd_flags |= DMA_DATA;
+	cmd = host->req->tpc << 16;
+	if (is_read)
+		cmd |= TPC_DIR;
 
-	if (host->req->long_data) {
-		data_len = host->req->sg.length;
-	} else {
-		data_len = host->req->data_len;
-		host->cmd_flags &= ~DMA_DATA;
+	if (host->req->need_card_int) {
+		dbg_v(host, "IO: Will wait for card interrupt");
+		cmd |= TPC_WAIT_INT;
+		/* No, the TPC_GET_INT doesn't work.... */
 	}
 
-	if (data_len <= 8) {
-		cmd &= ~(TPC_DATA_SEL | 0xf);
+	/* Special case for short TPCs */
+	if (!host->req->long_data && data_len <= 8) {
+		dbg(host, "IO: Using 8 byte register window");
 		host->cmd_flags |= REG_DATA;
 		cmd |= data_len & 0xf;
-		host->cmd_flags &= ~DMA_DATA;
+
+		if (!is_read)
+			j38ms_write_tpc_inline(host);
+		goto exec;
 	}
 
-	if (host->cmd_flags & DMA_DATA) {
-		if (1 != pci_map_sg(host->chip->pdev, &host->req->sg, 1,
-				    host->req->data_dir == READ
-				    ? PCI_DMA_FROMDEVICE
-				    : PCI_DMA_TODEVICE)) {
-			host->req->error = -ENOMEM;
-			return host->req->error;
+	/* Otherwise use internal fifo*/
+	cmd |= TPC_DATA_SEL;
+
+	if (data_len & 0x03) {
+		dbg(host, "Hardware doesn't support not-aligned len TPCs!");
+		host->req->error = -ENOSYS;
+		return host->req->error;
+	}
+
+	/* DMA */
+	if (!no_dma) {
+
+		dbg(host, "IO: Using DMA");
+		host->cmd_flags |= DMA_DATA;
+
+		if (host->req->long_data) {
+
+			if (pci_map_sg(host->chip->pdev,
+				&host->req->sg, 1, is_read
+				? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE) != 1) {
+
+				dbg(host, "IO: DMA map failed");
+				host->req->error = -ENOMEM;
+				return host->req->error;
+			}
+
+			/* We really shouldn't pretend we support that case */
+			if (sg_dma_len(&host->req->sg) != data_len) {
+				dbg(host, "IO: DMA len mismatch");
+				host->req->error = -EFAULT;
+				return host->req->error;
+			}
+
+			dma_address = sg_dma_address(&host->req->sg);
+
+		} else {
+			if (!is_read)
+				memcpy(host->dma_bounce_page,
+					host->req->data, data_len);
+			dma_address = host->dma_bus_address;
 		}
-		data_len = sg_dma_len(&host->req->sg);
-		writel(sg_dma_address(&host->req->sg),
-		       host->addr + DMA_ADDRESS);
-		writel(((1 << 16) & BLOCK_COUNT_MASK)
-		       | (data_len & BLOCK_SIZE_MASK),
-		       host->addr + BLOCK);
-		writel(DMA_CONTROL_ENABLE, host->addr + DMA_CONTROL);
-	} else if (!(host->cmd_flags & REG_DATA)) {
-		writel(((1 << 16) & BLOCK_COUNT_MASK)
-		       | (data_len & BLOCK_SIZE_MASK),
-		       host->addr + BLOCK);
-			t_val = readl(host->addr + INT_STATUS_ENABLE);
-			t_val |= host->req->data_dir == READ
-				 ? INT_STATUS_FIFO_RRDY
-				 : INT_STATUS_FIFO_WRDY;
-
-			writel(t_val, host->addr + INT_STATUS_ENABLE);
-			writel(t_val, host->addr + INT_SIGNAL_ENABLE);
+
+		j38ms_write_reg(host, BLOCK, data_len | BLOCK_COUNT_1BLOCK);
+		j38ms_write_reg(host, DMA_ADDRESS, dma_address);
+		j38ms_write_reg(host, DMA_CONTROL, DMA_CONTROL_ENABLE);
+	/* PIO */
 	} else {
-		cmd &= ~(TPC_DATA_SEL | 0xf);
-		host->cmd_flags |= REG_DATA;
-		cmd |= data_len & 0xf;
 
-		if (host->req->data_dir == WRITE) {
-			jmb38x_ms_transfer_data(host);
-			writel(host->io_word[0], host->addr + TPC_P0);
-			writel(host->io_word[1], host->addr + TPC_P1);
-		}
-	}
+		dbg(host, "IO: Using PIO");
+		host->cmd_flags |= PIO_DATA;
 
-	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
-	writel(HOST_CONTROL_LED | readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
-	host->req->error = 0;
+		host->pio_offset = 0;
+		host->pio_tmp_buf_len = 0;
+		memset(host->pio_tmp_buf, 0, 4);
+
+		if (host->req->long_data)
+			sg_miter_start(&host->pio_sg_iter,
+				&host->req->sg, 1, SG_MITER_ATOMIC |
+				(is_read ? SG_MITER_FROM_SG : SG_MITER_TO_SG));
 
-	writel(cmd, host->addr + TPC);
-	dev_dbg(&msh->dev, "executing TPC %08x, len %x\n", cmd, data_len);
+		/* Enable FIFO empty interrupts */
+		t_val = is_read ? INT_STATUS_FIFO_RRDY : INT_STATUS_FIFO_WRDY;
 
+		j38ms_write_reg(host, BLOCK, data_len | BLOCK_COUNT_1BLOCK);
+		j38ms_set_reg_mask(host, INT_SIGNAL_ENABLE, t_val);
+		j38ms_set_reg_mask(host, INT_STATUS_ENABLE, t_val);
+	}
+exec:
+	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
+
+	/* Let the TPC fly... */
+	j38ms_write_reg(host, TPC, cmd);
+	j38ms_set_reg_mask(host, HOST_CONTROL, HOST_CONTROL_LED);
 	return 0;
 }
 
-static void jmb38x_ms_complete_cmd(struct memstick_host *msh, int last)
+/* Cleanups execution of current TPC */
+static void j38ms_complete_tpc(struct memstick_host *msh)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
-	unsigned int t_val = 0;
-	int rc;
-
+	struct j38ms_host *host = memstick_priv(msh);
 	del_timer(&host->timer);
 
-	dev_dbg(&msh->dev, "c control %08x\n",
-		readl(host->addr + HOST_CONTROL));
-	dev_dbg(&msh->dev, "c status %08x\n",
-		readl(host->addr + INT_STATUS));
-	dev_dbg(&msh->dev, "c hstatus %08x\n", readl(host->addr + STATUS));
+	dbg(host, "IO: TPC complete (error : %d)", host->req->error);
+
+	j38ms_write_reg(host, BLOCK, 0);
+	j38ms_write_reg(host, DMA_CONTROL, 0);
 
-	host->req->int_reg = readl(host->addr + STATUS) & 0xff;
+	dbg_v(host, "host control: %08x", j38ms_read_reg(host, HOST_CONTROL));
+	dbg_v(host, "int status: %08x", j38ms_read_reg(host, INT_STATUS));
+	dbg_v(host, "card status: %08x", j38ms_read_reg(host, STATUS));
 
-	writel(0, host->addr + BLOCK);
-	writel(0, host->addr + DMA_CONTROL);
+	if (host->req->need_card_int)
+		host->req->int_reg = j38ms_read_reg(host, STATUS) & 0xFF;
 
 	if (host->cmd_flags & DMA_DATA) {
-		pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
-			     host->req->data_dir == READ
-			     ? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
-	} else {
-		t_val = readl(host->addr + INT_STATUS_ENABLE);
-		if (host->req->data_dir == READ)
-			t_val &= ~INT_STATUS_FIFO_RRDY;
-		else
-			t_val &= ~INT_STATUS_FIFO_WRDY;
 
-		writel(t_val, host->addr + INT_STATUS_ENABLE);
-		writel(t_val, host->addr + INT_SIGNAL_ENABLE);
-	}
+		if (host->req->long_data)
+			pci_unmap_sg(host->chip->pdev, &host->req->sg, 1,
+				host->req->data_dir == READ
+				? PCI_DMA_FROMDEVICE : PCI_DMA_TODEVICE);
+		else if (host->req->data_dir == READ)
+			memcpy(host->req->data,
+				host->dma_bounce_page, host->req->data_len);
 
-	writel((~HOST_CONTROL_LED) & readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
+	} else if (host->cmd_flags & PIO_DATA) {
+		u32 t_val = INT_STATUS_FIFO_RRDY | INT_STATUS_FIFO_WRDY;
 
-	if (!last) {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-		} while (!rc && jmb38x_ms_issue_cmd(msh));
-	} else {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-			if (!rc)
-				host->req->error = -ETIME;
-		} while (!rc);
+		/* This is not known well */
+		j38ms_clear_reg_mask(host, INT_STATUS_ENABLE, t_val);
+
+		/* This disables the IRQ to host, really */
+		j38ms_clear_reg_mask(host, INT_SIGNAL_ENABLE, t_val);
 	}
+
+	j38ms_clear_reg_mask(host, HOST_CONTROL, HOST_CONTROL_LED);
 }
 
-static irqreturn_t jmb38x_ms_isr(int irq, void *dev_id)
+/* Interrupt handler */
+static irqreturn_t j38ms_isr(int irq, void *dev_id)
 {
 	struct memstick_host *msh = dev_id;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
-	unsigned int irq_status;
+	struct j38ms_host *host = memstick_priv(msh);
+	u32 irq_status;
 
 	spin_lock(&host->lock);
-	irq_status = readl(host->addr + INT_STATUS);
-	dev_dbg(&host->chip->pdev->dev, "irq_status = %08x\n", irq_status);
+	irq_status = j38ms_read_reg(host, INT_STATUS);
+
 	if (irq_status == 0 || irq_status == (~0)) {
 		spin_unlock(&host->lock);
 		return IRQ_NONE;
 	}
 
-	if (host->req) {
-		if (irq_status & INT_STATUS_ANY_ERR) {
-			if (irq_status & INT_STATUS_CRC_ERR)
-				host->req->error = -EILSEQ;
-			else
-				host->req->error = -ETIME;
-		} else {
-			if (host->cmd_flags & DMA_DATA) {
-				if (irq_status & INT_STATUS_EOTRAN)
-					host->cmd_flags |= FIFO_READY;
-			} else {
-				if (irq_status & (INT_STATUS_FIFO_RRDY
-						  | INT_STATUS_FIFO_WRDY))
-					jmb38x_ms_transfer_data(host);
-
-				if (irq_status & INT_STATUS_EOTRAN) {
-					jmb38x_ms_transfer_data(host);
-					host->cmd_flags |= FIFO_READY;
-				}
-			}
+	dbg(host, "IRQ: status: %08x", irq_status);
 
-			if (irq_status & INT_STATUS_EOTPC) {
-				host->cmd_flags |= CMD_READY;
-				if (host->cmd_flags & REG_DATA) {
-					if (host->req->data_dir == READ) {
-						host->io_word[0]
-							= readl(host->addr
-								+ TPC_P0);
-						host->io_word[1]
-							= readl(host->addr
-								+ TPC_P1);
-						host->io_pos = 8;
-
-						jmb38x_ms_transfer_data(host);
-					}
-					host->cmd_flags |= FIFO_READY;
-				}
-			}
+	if (irq_status & INT_STATUS_ANY_ERR)
+		dbg(host, "IRQ: error");
+
+	if (irq_status & INT_STATUS_EOTRAN)
+		dbg(host, "IRQ: transaction done");
+
+	if (irq_status & INT_STATUS_FIFO_RRDY)
+		dbg(host, "IRQ: FIFO is now ready for reading");
+
+	if (irq_status & INT_STATUS_FIFO_WRDY)
+		dbg(host, "IRQ: FIFO is now ready for writing");
+
+	if (irq_status & INT_STATUS_EOTPC)
+		dbg(host, "IRQ: TPC complete");
+
+	if (!host->req)
+		goto out;
+
+	/* Errors */
+	if (irq_status & INT_STATUS_ANY_ERR) {
+		host->req->error =
+			(irq_status & INT_STATUS_CRC_ERR) ? -EILSEQ : -EIO;
+		goto out;
+	}
+
+	/* End of TPC interrupt */
+	if (irq_status & INT_STATUS_EOTPC) {
+		host->cmd_flags |= CMD_READY;
+
+		if (host->cmd_flags & REG_DATA) {
+			if (host->req->data_dir == READ)
+				j38ms_read_tpc_inline(host);
+			host->cmd_flags |= FIFO_READY;
 		}
 	}
 
+	/* Fifo handling */
+	if (irq_status & INT_STATUS_EOTRAN)
+		host->cmd_flags |= FIFO_READY;
+	else if (irq_status & (INT_STATUS_FIFO_RRDY | INT_STATUS_FIFO_WRDY))
+		if (host->cmd_flags & PIO_DATA)
+			j38ms_transfer_pio(host);
+
+out:
 	if (irq_status & (INT_STATUS_MEDIA_IN | INT_STATUS_MEDIA_OUT)) {
-		dev_dbg(&host->chip->pdev->dev, "media changed\n");
+		dbg(host, "IRQ: media changed");
 		memstick_detect_change(msh);
 	}
 
-	writel(irq_status, host->addr + INT_STATUS);
+	/* Yes, interrupt status is cleared by setting the bits as usual */
+	j38ms_write_reg(host, INT_STATUS, irq_status);
 
-	if (host->req
-	    && (((host->cmd_flags & CMD_READY)
-		 && (host->cmd_flags & FIFO_READY))
-		|| host->req->error))
-		jmb38x_ms_complete_cmd(msh, 0);
+	if (host->req && (((host->cmd_flags & CMD_READY)
+		&& (host->cmd_flags & FIFO_READY)) || host->req->error)) {
+		j38ms_complete_tpc(msh);
+		tasklet_schedule(&host->tasklet);
+	}
 
 	spin_unlock(&host->lock);
 	return IRQ_HANDLED;
 }
 
-static void jmb38x_ms_abort(unsigned long data)
+/* Timer that is executed in absense of the interrupt */
+static void j38ms_abort(unsigned long data)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = (struct j38ms_host *)data;
 	unsigned long flags;
 
-	dev_dbg(&host->chip->pdev->dev, "abort\n");
+	dbg(host, "interrupt timeout");
+
 	spin_lock_irqsave(&host->lock, flags);
 	if (host->req) {
 		host->req->error = -ETIME;
-		jmb38x_ms_complete_cmd(msh, 0);
+		j38ms_complete_tpc(host->msh);
+		tasklet_schedule(&host->tasklet);
 	}
+
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_req_tasklet(unsigned long data)
+static void j38ms_submit_tasklet(unsigned long data)
 {
-	struct memstick_host *msh = (struct memstick_host *)data;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = (struct j38ms_host *)data;
 	unsigned long flags;
-	int rc;
 
 	spin_lock_irqsave(&host->lock, flags);
-	if (!host->req) {
-		do {
-			rc = memstick_next_req(msh, &host->req);
-			dev_dbg(&host->chip->pdev->dev, "tasklet req %d\n", rc);
-		} while (!rc && jmb38x_ms_issue_cmd(msh));
-	}
+	j38ms_next_request(host);
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_dummy_submit(struct memstick_host *msh)
+/* Asks for next request from upper layer and starts its execution */
+static void j38ms_next_request(struct j38ms_host *host)
 {
-	return;
+	while (!memstick_next_req(host->msh, &host->req))
+		if (!j38ms_execute_tpc(host))
+			return;
 }
 
-static void jmb38x_ms_submit_req(struct memstick_host *msh)
+/* hardware reset */
+static int j38ms_reset(struct j38ms_host *host, u32 reset_bit)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	int i;
+	j38ms_set_reg_mask(host,
+			HOST_CONTROL, reset_bit | HOST_CONTROL_CLOCK_EN);
 
-	tasklet_schedule(&host->notify);
+	for (i = 0; i < 20; ++i) {
+		if (!(j38ms_read_reg(host, HOST_CONTROL) & reset_bit))
+			break;
+		ndelay(20);
+	}
+	return (j38ms_read_reg(host, HOST_CONTROL) & reset_bit) ? EIO : 0;
 }
 
-static int jmb38x_ms_reset(struct jmb38x_ms_host *host)
+/* Enable/disable the device */
+static int j38ms_power_device(struct j38ms_host *host, bool enable)
 {
-	int cnt;
+	int error;
 
-	writel(HOST_CONTROL_RESET_REQ | HOST_CONTROL_CLOCK_EN
-	       | readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
-	mmiowb();
+	if (enable) {
 
-	for (cnt = 0; cnt < 20; ++cnt) {
-		if (!(HOST_CONTROL_RESET_REQ
-		      & readl(host->addr + HOST_CONTROL)))
-			goto reset_next;
+		error = j38ms_reset(host, HOST_CONTROL_RESET_REQ);
+		error = j38ms_reset(host, HOST_CONTROL_RESET);
 
-		ndelay(20);
-	}
-	dev_dbg(&host->chip->pdev->dev, "reset_req timeout\n");
-	/* return -EIO; */
+		if (error)
+			return error;
 
-reset_next:
-	writel(HOST_CONTROL_RESET | HOST_CONTROL_CLOCK_EN
-	       | readl(host->addr + HOST_CONTROL),
-	       host->addr + HOST_CONTROL);
-	mmiowb();
+		j38ms_write_reg(host, INT_SIGNAL_ENABLE, INT_STATUS_ALL);
+		j38ms_write_reg(host, INT_STATUS_ENABLE, INT_STATUS_ALL);
+		j38ms_write_reg(host, CLOCK_CONTROL, CLOCK_CONTROL_RESET);
 
-	for (cnt = 0; cnt < 20; ++cnt) {
-		if (!(HOST_CONTROL_RESET
-		      & readl(host->addr + HOST_CONTROL)))
-			goto reset_ok;
+		j38ms_write_reg(host, HOST_CONTROL,
+			HOST_CONTROL_POWER_EN |
+			HOST_CONTROL_CLOCK_EN |
+			HOST_CONTROL_HW_OC_P |
+			HOST_CONTROL_TDELAY_EN |
+			HOST_CONTROL_BSY_TIME);
+
+		j38ms_write_reg(host, PAD_PU_PD, host->id ?
+			PAD_PU_PD_ON_MS_SOCK1 : PAD_PU_PD_ON_MS_SOCK0);
+
+		j38ms_write_reg(host, PAD_OUTPUT_ENABLE, PAD_OUTPUT_ENABLE_MS);
+
+	} else {
+		j38ms_clear_reg_mask(host, HOST_CONTROL,
+			HOST_CONTROL_POWER_EN | HOST_CONTROL_CLOCK_EN);
+		j38ms_write_reg(host, PAD_OUTPUT_ENABLE, 0);
+		j38ms_write_reg(host, PAD_PU_PD, PAD_PU_PD_OFF);
+		j38ms_write_reg(host, CLOCK_CONTROL, CLOCK_CONTROL_OFF);
 
-		ndelay(20);
 	}
-	dev_dbg(&host->chip->pdev->dev, "reset timeout\n");
-	return -EIO;
+	msleep(100);
+	return 0;
+}
+
+/* Switch interface */
+static int j38ms_set_interface(struct j38ms_host *host, int interface)
+{
+	u32 host_ctl = j38ms_read_reg(host, HOST_CONTROL);
+	u32 clock_ctl = CLOCK_CONTROL_40MHZ;
+	u32 clock_delay;
+
+	host_ctl &= ~HOST_CONTROL_IF_MASK;
+	pci_read_config_dword(host->chip->pdev, PCI_CTL_CLOCK_DLY_ADDR,
+				&clock_delay);
+
+	clock_delay &= host->id ? ~PCI_CTL_CLOCK_DLY_MASK_B
+				: ~PCI_CTL_CLOCK_DLY_MASK_A;
+
+	if (interface == MEMSTICK_SERIAL) {
+
+		host_ctl |= HOST_CONTROL_IF_SERIAL;
+		clock_ctl = CLOCK_CONTROL_40MHZ;
+
+		host_ctl &= ~HOST_CONTROL_FAST_CLK;
+		host_ctl &= ~HOST_CONTROL_REO;
+		host_ctl |= HOST_CONTROL_REI;
+
+	} else if (interface == MEMSTICK_PAR4) {
+
+		host_ctl |= HOST_CONTROL_IF_PAR4;
+		clock_ctl = CLOCK_CONTROL_40MHZ;
+
+		host_ctl |= HOST_CONTROL_FAST_CLK;
+		host_ctl |= HOST_CONTROL_REO;
+		host_ctl &= ~HOST_CONTROL_REI;
+
+		clock_delay |= host->id ? (4 << 12) : (4 << 8);
+
+	} else if (interface == MEMSTICK_PAR8) {
+
+		host_ctl |= HOST_CONTROL_IF_PAR8;
+		clock_ctl = CLOCK_CONTROL_50MHZ;
+
+		host_ctl |= HOST_CONTROL_FAST_CLK;
+		host_ctl &= ~HOST_CONTROL_REO;
+		host_ctl &= ~HOST_CONTROL_REI;
+	} else
+		return -EINVAL;
 
-reset_ok:
-	mmiowb();
-	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
-	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
+	j38ms_write_reg(host, HOST_CONTROL, host_ctl);
+	j38ms_write_reg(host, CLOCK_CONTROL, clock_ctl);
+
+	pci_write_config_dword(host->chip->pdev,
+		PCI_CTL_CLOCK_DLY_ADDR, clock_delay);
+
+	host->interface = interface;
 	return 0;
 }
 
-static int jmb38x_ms_set_param(struct memstick_host *msh,
+/* external interface: control hardware settings */
+static int j38ms_set_param(struct memstick_host *msh,
 			       enum memstick_param param,
 			       int value)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
-	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
-	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
-	int rc = 0;
+	struct j38ms_host *host = memstick_priv(msh);
 
 	switch (param) {
 	case MEMSTICK_POWER:
-		if (value == MEMSTICK_POWER_ON) {
-			rc = jmb38x_ms_reset(host);
-			if (rc)
-				return rc;
-
-			host_ctl = 7;
-			host_ctl |= HOST_CONTROL_POWER_EN
-				    | HOST_CONTROL_CLOCK_EN
-				    | HOST_CONTROL_HW_OC_P
-				    | HOST_CONTROL_TDELAY_EN;
-			writel(host_ctl, host->addr + HOST_CONTROL);
-
-			writel(host->id ? PAD_PU_PD_ON_MS_SOCK1
-					: PAD_PU_PD_ON_MS_SOCK0,
-			       host->addr + PAD_PU_PD);
-
-			writel(PAD_OUTPUT_ENABLE_MS,
-			       host->addr + PAD_OUTPUT_ENABLE);
-
-			msleep(10);
-			dev_dbg(&host->chip->pdev->dev, "power on\n");
-		} else if (value == MEMSTICK_POWER_OFF) {
-			host_ctl &= ~(HOST_CONTROL_POWER_EN
-				      | HOST_CONTROL_CLOCK_EN);
-			writel(host_ctl, host->addr +  HOST_CONTROL);
-			writel(0, host->addr + PAD_OUTPUT_ENABLE);
-			writel(PAD_PU_PD_OFF, host->addr + PAD_PU_PD);
-			dev_dbg(&host->chip->pdev->dev, "power off\n");
-		} else
-			return -EINVAL;
-		break;
+		return j38ms_power_device(host, (value == MEMSTICK_POWER_ON));
 	case MEMSTICK_INTERFACE:
-		host_ctl &= ~(3 << HOST_CONTROL_IF_SHIFT);
-		pci_read_config_dword(host->chip->pdev,
-				      PCI_CTL_CLOCK_DLY_ADDR,
-				      &clock_delay);
-		clock_delay &= host->id ? ~PCI_CTL_CLOCK_DLY_MASK_B
-					: ~PCI_CTL_CLOCK_DLY_MASK_A;
-
-		if (value == MEMSTICK_SERIAL) {
-			host_ctl &= ~HOST_CONTROL_FAST_CLK;
-			host_ctl &= ~HOST_CONTROL_REO;
-			host_ctl |= HOST_CONTROL_IF_SERIAL
-				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl |= HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_40MHZ;
-		} else if (value == MEMSTICK_PAR4) {
-			host_ctl |= HOST_CONTROL_FAST_CLK | HOST_CONTROL_REO;
-			host_ctl |= HOST_CONTROL_IF_PAR4
-				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~HOST_CONTROL_REI;
-			clock_ctl = CLOCK_CONTROL_40MHZ;
-			clock_delay |= host->id ? (4 << 12) : (4 << 8);
-		} else if (value == MEMSTICK_PAR8) {
-			host_ctl |= HOST_CONTROL_FAST_CLK;
-			host_ctl |= HOST_CONTROL_IF_PAR8
-				    << HOST_CONTROL_IF_SHIFT;
-			host_ctl &= ~(HOST_CONTROL_REI | HOST_CONTROL_REO);
-			clock_ctl = CLOCK_CONTROL_50MHZ;
-		} else
-			return -EINVAL;
-
-		writel(host_ctl, host->addr + HOST_CONTROL);
-		writel(clock_ctl, host->addr + CLOCK_CONTROL);
-		pci_write_config_dword(host->chip->pdev,
-				       PCI_CTL_CLOCK_DLY_ADDR,
-				       clock_delay);
-		break;
+		return j38ms_set_interface(host, value);
+	default:
+		return -EINVAL;
 	};
-	return 0;
+}
+
+/* external interface: Submit new request from upper layer */
+static void j38ms_submit_req(struct memstick_host *msh)
+{
+	struct j38ms_host *host = memstick_priv(msh);
+	if (!host->req)
+		tasklet_schedule(&host->tasklet);
 }
 
 #ifdef CONFIG_PM
 
-static int jmb38x_ms_suspend(struct pci_dev *dev, pm_message_t state)
+static int j38ms_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	struct jmb38x_ms *jm = pci_get_drvdata(dev);
+	struct j38ms *jm = pci_get_drvdata(dev);
 	int cnt;
 
 	for (cnt = 0; cnt < jm->host_cnt; ++cnt) {
@@ -772,9 +684,9 @@ static int jmb38x_ms_suspend(struct pci_dev *dev, pm_message_t state)
 	return 0;
 }
 
-static int jmb38x_ms_resume(struct pci_dev *dev)
+static int j38ms_resume(struct pci_dev *dev)
 {
-	struct jmb38x_ms *jm = pci_get_drvdata(dev);
+	struct j38ms *jm = pci_get_drvdata(dev);
 	int rc;
 
 	pci_set_power_state(dev, PCI_D0);
@@ -799,12 +711,12 @@ static int jmb38x_ms_resume(struct pci_dev *dev)
 
 #else
 
-#define jmb38x_ms_suspend NULL
-#define jmb38x_ms_resume NULL
+#define j38ms_suspend NULL
+#define j38ms_resume NULL
 
 #endif /* CONFIG_PM */
 
-static int jmb38x_ms_count_slots(struct pci_dev *pdev)
+static int j38ms_count_slots(struct pci_dev *pdev)
 {
 	int cnt, rc = 0;
 
@@ -814,23 +726,23 @@ static int jmb38x_ms_count_slots(struct pci_dev *pdev)
 
 		if (256 != pci_resource_len(pdev, cnt))
 			break;
-
 		++rc;
 	}
 	return rc;
 }
 
-static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
+static struct memstick_host *j38ms_alloc_host(struct j38ms *jm, int cnt)
 {
 	struct memstick_host *msh;
-	struct jmb38x_ms_host *host;
+	struct j38ms_host *host;
 
-	msh = memstick_alloc_host(sizeof(struct jmb38x_ms_host),
+	msh = memstick_alloc_host(sizeof(struct j38ms_host),
 				  &jm->pdev->dev);
 	if (!msh)
 		return NULL;
 
 	host = memstick_priv(msh);
+	host->msh = msh;
 	host->chip = jm;
 	host->addr = ioremap(pci_resource_start(jm->pdev, cnt),
 			     pci_resource_len(jm->pdev, cnt));
@@ -842,39 +754,53 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 	snprintf(host->host_id, sizeof(host->host_id), DRIVER_NAME ":slot%d",
 		 host->id);
 	host->irq = jm->pdev->irq;
-	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->notify, jmb38x_ms_req_tasklet, (unsigned long)msh);
-	msh->request = jmb38x_ms_submit_req;
-	msh->set_param = jmb38x_ms_set_param;
+	msh->request = j38ms_submit_req;
+	msh->set_param = j38ms_set_param;
 
 	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
-	setup_timer(&host->timer, jmb38x_ms_abort, (unsigned long)msh);
+	host->timeout_jiffies = msecs_to_jiffies(1000);
+	setup_timer(&host->timer, j38ms_abort, (unsigned long)host);
+	tasklet_init(&host->tasklet, j38ms_submit_tasklet, (unsigned long)host);
+
+	host->dma_bounce_page = pci_alloc_consistent(
+				jm->pdev, PAGE_SIZE, &host->dma_bus_address);
 
-	if (!request_irq(host->irq, jmb38x_ms_isr, IRQF_SHARED, host->host_id,
+	if (!host->dma_bounce_page)
+		goto err_out_free;
+
+	if (!request_irq(host->irq, j38ms_isr, IRQF_SHARED, host->host_id,
 			 msh))
 		return msh;
 
 	iounmap(host->addr);
+
 err_out_free:
+	if (host->dma_bounce_page)
+		pci_free_consistent(jm->pdev, PAGE_SIZE,
+			host->dma_bounce_page, host->dma_bus_address);
 	kfree(msh);
 	return NULL;
 }
 
-static void jmb38x_ms_free_host(struct memstick_host *msh)
+static void j38ms_free_host(struct memstick_host *msh)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 
 	free_irq(host->irq, msh);
 	iounmap(host->addr);
+
+	pci_free_consistent(host->chip->pdev, PAGE_SIZE,
+		host->dma_bounce_page, host->dma_bus_address);
+
 	memstick_free_host(msh);
 }
 
-static int jmb38x_ms_probe(struct pci_dev *pdev,
+static int j38ms_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *dev_id)
 {
-	struct jmb38x_ms *jm;
+	struct j38ms *jm;
 	int pci_dev_busy = 0;
 	int rc, cnt;
 
@@ -897,14 +823,14 @@ static int jmb38x_ms_probe(struct pci_dev *pdev,
 	pci_read_config_dword(pdev, 0xac, &rc);
 	pci_write_config_dword(pdev, 0xac, rc | 0x00470000);
 
-	cnt = jmb38x_ms_count_slots(pdev);
+	cnt = j38ms_count_slots(pdev);
 	if (!cnt) {
 		rc = -ENODEV;
 		pci_dev_busy = 1;
 		goto err_out;
 	}
 
-	jm = kzalloc(sizeof(struct jmb38x_ms)
+	jm = kzalloc(sizeof(struct j38ms)
 		     + cnt * sizeof(struct memstick_host *), GFP_KERNEL);
 	if (!jm) {
 		rc = -ENOMEM;
@@ -916,14 +842,14 @@ static int jmb38x_ms_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, jm);
 
 	for (cnt = 0; cnt < jm->host_cnt; ++cnt) {
-		jm->hosts[cnt] = jmb38x_ms_alloc_host(jm, cnt);
+		jm->hosts[cnt] = j38ms_alloc_host(jm, cnt);
 		if (!jm->hosts[cnt])
 			break;
 
 		rc = memstick_add_host(jm->hosts[cnt]);
 
 		if (rc) {
-			jmb38x_ms_free_host(jm->hosts[cnt]);
+			j38ms_free_host(jm->hosts[cnt]);
 			jm->hosts[cnt] = NULL;
 			break;
 		}
@@ -944,10 +870,10 @@ err_out:
 	return rc;
 }
 
-static void jmb38x_ms_remove(struct pci_dev *dev)
+static void j38ms_remove(struct pci_dev *dev)
 {
-	struct jmb38x_ms *jm = pci_get_drvdata(dev);
-	struct jmb38x_ms_host *host;
+	struct j38ms *jm = pci_get_drvdata(dev);
+	struct j38ms_host *host;
 	int cnt;
 	unsigned long flags;
 
@@ -957,23 +883,28 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 
 		host = memstick_priv(jm->hosts[cnt]);
 
-		jm->hosts[cnt]->request = jmb38x_ms_dummy_submit;
-		tasklet_kill(&host->notify);
-		writel(0, host->addr + INT_SIGNAL_ENABLE);
-		writel(0, host->addr + INT_STATUS_ENABLE);
-		mmiowb();
-		dev_dbg(&jm->pdev->dev, "interrupts off\n");
+		tasklet_kill(&host->tasklet);
+
 		spin_lock_irqsave(&host->lock, flags);
+		host->dead = true;
+
+		j38ms_write_reg(host, INT_SIGNAL_ENABLE, 0);
+		j38ms_write_reg(host, INT_STATUS_ENABLE, 0);
+
+		mmiowb();
+		dbg(host, "interrupts off");
+
 		if (host->req) {
 			host->req->error = -ETIME;
-			jmb38x_ms_complete_cmd(jm->hosts[cnt], 1);
+			j38ms_complete_tpc(jm->hosts[cnt]);
 		}
+
 		spin_unlock_irqrestore(&host->lock, flags);
 
 		memstick_remove_host(jm->hosts[cnt]);
-		dev_dbg(&jm->pdev->dev, "host removed\n");
+		dbg(host, "host removed");
 
-		jmb38x_ms_free_host(jm->hosts[cnt]);
+		j38ms_free_host(jm->hosts[cnt]);
 	}
 
 	pci_set_drvdata(dev, NULL);
@@ -982,35 +913,41 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 	kfree(jm);
 }
 
-static struct pci_device_id jmb38x_ms_id_tbl [] = {
+static struct pci_device_id j38ms_id_tbl[] = {
 	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, 0, 0 },
 	{ }
 };
 
-static struct pci_driver jmb38x_ms_driver = {
+static struct pci_driver j38ms_driver = {
 	.name = DRIVER_NAME,
-	.id_table = jmb38x_ms_id_tbl,
-	.probe = jmb38x_ms_probe,
-	.remove = jmb38x_ms_remove,
-	.suspend = jmb38x_ms_suspend,
-	.resume = jmb38x_ms_resume
+	.id_table = j38ms_id_tbl,
+	.probe = j38ms_probe,
+	.remove = j38ms_remove,
+	.suspend = j38ms_suspend,
+	.resume = j38ms_resume
 };
 
-static int __init jmb38x_ms_init(void)
+static int __init j38ms_init(void)
 {
-	return pci_register_driver(&jmb38x_ms_driver);
+	return pci_register_driver(&j38ms_driver);
 }
 
-static void __exit jmb38x_ms_exit(void)
+static void __exit j38ms_exit(void)
 {
-	pci_unregister_driver(&jmb38x_ms_driver);
+	pci_unregister_driver(&j38ms_driver);
 }
 
 MODULE_AUTHOR("Alex Dubov");
-MODULE_DESCRIPTION("JMicron jmb38x MemoryStick driver");
+MODULE_DESCRIPTION("JMicron jm38x_ms MemoryStick driver");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, jmb38x_ms_id_tbl);
+MODULE_DEVICE_TABLE(pci, j38ms_id_tbl);
+
+module_param(debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Debug level (0-3)");
+
+module_param(no_dma, bool, 0644);
+MODULE_PARM_DESC(no_dma, "Disable the dma");
 
-module_init(jmb38x_ms_init);
-module_exit(jmb38x_ms_exit);
+module_init(j38ms_init);
+module_exit(j38ms_exit);
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
new file mode 100644
index 0000000..0d83365
--- /dev/null
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -0,0 +1,200 @@
+/*
+ *  jmb38x_ms.c - JMicron jmb38x MemoryStick card reader
+ *
+ *  Copyright (C) 2008 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#define DRIVER_NAME "jmb38x_ms"
+
+/* physical address of a page for DMA */
+#define	DMA_ADDRESS            0x00
+
+/* controls the size of the TPC */
+#define	BLOCK                  0x04
+#define BLOCK_COUNT_MASK        0xffff0000
+#define BLOCK_COUNT_1BLOCK      0x00010000
+#define BLOCK_SIZE_MASK         0x00000fff
+
+/* Enables the DMA */
+#define	DMA_CONTROL            0x08
+#define DMA_CONTROL_ENABLE      0x00000001
+
+/* A window for small TPCs to send the contents inline */
+#define	TPC_P0                 0x0c
+#define	TPC_P1                 0x10
+
+/* TPC execution register */
+#define	TPC                    0x14
+#define TPC_DATA_SEL            0x00008000
+#define TPC_DIR                 0x00004000
+#define TPC_WAIT_INT            0x00002000
+#define TPC_GET_INT             0x00000800
+#define TPC_CODE_SZ_MASK        0x00000700
+#define TPC_DATA_SZ_MASK        0x00000007
+
+/* General device settings */
+#define	HOST_CONTROL           0x18
+#define HOST_CONTROL_TDELAY_EN  0x00040000
+#define HOST_CONTROL_HW_OC_P    0x00010000
+#define HOST_CONTROL_RESET_REQ  0x00008000
+#define HOST_CONTROL_REI        0x00004000
+#define HOST_CONTROL_LED        0x00000400
+#define HOST_CONTROL_FAST_CLK   0x00000200
+#define HOST_CONTROL_RESET      0x00000100
+#define HOST_CONTROL_POWER_EN   0x00000080
+#define HOST_CONTROL_IF_PAR4    0x00000010
+#define HOST_CONTROL_IF_PAR8    0x00000030
+#define HOST_CONTROL_IF_MASK    0x00000030
+#define HOST_CONTROL_CLOCK_EN   0x00000040
+#define HOST_CONTROL_REO        0x00000008
+#define HOST_CONTROL_BSY_TIME	0x00000007
+#define HOST_CONTROL_IF_SERIAL  0x00000000
+
+/* IO window for PIO access to internal FIFO*/
+#define	DATA                   0x1c
+
+/* MS status */
+#define	STATUS                 0x20
+#define STATUS_BUSY             0x00080000
+#define STATUS_MS_DAT7          0x00040000
+#define STATUS_MS_DAT6          0x00020000
+#define STATUS_MS_DAT5          0x00010000
+#define STATUS_MS_DAT4          0x00008000
+#define STATUS_MS_DAT3          0x00004000
+#define STATUS_MS_DAT2          0x00002000
+#define STATUS_MS_DAT1          0x00001000
+#define STATUS_MS_DAT0          0x00000800
+#define STATUS_HAS_MEDIA        0x00000400
+#define STATUS_FIFO_EMPTY       0x00000200
+#define STATUS_FIFO_FULL        0x00000100
+#define STATUS_MS_CED           0x00000080
+#define STATUS_MS_ERR           0x00000040
+#define STATUS_MS_BRQ           0x00000020
+#define STATUS_MS_CNK           0x00000001
+
+/* Device status */
+#define	INT_STATUS             0x24
+#define INT_STATUS_TPC_ERR      0x00080000
+#define INT_STATUS_CRC_ERR      0x00040000
+#define INT_STATUS_TIMER_TO     0x00020000
+#define INT_STATUS_HSK_TO       0x00010000
+#define INT_STATUS_ANY_ERR      0x00008000
+#define INT_STATUS_FIFO_WRDY    0x00000080
+#define INT_STATUS_FIFO_RRDY    0x00000040
+#define INT_STATUS_MEDIA_OUT    0x00000010
+#define INT_STATUS_MEDIA_IN     0x00000008
+#define INT_STATUS_DMA_BOUNDARY 0x00000004
+#define INT_STATUS_EOTRAN       0x00000002
+#define INT_STATUS_EOTPC        0x00000001
+#define INT_STATUS_ALL          0x000f801f
+
+/* Interrupt enable - ???*/
+#define	INT_STATUS_ENABLE      0x28
+
+/* Interrupt enable*/
+#define	INT_SIGNAL_ENABLE      0x2c
+
+/* Current timer value */
+#define	TIMER                  0x30
+
+/* Enable/disable the timer */
+#define	TIMER_CONTROL          0x34
+
+/* Output pad enable */
+#define	PAD_OUTPUT_ENABLE      0x38
+#define PAD_OUTPUT_ENABLE_MS    0x0F3F
+
+/* Ouput pad pull-up, pull-down control */
+#define	PAD_PU_PD              0x3c
+#define PAD_PU_PD_OFF           0x7fff0000
+#define PAD_PU_PD_ON_MS_SOCK0   0x5f8f0000
+#define PAD_PU_PD_ON_MS_SOCK1   0x0f0f0000
+
+/* Internal clock delay */
+#define	CLOCK_DELAY            0x40
+
+/* ??? */
+#define	ADMA_ADDRESS           0x44
+
+/* Set the device clock */
+#define	CLOCK_CONTROL          0x48
+#define CLOCK_CONTROL_RESET     0x00000008
+#define CLOCK_CONTROL_40MHZ     0x00000009
+#define CLOCK_CONTROL_50MHZ     0x0000000a
+#define CLOCK_CONTROL_62_5MHZ   0x0000000c
+#define CLOCK_CONTROL_OFF       0x00000000
+
+/* Led blink period */
+#define	LED_CONTROL            0x4c
+
+/* Hardware version */
+#define	VERSION                0x50
+
+#define PCI_CTL_CLOCK_DLY_ADDR   0x000000b0
+#define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
+#define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
+
+struct j38ms_host {
+	struct j38ms            *chip;
+	struct memstick_host    *msh;
+	void __iomem            *addr;
+	bool                    dead;
+	spinlock_t              lock;
+	int                     id;
+	char                    host_id[32];
+	int                     irq;
+	struct memstick_request *req;
+	unsigned char           cmd_flags;
+	struct timer_list       timer;
+	struct tasklet_struct	tasklet;
+	unsigned long		timeout_jiffies;
+	int                     interface;
+
+	/* PIO state */
+	struct sg_mapping_iter  pio_sg_iter;
+	unsigned char		pio_offset;
+	unsigned char           pio_tmp_buf[4];
+	unsigned int            pio_tmp_buf_len;
+
+	/* DMA bounce buffer */
+	void			*dma_bounce_page;
+	dma_addr_t		dma_bus_address;
+
+};
+
+struct j38ms {
+	struct pci_dev        *pdev;
+	int                   host_cnt;
+	struct memstick_host  *hosts[];
+};
+
+enum {
+	CMD_READY    = 0x01,
+	FIFO_READY   = 0x02,
+
+	REG_DATA     = 0x04,
+	DMA_DATA     = 0x08,
+	PIO_DATA     = 0x10
+};
+
+#define __dbg(host, level, format, ...) \
+	do { \
+		if (debug >= level) \
+			printk(KERN_DEBUG \
+				"%s: " format "\n", dev_name(&host->msh->dev) \
+					 , ## __VA_ARGS__); \
+		else \
+			dev_dbg(&host->msh->dev, format, ## __VA_ARGS__); \
+	} while (0)
+
+#define dbg(host, format, ...)		__dbg(host, 1, format, ## __VA_ARGS__)
+#define dbg_v(host, format, ...)	__dbg(host, 2, format, ## __VA_ARGS__)
+#define dbg_reg(host, format, ...)	__dbg(host, 3, format, ## __VA_ARGS__)
+
+static void j38ms_next_request(struct j38ms_host *host);
-- 
1.7.1


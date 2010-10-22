Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab0JVX5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:57:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab0JVXyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X0x8E+tn9DWTobPR3Fte6hWjpek+RFclgMe4jKSqfuHl/KZyytrzd19Tiwb0P9NepD
         d+7GEtlWLoiBLP4KI0PNf3F+S5C3tsLzXkFKj2n8A/P7y6kT/0HS8kOgWjdW+IBDKMJr
         2SPxlBEupoYfDbl2IvV1YPQJqgj8SLxMeEx2c=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 20/29] memstick: jmb38x_ms: rework PIO
Date: Sat, 23 Oct 2010 01:53:48 +0200
Message-Id: <1287791637-10329-21-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite PIO code to be just simplier and shorter,
and comment not so obivous parts.

Signed-off-by: Maxim Levitsky<maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  283 +++++++++++++------------------------
 drivers/memstick/host/jmb38x_ms.h |   17 +--
 2 files changed, 103 insertions(+), 197 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index bcdb785..5af0a52 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -17,6 +17,7 @@
 #include <linux/highmem.h>
 #include <linux/memstick.h>
 #include <linux/slab.h>
+#include <linux/scatterlist.h>
 #include "jmb38x_ms.h"
 
 static int no_dma;
@@ -103,39 +104,34 @@ static inline int j38ms_write_fifo_dword_pio(struct j38ms_host *host, u32 dword)
 static unsigned int j38ms_read_fifo_pio(struct j38ms_host *host,
 				unsigned char *buf, unsigned int length)
 {
-	unsigned int off = 0;
+	unsigned int orig_len = length;
+	unsigned char tmp_buf[4];
 
-	while (host->io_pos && length) {
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
 
-	while (!(STATUS_FIFO_EMPTY & readl(host->addr + STATUS))) {
-		if (length < 4)
-			break;
-		*(unsigned int *)(buf + off) = __raw_readl(host->addr + DATA);
-		length -= 4;
-		off += 4;
-	}
+	/* Read last 4 bytes, and
+			save unconsumed part of it to the pio_tmp_buf */
+	if (length && !j38ms_read_fifo_dword_pio(host, (u32 *)tmp_buf)) {
 
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
+		host->pio_tmp_buf_len = 4 - length;
+		memcpy(buf, tmp_buf, length);
+		memcpy(host->pio_tmp_buf,
+				tmp_buf + length, host->pio_tmp_buf_len);
+		length = 0;
 	}
 
-	return off;
+	return orig_len - length;
 }
 
 /* Write TPC data through normal PIO fifo */
@@ -143,175 +139,106 @@ static unsigned int j38ms_write_fifo_pio(struct j38ms_host *host,
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
-
-		__raw_writel(*(unsigned int *)(buf + off),
-			     host->addr + DATA);
-		length -= 4;
-		off += 4;
-	}
+	/* Write aligned data to hardware */
+	for (; length >= 4 ; length -= 4, buf += 4)
+		if (j38ms_write_fifo_dword_pio(host, *(u32 *)buf))
+			return orig_len - length;
 
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
+	/* Save last 3-1 bytes to buffer, because we can't send them now*/
+	if (length) {
+		memset(host->pio_tmp_buf, 0, 4);
+		memcpy(host->pio_tmp_buf, buf, length);
+		host->pio_tmp_buf_len = length;
 	}
 
-	off += host->io_pos;
-
-	return off;
+	return orig_len - length;
 }
 
+
 /* Transfer data between current request and FIFO */
-static int j38ms_transfer_data(struct j38ms_host *host)
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
-				 ? j38ms_write_fifo_pio(host, buf, p_cnt)
-				 : j38ms_write_tpc_inline(host, buf, p_cnt);
-		else
-			t_size = !(host->cmd_flags & REG_DATA)
-				 ? j38ms_read_fifo_pio(host, buf, p_cnt)
-				 : j38ms_read_tpc_inline(host, buf, p_cnt);
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
+	}
+exit:
+	if (host->req->long_data) {
+		sg_miter_stop(&host->pio_sg_iter);
+		local_irq_restore(flags);
 	}
-
-	return length;
 }
 
 /* Read short TPC data (up to 8 bytes) via 2 special registers*/
-static unsigned int j38ms_read_tpc_inline(struct j38ms_host *host,
-					    unsigned char *buf,
-					    unsigned int length)
+static void j38ms_read_tpc_inline(struct j38ms_host *host)
 {
-	unsigned int off = 0;
-
-	while (host->io_pos > 4 && length) {
-		buf[off++] = host->io_word[0] & 0xff;
-		host->io_word[0] >>= 8;
-		length--;
-		host->io_pos--;
-	}
-
-	if (!length)
-		return off;
-
-	while (host->io_pos && length) {
-		buf[off++] = host->io_word[1] & 0xff;
-		host->io_word[1] >>= 8;
-		length--;
-		host->io_pos--;
-	}
-
-	return off;
+       *(u32 *)(host->req->data + 0) = j38ms_read_reg_raw(host, TPC_P0);
+       *(u32 *)(host->req->data + 4) = j38ms_read_reg_raw(host, TPC_P1);
 }
 
 /* Write short TPC data (up to 8 bytes) through 2 special registers */
-static unsigned int j38ms_write_tpc_inline(struct j38ms_host *host,
-					     unsigned char *buf,
-					     unsigned int length)
+static void j38ms_write_tpc_inline(struct j38ms_host *host)
 {
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
-
-	return off;
+	j38ms_write_reg_raw(host, TPC_P0, *(u32 *)(host->req->data + 0));
+	j38ms_write_reg_raw(host, TPC_P1, *(u32 *)(host->req->data + 4));
 }
 
 /*
@@ -344,10 +271,6 @@ static int j38ms_execute_tpc(struct memstick_host *msh)
 	dev_dbg(&msh->dev, "hstatus %08x\n", readl(host->addr + STATUS));
 
 	host->cmd_flags = 0;
-	host->block_pos = 0;
-	host->io_pos = 0;
-	host->io_word[0] = 0;
-	host->io_word[1] = 0;
 
 	cmd = host->req->tpc << 16;
 	cmd |= TPC_DATA_SEL;
@@ -407,11 +330,8 @@ static int j38ms_execute_tpc(struct memstick_host *msh)
 		host->cmd_flags |= REG_DATA;
 		cmd |= data_len & 0xf;
 
-		if (host->req->data_dir == WRITE) {
-			j38ms_transfer_data(host);
-			writel(host->io_word[0], host->addr + TPC_P0);
-			writel(host->io_word[1], host->addr + TPC_P1);
-		}
+		if (host->req->data_dir == WRITE)
+			j38ms_write_tpc_inline(host);
 	}
 
 	mod_timer(&host->timer, jiffies + host->timeout_jiffies);
@@ -504,10 +424,10 @@ static irqreturn_t j38ms_isr(int irq, void *dev_id)
 			} else {
 				if (irq_status & (INT_STATUS_FIFO_RRDY
 						  | INT_STATUS_FIFO_WRDY))
-					j38ms_transfer_data(host);
+					j38ms_transfer_pio(host);
 
 				if (irq_status & INT_STATUS_EOTRAN) {
-					j38ms_transfer_data(host);
+					j38ms_transfer_pio(host);
 					host->cmd_flags |= FIFO_READY;
 				}
 			}
@@ -515,17 +435,8 @@ static irqreturn_t j38ms_isr(int irq, void *dev_id)
 			if (irq_status & INT_STATUS_EOTPC) {
 				host->cmd_flags |= CMD_READY;
 				if (host->cmd_flags & REG_DATA) {
-					if (host->req->data_dir == READ) {
-						host->io_word[0]
-							= readl(host->addr
-								+ TPC_P0);
-						host->io_word[1]
-							= readl(host->addr
-								+ TPC_P1);
-						host->io_pos = 8;
-
-						j38ms_transfer_data(host);
-					}
+					if (host->req->data_dir == READ)
+						j38ms_read_tpc_inline(host);
 					host->cmd_flags |= FIFO_READY;
 				}
 			}
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index 35b8bca..d7dffb6 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -151,13 +151,16 @@ struct j38ms_host {
 	int                     id;
 	char                    host_id[32];
 	int                     irq;
-	unsigned int            block_pos;
 	unsigned long           timeout_jiffies;
 	struct timer_list       timer;
 	struct memstick_request *req;
 	unsigned char           cmd_flags;
-	unsigned char           io_pos;
-	unsigned int            io_word[2];
+
+	/* PIO state */
+	struct sg_mapping_iter  pio_sg_iter;
+	unsigned char		pio_offset;
+	unsigned char           pio_tmp_buf[4];
+	unsigned int            pio_tmp_buf_len;
 };
 
 struct j38ms {
@@ -187,11 +190,3 @@ enum {
 #define dbg(host, format, ...)		__dbg(host, 1, format, ## __VA_ARGS__)
 #define dbg_v(host, format, ...)	__dbg(host, 2, format, ## __VA_ARGS__)
 #define dbg_reg(host, format, ...)	__dbg(host, 3, format, ## __VA_ARGS__)
-
-static unsigned int j38ms_read_tpc_inline(struct j38ms_host *host,
-					    unsigned char *buf,
-					    unsigned int length);
-
-static unsigned int j38ms_write_tpc_inline(struct j38ms_host *host,
-					     unsigned char *buf,
-					     unsigned int length);
-- 
1.7.1


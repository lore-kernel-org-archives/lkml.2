Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab1FXNOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:14:10 -0400
Received: from multi.imgtec.com ([194.200.65.239]:1467 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1FXNOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:14:08 -0400
Message-ID: <4E0489D4.1040607@imgtec.com>
Date: Fri, 24 Jun 2011 13:57:56 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Subject: [PATCH 6/6] mmc: dw_mmc: handle unaligned buffers and sizes
References: <4E0488A9.6050109@imgtec.com>
In-Reply-To: <4E0488A9.6050109@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:57:57.0335 (UTC) FILETIME=[56F15670:01CC326E]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_57_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update functions for PIO pushing and pulling data to and from the FIFO
so that they can handle unaligned output buffers and unaligned buffer
lengths. This makes more of the tests in mmc_test pass.

Unaligned lengths in pulls are handled by reading the full FIFO item,
and storing the remaining bytes in a small internal buffer (part_buf).
The next data pull will copy data out of this buffer first before
accessing the FIFO again. Similarly, for pushes the final bytes that
don't fill a FIFO item are stored in the part_buf (or sent anyway if
it's the last transfer), and then the part_buf is included at the
beginning of the next buffer pushed.

Unaligned buffers in pulls are handled specially if the architecture
cannot do efficient unaligned accesses, by reading FIFO items into a
aligned local buffer, and memcpy'ing them into the output buffer, again
storing any remaining bytes in the internal buffer. Similarly for pushes
the buffer is memcpy'd into an aligned local buffer then written to the
FIFO.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c  |  309 ++++++++++++++++++++++++++++++++++++--------
 include/linux/mmc/dw_mmc.h |   10 ++
 2 files changed, 262 insertions(+), 57 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 3832312..10b6979 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -495,6 +495,8 @@ static void dw_mci_submit_data(struct dw_mci *host, struct mmc_data *data)
 	if (dw_mci_submit_data_dma(host, data)) {
 		host->sg = data->sg;
 		host->pio_offset = 0;
+		host->part_buf_start = 0;
+		host->part_buf_count = 0;
 		if (data->flags & MMC_DATA_READ)
 			host->dir_status = DW_MCI_RECV_STATUS;
 		else
@@ -957,84 +959,278 @@ unlock:
 
 }
 
-static void dw_mci_push_data16(struct dw_mci *host, void *buf, int cnt)
+/* push final bytes to part_buf, only use during push */
+static void dw_mci_set_part_bytes(struct dw_mci *host, void *buf, int cnt)
 {
-	u16 *pdata = (u16 *)buf;
+	memcpy((void *)&host->part_buf, buf, cnt);
+	host->part_buf_count = cnt;
+}
 
-	WARN_ON(cnt % 2 != 0);
+/* append bytes to part_buf, only use during push */
+static int dw_mci_push_part_bytes(struct dw_mci *host, void *buf, int cnt)
+{
+	cnt = min(cnt, (1 << host->data_shift) - host->part_buf_count);
+	memcpy((void *)&host->part_buf + host->part_buf_count, buf, cnt);
+	host->part_buf_count += cnt;
+	return cnt;
+}
 
-	cnt = cnt >> 1;
-	while (cnt > 0) {
-		mci_writew(host, DATA, *pdata++);
-		cnt--;
+/* pull first bytes from part_buf, only use during pull */
+static int dw_mci_pull_part_bytes(struct dw_mci *host, void *buf, int cnt)
+{
+	cnt = min(cnt, (int)host->part_buf_count);
+	if (cnt) {
+		memcpy(buf, (void *)&host->part_buf + host->part_buf_start,
+		       cnt);
+		host->part_buf_count -= cnt;
+		host->part_buf_start += cnt;
 	}
+	return cnt;
 }
 
-static void dw_mci_pull_data16(struct dw_mci *host, void *buf, int cnt)
+/* pull final bytes from the part_buf, assuming it's just been filled */
+static void dw_mci_pull_final_bytes(struct dw_mci *host, void *buf, int cnt)
 {
-	u16 *pdata = (u16 *)buf;
+	memcpy(buf, &host->part_buf, cnt);
+	host->part_buf_start = cnt;
+	host->part_buf_count = (1 << host->data_shift) - cnt;
+}
 
-	WARN_ON(cnt % 2 != 0);
+static void dw_mci_push_data16(struct dw_mci *host, void *buf, int cnt)
+{
+	/* try and push anything in the part_buf */
+	if (unlikely(host->part_buf_count)) {
+		int len = dw_mci_push_part_bytes(host, buf, cnt);
+		buf += len;
+		cnt -= len;
+		if (!sg_next(host->sg) || host->part_buf_count == 2) {
+			mci_writew(host, DATA, host->part_buf16);
+			host->part_buf_count = 0;
+		}
+	}
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x1)) {
+		while (cnt >= 2) {
+			u16 aligned_buf[64];
+			int len = min(cnt & -2, (int)sizeof(aligned_buf));
+			int items = len >> 1;
+			int i;
+			/* memcpy from input buffer into aligned buffer */
+			memcpy(aligned_buf, buf, len);
+			buf += len;
+			cnt -= len;
+			/* push data from aligned buffer into fifo */
+			for (i = 0; i < items; ++i)
+				mci_writew(host, DATA, aligned_buf[i]);
+		}
+	} else
+#endif
+	{
+		u16 *pdata = buf;
+		for (; cnt >= 2; cnt -= 2)
+			mci_writew(host, DATA, *pdata++);
+		buf = pdata;
+	}
+	/* put anything remaining in the part_buf */
+	if (cnt) {
+		dw_mci_set_part_bytes(host, buf, cnt);
+		if (!sg_next(host->sg))
+			mci_writew(host, DATA, host->part_buf16);
+	}
+}
 
-	cnt = cnt >> 1;
-	while (cnt > 0) {
-		*pdata++ = mci_readw(host, DATA);
-		cnt--;
+static void dw_mci_pull_data16(struct dw_mci *host, void *buf, int cnt)
+{
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x1)) {
+		while (cnt >= 2) {
+			/* pull data from fifo into aligned buffer */
+			u16 aligned_buf[64];
+			int len = min(cnt & -2, (int)sizeof(aligned_buf));
+			int items = len >> 1;
+			int i;
+			for (i = 0; i < items; ++i)
+				aligned_buf[i] = mci_readw(host, DATA);
+			/* memcpy from aligned buffer into output buffer */
+			memcpy(buf, aligned_buf, len);
+			buf += len;
+			cnt -= len;
+		}
+	} else
+#endif
+	{
+		u16 *pdata = buf;
+		for (; cnt >= 2; cnt -= 2)
+			*pdata++ = mci_readw(host, DATA);
+		buf = pdata;
+	}
+	if (cnt) {
+		host->part_buf16 = mci_readw(host, DATA);
+		dw_mci_pull_final_bytes(host, buf, cnt);
 	}
 }
 
 static void dw_mci_push_data32(struct dw_mci *host, void *buf, int cnt)
 {
-	u32 *pdata = (u32 *)buf;
-
-	WARN_ON(cnt % 4 != 0);
-	WARN_ON((unsigned long)pdata & 0x3);
-
-	cnt = cnt >> 2;
-	while (cnt > 0) {
-		mci_writel(host, DATA, *pdata++);
-		cnt--;
+	/* try and push anything in the part_buf */
+	if (unlikely(host->part_buf_count)) {
+		int len = dw_mci_push_part_bytes(host, buf, cnt);
+		buf += len;
+		cnt -= len;
+		if (!sg_next(host->sg) || host->part_buf_count == 4) {
+			mci_writel(host, DATA, host->part_buf32);
+			host->part_buf_count = 0;
+		}
+	}
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x3)) {
+		while (cnt >= 4) {
+			u32 aligned_buf[32];
+			int len = min(cnt & -4, (int)sizeof(aligned_buf));
+			int items = len >> 2;
+			int i;
+			/* memcpy from input buffer into aligned buffer */
+			memcpy(aligned_buf, buf, len);
+			buf += len;
+			cnt -= len;
+			/* push data from aligned buffer into fifo */
+			for (i = 0; i < items; ++i)
+				mci_writel(host, DATA, aligned_buf[i]);
+		}
+	} else
+#endif
+	{
+		u32 *pdata = buf;
+		for (; cnt >= 4; cnt -= 4)
+			mci_writel(host, DATA, *pdata++);
+		buf = pdata;
+	}
+	/* put anything remaining in the part_buf */
+	if (cnt) {
+		dw_mci_set_part_bytes(host, buf, cnt);
+		if (!sg_next(host->sg))
+			mci_writel(host, DATA, host->part_buf32);
 	}
 }
 
 static void dw_mci_pull_data32(struct dw_mci *host, void *buf, int cnt)
 {
-	u32 *pdata = (u32 *)buf;
-
-	WARN_ON(cnt % 4 != 0);
-	WARN_ON((unsigned long)pdata & 0x3);
-
-	cnt = cnt >> 2;
-	while (cnt > 0) {
-		*pdata++ = mci_readl(host, DATA);
-		cnt--;
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x3)) {
+		while (cnt >= 4) {
+			/* pull data from fifo into aligned buffer */
+			u32 aligned_buf[32];
+			int len = min(cnt & -4, (int)sizeof(aligned_buf));
+			int items = len >> 2;
+			int i;
+			for (i = 0; i < items; ++i)
+				aligned_buf[i] = mci_readl(host, DATA);
+			/* memcpy from aligned buffer into output buffer */
+			memcpy(buf, aligned_buf, len);
+			buf += len;
+			cnt -= len;
+		}
+	} else
+#endif
+	{
+		u32 *pdata = buf;
+		for (; cnt >= 4; cnt -= 4)
+			*pdata++ = mci_readl(host, DATA);
+		buf = pdata;
+	}
+	if (cnt) {
+		host->part_buf32 = mci_readl(host, DATA);
+		dw_mci_pull_final_bytes(host, buf, cnt);
 	}
 }
 
 static void dw_mci_push_data64(struct dw_mci *host, void *buf, int cnt)
 {
-	u64 *pdata = (u64 *)buf;
-
-	WARN_ON(cnt % 8 != 0);
-
-	cnt = cnt >> 3;
-	while (cnt > 0) {
-		mci_writeq(host, DATA, *pdata++);
-		cnt--;
+	/* try and push anything in the part_buf */
+	if (unlikely(host->part_buf_count)) {
+		int len = dw_mci_push_part_bytes(host, buf, cnt);
+		buf += len;
+		cnt -= len;
+		if (!sg_next(host->sg) || host->part_buf_count == 8) {
+			mci_writew(host, DATA, host->part_buf);
+			host->part_buf_count = 0;
+		}
+	}
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x7)) {
+		while (cnt >= 8) {
+			u64 aligned_buf[16];
+			int len = min(cnt & -8, (int)sizeof(aligned_buf));
+			int items = len >> 3;
+			int i;
+			/* memcpy from input buffer into aligned buffer */
+			memcpy(aligned_buf, buf, len);
+			buf += len;
+			cnt -= len;
+			/* push data from aligned buffer into fifo */
+			for (i = 0; i < items; ++i)
+				mci_writeq(host, DATA, aligned_buf[i]);
+		}
+	} else
+#endif
+	{
+		u64 *pdata = buf;
+		for (; cnt >= 8; cnt -= 8)
+			mci_writeq(host, DATA, *pdata++);
+		buf = pdata;
+	}
+	/* put anything remaining in the part_buf */
+	if (cnt) {
+		dw_mci_set_part_bytes(host, buf, cnt);
+		if (!sg_next(host->sg))
+			mci_writeq(host, DATA, host->part_buf);
 	}
 }
 
 static void dw_mci_pull_data64(struct dw_mci *host, void *buf, int cnt)
 {
-	u64 *pdata = (u64 *)buf;
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x7)) {
+		while (cnt >= 8) {
+			/* pull data from fifo into aligned buffer */
+			u64 aligned_buf[16];
+			int len = min(cnt & -8, (int)sizeof(aligned_buf));
+			int items = len >> 3;
+			int i;
+			for (i = 0; i < items; ++i)
+				aligned_buf[i] = mci_readq(host, DATA);
+			/* memcpy from aligned buffer into output buffer */
+			memcpy(buf, aligned_buf, len);
+			buf += len;
+			cnt -= len;
+		}
+	} else
+#endif
+	{
+		u64 *pdata = buf;
+		for (; cnt >= 8; cnt -= 8)
+			*pdata++ = mci_readq(host, DATA);
+		buf = pdata;
+	}
+	if (cnt) {
+		host->part_buf = mci_readq(host, DATA);
+		dw_mci_pull_final_bytes(host, buf, cnt);
+	}
+}
+
+static void dw_mci_pull_data(struct dw_mci *host, void *buf, int cnt)
+{
+	int len;
 
-	WARN_ON(cnt % 8 != 0);
+	/* get remaining partial bytes */
+	len = dw_mci_pull_part_bytes(host, buf, cnt);
+	if (unlikely(len == cnt))
+		return;
+	buf += len;
+	cnt -= len;
 
-	cnt = cnt >> 3;
-	while (cnt > 0) {
-		*pdata++ = mci_readq(host, DATA);
-		cnt--;
-	}
+	/* get the rest of the data */
+	host->pull_data(host, buf, cnt);
 }
 
 static void dw_mci_read_data_pio(struct dw_mci *host)
@@ -1048,9 +1244,10 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 	unsigned int nbytes = 0, len;
 
 	do {
-		len = SDMMC_GET_FCNT(mci_readl(host, STATUS)) << shift;
+		len = host->part_buf_count +
+			(SDMMC_GET_FCNT(mci_readl(host, STATUS)) << shift);
 		if (offset + len <= sg->length) {
-			host->pull_data(host, (void *)(buf + offset), len);
+			dw_mci_pull_data(host, (void *)(buf + offset), len);
 
 			offset += len;
 			nbytes += len;
@@ -1066,8 +1263,8 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 			}
 		} else {
 			unsigned int remaining = sg->length - offset;
-			host->pull_data(host, (void *)(buf + offset),
-					remaining);
+			dw_mci_pull_data(host, (void *)(buf + offset),
+					 remaining);
 			nbytes += remaining;
 
 			flush_dcache_page(sg_page(sg));
@@ -1077,7 +1274,7 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 
 			offset = len - remaining;
 			buf = sg_virt(sg);
-			host->pull_data(host, buf, offset);
+			dw_mci_pull_data(host, buf, offset);
 			nbytes += offset;
 		}
 
@@ -1094,7 +1291,6 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 			return;
 		}
 	} while (status & SDMMC_INT_RXDR); /*if the RXDR is ready read again*/
-	len = SDMMC_GET_FCNT(mci_readl(host, STATUS));
 	host->pio_offset = offset;
 	data->bytes_xfered += nbytes;
 	return;
@@ -1116,8 +1312,9 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 	unsigned int nbytes = 0, len;
 
 	do {
-		len = (host->fifo_depth -
-			SDMMC_GET_FCNT(mci_readl(host, STATUS))) << shift;
+		len = ((host->fifo_depth -
+			SDMMC_GET_FCNT(mci_readl(host, STATUS))) << shift)
+			- host->part_buf_count;
 		if (offset + len <= sg->length) {
 			host->push_data(host, (void *)(buf + offset), len);
 
@@ -1162,10 +1359,8 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 			return;
 		}
 	} while (status & SDMMC_INT_TXDR); /* if TXDR write again */
-
 	host->pio_offset = offset;
 	data->bytes_xfered += nbytes;
-
 	return;
 
 done:
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 01db1a0..f3f68ee 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -76,6 +76,9 @@ struct mmc_data;
  * @slot: Slots sharing this MMC controller.
  * @fifo_depth: depth of FIFO.
  * @data_shift: log2 of FIFO item size.
+ * @part_buf_start: Start index in part_buf.
+ * @part_buf_count: Bytes of partial data in part_buf.
+ * @part_buf: Simple buffer for partial fifo reads/writes.
  * @push_data: Pointer to FIFO push function.
  * @pull_data: Pointer to FIFO pull function.
  * @quirks: Set of quirks that apply to specific versions of the IP.
@@ -149,6 +152,13 @@ struct dw_mci {
 	/* FIFO push and pull */
 	int			fifo_depth;
 	int			data_shift;
+	u8			part_buf_start;
+	u8			part_buf_count;
+	union {
+		u16		part_buf16;
+		u32		part_buf32;
+		u64		part_buf;
+	};
 	void (*push_data)(struct dw_mci *host, void *buf, int cnt);
 	void (*pull_data)(struct dw_mci *host, void *buf, int cnt);
 
-- 
1.7.2.3


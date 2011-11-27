Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1K0Fcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:32:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab1K0FcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:32:25 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, Alex Dubov <oakad@yahoo.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 20/62] mmc: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:00 +0800
Message-Id: <1322371662-26166-21-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/mmc/host/at91_mci.c |    8 ++++----
 drivers/mmc/host/msm_sdcc.c |    6 +++---
 drivers/mmc/host/sdhci.c    |    4 ++--
 drivers/mmc/host/tifm_sd.c  |   16 ++++++++--------
 drivers/mmc/host/tmio_mmc.c |    1 -
 drivers/mmc/host/tmio_mmc.h |    4 ++--
 6 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index a8b4d2a..9a32922 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -236,7 +236,7 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 
 		sg = &data->sg[i];
 
-		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+		sgbuffer = kmap_atomic(sg_page(sg)) + sg->offset;
 		amount = min(size, sg->length);
 		size -= amount;
 
@@ -252,7 +252,7 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer);
 
 		if (size == 0)
 			break;
@@ -302,7 +302,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 
 		sg = &data->sg[i];
 
-		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+		sgbuffer = kmap_atomic(sg_page(sg)) + sg->offset;
 		amount = min(size, sg->length);
 		size -= amount;
 
@@ -318,7 +318,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 		}
 
 		flush_kernel_dcache_page(sg_page(sg));
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(sgbuffer);
 		data->bytes_xfered += amount;
 		if (size == 0)
 			break;
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 80d8eb1..62faa4a 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -689,8 +689,8 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 
 		/* Map the current scatter buffer */
 		local_irq_save(flags);
-		buffer = kmap_atomic(sg_page(host->pio.sg),
-				     KM_BIO_SRC_IRQ) + host->pio.sg->offset;
+		buffer = kmap_atomic(sg_page(host->pio.sg))
+				     + host->pio.sg->offset;
 		buffer += host->pio.sg_off;
 		remain = host->pio.sg->length - host->pio.sg_off;
 		len = 0;
@@ -700,7 +700,7 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 			len = msmsdcc_pio_write(host, buffer, remain, status);
 
 		/* Unmap the buffer */
-		kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+		kunmap_atomic(buffer);
 		local_irq_restore(flags);
 
 		host->pio.sg_off += len;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6d8eea3..2cc9e29 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -423,12 +423,12 @@ static void sdhci_transfer_pio(struct sdhci_host *host)
 static char *sdhci_kmap_atomic(struct scatterlist *sg, unsigned long *flags)
 {
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+	return kmap_atomic(sg_page(sg)) + sg->offset;
 }
 
 static void sdhci_kunmap_atomic(void *buffer, unsigned long *flags)
 {
-	kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
+	kunmap_atomic(buffer);
 	local_irq_restore(*flags);
 }
 
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index f70d046..fc00081 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -118,7 +118,7 @@ static void tifm_sd_read_fifo(struct tifm_sd *host, struct page *pg,
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg, KM_BIO_DST_IRQ) + off;
+	buf = kmap_atomic(pg) + off;
 	if (host->cmd_flags & DATA_CARRY) {
 		buf[pos++] = host->bounce_buf_data[0];
 		host->cmd_flags &= ~DATA_CARRY;
@@ -134,7 +134,7 @@ static void tifm_sd_read_fifo(struct tifm_sd *host, struct page *pg,
 		}
 		buf[pos++] = (val >> 8) & 0xff;
 	}
-	kunmap_atomic(buf - off, KM_BIO_DST_IRQ);
+	kunmap_atomic(buf - off);
 }
 
 static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
@@ -144,7 +144,7 @@ static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
 	unsigned char *buf;
 	unsigned int pos = 0, val;
 
-	buf = kmap_atomic(pg, KM_BIO_SRC_IRQ) + off;
+	buf = kmap_atomic(pg) + off;
 	if (host->cmd_flags & DATA_CARRY) {
 		val = host->bounce_buf_data[0] | ((buf[pos++] << 8) & 0xff00);
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
@@ -161,7 +161,7 @@ static void tifm_sd_write_fifo(struct tifm_sd *host, struct page *pg,
 		val |= (buf[pos++] << 8) & 0xff00;
 		writel(val, sock->addr + SOCK_MMCSD_DATA);
 	}
-	kunmap_atomic(buf - off, KM_BIO_SRC_IRQ);
+	kunmap_atomic(buf - off);
 }
 
 static void tifm_sd_transfer_data(struct tifm_sd *host)
@@ -212,13 +212,13 @@ static void tifm_sd_copy_page(struct page *dst, unsigned int dst_off,
 			      struct page *src, unsigned int src_off,
 			      unsigned int count)
 {
-	unsigned char *src_buf = kmap_atomic(src, KM_BIO_SRC_IRQ) + src_off;
-	unsigned char *dst_buf = kmap_atomic(dst, KM_BIO_DST_IRQ) + dst_off;
+	unsigned char *src_buf = kmap_atomic(src) + src_off;
+	unsigned char *dst_buf = kmap_atomic(dst) + dst_off;
 
 	memcpy(dst_buf, src_buf, count);
 
-	kunmap_atomic(dst_buf - dst_off, KM_BIO_DST_IRQ);
-	kunmap_atomic(src_buf - src_off, KM_BIO_SRC_IRQ);
+	kunmap_atomic(dst_buf - dst_off);
+	kunmap_atomic(src_buf - src_off);
 }
 
 static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index a4ea102..4626ef2 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/scatterlist.h>
-
 #include "tmio_mmc.h"
 
 #ifdef CONFIG_PM
diff --git a/drivers/mmc/host/tmio_mmc.h b/drivers/mmc/host/tmio_mmc.h
index 3020f98..a95e6d9 100644
--- a/drivers/mmc/host/tmio_mmc.h
+++ b/drivers/mmc/host/tmio_mmc.h
@@ -105,13 +105,13 @@ static inline char *tmio_mmc_kmap_atomic(struct scatterlist *sg,
 					 unsigned long *flags)
 {
 	local_irq_save(*flags);
-	return kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
+	return kmap_atomic(sg_page(sg)) + sg->offset;
 }
 
 static inline void tmio_mmc_kunmap_atomic(struct scatterlist *sg,
 					  unsigned long *flags, void *virt)
 {
-	kunmap_atomic(virt - sg->offset, KM_BIO_SRC_IRQ);
+	kunmap_atomic(virt - sg->offset);
 	local_irq_restore(*flags);
 }
 
-- 
1.7.4.4


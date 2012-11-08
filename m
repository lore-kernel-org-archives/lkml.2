Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2KHNEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:04:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:24988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab2KHNEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:04:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102523"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 22/26] mmc: sdhci: panic write: no dma mapping
Date: Thu,  8 Nov 2012 15:06:20 +0200
Message-Id: <1352379984-18381-23-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Implement simple dma ops to avoid usage dma mapping in panic mode.
Init & cleanup pave the way for the dma ops implemented through
pre and post functions.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/host/sdhci.c  |  158 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/sdhci.h |    8 +++
 2 files changed, 164 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d85e9d5..ab3f5ce 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -649,6 +649,69 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 		data->sg_len, direction);
 }
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+
+static void sdhci_panic_dma_pre(struct sdhci_host *host, struct mmc_data *data)
+{
+	struct scatterlist *sg;
+	int i, len;
+	dma_addr_t addr;
+	u8 *desc;
+
+	if (host->flags & SDHCI_USE_ADMA) {
+		if (data->sg_len != 1) {
+			WARN_ON(1);
+			host->flags &= ~SDHCI_REQ_USE_DMA;
+			return;
+		}
+		desc = host->panic_adma_desc;
+		for_each_sg(data->sg, sg, 1, i) {
+			addr = host->panic_dma_addr;
+			len = sg->length;
+			sdhci_set_adma_desc(desc, addr, len, 0x21);
+			desc += 8;
+		}
+		if (host->quirks & SDHCI_QUIRK_NO_ENDATTR_IN_NOPDESC) {
+			if (desc != host->panic_adma_desc) {
+				desc -= 8;
+				desc[0] |= 0x2;
+			}
+		} else {
+			sdhci_set_adma_desc(desc, 0, 0, 0x3);
+		}
+		sdhci_writel(host, host->panic_adma_addr, SDHCI_ADMA_ADDRESS);
+	} else {
+		sdhci_writel(host, host->panic_dma_addr, SDHCI_DMA_ADDRESS);
+	}
+
+	if (data->flags & MMC_DATA_WRITE) {
+		sg_copy_to_buffer(data->sg, data->sg_len, host->panic_buf,
+				  host->panic_bufsize);
+	}
+}
+
+static void sdhci_panic_dma_post(struct sdhci_host *host, struct mmc_data *data)
+{
+	if (data->flags & MMC_DATA_READ) {
+		sg_copy_from_buffer(data->sg, data->sg_len, host->panic_buf,
+				    host->panic_bufsize);
+	}
+}
+
+#else
+
+static inline void sdhci_panic_dma_pre(struct sdhci_host *host,
+				       struct mmc_data *data)
+{
+}
+
+static inline void sdhci_panic_dma_post(struct sdhci_host *host,
+					struct mmc_data *data)
+{
+}
+
+#endif
+
 static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 {
 	u8 count;
@@ -810,7 +873,9 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 	}
 
 	if (host->flags & SDHCI_REQ_USE_DMA) {
-		if (host->flags & SDHCI_USE_ADMA) {
+		if (mmc_am_panic_task(host->mmc)) {
+			sdhci_panic_dma_pre(host, data);
+		} else if (host->flags & SDHCI_USE_ADMA) {
 			ret = sdhci_adma_table_pre(host, data);
 			if (ret) {
 				/*
@@ -937,7 +1002,9 @@ static void sdhci_finish_data(struct sdhci_host *host)
 	host->data = NULL;
 
 	if (host->flags & SDHCI_REQ_USE_DMA) {
-		if (host->flags & SDHCI_USE_ADMA)
+		if (mmc_am_panic_task(host->mmc))
+			sdhci_panic_dma_post(host, data);
+		else if (host->flags & SDHCI_USE_ADMA)
 			sdhci_adma_table_post(host, data);
 		else {
 			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
@@ -2045,6 +2112,91 @@ static const struct mmc_host_ops sdhci_ops = {
 
 #ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
 
+/*
+ * Arbitrary maximum DMA buffer size and hence maximum request size when using
+ * DMA.
+ */
+#define SDHCI_PANIC_DMA_BUFSIZE (32 * 1024)
+
+/*
+ * We DMA at most one segment which is aligned. Plus we need an end descriptor.
+ * We allow for a 8 byte (32-bit address) descriptor size.
+ */
+#define SDHCI_PANIC_ADMA_DESC_SZ ((1 + 1) * 12)
+
+static void sdhci_panic_dma_cleanup(struct sdhci_host *host)
+{
+	if (host->panic_adma_desc) {
+		dma_free_coherent(mmc_dev(host->mmc), SDHCI_PANIC_ADMA_DESC_SZ,
+				  host->panic_adma_desc, host->panic_adma_addr);
+		host->panic_adma_desc = NULL;
+	}
+
+	if (host->panic_buf) {
+		dma_free_coherent(mmc_dev(host->mmc), host->panic_bufsize,
+				  host->panic_buf, host->panic_dma_addr);
+		host->panic_buf = NULL;
+	}
+}
+
+static int sdhci_panic_dma_init(struct sdhci_host *host)
+{
+	size_t size;
+
+	size = min_t(size_t, SDHCI_PANIC_DMA_BUFSIZE, host->mmc->max_seg_size);
+	while (size > PAGE_SIZE) {
+		host->panic_buf = dma_alloc_coherent(mmc_dev(host->mmc), size,
+						     &host->panic_dma_addr,
+						     GFP_KERNEL | __GFP_NOWARN);
+		if (host->panic_buf)
+			break;
+		size >>= 1;
+	}
+	if (!host->panic_buf) {
+		host->panic_buf = dma_alloc_coherent(mmc_dev(host->mmc), size,
+						     &host->panic_dma_addr,
+						     GFP_KERNEL);
+	}
+	if (!host->panic_buf)
+		return -ENOMEM;
+
+	host->panic_bufsize = size;
+	host->mmc->panic_max_size = size;
+
+	if (host->flags & SDHCI_USE_ADMA) {
+		size = SDHCI_PANIC_ADMA_DESC_SZ;
+		host->panic_adma_desc = dma_alloc_coherent(mmc_dev(host->mmc),
+							size,
+							&host->panic_adma_addr,
+							GFP_KERNEL);
+		if (!host->panic_adma_desc) {
+			sdhci_panic_dma_cleanup(host);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
+static int sdhci_panic_init(struct mmc_host *mmc)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+
+	mmc->panic_max_size = mmc->max_seg_size;
+
+	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA))
+		return sdhci_panic_dma_init(host);
+
+	return 0;
+}
+
+static void sdhci_panic_cleanup(struct mmc_host *mmc)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+
+	sdhci_panic_dma_cleanup(host);
+}
+
 void sdhci_lock(struct sdhci_host *host)
 {
 	if (mmc_am_panic_task(host->mmc))
@@ -2092,6 +2244,8 @@ static void sdhci_panic_end(struct mmc_host *mmc)
 }
 
 static const struct mmc_panic_ops sdhci_pops = {
+	.init		= sdhci_panic_init,
+	.cleanup	= sdhci_panic_cleanup,
 	.begin		= sdhci_panic_begin,
 	.end		= sdhci_panic_end,
 };
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index fa8529a..873e41d 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -172,6 +172,14 @@ struct sdhci_host {
 #define SDHCI_TUNING_MODE_1	0
 	struct timer_list	tuning_timer;	/* Timer for tuning */
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+	void			*panic_buf;	/* buffer for panic requests */
+	size_t			panic_bufsize;	/* panic buffer size */
+	dma_addr_t		panic_dma_addr;	/* panic buffer dma address */
+	u8			*panic_adma_desc;	/* adma desc buffer */
+	dma_addr_t		panic_adma_addr;	/* adma desc address */
+#endif
+
 	unsigned long private[0] ____cacheline_aligned;
 };
 #endif /* LINUX_MMC_SDHCI_H */
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2KHNFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:05:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:24988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab2KHNEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:04:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102635"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 25/26] mmc: sdhci: panic write: trap nonpanic tasks
Date: Thu,  8 Nov 2012 15:06:23 +0200
Message-Id: <1352379984-18381-26-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/host/sdhci.c  |   47 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/mmc/sdhci.h |    1 +
 2 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 9a24417..db12fad 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2204,8 +2204,12 @@ static void sdhci_panic_cleanup(struct mmc_host *mmc)
 
 void sdhci_lock(struct sdhci_host *host)
 {
-	if (mmc_am_panic_task(host->mmc))
-		return;
+	if (mmc_panic_task_active(host->mmc)) {
+		if (mmc_am_panic_task(host->mmc))
+			return;
+		while (mmc_am_nonpanic_task(host->mmc))
+			cpu_relax();
+	}
 	spin_lock(&host->lock);
 }
 
@@ -2219,8 +2223,12 @@ void _sdhci_lock_irqsave(struct sdhci_host *host, unsigned long *flags_ptr)
 {
 	unsigned long flags;
 
-	if (mmc_am_panic_task(host->mmc))
-		return;
+	if (mmc_panic_task_active(host->mmc)) {
+		if (mmc_am_panic_task(host->mmc))
+			return;
+		while (mmc_am_nonpanic_task(host->mmc))
+			cpu_relax();
+	}
 
 	spin_lock_irqsave(&host->lock, flags);
 	*flags_ptr = flags;
@@ -2235,6 +2243,16 @@ void sdhci_unlock_irqrestore(struct sdhci_host *host, unsigned long flags)
 static void sdhci_panic_begin(struct mmc_host *mmc)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	int i;
+
+	/* Wait a bit for other users to go away */
+	for (i = 0; i < 10000; i++) {
+		if (spin_trylock(&host->lock)) {
+			host->locked = 1;
+			break;
+		}
+		udelay(1);
+	}
 
 	if (host->runtime_suspended)
 		sdhci_runtime_resume_host(host);
@@ -2250,6 +2268,10 @@ static void sdhci_panic_end(struct mmc_host *mmc)
 
 	ier = sdhci_readl(host, SDHCI_INT_ENABLE);
 	sdhci_writel(host, ier, SDHCI_SIGNAL_ENABLE);
+	if (host->locked) {
+		host->locked = 0;
+		spin_unlock(&host->lock);
+	}
 }
 
 static const struct mmc_panic_ops sdhci_pops = {
@@ -2368,6 +2390,9 @@ static void sdhci_timeout_timer(unsigned long data)
 
 	host = (struct sdhci_host*)data;
 
+	if (mmc_am_nonpanic_task(host->mmc))
+		return;
+
 	sdhci_lock_irqsave(host, flags);
 
 	if (host->mrq) {
@@ -2399,6 +2424,9 @@ static void sdhci_tuning_timer(unsigned long data)
 
 	host = (struct sdhci_host *)data;
 
+	if (mmc_am_nonpanic_task(host->mmc))
+		return;
+
 	sdhci_lock_irqsave(host, flags);
 
 	host->flags |= SDHCI_NEEDS_RETUNING;
@@ -2596,6 +2624,9 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	u32 intmask, unexpected = 0;
 	int cardint = 0, max_loops = 16;
 
+	if (mmc_am_nonpanic_task(host->mmc))
+		return IRQ_HANDLED;
+
 	sdhci_lock(host);
 
 
@@ -2713,6 +2744,8 @@ int sdhci_suspend_host(struct sdhci_host *host)
 	if (host->ops->platform_suspend)
 		host->ops->platform_suspend(host);
 
+	mmc_trap_nonpanic_tasks(host->mmc);
+
 	sdhci_disable_card_detection(host);
 
 	/* Disable tuning since we are suspending */
@@ -2745,6 +2778,8 @@ int sdhci_resume_host(struct sdhci_host *host)
 {
 	int ret;
 
+	mmc_trap_nonpanic_tasks(host->mmc);
+
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
 			host->ops->enable_dma(host);
@@ -2820,6 +2855,8 @@ int sdhci_runtime_suspend_host(struct sdhci_host *host)
 	unsigned long flags;
 	int ret = 0;
 
+	mmc_trap_nonpanic_tasks(host->mmc);
+
 	/* Disable tuning since we are suspending */
 	if (host->flags & SDHCI_USING_RETUNING_TIMER) {
 		del_timer_sync(&host->tuning_timer);
@@ -2845,6 +2882,8 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
 	unsigned long flags;
 	int ret = 0, host_flags = host->flags;
 
+	mmc_trap_nonpanic_tasks(host->mmc);
+
 	if (host_flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma)
 			host->ops->enable_dma(host);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 873e41d..13cc598 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -173,6 +173,7 @@ struct sdhci_host {
 	struct timer_list	tuning_timer;	/* Timer for tuning */
 
 #ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+	int			locked;		/* panic task has the lock */
 	void			*panic_buf;	/* buffer for panic requests */
 	size_t			panic_bufsize;	/* panic buffer size */
 	dma_addr_t		panic_dma_addr;	/* panic buffer dma address */
-- 
1.7.9.5


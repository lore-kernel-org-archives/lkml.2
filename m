Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2KHNHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:07:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:24988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab2KHNEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:04:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102359"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 15/26] mmc: sdhci: panic write: bypass spin lock
Date: Thu,  8 Nov 2012 15:06:13 +0200
Message-Id: <1352379984-18381-16-git-send-email-dragos.tatulea@intel.com>
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
 drivers/mmc/host/sdhci.c |  119 ++++++++++++++++++++++++++++++----------------
 drivers/mmc/host/sdhci.h |   24 ++++++++++
 2 files changed, 101 insertions(+), 42 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7922adb..1ed78f0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -287,7 +287,7 @@ static void sdhci_led_control(struct led_classdev *led,
 	struct sdhci_host *host = container_of(led, struct sdhci_host, led);
 	unsigned long flags;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	if (host->runtime_suspended)
 		goto out;
@@ -297,7 +297,7 @@ static void sdhci_led_control(struct led_classdev *led,
 	else
 		sdhci_activate_led(host);
 out:
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 #endif
 
@@ -1266,7 +1266,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	sdhci_runtime_pm_get(host);
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	WARN_ON(host->mrq != NULL);
 
@@ -1319,9 +1319,9 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 			tuning_opcode = mmc->card->type == MMC_TYPE_MMC ?
 				MMC_SEND_TUNING_BLOCK_HS200 :
 				MMC_SEND_TUNING_BLOCK;
-			spin_unlock_irqrestore(&host->lock, flags);
+			sdhci_unlock_irqrestore(host, flags);
 			sdhci_execute_tuning(mmc, tuning_opcode);
-			spin_lock_irqsave(&host->lock, flags);
+			sdhci_lock_irqsave(host, flags);
 
 			/* Restore original mmc_request structure */
 			host->mrq = mrq;
@@ -1334,7 +1334,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	}
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 
 static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
@@ -1343,10 +1343,10 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 	int vdd_bit = -1;
 	u8 ctrl;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	if (host->flags & SDHCI_DEVICE_DEAD) {
-		spin_unlock_irqrestore(&host->lock, flags);
+		sdhci_unlock_irqrestore(host, flags);
 		if (host->vmmc && ios->power_mode == MMC_POWER_OFF)
 			mmc_regulator_set_ocr(host->mmc, host->vmmc, 0);
 		return;
@@ -1369,9 +1369,9 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 		vdd_bit = sdhci_set_power(host, ios->vdd);
 
 	if (host->vmmc && vdd_bit != -1) {
-		spin_unlock_irqrestore(&host->lock, flags);
+		sdhci_unlock_irqrestore(host, flags);
 		mmc_regulator_set_ocr(host->mmc, host->vmmc, vdd_bit);
-		spin_lock_irqsave(&host->lock, flags);
+		sdhci_lock_irqsave(host, flags);
 	}
 
 	if (host->ops->platform_send_init_74_clocks)
@@ -1500,7 +1500,7 @@ static void sdhci_do_set_ios(struct sdhci_host *host, struct mmc_ios *ios)
 		sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 
 static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
@@ -1517,7 +1517,7 @@ static int sdhci_check_ro(struct sdhci_host *host)
 	unsigned long flags;
 	int is_readonly;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		is_readonly = 0;
@@ -1527,7 +1527,7 @@ static int sdhci_check_ro(struct sdhci_host *host)
 		is_readonly = !(sdhci_readl(host, SDHCI_PRESENT_STATE)
 				& SDHCI_WRITE_PROTECT);
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 
 	/* This quirk needs to be replaced by a callback-function later */
 	return host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT ?
@@ -1600,9 +1600,9 @@ static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 	struct sdhci_host *host = mmc_priv(mmc);
 	unsigned long flags;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 	sdhci_enable_sdio_irq_nolock(host, enable);
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 
 static int sdhci_do_3_3v_signal_voltage_switch(struct sdhci_host *host,
@@ -1770,7 +1770,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 
 	sdhci_runtime_pm_get(host);
 	disable_irq(host->irq);
-	spin_lock(&host->lock);
+	sdhci_lock(host);
 
 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 
@@ -1790,7 +1790,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 	    requires_tuning_nonuhs)
 		ctrl |= SDHCI_CTRL_EXEC_TUNING;
 	else {
-		spin_unlock(&host->lock);
+		sdhci_unlock(host);
 		enable_irq(host->irq);
 		sdhci_runtime_pm_put(host);
 		return 0;
@@ -1863,7 +1863,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 		host->cmd = NULL;
 		host->mrq = NULL;
 
-		spin_unlock(&host->lock);
+		sdhci_unlock(host);
 		enable_irq(host->irq);
 
 		/* Wait for Buffer Read Ready interrupt */
@@ -1871,7 +1871,7 @@ static int sdhci_execute_tuning(struct mmc_host *mmc, u32 opcode)
 					(host->tuning_done == 1),
 					msecs_to_jiffies(50));
 		disable_irq(host->irq);
-		spin_lock(&host->lock);
+		sdhci_lock(host);
 
 		if (!host->tuning_done) {
 			pr_info(DRIVER_NAME ": Timeout waiting for "
@@ -1945,7 +1945,7 @@ out:
 		err = 0;
 
 	sdhci_clear_set_irqs(host, SDHCI_INT_DATA_AVAIL, ier);
-	spin_unlock(&host->lock);
+	sdhci_unlock(host);
 	enable_irq(host->irq);
 	sdhci_runtime_pm_put(host);
 
@@ -1961,7 +1961,7 @@ static void sdhci_do_enable_preset_value(struct sdhci_host *host, bool enable)
 	if (host->version < SDHCI_SPEC_300)
 		return;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	ctrl = sdhci_readw(host, SDHCI_HOST_CONTROL2);
 
@@ -1979,7 +1979,7 @@ static void sdhci_do_enable_preset_value(struct sdhci_host *host, bool enable)
 		host->flags &= ~SDHCI_PV_ENABLED;
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 
 static void sdhci_enable_preset_value(struct mmc_host *mmc, bool enable)
@@ -2002,6 +2002,40 @@ static const struct mmc_host_ops sdhci_ops = {
 	.enable_preset_value		= sdhci_enable_preset_value,
 };
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+
+void sdhci_lock(struct sdhci_host *host)
+{
+	if (mmc_am_panic_task(host->mmc))
+		return;
+	spin_lock(&host->lock);
+}
+
+void sdhci_unlock(struct sdhci_host *host)
+{
+	if (!mmc_am_panic_task(host->mmc))
+		spin_unlock(&host->lock);
+}
+
+void _sdhci_lock_irqsave(struct sdhci_host *host, unsigned long *flags_ptr)
+{
+	unsigned long flags;
+
+	if (mmc_am_panic_task(host->mmc))
+		return;
+
+	spin_lock_irqsave(&host->lock, flags);
+	*flags_ptr = flags;
+}
+
+void sdhci_unlock_irqrestore(struct sdhci_host *host, unsigned long flags)
+{
+	if (!mmc_am_panic_task(host->mmc))
+		spin_unlock_irqrestore(&host->lock, flags);
+}
+
+#endif
+
 /*****************************************************************************\
  *                                                                           *
  * Tasklets                                                                  *
@@ -2015,7 +2049,7 @@ static void sdhci_tasklet_card(unsigned long param)
 
 	host = (struct sdhci_host*)param;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	/* Check host->mrq first in case we are runtime suspended */
 	if (host->mrq &&
@@ -2032,7 +2066,7 @@ static void sdhci_tasklet_card(unsigned long param)
 		tasklet_schedule(&host->finish_tasklet);
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
@@ -2045,14 +2079,14 @@ static void sdhci_tasklet_finish(unsigned long param)
 
 	host = (struct sdhci_host*)param;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
         /*
          * If this tasklet gets rescheduled while running, it will
          * be run again afterwards but without any active request.
          */
 	if (!host->mrq) {
-		spin_unlock_irqrestore(&host->lock, flags);
+		sdhci_unlock_irqrestore(host, flags);
 		return;
 	}
 
@@ -2095,7 +2129,7 @@ static void sdhci_tasklet_finish(unsigned long param)
 #endif
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 
 	mmc_request_done(host->mmc, mrq);
 	sdhci_runtime_pm_put(host);
@@ -2108,7 +2142,7 @@ static void sdhci_timeout_timer(unsigned long data)
 
 	host = (struct sdhci_host*)data;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	if (host->mrq) {
 		pr_err("%s: Timeout waiting for hardware "
@@ -2129,7 +2163,7 @@ static void sdhci_timeout_timer(unsigned long data)
 	}
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 
 static void sdhci_tuning_timer(unsigned long data)
@@ -2139,11 +2173,11 @@ static void sdhci_tuning_timer(unsigned long data)
 
 	host = (struct sdhci_host *)data;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	host->flags |= SDHCI_NEEDS_RETUNING;
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 }
 
 /*****************************************************************************\
@@ -2336,10 +2370,11 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	u32 intmask, unexpected = 0;
 	int cardint = 0, max_loops = 16;
 
-	spin_lock(&host->lock);
+	sdhci_lock(host);
+
 
 	if (host->runtime_suspended) {
-		spin_unlock(&host->lock);
+		sdhci_unlock(host);
 		pr_warning("%s: got irq while runtime suspended\n",
 		       mmc_hostname(host->mmc));
 		return IRQ_HANDLED;
@@ -2421,7 +2456,7 @@ again:
 	if (intmask && --max_loops)
 		goto again;
 out:
-	spin_unlock(&host->lock);
+	sdhci_unlock(host);
 
 	if (unexpected) {
 		pr_err("%s: Unexpected interrupt 0x%08x.\n",
@@ -2557,15 +2592,15 @@ int sdhci_runtime_suspend_host(struct sdhci_host *host)
 		host->flags &= ~SDHCI_NEEDS_RETUNING;
 	}
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 	sdhci_mask_irqs(host, SDHCI_INT_ALL_MASK);
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 
 	synchronize_irq(host->irq);
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 	host->runtime_suspended = true;
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 
 	return ret;
 }
@@ -2596,7 +2631,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
 	if (host->flags & SDHCI_USING_RETUNING_TIMER)
 		host->flags |= SDHCI_NEEDS_RETUNING;
 
-	spin_lock_irqsave(&host->lock, flags);
+	sdhci_lock_irqsave(host, flags);
 
 	host->runtime_suspended = false;
 
@@ -2607,7 +2642,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host)
 	/* Enable Card Detection */
 	sdhci_enable_card_detection(host);
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	sdhci_unlock_irqrestore(host, flags);
 
 	return ret;
 }
@@ -3132,7 +3167,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 	unsigned long flags;
 
 	if (dead) {
-		spin_lock_irqsave(&host->lock, flags);
+		sdhci_lock_irqsave(host, flags);
 
 		host->flags |= SDHCI_DEVICE_DEAD;
 
@@ -3144,7 +3179,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 			tasklet_schedule(&host->finish_tasklet);
 		}
 
-		spin_unlock_irqrestore(&host->lock, flags);
+		sdhci_unlock_irqrestore(host, flags);
 	}
 
 	sdhci_disable_card_detection(host);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 97653ea..e2444918 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -388,4 +388,28 @@ extern int sdhci_runtime_suspend_host(struct sdhci_host *host);
 extern int sdhci_runtime_resume_host(struct sdhci_host *host);
 #endif
 
+#ifdef CONFIG_MMC_BLOCK_PANIC_WRITE
+
+extern void sdhci_lock(struct sdhci_host *host);
+extern void sdhci_unlock(struct sdhci_host *host);
+
+extern void _sdhci_lock_irqsave(struct sdhci_host *host,
+				unsigned long *flags_ptr);
+extern void sdhci_unlock_irqrestore(struct sdhci_host *host,
+				    unsigned long flags);
+
+#define sdhci_lock_irqsave(host, flags)	_sdhci_lock_irqsave(host, &(flags))
+
+#else
+
+#define sdhci_lock(host)	spin_lock(&(host)->lock)
+#define sdhci_unlock(host)	spin_unlock(&(host)->lock)
+
+#define sdhci_lock_irqsave(host, flags)		\
+	spin_lock_irqsave(&(host)->lock, flags)
+#define sdhci_unlock_irqrestore(host, flags)	\
+	spin_unlock_irqrestore(&(host)->lock, flags)
+
+#endif
+
 #endif /* __SDHCI_HW_H */
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2LXNvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:51:43 -0500
Received: from 212.199.104.198.static.012.net.il ([212.199.104.198]:5603 "EHLO
	lx-merez.qi.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752960Ab2LXNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:51:39 -0500
From: Maya Erez <merez@codeaurora.org>
To: linux-mmc@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 2/2] mmc: allow the host controller to poll for BKOPS completion
Date: Mon, 24 Dec 2012 15:51:08 +0200
Message-Id: <1356357068-31807-3-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow the card to perform the required BKOPS and prevent
the need for critical BKOPS, we would like to prevent BKOPS interruption
when possible.
In case the controller calls mmc_suspend_host when runtime suspend is
idle, the BKOPS operation will be interrupted. To prevent this we would
like to prevent the runtime suspend idle until BKOPS is completed.
This patch adds a flag to allow the controller to mark if the polling is
required or not.

Signed-off-by: Maya Erez <merez@codeaurora.org>

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 36cef94..cb20bac 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -361,14 +361,101 @@ void mmc_start_bkops(struct mmc_card *card, bool from_exception)
 	 * bkops executed synchronously, otherwise
 	 * the operation is in progress
 	 */
-	if (!use_busy_signal)
+	if (!use_busy_signal) {
 		mmc_card_set_doing_bkops(card);
+		if (card->host->caps2 & MMC_CAP2_POLL_FOR_BKOPS_COMP) {
+			pr_debug("%s: %s: starting the polling thread\n",
+				 mmc_hostname(card->host), __func__);
+			queue_work(system_nrt_wq,
+				   &card->bkops_info.poll_for_completion);
+		}
+	}
+
 out:
 	mmc_release_host(card->host);
 }
 EXPORT_SYMBOL(mmc_start_bkops);
 
 /**
+ * mmc_bkops_completion_polling() - Poll on the card status to
+ * wait for the non-blocking BKOPS completion
+ * @work:	The completion polling work
+ *
+ * The on-going reading of the card status will prevent the card
+ * from getting into suspend while it is in the middle of
+ * performing BKOPS.
+ * Since the non blocking BKOPS can be interrupted by a fetched
+ * request we also check IF mmc_card_doing_bkops in each
+ * iteration.
+ */
+void mmc_bkops_completion_polling(struct work_struct *work)
+{
+	struct mmc_card *card = container_of(work, struct mmc_card,
+			bkops_info.poll_for_completion);
+	unsigned long timeout_jiffies = jiffies +
+		msecs_to_jiffies(BKOPS_COMPLETION_POLLING_TIMEOUT_MS);
+	u32 status;
+	int err;
+
+	/*
+	 * Wait for the BKOPs to complete. Keep reading the status to prevent
+	 * the host from getting into suspend
+	 */
+	do {
+		mmc_claim_host(card->host);
+
+		if (!mmc_card_doing_bkops(card))
+			goto out;
+
+		err = pm_runtime_get_sync(card->host->parent);
+		if (err) {
+			pr_err("%s: error %d requesting status\n",
+			       mmc_hostname(card->host), err);
+			goto out;
+		}
+
+		err = mmc_send_status(card, &status);
+		if (err) {
+			pr_err("%s: error %d requesting status\n",
+			       mmc_hostname(card->host), err);
+			goto put_sync;
+		}
+
+		/*
+		 * Some cards mishandle the status bits, so make sure to check
+		 * both the busy indication and the card state.
+		 */
+		if ((status & R1_READY_FOR_DATA) &&
+		    (R1_CURRENT_STATE(status) != R1_STATE_PRG)) {
+			pr_debug("%s: %s: completed BKOPs, exit polling\n",
+				 mmc_hostname(card->host), __func__);
+			mmc_card_clr_doing_bkops(card);
+			card->bkops_info.started_delayed_bkops = false;
+			goto put_sync;
+		}
+
+		mmc_release_host(card->host);
+
+		/*
+		 * Sleep before checking the card status again to allow the
+		 * card to complete the BKOPs operation
+		 */
+		msleep(BKOPS_COMPLETION_POLLING_INTERVAL_MS);
+	} while (time_before(jiffies, timeout_jiffies));
+
+	pr_err("%s: %s: exit polling due to timeout\n",
+	       mmc_hostname(card->host), __func__);
+
+	pm_runtime_put_sync(card->host->parent);
+	return;
+
+put_sync:
+	pm_runtime_put_sync(card->host->parent);
+out:
+	mmc_release_host(card->host);
+}
+
+/**
  * mmc_start_idle_time_bkops() - check if a non urgent BKOPS is
  * needed
  * @work:	The idle time BKOPS work
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index f68624a..d9ad3ff 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1279,6 +1279,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		if (card->ext_csd.bkops_en) {
 			INIT_DELAYED_WORK(&card->bkops_info.dw,
 					  mmc_start_idle_time_bkops);
+			INIT_WORK(&card->bkops_info.poll_for_completion,
+				  mmc_bkops_completion_polling);
 
 			/*
 			 * Calculate the time to start the BKOPs checking.
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index ca4cf19..ce30fac 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -216,6 +216,7 @@ struct mmc_part {
  * @host_delay_ms:	The host controller time to start bkops
  * @delay_ms:	The time to start the BKOPS
  *        delayed work once MMC thread is idle
+ * @poll_for_completion:	Poll on BKOPS completion
  * @cancel_delayed_work: A flag to indicate if the delayed work
  *        should be cancelled
  * @started_delayed_bkops:  A flag to indicate if the delayed
@@ -230,6 +231,10 @@ struct mmc_bkops_info {
  * is idle.
  */
 #define MMC_IDLE_BKOPS_TIME_MS 2000
+	struct work_struct	poll_for_completion;
+/* Polling timeout and interval for waiting on non-blocking BKOPs completion */
+#define BKOPS_COMPLETION_POLLING_TIMEOUT_MS 10000 /* in ms */
+#define BKOPS_COMPLETION_POLLING_INTERVAL_MS 1000 /* in ms */
 	bool			cancel_delayed_work;
 	bool			started_delayed_bkops;
 };
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index c6426c6..2b7355a 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -147,6 +147,7 @@ extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
 extern void mmc_start_bkops(struct mmc_card *card, bool from_exception);
 extern void mmc_start_delayed_bkops(struct mmc_card *card);
 extern void mmc_start_idle_time_bkops(struct work_struct *work);
+extern void mmc_bkops_completion_polling(struct work_struct *work);
 extern int __mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int, bool);
 extern int mmc_switch(struct mmc_card *, u8, u8, u8, unsigned int);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 61a10c1..f02ad52 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -259,6 +259,7 @@ struct mmc_host {
 #define MMC_CAP2_CD_ACTIVE_HIGH	(1 << 10)	/* Card-detect signal active high */
 #define MMC_CAP2_RO_ACTIVE_HIGH	(1 << 11)	/* Write-protect signal active high */
 
+#define MMC_CAP2_POLL_FOR_BKOPS_COMP	(1 << 12)/* poll for bkops completion */
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
 #ifdef CONFIG_MMC_CLKGATE
-- 
1.7.3.3
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

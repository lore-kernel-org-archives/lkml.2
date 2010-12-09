Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0LIM2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 07:28:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:18791 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab0LIM2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 07:28:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,319,1288594800"; 
   d="scan'208";a="359305914"
Date: Thu, 9 Dec 2010 20:24:39 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cjb@laptop.org,
        kmpark@infradead.org, leonard.mai@intel.com
Subject: [PATCH v5 2/4]add two callbacks in core to implement HW reset
Message-ID: <20101209122439.GC13236@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW reset will reset eMMC card. So after reset, card should also be
reinitialized. Add two new callbacks to implement reset and reinitialize.
MMC core layer will check whether occurs a timeout error in the new added
routine mmc_handle_timeout_error

mmc_handle_timeout_error: check whether occurs a timeout error. If
occurs,use HW reset callbacks to do reset and reinitialize

hardware_reset: trigger a RST_n signal for host to reset card. This callback
was just defined in header file, not implemented in this patch.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h  |    9 +++++++++
 drivers/mmc/core/mmc.c   |   31 +++++++++++++++++++++++++++++++
 include/linux/mmc/core.h |    1 +
 include/linux/mmc/host.h |   13 +++++++++++++
 5 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6286898..530fc35 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -82,6 +82,51 @@ static void mmc_flush_scheduled_work(void)
 }
 
 /**
+ *	mmc_handle_timeout_error - handle command and data timeout
+ *	errors.
+ *	@host: MMC host used to handle error
+ *	@error: error condition
+ *
+ *	check whether there is a command or data timeout error occured,
+ *	if so, reset and reinit eMMC card if card has such capability.
+ *	1. let host controller do a specific hardware reset for eMMC
+ *	   card (trigger RST_n signal).
+ *	2. after reset done, reinit eMMC card.
+ */
+void mmc_handle_timeout_error(struct mmc_host *host, int error)
+{
+	struct mmc_card *card = host->card;
+
+	/*
+	 * If error condition is not timeout, do nothing
+	 */
+	if (error != -ETIMEDOUT)
+		return;
+	/*
+	 * make sure mmc_reqeust is not NULL
+	 * make sure mmc_card has HW reset capability
+	 */
+	if (!card || !card->ext_csd.rst)
+		return;
+
+	/* check whether host has such callback */
+	if (!host->ops->hardware_reset ||
+			!host->bus_ops->reinit)
+		return;
+
+	/*
+	 * if there occurs any timeout error, HW reset
+	 * eMMC card and reinit again.
+	 */
+	if (host->ops->hardware_reset(host))
+		pr_warn("MMC card reset failed\n");
+	else
+		if (host->bus_ops->reinit(host))
+			pr_warn("MMC card reinit failed\n");
+}
+EXPORT_SYMBOL(mmc_handle_timeout_error);
+
+/**
  *	mmc_request_done - finish processing an MMC request
  *	@host: MMC host which completed request
  *	@mrq: MMC request which request
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 026c975..4980e2f 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -24,6 +24,15 @@ struct mmc_bus_ops {
 	int (*resume)(struct mmc_host *);
 	int (*power_save)(struct mmc_host *);
 	int (*power_restore)(struct mmc_host *);
+	/*
+	 * New added callback
+	 * Used to reinit card when HW reset occurs
+	 *
+	 * return value:
+	 * 0: successfully reinit card.
+	 * negative value: failed to reinit
+	 */
+	int (*reinit)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1d138b3..b3eb8a6 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -732,6 +732,35 @@ static int mmc_awake(struct mmc_host *host)
 	return err;
 }
 
+/**
+ * mmc_reinit_card - reinitialize card after HW reset
+ *
+ * this callback is used to reinitialize card after a HW
+ * reset occurs.
+ * Reture value:
+ * 0: successfully reinitialize
+ * other: failed to reinitialize
+ *
+ * claim_host should be called before using this callback.
+ */
+static int mmc_reinit_card(struct mmc_host *host)
+{
+	int err;
+	/*
+	 * Before init card, set the clock to be
+	 * the init frequency
+	 */
+	host->ios.clock = host->f_init;
+	mmc_set_clock(host, host->ios.clock);
+
+	err = mmc_init_card(host, host->ocr, host->card);
+	if (err)
+		pr_err("%s: Error %d while reinit card\n",
+				mmc_hostname(host), err);
+
+	return err;
+}
+
 static const struct mmc_bus_ops mmc_ops = {
 	.awake = mmc_awake,
 	.sleep = mmc_sleep,
@@ -740,6 +769,7 @@ static const struct mmc_bus_ops mmc_ops = {
 	.suspend = NULL,
 	.resume = NULL,
 	.power_restore = mmc_power_restore,
+	.reinit = mmc_reinit_card,
 };
 
 static const struct mmc_bus_ops mmc_ops_unsafe = {
@@ -750,6 +780,7 @@ static const struct mmc_bus_ops mmc_ops_unsafe = {
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
 	.power_restore = mmc_power_restore,
+	.reinit = mmc_reinit_card,
 };
 
 static void mmc_attach_bus_ops(struct mmc_host *host)
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 64e013f..115d589 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -131,6 +131,7 @@ struct mmc_request {
 struct mmc_host;
 struct mmc_card;
 
+extern void mmc_handle_timeout_error(struct mmc_host *, int);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 4a9d9d2..f1dffcb 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -117,6 +117,19 @@ struct mmc_host_ops {
 
 	/* optional callback for HC quirks */
 	void	(*init_card)(struct mmc_host *host, struct mmc_card *card);
+
+	/*
+	 * eMMC4.4 HW reset feature callback
+	 *
+	 * eMMC4.4 card can be reset if host triggers a RST_n signal
+	 * This callback will be used to for host to trigger such
+	 * signal.
+	 *
+	 * return value:
+	 * 0: successfully reset the eMMC card.
+	 * -ENODEV: no valid hardware to do so.
+	 */
+	int (*hardware_reset)(struct mmc_host *host);
 };
 
 struct mmc_card;
-- 
1.6.6.1


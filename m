Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0L0KSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:18:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:20970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0L0KSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:18:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="872137020"
Date: Mon, 27 Dec 2010 18:13:55 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, akpm@linux-foundation.org
Subject: [PATCH v6 2/3]mmc: do HW reset if eMMC card occurs timeout error
Message-ID: <20101227101355.GC20143@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two new callbacks were added in mmc_bus_ops to implement this.
hwreset_emmc: trigger a RST_n signal for host to reset card.
reinit_emmc: reinitialize eMMC card after hardware reset occurs.

MMC core layer will check whether occurs a timeout error in the new added
function mmc_handle_timeout_error.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/card/block.c |   10 +++++++++
 drivers/mmc/core/core.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/core.h  |   26 ++++++++++++++++++++++++
 include/linux/mmc/core.h |    1 +
 4 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 217f820..ba9614d 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -424,6 +424,16 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *req)
 
 		mmc_wait_for_req(card->host, &brq.mrq);
 
+		/* Check if need to do HW reset */
+		if (brq.cmd.error)
+			mmc_handle_timeout_error(card->host, brq.cmd.error);
+
+		if (brq.data.error)
+			mmc_handle_timeout_error(card->host, brq.data.error);
+
+		if (brq.stop.error)
+			mmc_handle_timeout_error(card->host, brq.stop.error);
+
 		mmc_queue_bounce_post(mq);
 
 		/*
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index a8e89f3..795bd81 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -83,6 +83,52 @@ static void mmc_flush_scheduled_work(void)
 }
 
 /**
+ *	mmc_handle_timeout_error - handle timeout errors occurs by card
+ *	@host: MMC host used to handle error
+ *	@error: error condition
+ *
+ *	check whether there is a command or data timeout error occurred,
+ *	if so, reset and reinit eMMC card if card has such capability.
+ *
+ *	In this function, driver will do follow things:
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
+	 * make sure card is not NULL
+	 * make sure mmc_card has HW reset capability
+	 */
+	if (!card || !card->ext_csd.rst)
+		return;
+
+	/* check whether host has such callback */
+	if (!host->bus_ops->hwreset_emmc ||
+			!host->bus_ops->reinit_emmc)
+		return;
+
+	/*
+	 * if there occurs any timeout error, HW reset
+	 * eMMC card and reinit again.
+	 */
+	if (host->bus_ops->hwreset_emmc(host))
+		pr_warn("MMC card reset failed\n");
+	else
+		if (host->bus_ops->reinit_emmc(host))
+			pr_warn("MMC card reinit failed\n");
+}
+EXPORT_SYMBOL(mmc_handle_timeout_error);
+
+/**
  *	mmc_request_done - finish processing an MMC request
  *	@host: MMC host which completed request
  *	@mrq: MMC request which request
@@ -1341,6 +1387,8 @@ static int mmc_do_erase(struct mmc_card *card, unsigned int from,
 	if (err) {
 		printk(KERN_ERR "mmc_erase: erase error %d, status %#x\n",
 		       err, cmd.resp[0]);
+		/* Before return, check whether can do a HW reset */
+		mmc_handle_timeout_error(card->host, cmd.error);
 		err = -EIO;
 		goto out;
 	}
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 026c975..09b6c54 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -24,6 +24,32 @@ struct mmc_bus_ops {
 	int (*resume)(struct mmc_host *);
 	int (*power_save)(struct mmc_host *);
 	int (*power_restore)(struct mmc_host *);
+	/*
+	 * New added callback
+	 * This function is used to reinitialize eMMC card after eMMC card been
+	 * reset.
+	 *
+	 * Note 1: before calling this, mmc_claim_host is needed. After finish
+	 * this calling, mmc_release_host is needed.
+	 *
+	 * return value:
+	 * 0 - successfully reinit card
+	 * other - failed to reinit
+	 */
+	int (*reinit_emmc)(struct mmc_host *);
+	/*
+	 * New added callback
+	 * This function is used to trigger RST_n signal to reset eMMC card as
+	 * eMMC4.4 spec recommended.
+	 *
+	 * Note 1: this function may sleep since delay is needed when pull
+	 * up/down GPIO line.
+	 *
+	 * return value:
+	 * 0 - successfully reset eMMC card
+	 * other - failed to reset eMMC card
+	 */
+	int (*hwreset_emmc)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
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
-- 
1.6.6.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0KRDGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 22:06:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:10529 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0KRDGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 22:06:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,214,1288594800"; 
   d="scan'208,223";a="678602655"
Date: Thu, 18 Nov 2010 11:04:23 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, alan@linux.intel.com
Subject: [PATCH v3 1/2]mmc:implemented HW reset in mmc core layer
Message-ID: <20101118030423.GB10621@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 49962ed89078717d539805f999503b2d29a42b05 Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 18 Nov 2010 10:25:44 +0800
Subject: [PATCH 1/2] mmc: implemented eMMC4.4 hardware reset feature in mmc core layer

When core layer detect a data timeout error, core driver need to
first reset eMMC card and then do a reinit for card. After that,
posts the original timeout error to mmc block layer.

1. enable hardware reset feature: to enable hardware reset
feature, mmc driver need to set RST_n_function bit in ext_csd
register. But this bit is onetime programmable, not sure whether
it is suitable for driver to set this bit.

2. The reset part was resvered for host controller to implement.

3. The reinit card part was implemented.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/core.c  |   28 ++++++++++++++++++++++++++
 drivers/mmc/core/core.h  |    9 ++++++++
 drivers/mmc/core/mmc.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    1 +
 include/linux/mmc/host.h |   10 +++++++++
 include/linux/mmc/mmc.h  |    1 +
 6 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 434e62c..4aa6895 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -212,6 +212,8 @@ static void mmc_wait_done(struct mmc_request *mrq)
  */
 void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
 {
+	struct mmc_card *card = host->card;
+
 	DECLARE_COMPLETION_ONSTACK(complete);
 
 	mrq->done_data = &complete;
@@ -220,6 +222,32 @@ void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
 	mmc_start_request(host, mrq);
 
 	wait_for_completion(&complete);
+
+	/*
+	 * as MMC4.4 standard says, when some data timeout conditions
+	 * occur, HC need to do a hardware reset for eMMC4.4 card.
+	 * If the card is eMMC4.4 card && data error is timeout,
+	 * do the following things:
+	 * 1. let host controller do a specific hardware reset for eMMC
+	 *    card (trigger RST_n signal).
+	 * 2. after reset done, reinit eMMC4.4 card.
+	 */
+	if (mrq->data && card &&
+		mrq->data->error == -ETIMEDOUT &&
+		card->ext_csd.rst == 1) {
+		int err = 1;
+		if (host->ops->hardware_reset &&
+				host->bus_ops->reinit) {
+			err = host->ops->hardware_reset(host);
+			if (err)
+				pr_warn("MMC card reset failed\n");
+			else
+				err = host->bus_ops->reinit(host);
+		}
+
+		if (err)
+			pr_warn("cannot reset and reinit eMMC4.4 card\n");
+	}
 }
 
 EXPORT_SYMBOL(mmc_wait_for_req);
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index 9972808..3cc1717 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -24,6 +24,15 @@ struct mmc_bus_ops {
 	int (*resume)(struct mmc_host *);
 	int (*power_save)(struct mmc_host *);
 	int (*power_restore)(struct mmc_host *);
+	/*
+	 * New reinit callback.
+	 * Used to reinit card when a reset occurs
+	 * or someother conditions
+	 * return value:
+	 * 0: successfully reinit card.
+	 * negative value: failed to reinit
+	 */
+	int (*reinit)(struct mmc_host *);
 };
 
 void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops);
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 77f93c3..117f345 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -237,6 +237,8 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 		}
 	}
 
+	card->ext_csd.rst = ext_csd[EXT_CSD_RST];
+
 	card->ext_csd.rev = ext_csd[EXT_CSD_REV];
 	if (card->ext_csd.rev > 5) {
 		printk(KERN_ERR "%s: unrecognised EXT_CSD revision %d\n",
@@ -484,6 +486,32 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * eMMC4.4 version card has HW reset capbility.
+	 * Enable this feature here:
+	 * RST_N_FUNCTION register is W/R, one time programmable
+	 * or readable.
+	 * So need to enable this register only once after power on
+	 */
+	if (card->csd.mmca_vsn >= CSD_SPEC_VER_4 &&
+			card->ext_csd.rev >= 4 &&
+			card->ext_csd.rst != 1) {
+		/* Be careful, EXT_CSD_RST register is one
+		 * time programmable
+		 * */
+		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+				EXT_CSD_RST, 1);
+		if (err && err != -EBADMSG)
+			goto free_card;
+
+		if (err) {
+			printk(KERN_WARNING "%s: switch to enable HW reset failed\n",
+			       mmc_hostname(card->host));
+			err = 0;
+		} else
+			card->ext_csd.rst = 1;
+	}
+
+	/*
 	 * Activate high speed (if supported)
 	 */
 	if ((card->ext_csd.hs_max_dtr != 0) &&
@@ -703,6 +731,24 @@ static int mmc_awake(struct mmc_host *host)
 	return err;
 }
 
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
@@ -711,6 +757,7 @@ static const struct mmc_bus_ops mmc_ops = {
 	.suspend = NULL,
 	.resume = NULL,
 	.power_restore = mmc_power_restore,
+	.reinit = mmc_reinit_card,
 };
 
 static const struct mmc_bus_ops mmc_ops_unsafe = {
@@ -721,6 +768,7 @@ static const struct mmc_bus_ops mmc_ops_unsafe = {
 	.suspend = mmc_suspend,
 	.resume = mmc_resume,
 	.power_restore = mmc_power_restore,
+	.reinit = mmc_reinit_card,
 };
 
 static void mmc_attach_bus_ops(struct mmc_host *host)
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8ce0827..ebee676 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -54,6 +54,7 @@ struct mmc_ext_csd {
 	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
 	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
 	unsigned int		trim_timeout;		/* In milliseconds */
+	unsigned int		rst; /* hardware reset enable bit */
 };
 
 struct sd_scr {
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f108cee..486cdbd 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -117,6 +117,16 @@ struct mmc_host_ops {
 
 	/* optional callback for HC quirks */
 	void	(*init_card)(struct mmc_host *host, struct mmc_card *card);
+
+	/*
+	 * HW reset callback, used for eMMC 4.4 new feature.
+	 * when occurs data timeout, HC can calling this callback
+	 * to reset eMMC card.
+	 * return value:
+	 * 0: successfully reset the eMMC card.
+	 * -ENODEV: no valid hardware to do so.
+	 */
+	int (*hardware_reset)(struct mmc_host *host);
 };
 
 struct mmc_card;
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 956fbd8..b7ab0da 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -251,6 +251,7 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_RST		162	/* onetime programmable R/W */
 #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
 #define EXT_CSD_ERASED_MEM_CONT		181	/* RO */
 #define EXT_CSD_BUS_WIDTH		183	/* R/W */
-- 
1.6.6.1


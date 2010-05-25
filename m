Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403Ab0EYQRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:17:15 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:35198 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837Ab0EYQRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:17:12 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 12:17:12 EDT
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <1-1000-12432-1274803827-7569@rere.qmqm.pl>
Subject: [RFC] [PATCH 1/2] mmc: split mmc_sd_init_card()
Date: Tue, 25 May 2010 18:10:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed to avoid code duplication in SD-combo support.
---
 drivers/mmc/core/sd.c |  256 ++++++++++++++++++++++++++++--------------------
 drivers/mmc/core/sd.h |   17 ++++
 2 files changed, 166 insertions(+), 107 deletions(-)
 create mode 100644 drivers/mmc/core/sd.h

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 5eac21d..75fad9a 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -59,7 +59,7 @@ static const unsigned int tacc_mant[] = {
 /*
  * Given the decoded CSD structure, decode the raw CID to our CID structure.
  */
-static void mmc_decode_cid(struct mmc_card *card)
+void mmc_decode_cid(struct mmc_card *card)
 {
 	u32 *resp = card->raw_cid;
 
@@ -238,22 +238,22 @@ out:
 /*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
-static int mmc_switch_hs(struct mmc_card *card)
+int mmc_sd_switch_hs(struct mmc_card *card)
 {
 	int err;
 	u8 *status;
 
 	if (card->scr.sda_vsn < SCR_SPEC_VER_1)
-		return 0;
+		return -EOPNOTSUPP;
 
 	if (!(card->csd.cmdclass & CCC_SWITCH))
-		return 0;
+		return -EOPNOTSUPP;
 
 	if (!(card->host->caps & MMC_CAP_SD_HIGHSPEED))
-		return 0;
+		return -EOPNOTSUPP;
 
 	if (card->sw_caps.hs_max_dtr == 0)
-		return 0;
+		return -EOPNOTSUPP;
 
 	err = -EIO;
 
@@ -272,9 +272,7 @@ static int mmc_switch_hs(struct mmc_card *card)
 		printk(KERN_WARNING "%s: Problem switching card "
 			"into high-speed mode!\n",
 			mmc_hostname(card->host));
-	} else {
-		mmc_card_set_highspeed(card);
-		mmc_set_timing(card->host, MMC_TIMING_SD_HS);
+		err = -EOPNOTSUPP;
 	}
 
 out:
@@ -320,26 +318,16 @@ static const struct attribute_group *sd_attr_groups[] = {
 	NULL,
 };
 
-static struct device_type sd_type = {
+struct device_type sd_type = {
 	.groups = sd_attr_groups,
 };
 
 /*
- * Handle the detection and initialisation of a card.
- *
- * In the case of a resume, "oldcard" will contain the card
- * we're trying to reinitialise.
+ * Fetch CID from card.
  */
-static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
-	struct mmc_card *oldcard)
+int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid)
 {
-	struct mmc_card *card;
 	int err;
-	u32 cid[4];
-	unsigned int max_dtr;
-
-	BUG_ON(!host);
-	WARN_ON(!host->claimed);
 
 	/*
 	 * Since we're changing the OCR value, we seem to
@@ -361,23 +349,137 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 
 	err = mmc_send_app_op_cond(host, ocr, NULL);
 	if (err)
-		goto err;
+		return err;
 
-	/*
-	 * Fetch CID from card.
-	 */
 	if (mmc_host_is_spi(host))
 		err = mmc_send_cid(host, cid);
 	else
 		err = mmc_all_send_cid(host, cid);
+	
+	return err;
+}
+
+int mmc_sd_get_csd(struct mmc_host *host, struct mmc_card *card)
+{
+	int err;
+
+	/*
+	 * Fetch CSD from card.
+	 */
+	err = mmc_send_csd(card, card->raw_csd);
 	if (err)
-		goto err;
+		return err;
 
-	if (oldcard) {
-		if (memcmp(cid, oldcard->raw_cid, sizeof(cid)) != 0) {
-			err = -ENOENT;
-			goto err;
+	err = mmc_decode_csd(card);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
+	bool reinit)
+{
+	int err;
+
+	if (!reinit) {
+		/*
+		 * Fetch SCR from card.
+		 */
+		err = mmc_app_send_scr(card, card->raw_scr);
+		if (err)
+			return err;
+
+		err = mmc_decode_scr(card);
+		if (err)
+			return err;
+
+		/*
+		 * Fetch switch information from card.
+		 */
+		err = mmc_read_switch(card);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * For SPI, enable CRC as appropriate.
+	 * This CRC enable is located AFTER the reading of the
+	 * card registers because some SDHC cards are not able
+	 * to provide valid CRCs for non-512-byte blocks.
+	 */
+	if (mmc_host_is_spi(host)) {
+		err = mmc_spi_set_crc(host, use_spi_crc);
+		if (err)
+			return err;
+	}
+
+	/*
+	 * Check if read-only switch is active.
+	 */
+	if (!reinit) {
+		int ro = -1;
+
+		if (host->ops->get_ro)
+			ro = host->ops->get_ro(host);
+
+		if (ro < 0) {
+			printk(KERN_WARNING "%s: host does not "
+				"support reading read-only "
+				"switch. assuming write-enable.\n",
+				mmc_hostname(host));
+		} else if (ro > 0) {
+			mmc_card_set_readonly(card);
 		}
+	}
+
+	return 0;
+}
+
+unsigned mmc_sd_get_max_clock(struct mmc_card *card)
+{
+	unsigned max_dtr = (unsigned int)-1;
+
+	if (mmc_card_highspeed(card)) {
+		if (max_dtr > card->sw_caps.hs_max_dtr)
+			max_dtr = card->sw_caps.hs_max_dtr;
+	} else if (max_dtr > card->csd.max_dtr) {
+		max_dtr = card->csd.max_dtr;
+	}
+
+	return max_dtr;
+}
+
+void mmc_sd_go_highspeed(struct mmc_card *card)
+{
+	mmc_card_set_highspeed(card);
+	mmc_set_timing(card->host, MMC_TIMING_SD_HS);
+}
+
+/*
+ * Handle the detection and initialisation of a card.
+ *
+ * In the case of a resume, "oldcard" will contain the card
+ * we're trying to reinitialise.
+ */
+static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
+	struct mmc_card *oldcard)
+{
+	struct mmc_card *card;
+	int err;
+	u32 cid[4];
+	unsigned int max_dtr;
+
+	BUG_ON(!host);
+	WARN_ON(!host->claimed);
+
+	err = mmc_sd_get_cid(host, ocr, cid);
+	if (err)
+		return err;
+
+	if (oldcard) {
+		if (memcmp(cid, oldcard->raw_cid, sizeof(cid)) != 0)
+			return -ENOENT;
 
 		card = oldcard;
 	} else {
@@ -385,10 +487,8 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		 * Allocate card structure.
 		 */
 		card = mmc_alloc_card(host, &sd_type);
-		if (IS_ERR(card)) {
-			err = PTR_ERR(card);
-			goto err;
-		}
+		if (IS_ERR(card))
+			return PTR_ERR(card);
 
 		card->type = MMC_TYPE_SD;
 		memcpy(card->raw_cid, cid, sizeof(card->raw_cid));
@@ -400,22 +500,15 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	if (!mmc_host_is_spi(host)) {
 		err = mmc_send_relative_addr(host, &card->rca);
 		if (err)
-			goto free_card;
+			return err;
 
 		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
 	}
 
 	if (!oldcard) {
-		/*
-		 * Fetch CSD from card.
-		 */
-		err = mmc_send_csd(card, card->raw_csd);
+		err = mmc_sd_get_csd(host, card);
 		if (err)
-			goto free_card;
-
-		err = mmc_decode_csd(card);
-		if (err)
-			goto free_card;
+			return err;
 
 		mmc_decode_cid(card);
 	}
@@ -426,60 +519,27 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	if (!mmc_host_is_spi(host)) {
 		err = mmc_select_card(card);
 		if (err)
-			goto free_card;
+			return err;
 	}
 
-	if (!oldcard) {
-		/*
-		 * Fetch SCR from card.
-		 */
-		err = mmc_app_send_scr(card, card->raw_scr);
-		if (err)
-			goto free_card;
-
-		err = mmc_decode_scr(card);
-		if (err < 0)
-			goto free_card;
-
-		/*
-		 * Fetch switch information from card.
-		 */
-		err = mmc_read_switch(card);
-		if (err)
-			goto free_card;
-	}
+	err = mmc_sd_setup_card(host, card, oldcard != NULL);
+	if (err)
+		goto free_card;
 
 	/*
-	 * For SPI, enable CRC as appropriate.
-	 * This CRC enable is located AFTER the reading of the
-	 * card registers because some SDHC cards are not able
-	 * to provide valid CRCs for non-512-byte blocks.
+	 * Attempt to change to high-speed (if supported)
 	 */
-	if (mmc_host_is_spi(host)) {
-		err = mmc_spi_set_crc(host, use_spi_crc);
-		if (err)
+	err = mmc_sd_switch_hs(card);
+	if (err) {
+		if (err != -EOPNOTSUPP)
 			goto free_card;
+		mmc_sd_go_highspeed(card);
 	}
 
 	/*
-	 * Attempt to change to high-speed (if supported)
-	 */
-	err = mmc_switch_hs(card);
-	if (err)
-		goto free_card;
-
-	/*
 	 * Compute bus speed.
 	 */
-	max_dtr = (unsigned int)-1;
-
-	if (mmc_card_highspeed(card)) {
-		if (max_dtr > card->sw_caps.hs_max_dtr)
-			max_dtr = card->sw_caps.hs_max_dtr;
-	} else if (max_dtr > card->csd.max_dtr) {
-		max_dtr = card->csd.max_dtr;
-	}
-
+	max_dtr = mmc_sd_get_max_clock(card);
 	mmc_set_clock(host, max_dtr);
 
 	/*
@@ -494,30 +554,12 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 		mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
 	}
 
-	/*
-	 * Check if read-only switch is active.
-	 */
-	if (!oldcard) {
-		if (!host->ops->get_ro || host->ops->get_ro(host) < 0) {
-			printk(KERN_WARNING "%s: host does not "
-				"support reading read-only "
-				"switch. assuming write-enable.\n",
-				mmc_hostname(host));
-		} else {
-			if (host->ops->get_ro(host) > 0)
-				mmc_card_set_readonly(card);
-		}
-	}
-
-	if (!oldcard)
-		host->card = card;
-
+	host->card = card;
 	return 0;
 
 free_card:
 	if (!oldcard)
 		mmc_remove_card(card);
-err:
 
 	return err;
 }
diff --git a/drivers/mmc/core/sd.h b/drivers/mmc/core/sd.h
new file mode 100644
index 0000000..3d8800f
--- /dev/null
+++ b/drivers/mmc/core/sd.h
@@ -0,0 +1,17 @@
+#ifndef _MMC_CORE_SD_H
+#define _MMC_CORE_SD_H
+
+#include <linux/mmc/card.h>
+
+extern struct device_type sd_type;
+
+int mmc_sd_get_cid(struct mmc_host *host, u32 ocr, u32 *cid);
+int mmc_sd_get_csd(struct mmc_host *host, struct mmc_card *card);
+void mmc_decode_cid(struct mmc_card *card);
+int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
+	bool reinit);
+unsigned mmc_sd_get_max_clock(struct mmc_card *card);
+int mmc_sd_switch_hs(struct mmc_card *card);
+void mmc_sd_go_highspeed(struct mmc_card *card);
+
+#endif
-- 
1.6.4.4


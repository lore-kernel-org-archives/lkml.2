Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab0FER37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:29:59 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:35039 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab0FER30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:29:26 -0400
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>
Message-ID: <2-1000-17336-1275758964-1828@rere.qmqm.pl>
In-Reply-To: <1-1000-17336-1275758964-1828@rere.qmqm.pl>
Date: Sat,  5 Jun 2010 19:29:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4b79c6ed22da18382748f578f9b4beb2d51afef3 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Fri, 4 Jun 2010 21:37:00 +0200
Subject: [PATCH 1/2] mmc: split mmc_sd_init_card()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Prepare for SD-combo (IO+mem) support by splitting SD memory
card init and related functions.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/mmc/core/sd.c   |  249 +++++++++++++++++++++++++++--------------------
 drivers/mmc/core/sd.h   |   17 +++
 drivers/mmc/core/sdio.c |   39 +++++---
 3 files changed, 186 insertions(+), 119 deletions(-)
 create mode 100644 drivers/mmc/core/sd.h

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 5eac21d..840be1b 100644
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
 
@@ -238,7 +238,7 @@ out:
 /*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
-static int mmc_switch_hs(struct mmc_card *card)
+int mmc_sd_switch_hs(struct mmc_card *card)
 {
 	int err;
 	u8 *status;
@@ -272,9 +272,9 @@ static int mmc_switch_hs(struct mmc_card *card)
 		printk(KERN_WARNING "%s: Problem switching card "
 			"into high-speed mode!\n",
 			mmc_hostname(card->host));
+		err = 0;
 	} else {
-		mmc_card_set_highspeed(card);
-		mmc_set_timing(card->host, MMC_TIMING_SD_HS);
+		err = 1;
 	}
 
 out:
@@ -320,26 +320,16 @@ static const struct attribute_group *sd_attr_groups[] = {
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
@@ -361,23 +351,136 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 
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
@@ -385,10 +488,8 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
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
@@ -400,22 +501,15 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
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
@@ -426,61 +520,26 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	if (!mmc_host_is_spi(host)) {
 		err = mmc_select_card(card);
 		if (err)
-			goto free_card;
-	}
-
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
+			return err;
 	}
 
-	/*
-	 * For SPI, enable CRC as appropriate.
-	 * This CRC enable is located AFTER the reading of the
-	 * card registers because some SDHC cards are not able
-	 * to provide valid CRCs for non-512-byte blocks.
-	 */
-	if (mmc_host_is_spi(host)) {
-		err = mmc_spi_set_crc(host, use_spi_crc);
-		if (err)
-			goto free_card;
-	}
+	err = mmc_sd_setup_card(host, card, oldcard != NULL);
+	if (err)
+		goto free_card;
 
 	/*
 	 * Attempt to change to high-speed (if supported)
 	 */
-	err = mmc_switch_hs(card);
-	if (err)
+	err = mmc_sd_switch_hs(card);
+	if (err > 0)
+		mmc_sd_go_highspeed(card);
+	else if (err)
 		goto free_card;
 
 	/*
-	 * Compute bus speed.
+	 * Set bus speed.
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
-	mmc_set_clock(host, max_dtr);
+	mmc_set_clock(host, mmc_sd_get_max_clock(card));
 
 	/*
 	 * Switch to wider bus (if supported).
@@ -494,30 +553,12 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
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
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 2dd4cfe..8a97e99 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -18,6 +18,7 @@
 
 #include "core.h"
 #include "bus.h"
+#include "sd.h"
 #include "sdio_bus.h"
 #include "mmc_ops.h"
 #include "sd_ops.h"
@@ -245,10 +246,26 @@ static int sdio_enable_hs(struct mmc_card *card)
 	if (ret)
 		return ret;
 
-	mmc_card_set_highspeed(card);
-	mmc_set_timing(card->host, MMC_TIMING_SD_HS);
+	return 1;
+}
 
-	return 0;
+static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
+{
+	unsigned max_dtr;
+
+	if (mmc_card_highspeed(card)) {
+		/*
+		 * The SDIO specification doesn't mention how
+		 * the CIS transfer speed register relates to
+		 * high-speed, but it seems that 50 MHz is
+		 * mandatory.
+		 */
+		max_dtr = 50000000;
+	} else {
+		max_dtr = card->cis.max_dtr;
+	}
+
+	return max_dtr;
 }
 
 /*
@@ -345,23 +362,15 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	 * Switch to high-speed (if supported).
 	 */
 	err = sdio_enable_hs(card);
-	if (err)
+	if (err > 0)
+		mmc_sd_go_highspeed(card);
+	else if (err)
 		goto remove;
 
 	/*
 	 * Change to the card's maximum speed.
 	 */
-	if (mmc_card_highspeed(card)) {
-		/*
-		 * The SDIO specification doesn't mention how
-		 * the CIS transfer speed register relates to
-		 * high-speed, but it seems that 50 MHz is
-		 * mandatory.
-		 */
-		mmc_set_clock(host, 50000000);
-	} else {
-		mmc_set_clock(host, card->cis.max_dtr);
-	}
+	mmc_set_clock(host, mmc_sdio_get_max_clock(card));
 
 	/*
 	 * Switch to wider bus (if supported).
-- 
1.6.4.4


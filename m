Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0FER33 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 13:29:29 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:35040 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab0FER30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 13:29:26 -0400
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>, Chris Ball <cjb@laptop.org>
Message-ID: <3-1000-17336-1275758964-1828@rere.qmqm.pl>
In-Reply-To: <1-1000-17336-1275758964-1828@rere.qmqm.pl>
Date: Sat,  5 Jun 2010 19:29:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 46eda5101dd303feac7f8353023f78bf4f7fd2fe Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Sat, 5 Jun 2010 19:03:40 +0200
Subject: [PATCH 2/2] mmc: implement SD-combo (IO+mem) support
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/mmc/core/bus.c   |    9 +++
 drivers/mmc/core/core.c  |   12 ++++-
 drivers/mmc/core/sdio.c  |  135 ++++++++++++++++++++++++++++++++++++++-------
 include/linux/mmc/card.h |    1 +
 4 files changed, 134 insertions(+), 23 deletions(-)

diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 49d9dca..7cd9749 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -37,6 +37,8 @@ static ssize_t mmc_type_show(struct device *dev,
 		return sprintf(buf, "SD\n");
 	case MMC_TYPE_SDIO:
 		return sprintf(buf, "SDIO\n");
+	case MMC_TYPE_SD_COMBO:
+		return sprintf(buf, "SDcombo\n");
 	default:
 		return -EFAULT;
 	}
@@ -74,6 +76,9 @@ mmc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 	case MMC_TYPE_SDIO:
 		type = "SDIO";
 		break;
+	case MMC_TYPE_SD_COMBO:
+		type = "SDcombo";
+		break;
 	default:
 		type = NULL;
 	}
@@ -239,6 +244,10 @@ int mmc_add_card(struct mmc_card *card)
 	case MMC_TYPE_SDIO:
 		type = "SDIO";
 		break;
+	case MMC_TYPE_SD_COMBO:
+		type = "SD-combo";
+		if (mmc_card_blockaddr(card))
+			type = "SDHC-combo";
 	default:
 		type = "?";
 		break;
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 3168ebd..87cf0de 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1099,8 +1099,15 @@ void mmc_rescan(struct work_struct *work)
 	 */
 	err = mmc_send_io_op_cond(host, 0, &ocr);
 	if (!err) {
-		if (mmc_attach_sdio(host, ocr))
-			mmc_power_off(host);
+		if (mmc_attach_sdio(host, ocr)) {
+			mmc_claim_host(host);
+			/* try SDMEM (but not MMC) even if SDIO is broken */
+			if (mmc_send_app_op_cond(host, 0, &ocr))
+				goto out_fail;
+
+			if (mmc_attach_sd(host, ocr))
+				mmc_power_off(host);
+		}
 		goto out;
 	}
 
@@ -1124,6 +1131,7 @@ void mmc_rescan(struct work_struct *work)
 		goto out;
 	}
 
+out_fail:
 	mmc_release_host(host);
 	mmc_power_off(host);
 
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 8a97e99..dc23427 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -160,9 +160,7 @@ static int sdio_enable_wide(struct mmc_card *card)
 	if (ret)
 		return ret;
 
-	mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
-
-	return 0;
+	return 1;
 }
 
 /*
@@ -222,10 +220,34 @@ static int sdio_disable_wide(struct mmc_card *card)
 	return 0;
 }
 
+
+static int sdio_enable_4bit_bus(struct mmc_card *card)
+{
+	int err;
+
+	if (card->type == MMC_TYPE_SDIO)
+		return sdio_enable_wide(card);
+
+	if ((card->host->caps & MMC_CAP_4_BIT_DATA) &&
+		(card->scr.bus_widths & SD_SCR_BUS_WIDTH_4)) {
+		err = mmc_app_set_bus_width(card, MMC_BUS_WIDTH_4);
+		if (err)
+			return err;
+	} else
+		return 0;
+
+	err = sdio_enable_wide(card);
+	if (err <= 0)
+		mmc_app_set_bus_width(card, MMC_BUS_WIDTH_1);
+
+	return err;
+}
+
+
 /*
  * Test if the card supports high-speed mode and, if so, switch to it.
  */
-static int sdio_enable_hs(struct mmc_card *card)
+static int mmc_sdio_switch_hs(struct mmc_card *card, int enable)
 {
 	int ret;
 	u8 speed;
@@ -240,7 +262,10 @@ static int sdio_enable_hs(struct mmc_card *card)
 	if (ret)
 		return ret;
 
-	speed |= SDIO_SPEED_EHS;
+	if (enable)
+		speed |= SDIO_SPEED_EHS;
+	else
+		speed &= ~SDIO_SPEED_EHS;
 
 	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_SPEED, speed, NULL);
 	if (ret)
@@ -249,6 +274,24 @@ static int sdio_enable_hs(struct mmc_card *card)
 	return 1;
 }
 
+/*
+ * Enable SDIO/combo card's high-speed mode. Return 0/1 if [not]supported.
+ */
+static int sdio_enable_hs(struct mmc_card *card)
+{
+	int ret;
+
+	ret = mmc_sdio_switch_hs(card, true);
+	if (ret <= 0 || card->type == MMC_TYPE_SDIO)
+		return ret;
+
+	ret = mmc_sd_switch_hs(card);
+	if (ret <= 0)
+		mmc_sdio_switch_hs(card, false);
+
+	return ret;
+}
+
 static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 {
 	unsigned max_dtr;
@@ -265,6 +308,9 @@ static unsigned mmc_sdio_get_max_clock(struct mmc_card *card)
 		max_dtr = card->cis.max_dtr;
 	}
 
+	if (card->type == MMC_TYPE_SD_COMBO)
+		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
+
 	return max_dtr;
 }
 
@@ -310,7 +356,24 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 		goto err;
 	}
 
-	card->type = MMC_TYPE_SDIO;
+	err = mmc_sd_get_cid(host, host->ocr & ocr, card->raw_cid);
+
+	if (!err) {
+		card->type = MMC_TYPE_SD_COMBO;
+
+		if (oldcard && (oldcard->type != MMC_TYPE_SD_COMBO ||
+		    memcmp(card->raw_cid, oldcard->raw_cid, sizeof(card->raw_cid)) != 0)) {
+			mmc_remove_card(card);
+			return -ENOENT;
+		}
+	} else {
+		card->type = MMC_TYPE_SDIO;
+
+		if (oldcard && oldcard->type != MMC_TYPE_SDIO) {
+			mmc_remove_card(card);
+			return -ENOENT;
+		}
+	}
 
 	/*
 	 * For native busses:  set card RCA and quit open drain mode.
@@ -324,6 +387,17 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * Read CSD, before selecting the card
+	 */
+	if (!oldcard && card->type == MMC_TYPE_SD_COMBO) {
+		err = mmc_sd_get_csd(host, card);
+		if (err)
+			return err;
+
+		mmc_decode_cid(card);
+	}
+
+	/*
 	 * Select card, as all following commands rely on that.
 	 */
 	if (!powered_resume && !mmc_host_is_spi(host)) {
@@ -350,14 +424,33 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 		int same = (card->cis.vendor == oldcard->cis.vendor &&
 			    card->cis.device == oldcard->cis.device);
 		mmc_remove_card(card);
-		if (!same) {
-			err = -ENOENT;
-			goto err;
-		}
+		if (!same)
+			return -ENOENT;
+
 		card = oldcard;
 		return 0;
 	}
 
+	if (card->type == MMC_TYPE_SD_COMBO) {
+		err = mmc_sd_setup_card(host, card, oldcard != NULL);
+		/* handle as SDIO-only card if memory init failed */
+		if (err) {
+			mmc_go_idle(host);
+			if (mmc_host_is_spi(host))
+				/* should not fail, as it worked previously */
+				mmc_spi_set_crc(host, use_spi_crc);
+			card->type = MMC_TYPE_SDIO;
+		} else
+			card->dev.type = &sd_type;
+	}
+
+	/*
+	 * If needed, disconnect card detection pull-up resistor.
+	 */
+	err = sdio_disable_cd(card);
+	if (err)
+		goto remove;
+
 	/*
 	 * Switch to high-speed (if supported).
 	 */
@@ -375,8 +468,10 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	/*
 	 * Switch to wider bus (if supported).
 	 */
-	err = sdio_enable_wide(card);
-	if (err)
+	err = sdio_enable_4bit_bus(card);
+	if (err > 0)
+		mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
+	else if (err)
 		goto remove;
 
 	if (!oldcard)
@@ -490,9 +585,14 @@ static int mmc_sdio_resume(struct mmc_host *host)
 	mmc_claim_host(host);
 	err = mmc_sdio_init_card(host, host->ocr, host->card,
 				 (host->pm_flags & MMC_PM_KEEP_POWER));
-	if (!err)
+	if (!err) {
 		/* We may have switched to 1-bit mode during suspend. */
-		err = sdio_enable_wide(host->card);
+		err = sdio_enable_4bit_bus(host->card);
+		if (err > 0) {
+			mmc_set_bus_width(host, MMC_BUS_WIDTH_4);
+			err = 0;
+		}
+	}
 	if (!err && host->sdio_irqs)
 		mmc_signal_sdio_irq(host);
 	mmc_release_host(host);
@@ -577,13 +677,6 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
 	card->sdio_funcs = 0;
 
 	/*
-	 * If needed, disconnect card detection pull-up resistor.
-	 */
-	err = sdio_disable_cd(card);
-	if (err)
-		goto remove;
-
-	/*
 	 * Initialize (but don't add) all present functions.
 	 */
 	for (i = 0; i < funcs; i++, card->sdio_funcs++) {
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index d02d2c6..dc570f5 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -92,6 +92,7 @@ struct mmc_card {
 #define MMC_TYPE_MMC		0		/* MMC card */
 #define MMC_TYPE_SD		1		/* SD card */
 #define MMC_TYPE_SDIO		2		/* SDIO card */
+#define MMC_TYPE_SD_COMBO	3		/* SD combo (IO+mem) card */
 	unsigned int		state;		/* (our) card state */
 #define MMC_STATE_PRESENT	(1<<0)		/* present in sysfs */
 #define MMC_STATE_READONLY	(1<<1)		/* card is read-only */
-- 
1.6.4.4


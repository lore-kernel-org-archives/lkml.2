Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab0EYQRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:17:16 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:35199 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758838Ab0EYQRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:17:13 -0400
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <2-1000-12432-1274803827-7569@rere.qmqm.pl>
In-Reply-To: <1-1000-12432-1274803827-7569@rere.qmqm.pl>
Subject: [RFC] [PATCH 2/2] mmc: implement SD-combo (IO+mem) support
Date: Tue, 25 May 2010 18:10:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/mmc/core/bus.c   |    9 +++
 drivers/mmc/core/core.c  |   12 +++-
 drivers/mmc/core/sdio.c  |  178 ++++++++++++++++++++++++++++++++++++---------
 include/linux/mmc/card.h |    1 +
 4 files changed, 162 insertions(+), 38 deletions(-)

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
index 2dd4cfe..aebb0b0 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -18,6 +18,7 @@
 
 #include "core.h"
 #include "bus.h"
+#include "sd.h"
 #include "sdio_bus.h"
 #include "mmc_ops.h"
 #include "sd_ops.h"
@@ -144,10 +145,10 @@ static int sdio_enable_wide(struct mmc_card *card)
 	u8 ctrl;
 
 	if (!(card->host->caps & MMC_CAP_4_BIT_DATA))
-		return 0;
+		return -EOPNOTSUPP;
 
 	if (card->cccr.low_speed && !card->cccr.wide_bus)
-		return 0;
+		return -EOPNOTSUPP;
 
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_IF, 0, &ctrl);
 	if (ret)
@@ -159,8 +160,6 @@ static int sdio_enable_wide(struct mmc_card *card)
 	if (ret)
 		return ret;
 
-	mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
-
 	return 0;
 }
 
@@ -221,36 +220,98 @@ static int sdio_disable_wide(struct mmc_card *card)
 	return 0;
 }
 
+
+static int sdio_enable_4bit_bus(struct mmc_card *card)
+{
+	int err;
+
+	if (card->type == MMC_TYPE_SD_COMBO) {
+		if ((card->host->caps & MMC_CAP_4_BIT_DATA) &&
+			(card->scr.bus_widths & SD_SCR_BUS_WIDTH_4)) {
+			err = mmc_app_set_bus_width(card, MMC_BUS_WIDTH_4);
+			if (err)
+				return err;
+		} else
+			return -EOPNOTSUPP;
+	}
+
+	err = sdio_enable_wide(card);
+	if (err == -EOPNOTSUPP && card->type == MMC_TYPE_SD_COMBO)
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
 
 	if (!(card->host->caps & MMC_CAP_SD_HIGHSPEED))
-		return 0;
+		return -EOPNOTSUPP;
 
 	if (!card->cccr.high_speed)
-		return 0;
+		return -EOPNOTSUPP;
 
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_SPEED, 0, &speed);
 	if (ret)
 		return ret;
 
-	speed |= SDIO_SPEED_EHS;
+	if (enable)
+		speed |= SDIO_SPEED_EHS;
+	else
+		speed &= ~SDIO_SPEED_EHS;
 
 	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_SPEED, speed, NULL);
 	if (ret)
 		return ret;
 
-	mmc_card_set_highspeed(card);
-	mmc_set_timing(card->host, MMC_TIMING_SD_HS);
-
 	return 0;
 }
 
+static int sdio_enable_hs(struct mmc_card *card)
+{
+	int err;
+
+	err = mmc_sdio_switch_hs(card, true);
+	if (err)
+		return err;
+
+	if (card->type == MMC_TYPE_SD_COMBO) {
+		err = mmc_sd_switch_hs(card);
+		if (err == -EOPNOTSUPP)
+			mmc_sdio_switch_hs(card, false);
+	}
+
+	return err;
+}
+
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
+	if (card->type == MMC_TYPE_SD_COMBO)
+		max_dtr = min(max_dtr, mmc_sd_get_max_clock(card));
+
+	return max_dtr;
+}
+
 /*
  * Handle the detection and initialisation of a card.
  *
@@ -295,6 +356,34 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 
 	card->type = MMC_TYPE_SDIO;
 
+	if (!oldcard || oldcard->type == MMC_TYPE_SDIO) {
+		u32 cid[4];
+
+		err = mmc_sd_get_cid(host, host->ocr & ocr, cid);
+		if (!err) {
+			/* this is SD-combo card */
+			if (oldcard && oldcard->type == MMC_TYPE_SDIO) {
+				err = -ENOENT;
+				goto remove;
+			}
+			card->type = MMC_TYPE_SD_COMBO;
+			memcpy(card->raw_cid, cid, sizeof(card->raw_cid));
+		}
+	} else if (oldcard->type == MMC_TYPE_SD_COMBO) {
+		u32 cid[4];
+
+		err = mmc_sd_get_cid(host, host->ocr & ocr, cid);
+		if (err) {
+			/* this is SDIO-only card */
+			goto remove;
+		}
+
+		if (memcmp(cid, oldcard->raw_cid, sizeof(cid)) != 0) {
+			err = -ENOENT;
+			goto remove;
+		}
+	}
+
 	/*
 	 * For native busses:  set card RCA and quit open drain mode.
 	 */
@@ -307,6 +396,17 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
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
@@ -333,41 +433,54 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
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
 	err = sdio_enable_hs(card);
-	if (err)
+	if (!err)
+		mmc_sd_go_highspeed(card);
+	else if (err != -EOPNOTSUPP)
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
 	 */
-	err = sdio_enable_wide(card);
-	if (err)
+	err = sdio_enable_4bit_bus(card);
+	if (!err)
+		mmc_set_bus_width(card->host, MMC_BUS_WIDTH_4);
+	else if (err != -EOPNOTSUPP)
 		goto remove;
 
 	if (!oldcard)
@@ -568,13 +681,6 @@ int mmc_attach_sdio(struct mmc_host *host, u32 ocr)
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


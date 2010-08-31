Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab0HaP0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:26:01 -0400
Received: from mail.df.lth.se ([194.47.250.12]:58475 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932372Ab0HaP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:26:00 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tony Lindgren <tony@atomide.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        Jarkko Lavinen <jarkko.lavinen@nokia.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] MMC: move regulator handling closer to core v2
Date: Tue, 31 Aug 2010 17:26:06 +0200
Message-Id: <1283268367-3525-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After discovering a problem in regulator reference counting I
took Mark Brown's advice to move the reference count into the
MMC core by making the regulator status a member of
struct mmc_host.

I took this opportunity to also implement NULL versions of
the regulator functions so as to rid the driver code from
some ugly #ifdef CONFIG_REGULATOR clauses.
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Cliff Brake <cbrake@bec-systems.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
Changes V1->V2:
- Moved #ifdef:ed out regulator code to core.h header
- Moved error print into the core regulator code
---
 drivers/mmc/core/core.c       |   26 ++++++++++++++++----------
 drivers/mmc/host/mmci.c       |   11 ++++-------
 drivers/mmc/host/omap_hsmmc.c |   21 +++++++++++++--------
 drivers/mmc/host/pxamci.c     |   18 ++++++++++++------
 include/linux/mmc/host.h      |   22 +++++++++++++++++++++-
 5 files changed, 66 insertions(+), 32 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 5db49b1..2d47467 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -771,8 +771,9 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
 
 /**
  * mmc_regulator_set_ocr - set regulator to match host->ios voltage
- * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
+ * @mmc: the host to regulate
  * @supply: regulator to use
+ * @vdd_bit: zero for power off, else a bit number (host->ios.vdd)
  *
  * Returns zero on success, else negative errno.
  *
@@ -780,15 +781,12 @@ EXPORT_SYMBOL(mmc_regulator_get_ocrmask);
  * a particular supply voltage.  This would normally be called from the
  * set_ios() method.
  */
-int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
+int mmc_regulator_set_ocr(struct mmc_host *mmc,
+			struct regulator *supply,
+			unsigned short vdd_bit)
 {
 	int			result = 0;
 	int			min_uV, max_uV;
-	int			enabled;
-
-	enabled = regulator_is_enabled(supply);
-	if (enabled < 0)
-		return enabled;
 
 	if (vdd_bit) {
 		int		tmp;
@@ -819,17 +817,25 @@ int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit)
 		else
 			result = 0;
 
-		if (result == 0 && !enabled)
+		if (result == 0 && !mmc->regulator_enabled) {
 			result = regulator_enable(supply);
-	} else if (enabled) {
+			if (!result)
+				mmc->regulator_enabled = true;
+		}
+	} else if (mmc->regulator_enabled) {
 		result = regulator_disable(supply);
+		if (result == 0)
+			mmc->regulator_enabled = false;
 	}
 
+	if (result)
+		dev_err(mmc_dev(mmc),
+			"could not set regulator OCR (%d)\n", result);
 	return result;
 }
 EXPORT_SYMBOL(mmc_regulator_set_ocr);
 
-#endif
+#endif /* CONFIG_REGULATOR */
 
 /*
  * Mask off any voltages we don't support and select
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 840b301..7f5ec67 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -507,19 +507,16 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	struct mmci_host *host = mmc_priv(mmc);
 	u32 pwr = 0;
 	unsigned long flags;
+	int ret;
 
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
-		if(host->vcc &&
-		   regulator_is_enabled(host->vcc))
-			regulator_disable(host->vcc);
+		if (host->vcc)
+			ret = mmc_regulator_set_ocr(mmc, host->vcc, 0);
 		break;
 	case MMC_POWER_UP:
-#ifdef CONFIG_REGULATOR
 		if (host->vcc)
-			/* This implicitly enables the regulator */
-			mmc_regulator_set_ocr(host->vcc, ios->vdd);
-#endif
+			ret = mmc_regulator_set_ocr(mmc, host->vcc, ios->vdd);
 		if (host->plat->vdd_handler)
 			pwr |= host->plat->vdd_handler(mmc_dev(mmc), ios->vdd,
 						       ios->power_mode);
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 4a8776f..14598ca 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -250,9 +250,9 @@ static int omap_hsmmc_1_set_power(struct device *dev, int slot, int power_on,
 		mmc_slot(host).before_set_reg(dev, slot, power_on, vdd);
 
 	if (power_on)
-		ret = mmc_regulator_set_ocr(host->vcc, vdd);
+		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
 	else
-		ret = mmc_regulator_set_ocr(host->vcc, 0);
+		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
 
 	if (mmc_slot(host).after_set_reg)
 		mmc_slot(host).after_set_reg(dev, slot, power_on, vdd);
@@ -291,18 +291,23 @@ static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
 	 * chips/cards need an interface voltage rail too.
 	 */
 	if (power_on) {
-		ret = mmc_regulator_set_ocr(host->vcc, vdd);
+		ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
 		/* Enable interface voltage rail, if needed */
 		if (ret == 0 && host->vcc_aux) {
 			ret = regulator_enable(host->vcc_aux);
 			if (ret < 0)
-				ret = mmc_regulator_set_ocr(host->vcc, 0);
+				ret = mmc_regulator_set_ocr(host->mmc,
+							host->vcc, 0);
 		}
 	} else {
+		/* Shut down the rail */
 		if (host->vcc_aux)
 			ret = regulator_disable(host->vcc_aux);
-		if (ret == 0)
-			ret = mmc_regulator_set_ocr(host->vcc, 0);
+		if (!ret) {
+			/* Then proceed to shut down the local regulator */
+			ret = mmc_regulator_set_ocr(host->mmc,
+						host->vcc, 0);
+		}
 	}
 
 	if (mmc_slot(host).after_set_reg)
@@ -343,9 +348,9 @@ static int omap_hsmmc_23_set_sleep(struct device *dev, int slot, int sleep,
 	if (cardsleep) {
 		/* VCC can be turned off if card is asleep */
 		if (sleep)
-			err = mmc_regulator_set_ocr(host->vcc, 0);
+			err = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
 		else
-			err = mmc_regulator_set_ocr(host->vcc, vdd);
+			err = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
 	} else
 		err = regulator_set_mode(host->vcc, mode);
 	if (err)
diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 0a4e43f..a219f1f 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -99,14 +99,20 @@ static inline void pxamci_init_ocr(struct pxamci_host *host)
 	}
 }
 
-static inline void pxamci_set_power(struct pxamci_host *host, unsigned int vdd)
+static inline void pxamci_set_power(struct pxamci_host *host,
+				    unsigned char power_mode,
+				    unsigned int vdd)
 {
 	int on;
 
-#ifdef CONFIG_REGULATOR
-	if (host->vcc)
-		mmc_regulator_set_ocr(host->vcc, vdd);
-#endif
+	if (host->vcc) {
+		int ret;
+
+		if (power_mode == MMC_POWER_UP)
+			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
+		else if (power_mode == MMC_POWER_OFF)
+			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
+	}
 	if (!host->vcc && host->pdata &&
 	    gpio_is_valid(host->pdata->gpio_power)) {
 		on = ((1 << vdd) & host->pdata->ocr_mask);
@@ -492,7 +498,7 @@ static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	if (host->power_mode != ios->power_mode) {
 		host->power_mode = ios->power_mode;
 
-		pxamci_set_power(host, ios->vdd);
+		pxamci_set_power(host, ios->power_mode, ios->vdd);
 
 		if (ios->power_mode == MMC_POWER_ON)
 			host->cmdat |= CMDAT_INIT;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 1575b52..d009d73 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -212,6 +212,10 @@ struct mmc_host {
 	struct led_trigger	*led;		/* activity led */
 #endif
 
+#ifdef CONFIG_REGULATOR
+	bool			regulator_enabled; /* regulator state */
+#endif
+
 	struct dentry		*debugfs_root;
 
 	unsigned long		private[0] ____cacheline_aligned;
@@ -250,8 +254,24 @@ static inline void mmc_signal_sdio_irq(struct mmc_host *host)
 
 struct regulator;
 
+#ifdef CONFIG_REGULATOR
 int mmc_regulator_get_ocrmask(struct regulator *supply);
-int mmc_regulator_set_ocr(struct regulator *supply, unsigned short vdd_bit);
+int mmc_regulator_set_ocr(struct mmc_host *mmc,
+			struct regulator *supply,
+			unsigned short vdd_bit);
+#else
+int inline mmc_regulator_get_ocrmask(struct regulator *supply)
+{
+	return 0;
+}
+
+int inline mmc_regulator_set_ocr(struct mmc_host *mmc,
+				 struct regulator *supply,
+				 unsigned short vdd_bit)
+{
+	return 0;
+}
+#endif
 
 int mmc_card_awake(struct mmc_host *host);
 int mmc_card_sleep(struct mmc_host *host);
-- 
1.7.2.2


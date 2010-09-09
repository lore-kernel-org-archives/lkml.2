Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0IIIFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 04:05:30 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:57757 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751311Ab0IIIFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 04:05:16 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-mmc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>, Linus Walleij <linus.walleij@stericsson.com>,
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
        Jarkko Lavinen <jarkko.lavinen@nokia.com>
Subject: [PATCH] MMC: move regulator handling closer to core v4
Date: Thu, 9 Sep 2010 10:03:06 +0200
Message-ID: <1284019386-26972-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
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
Changes v3->v4:

Propagate errors from regulator_set_ocr() properly in the
pxamci and mmci drivers, as far as is possible until we hit the
fact that mmc_set_ios() returns void and cannot handle error
codes.

Switched a pr_debug() in the PXA driver to a dev_dbg() as well
because it was disturbing to see it.

Andrew, if you want me to go in and fix the mmc_host_struct
.set_ios() member to supply and handle an int return value then I
can make a go, but is it OK to take this patch first and then fix
up that MMC core issue on top of this patch then?
---
 drivers/mmc/core/core.c       |   26 ++++++++++++++++----------
 drivers/mmc/host/mmci.c       |   28 ++++++++++++++++++----------
 drivers/mmc/host/omap_hsmmc.c |   21 +++++++++++++--------
 drivers/mmc/host/pxamci.c     |   41 +++++++++++++++++++++++++++++++++--------
 include/linux/mmc/host.h      |   22 +++++++++++++++++++++-
 5 files changed, 101 insertions(+), 37 deletions(-)

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
index 1932e9c..f716e3c 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -523,19 +523,27 @@ static void mmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
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
-		if (host->vcc)
-			/* This implicitly enables the regulator */
-			mmc_regulator_set_ocr(host->vcc, ios->vdd);
-#endif
+		if (host->vcc) {
+			ret = mmc_regulator_set_ocr(mmc, host->vcc, ios->vdd);
+			if (ret) {
+				dev_err(mmc_dev(mmc), "unable to set OCR\n");
+				/*
+				 * The .set_ios() function in the mmc_host_ops
+				 * struct return void, and failing to set the
+				 * power should be rare so we print an error
+				 * and return here.
+				 */
+				return;
+			}
+		}
 		if (host->plat->vdd_handler)
 			pwr |= host->plat->vdd_handler(mmc_dev(mmc), ios->vdd,
 						       ios->power_mode);
@@ -843,8 +851,8 @@ static int __devexit mmci_remove(struct amba_device *dev)
 		clk_disable(host->clk);
 		clk_put(host->clk);
 
-		if (regulator_is_enabled(host->vcc))
-			regulator_disable(host->vcc);
+		if (host->vcc)
+			mmc_regulator_set_ocr(mmc, host->vcc, 0);
 		regulator_put(host->vcc);
 
 		mmc_free_host(mmc);
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
index 0a4e43f..7609385 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -99,14 +99,25 @@ static inline void pxamci_init_ocr(struct pxamci_host *host)
 	}
 }
 
-static inline void pxamci_set_power(struct pxamci_host *host, unsigned int vdd)
+static inline int pxamci_set_power(struct pxamci_host *host,
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
+		if (power_mode == MMC_POWER_UP) {
+			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
+			if (ret)
+				return ret;
+		} else if (power_mode == MMC_POWER_OFF) {
+			ret = mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
+			if (ret)
+				return ret;
+		}
+	}
 	if (!host->vcc && host->pdata &&
 	    gpio_is_valid(host->pdata->gpio_power)) {
 		on = ((1 << vdd) & host->pdata->ocr_mask);
@@ -115,6 +126,8 @@ static inline void pxamci_set_power(struct pxamci_host *host, unsigned int vdd)
 	}
 	if (!host->vcc && host->pdata && host->pdata->setpower)
 		host->pdata->setpower(mmc_dev(host->mmc), vdd);
+
+	return 0;
 }
 
 static void pxamci_stop_clock(struct pxamci_host *host)
@@ -490,9 +503,21 @@ static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 	if (host->power_mode != ios->power_mode) {
+		int ret;
+
 		host->power_mode = ios->power_mode;
 
-		pxamci_set_power(host, ios->vdd);
+		ret = pxamci_set_power(host, ios->power_mode, ios->vdd);
+		if (ret) {
+			dev_err(mmc_dev(mmc), "unable to set power\n");
+			/*
+			 * The .set_ios() function in the mmc_host_ops
+			 * struct return void, and failing to set the
+			 * power should be rare so we print an error and
+			 * return here.
+			 */
+			return;
+		}
 
 		if (ios->power_mode == MMC_POWER_ON)
 			host->cmdat |= CMDAT_INIT;
@@ -503,8 +528,8 @@ static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	else
 		host->cmdat &= ~CMDAT_SD_4DAT;
 
-	pr_debug("PXAMCI: clkrt = %x cmdat = %x\n",
-		 host->clkrt, host->cmdat);
+	dev_dbg(mmc_dev(mmc), "PXAMCI: clkrt = %x cmdat = %x\n",
+		host->clkrt, host->cmdat);
 }
 
 static void pxamci_enable_sdio_irq(struct mmc_host *host, int enable)
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
1.6.3.3


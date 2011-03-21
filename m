Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1CUSrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:47:37 -0400
Received: from smtp208.alice.it ([82.57.200.104]:50744 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1CUSrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:47:16 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-mmc@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>,
        Ernst Schwab <eschwab@online.de>, Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mmc_spi.c: add support for the regulator framework
Date: Mon, 21 Mar 2011 19:46:42 +0100
Message-Id: <1300733202-27316-5-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for powering up SD cards driven by regulators.
This makes the mmc_spi driver work also with the Motorola A910 phone.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/mmc/host/mmc_spi.c |   61 +++++++++++++++++++++++++++++++++++--------
 1 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 5e4b2c7..d5fe841 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -31,6 +31,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/crc7.h>
 #include <linux/crc-itu-t.h>
+#include <linux/regulator/consumer.h>
 #include <linux/scatterlist.h>
 
 #include <linux/mmc/host.h>
@@ -150,11 +151,13 @@ struct mmc_spi_host {
 	 */
 	void			*ones;
 	dma_addr_t		ones_dma;
+
+	struct regulator	*vcc;
 };
 
 static inline int mmc_spi_canpower(struct mmc_spi_host *host)
 {
-	return host->pdata && host->pdata->setpower;
+	return (host->pdata && host->pdata->setpower) || host->vcc;
 }
 
 /****************************************************************************/
@@ -1225,17 +1228,35 @@ static inline int mmc_spi_setpower(struct mmc_spi_host *host,
 					unsigned char power_mode,
 					unsigned int vdd)
 {
+	if (!mmc_spi_canpower(host))
+		return -ENOSYS;
+
 	/* switch power on/off if possible, accounting for
 	 * max 250msec powerup time if needed.
 	 */
-	if (mmc_spi_canpower(host)) {
-		switch (power_mode) {
-		case MMC_POWER_OFF:
-		case MMC_POWER_UP:
+	switch (power_mode) {
+	case MMC_POWER_OFF:
+		if (host->vcc) {
+			int ret = mmc_regulator_set_ocr(host->mmc,
+							host->vcc, 0);
+			if (ret)
+				return ret;
+		} else {
+			host->pdata->setpower(&host->spi->dev, vdd);
+		}
+		break;
+
+	case MMC_POWER_UP:
+		if (host->vcc) {
+			int ret = mmc_regulator_set_ocr(host->mmc,
+							host->vcc, vdd);
+			if (ret)
+				return ret;
+		} else {
 			host->pdata->setpower(&host->spi->dev, vdd);
-			if (power_mode == MMC_POWER_UP)
-				msleep(host->powerup_msecs);
 		}
+		msleep(host->powerup_msecs);
+		break;
 	}
 
 	return 0;
@@ -1420,12 +1441,28 @@ static int mmc_spi_probe(struct spi_device *spi)
 	 * and power switching gpios.
 	 */
 	host->pdata = mmc_spi_get_pdata(spi);
-	if (host->pdata)
-		mmc->ocr_avail = host->pdata->ocr_mask;
-	if (!mmc->ocr_avail) {
-		dev_warn(&spi->dev, "ASSUMING 3.2-3.4 V slot power\n");
-		mmc->ocr_avail = MMC_VDD_32_33|MMC_VDD_33_34;
+#ifdef CONFIG_REGULATOR
+	host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
+
+	if (IS_ERR(host->vcc)) {
+		host->vcc = NULL;
+	} else {
+		host->mmc->ocr_avail = mmc_regulator_get_ocrmask(host->vcc);
+		if (host->pdata && host->pdata->ocr_mask)
+			dev_warn(mmc_dev(host->mmc),
+				"ocr_mask/setpower will not be used\n");
 	}
+#endif
+	if (host->vcc == NULL) {
+		/* fall-back to platform data */
+		if (host->pdata)
+			mmc->ocr_avail = host->pdata->ocr_mask;
+		if (!mmc->ocr_avail) {
+			dev_warn(&spi->dev, "ASSUMING 3.2-3.4 V slot power\n");
+			mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+		}
+	}
+
 	if (mmc_spi_canpower(host)) {
 		host->powerup_msecs = host->pdata->powerup_msecs;
 		if (!host->powerup_msecs || host->powerup_msecs > 250)
-- 
1.7.4.1


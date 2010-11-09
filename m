Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0KIKfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:35:46 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60661 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069Ab0KIKfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ry33YTJpBthxque9R3RxIDAQXX6CcRuJQMDSnYQ8wWkA5+W/W5LzZaG9mrjdYvXRfP
         qL/3MeeEieqtdwWjFTnpS7GUZObjNt7s+FHyuBq00eq6L4kXRm0qsWWwXY2vbXcdz1JB
         afmKiEH+ZV/EXWxUzPj/+KjsTLfTZ82ixiBn0=
Subject: [PATCH v2] mxcmmc: update the regulator support code to the latest
 API
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>
In-Reply-To: <20101108143746.GA23201@void.printf.net>
References: <1288656337.29881.13.camel@realization>
	 <20101102073932.GB6017@pengutronix.de>
	 <1288949275.3072.3.camel@realization>
	 <1289213595.3425.23.camel@realization>
	 <20101108143746.GA23201@void.printf.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 11:35:37 +0100
Message-ID: <1289298937.3020.34.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix also the build problem introduced by my previous patch
due to not handled API changes introduced by commit:
 99fc513 (mmc: Move regulator handling closer to core)

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---

This patch apply to the current mmc-next branch

 drivers/mmc/host/mxcmmc.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 1a7f48c..2b9f7c8 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -150,7 +150,6 @@ static void mxcmci_set_clk_rate(struct mxcmci_host *host, unsigned int clk_ios);
 
 static inline void mxcmci_init_ocr(struct mxcmci_host *host)
 {
-#ifdef CONFIG_REGULATOR
 	host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
 
 	if (IS_ERR(host->vcc)) {
@@ -161,7 +160,7 @@ static inline void mxcmci_init_ocr(struct mxcmci_host *host)
 			dev_warn(mmc_dev(host->mmc),
 				"pdata->ocr_avail will not be used\n");
 	}
-#endif
+
 	if (host->vcc == NULL) {
 		/* fall-back to platform data */
 		if (host->pdata && host->pdata->ocr_avail)
@@ -171,12 +170,17 @@ static inline void mxcmci_init_ocr(struct mxcmci_host *host)
 	}
 }
 
-static inline void mxcmci_set_power(struct mxcmci_host *host, unsigned int vdd)
+static inline void mxcmci_set_power(struct mxcmci_host *host,
+				    unsigned char power_mode,
+				    unsigned int vdd)
 {
-#ifdef CONFIG_REGULATOR
-	if (host->vcc)
-		mmc_regulator_set_ocr(host->vcc, vdd);
-#endif
+	if (host->vcc) {
+		if (power_mode == MMC_POWER_UP)
+			mmc_regulator_set_ocr(host->mmc, host->vcc, vdd);
+		else if (power_mode == MMC_POWER_OFF)
+			mmc_regulator_set_ocr(host->mmc, host->vcc, 0);
+	}
+
 	if (host->pdata && host->pdata->setpower)
 		host->pdata->setpower(mmc_dev(host->mmc), vdd);
 }
@@ -716,7 +720,7 @@ static void mxcmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->cmdat &= ~CMD_DAT_CONT_BUS_WIDTH_4;
 
 	if (host->power_mode != ios->power_mode) {
-		mxcmci_set_power(host, ios->vdd);
+		mxcmci_set_power(host, ios->power_mode, ios->vdd);
 		host->power_mode = ios->power_mode;
 
 		if (ios->power_mode == MMC_POWER_ON)
-- 
1.6.3.3





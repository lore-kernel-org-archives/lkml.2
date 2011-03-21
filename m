Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab1CUSrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:47:17 -0400
Received: from smtp208.alice.it ([82.57.200.104]:50741 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1CUSrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:47:15 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-mmc@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>,
        Ernst Schwab <eschwab@online.de>, Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] mmc_spi.c: factor out a mmc_spi_setpower() function
Date: Mon, 21 Mar 2011 19:46:41 +0100
Message-Id: <1300733202-27316-4-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out a mmc_spi_setpower() function so to make changing it more
elegant without adding too much stuff to mmc_spi_set_ios().

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/mmc/host/mmc_spi.c |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index fe0fdc4..5e4b2c7 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1221,6 +1221,26 @@ static void mmc_spi_shutdownsequence(struct mmc_spi_host *host)
 	}
 }
 
+static inline int mmc_spi_setpower(struct mmc_spi_host *host,
+					unsigned char power_mode,
+					unsigned int vdd)
+{
+	/* switch power on/off if possible, accounting for
+	 * max 250msec powerup time if needed.
+	 */
+	if (mmc_spi_canpower(host)) {
+		switch (power_mode) {
+		case MMC_POWER_OFF:
+		case MMC_POWER_UP:
+			host->pdata->setpower(&host->spi->dev, vdd);
+			if (power_mode == MMC_POWER_UP)
+				msleep(host->powerup_msecs);
+		}
+	}
+
+	return 0;
+}
+
 static char *mmc_powerstring(u8 power_mode)
 {
 	switch (power_mode) {
@@ -1236,24 +1256,23 @@ static void mmc_spi_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 	struct mmc_spi_host *host = mmc_priv(mmc);
 
 	if (host->power_mode != ios->power_mode) {
+		int ret;
 
 		dev_dbg(&host->spi->dev, "mmc_spi: power %s (%d)%s\n",
 				mmc_powerstring(ios->power_mode),
 				ios->vdd,
 				mmc_spi_canpower(host) ? ", can switch" : "");
 
-		/* switch power on/off if possible, accounting for
-		 * max 250msec powerup time if needed.
-		 */
-		if (mmc_spi_canpower(host)) {
-			switch (ios->power_mode) {
-			case MMC_POWER_OFF:
-			case MMC_POWER_UP:
-				host->pdata->setpower(&host->spi->dev,
-						ios->vdd);
-				if (ios->power_mode == MMC_POWER_UP)
-					msleep(host->powerup_msecs);
-			}
+		ret = mmc_spi_setpower(host, ios->power_mode, ios->vdd);
+		if (ret) {
+			dev_err(mmc_dev(mmc), "unable to set power\n");
+			/*
+			 * The .set_ios() function in the mmc_host_ops
+			 * struct return void, and failing to set the
+			 * power should be rare so we print an error and
+			 * return here.
+			 */
+			return;
 		}
 
 		/* See 6.4.1 in the simplified SD card physical spec 2.0 */
-- 
1.7.4.1


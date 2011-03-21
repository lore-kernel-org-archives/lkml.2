Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1CUSrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:47:22 -0400
Received: from smtp205.alice.it ([82.57.200.101]:43922 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1CUSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:47:18 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-mmc@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        Daniel Ribeiro <drwyrm@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Chris Ball <cjb@laptop.org>, Grant Likely <grant.likely@secretlab.ca>,
        Ernst Schwab <eschwab@online.de>, Sonic Zhang <sonic.zhang@analog.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        openezx-devel@lists.openezx.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mmc_spi.c: factor out the SD card shutdown sequence
Date: Mon, 21 Mar 2011 19:46:40 +0100
Message-Id: <1300733202-27316-3-git-send-email-ospite@studenti.unina.it>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
References: <1300733202-27316-1-git-send-email-ospite@studenti.unina.it>
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+ ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out the SD card shutdown sequence to a dedicated
mmc_spi_shutdownsequence() function in order to make mmc_spi_set_ios()
more readable, and also for symmetry with mmc_spi_initsequence() which
is already a dedicated function.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
 drivers/mmc/host/mmc_spi.c |   90 +++++++++++++++++++++++--------------------
 1 files changed, 48 insertions(+), 42 deletions(-)

diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 1db18ce..fe0fdc4 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1176,6 +1176,51 @@ static void mmc_spi_initsequence(struct mmc_spi_host *host)
 	}
 }
 
+/* See Section 6.4.2, in SD "Simplified Physical Layer Specification 2.0"
+ *
+ * If powering down, ground all card inputs to avoid power delivery from data
+ * lines!  On a shared SPI bus, this will probably be temporary; 6.4.2 of
+ * the simplified SD spec says this must last at least 1msec.
+ *
+ *   - Clock low means CPOL 0, e.g. mode 0
+ *   - MOSI low comes from writing zero
+ *   - Chipselect is usually active low...
+ */
+static void mmc_spi_shutdownsequence(struct mmc_spi_host *host)
+{
+	int mres;
+	u8 nullbyte = 0;
+
+	host->spi->mode &= ~(SPI_CPOL|SPI_CPHA);
+	mres = spi_setup(host->spi);
+	if (mres < 0)
+		dev_dbg(&host->spi->dev,
+			"switch to SPI mode 0 failed\n");
+
+	if (spi_write(host->spi, &nullbyte, 1) < 0)
+		dev_dbg(&host->spi->dev,
+			"put spi signals to low failed\n");
+
+	/*
+	 * Now clock should be low due to spi mode 0;
+	 * MOSI should be low because of written 0x00;
+	 * chipselect should be low (it is active low)
+	 * power supply is off, so now MMC is off too!
+	 *
+	 * FIXME no, chipselect can be high since the
+	 * device is inactive and SPI_CS_HIGH is clear...
+	 */
+	msleep(10);
+	if (mres == 0) {
+		host->spi->mode |= (SPI_CPOL|SPI_CPHA);
+		mres = spi_setup(host->spi);
+		if (mres < 0)
+			dev_dbg(&host->spi->dev,
+				"switch back to SPI mode 3"
+				" failed\n");
+	}
+}
+
 static char *mmc_powerstring(u8 power_mode)
 {
 	switch (power_mode) {
@@ -1215,49 +1260,10 @@ static void mmc_spi_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		if (ios->power_mode == MMC_POWER_ON)
 			mmc_spi_initsequence(host);
 
-		/* If powering down, ground all card inputs to avoid power
-		 * delivery from data lines!  On a shared SPI bus, this
-		 * will probably be temporary; 6.4.2 of the simplified SD
-		 * spec says this must last at least 1msec.
-		 *
-		 *   - Clock low means CPOL 0, e.g. mode 0
-		 *   - MOSI low comes from writing zero
-		 *   - Chipselect is usually active low...
-		 */
+		/* See 6.4.2 in the simplified SD card physical spec 2.0 */
 		if (mmc_spi_canpower(host) &&
-		    ios->power_mode == MMC_POWER_OFF) {
-			int mres;
-			u8 nullbyte = 0;
-
-			host->spi->mode &= ~(SPI_CPOL|SPI_CPHA);
-			mres = spi_setup(host->spi);
-			if (mres < 0)
-				dev_dbg(&host->spi->dev,
-					"switch to SPI mode 0 failed\n");
-
-			if (spi_write(host->spi, &nullbyte, 1) < 0)
-				dev_dbg(&host->spi->dev,
-					"put spi signals to low failed\n");
-
-			/*
-			 * Now clock should be low due to spi mode 0;
-			 * MOSI should be low because of written 0x00;
-			 * chipselect should be low (it is active low)
-			 * power supply is off, so now MMC is off too!
-			 *
-			 * FIXME no, chipselect can be high since the
-			 * device is inactive and SPI_CS_HIGH is clear...
-			 */
-			msleep(10);
-			if (mres == 0) {
-				host->spi->mode |= (SPI_CPOL|SPI_CPHA);
-				mres = spi_setup(host->spi);
-				if (mres < 0)
-					dev_dbg(&host->spi->dev,
-						"switch back to SPI mode 3"
-						" failed\n");
-			}
-		}
+		    ios->power_mode == MMC_POWER_OFF)
+			mmc_spi_shutdownsequence(host);
 
 		host->power_mode = ios->power_mode;
 	}
-- 
1.7.4.1


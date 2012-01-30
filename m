Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2A3WFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:05:36 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:47520 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754310Ab2A3WFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:05:35 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/16] leds-lp5523: fix compiler warning
Date: Mon, 30 Jan 2012 23:00:20 +0100
Message-Id: <1327960820-11867-17-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327961134;990380a8;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for some -Wuninitialized compiler warnings.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/leds/leds-lp5523.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 73e791a..c11fce0 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -192,7 +192,7 @@ static int lp5523_detect(struct i2c_client *client)
 static int lp5523_configure(struct i2c_client *client)
 {
 	struct lp5523_chip *chip = i2c_get_clientdata(client);
-	int ret = 0;
+	int ret = 0, ret2 = 0;
 	u8 status;
 
 	/* one pattern per engine setting led mux start and stop addresses */
@@ -243,7 +243,10 @@ static int lp5523_configure(struct i2c_client *client)
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	lp5523_read(client, LP5523_REG_STATUS, &status);
+	ret2 = lp5523_read(client, LP5523_REG_STATUS, &status);
+	if (ret2) 
+		return -1;
+	
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status == LP5523_ENG_STATUS_MASK) {
@@ -461,7 +464,10 @@ static ssize_t lp5523_selftest(struct device *dev,
 	if (!(status & LP5523_LEDTEST_DONE))
 		usleep_range(3000, 6000); /* Was not ready. Wait little bit */
 
-	ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
+	ret = lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
+	if (ret)
+		goto fail;
+
 	vdd--;	/* There may be some fluctuation in measurement */
 
 	for (i = 0; i < LP5523_LEDS; i++) {
@@ -485,7 +491,9 @@ static ssize_t lp5523_selftest(struct device *dev,
 		ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
 		if (!(status & LP5523_LEDTEST_DONE))
 			usleep_range(3000, 6000);/* Was not ready. Wait. */
-		ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &adc);
+		ret = lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &adc);
+		if (ret)
+			goto fail;
 
 		if (adc >= vdd || adc < LP5523_ADC_SHORTCIRC_LIM)
 			pos += sprintf(buf + pos, "LED %d FAIL\n", i);
-- 
1.7.7.3


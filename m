Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760774Ab2BNOoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:44:14 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:56725 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab2BNOoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:44:12 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Danny Kukawka <dkukawka@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] leds-lp5523: fix compiler warning
Date: Tue, 14 Feb 2012 15:44:00 +0100
Message-Id: <1329230640-27265-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230652;012e214b;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for some -Wuninitialized compiler warnings related to not
checking lp5523_read() return values but using to the function
passed variables later.

v3: handle the error cases from lp5523_read()

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/leds/leds-lp5523.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
index 73e791a..2b2d10b 100644
--- a/drivers/leds/leds-lp5523.c
+++ b/drivers/leds/leds-lp5523.c
@@ -243,7 +243,13 @@ static int lp5523_configure(struct i2c_client *client)
 
 	/* Let the programs run for couple of ms and check the engine status */
 	usleep_range(3000, 6000);
-	lp5523_read(client, LP5523_REG_STATUS, &status);
+	ret = lp5523_read(client, LP5523_REG_STATUS, &status);
+
+	if (ret) {
+		dev_err(&client->dev, "could not read status\n");
+		return -1;
+	}
+
 	status &= LP5523_ENG_STATUS_MASK;
 
 	if (status == LP5523_ENG_STATUS_MASK) {
@@ -256,7 +262,7 @@ static int lp5523_configure(struct i2c_client *client)
 
 	dev_info(&client->dev, "disabling engines\n");
 
-	ret |= lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
+	ret = lp5523_write(client, LP5523_REG_OP_MODE, LP5523_CMD_DISABLED);
 
 	return ret;
 }
@@ -458,10 +464,16 @@ static ssize_t lp5523_selftest(struct device *dev,
 				    LP5523_EN_LEDTEST | 16);
 	usleep_range(3000, 6000); /* ADC conversion time is typically 2.7 ms */
 	ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+	if (ret)
+		goto fail;
+
 	if (!(status & LP5523_LEDTEST_DONE))
 		usleep_range(3000, 6000); /* Was not ready. Wait little bit */
 
-	ret |= lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
+	ret = lp5523_read(chip->client, LP5523_REG_LED_TEST_ADC, &vdd);
+	if (ret)
+		goto fail;
+
 	vdd--;	/* There may be some fluctuation in measurement */
 
 	for (i = 0; i < LP5523_LEDS; i++) {
@@ -483,9 +495,14 @@ static ssize_t lp5523_selftest(struct device *dev,
 		/* ADC conversion time is 2.7 ms typically */
 		usleep_range(3000, 6000);
 		ret = lp5523_read(chip->client, LP5523_REG_STATUS, &status);
+		if (ret)
+			goto fail;
+
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


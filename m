Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2A3WHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:07:11 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:47573 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753732Ab2A3WHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:07:08 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/16] leds-lp5521: fix compiler warning
Date: Mon, 30 Jan 2012 23:00:19 +0100
Message-Id: <1327960820-11867-16-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327961228;58c9a5f2;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for some -Wuninitialized compiler warnings.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/leds/leds-lp5521.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index d62a798..8ce4525 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -193,6 +193,7 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 	struct lp5521_chip *chip = engine_to_lp5521(eng);
 	struct i2c_client *client = chip->client;
 	int ret;
+	int ret2;
 	int addr;
 	u8 mode;
 
@@ -200,7 +201,11 @@ static int lp5521_load_program(struct lp5521_engine *eng, const u8 *pattern)
 	ret = lp5521_set_engine_mode(eng, LP5521_CMD_DIRECT);
 	/* Mode change requires min 500 us delay. 1 - 2 ms  with margin */
 	usleep_range(1000, 2000);
-	ret |= lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	ret2 = lp5521_read(client, LP5521_REG_OP_MODE, &mode);
+	if (ret2 < 0)
+		return ret2;
+
+	ret |= ret2;
 
 	/* For loading, all the engines to load mode */
 	lp5521_write(client, LP5521_REG_OP_MODE, LP5521_CMD_DIRECT);
@@ -692,7 +697,12 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	 * otherwise further access to the R G B channels in the
 	 * LP5521_REG_ENABLE register will not have any effect - strange!
 	 */
-	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	if (ret) {
+		dev_err(&client->dev, "error in reading chip\n");
+		goto fail2;
+	}
+
 	if (buf != LP5521_REG_R_CURR_DEFAULT) {
 		dev_err(&client->dev, "error in reseting chip\n");
 		goto fail2;
-- 
1.7.7.3


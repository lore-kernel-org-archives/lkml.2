Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1JJLaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:30:20 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:56074 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab1JJLaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:30:18 -0400
From: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Subject: [PATCH] drivers/leds/leds-lp5521.c: check if reset is successful
Date: Mon, 10 Oct 2011 17:00:02 +0530
Message-Id: <1318246202-2476-1-git-send-email-srinidhi.kasagar@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make sure that the reset is successful by issuing a dummy
read to R channel current register and check its default
value. On some platforms, without this dummy read, any
further access to {R/G/B}_EXEC will not have any impact.

Signed-off-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
Tested-by: Naga Radhesh <naga.radheshy@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/leds/leds-lp5521.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
index 9fc122c..91a2928 100644
--- a/drivers/leds/leds-lp5521.c
+++ b/drivers/leds/leds-lp5521.c
@@ -97,6 +97,9 @@
 /* Status */
 #define LP5521_EXT_CLK_USED		0x08
 
+/* default R channel current register value */
+#define LP5521_REG_R_CURR_DEFAULT	0xAF
+
 struct lp5521_engine {
 	int		id;
 	u8		mode;
@@ -643,6 +646,7 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 	struct lp5521_chip		*chip;
 	struct lp5521_platform_data	*pdata;
 	int ret, i, led;
+	u8 buf;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
 	if (!chip)
@@ -681,6 +685,21 @@ static int __devinit lp5521_probe(struct i2c_client *client,
 				     * Exact value is not available. 10 - 20ms
 				     * appears to be enough for reset.
 				     */
+
+	/*
+	 * Make sure that the chip is reset by reading back
+	 * r channel current reg. This is a dummy read, otherwise
+	 * in some platforms, access to R G B channel program
+	 * execution mode to 'Run' in LP5521_REG_ENABLE register
+	 * will not have any affect - strange!
+	 */
+	lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
+	if (buf != LP5521_REG_R_CURR_DEFAULT) {
+		dev_err(&client->dev, "error in reseting chip\n");
+		goto fail2;
+	}
+	usleep_range(10000, 20000);
+
 	ret = lp5521_detect(client);
 
 	if (ret) {
-- 
1.7.4.3


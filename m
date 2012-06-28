Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2F1MIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:08:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60643 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab2F1MIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:08:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] extcon: arizona: Update cable reporting calls and split headset
Date: Thu, 28 Jun 2012 13:08:30 +0100
Message-Id: <1340885311-12368-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use extcon_set_state_ for performance and split the headset into separate
headphone and microphone reports as this is more idiomatic.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   41 ++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index b068bc9..0626754 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -54,22 +54,17 @@ static const struct arizona_micd_config micd_default_modes[] = {
 	{ 0,                  2 << ARIZONA_MICD_BIAS_SRC_SHIFT, 1 },
 };
 
-#define ARIZONA_CABLE_MECHANICAL "Mechanical"
-#define ARIZONA_CABLE_HEADPHONE  "Headphone"
-#define ARIZONA_CABLE_HEADSET    "Headset"
+#define ARIZONA_CABLE_MECHANICAL 0
+#define ARIZONA_CABLE_MICROPHONE 1
+#define ARIZONA_CABLE_HEADPHONE  2
 
 static const char *arizona_cable[] = {
-	ARIZONA_CABLE_MECHANICAL,
-	ARIZONA_CABLE_HEADSET,
-	ARIZONA_CABLE_HEADPHONE,
+	"Mechanical",
+	"Microphone",
+	"Headphone",
 	NULL,
 };
 
-static const u32 arizona_exclusions[] = {
-	0x6,   /* Headphone and headset */
-	0,
-};
-
 static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 {
 	struct arizona *arizona = info->arizona;
@@ -174,8 +169,11 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 
 	/* If we got a high impedence we should have a headset, report it. */
 	if (info->detecting && (val & 0x400)) {
-		ret = extcon_set_cable_state(&info->edev,
-					     ARIZONA_CABLE_HEADSET, true);
+		ret = extcon_update_state(&info->edev,
+					  1 << ARIZONA_CABLE_MICROPHONE |
+					  1 << ARIZONA_CABLE_HEADPHONE,
+					  1 << ARIZONA_CABLE_MICROPHONE |
+					  1 << ARIZONA_CABLE_HEADPHONE);
 
 		if (ret != 0)
 			dev_err(arizona->dev, "Headset report failed: %d\n",
@@ -198,9 +196,9 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 		if (info->jack_flips >= info->micd_num_modes) {
 			dev_dbg(arizona->dev, "Detected headphone\n");
 			info->detecting = false;
-			ret = extcon_set_cable_state(&info->edev,
-						     ARIZONA_CABLE_HEADPHONE,
-						     true);
+			ret = extcon_set_cable_state_(&info->edev,
+						      ARIZONA_CABLE_HEADPHONE,
+						      true);
 			if (ret != 0)
 				dev_err(arizona->dev,
 					"Headphone report failed: %d\n",
@@ -231,9 +229,9 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			info->detecting = false;
 			arizona_stop_mic(info);
 
-			ret = extcon_set_cable_state(&info->edev,
-						     ARIZONA_CABLE_HEADPHONE,
-						     true);
+			ret = extcon_set_cable_state_(&info->edev,
+						      ARIZONA_CABLE_HEADPHONE,
+						      true);
 			if (ret != 0)
 				dev_err(arizona->dev,
 					"Headphone report failed: %d\n",
@@ -275,8 +273,8 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 
 	if (val & ARIZONA_JD1_STS) {
 		dev_dbg(arizona->dev, "Detected jack\n");
-		ret = extcon_set_cable_state(&info->edev,
-					     ARIZONA_CABLE_MECHANICAL, true);
+		ret = extcon_set_cable_state_(&info->edev,
+					      ARIZONA_CABLE_MECHANICAL, true);
 
 		if (ret != 0)
 			dev_err(arizona->dev, "Mechanical report failed: %d\n",
@@ -347,7 +345,6 @@ static int __devinit arizona_extcon_probe(struct platform_device *pdev)
 
 	info->edev.name = "Headset Jack";
 	info->edev.supported_cable = arizona_cable;
-	info->edev.mutually_exclusive = arizona_exclusions;
 
 	ret = extcon_dev_register(&info->edev, arizona->dev);
 	if (ret < 0) {
-- 
1.7.10


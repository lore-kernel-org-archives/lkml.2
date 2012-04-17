Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab2DQHaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:30:30 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:33992 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203Ab2DQHa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:30:29 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/6] mfd/ab8500: add new resources on AB8505 and AB9540
Date: Tue, 17 Apr 2012 09:30:14 +0200
Message-ID: <1334647814-1625-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

The AB8505 and AB9540 has extended support for micro USB
resistance detection, used for detecting chargers. Let's
register resources for this resource. Let's also split off the
separate codec device for AB9540.

Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   60 +++++++++++++++++++++++++++++++++----
 include/linux/mfd/abx500/ab8500.h |   12 ++++++--
 2 files changed, 65 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 1f08704..ae67612 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -744,6 +744,39 @@ static struct resource __devinitdata ab8500_usb_resources[] = {
 	},
 };
 
+static struct resource __devinitdata ab8505_iddet_resources[] = {
+	{
+		.name  = "KeyDeglitch",
+		.start = AB8505_INT_KEYDEGLITCH,
+		.end   = AB8505_INT_KEYDEGLITCH,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name  = "KP",
+		.start = AB8505_INT_KP,
+		.end   = AB8505_INT_KP,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name  = "IKP",
+		.start = AB8505_INT_IKP,
+		.end   = AB8505_INT_IKP,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name  = "IKR",
+		.start = AB8505_INT_IKR,
+		.end   = AB8505_INT_IKR,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name  = "KeyStuck",
+		.start = AB8505_INT_KEYSTUCK,
+		.end   = AB8505_INT_KEYSTUCK,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static struct resource __devinitdata ab8500_temp_resources[] = {
 	{
 		.name  = "AB8500_TEMP_WARM",
@@ -803,10 +836,6 @@ static struct mfd_cell __devinitdata abx500_common_devs[] = {
 		.resources = ab8500_av_acc_detect_resources,
 	},
 	{
-		.name = "ab8500-codec",
-	},
-
-	{
 		.name = "ab8500-poweron-key",
 		.num_resources = ARRAY_SIZE(ab8500_poweronkey_db_resources),
 		.resources = ab8500_poweronkey_db_resources,
@@ -845,6 +874,9 @@ static struct mfd_cell __devinitdata ab8500_devs[] = {
 		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
 		.resources = ab8500_usb_resources,
 	},
+	{
+		.name = "ab8500-codec",
+	},
 };
 
 static struct mfd_cell __devinitdata ab9540_devs[] = {
@@ -858,6 +890,18 @@ static struct mfd_cell __devinitdata ab9540_devs[] = {
 		.num_resources = ARRAY_SIZE(ab8500_usb_resources),
 		.resources = ab8500_usb_resources,
 	},
+	{
+		.name = "ab9540-codec",
+	},
+};
+
+/* Device list common to ab9540 and ab8505 */
+static struct mfd_cell __devinitdata ab9540_ab8505_devs[] = {
+	{
+		.name = "ab-iddet",
+		.num_resources = ARRAY_SIZE(ab8505_iddet_resources),
+		.resources = ab8505_iddet_resources,
+	},
 };
 
 static ssize_t show_chip_id(struct device *dev,
@@ -1125,8 +1169,14 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 			      ab8500->irq_base);
 	else
 		ret = mfd_add_devices(ab8500->dev, 0, ab8500_devs,
-			      ARRAY_SIZE(ab9540_devs), NULL,
+			      ARRAY_SIZE(ab8500_devs), NULL,
+			      ab8500->irq_base);
+
+	if (is_ab9540(ab8500) || is_ab8505(ab8500))
+		ret = mfd_add_devices(ab8500->dev, 0, ab9540_ab8505_devs,
+			      ARRAY_SIZE(ab9540_ab8505_devs), NULL,
 			      ab8500->irq_base);
+
 	if (ret)
 		goto out_freeirq;
 
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index fccc300..d798f5b 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -194,6 +194,14 @@ enum ab8500_version {
 #define AB9540_INT_GPIO52F		123
 #define AB9540_INT_GPIO53F		124
 #define AB9540_INT_GPIO54F		125 /* not 8505 */
+/* ab8500_irq_regoffset[16] -> IT[Source|Latch|Mask]25 */
+#define AB8505_INT_KEYSTUCK		128
+#define AB8505_INT_IKR			129
+#define AB8505_INT_IKP			130
+#define AB8505_INT_KP			131
+#define AB8505_INT_KEYDEGLITCH		132
+#define AB8505_INT_MODPWRSTATUSF	134
+#define AB8505_INT_MODPWRSTATUSR	135
 
 /*
  * AB8500_AB9540_NR_IRQS is used when configuring the IRQ numbers for the
@@ -203,8 +211,8 @@ enum ab8500_version {
  * which is larger.
  */
 #define AB8500_NR_IRQS			112
-#define AB8505_NR_IRQS			128
-#define AB9540_NR_IRQS			128
+#define AB8505_NR_IRQS			136
+#define AB9540_NR_IRQS			136
 /* This is set to the roof of any AB8500 chip variant IRQ counts */
 #define AB8500_MAX_NR_IRQS		AB9540_NR_IRQS
 
-- 
1.7.9.2


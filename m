Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab2DQHbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:31:12 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:60861 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754137Ab2DQHbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:31:09 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Rickard Andersson <rickard.andersson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/6] mfd/ab8500: add parameter to disable battery management
Date: Tue, 17 Apr 2012 09:30:57 +0200
Message-ID: <1334647857-1810-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Andersson <rickard.andersson@stericsson.com>

This patch makes it possible to disable battery management
via a module boot parameter. When 'ab8500-core.no_bm=1' then
ab8500_btemp, ab8500_chargalg, ab8500_charger and ab8500_fg will
not be probed. This boot parameter is used for scripted testing
of the system.

Signed-off-by: Rickard Andersson <rickard.andersson@stericsson.com>
Reviewed-by: Jonas Aberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |   55 ++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 8e56fd1..239d928 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -106,6 +106,9 @@
 
 #define AB8500_TURN_ON_STATUS		0x00
 
+static bool no_bm; /* No battery management */
+module_param(no_bm, bool, S_IRUGO);
+
 #define AB9540_MODEM_CTRL2_REG			0x23
 #define AB9540_MODEM_CTRL2_SWDBBRSTN_BIT	BIT(2)
 
@@ -904,26 +907,6 @@ static struct mfd_cell __devinitdata abx500_common_devs[] = {
 		.resources = ab8500_rtc_resources,
 	},
 	{
-		.name = "ab8500-charger",
-		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
-		.resources = ab8500_charger_resources,
-	},
-	{
-		.name = "ab8500-btemp",
-		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
-		.resources = ab8500_btemp_resources,
-	},
-	{
-		.name = "ab8500-fg",
-		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
-		.resources = ab8500_fg_resources,
-	},
-	{
-		.name = "ab8500-chargalg",
-		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
-		.resources = ab8500_chargalg_resources,
-	},
-	{
 		.name = "ab8500-acc-det",
 		.num_resources = ARRAY_SIZE(ab8500_av_acc_detect_resources),
 		.resources = ab8500_av_acc_detect_resources,
@@ -956,6 +939,29 @@ static struct mfd_cell __devinitdata abx500_common_devs[] = {
 	},
 };
 
+static struct mfd_cell __devinitdata ab8500_bm_devs[] = {
+	{
+		.name = "ab8500-charger",
+		.num_resources = ARRAY_SIZE(ab8500_charger_resources),
+		.resources = ab8500_charger_resources,
+	},
+	{
+		.name = "ab8500-btemp",
+		.num_resources = ARRAY_SIZE(ab8500_btemp_resources),
+		.resources = ab8500_btemp_resources,
+	},
+	{
+		.name = "ab8500-fg",
+		.num_resources = ARRAY_SIZE(ab8500_fg_resources),
+		.resources = ab8500_fg_resources,
+	},
+	{
+		.name = "ab8500-chargalg",
+		.num_resources = ARRAY_SIZE(ab8500_chargalg_resources),
+		.resources = ab8500_chargalg_resources,
+	},
+};
+
 static struct mfd_cell __devinitdata ab8500_devs[] = {
 	{
 		.name = "ab8500-gpio",
@@ -1306,6 +1312,15 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 	if (ret)
 		goto out_freeirq;
 
+	if (!no_bm) {
+		/* Add battery management devices */
+		ret = mfd_add_devices(ab8500->dev, 0, ab8500_bm_devs,
+				      ARRAY_SIZE(ab8500_bm_devs), NULL,
+				      ab8500->irq_base);
+		if (ret)
+			dev_err(ab8500->dev, "error adding bm devices\n");
+	}
+
 	if (is_ab9540(ab8500))
 		ret = sysfs_create_group(&ab8500->dev->kobj,
 					&ab9540_attr_group);
-- 
1.7.9.2


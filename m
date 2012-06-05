Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2FEILw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 04:11:52 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:53960 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657Ab2FEILt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 04:11:49 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Joe Perches <joe@perches.com>, Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3] mfd/ab8500: print switch off cause
Date: Tue, 5 Jun 2012 10:11:34 +0200
Message-ID: <1338883894-20388-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

Instead of just printing the register value, also output some
description of the value.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Use printk() with KERN_CONT instead of separate dev_* or
  printk() calls. (Review comment from Joe Perches.)
ChangeLog v1->v2:
- Print each cause on its own line with a tab to avoid missing
  initial cause heading if loglevel < info.
---
 drivers/mfd/ab8500-core.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index dac0e29..279bdeb 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1217,6 +1217,15 @@ static const struct of_device_id ab8500_match[] = {
 
 static int __devinit ab8500_probe(struct platform_device *pdev)
 {
+	static char *switch_off_status[] = {
+		"Swoff bit programming",
+		"Thermal protection activation",
+		"Vbat lower then BattOk falling threshold",
+		"Watchdog expired",
+		"Non presence of 32kHz clock",
+		"Battery level lower than power on reset threshold",
+		"Power on key 1 pressed longer than 10 seconds",
+		"DB8500 thermal shutdown"};
 	struct ab8500_platform_data *plat = dev_get_platdata(&pdev->dev);
 	const struct platform_device_id *platid = platform_get_device_id(pdev);
 	enum ab8500_version version = AB8500_VERSION_UNDEFINED;
@@ -1323,7 +1332,21 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
 		AB8500_SWITCH_OFF_STATUS, &value);
 	if (ret < 0)
 		return ret;
-	dev_info(ab8500->dev, "switch off status: %#x", value);
+	dev_info(ab8500->dev, "switch off cause(s) (%#x): ", value);
+
+	if (value) {
+		for (i = 0; i < ARRAY_SIZE(switch_off_status); i++) {
+			if (value & 1)
+				printk(KERN_CONT " \"%s\"",
+				       switch_off_status[i]);
+			value = value >> 1;
+
+		}
+		printk(KERN_CONT "\n");
+	} else {
+		printk(KERN_CONT " None\n");
+	}
+
 
 	if (plat && plat->init)
 		plat->init(ab8500);
-- 
1.7.9.2


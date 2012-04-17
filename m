Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab2DQHbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:31:35 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:57547 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab2DQHbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:31:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/6] mfd/ab8500: print switch off cause
Date: Tue, 17 Apr 2012 09:30:40 +0200
Message-ID: <1334647840-1736-1-git-send-email-linus.walleij@stericsson.com>
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
 drivers/mfd/ab8500-core.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index eee9560..9781e1e 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -1072,6 +1072,16 @@ static struct attribute_group ab9540_attr_group = {
 
 int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
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
+
 	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
 	int ret;
 	int i;
@@ -1139,7 +1149,20 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 		AB8500_SWITCH_OFF_STATUS, &value);
 	if (ret < 0)
 		return ret;
-	dev_info(ab8500->dev, "switch off status: %#x", value);
+	dev_info(ab8500->dev, "switch off cause(s) (%#x): ", value);
+
+	if (value) {
+		for (i = 0; i < ARRAY_SIZE(switch_off_status); i++) {
+			if (value & 1)
+				printk("\"%s\" ", switch_off_status[i]);
+			value = value >> 1;
+
+		}
+		printk("\n");
+	} else {
+		printk("None\n");
+	}
+
 
 	if (plat && plat->init)
 		plat->init(ab8500);
-- 
1.7.9.2


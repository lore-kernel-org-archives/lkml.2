Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2DJIEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:04:43 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:49446 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240Ab2DJIEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:04:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] pinctrl: implement pinctrl deferred probing
Date: Tue, 10 Apr 2012 10:04:08 +0200
Message-ID: <1334045048-15566-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

If drivers try to obtain pinctrl handles for a pin controller that
has not yet registered to the subsystem, we need to be able to
back out and retry with deferred probing. So let's return
-EPROBE_DEFER whenever this location fails.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 Documentation/pinctrl.txt    |    5 +++++
 drivers/pinctrl/core.c       |    7 +++++--
 drivers/pinctrl/devicetree.c |    4 ++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index eb46b1c..4431c3e7 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1043,6 +1043,11 @@ quickly poking some registers.
 The pins are allocated for your device when you issue the pinctrl_get() call,
 after this you should be able to see this in the debugfs listing of all pins.
 
+NOTE: the pinctrl system will return -EPROBE_DEFER if it cannot find the
+requested pinctrl handles, for example if the pinctrl driver has not yet
+registered. Thus make sure that the error path in your driver gracefully
+cleans up and is ready to retry the probing later in the startup process.
+
 
 System pin control hogging
 ==========================
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 7ff8690..3ae00ab 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -521,8 +521,11 @@ static int add_setting(struct pinctrl *p, struct pinctrl_map const *map)
 		dev_err(p->dev, "unknown pinctrl device %s in map entry",
 			map->ctrl_dev_name);
 		kfree(setting);
-		/* Eventually, this should trigger deferred probe */
-		return -ENODEV;
+		/*
+		 * OK let us guess that the driver is not there yet, and
+		 * let's defer obtaining this pinctrl handle to later...
+		 */
+		return -EPROBE_DEFER;
 	}
 
 	switch (map->type) {
diff --git a/drivers/pinctrl/devicetree.c b/drivers/pinctrl/devicetree.c
index 5ef2feb..8833538 100644
--- a/drivers/pinctrl/devicetree.c
+++ b/drivers/pinctrl/devicetree.c
@@ -124,8 +124,8 @@ static int dt_to_map_one_config(struct pinctrl *p, const char *statename,
 			dev_err(p->dev, "could not find pctldev for node %s\n",
 				np_config->full_name);
 			of_node_put(np_pctldev);
-			/* FIXME: This should trigger deferrered probe */
-			return -ENODEV;
+			/* OK let's just assume this will appear later then */
+			return -EPROBE_DEFER;
 		}
 		pctldev = find_pinctrl_by_of_node(np_pctldev);
 		if (pctldev)
-- 
1.7.9.2


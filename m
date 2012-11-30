Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab2K3L6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:58:07 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56512 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2K3L6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:04 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/12] ab8500_charger: Reorder obtainment of platform specific battery management data
Date: Fri, 30 Nov 2012 11:57:31 +0000
Message-Id: <1354276654-590-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
References: <1354276654-590-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we always pass platform specific battery management data
through platform_data instead of obtaining it via different means
depending the way be boot the system (DT or ATAGs); we need to
re-jiggle the way we acquire it in the driver start-up functions.
Now it is wrong for it to be missing, but we still allow Device
Tree code to fiddle with it once we've confirmed it's there.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/ab8500_charger.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index c1077df..2ddface 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -2636,6 +2636,7 @@ static char *supply_interface[] = {
 static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct abx500_bm_data *plat = pdev->dev.platform_data;
 	struct ab8500_charger *di;
 	int irq, i, charger_status, ret = 0;
 
@@ -2644,24 +2645,22 @@ static int __devinit ab8500_charger_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_charger\n", __func__);
 		return -ENOMEM;
 	}
-	di->bm = pdev->mfd_cell->platform_data;
-	if (!di->bm) {
-		if (np) {
-			ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
-			if (ret) {
-				dev_err(&pdev->dev,
-					"failed to get battery information\n");
-				return ret;
-			}
-			di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
-		} else {
-			dev_err(&pdev->dev, "missing dt node for ab8500_charger\n");
-			return -EINVAL;
+
+	if (!plat) {
+		dev_err(&pdev->dev, "no battery management data supplied\n");
+		return -EINVAL;
+	}
+	di->bm = plat;
+
+	if (np) {
+		ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to get battery information\n");
+			return ret;
 		}
-	} else {
-		dev_info(&pdev->dev, "falling back to legacy platform data\n");
+		di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
+	} else
 		di->autopower_cfg = false;
-	}
 
 	/* get parent data */
 	di->dev = &pdev->dev;
-- 
1.7.9.5


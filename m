Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030232Ab2K3L7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:59:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33263 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2K3L6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:58:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 08/12] ab8500_btemp: Reorder obtainment of platform specific battery management data
Date: Fri, 30 Nov 2012 11:57:30 +0000
Message-Id: <1354276654-590-9-git-send-email-lee.jones@linaro.org>
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
 drivers/power/ab8500_btemp.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index c0f7dcc..158cba5 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -976,6 +976,7 @@ static char *supply_interface[] = {
 static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct abx500_bm_data *plat = pdev->dev.platform_data;
 	struct ab8500_btemp *di;
 	int irq, i, ret = 0;
 	u8 val;
@@ -985,21 +986,19 @@ static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
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
-		} else {
-			dev_err(&pdev->dev, "missing dt node for ab8500_btemp\n");
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
 	}
 
 	/* get parent data */
-- 
1.7.9.5


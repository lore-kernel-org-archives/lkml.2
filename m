Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389Ab2K3MEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:04:42 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65133 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030350Ab2K3MEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:04:38 -0500
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 07:04:38 EST
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, cbou@mail.ru,
        dwmw2@infradead.org, rajanikanth.hv@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/12] ab8500_fg: Reorder obtainment of platform specific battery management data
Date: Fri, 30 Nov 2012 11:57:32 +0000
Message-Id: <1354276654-590-11-git-send-email-lee.jones@linaro.org>
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
 drivers/power/ab8500_fg.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 8bb9df9..df681a8 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -2448,6 +2448,7 @@ static char *supply_interface[] = {
 static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct abx500_bm_data *plat = pdev->dev.platform_data;
 	struct ab8500_fg *di;
 	int i, irq;
 	int ret = 0;
@@ -2457,21 +2458,19 @@ static int __devinit ab8500_fg_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
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
-			dev_err(&pdev->dev, "missing dt node for ab8500_fg\n");
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
 
 	mutex_init(&di->cc_lock);
-- 
1.7.9.5


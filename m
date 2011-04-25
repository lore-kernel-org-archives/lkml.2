Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab1DYN32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:29:28 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:56154 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1DYN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:29:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=ObpTfcZikW0q/udWxs67qPSZXVdxSp2+DboYkwKL8VrfcD/lrqp/0FEVkimPy0hRkW
         wkOtJghYr8SK23lcSsur+Tbwcp3Vzcy82flo3k90aWGByEKAdIi8A0O0Q9Gh7JQAjXxH
         btrBiakBySzRxoMw0EJEThd2nAzQ8guysLjko=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, Magnus Damm <magnus.damm@gmail.com>,
        lethal@linux-sh.org, simon@horms.net, linux-sh@vger.kernel.org
Date: Mon, 25 Apr 2011 22:36:10 +0900
Message-Id: <20110425133610.4213.81763.sendpatchset@t400s>
Subject: [PATCH] clocksource: sh_cmt: Runtime PM support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add Runtime PM support to the CMT driver.

The hardware device is enabled as long as the clocksource
or the clockevent portion of the driver is used.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Tested on the sh7372 Mackerel board with CMT10.

 drivers/clocksource/sh_cmt.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- 0008/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2011-04-25 15:01:53.000000000 +0900
@@ -24,6 +24,7 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 #include <linux/irq.h>
 #include <linux/err.h>
 #include <linux/clocksource.h>
@@ -152,10 +153,12 @@ static int sh_cmt_enable(struct sh_cmt_p
 {
 	int ret;
 
-	/* enable clock */
+	/* wake up device and enable clock */
+	pm_runtime_get_sync(&p->pdev->dev);
 	ret = clk_enable(p->clk);
 	if (ret) {
 		dev_err(&p->pdev->dev, "cannot enable clock\n");
+		pm_runtime_put_sync(&p->pdev->dev);
 		return ret;
 	}
 
@@ -187,8 +190,9 @@ static void sh_cmt_disable(struct sh_cmt
 	/* disable interrupts in CMT block */
 	sh_cmt_write(p, CMCSR, 0);
 
-	/* stop clock */
+	/* stop clock and mark device as idle */
 	clk_disable(p->clk);
+	pm_runtime_put_sync(&p->pdev->dev);
 }
 
 /* private flags */
@@ -660,6 +664,7 @@ static int __devinit sh_cmt_probe(struct
 
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
+		pm_runtime_enable(&pdev->dev);
 		return 0;
 	}
 
@@ -674,6 +679,9 @@ static int __devinit sh_cmt_probe(struct
 		kfree(p);
 		platform_set_drvdata(pdev, NULL);
 	}
+
+	if (!is_early_platform_device(pdev))
+		pm_runtime_enable(&pdev->dev);
 	return ret;
 }
 

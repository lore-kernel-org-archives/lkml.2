Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab1DYNdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 09:33:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52566 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab1DYNdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 09:33:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=a1DoHgEN+WN3rW0b3ISZGLhYKFpX7CFD6TXjUdxvlniD57ns8qcBiWZPP0wEXVNSy8
         Rn07/uxpkXRg0uTMJCjmGsL1jisrUo6v7By73KGx2XIwjtDQ1NecZWQLyRhsFxOhwtvj
         JdOQsJFshPIdt3x6BqvgnqV4eqpQP0rVnAYq4=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: johnstul@us.ibm.com, Magnus Damm <magnus.damm@gmail.com>,
        lethal@linux-sh.org, linux-sh@vger.kernel.org
Date: Mon, 25 Apr 2011 22:40:26 +0900
Message-Id: <20110425134026.4249.13858.sendpatchset@t400s>
Subject: [PATCH] clocksource: sh_tmu: Runtime PM support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add Runtime PM support to the TMU driver.

The hardware device is enabled as long as the clocksource
or the clockevent portion of the driver is used.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Tested on the sh7372 Mackerel board with TMU00 and TMU01.

 drivers/clocksource/sh_tmu.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- 0010/drivers/clocksource/sh_tmu.c
+++ work/drivers/clocksource/sh_tmu.c	2011-04-25 15:13:20.000000000 +0900
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 #include <linux/irq.h>
 #include <linux/err.h>
 #include <linux/clocksource.h>
@@ -109,10 +110,12 @@ static int sh_tmu_enable(struct sh_tmu_p
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
 
@@ -141,8 +144,9 @@ static void sh_tmu_disable(struct sh_tmu
 	/* disable interrupts in TMU block */
 	sh_tmu_write(p, TCR, 0x0000);
 
-	/* stop clock */
+	/* stop clock and mark device as idle */
 	clk_disable(p->clk);
+	pm_runtime_put_sync(&p->pdev->dev);
 }
 
 static void sh_tmu_set_next(struct sh_tmu_priv *p, unsigned long delta,
@@ -411,6 +415,7 @@ static int __devinit sh_tmu_probe(struct
 
 	if (p) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
+		pm_runtime_enable(&pdev->dev);
 		return 0;
 	}
 
@@ -425,6 +430,9 @@ static int __devinit sh_tmu_probe(struct
 		kfree(p);
 		platform_set_drvdata(pdev, NULL);
 	}
+
+	if (!is_early_platform_device(pdev))
+		pm_runtime_enable(&pdev->dev);
 	return ret;
 }
 

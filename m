Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab2LNFtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 00:49:00 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47967 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2LNFs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 00:48:58 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, johnstul@us.ibm.com, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de,
        Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 14 Dec 2012 14:53:32 +0900
Message-Id: <20121214055332.10081.96498.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
References: <20121214055323.10081.12056.sendpatchset@w520>
Subject: [PATCH 01/08] clocksource: sh_cmt: Take care of clk_put() when setup_irq() fails
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Make sure clk_put() is called in case of failure in sh_cmt_setup().

Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/clocksource/sh_cmt.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- 0001/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2012-12-14 12:50:02.000000000 +0900
@@ -708,17 +708,19 @@ static int sh_cmt_setup(struct sh_cmt_pr
 			      cfg->clocksource_rating);
 	if (ret) {
 		dev_err(&p->pdev->dev, "registration failed\n");
-		goto err1;
+		goto err2;
 	}
 	p->cs_enabled = false;
 
 	ret = setup_irq(irq, &p->irqaction);
 	if (ret) {
 		dev_err(&p->pdev->dev, "failed to request irq %d\n", irq);
-		goto err1;
+		goto err2;
 	}
 
 	return 0;
+err2:
+	clk_put(p->clk);
 
 err1:
 	iounmap(p->mapbase);

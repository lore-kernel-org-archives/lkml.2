Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2HZQCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:02:37 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:39077
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839Ab2HZQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:19 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852298"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: kernel-janitors@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/13] drivers/watchdog/sp805_wdt.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:01:02 +0200
Message-Id: <1345996865-32082-11-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/watchdog/sp805_wdt.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index e4841c3..cabb040 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -130,16 +130,10 @@ static int wdt_config(struct watchdog_device *wdd, bool ping)
 	int ret;
 
 	if (!ping) {
-		ret = clk_prepare(wdt->clk);
-		if (ret) {
-			dev_err(&wdt->adev->dev, "clock prepare fail");
-			return ret;
-		}
 
-		ret = clk_enable(wdt->clk);
+		ret = clk_prepare_enable(wdt->clk);
 		if (ret) {
 			dev_err(&wdt->adev->dev, "clock enable fail");
-			clk_unprepare(wdt->clk);
 			return ret;
 		}
 	}
@@ -190,8 +184,7 @@ static int wdt_disable(struct watchdog_device *wdd)
 	readl_relaxed(wdt->base + WDTLOCK);
 	spin_unlock(&wdt->lock);
 
-	clk_disable(wdt->clk);
-	clk_unprepare(wdt->clk);
+	clk_disable_unprepare(wdt->clk);
 
 	return 0;
 }


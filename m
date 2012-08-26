Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab2HZQBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:01:32 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56799
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054Ab2HZQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852300"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Russell King <linux@arm.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/13] drivers/amba/bus.c: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:01:04 +0200
Message-Id: <1345996865-32082-13-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/amba/bus.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index e8eb91b..6374ee6 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -329,17 +329,9 @@ static int amba_get_enable_pclk(struct amba_device *pcdev)
 	if (IS_ERR(pclk))
 		return PTR_ERR(pclk);
 
-	ret = clk_prepare(pclk);
-	if (ret) {
-		clk_put(pclk);
-		return ret;
-	}
-
-	ret = clk_enable(pclk);
-	if (ret) {
-		clk_unprepare(pclk);
+	ret = clk_prepare_enable(pclk);
+	if (ret)
 		clk_put(pclk);
-	}
 
 	return ret;
 }
@@ -348,8 +340,7 @@ static void amba_put_disable_pclk(struct amba_device *pcdev)
 {
 	struct clk *pclk = pcdev->pclk;
 
-	clk_disable(pclk);
-	clk_unprepare(pclk);
+	clk_disable_unprepare(pclk);
 	clk_put(pclk);
 }
 


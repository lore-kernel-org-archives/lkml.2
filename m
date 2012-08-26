Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab2HZQDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:03:13 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:39077
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab2HZQBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:17 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852296"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: "Jean Delvare (PC drivers core)" <khali@linux-fr.org>
Cc: kernel-janitors@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/13] i2c: mv64xxx: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:01:00 +0200
Message-Id: <1345996865-32082-9-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/i2c/busses/i2c-mv64xxx.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 2e9d567..046c4b5 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -633,10 +633,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
 	drv_data->clk = clk_get(&pd->dev, NULL);
-	if (!IS_ERR(drv_data->clk)) {
-		clk_prepare(drv_data->clk);
-		clk_enable(drv_data->clk);
-	}
+	if (!IS_ERR(drv_data->clk))
+		clk_prepare_enable(drv_data->clk);
 #endif
 	if (pdata) {
 		drv_data->freq_m = pdata->freq_m;
@@ -686,10 +684,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
 	exit_unmap_regs:
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
-	if (!IS_ERR(drv_data->clk)) {
-		clk_disable(drv_data->clk);
-		clk_unprepare(drv_data->clk);
-	}
+	if (!IS_ERR(drv_data->clk))
+		clk_disable_unprepare(drv_data->clk);
 #endif
 		mv64xxx_i2c_unmap_regs(drv_data);
 	exit_kfree:
@@ -708,10 +704,8 @@ mv64xxx_i2c_remove(struct platform_device *dev)
 	mv64xxx_i2c_unmap_regs(drv_data);
 #if defined(CONFIG_HAVE_CLK)
 	/* Not all platforms have a clk */
-	if (!IS_ERR(drv_data->clk)) {
-		clk_disable(drv_data->clk);
-		clk_unprepare(drv_data->clk);
-	}
+	if (!IS_ERR(drv_data->clk))
+		clk_disable_unprepare(drv_data->clk);
 #endif
 	kfree(drv_data);
 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2HZQBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:01:21 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:39077
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970Ab2HZQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852292"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Barry Song <baohua.song@csr.com>
Cc: kernel-janitors@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/13] i2c: sirf: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:00:56 +0200
Message-Id: <1345996865-32082-5-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/i2c/busses/i2c-sirf.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index 5574a47..110660a 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -278,18 +278,12 @@ static int __devinit i2c_sirfsoc_probe(struct platform_device *pdev)
 		goto err_get_clk;
 	}
 
-	err = clk_prepare(clk);
+	err = clk_prepare_enable(clk);
 	if (err) {
-		dev_err(&pdev->dev, "Clock prepare failed\n");
+		dev_err(&pdev->dev, "Clock prepare or enable failed\n");
 		goto err_clk_prep;
 	}
 
-	err = clk_enable(clk);
-	if (err) {
-		dev_err(&pdev->dev, "Clock enable failed\n");
-		goto err_clk_en;
-	}
-
 	ctrl_speed = clk_get_rate(clk);
 
 	siic = devm_kzalloc(&pdev->dev, sizeof(*siic), GFP_KERNEL);
@@ -376,9 +370,7 @@ static int __devinit i2c_sirfsoc_probe(struct platform_device *pdev)
 	return 0;
 
 out:
-	clk_disable(clk);
-err_clk_en:
-	clk_unprepare(clk);
+	clk_disable_unprepare(clk);
 err_clk_prep:
 	clk_put(clk);
 err_get_clk:


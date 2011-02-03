Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1BCRR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:17:26 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43835 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab1BCRRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:17:25 -0500
From: Julia Lawall <julia@diku.dk>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: kernel-janitors@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/w1/masters/omap_hdq.c: Add missing clk_put
Date: Thu,  3 Feb 2011 18:37:47 +0100
Message-Id: <1296754667-18049-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code makes two calls to clk_get, then test both return values
and fails if either failed.  The problem is that in the first inner if,
where the first call to clk_get has failed, it don't know if the second
call has failed as well.  So it don't know whether clk_get should be called
on the result of the second call.  Of course, it would be possible to test
that value again.  A simpler solution is just to test the result of calling
clk_get directly after each call.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
position p1,p2;
expression e;
statement S;
@@

e = clk_get@p1(...)
...
if@p2 (IS_ERR(e)) S

@@
expression e;
statement S;
identifier l;
position r.p1, p2 != r.p2;
@@

*e = clk_get@p1(...)
... when != clk_put(e)
*if@p2 (...)
{
  ... when != clk_put(e)
* return ...;
}// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/w1/masters/omap_hdq.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 3a7e9ff..38e96ab 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -593,19 +593,17 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 
 	/* get interface & functional clock objects */
 	hdq_data->hdq_ick = clk_get(&pdev->dev, "ick");
-	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
+	if (IS_ERR(hdq_data->hdq_ick)) {
+		dev_dbg(&pdev->dev, "Can't get HDQ ick clock object\n");
+		ret = PTR_ERR(hdq_data->hdq_ick);
+		goto err_ick;
+	}
 
-	if (IS_ERR(hdq_data->hdq_ick) || IS_ERR(hdq_data->hdq_fck)) {
-		dev_dbg(&pdev->dev, "Can't get HDQ clock objects\n");
-		if (IS_ERR(hdq_data->hdq_ick)) {
-			ret = PTR_ERR(hdq_data->hdq_ick);
-			goto err_clk;
-		}
-		if (IS_ERR(hdq_data->hdq_fck)) {
-			ret = PTR_ERR(hdq_data->hdq_fck);
-			clk_put(hdq_data->hdq_ick);
-			goto err_clk;
-		}
+	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
+	if (IS_ERR(hdq_data->hdq_fck)) {
+		dev_dbg(&pdev->dev, "Can't get HDQ fck clock object\n");
+		ret = PTR_ERR(hdq_data->hdq_fck);
+		goto err_fck;
 	}
 
 	hdq_data->hdq_usecount = 0;
@@ -665,10 +663,12 @@ err_fnclk:
 	clk_disable(hdq_data->hdq_ick);
 
 err_intfclk:
-	clk_put(hdq_data->hdq_ick);
 	clk_put(hdq_data->hdq_fck);
 
-err_clk:
+err_fck:
+	clk_put(hdq_data->hdq_ick);
+
+err_ick:
 	iounmap(hdq_data->hdq_base);
 
 err_ioremap:


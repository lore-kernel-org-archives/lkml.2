Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab2HDQvD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:51:03 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:63697
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab2HDQvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:51:00 -0400
X-IronPort-AV: E=Sophos;i="4.77,713,1336341600"; 
   d="scan'208";a="152439851"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Matt Mackall <mpm@selenic.com>
Cc: kernel-janitors@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] drivers/char/hw_random/octeon-rng.c: drop frees of devm allocated data
Date: Sat,  4 Aug 2012 18:50:46 +0200
Message-Id: <1344099049-15212-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_kfree and devm_iounmap should not have to be explicitly used.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,d;
@@

x = devm_kzalloc(...)
...
?-devm_kfree(d,x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/char/hw_random/octeon-rng.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index 0943edc..5c34c09 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -75,42 +75,35 @@ static int __devinit octeon_rng_probe(struct platform_device *pdev)
 
 	res_ports = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res_ports)
-		goto err_ports;
+		return -ENOENT;
 
 	res_result = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!res_result)
-		goto err_ports;
+		return -ENOENT;
 
 
 	rng->control_status = devm_ioremap_nocache(&pdev->dev,
 						   res_ports->start,
 						   sizeof(u64));
 	if (!rng->control_status)
-		goto err_ports;
+		return -ENOENT;
 
 	rng->result = devm_ioremap_nocache(&pdev->dev,
 					   res_result->start,
 					   sizeof(u64));
 	if (!rng->result)
-		goto err_r;
+		return -ENOENT;
 
 	rng->ops = ops;
 
 	dev_set_drvdata(&pdev->dev, &rng->ops);
 	ret = hwrng_register(&rng->ops);
 	if (ret)
-		goto err;
+		return -ENOENT;
 
 	dev_info(&pdev->dev, "Octeon Random Number Generator\n");
 
 	return 0;
-err:
-	devm_iounmap(&pdev->dev, rng->control_status);
-err_r:
-	devm_iounmap(&pdev->dev, rng->result);
-err_ports:
-	devm_kfree(&pdev->dev, rng);
-	return -ENOENT;
 }
 
 static int __exit octeon_rng_remove(struct platform_device *pdev)


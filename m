Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2ALJzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:55:31 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:41624 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab2ALJz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:55:26 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/15] drivers/net/ethernet/tundra/tsi108_eth.c: add missing iounmap
Date: Thu, 12 Jan 2012 10:55:04 +0100
Message-Id: <1326362117-29371-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Add missing iounmap in error handling code, in a case where the function
already preforms iounmap on some other execution path.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
statement S,S1;
int ret;
@@
e = \(ioremap\|ioremap_nocache\)(...)
... when != iounmap(e)
if (<+...e...+>) S
... when any
    when != iounmap(e)
*if (...)
   { ... when != iounmap(e)
     return ...; }
... when any
iounmap(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/tundra/tsi108_eth.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index a9ce01b..164fb77 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1604,7 +1604,7 @@ tsi108_init_one(struct platform_device *pdev)
 	data->phyregs = ioremap(einfo->phyregs, 0x400);
 	if (NULL == data->phyregs) {
 		err = -ENOMEM;
-		goto regs_fail;
+		goto phyregs_fail;
 	}
 /* MII setup */
 	data->mii_if.dev = dev;
@@ -1663,9 +1663,11 @@ tsi108_init_one(struct platform_device *pdev)
 	return 0;
 
 register_fail:
-	iounmap(data->regs);
 	iounmap(data->phyregs);
 
+phyregs_fail:
+	iounmap(data->regs);
+
 regs_fail:
 	free_netdev(dev);
 	return err;


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2IQIPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 04:15:44 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42545 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2IQIPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 04:15:40 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: jarkko.lavinen@nokia.com
Cc: cjb@laptop.org, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/4] drivers/mmc/host/omap.c: fix error return code
Date: Mon, 17 Sep 2012 10:15:26 +0200
Message-Id: <1347869728-2696-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
References: <1347869728-2696-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/mmc/host/omap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 48ad361..d468f51 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1369,8 +1369,10 @@ static int __devinit mmc_omap_probe(struct platform_device *pdev)
 	host->irq = irq;
 	host->phys_base = host->mem_res->start;
 	host->virt_base = ioremap(res->start, resource_size(res));
-	if (!host->virt_base)
+	if (!host->virt_base) {
+		ret = -ENOMEM;
 		goto err_ioremap;
+	}
 
 	host->iclk = clk_get(&pdev->dev, "ick");
 	if (IS_ERR(host->iclk)) {
@@ -1438,8 +1440,10 @@ static int __devinit mmc_omap_probe(struct platform_device *pdev)
 	host->reg_shift = (cpu_is_omap7xx() ? 1 : 2);
 
 	host->mmc_omap_wq = alloc_workqueue("mmc_omap", 0, 0);
-	if (!host->mmc_omap_wq)
+	if (!host->mmc_omap_wq) {
+		err = -ENOMEM;
 		goto err_plat_cleanup;
+	}
 
 	for (i = 0; i < pdata->nr_slots; i++) {
 		ret = mmc_omap_new_slot(host, i);
-- 
1.7.11.4


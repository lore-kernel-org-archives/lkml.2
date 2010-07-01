Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab0GAJqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:46:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32939 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab0GAJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=vjFcxy6WF7egNGQK35zxMasAZXlP8VswCk79DxcszIhJgspwW+Qmx1PfciGgvGm+B+
         P8HpfMHG8RE40w/YXV3+OTAt9wxhR4FlO1su/KfVpaPaR3NPtzvNBZ9d/dQ4cazMGEMh
         aAkuGW3lTMAxuCTxRY7Lkme1X3p7/WbGtAw3k=
Subject: [PATCH] t7l66xb: properly free clk32k clock source
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Magnus Damm <damm@opensource.se>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain
Date: Thu, 01 Jul 2010 17:43:50 +0800
Message-Id: <1277977430.9342.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes below fixes to properly free clk32k clock source:
1. remove a redundant clk_put in t7l66xb_probe error path
2. add missing clk_disable(t7l66xb->clk32k) and clk_put(t7l66xb->clk32k)
   to properly free the clock source.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/t7l66xb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 5041d33..006c121 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -350,7 +350,6 @@ static int t7l66xb_probe(struct platform_device *dev)
 	t7l66xb->clk48m = clk_get(&dev->dev, "CLK_CK48M");
 	if (IS_ERR(t7l66xb->clk48m)) {
 		ret = PTR_ERR(t7l66xb->clk48m);
-		clk_put(t7l66xb->clk32k);
 		goto err_clk48m_get;
 	}
 
@@ -425,6 +424,8 @@ static int t7l66xb_remove(struct platform_device *dev)
 	ret = pdata->disable(dev);
 	clk_disable(t7l66xb->clk48m);
 	clk_put(t7l66xb->clk48m);
+	clk_disable(t7l66xb->clk32k);
+	clk_put(t7l66xb->clk32k);
 	t7l66xb_detach_irq(dev);
 	iounmap(t7l66xb->scr);
 	release_resource(&t7l66xb->rscr);
-- 
1.5.4.3




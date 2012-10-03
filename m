Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301Ab2JCQXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:23:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48406 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812Ab2JCQS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:18:28 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: samuel@sortiz.org
Cc: kernel-janitors@vger.kernel.org, irda-users@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 11/20] drivers/net/irda/sh_sir.c: fix error return code
Date: Wed,  3 Oct 2012 18:17:56 +0200
Message-Id: <1349281090-10013-6-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
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
 drivers/net/irda/sh_sir.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/sh_sir.c b/drivers/net/irda/sh_sir.c
index 7951094..624ac19 100644
--- a/drivers/net/irda/sh_sir.c
+++ b/drivers/net/irda/sh_sir.c
@@ -741,6 +741,7 @@ static int __devinit sh_sir_probe(struct platform_device *pdev)
 	self->clk = clk_get(&pdev->dev, clk_name);
 	if (IS_ERR(self->clk)) {
 		dev_err(&pdev->dev, "cannot get clock \"%s\"\n", clk_name);
+		err = -ENODEV;
 		goto err_mem_3;
 	}
 
@@ -760,8 +761,8 @@ static int __devinit sh_sir_probe(struct platform_device *pdev)
 		goto err_mem_4;
 
 	platform_set_drvdata(pdev, ndev);
-
-	if (request_irq(irq, sh_sir_irq, IRQF_DISABLED, "sh_sir", self)) {
+	err = request_irq(irq, sh_sir_irq, IRQF_DISABLED, "sh_sir", self);
+	if (err) {
 		dev_warn(&pdev->dev, "Unable to attach sh_sir interrupt\n");
 		goto err_mem_4;
 	}


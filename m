Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab0JQOvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:51:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34172 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756759Ab0JQOvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bbdMvWa/9JHVF6mDQZumodqwmUcw72imizZz7ez7bNaQJ/R35JNE2DTpicD2ws3t9W
         95GEPI7sVX+vA4tzl3ucEm76E6cDviknlPoYDUsw/I259HsgTaTeB4ZpZSq2uG2lHebM
         WDDF6TNgQCV7Hb/bAoQGjm2KTNFoZCPQfX9go=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arm: mach-msm: fix error handling in msm_iommu_probe()
Date: Sun, 17 Oct 2010 18:51:37 +0400
Message-Id: <1287327097-9025-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msm_iommu_probe() didn't free mem_region and mapped IO.
Also if request_mem_region() failed then error handling
code dereferenced NULL pointer.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 arch/arm/mach-msm/iommu_dev.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index c33ae78..9019cee 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -128,7 +128,7 @@ static void msm_iommu_reset(void __iomem *base)
 
 static int msm_iommu_probe(struct platform_device *pdev)
 {
-	struct resource *r;
+	struct resource *r, *r2;
 	struct clk *iommu_clk;
 	struct msm_iommu_drvdata *drvdata;
 	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
@@ -183,27 +183,27 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 		len = r->end - r->start + 1;
 
-		r = request_mem_region(r->start, len, r->name);
-		if (!r) {
+		r2 = request_mem_region(r->start, len, r->name);
+		if (!r2) {
 			pr_err("Could not request memory region: "
 			"start=%p, len=%d\n", (void *) r->start, len);
 			ret = -EBUSY;
 			goto fail;
 		}
 
-		regs_base = ioremap(r->start, len);
+		regs_base = ioremap(r2->start, len);
 
 		if (!regs_base) {
 			pr_err("Could not ioremap: start=%p, len=%d\n",
-				 (void *) r->start, len);
+				 (void *) r2->start, len);
 			ret = -EBUSY;
-			goto fail;
+			goto fail_mem;
 		}
 
 		irq = platform_get_irq_byname(pdev, "secure_irq");
 		if (irq < 0) {
 			ret = -ENODEV;
-			goto fail;
+			goto fail_io;
 		}
 
 		mb();
@@ -211,14 +211,14 @@ static int msm_iommu_probe(struct platform_device *pdev)
 		if (GET_IDR(regs_base) == 0) {
 			pr_err("Invalid IDR value detected\n");
 			ret = -ENODEV;
-			goto fail;
+			goto fail_io;
 		}
 
 		ret = request_irq(irq, msm_iommu_fault_handler, 0,
 				"msm_iommu_secure_irpt_handler", drvdata);
 		if (ret) {
 			pr_err("Request IRQ %d failed with ret=%d\n", irq, ret);
-			goto fail;
+			goto fail_io;
 		}
 
 		msm_iommu_reset(regs_base);
@@ -237,6 +237,10 @@ static int msm_iommu_probe(struct platform_device *pdev)
 
 	return 0;
 
+fail_io:
+	iounmap(regs_base);
+fail_mem:
+	release_mem_region(r->start, len);
 fail:
 	kfree(drvdata);
 	return ret;
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2BQNJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:09:00 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46188 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2BQNI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:08:59 -0500
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@yxit.co.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Subject: [PATCH 2/2] ARM: dma-mapping: fix leak in consistent_init
Date: Fri, 17 Feb 2012 18:39:55 +0530
Message-Id: <1329484195-26361-1-git-send-email-ajeet.yadav.77@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the error in this case is unlikely, but logically
if error occurs then we leak memory.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 arch/arm/mm/dma-mapping.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 04bfa76..b8cf062 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -161,7 +161,6 @@ static struct arm_vmregion_head consistent_head = {
  */
 static int __init consistent_init(void)
 {
-	int ret = 0;
 	pgd_t *pgd;
 	pud_t *pud;
 	pmd_t *pmd;
@@ -171,7 +170,7 @@ static int __init consistent_init(void)
 	unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
 
 	consistent_pte = kmalloc(num_ptes * sizeof(pte_t *), GFP_KERNEL);
-	if (!consistent_pte) {
+	if (unlikely(!consistent_pte)) {
 		pr_err("%s: no memory\n", __func__);
 		return -ENOMEM;
 	}
@@ -183,32 +182,33 @@ static int __init consistent_init(void)
 		pgd = pgd_offset(&init_mm, base);
 
 		pud = pud_alloc(&init_mm, pgd, base);
-		if (!pud) {
+		if (unlikely(!pud)) {
 			printk(KERN_ERR "%s: no pud tables\n", __func__);
-			ret = -ENOMEM;
-			break;
+			goto err;
 		}
 
 		pmd = pmd_alloc(&init_mm, pud, base);
-		if (!pmd) {
+		if (unlikely(!pmd)) {
 			printk(KERN_ERR "%s: no pmd tables\n", __func__);
-			ret = -ENOMEM;
-			break;
+			goto err;
 		}
 		WARN_ON(!pmd_none(*pmd));
 
 		pte = pte_alloc_kernel(pmd, base);
-		if (!pte) {
+		if (unlikely(!pte)) {
 			printk(KERN_ERR "%s: no pte tables\n", __func__);
-			ret = -ENOMEM;
-			break;
+			goto err;
 		}
 
 		consistent_pte[i++] = pte;
 		base += PMD_SIZE;
 	} while (base < CONSISTENT_END);
 
-	return ret;
+	return 0;
+err:
+	kfree(consistent_pte);
+	consistent_pte = NULL;
+	return -ENOMEM;
 }
 
 core_initcall(consistent_init);
-- 
1.7.8.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2BQN0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:26:39 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34138 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2BQN0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:26:38 -0500
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@yxit.co.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Subject: [PATCH 2/2] ARM: dma-mapping: fix leak in consistent_init
Date: Fri, 17 Feb 2012 18:57:17 +0530
Message-Id: <1329485237-26447-1-git-send-email-ajeet.yadav.77@gmail.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the error in this case is unlikely, but logically
if error occurs then we leak memory.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
---
 arch/arm/mm/dma-mapping.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 04bfa76..932d288 100644
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
@@ -185,30 +184,31 @@ static int __init consistent_init(void)
 		pud = pud_alloc(&init_mm, pgd, base);
 		if (!pud) {
 			printk(KERN_ERR "%s: no pud tables\n", __func__);
-			ret = -ENOMEM;
-			break;
+			goto err;
 		}
 
 		pmd = pmd_alloc(&init_mm, pud, base);
 		if (!pmd) {
 			printk(KERN_ERR "%s: no pmd tables\n", __func__);
-			ret = -ENOMEM;
-			break;
+			goto err;
 		}
 		WARN_ON(!pmd_none(*pmd));
 
 		pte = pte_alloc_kernel(pmd, base);
 		if (!pte) {
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


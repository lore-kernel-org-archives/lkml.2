Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328Ab0KORlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:41:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49306 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933317Ab0KORlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:41:03 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/20] ARM: LPAE: Change setup_mm_for_reboot() to work with LPAE
Date: Mon, 15 Nov 2010 17:40:19 +0000
Message-Id: <1289842829-3027-11-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
References: <1289842829-3027-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 15 Nov 2010 17:40:36.0144 (UTC) FILETIME=[35E37B00:01CB84EC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was assuming that there are only two levels of page
tables. The patch changes looping over the PMD entries to make it
compatible with LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/mmu.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 0ce781f..e238340 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1098,13 +1098,16 @@ void setup_mm_for_reboot(char mode)
 	if (cpu_architecture() <= CPU_ARCH_ARMv5TEJ && !cpu_is_xscale())
 		base_pmdval |= PMD_BIT4;
 
-	for (i = 0; i < FIRST_USER_PGD_NR + USER_PTRS_PER_PGD; i++, pgd++) {
+	for (i = 0; i < TASK_SIZE >> PMD_SHIFT; i++) {
 		unsigned long pmdval = (i << PMD_SHIFT) | base_pmdval;
 		pmd_t *pmd;
+		unsigned long addr = i << PMD_SHIFT;
 
-		pmd = pmd_off(pgd, i << PMD_SHIFT);
+		pmd = pmd_off(pgd + pgd_index(addr), addr);
 		pmd[0] = __pmd(pmdval);
+#ifndef CONFIG_ARM_LPAE
 		pmd[1] = __pmd(pmdval + (1 << (PMD_SHIFT - 1)));
+#endif
 		flush_pmd_entry(pmd);
 	}
 

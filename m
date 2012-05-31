Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798Ab2EaTsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:48:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:36248 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781Ab2EaTsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:48:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: konrad@darnok.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org
Subject: [PATCH] x86/i386: Check PSE bit before using PAGE_KERNEL_LARGE.
Date: Thu, 31 May 2012 15:40:18 -0400
Message-Id: <1338493218-25006-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During bootup we would unconditionally do this on any
machine that was built with CONFIG_NUMA=y on i386:

setup_arch
  \-initmem_init
      \-x86_numa_init (with dummy_init as callback)
          \- init_alloc_remap
               \- set_pmd_pfn (with PAGE_PSE)

without checking to see if the CPU supports PSE. This
patch adds that and also allows the init_alloc_remap function
to properly work by falling back on PTEs.

CC: stable@kernel.org
Tested-by: William Dauchy <wdauchy@gmail.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/pgtable_32.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index a69bcb8..9fd4abc 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -86,7 +86,30 @@ void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
 	}
 	pud = pud_offset(pgd, vaddr);
 	pmd = pmd_offset(pud, vaddr);
-	set_pmd(pmd, pfn_pmd(pfn, flags));
+
+	if ((!cpu_has_pse) && (pgprot_val(flags) & _PAGE_PSE)) {
+		pte_t *pte;
+		int i;
+
+		pgprot_val(flags) &= ~_PAGE_PSE;
+
+		/*
+		 * This is run _after_ initial memory mapped so the
+		 * PTE page are allocated - but we check it just in case.
+		 */
+		if (pmd_none(*pmd)) {
+			printk(KERN_WARNING "set_pmd_pfn: pmd_none\n");
+			return;
+		}
+
+		pte = (pte_t *)pmd_page_vaddr(*pmd);
+		for (i = 0; i < PTRS_PER_PTE; i++) {
+			set_pte(pte, pfn_pte(pfn + i, flags));
+			pte++;
+		}
+	} else
+		set_pmd(pmd, pfn_pmd(pfn, flags));
+
 	/*
 	 * It's enough to flush this one mapping.
 	 * (PGE mappings get flushed as well)
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3ADAtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:49:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30158 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab3ADAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v7u1 04/31] x86, 64bit, mm: add generic kernel/ident mapping helper
Date: Thu,  3 Jan 2013 16:48:24 -0800
Message-Id: <1357260531-11115-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is simple version for kernel_physical_mapping_init.
it will work to build one page table that will be used later.

Use mapping_info to control
        1. alloc_pg_page method
        2. if PMD is EXEC,
        3. if pgd is with kernel low mapping or ident mapping.

Will use to replace some local versions in kexec, hibernation and etc.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/init.h |   12 ++++++
 arch/x86/mm/init_64.c       |   90 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 102 insertions(+)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index bac770b..62052c5 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -1,5 +1,17 @@
 #ifndef _ASM_X86_INIT_H
 #define _ASM_X86_INIT_H
 
+struct x86_mapping_info {
+	void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
+	void *context;			 /* context for alloc_pgt_page */
+	unsigned long pmd_flag;		 /* page flag for PMD entry */
+	bool kernel_mapping;		 /* kernel mapping or ident mapping */
+};
+
+int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
+				unsigned long addr, unsigned long end);
+
+int kernel_mapping_init(pgd_t *pgd_page,
+				unsigned long addr, unsigned long end);
 
 #endif /* _ASM_X86_INIT_H */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index b1178eb..9c5f2b1 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -56,6 +56,96 @@
 
 #include "mm_internal.h"
 
+static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
+			   unsigned long addr, unsigned long end)
+{
+	addr &= PMD_MASK;
+	for (; addr < end; addr += PMD_SIZE) {
+		pmd_t *pmd = pmd_page + pmd_index(addr);
+
+		if (!pmd_present(*pmd))
+			set_pmd(pmd, __pmd(addr | pmd_flag));
+	}
+}
+static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
+			  unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+
+	for (; addr < end; addr = next) {
+		pud_t *pud = pud_page + pud_index(addr);
+		pmd_t *pmd;
+
+		next = (addr & PUD_MASK) + PUD_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pud_present(*pud)) {
+			pmd = pmd_offset(pud, 0);
+			ident_pmd_init(info->pmd_flag, pmd, addr, next);
+			continue;
+		}
+		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
+		if (!pmd)
+			return -ENOMEM;
+		ident_pmd_init(info->pmd_flag, pmd, addr, next);
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+
+	return 0;
+}
+
+int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
+			      unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	int result;
+	int off = info->kernel_mapping ? pgd_index(__PAGE_OFFSET) : 0;
+
+	for (; addr < end; addr = next) {
+		pgd_t *pgd = pgd_page + pgd_index(addr) + off;
+		pud_t *pud;
+
+		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pgd_present(*pgd)) {
+			pud = pud_offset(pgd, 0);
+			result = ident_pud_init(info, pud, addr, next);
+			if (result)
+				return result;
+			continue;
+		}
+
+		pud = (pud_t *)info->alloc_pgt_page(info->context);
+		if (!pud)
+			return -ENOMEM;
+		result = ident_pud_init(info, pud, addr, next);
+		if (result)
+			return result;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+
+	return 0;
+}
+
+static void *alloc_pgt_page(void *context)
+{
+	return alloc_low_page();
+}
+
+int kernel_mapping_init(pgd_t *pgd_page, unsigned long addr, unsigned long end)
+{
+	struct x86_mapping_info info = {
+		.alloc_pgt_page	= alloc_pgt_page,
+		.pmd_flag	= __PAGE_KERNEL_LARGE,
+		.kernel_mapping	= true,
+	};
+
+	return kernel_ident_mapping_init(&info, pgd_page, addr, end);
+}
+
 static int __init parse_direct_gbpages_off(char *arg)
 {
 	direct_gbpages = 0;
-- 
1.7.10.4


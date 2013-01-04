Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab3ADAyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:54:13 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30322 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3ADAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org
Subject: [PATCH v7u1 31/31] x86, 64bit, mm: hibernate use generic mapping_init
Date: Thu,  3 Jan 2013 16:48:51 -0800
Message-Id: <1357260531-11115-32-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it only map range in pfn_mapped array.

and it has kernel mapping with EXEC.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org
---
 arch/x86/power/hibernate_64.c |   66 ++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 460f314..a0fde91 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -11,6 +11,8 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/suspend.h>
+
+#include <asm/init.h>
 #include <asm/proto.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -39,41 +41,21 @@ pgd_t *temp_level4_pgt;
 
 void *relocated_restore_code;
 
-static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
+static void *alloc_pgt_page(void *context)
 {
-	long i, j;
-
-	i = pud_index(address);
-	pud = pud + i;
-	for (; i < PTRS_PER_PUD; pud++, i++) {
-		unsigned long paddr;
-		pmd_t *pmd;
-
-		paddr = address + i*PUD_SIZE;
-		if (paddr >= end)
-			break;
-
-		pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
-		if (!pmd)
-			return -ENOMEM;
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
-		for (j = 0; j < PTRS_PER_PMD; pmd++, j++, paddr += PMD_SIZE) {
-			unsigned long pe;
-
-			if (paddr >= end)
-				break;
-			pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
-			pe &= __supported_pte_mask;
-			set_pmd(pmd, __pmd(pe));
-		}
-	}
-	return 0;
+	return (void *)get_safe_page(GFP_ATOMIC);
 }
 
 static int set_up_temporary_mappings(void)
 {
-	unsigned long start, end, next;
-	int error;
+	struct x86_mapping_info info = {
+		.alloc_pgt_page	= alloc_pgt_page,
+		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
+		.kernel_mapping = true,
+	};
+	unsigned long mstart, mend;
+	int result;
+	int i;
 
 	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
 	if (!temp_level4_pgt)
@@ -84,21 +66,17 @@ static int set_up_temporary_mappings(void)
 		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
 
 	/* Set up the direct mapping from scratch */
-	start = (unsigned long)pfn_to_kaddr(0);
-	end = (unsigned long)pfn_to_kaddr(max_pfn);
-
-	for (; start < end; start = next) {
-		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
-		if (!pud)
-			return -ENOMEM;
-		next = start + PGDIR_SIZE;
-		if (next > end)
-			next = end;
-		if ((error = res_phys_pud_init(pud, __pa(start), __pa(next))))
-			return error;
-		set_pgd(temp_level4_pgt + pgd_index(start),
-			mk_kernel_pgd(__pa(pud)));
+	for (i = 0; i < nr_pfn_mapped; i++) {
+		mstart = pfn_mapped[i].start << PAGE_SHIFT;
+		mend   = pfn_mapped[i].end << PAGE_SHIFT;
+
+		result = kernel_ident_mapping_init(&info, temp_level4_pgt,
+						   mstart, mend);
+
+		if (result)
+			return result;
 	}
+
 	return 0;
 }
 
-- 
1.7.10.4


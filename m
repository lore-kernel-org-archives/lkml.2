Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3ADA5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:57:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:30161 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab3ADAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:49:29 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v7u1 21/31] x86, kexec: only set ident mapping for ram.
Date: Thu,  3 Jan 2013 16:48:41 -0800
Message-Id: <1357260531-11115-22-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not set mapping for all under max_pfn.
That causes same problem that is fixed by

	x86, mm: Only direct map addresses that are marked as E820_RAM

This patch expose pfn_mapped array, and only set ident mapping for ranges
in that array.

This patch rely on new ident_mapping_init that could handle existing
pgd/pud between different calling.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
---
 arch/x86/include/asm/page.h        |    4 ++++
 arch/x86/kernel/machine_kexec_64.c |   13 +++++++++----
 arch/x86/mm/init.c                 |    4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 3698a6a..c878924 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -17,6 +17,10 @@
 
 struct page;
 
+#include <linux/range.h>
+extern struct range pfn_mapped[];
+extern int nr_pfn_mapped;
+
 static inline void clear_user_page(void *page, unsigned long vaddr,
 				   struct page *pg)
 {
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index d2d7e02..4eabc16 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -100,10 +100,15 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 
 	level4p = (pgd_t *)__va(start_pgtable);
 	clear_page(level4p);
-	result = kernel_ident_mapping_init(&info, level4p,
-						0, max_pfn << PAGE_SHIFT);
-	if (result)
-		return result;
+	for (i = 0; i < nr_pfn_mapped; i++) {
+		mstart = pfn_mapped[i].start << PAGE_SHIFT;
+		mend   = pfn_mapped[i].end << PAGE_SHIFT;
+
+		result = kernel_ident_mapping_init(&info,
+						 level4p, mstart, mend);
+		if (result)
+			return result;
+	}
 
 	/*
 	 * segments's mem ranges could be outside 0 ~ max_pfn,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index ab26a15..d704b36 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -300,8 +300,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-static struct range pfn_mapped[E820_X_MAX];
-static int nr_pfn_mapped;
+struct range pfn_mapped[E820_X_MAX];
+int nr_pfn_mapped;
 
 static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
 {
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab2KZRNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:13:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48059 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933025Ab2KZRN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:13:28 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Young <dyoung@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Flavio Leitner <fbl@redhat.com>,
        Tejun Heo <tj@kernel.org>, ianfang.cn@gmail.com,
        Vivek Goyal <vgoyal@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 217/270] Revert "x86/mm: Fix the size calculation of mapping tables"
Date: Mon, 26 Nov 2012 14:58:27 -0200
Message-Id: <1353949160-26803-218-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Young <dyoung@redhat.com>

commit 7b16bbf97375d9fb7fc107b3f80afeb94a204e44 upstream.

Commit:

   722bc6b16771 x86/mm: Fix the size calculation of mapping tables

Tried to address the issue that the first 2/4M should use 4k pages
if PSE enabled, but extra counts should only be valid for x86_32.

This commit caused a kdump regression: the kdump kernel hangs.

Work is in progress to fundamentally fix the various page table
initialization issues that we have, via the design suggested
by H. Peter Anvin, but it's not ready yet to be merged.

So, to get a working kdump revert to the last known working version,
which is the revert of this commit and of a followup fix (which was
incomplete):

   bd2753b2dda7 x86/mm: Only add extra pages count for the first memory range during pre-allocation

Tested kdump on physical and virtual machines.

Signed-off-by: Dave Young <dyoung@redhat.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Flavio Leitner <fbl@redhat.com>
Tested-by: Flavio Leitner <fbl@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Flavio Leitner <fbl@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: ianfang.cn@gmail.com
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/mm/init.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..37b2e6a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -29,14 +29,8 @@ int direct_gbpages
 #endif
 ;
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
-static void __init find_early_table_space(struct map_range *mr, unsigned long end,
-					  int use_pse, int use_gbpages)
+static void __init find_early_table_space(unsigned long end, int use_pse,
+					  int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -61,10 +55,6 @@ static void __init find_early_table_space(struct map_range *mr, unsigned long en
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
 #endif
-		/* The first 2/4M doesn't use large pages. */
-		if (mr->start < PMD_SIZE)
-			extra += mr->end - mr->start;
-
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -95,6 +85,12 @@ void __init native_pagetable_reserve(u64 start, u64 end)
 	memblock_reserve(start, end - start);
 }
 
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -267,7 +263,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
+		find_early_table_space(end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,
-- 
1.7.9.5


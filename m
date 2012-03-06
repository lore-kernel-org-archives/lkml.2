Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2CFQQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:16:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab2CFQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:16:43 -0500
Date: Tue, 6 Mar 2012 08:16:11 -0800
From: tip-bot for WANG Cong <xiyou.wangcong@gmail.com>
Message-ID: <tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, xiyou.wangcong@gmail.com,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        ianfang.cn@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, xiyou.wangcong@gmail.com,
        akpm@linux-foundation.org, tj@kernel.org, tglx@linutronix.de,
        ianfang.cn@gmail.com, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Fix the size calculation of mapping tables
Git-Commit-ID: 722bc6b16771ed80871e1fd81c86d3627dda2ac8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:16:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  722bc6b16771ed80871e1fd81c86d3627dda2ac8
Gitweb:     http://git.kernel.org/tip/722bc6b16771ed80871e1fd81c86d3627dda2ac8
Author:     WANG Cong <xiyou.wangcong@gmail.com>
AuthorDate: Mon, 5 Mar 2012 15:05:13 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:38:26 +0100

x86/mm: Fix the size calculation of mapping tables

For machines that enable PSE, the first 2/4M memory region still uses
4K pages, so needs more PTEs in this case, but
find_early_table_space() doesn't count this.

This patch fixes it.

The bug was found via code review, no misbehavior of the kernel
was observed.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <ianfang.cn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-kq6a00qe33h7c7ais2xsywnh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/init.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6cabf65..2e92fdc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -30,8 +30,14 @@ int direct_gbpages
 #endif
 ;
 
-static void __init find_early_table_space(unsigned long end, int use_pse,
-					  int use_gbpages)
+struct map_range {
+	unsigned long start;
+	unsigned long end;
+	unsigned page_size_mask;
+};
+
+static void __init find_early_table_space(struct map_range *mr, unsigned long end,
+					  int use_pse, int use_gbpages)
 {
 	unsigned long puds, pmds, ptes, tables, start = 0, good_end = end;
 	phys_addr_t base;
@@ -56,6 +62,9 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 #ifdef CONFIG_X86_32
 		extra += PMD_SIZE;
 #endif
+		/* The first 2/4M doesn't use large pages. */
+		extra += mr->end - mr->start;
+
 		ptes = (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
 		ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -85,12 +94,6 @@ void __init native_pagetable_reserve(u64 start, u64 end)
 	memblock_reserve(start, end - start);
 }
 
-struct map_range {
-	unsigned long start;
-	unsigned long end;
-	unsigned page_size_mask;
-};
-
 #ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
 #else /* CONFIG_X86_64 */
@@ -262,7 +265,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	 * nodes are discovered.
 	 */
 	if (!after_bootmem)
-		find_early_table_space(end, use_pse, use_gbpages);
+		find_early_table_space(&mr[0], end, use_pse, use_gbpages);
 
 	for (i = 0; i < nr_range; i++)
 		ret = kernel_physical_mapping_init(mr[i].start, mr[i].end,

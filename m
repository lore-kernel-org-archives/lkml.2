Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2FYGLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:11:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:27904 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab2FYGLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162133406"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 9/9] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
Date: Mon, 25 Jun 2012 14:08:27 +0800
Message-Id: <1340604507-11214-10-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch do flush_tlb_kernel_range by 'invlpg'. The performance pay
and gain was analyzed in previous patch
(x86/flush_tlb: try flush_tlb_single one by one in flush_tlb_range).

In the testing: http://lkml.org/lkml/2012/6/21/10

The pay is mostly covered by long kernel path, but the gain is still
quite clear, memory access in user APP can increase 30+% when kernel
execute this funtion.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/include/asm/tlbflush.h |   13 +++++++------
 arch/x86/mm/tlb.c               |   30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 008043d..f434842 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -123,6 +123,12 @@ static inline void reset_lazy_tlbstate(void)
 {
 }
 
+static inline void flush_tlb_kernel_range(unsigned long start,
+					  unsigned long end)
+{
+	flush_tlb_all();
+}
+
 #else  /* SMP */
 
 #include <asm/smp.h>
@@ -139,6 +145,7 @@ extern void flush_tlb_current_task(void);
 extern void flush_tlb_page(struct vm_area_struct *, unsigned long);
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 				unsigned long end, unsigned long vmflag);
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 #define flush_tlb()	flush_tlb_current_task()
 
@@ -168,10 +175,4 @@ static inline void reset_lazy_tlbstate(void)
 	native_flush_tlb_others(mask, mm, start, end)
 #endif
 
-static inline void flush_tlb_kernel_range(unsigned long start,
-					  unsigned long end)
-{
-	flush_tlb_all();
-}
-
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 2b5f506..fa78df9 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -264,6 +264,36 @@ void flush_tlb_all(void)
 	on_each_cpu(do_flush_tlb_all, NULL, 1);
 }
 
+static void do_kernel_range_flush(void *info)
+{
+	struct flush_tlb_info *f = info;
+	unsigned long addr;
+
+	/* flush range by one by one 'invlpg' */
+	for (addr = f->flush_start; addr < f->flush_end; addr += PAGE_SIZE)
+		__flush_tlb_single(addr);
+}
+
+void flush_tlb_kernel_range(unsigned long start, unsigned long end)
+{
+	unsigned act_entries;
+	struct flush_tlb_info info;
+
+	/* In modern CPU, last level tlb used for both data/ins */
+	act_entries = tlb_lld_4k[ENTRIES];
+
+	/* tlb_flushall_shift is on balance point, details in commit log */
+	if (end == TLB_FLUSH_ALL || tlb_flushall_shift == -1 ||
+		(end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift)
+
+		on_each_cpu(do_flush_tlb_all, NULL, 1);
+	else {
+		info.flush_start = start;
+		info.flush_end = end;
+		on_each_cpu(do_kernel_range_flush, &info, 1);
+	}
+}
+
 #ifdef CONFIG_DEBUG_TLBFLUSH
 static ssize_t tlbflush_read_file(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
-- 
1.7.5.4


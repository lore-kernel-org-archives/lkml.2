Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab2FZPUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:20:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2FZPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:20:10 -0400
Date: Tue, 26 Jun 2012 08:19:58 -0700
From: tip-bot for Alex Shi <alex.shi@intel.com>
Message-ID: <tip-b3ce6624a8364343e55d54cd3a2973d614b17256@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        alex.shi@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, alex.shi@intel.com
In-Reply-To: <1340604507-11214-10-git-send-email-alex.shi@intel.com>
References: <1340604507-11214-10-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
Git-Commit-ID: b3ce6624a8364343e55d54cd3a2973d614b17256
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 26 Jun 2012 08:20:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3ce6624a8364343e55d54cd3a2973d614b17256
Gitweb:     http://git.kernel.org/tip/b3ce6624a8364343e55d54cd3a2973d614b17256
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Mon, 25 Jun 2012 14:08:27 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 25 Jun 2012 20:53:21 -0700

x86/tlb: do flush_tlb_kernel_range by 'invlpg'

This patch do flush_tlb_kernel_range by 'invlpg'. The performance pay
and gain was analyzed in previous patch
(x86/flush_tlb: try flush_tlb_single one by one in flush_tlb_range).

In the testing: http://lkml.org/lkml/2012/6/21/10

The pay is mostly covered by long kernel path, but the gain is still
quite clear, memory access in user APP can increase 30+% when kernel
execute this funtion.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Link: http://lkml.kernel.org/r/1340604507-11214-10-git-send-email-alex.shi@intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2ACUUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:20:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:62042 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab2ACUUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:20:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102811090"
Message-Id: <41e3e15bf9770aea7e8740f7407b1e020a1c1a35.1325620195.git.tony.luck@intel.com>
In-Reply-To: <cover.1325620195.git.tony.luck@intel.com>
References: <cover.1325620195.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Thu, 15 Dec 2011 10:48:12 -0800
Subject: [PATCH 1/6] HWPOISON: Clean up memory_failure() vs. __memory_failure()
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is only one caller of memory_failure(), all other users call
__memory_failure() and pass in the flags argument explicitly. The
lone user of memory_failure() will soon need to pass flags too.

Add flags argument to the callsite in mce.c. Delete the old memory_failure()
function, and then rename __memory_failure() without the leading "__".

Provide clearer message when action optional memory errors are ignored.

Acked-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   12 ++++++---
 drivers/base/memory.c            |    2 +-
 include/linux/mm.h               |    3 +-
 mm/hwpoison-inject.c             |    4 +-
 mm/madvise.c                     |    2 +-
 mm/memory-failure.c              |   46 +++++++++++++++++--------------------
 6 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2af127d..1a08ce5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1046,11 +1046,15 @@ out:
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
-/* dummy to break dependency. actual code is in mm/memory-failure.c */
-void __attribute__((weak)) memory_failure(unsigned long pfn, int vector)
+#ifndef CONFIG_MEMORY_FAILURE
+int memory_failure(unsigned long pfn, int vector, int flags)
 {
-	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
+	printk(KERN_ERR "Uncorrected memory error in page 0x%lx ignored\n"
+		"Rebuild kernel with CONFIG_MEMORY_FAILURE=y for smarter handling\n", pfn);
+
+	return 0;
 }
+#endif
 
 /*
  * Called after mce notification in process context. This code
@@ -1068,7 +1072,7 @@ void mce_notify_process(void)
 	unsigned long pfn;
 	mce_notify_irq();
 	while (mce_ring_get(&pfn))
-		memory_failure(pfn, MCE_VECTOR);
+		memory_failure(pfn, MCE_VECTOR, 0);
 }
 
 static void mce_process_work(struct work_struct *dummy)
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 8272d92..9a92444 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -474,7 +474,7 @@ store_hard_offline_page(struct class *class,
 	if (strict_strtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
-	ret = __memory_failure(pfn, 0, 0);
+	ret = memory_failure(pfn, 0, 0);
 	return ret ? ret : count;
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4baadd1..bcc5234 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1607,8 +1607,7 @@ void vmemmap_populate_print_last(void);
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 };
-extern void memory_failure(unsigned long pfn, int trapno);
-extern int __memory_failure(unsigned long pfn, int trapno, int flags);
+extern int memory_failure(unsigned long pfn, int trapno, int flags);
 extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index c7fc7fd..cc448bb 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -45,7 +45,7 @@ static int hwpoison_inject(void *data, u64 val)
 	 * do a racy check with elevated page count, to make sure PG_hwpoison
 	 * will only be set for the targeted owner (or on a free page).
 	 * We temporarily take page lock for try_get_mem_cgroup_from_page().
-	 * __memory_failure() will redo the check reliably inside page lock.
+	 * memory_failure() will redo the check reliably inside page lock.
 	 */
 	lock_page(hpage);
 	err = hwpoison_filter(hpage);
@@ -55,7 +55,7 @@ static int hwpoison_inject(void *data, u64 val)
 
 inject:
 	printk(KERN_INFO "Injecting memory failure at pfn %lx\n", pfn);
-	return __memory_failure(pfn, 18, MF_COUNT_INCREASED);
+	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
diff --git a/mm/madvise.c b/mm/madvise.c
index 74bf193..f5ab745 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -251,7 +251,7 @@ static int madvise_hwpoison(int bhv, unsigned long start, unsigned long end)
 		printk(KERN_INFO "Injecting memory failure for page %lx at %lx\n",
 		       page_to_pfn(p), start);
 		/* Ignore return value for now */
-		__memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
+		memory_failure(page_to_pfn(p), 0, MF_COUNT_INCREASED);
 	}
 	return ret;
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 06d3479..ab259bb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -984,7 +984,25 @@ static void clear_page_hwpoison_huge_page(struct page *hpage)
 		ClearPageHWPoison(hpage + i);
 }
 
-int __memory_failure(unsigned long pfn, int trapno, int flags)
+/**
+ * memory_failure - Handle memory failure of a page.
+ * @pfn: Page Number of the corrupted page
+ * @trapno: Trap number reported in the signal to user space.
+ * @flags: fine tune action taken
+ *
+ * This function is called by the low level machine check code
+ * of an architecture when it detects hardware memory corruption
+ * of a page. It tries its best to recover, which includes
+ * dropping pages, killing processes etc.
+ *
+ * The function is primarily of use for corruptions that
+ * happen outside the current execution context (e.g. when
+ * detected by a background scrubber)
+ *
+ * Must run in process context (e.g. a work queue) with interrupts
+ * enabled and no spinlocks hold.
+ */
+int memory_failure(unsigned long pfn, int trapno, int flags)
 {
 	struct page_state *ps;
 	struct page *p;
@@ -1156,29 +1174,7 @@ out:
 	unlock_page(hpage);
 	return res;
 }
-EXPORT_SYMBOL_GPL(__memory_failure);
-
-/**
- * memory_failure - Handle memory failure of a page.
- * @pfn: Page Number of the corrupted page
- * @trapno: Trap number reported in the signal to user space.
- *
- * This function is called by the low level machine check code
- * of an architecture when it detects hardware memory corruption
- * of a page. It tries its best to recover, which includes
- * dropping pages, killing processes etc.
- *
- * The function is primarily of use for corruptions that
- * happen outside the current execution context (e.g. when
- * detected by a background scrubber)
- *
- * Must run in process context (e.g. a work queue) with interrupts
- * enabled and no spinlocks hold.
- */
-void memory_failure(unsigned long pfn, int trapno)
-{
-	__memory_failure(pfn, trapno, 0);
-}
+EXPORT_SYMBOL_GPL(memory_failure);
 
 #define MEMORY_FAILURE_FIFO_ORDER	4
 #define MEMORY_FAILURE_FIFO_SIZE	(1 << MEMORY_FAILURE_FIFO_ORDER)
@@ -1251,7 +1247,7 @@ static void memory_failure_work_func(struct work_struct *work)
 		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
 		if (!gotten)
 			break;
-		__memory_failure(entry.pfn, entry.trapno, entry.flags);
+		memory_failure(entry.pfn, entry.trapno, entry.flags);
 	}
 }
 
-- 
1.7.3.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab1EQIK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:10:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:63390 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab1EQIIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:08:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2661660"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/9] HWPoison: add memory_failure_queue()
Date: Tue, 17 May 2011 16:08:35 +0800
Message-Id: <1305619719-7480-6-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memory_failure() is the entry point for HWPoison memory error
recovery.  It must be called in process context.  But commonly
hardware memory errors are notified via MCE or NMI, so some delayed
execution mechanism must be used.  In MCE handler, a work queue + ring
buffer mechanism is used.

In addition to MCE, now APEI (ACPI Platform Error Interface) GHES
(Generic Hardware Error Source) can be used to report memory errors
too.  To add support to APEI GHES memory recovery, a mechanism similar
to that of MCE is implemented.  memory_failure_queue() is the new
entry point that can be called in IRQ context.  The next step is to
make MCE handler uses this interface too.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/mm.h  |    1 
 mm/memory-failure.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1664,6 +1664,7 @@ enum mf_flags {
 };
 extern void memory_failure(unsigned long pfn, int trapno);
 extern int __memory_failure(unsigned long pfn, int trapno, int flags);
+extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
 extern int unpoison_memory(unsigned long pfn);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/kfifo.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1182,6 +1183,97 @@ void memory_failure(unsigned long pfn, i
 	__memory_failure(pfn, trapno, 0);
 }
 
+#define MEMORY_FAILURE_FIFO_ORDER	4
+#define MEMORY_FAILURE_FIFO_SIZE	(1 << MEMORY_FAILURE_FIFO_ORDER)
+
+struct memory_failure_entry {
+	unsigned long pfn;
+	int trapno;
+	int flags;
+};
+
+struct memory_failure_cpu {
+	DECLARE_KFIFO(fifo, struct memory_failure_entry,
+		      MEMORY_FAILURE_FIFO_SIZE);
+	spinlock_t lock;
+	struct work_struct work;
+};
+
+static DEFINE_PER_CPU(struct memory_failure_cpu, memory_failure_cpu);
+
+/**
+ * memory_failure_queue - Schedule handling memory failure of a page.
+ * @pfn: Page Number of the corrupted page
+ * @trapno: Trap number reported in the signal to user space.
+ * @flags: Flags for memory failure handling
+ *
+ * This function is called by the low level hardware error handler
+ * when it detects hardware memory corruption of a page. It schedules
+ * the recovering of error page, including dropping pages, killing
+ * processes etc.
+ *
+ * The function is primarily of use for corruptions that
+ * happen outside the current execution context (e.g. when
+ * detected by a background scrubber)
+ *
+ * Can run in IRQ context.
+ */
+void memory_failure_queue(unsigned long pfn, int trapno, int flags)
+{
+	struct memory_failure_cpu *mf_cpu;
+	unsigned long proc_flags;
+	struct memory_failure_entry entry = {
+		.pfn =		pfn,
+		.trapno =	trapno,
+		.flags =	flags,
+	};
+
+	mf_cpu = &get_cpu_var(memory_failure_cpu);
+	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
+	if (kfifo_put(&mf_cpu->fifo, &entry))
+		schedule_work_on(smp_processor_id(), &mf_cpu->work);
+	else
+		pr_err("Memory failure: buffer overflow when recovering memory failure at 0x%#lx\n",
+		       pfn);
+	spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
+	put_cpu_var(memory_failure_cpu);
+}
+EXPORT_SYMBOL_GPL(memory_failure_queue);
+
+static void memory_failure_work_func(struct work_struct *work)
+{
+	struct memory_failure_cpu *mf_cpu;
+	struct memory_failure_entry entry = { 0, };
+	unsigned long proc_flags;
+	int gotten;
+
+	mf_cpu = &__get_cpu_var(memory_failure_cpu);
+	for (;;) {
+		spin_lock_irqsave(&mf_cpu->lock, proc_flags);
+		gotten = kfifo_get(&mf_cpu->fifo, &entry);
+		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
+		if (!gotten)
+			break;
+		__memory_failure(entry.pfn, entry.trapno, entry.flags);
+	}
+}
+
+static int __init memory_failure_init(void)
+{
+	struct memory_failure_cpu *mf_cpu;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		mf_cpu = &per_cpu(memory_failure_cpu, cpu);
+		spin_lock_init(&mf_cpu->lock);
+		INIT_KFIFO(mf_cpu->fifo);
+		INIT_WORK(&mf_cpu->work, memory_failure_work_func);
+	}
+
+	return 0;
+}
+core_initcall(memory_failure_init);
+
 /**
  * unpoison_memory - Unpoison a previously poisoned page
  * @pfn: Page number of the to be unpoisoned page

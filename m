Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab2EYRKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:10:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345Ab2EYRDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:30 -0400
From: Andrea Arcangeli <aarcange@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>
Subject: [PATCH 09/35] autonuma: mm_autonuma and sched_autonuma data structures
Date: Fri, 25 May 2012 19:02:13 +0200
Message-Id: <1337965359-29725-10-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the two data structures that collect the per-process (in the
mm) and per-thread (in the task_struct) statistical information that
are the input of the CPU follow memory algorithms in the NUMA
scheduler.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/autonuma_types.h |   57 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/autonuma_types.h

diff --git a/include/linux/autonuma_types.h b/include/linux/autonuma_types.h
new file mode 100644
index 0000000..65b175b
--- /dev/null
+++ b/include/linux/autonuma_types.h
@@ -0,0 +1,57 @@
+#ifndef _LINUX_AUTONUMA_TYPES_H
+#define _LINUX_AUTONUMA_TYPES_H
+
+#ifdef CONFIG_AUTONUMA
+
+#include <linux/numa.h>
+
+struct mm_autonuma {
+	struct list_head mm_node;
+	struct mm_struct *mm;
+	unsigned long numa_fault_tot; /* reset from here */
+	unsigned long numa_fault_pass;
+	unsigned long numa_fault[0];
+};
+
+extern int alloc_mm_autonuma(struct mm_struct *mm);
+extern void free_mm_autonuma(struct mm_struct *mm);
+extern void __init mm_autonuma_init(void);
+
+#define SCHED_AUTONUMA_FLAG_STOP_ONE_CPU	(1<<0)
+#define SCHED_AUTONUMA_FLAG_NEED_BALANCE	(1<<1)
+
+struct sched_autonuma {
+	int autonuma_node;
+	unsigned int autonuma_flags; /* zeroed from here */
+	unsigned long numa_fault_pass;
+	unsigned long numa_fault_tot;
+	unsigned long numa_fault[0];
+};
+
+extern int alloc_sched_autonuma(struct task_struct *tsk,
+				struct task_struct *orig,
+				int node);
+extern void __init sched_autonuma_init(void);
+extern void free_sched_autonuma(struct task_struct *tsk);
+
+#else /* CONFIG_AUTONUMA */
+
+static inline int alloc_mm_autonuma(struct mm_struct *mm)
+{
+	return 0;
+}
+static inline void free_mm_autonuma(struct mm_struct *mm) {}
+static inline void mm_autonuma_init(void) {}
+
+static inline int alloc_sched_autonuma(struct task_struct *tsk,
+				       struct task_struct *orig,
+				       int node)
+{
+	return 0;
+}
+static inline void sched_autonuma_init(void) {}
+static inline void free_sched_autonuma(struct task_struct *tsk) {}
+
+#endif /* CONFIG_AUTONUMA */
+
+#endif /* _LINUX_AUTONUMA_TYPES_H */

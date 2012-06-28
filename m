Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2F1M7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755415Ab2F1M7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:59:08 -0400
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
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 12/40] autonuma: core autonuma.h header
Date: Thu, 28 Jun 2012 14:55:52 +0200
Message-Id: <1340888180-15355-13-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the generic autonuma.h header that defines the generic
AutoNUMA specific functions like autonuma_setup_new_exec,
autonuma_split_huge_page, numa_hinting_fault, etc...

As usual functions like numa_hinting_fault that only matter for builds
with CONFIG_AUTONUMA=y are defined unconditionally, but they are only
linked into the kernel if CONFIG_AUTONUMA=n. Their call sites are
optimized away at build time (or kernel won't link).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/autonuma.h |   41 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/autonuma.h

diff --git a/include/linux/autonuma.h b/include/linux/autonuma.h
new file mode 100644
index 0000000..85ca5eb
--- /dev/null
+++ b/include/linux/autonuma.h
@@ -0,0 +1,41 @@
+#ifndef _LINUX_AUTONUMA_H
+#define _LINUX_AUTONUMA_H
+
+#ifdef CONFIG_AUTONUMA
+
+#include <linux/autonuma_flags.h>
+
+extern void autonuma_enter(struct mm_struct *mm);
+extern void autonuma_exit(struct mm_struct *mm);
+extern void __autonuma_migrate_page_remove(struct page *page);
+extern void autonuma_migrate_split_huge_page(struct page *page,
+					     struct page *page_tail);
+extern void autonuma_setup_new_exec(struct task_struct *p);
+
+static inline void autonuma_migrate_page_remove(struct page *page)
+{
+	if (ACCESS_ONCE(page->autonuma_migrate_nid) >= 0)
+		__autonuma_migrate_page_remove(page);
+}
+
+#define autonuma_printk(format, args...) \
+	if (autonuma_debug()) printk(format, ##args)
+
+#else /* CONFIG_AUTONUMA */
+
+static inline void autonuma_enter(struct mm_struct *mm) {}
+static inline void autonuma_exit(struct mm_struct *mm) {}
+static inline void autonuma_migrate_page_remove(struct page *page) {}
+static inline void autonuma_migrate_split_huge_page(struct page *page,
+						    struct page *page_tail) {}
+static inline void autonuma_setup_new_exec(struct task_struct *p) {}
+
+#endif /* CONFIG_AUTONUMA */
+
+extern pte_t __pte_numa_fixup(struct mm_struct *mm, struct vm_area_struct *vma,
+			      unsigned long addr, pte_t pte, pte_t *ptep);
+extern void __pmd_numa_fixup(struct mm_struct *mm, unsigned long addr,
+			     pmd_t *pmd);
+extern void numa_hinting_fault(struct page *page, int numpages);
+
+#endif /* _LINUX_AUTONUMA_H */

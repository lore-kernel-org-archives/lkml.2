Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab2FFOwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:52:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464Ab2FFOww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:52:52 -0400
Date: Wed, 6 Jun 2012 16:50:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] uprobes: document uprobe_register() vs
	uprobe_mmap() race
Message-ID: <20120606145026.GD24078@redhat.com>
References: <20120604145238.GA6408@redhat.com> <20120606144933.GA24078@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606144933.GA24078@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Because the mind is treacherous and makes us forget we need to write
stuff down.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 88e903d..6e3b181 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -44,6 +44,23 @@ static DEFINE_SPINLOCK(uprobes_treelock);	/* serialize rbtree access */
 
 #define UPROBES_HASH_SZ	13
 
+/*
+ * We need separate register/unregister and mmap/munmap lock hashes because
+ * of mmap_sem nesting.
+ *
+ * uprobe_register() needs to install probes on (potentially) all processes
+ * and thus needs to acquire multiple mmap_sems (consequtively, not
+ * concurrently), whereas uprobe_mmap() is called while holding mmap_sem
+ * for the particular process doing the mmap.
+ *
+ * uprobe_register()->register_for_each_vma() needs to drop/acquire mmap_sem
+ * because of lock order against i_mmap_mutex. This means there's a hole in
+ * the register vma iteration where a mmap() can happen.
+ *
+ * Thus uprobe_register() can race with uprobe_mmap() and we can try and
+ * install a probe where one is already installed.
+ */
+
 /* serialize (un)register */
 static struct mutex uprobes_mutex[UPROBES_HASH_SZ];
 
@@ -353,7 +370,9 @@ out:
 int __weak set_swbp(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long vaddr)
 {
 	int result;
-
+	/*
+	 * See the comment near uprobes_hash().
+	 */
 	result = is_swbp_at_addr(mm, vaddr);
 	if (result == 1)
 		return -EEXIST;
@@ -855,6 +874,10 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 
 		if (is_register) {
 			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
+			/*
+			 * We can race against uprobe_mmap(), see the
+			 * comment near uprobe_hash().
+			 */
 			if (err == -EEXIST)
 				err = 0;
 		} else {
@@ -1063,8 +1086,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
 			}
 
 			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
-
-			/* Ignore double add: */
+			/*
+			 * We can race against uprobe_register(), see the
+			 * comment near uprobe_hash().
+			 */
 			if (ret == -EEXIST) {
 				ret = 0;
 
-- 
1.5.5.1



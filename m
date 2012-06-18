Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2FRIzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:55:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2FRIzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:55:47 -0400
Date: Mon, 18 Jun 2012 01:55:19 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-c5784de2b351fe871bb57487878f7fc7ec5b075c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
In-Reply-To: <20120615154339.GA9591@redhat.com>
References: <20120615154339.GA9591@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Document uprobe_register() vs uprobe_mmap
 () race
Git-Commit-ID: c5784de2b351fe871bb57487878f7fc7ec5b075c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:55:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5784de2b351fe871bb57487878f7fc7ec5b075c
Gitweb:     http://git.kernel.org/tip/c5784de2b351fe871bb57487878f7fc7ec5b075c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 15 Jun 2012 17:43:39 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:45 +0200

uprobes: Document uprobe_register() vs uprobe_mmap() race

Because the mind is treacherous and makes us forget we need to
write stuff down.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120615154339.GA9591@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 897417d..2671d9a 100644
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
 
@@ -339,7 +356,9 @@ out:
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
@@ -845,6 +864,10 @@ static int register_for_each_vma(struct uprobe *uprobe, bool is_register)
 
 		if (is_register) {
 			err = install_breakpoint(uprobe, mm, vma, info->vaddr);
+			/*
+			 * We can race against uprobe_mmap(), see the
+			 * comment near uprobe_hash().
+			 */
 			if (err == -EEXIST)
 				err = 0;
 		} else {
@@ -1054,8 +1077,10 @@ int uprobe_mmap(struct vm_area_struct *vma)
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
 

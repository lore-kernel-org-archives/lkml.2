Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870Ab2EYRHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:07:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933546Ab2EYRDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:03:39 -0400
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
Subject: [PATCH 16/35] autonuma: autonuma_enter/exit
Date: Fri, 25 May 2012 19:02:20 +0200
Message-Id: <1337965359-29725-17-git-send-email-aarcange@redhat.com>
In-Reply-To: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first gear in the whole AutoNUMA algorithm is knuma_scand. If
knuma_scand doesn't run AutoNUMA is a full bypass. If knuma_scand is
stopped, soon all other AutoNUMA gears will settle down too.

knuma_scand is the daemon that sets the pmd_numa and pte_numa and
allows the NUMA hinting page faults to start and then all other
actions follows as a reaction to that.

knuma_scand scans a list of "mm" and this is where we register and
unregister the "mm" into AutoNUMA for knuma_scand to scan them.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 kernel/fork.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 98db8b0..237c34e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -70,6 +70,7 @@
 #include <linux/khugepaged.h>
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
+#include <linux/autonuma.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -539,6 +540,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	if (likely(!mm_alloc_pgd(mm))) {
 		mm->def_flags = 0;
 		mmu_notifier_mm_init(mm);
+		autonuma_enter(mm);
 		return mm;
 	}
 
@@ -607,6 +609,7 @@ void mmput(struct mm_struct *mm)
 		exit_aio(mm);
 		ksm_exit(mm);
 		khugepaged_exit(mm); /* must run before exit_mmap */
+		autonuma_exit(mm); /* must run before exit_mmap */
 		exit_mmap(mm);
 		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {

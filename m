Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab2CZS6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:58:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933315Ab2CZS5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:57:24 -0400
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
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 16/39] autonuma: call autonuma_setup_new_exec()
Date: Mon, 26 Mar 2012 19:46:03 +0200
Message-Id: <1332783986-24195-17-git-send-email-aarcange@redhat.com>
In-Reply-To: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
References: <1332783986-24195-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This resets all per-thread and per-process statistics across exec
syscalls or after kernel threads detached from the mm. The past
statistical NUMA information is unlikely to be relevant for the future
in these cases.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 fs/exec.c        |    3 +++
 mm/mmu_context.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 23559c2..488cc4d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/autonuma.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1175,6 +1176,8 @@ void setup_new_exec(struct linux_binprm * bprm)
 			
 	flush_signal_handlers(current, 0);
 	flush_old_files(current->files);
+
+	autonuma_setup_new_exec(current);
 }
 EXPORT_SYMBOL(setup_new_exec);
 
diff --git a/mm/mmu_context.c b/mm/mmu_context.c
index 3dcfaf4..40f0f13 100644
--- a/mm/mmu_context.c
+++ b/mm/mmu_context.c
@@ -7,6 +7,7 @@
 #include <linux/mmu_context.h>
 #include <linux/export.h>
 #include <linux/sched.h>
+#include <linux/autonuma.h>
 
 #include <asm/mmu_context.h>
 
@@ -58,5 +59,6 @@ void unuse_mm(struct mm_struct *mm)
 	/* active_mm is still 'mm' */
 	enter_lazy_tlb(mm, tsk);
 	task_unlock(tsk);
+	autonuma_setup_new_exec(tsk);
 }
 EXPORT_SYMBOL_GPL(unuse_mm);

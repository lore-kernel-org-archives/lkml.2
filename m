Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2F1M6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755515Ab2F1M6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:58:04 -0400
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
Subject: [PATCH 18/40] autonuma: call autonuma_setup_new_exec()
Date: Thu, 28 Jun 2012 14:55:58 +0200
Message-Id: <1340888180-15355-19-git-send-email-aarcange@redhat.com>
In-Reply-To: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>
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
index da27b91..146ced2 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -55,6 +55,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/compat.h>
+#include <linux/autonuma.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1172,6 +1173,8 @@ void setup_new_exec(struct linux_binprm * bprm)
 			
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

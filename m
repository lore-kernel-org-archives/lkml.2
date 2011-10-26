Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1JZVjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:39:37 -0400
Received: from toro.web-alm.net ([62.245.132.31]:59414 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1JZVjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:39:33 -0400
X-Greylist: delayed 1313 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Oct 2011 17:39:31 EDT
Message-Id: <20111026211708.768925506@osadl.org>
User-Agent: quilt/0.48-1
Date: Wed, 26 Oct 2011 23:14:16 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <C.Emde@osadl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 1/1] Set the command name of the idle tasks in SMP kernels v3
References: <20111026211415.787299186@osadl.org>
Content-Disposition: inline; filename=kernel-sched-smp-set-idletask-comm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In UP systems, the idle task is initialized using the init_task
structure from which the command name is taken (currently "swapper").

In SMP systems, one idle task per CPU is forked by the worker thread
from which the task structure is copied. The command name is, therefore,
"kworker/0:0" or "kworker/0:1", if not updated. Since such update was
lacking, all idle tasks in SMP systems were incorrectly named. This
longtime bug was not discovered immediately, because there is no /proc/0
entry - the bug only becomes apparent when tracing is enabled.

This patch sets the command name of the idle tasks in SMP systems to the
name that is used in the INIT_TASK structure suffixed by a slash and the
number of the CPU.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 include/linux/init_task.h |    3 ++-
 kernel/sched.c            |    4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-3.0.7-rt20/include/linux/init_task.h
===================================================================
--- linux-3.0.7-rt20.orig/include/linux/init_task.h
+++ linux-3.0.7-rt20/include/linux/init_task.h
@@ -132,6 +132,7 @@ extern struct cred init_cred;
 # define INIT_TIMER_LIST
 #endif
 
+#define INIT_TASK_COMM "swapper"
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -168,7 +169,7 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
-	.comm		= "swapper",					\
+	.comm		= INIT_TASK_COMM,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
Index: linux-3.0.7-rt20/kernel/sched.c
===================================================================
--- linux-3.0.7-rt20.orig/kernel/sched.c
+++ linux-3.0.7-rt20/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/init_task.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -6104,6 +6105,9 @@ void __cpuinit init_idle(struct task_str
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
+#if defined(CONFIG_SMP)
+	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+#endif
 }
 
 /*


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab1KRXbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:31:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab1KRXbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:31:47 -0500
Date: Fri, 18 Nov 2011 15:31:27 -0800
From: tip-bot for Carsten Emde <C.Emde@osadl.org>
Message-ID: <tip-f1c6f1a7eed963ed233ba4c8b6fa8addb86c6ddc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, C.Emde@osadl.org,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, C.Emde@osadl.org,
        mingo@elte.hu
In-Reply-To: <20111026211708.768925506@osadl.org>
References: <20111026211708.768925506@osadl.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Set the command name of the idle tasks in SMP kernels
Git-Commit-ID: f1c6f1a7eed963ed233ba4c8b6fa8addb86c6ddc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:31:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1c6f1a7eed963ed233ba4c8b6fa8addb86c6ddc
Gitweb:     http://git.kernel.org/tip/f1c6f1a7eed963ed233ba4c8b6fa8addb86c6ddc
Author:     Carsten Emde <C.Emde@osadl.org>
AuthorDate: Wed, 26 Oct 2011 23:14:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Nov 2011 12:50:43 +0100

sched: Set the command name of the idle tasks in SMP kernels

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111026211708.768925506@osadl.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/init_task.h |    4 +++-
 kernel/sched.c            |    4 ++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 08ffab0..b6e5b8b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -126,6 +126,8 @@ extern struct cred init_cred;
 # define INIT_PERF_EVENTS(tsk)
 #endif
 
+#define INIT_TASK_COMM "swapper"
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -162,7 +164,7 @@ extern struct cred init_cred;
 	.group_leader	= &tsk,						\
 	RCU_INIT_POINTER(.real_cred, &init_cred),			\
 	RCU_INIT_POINTER(.cred, &init_cred),				\
-	.comm		= "swapper",					\
+	.comm		= INIT_TASK_COMM,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
diff --git a/kernel/sched.c b/kernel/sched.c
index 3d2c436..d6b149c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/init_task.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -6112,6 +6113,9 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	 */
 	idle->sched_class = &idle_sched_class;
 	ftrace_graph_init_idle_task(idle, cpu);
+#if defined(CONFIG_SMP)
+	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+#endif
 }
 
 /*

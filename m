Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1KOU2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:28:52 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42025 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab1KOU2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:28:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/9] sched: add is_idle_task() to handle invalidated uses of idle_cpu()
Date: Tue, 15 Nov 2011 12:28:00 -0800
Message-Id: <1321388885-11211-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-5930-0000-0000-000001AB37D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Commit 908a3283 (Fix idle_cpu()) invalidated some uses of idle_cpu(),
which used to say whether or not the CPU was running the idle task,
but now instead says whether or not the CPU is running the idle task
in the absence of pending wakeups.  Although this new implementation
gives a better answer to the question "is this CPU idle?", it also
invalidates other uses that were made of idle_cpu().

This commit therefore introduces a new is_idle_task() API member
that determines whether or not the specified task is one of the
idle tasks, allowing open-coded "->pid == 0" sequences to be replaced
by something more meaningful.

Suggested-by: Josh Triplett <josh@joshtriplett.org>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 68daf4f..4b1077b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2071,6 +2071,7 @@ extern int sched_setscheduler(struct task_struct *, int,
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
 extern struct task_struct *idle_task(int cpu);
+extern int is_idle_task(struct task_struct *p);
 extern struct task_struct *curr_task(int cpu);
 extern void set_curr_task(int cpu, struct task_struct *p);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 0e9344a..c9c1bb3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5185,6 +5185,15 @@ struct task_struct *idle_task(int cpu)
 }
 
 /**
+ * is_idle_task - is the specified task an idle task?
+ * @tsk: the task in question.
+ */
+int is_idle_task(struct task_struct *p)
+{
+	return p->pid == 0;
+}
+
+/**
  * find_process_by_pid - find a process with a matching PID value.
  * @pid: the pid in question.
  */
-- 
1.7.3.2


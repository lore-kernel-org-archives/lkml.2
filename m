Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab0IOKFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:05:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:39967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0IOKEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:04:45 -0400
Date: Wed, 15 Sep 2010 10:03:50 GMT
From: tip-bot for Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, will.deacon@arm.com, a.p.zijlstra@chello.nl,
        matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com, rostedt@goodmis.org,
        tglx@linutronix.de, mingo@elte.hu, greenrd@greenrd.org,
        prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, matthltc@us.ibm.com, mahesh@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, prasad@linux.vnet.ibm.com,
        greenrd@greenrd.org, mingo@elte.hu
In-Reply-To: <a134e5e392ab0204961fd1a62c84a222bf5874a9.1284407763.git.matthltc@us.ibm.com>
References: <a134e5e392ab0204961fd1a62c84a222bf5874a9.1284407763.git.matthltc@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf events: Clean up pid passing
Message-ID: <tip-38a81da2205f94e8a2a834b51a6b99c91fc7c2e8@git.kernel.org>
Git-Commit-ID: 38a81da2205f94e8a2a834b51a6b99c91fc7c2e8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:03:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38a81da2205f94e8a2a834b51a6b99c91fc7c2e8
Gitweb:     http://git.kernel.org/tip/38a81da2205f94e8a2a834b51a6b99c91fc7c2e8
Author:     Matt Helsley <matthltc@us.ibm.com>
AuthorDate: Mon, 13 Sep 2010 13:01:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:00 +0200

perf events: Clean up pid passing

The kernel perf event creation path shouldn't use find_task_by_vpid()
because a vpid exists in a specific namespace. find_task_by_vpid() uses
current's pid namespace which isn't always the correct namespace to use
for the vpid in all the places perf_event_create_kernel_counter() (and
thus find_get_context()) is called.

The goal is to clean up pid namespace handling and prevent bugs like:

	https://bugzilla.kernel.org/show_bug.cgi?id=17281

Instead of using pids switch find_get_context() to use task struct
pointers directly. The syscall is responsible for resolving the pid to
a task struct. This moves the pid namespace resolution into the syscall
much like every other syscall that takes pid parameters.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robin Green <greenrd@greenrd.org>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
LKML-Reference: <a134e5e392ab0204961fd1a62c84a222bf5874a9.1284407763.git.matthltc@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/oprofile/common.c |    2 +-
 include/linux/perf_event.h |    2 +-
 kernel/hw_breakpoint.c     |    5 ++---
 kernel/perf_event.c        |   21 ++++++++++-----------
 kernel/watchdog.c          |    2 +-
 5 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..aad63e6 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -96,7 +96,7 @@ static int op_create_counter(int cpu, int event)
 		return ret;
 
 	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
-						  cpu, -1,
+						  cpu, NULL,
 						  op_overflow_handler);
 
 	if (IS_ERR(pevent)) {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 93bf53a..39d8860 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -902,7 +902,7 @@ extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr,
 				int cpu,
-				pid_t pid,
+				struct task_struct *task,
 				perf_overflow_handler_t callback);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 6122f02..3b714e8 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -433,8 +433,7 @@ register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)
 {
-	return perf_event_create_kernel_counter(attr, -1, task_pid_vnr(tsk),
-						triggered);
+	return perf_event_create_kernel_counter(attr, -1, tsk, triggered);
 }
 EXPORT_SYMBOL_GPL(register_user_hw_breakpoint);
 
@@ -516,7 +515,7 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
 		pevent = per_cpu_ptr(cpu_events, cpu);
-		bp = perf_event_create_kernel_counter(attr, cpu, -1, triggered);
+		bp = perf_event_create_kernel_counter(attr, cpu, NULL, triggered);
 
 		*pevent = bp;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 3f5309d..86f394e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2053,15 +2053,14 @@ errout:
 }
 
 static struct perf_event_context *
-find_get_context(struct pmu *pmu, pid_t pid, int cpu)
+find_get_context(struct pmu *pmu, struct task_struct *task, int cpu)
 {
 	struct perf_event_context *ctx;
 	struct perf_cpu_context *cpuctx;
-	struct task_struct *task;
 	unsigned long flags;
 	int ctxn, err;
 
-	if (pid == -1 && cpu != -1) {
+	if (!task && cpu != -1) {
 		/* Must be root to operate on a CPU event: */
 		if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
 			return ERR_PTR(-EACCES);
@@ -2084,10 +2083,6 @@ find_get_context(struct pmu *pmu, pid_t pid, int cpu)
 		return ctx;
 	}
 
-	task = find_lively_task_by_vpid(pid);
-	if (IS_ERR(task))
-		return (void*)task;
-
 	err = -EINVAL;
 	ctxn = pmu->task_ctx_nr;
 	if (ctxn < 0)
@@ -5527,6 +5522,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct perf_event_context *ctx;
 	struct file *event_file = NULL;
 	struct file *group_file = NULL;
+	struct task_struct *task = NULL;
 	struct pmu *pmu;
 	int event_fd;
 	int fput_needed = 0;
@@ -5581,10 +5577,13 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((pmu->task_ctx_nr == perf_sw_context) && group_leader)
 		pmu = group_leader->pmu;
 
+	if (pid != -1)
+		task = find_lively_task_by_vpid(pid);
+
 	/*
 	 * Get the target context (task or percpu):
 	 */
-	ctx = find_get_context(pmu, pid, cpu);
+	ctx = find_get_context(pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_group_fd;
@@ -5666,11 +5665,11 @@ err_fd:
  *
  * @attr: attributes of the counter to create
  * @cpu: cpu in which the counter is bound
- * @pid: task to profile
+ * @task: task to profile (NULL for percpu)
  */
 struct perf_event *
 perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
-				 pid_t pid,
+				 struct task_struct *task,
 				 perf_overflow_handler_t overflow_handler)
 {
 	struct perf_event_context *ctx;
@@ -5687,7 +5686,7 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err;
 	}
 
-	ctx = find_get_context(event->pmu, pid, cpu);
+	ctx = find_get_context(event->pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_free;
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 89eadbb..dc8e168 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -358,7 +358,7 @@ static int watchdog_nmi_enable(int cpu)
 	/* Try to register using hardware perf events */
 	wd_attr = &wd_hw_attr;
 	wd_attr->sample_period = hw_nmi_get_sample_period();
-	event = perf_event_create_kernel_counter(wd_attr, cpu, -1, watchdog_overflow_callback);
+	event = perf_event_create_kernel_counter(wd_attr, cpu, NULL, watchdog_overflow_callback);
 	if (!IS_ERR(event)) {
 		printk(KERN_INFO "NMI watchdog enabled, takes one hw-pmu counter.\n");
 		goto out_save;

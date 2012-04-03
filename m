Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2DCWlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:41:01 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57283 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2DCWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:41:00 -0400
Date: Wed, 4 Apr 2012 00:40:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120403224055.GA5338@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 7b8e6da46b921d30ac1553cac56d8fb74f0b431d perf/x86/p4: Add format attributes

 Thanks,

	Ingo

------------------>
Oleg Nesterov (1):
      tracing, sched, vfs: Fix 'old_pid' usage in trace_sched_process_exec()

Peter Zijlstra (1):
      perf/x86/p4: Add format attributes


 arch/x86/kernel/cpu/perf_event_p4.c |   13 +++++++++++++
 fs/exec.c                           |    7 ++++---
 include/trace/events/sched.h        |    2 +-
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ef484d9..a2dfacf 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1271,6 +1271,17 @@ done:
 	return num ? -EINVAL : 0;
 }
 
+PMU_FORMAT_ATTR(cccr, "config:0-31" );
+PMU_FORMAT_ATTR(escr, "config:32-62");
+PMU_FORMAT_ATTR(ht,   "config:63"   );
+
+static struct attribute *intel_p4_formats_attr[] = {
+	&format_attr_cccr.attr,
+	&format_attr_escr.attr,
+	&format_attr_ht.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu p4_pmu = {
 	.name			= "Netburst P4/Xeon",
 	.handle_irq		= p4_pmu_handle_irq,
@@ -1305,6 +1316,8 @@ static __initconst const struct x86_pmu p4_pmu = {
 	 * the former idea is taken from OProfile code
 	 */
 	.perfctr_second_write	= 1,
+
+	.format_attrs		= intel_p4_formats_attr,
 };
 
 __init int p4_pmu_init(void)
diff --git a/fs/exec.c b/fs/exec.c
index 23559c2..644f6c4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1370,7 +1370,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 	unsigned int depth = bprm->recursion_depth;
 	int try,retval;
 	struct linux_binfmt *fmt;
-	pid_t old_pid;
+	pid_t old_pid, old_vpid;
 
 	retval = security_bprm_check(bprm);
 	if (retval)
@@ -1381,8 +1381,9 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 		return retval;
 
 	/* Need to fetch pid before load_binary changes it */
+	old_pid = current->pid;
 	rcu_read_lock();
-	old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
+	old_vpid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));
 	rcu_read_unlock();
 
 	retval = -ENOENT;
@@ -1405,7 +1406,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
 			if (retval >= 0) {
 				if (depth == 0) {
 					trace_sched_process_exec(current, old_pid, bprm);
-					ptrace_event(PTRACE_EVENT_EXEC, old_pid);
+					ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
 				}
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index fbc7b1a..ea7a203 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -295,7 +295,7 @@ TRACE_EVENT(sched_process_exec,
 	TP_fast_assign(
 		__assign_str(filename, bprm->filename);
 		__entry->pid		= p->pid;
-		__entry->old_pid	= p->pid;
+		__entry->old_pid	= old_pid;
 	),
 
 	TP_printk("filename=%s pid=%d old_pid=%d", __get_str(filename),

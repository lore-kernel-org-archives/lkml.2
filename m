Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0GDUZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 16:25:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56991 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757960Ab0GDUZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 16:25:18 -0400
Date: Sun, 4 Jul 2010 22:24:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100704202453.GA32531@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0033]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      x86: Send a SIGTRAP for user icebp traps

Gui Jianfeng (1):
      perf tools: Fix find tids routine by excluding "." and ".."

Vince Weaver (1):
      perf, x86: Fix incorrect branches event on AMD CPUs


 arch/x86/kernel/cpu/perf_event_amd.c |    4 ++--
 arch/x86/kernel/traps.c              |   11 ++++++++++-
 tools/perf/util/thread.c             |   11 ++++++++++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 611df11..c2897b7 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -102,8 +102,8 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
   [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0080,
   [PERF_COUNT_HW_CACHE_MISSES]		= 0x0081,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c2,
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c3,
 };
 
 static u64 amd_pmu_event_map(int hw_event)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 142d70c..725ef4d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -526,6 +526,7 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *eregs)
 dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 {
 	struct task_struct *tsk = current;
+	int user_icebp = 0;
 	unsigned long dr6;
 	int si_code;
 
@@ -534,6 +535,14 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 	/* Filter out all the reserved bits which are preset to 1 */
 	dr6 &= ~DR6_RESERVED;
 
+	/*
+	 * If dr6 has no reason to give us about the origin of this trap,
+	 * then it's very likely the result of an icebp/int01 trap.
+	 * User wants a sigtrap for that.
+	 */
+	if (!dr6 && user_mode(regs))
+		user_icebp = 1;
+
 	/* Catch kmemcheck conditions first of all! */
 	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
 		return;
@@ -575,7 +584,7 @@ dotraplinkage void __kprobes do_debug(struct pt_regs *regs, long error_code)
 		regs->flags &= ~X86_EFLAGS_TF;
 	}
 	si_code = get_si_code(tsk->thread.debugreg6);
-	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS))
+	if (tsk->thread.debugreg6 & (DR_STEP | DR_TRAP_BITS) || user_icebp)
 		send_sigtrap(tsk, regs, error_code, si_code);
 	preempt_conditional_cli(regs);
 
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 1f7ecd4..9a448b4 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,6 +7,15 @@
 #include "util.h"
 #include "debug.h"
 
+/* Skip "." and ".." directories */
+static int filter(const struct dirent *dir)
+{
+	if (dir->d_name[0] == '.')
+		return 0;
+	else
+		return 1;
+}
+
 int find_all_tid(int pid, pid_t ** all_tid)
 {
 	char name[256];
@@ -16,7 +25,7 @@ int find_all_tid(int pid, pid_t ** all_tid)
 	int i;
 
 	sprintf(name, "/proc/%d/task", pid);
-	items = scandir(name, &namelist, NULL, NULL);
+	items = scandir(name, &namelist, filter, NULL);
 	if (items <= 0)
                 return -ENOENT;
 	*all_tid = malloc(sizeof(pid_t) * items);


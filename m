Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab0EKTSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:18:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42628 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab0EKTSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:18:44 -0400
Date: Tue, 11 May 2010 21:18:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100511191807.GA12035@elte.hu>
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
	[score: 0.0000]
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
      perf: Fix static strings treated like dynamic ones

Masami Hiramatsu (1):
      kprobes/x86: Fix removed int3 checking order


 arch/x86/kernel/kprobes.c           |   27 +++++++++++++--------------
 tools/perf/util/trace-event-parse.c |    2 +-
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index b43bbae..1658efd 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -534,20 +534,6 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb;
 
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
-	if (*addr != BREAKPOINT_INSTRUCTION) {
-		/*
-		 * The breakpoint instruction was removed right
-		 * after we hit it.  Another cpu has removed
-		 * either a probepoint or a debugger breakpoint
-		 * at this address.  In either case, no further
-		 * handling of this interrupt is appropriate.
-		 * Back up over the (now missing) int3 and run
-		 * the original instruction.
-		 */
-		regs->ip = (unsigned long)addr;
-		return 1;
-	}
-
 	/*
 	 * We don't want to be preempted for the entire
 	 * duration of kprobe processing. We conditionally
@@ -579,6 +565,19 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 				setup_singlestep(p, regs, kcb, 0);
 			return 1;
 		}
+	} else if (*addr != BREAKPOINT_INSTRUCTION) {
+		/*
+		 * The breakpoint instruction was removed right
+		 * after we hit it.  Another cpu has removed
+		 * either a probepoint or a debugger breakpoint
+		 * at this address.  In either case, no further
+		 * handling of this interrupt is appropriate.
+		 * Back up over the (now missing) int3 and run
+		 * the original instruction.
+		 */
+		regs->ip = (unsigned long)addr;
+		preempt_enable_no_resched();
+		return 1;
 	} else if (kprobe_running()) {
 		p = __get_cpu_var(current_kprobe);
 		if (p->break_handler && p->break_handler(p, regs)) {
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 9b3c20f..613c9cc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1925,7 +1925,7 @@ void *raw_field_ptr(struct event *event, const char *name, void *data)
 	if (!field)
 		return NULL;
 
-	if (field->flags & FIELD_IS_STRING) {
+	if (field->flags & FIELD_IS_DYNAMIC) {
 		int offset;
 
 		offset = *(int *)(data + field->offset);

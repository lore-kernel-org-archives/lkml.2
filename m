Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0EHLc0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:32:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:57491 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab0EHLcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:32:24 -0400
Date: Sat, 8 May 2010 11:30:38 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       ananth@in.ibm.com, anderson@redhat.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       anderson@redhat.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100427223348.2322.9112.stgit@localhost6.localdomain6>
References: <20100427223348.2322.9112.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes/x86: Fix removed int3 checking order
Message-ID: <tip-51a66680aa450c81a1f31570700b6ade4886c841@git.kernel.org>
Git-Commit-ID: 51a66680aa450c81a1f31570700b6ade4886c841
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 08 May 2010 11:30:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  51a66680aa450c81a1f31570700b6ade4886c841
Gitweb:     http://git.kernel.org/tip/51a66680aa450c81a1f31570700b6ade4886c841
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Apr 2010 18:33:49 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 May 2010 13:19:29 +0200

kprobes/x86: Fix removed int3 checking order

Fix kprobe/x86 to check removed int3 when failing to get kprobe
from hlist. Since we have a time window between checking int3
exists on probed address and getting kprobe on that address,
we can have following scenario:

 -------
 CPU1                     CPU2
 hit int3
 check int3 exists
                          remove int3
                          remove kprobe from hlist
 get kprobe from hlist
 no kprobe->OOPS!
 -------

This patch moves int3 checking if there is no kprobe on that
address for fixing this problem as follows:

 ------
 CPU1                     CPU2
 hit int3
                          remove int3
                          remove kprobe from hlist
 get kprobe from hlist
 no kprobe->check int3 exists
          ->rollback&retry
 ------

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100427223348.2322.9112.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

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

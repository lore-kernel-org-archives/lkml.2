Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0D0W20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 18:28:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab0D0W2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 18:28:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] [BUGFIX] kprobes/x86: Fix removed int3 checking order
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Dave Anderson <anderson@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 27 Apr 2010 18:33:49 -0400
Message-ID: <20100427223348.2322.9112.stgit@localhost6.localdomain6>
In-Reply-To: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
References: <20100427223312.2322.60512.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix kprobe/x86 to check removed int3 when failing to get kprobe
from hlist. Since we have a time window between checking int3
exists on probed address and getting kprobe on that address,
we can have following senario.
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
address for fixing this problem as follows;
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
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Dave Anderson <anderson@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/kprobes.c |   27 +++++++++++++--------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index f2f56c0..345a4b1 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -542,20 +542,6 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
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
@@ -587,6 +573,19 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
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


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

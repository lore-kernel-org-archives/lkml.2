Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559Ab2JAXYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:24:43 -0400
Received: from 1wt.eu ([62.212.114.60]:35326 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab2JAXBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:16 -0400
Message-Id: <20121001225203.800125652@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 146/180] sparc64: Eliminate obsolete __handle_softirq() function
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

commit 3d3eeb2ef26112a200785e5fca58ec58dd33bf1e upstream.

The invocation of softirq is now handled by irq_exit(), so there is no
need for sparc64 to invoke it on the trap-return path.  In fact, doing so
is a bug because if the trap occurred in the idle loop, this invocation
can result in lockdep-RCU failures.  The problem is that RCU ignores idle
CPUs, and the sparc64 trap-return path to the softirq handlers fails to
tell RCU that the CPU must be considered non-idle while those handlers
are executing.  This means that RCU is ignoring any RCU read-side critical
sections in those handlers, which in turn means that RCU-protected data
can be yanked out from under those read-side critical sections.

The shiny new lockdep-RCU ability to detect RCU read-side critical sections
that RCU is ignoring located this problem.

The fix is straightforward: Make sparc64 stop manually invoking the
softirq handlers.

Reported-by: Meelis Roos <mroos@linux.ee>
Suggested-by: David Miller <davem@davemloft.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/sparc/kernel/rtrap_64.S |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
index fd3cee4..cc4b1ff 100644
--- a/arch/sparc/kernel/rtrap_64.S
+++ b/arch/sparc/kernel/rtrap_64.S
@@ -20,11 +20,6 @@
 
 		.text
 		.align			32
-__handle_softirq:
-		call			do_softirq
-		 nop
-		ba,a,pt			%xcc, __handle_softirq_continue
-		 nop
 __handle_preemption:
 		call			schedule
 		 wrpr			%g0, RTRAP_PSTATE, %pstate
@@ -159,9 +154,7 @@ rtrap:
 		cmp			%l1, 0
 
 		/* mm/ultra.S:xcall_report_regs KNOWS about this load. */
-		bne,pn			%icc, __handle_softirq
 		 ldx			[%sp + PTREGS_OFF + PT_V9_TSTATE], %l1
-__handle_softirq_continue:
 rtrap_xcall:
 		sethi			%hi(0xf << 20), %l4
 		and			%l1, %l4, %l4
-- 
1.7.2.1.45.g54fbc




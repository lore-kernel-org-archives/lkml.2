Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2DSVue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:50:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41811 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933094Ab2DSVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:09:42 -0400
Message-Id: <20120419210612.137028687@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Meelis Roos <mroos@linux.ee>,
        David Miller <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [ 12/59] sparc64: Eliminate obsolete __handle_softirq() function
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

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

---
 arch/sparc/kernel/rtrap_64.S |    7 -------
 1 file changed, 7 deletions(-)

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
@@ -89,9 +84,7 @@ rtrap:
 		cmp			%l1, 0
 
 		/* mm/ultra.S:xcall_report_regs KNOWS about this load. */
-		bne,pn			%icc, __handle_softirq
 		 ldx			[%sp + PTREGS_OFF + PT_V9_TSTATE], %l1
-__handle_softirq_continue:
 rtrap_xcall:
 		sethi			%hi(0xf << 20), %l4
 		and			%l1, %l4, %l4



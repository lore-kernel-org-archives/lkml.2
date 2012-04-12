Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab2DLEyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 00:54:36 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47167 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab2DLEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 00:54:34 -0400
Date: Wed, 11 Apr 2012 21:54:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: shemminger@vyatta.com, mroos@linux.ee, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: suspicious RCU usage warnings in 3.3.0
Message-ID: <20120412045428.GB2497@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120411171004.016ddd95@nehalam.linuxnetplumber.net>
 <20120411.201854.1070083308359208025.davem@davemloft.net>
 <20120412004507.GF2473@linux.vnet.ibm.com>
 <20120411.210843.716144028821174908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411.210843.716144028821174908.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041204-1780-0000-0000-000004B1DDF1
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000266; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00130134; UDB=6.00030735; UTC=2012-04-12
 04:54:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:08:43PM -0400, David Miller wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Date: Wed, 11 Apr 2012 17:45:07 -0700
> 
> > If I am confused about the simple function call, and if control is really
> > passing via an interrupt or exception, then rcu_irq_enter() should be
> > called on entry to the interrupt or exception and rcu_irq_exit() should
> > be called on exit.
> 
> Hmm, it seems the convention changed such that platforms aren't
> supposed to invoke do_softirq() from their trap return trap any more.
> It's handled completely by irq_exit().
> 
> When did that start happening? :-)

Heh!  It appears that git doesn't go back far enough for me to find the
answer to that question.  ;-)

> Anyways I bet that's the problem, sparc64 invokes do_softirq() in it's
> trap return path if softirqs are pending, and that doesn't do any
> of the RCU frobbing you mention.

The following untested patch that probably does not even build is offered
up for your amusement.  I don't know enough about SPARC's needs for
alignment, handling of branch-delay slots, and so on for this to have
any chance of working, but hey!  ;-)

							Thanx, Paul

------------------------------------------------------------------------

sparc64: Eliminate obsolete __handle_softirq() function

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

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 rtrap_64.S |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/arch/sparc/kernel/rtrap_64.S b/arch/sparc/kernel/rtrap_64.S
index 77f1b95..9171fc2 100644
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


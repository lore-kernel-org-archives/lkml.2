Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab2GIRmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:42:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53869 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab2GIRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:42:10 -0400
Date: Mon, 9 Jul 2012 19:42:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] rcu: Settle config for userspace extended quiescent
 state
Message-ID: <20120709174200.GB8185@somewhere.redhat.com>
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-2-git-send-email-fweisbec@gmail.com>
 <20120706163129.GV2522@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706163129.GV2522@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:31:29AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 06, 2012 at 02:00:13PM +0200, Frederic Weisbecker wrote:
> > Create a new config option under the RCU menu that put
> > CPUs under RCU extended quiescent state (as in dynticks
> > idle mode) when they run in userspace. This require
> > some contribution from architectures to hook into kernel
> > and userspace boundaries.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Alessio Igor Bogani <abogani@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Avi Kivity <avi@redhat.com>
> > Cc: Chris Metcalf <cmetcalf@tilera.com>
> > Cc: Christoph Lameter <cl@linux.com>
> > Cc: Geoff Levand <geoff@infradead.org>
> > Cc: Gilad Ben Yossef <gilad@benyossef.com>
> > Cc: Hakan Akkan <hakanakkan@gmail.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: Max Krasnyansky <maxk@qualcomm.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Stephen Hemminger <shemminger@vyatta.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > ---
> >  arch/Kconfig     |   13 +++++++++++++
> >  init/Kconfig     |   10 ++++++++++
> >  kernel/rcutree.c |    4 ++++
> >  3 files changed, 27 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 8c3d957..c2e0ce4 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -274,4 +274,17 @@ config SECCOMP_FILTER
> > 
> >  	  See Documentation/prctl/seccomp_filter.txt for details.
> > 
> > +config HAVE_RCU_USER_QS
> > +	bool
> > +	help
> > +	  Provide kernel entry/exit hooks necessary for userspace
> > +	  RCU extended quiescent state. Syscalls and exceptions
> > +	  low level handlers must be wrapped with a call to rcu_user_exit()
> > +	  on entry and rcu_user_enter() before resuming userspace. Irqs
> > +	  entry don't need to call rcu_user_exit() because their high level
> > +	  handlers are protected inside rcu_irq_enter/rcu_irq_exit() but
> > +	  preemption or signal handling on irq exit still need to be protected
> > +	  with a call to rcu_user_exit(). rcu_user_enter() must then be
> > +	  called back on irq exit when the preempted task is back on the CPU.
> > +
> >  source "kernel/gcov/Kconfig"
> > diff --git a/init/Kconfig b/init/Kconfig
> > index d07dcf9..3a4af8f 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -441,6 +441,16 @@ config PREEMPT_RCU
> >  	  This option enables preemptible-RCU code that is common between
> >  	  the TREE_PREEMPT_RCU and TINY_PREEMPT_RCU implementations.
> > 
> > +config RCU_USER_QS
> > +	bool "Consider userspace as in RCU extended quiescent state"
> > +	depends on HAVE_RCU_USER_QS && SMP
> 
> OK, I'll bite...  Why the "SMP"?  RCU could make good use of knowing
> about user-mode executing even in UP kernels.

Because Tiny RCU doesn't implement rcu_user_enter()/exit yet. And it
doesn't need it for now.

To better express the constraint I should probably have used:

	depends on TREE_RCU || TREE_PREEMPT_RCU

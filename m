Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab1HQCaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:30:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62639 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab1HQCaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:30:08 -0400
Date: Wed, 17 Aug 2011 04:30:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 24/32] nohz/cpuset: Handle kernel entry/exit to account
 cputime
Message-ID: <20110817023000.GD32132@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-25-git-send-email-fweisbec@gmail.com>
 <20110816203820.GI2404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816203820.GI2404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 01:38:20PM -0700, Paul E. McKenney wrote:
> On Mon, Aug 15, 2011 at 05:52:21PM +0200, Frederic Weisbecker wrote:
> > Provide a few APIs that archs can call to tell they are entering
> > or exiting the kernel so that when we are in nohz adaptive mode
> > we know precisely where we need to account the cputime.
> > 
> > The new APIs are:
> > 
> > - tick_nohz_enter_kernel() (called when we enter a syscall)
> > - tick_nohz_exit_kernel() (called when we exit a syscall)
> > - tick_nohz_enter_exception() (called when we enter any
> >   exception, trap, faults...but not irqs)
> > - tick_nohz_exit_exception() (called when we exit any exception)
> > 
> > Hooks into syscalls are typically driven by the TIF_NOHZ thread
> > flag.
> > 
> > In addition, we use the value returned by user_mode(regs) from
> > the timer interrupt to know where we are.
> > Nonetheless, we can rely on user_mode(regs) != 0 to know
> > we are in userspace, but we can't rely on user_mode(regs) == 0
> > to know we are in the system.
> > 
> > Consider the following scenario: we stop the tick after syscall
> > return, so we set TIF_NOHZ but the syscall exit hook is behind us.
> > If we haven't yet returned to userspace, then we have
> > user_mode(regs) == 0. If on top of that we consider we are in
> > system mode, and later we issue a syscall but restart the tick
> > right before reaching the syscall entry hook, then we have no clue
> > that the whole elapsed cputime was not in the system but in the
> > userspace.
> > 
> > The only way to fix this is to only start entering nohz mode once
> > we know we are in userspace a first time, like when we reach the
> > kernel exit hook or when a timer tick with user_mode(regs) == 1
> > fires. Kernel threads don't have this worry.
> > 
> > This sucks but for now I have no better solution. Let's hope we
> > can find better.
> > 
> > TODO: wrap operation on jiffies?
> 
> Hmmm...  Does the RCU dyntick-idle code need to know about exception
> entry and exit?
> 
> 							Thanx, Paul

At that time it doesn't because we don't yet call rcu_enter_nohz()
when switching to userspace. Instead we shutdown the tick and
restart it when needed when a remote CPU sends us an IPI to complete
a grace period.

The patch that switches to extended qs is the 31/32 and it handles
syscalls and exceptions as well.

I wanted to have support on rcu extended quiescent states late
in the patchset so that it's considered as an incremental feature
and not a core piece of the adaptive nohz (ie: it's no mandatory thing,
just an optimization). This way we can use cpuset nohz without that
rcu extended quiescent state feature and hence make that small part
bisectable.

Patch 30 activates support for cpuset nohz (support from x86).
Patch 31 activates the rcu extended quiescent state support in
userspace as a bonus.

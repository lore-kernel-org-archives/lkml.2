Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2IYHKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:10:17 -0400
Received: from ozlabs.org ([203.10.76.45]:49526 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270Ab2IYHKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:10:15 -0400
From: Michael Neuling <mikey@neuling.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: K Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
In-reply-to: <11821.1345240695@neuling.org>
References: <28857.1345091034@neuling.org> <20120817161554.GA3772@somewhere> <11821.1345240695@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Sat, 18 Aug 2012 07:58:15 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.3.1
Date: Tue, 25 Sep 2012 17:10:14 +1000
Message-ID: <29084.1348557014@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> wrote:

> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Aug 16, 2012 at 02:23:54PM +1000, Michael Neuling wrote:
> > > Hi,
> > > 
> > > I've been trying to get hardware breakpoints with perf to work on POWER7
> > > but I'm getting the following:
> > > 
> > >   % perf record -e mem:0x10000000 true
> > > 
> > >     Error: sys_perf_event_open() syscall returned with 28 (No space left on device).  /bin/dmesg may provide additional information.
> > > 
> > >     Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> > > 
> > >   true: Terminated
> > > 
> > > (FWIW adding -a and it works fine)
> > > 
> > > Debugging it seems that __reserve_bp_slot() is returning ENOSPC because
> > > it thinks there are no free breakpoint slots on this CPU.
> > > 
> > > I have a 2 CPUs, so perf userspace is doing two perf_event_open syscalls
> > > to add a counter to each CPU [1].  The first syscall succeeds but the
> > > second is failing.
> > > 
> > > On this second syscall, fetch_bp_busy_slots() sets slots.pinned to be 1,
> > > despite there being no breakpoint on this CPU.  This is because the call
> > > the task_bp_pinned, checks all CPUs, rather than just the current CPU.
> > > POWER7 only has one hardware breakpoint per CPU (ie. HBP_NUM=1), so we
> > > return ENOSPC.
> > > 
> > > The following patch fixes this by checking the associated CPU for each
> > > breakpoint in task_bp_pinned.  I'm not familiar with this code, so it's
> > > provided as a reference to the above issue.
> > > 
> > > Mikey
> > > 
> > > 1. not sure why it doesn't just do one syscall and specify all CPUs, but
> > > that's another issue.  Using two syscalls should work.
> > 
> > This patch seems to make sense. I'll try it and run some tests.
> > Can I have your Signed-off-by ?

Frederic,

Did you ever get to testing or integrating this patch?

Mikey

> Of course...
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2FORh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:37:29 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37972 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab2FORh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:37:28 -0400
Date: Fri, 15 Jun 2012 19:37:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck,Tony" <tony.luck@intel.com>
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
Message-ID: <20120615173713.GA23238@somewhere.redhat.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
 <1339664829.2559.14.camel@twins>
 <20120614111241.GA16848@somewhere>
 <20120614111638.GA16676@gmail.com>
 <alpine.LFD.2.02.1206141321010.3086@ionos>
 <20120614112241.GB16848@somewhere>
 <20120614144815.1401af49@de.ibm.com>
 <20120614134238.GD16848@somewhere>
 <20120614171800.72f02152@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614171800.72f02152@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 05:18:00PM +0200, Martin Schwidefsky wrote:
> On Thu, 14 Jun 2012 15:42:44 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Thu, Jun 14, 2012 at 02:48:15PM +0200, Martin Schwidefsky wrote:
> > > On Thu, 14 Jun 2012 13:22:45 +0200
> > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > On Thu, Jun 14, 2012 at 01:21:23PM +0200, Thomas Gleixner wrote:
> > > > > On Thu, 14 Jun 2012, Ingo Molnar wrote:
> > > > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > > > You're right, I should have looked into CONFIG_VIRT_CPU_ACCOUNTING sooner
> > > > > > > and see if I can reuse it.
> > > > > > > 
> > > > > > > I'll try something with that.
> > > > > > 
> > > > > > Maybe sanitize all the variants under a single set of 
> > > > > > wrappers/callbacks?
> > > > > 
> > > > > Yes, please!
> > > > 
> > > > Sure, I'm working in it.
> > >  
> > > Please keep me in the loop, I want to avoid that things break on s390. Thanks.
> > 
> > Do you have any idea why s390 counts idle time from asm deep in the idle code
> > rather than just hooking in account_system_vtime() like ppc or ia64?
>  
> Well what is idle time? For s390 it is the difference in the TOD clock between
> the instruction that loaded the enabled-wait-PSW and the first instruction on
> the interrupt handler. To get the best precision you need to get the TOD time
> stamps as close to these two instructions as possible. For s390 it is the
> following sequence:
> 
>         STCK    __IDLE_ENTER(%r2)	# idle enter time stamp
>         ltr     %r5,%r5
>         stpt    __VQ_IDLE_ENTER(%r3)
>         jz      psw_idle_lpsw
>         spt     0(%r1)
> psw_idle_lpsw:
>         lpswe   __SF_EMPTY(%r15)
> 
> <<< sleeping >>>
> 
> int_handler:
>         STCK    __LC_INT_CLOCK		# idle exit time stamp
> 
> There are at maximum 5 instructions between the STCK for the idle
> enter time stamp and the lpswe that puts the cpu to sleep.

I see. So s390 accounts only the time spent in low power mode whereas
ppc/ia64 accounts everything that happens in the idle task.

I don't know which one has chosen the right semantics but this complicates
any possible unification.

BTW, aren't you accounting the idle time as system time as well with
account_sys_vtime()?

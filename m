Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2FNPSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:18:13 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:50747 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab2FNPSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:18:10 -0400
Date: Thu, 14 Jun 2012 17:18:00 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20120614171800.72f02152@de.ibm.com>
In-Reply-To: <20120614134238.GD16848@somewhere>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
	<1339664829.2559.14.camel@twins>
	<20120614111241.GA16848@somewhere>
	<20120614111638.GA16676@gmail.com>
	<alpine.LFD.2.02.1206141321010.3086@ionos>
	<20120614112241.GB16848@somewhere>
	<20120614144815.1401af49@de.ibm.com>
	<20120614134238.GD16848@somewhere>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12061415-1948-0000-0000-000002181265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 15:42:44 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Jun 14, 2012 at 02:48:15PM +0200, Martin Schwidefsky wrote:
> > On Thu, 14 Jun 2012 13:22:45 +0200
> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > On Thu, Jun 14, 2012 at 01:21:23PM +0200, Thomas Gleixner wrote:
> > > > On Thu, 14 Jun 2012, Ingo Molnar wrote:
> > > > > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > > You're right, I should have looked into CONFIG_VIRT_CPU_ACCOUNTING sooner
> > > > > > and see if I can reuse it.
> > > > > > 
> > > > > > I'll try something with that.
> > > > > 
> > > > > Maybe sanitize all the variants under a single set of 
> > > > > wrappers/callbacks?
> > > > 
> > > > Yes, please!
> > > 
> > > Sure, I'm working in it.
> >  
> > Please keep me in the loop, I want to avoid that things break on s390. Thanks.
> 
> Do you have any idea why s390 counts idle time from asm deep in the idle code
> rather than just hooking in account_system_vtime() like ppc or ia64?
 
Well what is idle time? For s390 it is the difference in the TOD clock between
the instruction that loaded the enabled-wait-PSW and the first instruction on
the interrupt handler. To get the best precision you need to get the TOD time
stamps as close to these two instructions as possible. For s390 it is the
following sequence:

        STCK    __IDLE_ENTER(%r2)	# idle enter time stamp
        ltr     %r5,%r5
        stpt    __VQ_IDLE_ENTER(%r3)
        jz      psw_idle_lpsw
        spt     0(%r1)
psw_idle_lpsw:
        lpswe   __SF_EMPTY(%r15)

<<< sleeping >>>

int_handler:
        STCK    __LC_INT_CLOCK		# idle exit time stamp

There are at maximum 5 instructions between the STCK for the idle
enter time stamp and the lpswe that puts the cpu to sleep.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.


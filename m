Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438Ab2C1LUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:20:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:57723 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab2C1LUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:20:41 -0400
Date: Wed, 28 Mar 2012 13:20:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: Re: [PATCH 21/32] nohz/cpuset: Flush cputime on threads in nohz
 cpusets when waiting leader
Message-ID: <20120328112030.GA17189@somewhere.redhat.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-23-git-send-email-fweisbec@gmail.com>
 <CAOtvUMegNxbb4OHRo6cB3EWT6R0F0rpzZAd8d=pxoHjehSCgKw@mail.gmail.com>
 <CAOtvUMdUuBhPZ3FARn+daOM3fYRxwTVBhOOBXKZo6KzOOioPUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOtvUMdUuBhPZ3FARn+daOM3fYRxwTVBhOOBXKZo6KzOOioPUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 04:23:14PM +0200, Gilad Ben-Yossef wrote:
> On Tue, Mar 27, 2012 at 4:10 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> > On Wed, Mar 21, 2012 at 3:58 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> When we wait for a zombie task, flush the cputimes on nohz cpusets
> >> in case we are waiting for a group leader that has threads running
> >> in nohz CPUs. This way thread_group_times() doesn't report stale
> >> values.
> >>
> >> <doubts>
> >> If I understood well the code, by the time we call that thread_group_times(),
> >> we may have childs that are still running, so this is necessary.
> >> But I need to check deeper.
> >> </doubts>
> >>
> > ...
> >>
> >> diff --git a/kernel/exit.c b/kernel/exit.c
> >> index 4b4042f..c194662 100644
> >> --- a/kernel/exit.c
> >> +++ b/kernel/exit.c
> >> @@ -52,6 +52,7 @@
> >>  #include <linux/hw_breakpoint.h>
> >>  #include <linux/oom.h>
> >>  #include <linux/writeback.h>
> >> +#include <linux/cpuset.h>
> >>
> >>  #include <asm/uaccess.h>
> >>  #include <asm/unistd.h>
> >> @@ -1712,6 +1713,13 @@ repeat:
> >>           (!wo->wo_pid || hlist_empty(&wo->wo_pid->tasks[wo->wo_type])))
> >>                goto notask;
> >>
> >> +       /*
> >> +        * For cputime in sub-threads before adding them.
> >> +        * Must be called outside tasklist_lock lock because write lock
> >> +        * can be acquired under irqs disabled.
> >> +        */
> >> +       cpuset_nohz_flush_cputimes();
> >> +
> >>        set_current_state(TASK_INTERRUPTIBLE);
> >>        read_lock(&tasklist_lock);
> >>        tsk = current;
> >> --
> >> 1.7.5.4
> >>
> >
> > I believe this patch is not needed because after this point we call
> > do_wait_thread /ptrace_do_wait, which both call wait_consider_task,
> > which calls wait_task_stopped/zombie/continued, which all eventually
> > calls getrusage, which calls k_getrusage where you added a call to
> > cpuset_noz_flush_cputimes() in another patch :-)
> >
> 
> OK, I now see that wait_task_zombie actually calls
> thread_group_times() directly, unlike other wait_task_*
> what I wrote above is not needed.
> 
> It does result in more then one IPI for each isolated core (something
> like 3 really) for the other cases though:
> one from this patch and the rest from the one in k_getrusage calls.

Yeah I realize we may be calling getrusage() from each of the wait_*()
things if the user request the rusage. That plus the IPI done in this
patch this is too much.

> 
> I wonder what would be a better way to do it. In theory we can send
> the IPI only to nohz cpuset cores that actually
> run tasks form the thread group. Finding which is not trivial though...

I also realize that we only call wait_task_zombie() on group leaders
if they don't have any subthread left (see delay_group_leader() test).
But then we call thread_group_times() to get the time of all threads
in the group from wait_task_zombie().

Now I'm confused.

> 
> Gilad
> 
> > Gilad
> >
> > --
> > Gilad Ben-Yossef
> > Chief Coffee Drinker
> > gilad@benyossef.com
> > Israel Cell: +972-52-8260388
> > US Cell: +1-973-8260388
> > http://benyossef.com
> >
> > "If you take a class in large-scale robotics, can you end up in a
> > situation where the homework eats your dog?"
> >  -- Jean-Baptiste Queru
> 
> 
> 
> -- 
> Gilad Ben-Yossef
> Chief Coffee Drinker
> gilad@benyossef.com
> Israel Cell: +972-52-8260388
> US Cell: +1-973-8260388
> http://benyossef.com
> 
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru

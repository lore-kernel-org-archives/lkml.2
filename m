Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1DMOfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:35:12 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39040 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756484Ab1DMOfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:35:10 -0400
Subject: Re: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task
 breakpoints
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
In-Reply-To: <20110412175437.GC2240@nowhere>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
	 <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
	 <1302518877.24286.34.camel@e102144-lin.cambridge.arm.com>
	 <20110412175437.GC2240@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 15:34:18 +0100
Message-ID: <1302705258.4214.11.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Tue, 2011-04-12 at 18:54 +0100, Frederic Weisbecker wrote:
> > On Fri, 2011-04-08 at 18:34 +0100, Frederic Weisbecker wrote:
> > > When a task is traced and is in a stopped state, the tracer
> > > may execute a ptrace request to examine the tracee state and
> > > get its task struct. Right after, the tracee can be killed
> > > and thus its breakpoints released.
> > > This can happen concurrently when the tracer is in the middle
> > > of reading or modifying these breakpoints, leading to dereferencing
> > > a freed pointer.
> >
> > Oo, that's nasty. Would an alternative solution be to free the
> > breakpoints only when the task_struct usage count is zero?
> 
> Yeah my solution may look a bit gross. But the problem is
> that perf events hold a ref on their task context. Thus the
> task_struct usage will never be 0 until you release all the
> perf events attached to it.

Blimey, that explains the complications!

> Normal perf events are released in two ways in the exit path:
> 
> - explicitly if they are inherited
> - from the file release path if they are a parent
> 
> Now breakpoints are a bit specific because neither are they inherited,
> nor do they have a file associated.
> 
> So we need to release them explicitly to release the task. And after that
> we also need to ensure nobody will play with the breakpoints, otherwise there
> will be a memory leak because those will never be freed.
> 
> So that patch protects against concurrent release of the breakpoints and
> also against the possible memory leak.

Agreed.

> May be we can think about a solution that involves not taking a ref
> to the task when we allocate breakpoints, and then finally release
> from the task_struct rcu release. But that may involve many corner
> cases. Perhaps we can think about this later and for now opt for the
> current solution that looks safe and without surprise. This fix needs
> to be backported so it should stay KISS I think.

Avoiding taking the ref still means handling breakpoints specially so I
don't think you win much. I was just intrigued by your original patch.

> > > diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> > > index 0fc1eed..dc7ab65 100644
> > > --- a/kernel/ptrace.c
> > > +++ b/kernel/ptrace.c
> > > @@ -22,6 +22,7 @@
> > >  #include <linux/syscalls.h>
> > >  #include <linux/uaccess.h>
> > >  #include <linux/regset.h>
> > > +#include <linux/hw_breakpoint.h>
> > >
> > >
> > >  /*
> > > @@ -879,3 +880,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
> > >         return ret;
> > >  }
> > >  #endif /* CONFIG_COMPAT */
> > > +
> > > +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> > > +int ptrace_get_breakpoints(struct task_struct *tsk)
> > > +{
> > > +       if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
> > > +               return 0;
> > > +
> > > +       return -1;
> > > +}
> >
> >
> > Would it be better to return -ESRCH here instead?
> 
> So I'm going to be nitpicking there :)
> The ptrace_get_breakpoints() function tells us whether
> we can take a ref on the breakpoints or not.
> 
> Returning -ERSCH there would mean that the task struct doesn't exist,
> or something confusing like this. Which is not true: the task exists.

Sure, we need a way of saying `you can't take a reference to the
breakpoints for this task' without specifying why. So I guess -ESRCH is
wrong but I don't know that -1 is correct either (then again, I'm not
*too* bothered by it :).

> OTOH, the caller, which is ptrace, needs to take a decision when he
> can't take a reference to the breakpoints. The behaviour is
> to act as if the process does not exist anymore, which is about to
> happen for real but we anticipate because the task has reached a
> state in its exiting path where we can't manipulate the breakpoints
> anymore.
> 
> So the rationale behind it is that -ERSCH is an interpretation
> of the caller.
> 
> Right?

Yup.

For this and the ARM patch:

Acked-by: Will Deacon <will.deacon@arm.com>

Will


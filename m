Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab1DLRys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:54:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38489 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab1DLRyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:54:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Smv36kyptAYXlpHOkgzDtsfNEldZ6qev9yBmgIYIBumHlzkpnm8l68AvweRr1wKUDl
         BEpu0cgV/6WaQL3WWM+G+0D5P3yiTA6KrNknvLvF9y3DJMU29kz5Cw+xtPM2n2jNRYnj
         itO6GlUZnHCi3qJNDmEaznwvoyxDIdAiVFyfI=
Date: Tue, 12 Apr 2011 19:54:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "v2.6.33.." <stable@kernel.org>
Subject: Re: [PATCH 1/5] ptrace: Prepare to fix racy accesses on task
 breakpoints
Message-ID: <20110412175437.GC2240@nowhere>
References: <1302284067-7860-1-git-send-email-fweisbec@gmail.com>
 <1302284067-7860-2-git-send-email-fweisbec@gmail.com>
 <1302518877.24286.34.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302518877.24286.34.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:47:57AM +0100, Will Deacon wrote:
> Hi Frederic,
> 
> On Fri, 2011-04-08 at 18:34 +0100, Frederic Weisbecker wrote:
> > When a task is traced and is in a stopped state, the tracer
> > may execute a ptrace request to examine the tracee state and
> > get its task struct. Right after, the tracee can be killed
> > and thus its breakpoints released.
> > This can happen concurrently when the tracer is in the middle
> > of reading or modifying these breakpoints, leading to dereferencing
> > a freed pointer.
> 
> Oo, that's nasty. Would an alternative solution be to free the
> breakpoints only when the task_struct usage count is zero?

Yeah my solution may look a bit gross. But the problem is
that perf events hold a ref on their task context. Thus the
task_struct usage will never be 0 until you release all the
perf events attached to it.

Normal perf events are released in two ways in the exit path:

- explicitly if they are inherited
- from the file release path if they are a parent

Now breakpoints are a bit specific because neither are they inherited,
nor do they have a file associated.

So we need to release them explicitly to release the task. And after that
we also need to ensure nobody will play with the breakpoints, otherwise there
will be a memory leak because those will never be freed.

So that patch protects against concurrent release of the breakpoints and
also against the possible memory leak.

May be we can think about a solution that involves not taking a ref
to the task when we allocate breakpoints, and then finally release
from the task_struct rcu release. But that may involve many corner
cases. Perhaps we can think about this later and for now opt for the
current solution that looks safe and without surprise. This fix needs
to be backported so it should stay KISS I think.

 
> > diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> > index 0fc1eed..dc7ab65 100644
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/syscalls.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/regset.h>
> > +#include <linux/hw_breakpoint.h>
> > 
> > 
> >  /*
> > @@ -879,3 +880,19 @@ asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
> >         return ret;
> >  }
> >  #endif /* CONFIG_COMPAT */
> > +
> > +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> > +int ptrace_get_breakpoints(struct task_struct *tsk)
> > +{
> > +       if (atomic_inc_not_zero(&tsk->ptrace_bp_refcnt))
> > +               return 0;
> > +
> > +       return -1;
> > +}
> 
> 
> Would it be better to return -ESRCH here instead?

So I'm going to be nitpicking there :)
The ptrace_get_breakpoints() function tells us whether
we can take a ref on the breakpoints or not.

Returning -ERSCH there would mean that the task struct doesn't exist,
or something confusing like this. Which is not true: the task exists.

OTOH, the caller, which is ptrace, needs to take a decision when he
can't take a reference to the breakpoints. The behaviour is
to act as if the process does not exist anymore, which is about to
happen for real but we anticipate because the task has reached a
state in its exiting path where we can't manipulate the breakpoints
anymore.

So the rationale behind it is that -ERSCH is an interpretation
of the caller.

Right?

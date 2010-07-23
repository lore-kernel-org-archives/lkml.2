Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab0GWInr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 04:43:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:32169 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0GWIno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:43:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,246,1278313200"; 
   d="scan'208";a="538083971"
Subject: Re: [PATCH] Don't apply for write lock on tasklist_lock if parent
 doesn't ptrace other processes
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        stable@kernel.org
In-Reply-To: <20100722090524.GA6647@redhat.com>
References: <1279176663.2096.1264.camel@ymzhang.sh.intel.com>
	 <20100721144944.5351c741.akpm@linux-foundation.org>
	 <20100721222529.EFBAA400B6@magilla.sf.frob.com>
	 <20100722090524.GA6647@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 23 Jul 2010 16:45:05 +0800
Message-Id: <1279874705.2096.1274.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 11:05 +0200, Oleg Nesterov wrote:
> I am not surpized perf blaims tasklist, but I am really surpized this patch
> adds 10% improvement...
I changed aim7 workfile to focus on fork/exec and other a couple of sub-cases.
And this behavior is clear on 8-socket machines. 

> 
> On 07/21, Roland McGrath wrote:
> >
> > > > @@ -331,6 +331,9 @@ void exit_ptrace(struct task_struct *tra
> > > >  	struct task_struct *p, *n;
> > > >  	LIST_HEAD(ptrace_dead);
> > > >
> > > > +	if (list_empty(&tracer->ptraced))
> > > > +		return;
> > > > +
> > > >  	write_lock_irq(&tasklist_lock);
> > > >  	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
> > > >  		if (__ptrace_detach(tracer, p))
> >
> > I think we may have tried that before.  Oleg can tell us if it's really
> > safe vs a race with PTRACE_TRACEME or something like that.
> 
> Yes, this can race with ptrace_traceme(). Without tasklist_lock in
> exit_ptrace(), it is possible that ptrace_traceme() starts __ptrace_link()
> before it sees PF_EXITING, and completes before the result of list_add()
> is visible to the exiting parent. tasklist acts as a barrier.
Thanks for your kind explanation.

> 
> So, this list_empty() check needs taskslit at least for reading. But, we
> are going to take it for writing right after exit_ptrace() returns, afaics
> we can add this fastpatch check for free.
> 
> Uncompiled/untested.
> 
> Oleg.
> 
>  kernel/ptrace.c |   10 +++++++---
>  kernel/exit.c   |    3 ++-
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> --- x/kernel/ptrace.c
> +++ x/kernel/ptrace.c
> @@ -324,26 +324,30 @@ int ptrace_detach(struct task_struct *ch
>  }
>  
>  /*
> - * Detach all tasks we were using ptrace on.
> + * Detach all tasks we were using ptrace on. Called with tasklist held.
>   */
>  void exit_ptrace(struct task_struct *tracer)
>  {
>  	struct task_struct *p, *n;
>  	LIST_HEAD(ptrace_dead);
>  
> -	write_lock_irq(&tasklist_lock);
> +	if (likely(list_empty(&tracer->ptraced)))
> +		return;
> +
>  	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
>  		if (__ptrace_detach(tracer, p))
>  			list_add(&p->ptrace_entry, &ptrace_dead);
>  	}
> -	write_unlock_irq(&tasklist_lock);
>  
> +	write_unlock_irq(&tasklist_lock);
>  	BUG_ON(!list_empty(&tracer->ptraced));
>  
>  	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
>  		list_del_init(&p->ptrace_entry);
>  		release_task(p);
>  	}
> +
> +	write_lock_irq(&tasklist_lock);
>  }
>  
>  int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
> --- x/kernel/exit.c
> +++ x/kernel/exit.c
> @@ -771,9 +771,10 @@ static void forget_original_parent(struc
After applying my patch (although it's incorrect as there is a race with TRACEME),
perf shows write_lock_irq in forget_original_parent consumes less than 40% cpu time on
8-socket machine.

Is it possible to optimize it to use finer locks instead of the global tasklist_lock?


>  	struct task_struct *p, *n, *reaper;
>  	LIST_HEAD(dead_children);
>  
> +	write_lock_irq(&tasklist_lock);
> +
>  	exit_ptrace(father);
>  
> -	write_lock_irq(&tasklist_lock);
>  	reaper = find_new_reaper(father);
>  
>  	list_for_each_entry_safe(p, n, &father->children, sibling) {
> 



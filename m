Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2AFMoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:44:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45215 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2AFMoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:44:12 -0500
Message-ID: <1325853838.2442.18.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Fri, 06 Jan 2012 13:43:58 +0100
In-Reply-To: <20120106210108.AB18.E1E9C6FF@jp.fujitsu.com>
References: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com>
	 <1325847671.2442.7.camel@twins>
	 <20120106210108.AB18.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-06 at 21:01 +0900, Yasunori Goto wrote:

> Do you mean the following patch?

Yes, something like that. At that point ->state should be TASK_RUNNING
(since we are after all running). The unlock_wait() will synchronize
against any in-progress ttwu() while its fast path is a non-atomic
compare. Any ttwu after this will bail since it will either observe
TASK_RUNNING or TASK_DEAD, neither are a state it will act upon.

Now the only question that remains is if we need the full memory barrier
or if we can get away with less.

I guess the mb separates the write to ->state (setting TASK_RUNNING)
from the read of ->pi_lock. The remote CPU must see the TASK_RUNNING,
and we must see ->pi_lock taken if it is.

I also can't find anything to 'borrow' a barrier from (well I can for
mainline, but not for -rt).

So yes, I guess the below will do, albeit it needs a somewhat
comprehensive comment explaining its need.

Oleg, can you agree?

> ---
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> ---
>  kernel/exit.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-3.2-rc7/kernel/exit.c
> ===================================================================
> --- linux-3.2-rc7.orig/kernel/exit.c
> +++ linux-3.2-rc7/kernel/exit.c
> @@ -1038,6 +1038,10 @@ NORET_TYPE void do_exit(long code)
>  
>  	preempt_disable();
>  	exit_rcu();
> +
> +	smp_mb();
> +	raw_spin_unlock_wait(&tsk->pi_lock);
> +
>  	/* causes final put_task_struct in finish_task_switch(). */
>  	tsk->state = TASK_DEAD;
>  	schedule();
> 
> 


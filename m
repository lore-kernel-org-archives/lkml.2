Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab2APNiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:38:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55301 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2APNiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:38:11 -0500
Message-ID: <1326721082.2442.234.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jan 2012 14:38:02 +0100
In-Reply-To: <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
References: <20120106141258.GB19462@redhat.com>
	 <20120107103059.BF5F.E1E9C6FF@jp.fujitsu.com>
	 <20120116205140.6120.E1E9C6FF@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 20:51 +0900, Yasunori Goto wrote:

> try_to_wake_up() has a problem which may change status from TASK_DEAD to
> TASK_RUNNING in race condition with SMI or guest environment of virtual
> machine. (See: https://lkml.org/lkml/2011/12/21/523)
> As a result, exited task is scheduled() again and panic occurs.
> 
> By this patch, do_exit() waits for releasing task->pi_lock which is used
> in try_to_wake_up(). It guarantees the task becomes TASK_DEAD after
> waking up.


This Changelog isn't very good. Please spell out the problem instead of
referring to it so that people using git-blame and the like don't then
have to go look up some (possibly non-existent) web-resource.

> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> ---
>  kernel/exit.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-3.2/kernel/exit.c
> ===================================================================
> --- linux-3.2.orig/kernel/exit.c
> +++ linux-3.2/kernel/exit.c
> @@ -1038,6 +1038,14 @@ NORET_TYPE void do_exit(long code)
>  
>  	preempt_disable();
>  	exit_rcu();
> +
> +	/*
> +	 * try_to_wake_up() might be waking me up due to race condition.
> +	 * Make sure it is finished.
> +	 */

That comment is waaaay too terse. What race and what must be finished?

> +	smp_mb();
> +	raw_spin_unlock_wait(&tsk->pi_lock);
> +
>  	/* causes final put_task_struct in finish_task_switch(). */
>  	tsk->state = TASK_DEAD;
>  	schedule();
> 


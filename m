Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab2AFOTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:19:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab2AFOTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:19:03 -0500
Date: Fri, 6 Jan 2012 15:12:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Motohiro Kosaki <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special
	condition
Message-ID: <20120106141258.GB19462@redhat.com>
References: <20120106192256.AB15.E1E9C6FF@jp.fujitsu.com> <1325847671.2442.7.camel@twins> <20120106210108.AB18.E1E9C6FF@jp.fujitsu.com> <1325853838.2442.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325853838.2442.18.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06, Peter Zijlstra wrote:
>
> On Fri, 2012-01-06 at 21:01 +0900, Yasunori Goto wrote:
>
> > Do you mean the following patch?
>
> Yes, something like that. At that point ->state should be TASK_RUNNING
> (since we are after all running). The unlock_wait() will synchronize
> against any in-progress ttwu() while its fast path is a non-atomic
> compare. Any ttwu after this will bail since it will either observe
> TASK_RUNNING or TASK_DEAD, neither are a state it will act upon.
>
> Now the only question that remains is if we need the full memory barrier
> or if we can get away with less.
>
> I guess the mb separates the write to ->state (setting TASK_RUNNING)
> from the read of ->pi_lock. The remote CPU must see the TASK_RUNNING,
> and we must see ->pi_lock taken if it is.

Yes, I think we need the full mb, STORE vs LOAD.

> > --- linux-3.2-rc7.orig/kernel/exit.c
> > +++ linux-3.2-rc7/kernel/exit.c
> > @@ -1038,6 +1038,10 @@ NORET_TYPE void do_exit(long code)
> >
> >  	preempt_disable();
> >  	exit_rcu();
> > +
> > +	smp_mb();
> > +	raw_spin_unlock_wait(&tsk->pi_lock);
> > +
> >  	/* causes final put_task_struct in finish_task_switch(). */
> >  	tsk->state = TASK_DEAD;

Interesting. Initially I thought this is wrong and we should do

	raw_spin_unlock_wait(pi_lock);

	mb();

	tsk->state = TASK_DEAD;

This "obviously" serializes LOAD(pi_lock) and STORE(state).

But when I re-read your explanation above I think you are right,
mb() before unlock_wait() should work too, just it refers to
state = RUNNING in the past.

But this makes me worry. We are doing a lot of things after
exit_mm(). In particular we take tasklist_lock in exit_notify()
and then do_exit() takes task_lock(). But every unlock + lock
implies mb(). So how it was possible to hit this bug???

Oleg.


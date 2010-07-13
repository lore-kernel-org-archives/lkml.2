Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GMK3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:29:13 -0400
Received: from www.tglx.de ([62.245.132.106]:43108 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942Ab0GMK3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:29:11 -0400
Date: Tue, 13 Jul 2010 12:28:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH][RT] futex: protect against pi_blocked_on corruption
 during requeue PI
In-Reply-To: <alpine.LFD.2.00.1007131041230.3321@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1007131222430.3321@localhost.localdomain>
References: <1278478019.10245.77.camel@marge.simson.net> <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain> <4C3C1DCF.9090509@us.ibm.com> <alpine.LFD.2.00.1007131041230.3321@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Thomas Gleixner wrote:
> On Tue, 13 Jul 2010, Darren Hart wrote:
>
> > --- a/kernel/rtmutex.c
> > +++ b/kernel/rtmutex.c
> > @@ -227,7 +227,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
> >  	 * reached or the state of the chain has changed while we
> >  	 * dropped the locks.
> >  	 */
> > -	if (!waiter || !waiter->task)
> > +	if (!waiter || (long)waiter == PI_WAKEUP_INPROGRESS || !waiter->task)
> >  		goto out_unlock_pi;
> 
>  Why do we need that check ? Either the requeue succeeded then
>  task->pi_blocked_on is set to the real waiter or the wakeup won and
>  we are in no lock chain.
> 
>  If we ever find a waiter with PI_WAKEUP_INPROGRESS set in
>  rt_mutex_adjust_prio_chain() then it's a bug nothing else.

Grrr, I'm wrong. If we take hb->lock in the fast path then something
else might try to boost us and trip over this :(

This code causes braindamage. I really wonder whether we need to
remove it according to the "United Nations Convention against Torture
and Other Cruel, Inhuman or Degrading Treatment or Punishment".

> > @@ -6377,7 +6379,8 @@ void task_setprio(struct task_struct *p, int prio)
> >  	 */
> >  	if (unlikely(p == rq->idle)) {
> >  		WARN_ON(p != rq->curr);
> > -		WARN_ON(p->pi_blocked_on);
> > +		WARN_ON(p->pi_blocked_on &&
> > +		        (long)p->pi_blocked_on != PI_WAKEUP_INPROGRESS);
> 
>   Yuck. Paranoia ? If we ever requeue idle, then .....

  At least one which is bogus :)
 
Thanks,

	tglx

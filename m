Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab0LTXuB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 18:50:01 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:54729 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab0LTXt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 18:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Id25CM3ZWFZsybXJY7PF3p6OmWXE7aB9RVF/xtAuCcE7//fkKX1PQIqoVdhJbMVvPt
         UiEYjDYS4IgfkOKeiDex2Th7qgxG+h/r6w2x4s17LWvFJIEJTaRDl8qS1OWaF98h22wQ
         +CchA98NsDN8bdSwDBy9/tF8yO9oEjr2+tzuA=
Date: Tue, 21 Dec 2010 00:49:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 06/15] nohz_task: Keep the tick if rcu needs it
Message-ID: <20101220234934.GD1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-7-git-send-email-fweisbec@gmail.com>
 <1292860700.5021.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292860700.5021.14.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:58:20PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> 
> > @@ -1634,7 +1633,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
> >   * by the current CPU, returning 1 if so.  This function is part of the
> >   * RCU implementation; it is -not- an exported member of the RCU API.
> >   */
> > -static int rcu_pending(int cpu)
> > +int rcu_pending(int cpu)
> 
> /me wonders about that comment.

Yeah I'll need to update that.
 
> >  {
> >  	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
> >  	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 6dbae46..45bd6e2 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2470,10 +2470,16 @@ static void nohz_task_cpu_update(void *unused)
> >  int nohz_task_can_stop_tick(void)
> >  {
> >  	struct rq *rq = this_rq();
> > +	int cpu;
> >  
> >  	if (rq->nr_running > 1)
> >  		return 0;
> >  
> > +	cpu = smp_processor_id();
> > +
> > +	if (rcu_pending(cpu) || rcu_needs_cpu(cpu))
> > +		return 0;
> 
> Arguable, rcu_needs_cpu() should imply rcu_pending(), because if there's
> work still to be done, it needs the cpu, hmm?

We certainly need to change the naming there.

rcu_needs_cpu() checks if we need to do something with the local callbacks.
rcu_pending() checks if we the current CPU needs to notify quiescent states
because a new grace period has started.

So now that rcu_pending() is exported we probably need to refine the naming.
rcu_callbacks_pending() and rcu_grace_period_pending(), or something like
this.


> >  	return 1;
> >  }
> >  
> 
> This patch also implies you broke stuff with #4 because it would put the
> machine to sleep while RCU still had bits to do, not very nice.

Nope, the new config can only be built after [RFC PATCH 11/15] x86: Nohz task support

I know I split up the patches in some unusual way but I did that on purpose:
I wanted to have a finegrained patchset so that it's more reviewable than a big
"core support" - "arch support" dual patch based style.

But I ensured the new config can not be enabled before it's entirely buildable
and has no known bugs.

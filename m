Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab1C3TyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:54:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab1C3TyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:54:18 -0400
Date: Wed, 30 Mar 2011 21:53:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RFC] perf: panic due to inclied cpu context task_ctx
	value
Message-ID: <20110330195354.GA15046@redhat.com>
References: <20110326173545.GA22919@redhat.com> <1301164168.2250.370.camel@laptop> <20110328133033.GA8254@redhat.com> <1301324275.4859.25.camel@twins> <1301327368.4859.28.camel@twins> <20110328165648.GA9304@redhat.com> <20110330130951.GA2124@jolsa.brq.redhat.com> <1301496684.4859.192.camel@twins> <20110330163730.GA6038@redhat.com> <20110330183049.GK2255@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330183049.GK2255@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30, Paul E. McKenney wrote:
>
> On Wed, Mar 30, 2011 at 06:37:30PM +0200, Oleg Nesterov wrote:
> >
> > So. synchronize_sched() above should ensure that all CPUs do context
> > switch at least once (ignoring idle). And I _thought_ that in practice
> > this should work.
> >
> > But, unles I misread the comment above synchronize_sched(), it seems that
> > it only guarantees the end of "everything" which disables preemption,
> > explicitly or not. IOW, say, in theory rcu_read_unlock_sched() could
> > trigger ->passed_quiesc == T without reschedule.
>
> For rcu_read_lock() in preemptible RCU, this is true.

Hmm, not sure I understand... Do you mean that with the current
implementation rcu_read_unlock() can imply rcu_sched_qs() without
rescheduling ?

> But for
> rcu_read_unlock_sched(), the only way rcu_note_context_switch() is called
> is if the code is preempted, which ends up calling schedule().

Indeed, that is why I thought synchronize_sched() can help in this
case. I meant, according to the documentation it could in theory.

But,

> > Oh, and this is not theoretical, afaics. run_ksoftirqd() does
> > rcu_note_context_switch().
>
> Interesting...  Color me confused.
>
> Suppose the rcu_note_context_switch() in run_ksoftirqd() was replaced
> with schedule().  This has to be OK, right?  But schedule() itself
> invokes rcu_note_context_switch().  So if it is OK to call schedule(),
> it should be OK to call rcu_note_context_switch() directly, right?
>
> So, what am I missing here?

It is me, not you.

Damn. It is even worse than I thought. Somehow I missed the simple
fact, schedule() does not necessarily mean context_switch(). So the
idea to use synchronize_sched() was simply wrong. Sorry to all for
wasting your time ;)



> > So, I think we need something else :/
>
> The thing that I would be more concerned about is the idle loop.
> If a CPU is in the idle loop, then rcu_sched_qs() will be invoked
> (and which is invoked by rcu_note_context_switch()).  So is it
> illegal to use the above in the idle loop?

Not sure I understand what you mean, but the idle loop is fine.
An idle thread can't have the counters attached, we don't care
about them.


Thanks Paul,

Oleg.


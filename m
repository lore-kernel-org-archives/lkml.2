Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0CVOWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:22:17 -0400
Received: from mail.openrapids.net ([64.15.138.104]:33893 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753900Ab0CVOWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:22:15 -0400
Date: Mon, 22 Mar 2010 10:22:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [RFC patch 2/3] tree/tiny rcu: Add debug RCU head objects (v3)
Message-ID: <20100322142211.GA32453@Krystal>
References: <20100319204739.574593298@efficios.com> <20100319205233.474028085@efficios.com> <4BA6E515.4040001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA6E515.4040001@cn.fujitsu.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:03:16 up 58 days, 16:40,  6 users,  load average: 1.01, 1.05,
	1.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Very nice you do not touch struct rcu_head.
> 
> Mathieu Desnoyers wrote:
> 
> > +
> > +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> > +# define STATE_RCU_HEAD_READY	0
> > +# define STATE_RCU_HEAD_QUEUED	1
> > +
> > +extern struct debug_obj_descr rcuhead_debug_descr;
> > +
> > +static inline void debug_rcu_head_queue(struct rcu_head *head)
> > +{
> > +	debug_object_activate(head, &rcuhead_debug_descr);
> > +	debug_object_active_state(head, &rcuhead_debug_descr,
> > +				  STATE_RCU_HEAD_READY,
> > +				  STATE_RCU_HEAD_QUEUED);
> > +}
> > +
> > +static inline void debug_rcu_head_unqueue(struct rcu_head *head)
> > +{
> > +	debug_object_active_state(head, &rcuhead_debug_descr,
> > +				  STATE_RCU_HEAD_QUEUED,
> > +				  STATE_RCU_HEAD_READY);
> > +	debug_object_deactivate(head, &rcuhead_debug_descr);
> > +}
> 
> I'm a little foolish. I don't know why we need
> STATE_RCU_HEAD_READY/QUEUED.
> 
> 1) obj->astate does not be set to STATE_RCU_HEAD_READY in
> debug_object_activate/init().

Yes it is. astate is set to 0 upon activation, and STATE_RCU_HEAD_READY is 0.
This is the initial state of the state machine (and also the accepting state).
Maybe I could document it a little bit more. Will write:

+/*
+ * Active state:
+ * - Set at 0 upon initialization.
+ * - Must return to 0 before deactivation.
+ */
+extern void
+debug_object_active_state(void *addr, struct debug_obj_descr *descr,
+                         unsigned int expect, unsigned int next);
+


> 
> Maybe you need to add a function:
> debug_object_activate_with_astate(head, descr, init_astate);
> (the same as debug_object_activate(), but init obj->astate also)
> 
> Or you need:
> @debugobjects.h
> # define DEBUG_OBJECT_ASTATE_INIT 0
> @rcupdate.c
> # define STATE_RCU_HEAD_READY	DEBUG_OBJECT_ASTATE_INIT
> # define STATE_RCU_HEAD_QUEUED	(STATE_RCU_HEAD_READY + 1)
> 
> 2) In debug_rcu_head_queue(), debug_object_active_state()
>    is always success when debug_object_activate() is success.
> 
>    In debug_rcu_head_unqueue(), debug_object_active_state()
>    is always success if RCU subsystem is running correctly.
> 
> (Correct me if I'm wrong) So we don't need debug_object_active_state()
> here if we just find racy users of call_rcu().

Yes, but this debug infrastructure also detects problems that may arise in the
RCU subsystem itself: e.g. a rcu head that would be executed on two CPUs, which
could be caused by races between cpu hotplug and the RCU subsystem. I'm not
saying that we have these races currently, but that the RCU subsystems is now so
tied to complex parts of the kernel (scheduler, cpu hotplug) that it's bound to
have nasty bugs eventually.

So without the state machine, what we don't have in debugobjects is the ability
to detect a second "deactivation": debugobjects considers that an object can be
deactivated more than once without error. But in this case, just one
deactivation should be allowed. I thought that this state machine scheme would
allow following an object life more closely than just the
init/activate/deactivate/destroy/free phases. Maybe there could be ways to
combine the calls ? But.. given that it's for debugging purposes, do we care
that much about performance that it's worth creating new API members, making the
API more obscure ?


> 
> > + */
> > +static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
> > +{
> > +	struct rcu_head *head = addr;
> > +
> > +	switch (state) {
> > +	case ODEBUG_STATE_ACTIVE:
> > +		/*
> > +		 * Ensure that queued callbacks are all executed.
> > +		 * If we detect that we are nested in a RCU read-side critical
> > +		 * section, we should simply fail, otherwise we would deadlock.
> > +		 */
> > +		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
> > +		    irqs_disabled()) {
> > +			WARN_ON(1);
> > +			return 0;
> > +		}
> 
> preempt_count() != 0 ??? What happen when !CONFIG_PREEMPT?

Will change for:

#ifndef CONFIG_PREEMPT
                WARN_ON(1);
                return 0;
#else
                if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
                    irqs_disabled()) {
                        WARN_ON(1);
                        return 0;
                }
                rcu_barrier();
                rcu_barrier_sched();
                rcu_barrier_bh();
                debug_object_activate(head, &rcuhead_debug_descr);
                return 1;
#endif

> 
> > +		rcu_barrier();
> 
> We may need call rcu_barrier(), rcu_barrier_sched(), rcu_barrier_bh() together?
> rcu_barrier() does not ensure to flush callbacks of RCU_BH, RCU_SCHED.

Right, will do.

Thanks,

Mathieu


> 
> > +		debug_object_init(head, &rcuhead_debug_descr);
> > +		return 1;
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0CVDdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:33:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61929 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab0CVDdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:33:38 -0400
Message-ID: <4BA6E515.4040001@cn.fujitsu.com>
Date: Mon, 22 Mar 2010 11:33:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [RFC patch 2/3] tree/tiny rcu: Add debug RCU head objects (v3)
References: <20100319204739.574593298@efficios.com> <20100319205233.474028085@efficios.com>
In-Reply-To: <20100319205233.474028085@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very nice you do not touch struct rcu_head.

Mathieu Desnoyers wrote:

> +
> +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> +# define STATE_RCU_HEAD_READY	0
> +# define STATE_RCU_HEAD_QUEUED	1
> +
> +extern struct debug_obj_descr rcuhead_debug_descr;
> +
> +static inline void debug_rcu_head_queue(struct rcu_head *head)
> +{
> +	debug_object_activate(head, &rcuhead_debug_descr);
> +	debug_object_active_state(head, &rcuhead_debug_descr,
> +				  STATE_RCU_HEAD_READY,
> +				  STATE_RCU_HEAD_QUEUED);
> +}
> +
> +static inline void debug_rcu_head_unqueue(struct rcu_head *head)
> +{
> +	debug_object_active_state(head, &rcuhead_debug_descr,
> +				  STATE_RCU_HEAD_QUEUED,
> +				  STATE_RCU_HEAD_READY);
> +	debug_object_deactivate(head, &rcuhead_debug_descr);
> +}

I'm a little foolish. I don't know why we need
STATE_RCU_HEAD_READY/QUEUED.

1) obj->astate does not be set to STATE_RCU_HEAD_READY in
debug_object_activate/init().

Maybe you need to add a function:
debug_object_activate_with_astate(head, descr, init_astate);
(the same as debug_object_activate(), but init obj->astate also)

Or you need:
@debugobjects.h
# define DEBUG_OBJECT_ASTATE_INIT 0
@rcupdate.c
# define STATE_RCU_HEAD_READY	DEBUG_OBJECT_ASTATE_INIT
# define STATE_RCU_HEAD_QUEUED	(STATE_RCU_HEAD_READY + 1)

2) In debug_rcu_head_queue(), debug_object_active_state()
   is always success when debug_object_activate() is success.

   In debug_rcu_head_unqueue(), debug_object_active_state()
   is always success if RCU subsystem is running correctly.

(Correct me if I'm wrong) So we don't need debug_object_active_state()
here if we just find racy users of call_rcu().

> + */
> +static int rcuhead_fixup_init(void *addr, enum debug_obj_state state)
> +{
> +	struct rcu_head *head = addr;
> +
> +	switch (state) {
> +	case ODEBUG_STATE_ACTIVE:
> +		/*
> +		 * Ensure that queued callbacks are all executed.
> +		 * If we detect that we are nested in a RCU read-side critical
> +		 * section, we should simply fail, otherwise we would deadlock.
> +		 */
> +		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
> +		    irqs_disabled()) {
> +			WARN_ON(1);
> +			return 0;
> +		}

preempt_count() != 0 ??? What happen when !CONFIG_PREEMPT?

> +		rcu_barrier();

We may need call rcu_barrier(), rcu_barrier_sched(), rcu_barrier_bh() together?
rcu_barrier() does not ensure to flush callbacks of RCU_BH, RCU_SCHED.

> +		debug_object_init(head, &rcuhead_debug_descr);
> +		return 1;
> +	default:
> +		return 0;
> +	}
> +}
> +


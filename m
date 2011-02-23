Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1BWCoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:44:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab1BWCo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:44:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b+CdBiu2h8gLz4NN2H68o3SvDqUTSmWgrQtbQvqQjmdkQdYzbVHfRWUbuGW2YcQ0zb
         X7gLxgGiDRIWgKX71TM89Yqd0L8rQyYtfmQuXq5YnoCkdxye8iZ7u+7vcAwcQjmTU7ZZ
         i1s+JRxPGyJoJg5DxB2SJ6koyeqTBodQTyeMs=
Date: Wed, 23 Feb 2011 03:44:24 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110223024420.GA5809@nowhere>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> +static int rcu_node_kthread(void *arg)
> +{
> +	int cpu;
> +	unsigned long flags;
> +	unsigned long mask;
> +	struct rcu_node *rnp = (struct rcu_node *)arg;
> +	struct sched_param sp;
> +	struct task_struct *t;
> +
> +	for (;;) {
> +		wait_event_interruptible(rnp->node_wq, rnp->wakemask != 0 ||
> +						       kthread_should_stop());
> +		if (kthread_should_stop())
> +			break;
> +		raw_spin_lock_irqsave(&rnp->lock, flags);
> +		mask = rnp->wakemask;
> +		rnp->wakemask = 0;
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, mask <<= 1) {

I may be confused, but shouldn't it be mask >>= 1 instead?

rnp->wakemask is the unioned rdp->grpmask of the cpu(s) for which we woke that
node thread up. Those mask start from 0, so what you want with the below
check is to watch if the next CPU in group range is in the wakeup mask by shifting
to the right.

No?

> +			if ((mask & 0x1) == 0)
> +				continue;
> +			preempt_disable();
> +			per_cpu(rcu_cpu_has_work, cpu) = 1;
> +			t = per_cpu(rcu_cpu_kthread_task, cpu);
> +			if (t == NULL) {
> +				preempt_enable();
> +				continue;
> +			}
> +			sp.sched_priority = RCU_KTHREAD_PRIO;
> +			sched_setscheduler_nocheck(t, cpu, &sp);
> +			wake_up_process(t);
> +			preempt_enable();
> +		}
> +	}
> +	return 0;
> +}

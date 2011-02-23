Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1BWQSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:18:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34126 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab1BWQSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:18:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v2djcVQUlH0k1GQuPiMy6UE8UIqylCvS9qoE92WlfiVLTc02TkEGgj5TvKeH8CSA/B
         NvoFDkv0VosTiyfPlqpJgEvue9pkL9luGH7MUvwIatE8K7BZOy4X018iTKSwPcnXBsDC
         qhX/tptGp/5ilL3LhIeSKavkSyTo16UONn/fg=
Date: Wed, 23 Feb 2011 17:16:48 +0100
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
Message-ID: <20110223161645.GA1819@nowhere>
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
> +/*
> + * Wake up the current CPU's kthread.  This replaces raise_softirq()
> + * in earlier versions of RCU.
> + */
> +static void invoke_rcu_kthread(void)
> +{
> +	unsigned long flags;
> +	wait_queue_head_t *q;
> +	int cpu;
> +
> +	local_irq_save(flags);
> +	cpu = smp_processor_id();
> +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
> +		local_irq_restore(flags);
> +		return;
> +	}
> +	per_cpu(rcu_cpu_has_work, cpu) = 1;
> +	q = &per_cpu(rcu_cpu_wq, cpu);

I see you make extensive use of per_cpu() accessors even for
local variables.

I tend to think it's better to use __get_cpu_var() for local
accesses and keep per_cpu() for remote accesses.

There are several reasons for that:

* __get_cpu_var() checks we are in a non-preemptible section,
per_cpu() doesn't. That may sound of a limited interest for code like the
above, but by the time code can move, and then we might lose track of some
things, etc...

* local accesses can be optimized by architectures. per_cpu() implies
finding the local cpu number, and dereference an array of cpu offsets with
that number to find the local cpu offset.
__get_cpu_var() does a direct access to __my_cpu_offset which is a nice
shortcut if the arch implements it.

* It makes code easier to review: we know that __get_cpu_var() is
for local accesses and per_cpu() for remote.

> +	wake_up(q);
> +	local_irq_restore(flags);
> +}

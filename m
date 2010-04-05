Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab0DEREm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 13:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653Ab0DEREf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 13:04:35 -0400
Date: Mon, 5 Apr 2010 18:29:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Sachin Sant <sachinp@in.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Shane Wang <shane.wang@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 2/2] cpuhotplug: make get_online_cpus() scalability by
	using percpu counter
Message-ID: <20100405162901.GA3567@redhat.com>
References: <4BB9BD8A.9040209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB9BD8A.9040209@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05, Lai Jiangshan wrote:
>
> 1) get_online_cpus() must be allowed to be called recursively, so I added
>    get_online_cpus_nest for every task for new code.

Well, iirc one of the goals of

	cpu-hotplug: replace lock_cpu_hotplug() with get_online_cpus()
	86ef5c9a8edd78e6bf92879f32329d89b2d55b5a

was avoiding the new members in task_struct. I leave this up to you
and Gautham.


Lai, I didn't read this patch carefully yet (and I can't apply it to
Linus's tree). But at first glance,

>  void put_online_cpus(void)
>  {
> ...
> +	if (!--current->get_online_cpus_nest) {
> +		preempt_disable();
> +		__get_cpu_var(refcount)--;
> +		if (cpu_hotplug_task)
> +			wake_up_process(cpu_hotplug_task);

This looks unsafe. In theory nothing protects cpu_hotplug_task from
exiting if refcount_sum() becomes zero, this means wake_up_process()
can hit the freed/reused/unmapped task_struct. Probably cpu_hotplug_done()
needs another synhronize_sched() before return.

OTOH, I do not understand why the result of __get_cpu_var(refcount)
must be visible to refcount_sum() if we race with cpu_hotplug_begin(),
so it seems to me cpu_hotplug_begin() also needs synchronize_sched()
before refcount_sum().

Oleg.


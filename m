Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0DIMPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 08:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab0DIMPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 08:15:37 -0400
Date: Fri, 9 Apr 2010 14:12:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Gautham R Shenoy <ego@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nathan Fontenot <nfont@austin.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Sachin Sant <sachinp@in.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Shane Wang <shane.wang@intel.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuhotplug: make get_online_cpus() scalability by
	using percpu counter
Message-ID: <20100409121235.GA5784@redhat.com>
References: <4BB9BD8A.9040209@cn.fujitsu.com> <20100405162901.GA3567@redhat.com> <20100406120039.GC5680@redhat.com> <4BBC8A11.3040501@cn.fujitsu.com> <20100407135456.GA12029@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100407135456.GA12029@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07, Oleg Nesterov wrote:
>
> On 04/07, Lai Jiangshan wrote:
> >
> > Old get_online_cpus() is read-preference, I think the goal of this ability
> > is allow get_online_cpus()/put_online_cpus() to be called nested.
>
> Sure, I understand why you added task_struct->get_online_cpus_nest.
>
> > and use per-task counter for allowing get_online_cpus()/put_online_cpus()
> > to be called nested, I think this deal is absolutely worth.
>
> As I said, I am not going to argue. I can't justify this tradeoff.

But, I must admit, I'd like to avoid adding the new member to task_struct.

What do you think about the code below?

I didn't even try to compile it, just to explain what I mean.

In short: we have the per-cpu fast counters, plus the slow counter
which is only used when cpu_hotplug_begin() is in progress.

Oleg.


static DEFINE_PER_CPU(long, cpuhp_fast_ctr);
static struct task_struct *cpuhp_writer;
static DEFINE_MUTEX(cpuhp_slow_lock)
static long cpuhp_slow_ctr;

static bool update_fast_ctr(int inc)
{
	bool success = true;

	preempt_disable();
	if (likely(!cpuhp_writer))
		__get_cpu_var(cpuhp_fast_ctr) += inc;
	else if (cpuhp_writer != current)
		success = false;
	preempt_enable();

	return success;
}

void get_online_cpus(void)
{
	if (likely(update_fast_ctr(+1));
		return;

	mutex_lock(&cpuhp_slow_lock);
	cpuhp_slow_ctr++;
	mutex_unlock(&cpuhp_slow_lock);
}

void put_online_cpus(void)
{
	if (likely(update_fast_ctr(-1));
		return;

	mutex_lock(&cpuhp_slow_lock);
	if (!--cpuhp_slow_ctr && cpuhp_writer)
		wake_up_process(cpuhp_writer);
	mutex_unlock(&cpuhp_slow_lock);
}

static void clear_fast_ctr(void)
{
	long total = 0;
	int cpu;

	for_each_possible_cpu(cpu) {
		total += per_cpu(cpuhp_fast_ctr, cpu);
		per_cpu(cpuhp_fast_ctr, cpu) = 0;
	}

	return total;
}

static void cpu_hotplug_begin(void)
{
	cpuhp_writer = current;
	synchronize_sched();

	/* Nobody except us can use can use cpuhp_fast_ctr */

	mutex_lock(&cpuhp_slow_lock);
	cpuhp_slow_ctr += clear_fast_ctr();

	while (cpuhp_slow_ctr) {
		__set_current_state(TASK_UNINTERRUPTIBLE);
		mutex_unlock(&&cpuhp_slow_lock);
		schedule();
		mutex_lock(&cpuhp_slow_lock);
	}
}

static void cpu_hotplug_done(void)
{
	cpuhp_writer = NULL;
	mutex_unlock(&cpuhp_slow_lock);
}


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1EGFc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 01:32:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28326 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab1EGFc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 01:32:57 -0400
Message-ID: <4DC4D971.4010002@oracle.com>
Date: Sat, 07 May 2011 00:32:33 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110503 Lightning/1.0b2 OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/UAFCAFCATUAFLAF_1301673577011-962016341 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Chris Mason <chris.mason@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/4] Avoid tick broadcast switch-overs for thread siblings
References: <1304718056-20206-1-git-send-email-andi@firstfloor.org> <1304718056-20206-4-git-send-email-andi@firstfloor.org>
In-Reply-To: <1304718056-20206-4-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DC4D979.00F6:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2011 04:40 PM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> On SMT systems the thread siblings will keep the timer alive
> in any power state. Teach the oneshot broadcast logic about this.
>
> As long as any thread sibling is alive keep using the local timer
> device. When we actually switch over to broadcast we need
> to use the nearest timer expire of all the siblings.
>
> This adds a new "slave" state: a slave is tied to another CPU.
> When the other CPU goes idle too switch over all slaves
> to broadcast timing.
>
> This lowers locking contention on the broadcast lock and
> general overhead.
>
> Signed-off-by: Andi Kleen<ak@linux.intel.com>

This patch causes a 128-cpu system to hang during boot. I've got a busy 
weekend planned, so I might not get a chance to look at this much more 
before Monday.

I tried fixing the problems I found below, but it still doesn't make it 
all the way through the boot, so I'm missing something.

> ---
>   kernel/time/tick-broadcast.c |   97 +++++++++++++++++++++++++++++++++++++++---
>   1 files changed, 90 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 92aba0b..c1587cb 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -358,10 +358,16 @@ int tick_resume_broadcast(void)
>
>   #ifdef CONFIG_TICK_ONESHOT
>
> +/* Lock on the first thread on a core coordinates state */
>   struct broadcast_cpu_state {
> +	int slave;
>   	int need_oneshot;
> +	raw_spinlock_t lock;
>   } ____cacheline_aligned;
> -static DEFINE_PER_CPU(struct broadcast_cpu_state, state);
> +
> +static DEFINE_PER_CPU(struct broadcast_cpu_state, state) = {
> +	.lock = __RAW_SPIN_LOCK_UNLOCKED(lock)
> +};
>
>   /*
>    * Exposed for debugging: see timer_list.c
> @@ -454,6 +460,70 @@ again:
>   	raw_spin_unlock(&tick_broadcast_lock);
>   }
>
> +#define for_each_sibling(i, cpu) for_each_cpu(i, topology_thread_cpumask(cpu))
> +
> +/*
> + * When another thread sibling is alive our timer keeps ticking.
> + * Check for this here because it's much less expensive.
> + * When this happens the current CPU turns into a slave, tied
> + * to the still running CPU. When that also goes idle both
> + * become serviced by the broadcaster.
> + */
> +static int tick_sibling_active(int cpu, ktime_t *timeout, int enter)
> +{
> +	int i, leader;
> +	int running;
> +	ktime_t n;
> +
> +	/*
> + 	 * Exit can be done lockless because unidling
> + 	 * does not affect others.
> + 	 */
> +	if (!enter) {
> +		int was_slave = __get_cpu_var(state).slave;
> +		__get_cpu_var(state).slave = 0;
> +		return was_slave;
> +	}
> +
> +	leader = cpumask_first(topology_thread_cpumask(cpu));
> +	running = 1;

I don't understand this initialization. Won't the following loop 
increment running for the calling cpu? shouldn't it be initialized to 0?

> +	raw_spin_lock(&per_cpu(state, leader).lock);
> +	for_each_sibling(i, cpu) {
> +		struct broadcast_cpu_state *s =&per_cpu(state, i);
> +
> +		n = per_cpu(tick_cpu_device, i).evtdev->next_event;
> +		if (n.tv64<  timeout->tv64&&  (s->slave || s->need_oneshot))
> +			*timeout = n;
> +		if (!s->slave&&  !s->need_oneshot)
> +			running++;
> +	}
> +	__get_cpu_var(state).slave = running>  1;
> +	raw_spin_unlock(&per_cpu(state, leader).lock);
> +	return running>  1;
> +}
> +
> +/*
> + * Sync oneshot state with siblings.
> + */
> +static void set_broadcast_sibling_state(int cpu, int enter)
> +{
> +	int i;
> +
> +	for_each_sibling(i, cpu) {
> +		struct broadcast_cpu_state *s =&per_cpu(state, i);
> +
> +		if (enter&&  s->slave) {
> +			s->need_oneshot = 1;
> +			wmb();
> +			s->slave = 0;
> +		} else if (!enter&&  s->need_oneshot) {
> +			s->slave = 1;
> +			wmb();
> +			s->need_oneshot = 0;
> +		}
> +	}
> +}
> +
>   /*
>    * Powerstate information: The system enters/leaves a state, where
>    * affected devices might stop
> @@ -464,7 +534,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>   	struct tick_device *td;
>   	unsigned long flags;
>   	int cpu;
> -
> +	ktime_t timeout;
> +	
>   	/*
>   	 * Periodic mode does not care about the enter/exit of power
>   	 * states
> @@ -476,21 +547,28 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>   	bc = tick_broadcast_device.evtdev;
>   	td =&per_cpu(tick_cpu_device, cpu);
>   	dev = td->evtdev;
> +	timeout = td->evtdev->next_event;
>
>   	if (!(dev->features&  CLOCK_EVT_FEAT_C3STOP))
>   		return;
>
> +	if (tick_sibling_active(cpu,&timeout,
> +				reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER))
> +		return;
> +
>   	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>   	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
>   		if (!__get_cpu_var(state).need_oneshot) {
> -			__get_cpu_var(state).need_oneshot = 1;

Don't we still need to set need_oneshot here for this cpu?

> +			/* Turn all slaves into oneshots */
> +			set_broadcast_sibling_state(cpu, 1);
>   			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> -			if (dev->next_event.tv64<  bc->next_event.tv64)
> -				tick_broadcast_set_event(dev->next_event, 1);
> +			if (timeout.tv64<  bc->next_event.tv64)
> +				tick_broadcast_set_event(timeout, 1);
>   		}
>   	} else {
>   		if (__get_cpu_var(state).need_oneshot) {
> -			__get_cpu_var(state).need_oneshot = 0;

And don't we still need to clear it here?

> +			/* Turn all oneshots into slaves */
> +			set_broadcast_sibling_state(cpu, 0);
>   			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
>   			if (dev->next_event.tv64 != KTIME_MAX)
>   				tick_program_event(dev->next_event, 1);
> @@ -506,7 +584,12 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>    */
>   static void tick_broadcast_clear_oneshot(int cpu)
>   {
> -	per_cpu(state, cpu).need_oneshot = 0;
> +	int i;
> +
> +	for_each_sibling (i, cpu) {
> +		per_cpu(state, i).need_oneshot = 0;
> +		per_cpu(state, i).slave = 0;
> +	}
>   }
>
>   static void tick_broadcast_init_next_event(struct cpumask *mask,

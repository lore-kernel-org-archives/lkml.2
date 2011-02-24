Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab1BXPBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 10:01:01 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59556 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1BXPA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 10:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=He0QzGPuGZ74yPUwOwAPp6EipDNiL9xBxNDaH2UxOgwkpbzQAlt4jEosEBwHNl2yUt
         gd+4KZiPBb1Q9nVNDOxwd+l1EaPgmEWmty1DHuTunEcumULuOmf9EuIW5eEiaaIj3kjd
         7MVf3fzfIy7ntet/Hru6UAul/GftsGy9FAL3c=
Date: Thu, 24 Feb 2011 16:00:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        rostedt@goodmis.org, amit.kucheria@linaro.org,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V4 2/2] tracing, perf : add cpu hotplug trace events
Message-ID: <20110224150050.GA1840@nowhere>
References: <AANLkTi=z8GjFEK5bUfrfiSikETFywyAcT5ZdnWaJ6ZzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=z8GjFEK5bUfrfiSikETFywyAcT5ZdnWaJ6ZzA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:23:59AM +0100, Vincent Guittot wrote:
> Please find below a new proposal for adding trace events for cpu hotplug.
> The goal is to measure the latency of each part (kernel, architecture)
> and also to trace the cpu hotplug activity with other power events. I
> have tested these traces events on an arm platform.
> 
> Subject: [PATCH 2/2] add hotplug tracepoint
> 
> this patch adds new events for cpu hotplug tracing
>  * plug/unplug sequence
>  * core and architecture latency measurements
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/cpu.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 156cc55..692e819 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -16,6 +16,9 @@
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
> 
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/cpu_hotplug.h>
> +
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
> @@ -197,10 +200,13 @@ struct take_cpu_down_param {
>  static int __ref take_cpu_down(void *_param)
>  {
>  	struct take_cpu_down_param *param = _param;
> +	unsigned int cpu = (unsigned int)(param->hcpu);
>  	int err;
> 
>  	/* Ensure this CPU doesn't handle any more interrupts. */
> +	trace_cpu_hotplug_disable_start(cpu);
>  	err = __cpu_disable();
> +	trace_cpu_hotplug_disable_end(cpu);
>  	if (err < 0)
>  		return err;
> 
> @@ -256,7 +262,9 @@ static int __ref _cpu_down(unsigned int cpu, int
> tasks_frozen)
>  		cpu_relax();
> 
>  	/* This actually kills the CPU. */
> +	trace_cpu_hotplug_die_start(cpu);
>  	__cpu_die(cpu);
> +	trace_cpu_hotplug_die_end(cpu);
> 
>  	/* CPU is completely dead: tell everyone.  Too late to complain. */
>  	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
> @@ -274,6 +282,8 @@ int __ref cpu_down(unsigned int cpu)
>  {
>  	int err;
> 
> +	trace_cpu_hotplug_down_start(cpu);
> +
>  	cpu_maps_update_begin();
> 
>  	if (cpu_hotplug_disabled) {
> @@ -285,6 +295,8 @@ int __ref cpu_down(unsigned int cpu)
> 
>  out:
>  	cpu_maps_update_done();
> +
> +	trace_cpu_hotplug_down_end(cpu);
>  	return err;
>  }
>  EXPORT_SYMBOL(cpu_down);
> @@ -310,7 +322,9 @@ static int __cpuinit _cpu_up(unsigned int cpu, int
> tasks_frozen)
>  	}
> 
>  	/* Arch-specific enabling code. */
> +	trace_cpu_hotplug_arch_up_start(cpu);
>  	ret = __cpu_up(cpu);
> +	trace_cpu_hotplug_arch_up_end(cpu);
>  	if (ret != 0)
>  		goto out_notify;
>  	BUG_ON(!cpu_online(cpu));
> @@ -335,6 +349,8 @@ int __cpuinit cpu_up(unsigned int cpu)
>  	pg_data_t	*pgdat;
>  #endif
> 
> +	trace_cpu_hotplug_up_start(cpu);
> +
>  	if (!cpu_possible(cpu)) {
>  		printk(KERN_ERR "can't online cpu %d because it is not "
>  			"configured as may-hotadd at boot time\n", cpu);
> @@ -376,6 +392,8 @@ int __cpuinit cpu_up(unsigned int cpu)
> 
>  	err = _cpu_up(cpu, 0);
> 
> +	trace_cpu_hotplug_up_end(cpu);

You should probably have this call after cpu_maps_update_done(),
because you put the start before the mutex is locked.
Just to stay symetric with lock events.

In fact I think it may be better not to include the hotplug lock/unlock
in the cpu down/up tracing, but trace start once it is locked and trace
stop before we release it.

It's just that I think you're not interested in including cpu_add_remove_lock
mutex contention in cpu hotplug traces. That's rather something to be measured
with lock events if needed.

It's a detail, for the rest I'm fine the patches. As Steve said though, it would
be nice to get feedback from cpu hotplug maintainers (who I'm adding in Cc
here again).

Thanks.


> +
>  out:
>  	cpu_maps_update_done();
>  	return err;
> -- 
> 1.7.1

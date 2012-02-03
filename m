Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2BCLCi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 06:02:38 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52583 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab2BCLCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 06:02:36 -0500
Message-ID: <4F2BBEB3.7080802@linux.vnet.ibm.com>
Date: Fri, 03 Feb 2012 16:32:11 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RFC tip/core/rcu 3/3] cpuidle: Inform RCU of read-side
 critical sections
References: <20120203011208.GA2004@linux.vnet.ibm.com> <1328231568-2971-1-git-send-email-paulmck@linux.vnet.ibm.com> <1328231568-2971-3-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1328231568-2971-3-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020300-1396-0000-0000-0000009FB0F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 06:42 AM, Paul E. McKenney wrote:

> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The cpuidle_idle_call() function is invoked in the inner idle loop,
> after the call to rcu_idle_enter() and before the call to rcu_idle_exit().
> This means that RCU is ignoring the CPU at this point.  Unfortunately,
> cpuidle_idle_call() nevertheless contains tracepoints (important ones
> used by powertop) that expect RCU to be paying attention.  The consequences
> of using RCU read-side critical sections on CPUs that RCU is ignoring
> can be severe, including random corruption of random memory.
> 
> Therefore, this commit uses the new RCU_NONIDLE() macro to let RCU
> do its job with respect to the tracepoints.
> 
> Suggested-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Trinabh Gupta <g.trinabh@gmail.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> ---
>  drivers/cpuidle/cpuidle.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 59f4261..cd8a553 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -94,13 +94,17 @@ int cpuidle_idle_call(void)
> 
>  	target_state = &drv->states[next_state];
> 
> -	trace_power_start(POWER_CSTATE, next_state, dev->cpu);
> -	trace_cpu_idle(next_state, dev->cpu);
> +	RCU_NONIDLE(
> +		trace_power_start(POWER_CSTATE, next_state, dev->cpu);
> +		trace_cpu_idle(next_state, dev->cpu)
> +	);
> 
>  	entered_state = target_state->enter(dev, drv, next_state);
> 
> -	trace_power_end(dev->cpu);
> -	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
> +	RCU_NONIDLE(
> +		trace_power_end(dev->cpu);
> +		trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
> +	);
> 
>  	if (entered_state >= 0) {
>  		/* Update cpuidle counters */


Cleaner design esp by moving away from architecture specific
tweaking is much appreciated :)

Acked-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2BGCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 21:16:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:33989 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211Ab2BGCQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 21:16:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="103978073"
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Feb 2012 18:24:10 -0800
In-Reply-To: <1328560933-3037-1-git-send-email-venki@google.com>
References: <1328560933-3037-1-git-send-email-venki@google.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1328581451.29790.14.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 12:42 -0800, Venkatesh Pallipadi wrote:
> * Lower overhead on Async IPI send path. Measurements on Westmere based
>   systems show savings on "no wait" smp_call_function_single with idle
>   target CPU (as measured on the sender side).
>   local socket smp_call_func cost goes from ~1600 to ~1200 cycles
>   remote socket smp_call_func cost goes from ~2000 to ~1800 cycles

Interesting that savings in the remote socket is less compared to the
local socket.

> +int smp_need_ipi(int cpu)
> +{
> +	int oldval;
> +
> +	if (!system_using_cpu_idle_sync || cpu == smp_processor_id())
> +		return 1;
> +
> +	oldval = atomic_cmpxchg(&per_cpu(cpu_idle_sync, cpu),
> +				CPU_STATE_IDLE, CPU_STATE_WAKING);

To avoid too many cache line bounces for the case when the cpu is in the
running state, we should do a read to check if the state is in idle
before going ahead with the locked operation?

> +
> +	if (oldval == CPU_STATE_RUNNING)
> +		return 1;
> +
> +	if (oldval == CPU_STATE_IDLE) {
> +		set_tsk_ipi_pending(idle_task(cpu));
> +		atomic_set(&per_cpu(cpu_idle_sync, cpu), CPU_STATE_WOKENUP);
> +	}
> +
> +	return 0;

We should probably disable interrupts around this, otherwise any delay
in transitioning to wokenup from waking will cause the idle cpu to be
stuck for similar amount of time.

thanks,
suresh


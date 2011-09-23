Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1IWW7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:59:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:32335 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765Ab1IWW7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="55830690"
From: Andi Kleen <andi@firstfloor.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
References: <1316804080-6396-1-git-send-email-venki@google.com>
Date: Fri, 23 Sep 2011 15:59:16 -0700
In-Reply-To: <1316804080-6396-1-git-send-email-venki@google.com> (Venkatesh
	Pallipadi's message of "Fri, 23 Sep 2011 11:54:40 -0700")
Message-ID: <m2d3eqkgqj.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Pallipadi <venki@google.com> writes:
>
> But, doing an exhaustive search for all softexpired timers, especially when
> CPU is idle, has its advantages:
> * it will result in less interruptions later (when CPU may be busy).
> * it can reduce number of wakeups in cases where not yet expired timer in above description could be deleted before they expire.
> * For timers resulting in task wakeups, doing wakeup on idle can improve the
> overall efficiency of the system. It can also bring load balance/migration benefits.

Seems like a good idea in general.

> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
> index ca6f7ab..8d3e287 100644
> --- a/arch/x86/kernel/process_64.c
> +++ b/arch/x86/kernel/process_64.c
> @@ -149,6 +149,8 @@ void cpu_idle(void)
>  		preempt_enable_no_resched();
>  		schedule();
>  		preempt_disable();
> +		if (sysctl_hrtimer_greedy_lookup)
> +			hrtimer_peek_ahead_timers();

So why is it a sysctl and not default?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

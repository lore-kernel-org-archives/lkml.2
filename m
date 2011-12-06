Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464Ab1LFMOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:14:44 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39412 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933368Ab1LFMOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:14:42 -0500
Date: Tue, 6 Dec 2011 17:44:02 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Subject: Re: [patch v3 1/6] sched, nohz: introduce nohz_flags in the struct rq
Message-ID: <20111206121401.GA12083@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20111202010731.344451602@sbsiddha-desk.sc.intel.com>
 <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111202010832.499438999@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120612-7182-0000-0000-00000058067A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Suresh Siddha <suresh.b.siddha@intel.com> [2011-12-01 17:07:32]:

> @@ -4866,18 +4866,15 @@ static void nohz_balancer_kick(int cpu)
>  			return;
>  	}
> 
> -	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> -		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> -
> -		smp_mb();
> -		/*
> -		 * Use smp_send_reschedule() instead of resched_cpu().
> -		 * This way we generate a sched IPI on the target cpu which
> -		 * is idle. And the softirq performing nohz idle load balance
> -		 * will be run before returning from the IPI.
> -		 */
> -		smp_send_reschedule(ilb_cpu);
> -	}
> +	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))

s/cpu/ilb_cpu?

Also given that 'cpu' argument to nohz_balancer_kick() is no longer used, we can
avoid passing any argument to it as well ..

> +		return;
> +	/*
> +	 * Use smp_send_reschedule() instead of resched_cpu().
> +	 * This way we generate a sched IPI on the target cpu which
> +	 * is idle. And the softirq performing nohz idle load balance
> +	 * will be run before returning from the IPI.
> +	 */
> +	smp_send_reschedule(ilb_cpu);
>  	return;
>  }

- vatsa


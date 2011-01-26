Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1AZKDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 05:03:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:59998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1AZKDb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 05:03:31 -0500
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        Torben Hohn <torbenh@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        hch@infradead.org
In-Reply-To: <20110126055610.GA2593@windriver.com>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
	 <1295651224-29823-2-git-send-email-torbenh@gmx.de>
	 <1295901169.4845.29.camel@work-vm>
	 <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
	 <1295907672.2274.44.camel@twins>
	 <alpine.LFD.2.00.1101242344090.31804@localhost6.localdomain6>
	 <1295946514.28776.476.camel@laptop> <1295951677.28776.489.camel@laptop>
	 <1295974319.28776.1070.camel@laptop>  <20110126055610.GA2593@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 11:03:56 +0100
Message-ID: <1296036236.28776.1136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 13:56 +0800, Yong Zhang wrote:


> +static __init void start_calc_global_timer()
> +{
> +       calc_load_update = jiffies + LOAD_FREQ;

That should really be done where it was done in sched_init(), otherwise
rq->calc_load_update and this get out of sync.

> +       set_timer_slack(&global_load_timer, 0);

Ah, there an actual function for that ;-)

> +       mod_timer(&global_load_timer, calc_load_update + 10);
> +}



> @@ -7741,6 +7752,8 @@ void __init sched_init_smp(void)
>  {
>         cpumask_var_t non_isolated_cpus;
>  
> +       start_calc_global_timer();
> +
>         alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
>         alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
>  
> @@ -7777,6 +7790,7 @@ void __init sched_init_smp(void)
>  #else
>  void __init sched_init_smp(void)
>  {
> +       start_calc_global_timer();
>         sched_init_granularity();
>  }
>  #endif /* CONFIG_SMP */ 

Right, I done the same thing, except didn't do that wrapper function.

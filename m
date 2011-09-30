Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1I3Xjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:39:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55997 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab1I3Xjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:39:36 -0400
Date: Fri, 30 Sep 2011 16:39:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
Message-ID: <20110930233932.GB2658@mtj.dyndns.org>
References: <4E85EE1F.7050508@goop.org>
 <20110930230635.GA2658@mtj.dyndns.org>
 <4E865198.1070901@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E865198.1070901@goop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 30, 2011 at 04:32:40PM -0700, Jeremy Fitzhardinge wrote:
> > As others have pointed out, you'll need to call both local and hardirq
> > disables.  Also, I think the description and the code are a bit
> > misleading.  How aobut setting cpu_stop_initialized in cpu_stop_init()
> > and testing it from __stop_machine() instead?  I think it would be
> > better to keep the behavior as uniform as possible once things are up
> > and running.
> 
> Yes, I was wondering about that.  Do you think the patch (with irq fixes
> in place) would affect the behaviour of an SMP kernel running UP?

I can't think of anything which could go wrong from the top of my head
but there's no reason to risk subtle issues when the alternative isn't
difficult.

> diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
> index f5855fe3..70b3be4 100644
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -41,6 +41,7 @@ struct cpu_stopper {
>  };
>  
>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
> +static bool stop_machine_initialized = false;
>  
>  static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
>  {
> @@ -386,6 +387,8 @@ static int __init cpu_stop_init(void)
>  	cpu_stop_cpu_callback(&cpu_stop_cpu_notifier, CPU_ONLINE, bcpu);
>  	register_cpu_notifier(&cpu_stop_cpu_notifier);
>  
> +	stop_machine_initialized = true;
> +
>  	return 0;
>  }
>  early_initcall(cpu_stop_init);
> @@ -485,7 +488,7 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  					    .num_threads = num_online_cpus(),
>  					    .active_cpus = cpus };
>  
> -	if (smdata.num_threads == 1) {
> +	if (!stop_machine_initialized) {

Yeah, this looks good to me.  You might want to add
WARN_ON_ONCE(smdata.num_threads != 1) inside if {} tho.

Thank you.

-- 
tejun

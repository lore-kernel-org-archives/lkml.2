Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1H2QCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:02:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:56117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1H2QCU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:02:20 -0400
Subject: Re: [PATCH 19/32] nohz/cpuset: Restart tick when nohz flag is
 cleared on cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 18:02:01 +0200
In-Reply-To: <1313423549-27093-20-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-20-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314633721.2816.109.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> +++ b/kernel/cpuset.c
> @@ -1199,6 +1199,14 @@ static void cpuset_change_flag(struct task_struct *tsk,
>  
>  DEFINE_PER_CPU(int, cpu_adaptive_nohz_ref);
>  
> +static void cpu_exit_nohz(int cpu)
> +{
> +       preempt_disable();
> +       smp_call_function_single(cpu, cpuset_exit_nohz_interrupt,
> +                                NULL, true);
> +       preempt_enable();
> +}
> +
>  static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
>  {
>         int cpu;
> @@ -1212,6 +1220,19 @@ static void update_nohz_cpus(struct cpuset *old_cs, struct cpuset *cs)
>                         per_cpu(cpu_adaptive_nohz_ref, cpu) += 1;
>                 else
>                         per_cpu(cpu_adaptive_nohz_ref, cpu) -= 1;
> +
> +               val = per_cpu(cpu_adaptive_nohz_ref, cpu);
> +
> +               if (!val) {
> +                       /*
> +                        * The update to cpu_adaptive_nohz_ref must be
> +                        * visible right away. So that once we restart the tick
> +                        * from the IPI, it won't be stopped again due to cache
> +                        * update lag.
> +                        */
> +                       smp_mb();
> +                       cpu_exit_nohz(cpu);
> +               }
>         }
>  }
>  #else
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 78ea0a5..75378be 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2513,6 +2513,14 @@ void cpuset_update_nohz(void)
>                 cpuset_nohz_restart_tick();
>  }
>  
> +void cpuset_exit_nohz_interrupt(void *unused)
> +{
> +       if (!tick_nohz_adaptive_mode())
> +               return;
> +
> +       cpuset_nohz_restart_tick();
> +} 

You do this just to annoy me, right? Why doesn't it live in cpuset.c
where you use it?

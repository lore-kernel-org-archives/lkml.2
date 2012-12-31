Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab2LaHSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 02:18:41 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:49504 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2LaHSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 02:18:39 -0500
Message-ID: <1356938303.16700.23.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [PATCH 06/27] nohz: Basic full dynticks interface
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 31 Dec 2012 15:18:23 +0800
In-Reply-To: <1356799386-4212-7-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
	 <1356799386-4212-7-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12123107-2000-0000-0000-00000A6E5F51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-29 at 17:42 +0100, Frederic Weisbecker wrote:
> Start with a very simple interface to define full dynticks CPU:
> use a boot time option defined cpumask through the "full_nohz="
> kernel parameter.
> 
> Make sure you keep at least one CPU outside this range to handle
> the timekeeping.
> 
> Also full_nohz= must match rcu_nocb= value.
> 
> Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/tick.h     |    7 +++++++
>  kernel/time/Kconfig      |    9 +++++++++
>  kernel/time/tick-sched.c |   23 +++++++++++++++++++++++
>  3 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index 553272e..2d4f6f0 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -157,6 +157,13 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
>  static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
>  # endif /* !NO_HZ */
> 
> +#ifdef CONFIG_NO_HZ_FULL
> +int tick_nohz_full_cpu(int cpu);
> +#else
> +static inline int tick_nohz_full_cpu(int cpu) { return 0; }
> +#endif
> +
> +
>  # ifdef CONFIG_CPU_IDLE_GOV_MENU
>  extern void menu_hrtimer_cancel(void);
>  # else
> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
> index 8601f0d..dc6381d 100644
> --- a/kernel/time/Kconfig
> +++ b/kernel/time/Kconfig
> @@ -70,6 +70,15 @@ config NO_HZ
>  	  only trigger on an as-needed basis both when the system is
>  	  busy and when the system is idle.
> 
> +config NO_HZ_FULL
> +       bool "Full tickless system"
> +       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP

Does that mean for archs like PPC64, which HAVE_VIRT_CPU_ACCOUNTING, to
get NO_HZ_FULL supported, we need to use VIRT_CPU_ACCOUTING_GEN instead
of VIRT_CPU_ACCOUNTING_NATIVE? ( I think the two, *_NATIVE and *_GEN,
shouldn't be both enabled at the same time? )

When I tried it on a ppc64 machine, it seems that after I select
VIRT_CPU_ACCOUNTING, VIRT_CPU_ACCOUNTING_NATIVE is automatically
selected. And I have no way to enable VIRT_CPU_ACCOUTING_GEN, or disable
VIRT_CPU_ACCOUNTING_NATIVE. It seems that's because these two don't have
a configuration name (input prompt).

> +       select CONTEXT_TRACKING_FORCE
> +       help
> +         Try to be tickless everywhere, not just in idle. (You need
> +	 to fill up the full_nohz_mask boot parameter).

Maybe it is better to use the name of the boot parameter full_nohz here
than the name of the mask variable used in the code? 

Thanks, Zhong

> +
> +
>  config HIGH_RES_TIMERS
>  	bool "High Resolution Timer Support"
>  	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index ad0e6fa..fac9ba4 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -142,6 +142,29 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
>  	profile_tick(CPU_PROFILING);
>  }
> 
> +#ifdef CONFIG_NO_HZ_FULL
> +static cpumask_var_t full_nohz_mask;
> +bool have_full_nohz_mask;
> +
> +int tick_nohz_full_cpu(int cpu)
> +{
> +	if (!have_full_nohz_mask)
> +		return 0;
> +
> +	return cpumask_test_cpu(cpu, full_nohz_mask);
> +}
> +
> +/* Parse the boot-time nohz CPU list from the kernel parameters. */
> +static int __init tick_nohz_full_setup(char *str)
> +{
> +	alloc_bootmem_cpumask_var(&full_nohz_mask);
> +	have_full_nohz_mask = true;
> +	cpulist_parse(str, full_nohz_mask);
> +	return 1;
> +}
> +__setup("full_nohz=", tick_nohz_full_setup);
> +#endif
> +
>  /*
>   * NOHZ - aka dynamic tick functionality
>   */



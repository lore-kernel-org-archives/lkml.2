Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254Ab1FQPLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:11:47 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45080 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349Ab1FQPLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:11:46 -0400
Date: Fri, 17 Jun 2011 17:11:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 3/8] x86, mce: introduce mce_timer_add()
Message-ID: <20110617151124.GA20010@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB139D.8060401@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB139D.8060401@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:43:09AM -0400, Hidetoshi Seto wrote:
> It is too redundant to call setup_timer() every time when the timer is
> going to be added.
> 
> This patch breaks __mcheck_cpu_init_timer() down, put setup part to init
> code path and construct mce_timer_add() from the rests. Since there is no
> strong reason to keep interval only when it back from hotplug event, this
> patch also helps to kill duplicated code in hotplug notifier.
> 
> As the sideline this patch includes rename of mce_start_timer() to
> mce_timer_run(), to group related functions with mce_timer_ prefix.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Reviewed-by: Borislav Petkov <borislav.petkov@amd.com>

> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   54 ++++++++++++++++++-------------------
>  1 files changed, 26 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 205b334..c3dad64 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1114,7 +1114,7 @@ static int check_interval = 5 * 60; /* 5 minutes */
>  static DEFINE_PER_CPU(int, mce_next_interval); /* in jiffies */
>  static DEFINE_PER_CPU(struct timer_list, mce_timer);
>  
> -static void mce_start_timer(unsigned long data)
> +static void mce_timer_run(unsigned long data)
>  {
>  	struct timer_list *t = &per_cpu(mce_timer, data);
>  	int *n;
> @@ -1147,6 +1147,21 @@ static void mce_timer_delete_all(void)
>  	}
>  }
>  
> +static void mce_timer_add(unsigned long cpu)
> +{
> +	struct timer_list *t = &per_cpu(mce_timer, cpu);
> +	int *n = &per_cpu(mce_next_interval, cpu);
> +
> +	if (mce_ignore_ce || !check_interval)
> +		return;
> +
> +	/* reset next interval */
> +	*n = check_interval * HZ;
> +
> +	t->expires = round_jiffies(jiffies + *n);
> +	add_timer_on(t, cpu);
> +}
> +
>  static void mce_do_trigger(struct work_struct *work)
>  {
>  	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
> @@ -1374,23 +1389,6 @@ static void __mcheck_cpu_init_vendor(struct cpuinfo_x86 *c)
>  	}
>  }
>  
> -static void __mcheck_cpu_init_timer(void)
> -{
> -	struct timer_list *t = &__get_cpu_var(mce_timer);
> -	int *n = &__get_cpu_var(mce_next_interval);
> -
> -	setup_timer(t, mce_start_timer, smp_processor_id());
> -
> -	if (mce_ignore_ce)
> -		return;
> -
> -	*n = check_interval * HZ;
> -	if (!*n)
> -		return;
> -	t->expires = round_jiffies(jiffies + *n);
> -	add_timer_on(t, smp_processor_id());
> -}
> -
>  /* Handle unconfigured int18 (should never happen) */
>  static void unexpected_machine_check(struct pt_regs *regs, long error_code)
>  {
> @@ -1408,6 +1406,8 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
>   */
>  void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
>  {
> +	int cpu = smp_processor_id();
> +
>  	if (mce_disabled)
>  		return;
>  
> @@ -1433,9 +1433,12 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
>  
>  	__mcheck_cpu_init_generic();
>  	__mcheck_cpu_init_vendor(c);
> -	__mcheck_cpu_init_timer();
> +
> +	setup_timer(&__get_cpu_var(mce_timer), mce_timer_run, cpu);
>  	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
>  	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
> +
> +	mce_timer_add(cpu);
>  }
>  
>  /*
> @@ -1765,7 +1768,7 @@ static struct syscore_ops mce_syscore_ops = {
>  static void mce_cpu_restart(void *data)
>  {
>  	__mcheck_cpu_init_generic();
> -	__mcheck_cpu_init_timer();
> +	mce_timer_add(smp_processor_id());
>  }
>  
>  /* Reinit MCEs after user configuration changes */
> @@ -1786,7 +1789,7 @@ static void mce_enable_ce(void *all)
>  	cmci_reenable();
>  	cmci_recheck();
>  	if (all)
> -		__mcheck_cpu_init_timer();
> +		mce_timer_add(smp_processor_id());
>  }
>  
>  static struct sysdev_class mce_sysdev_class = {
> @@ -2030,7 +2033,6 @@ static int __cpuinit
>  mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  {
>  	unsigned int cpu = (unsigned long)hcpu;
> -	struct timer_list *t = &per_cpu(mce_timer, cpu);
>  
>  	switch (action) {
>  	case CPU_ONLINE:
> @@ -2047,16 +2049,12 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> -		del_timer_sync(t);
> +		del_timer_sync(&per_cpu(mce_timer, cpu));
>  		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
>  		break;
>  	case CPU_DOWN_FAILED:
>  	case CPU_DOWN_FAILED_FROZEN:
> -		if (!mce_ignore_ce && check_interval) {
> -			t->expires = round_jiffies(jiffies +
> -					   __get_cpu_var(mce_next_interval));
> -			add_timer_on(t, cpu);
> -		}
> +		mce_timer_add(cpu);
>  		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
>  		break;
>  	case CPU_POST_DEAD:
> -- 
> 1.7.1
> 
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

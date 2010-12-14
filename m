Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0LNWcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:32:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758986Ab0LNWcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:32:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Subject: Re: [tip:x86/alternatives] x86, suspend: Avoid unnecessary smp alternatives switch during suspend/resume
Date: Tue, 14 Dec 2010 23:31:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: linux-tip-commits@vger.kernel.org
References: <1290557500.4946.8.camel@sbsiddha-MOBL3.sc.intel.com> <tip-3fb82d56ad003e804923185316236f26b30dfdd5@git.kernel.org>
In-Reply-To: <tip-3fb82d56ad003e804923185316236f26b30dfdd5@git.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012142331.22404.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 14, 2010, tip-bot for Suresh Siddha wrote:
> Commit-ID:  3fb82d56ad003e804923185316236f26b30dfdd5
> Gitweb:     http://git.kernel.org/tip/3fb82d56ad003e804923185316236f26b30dfdd5
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Tue, 23 Nov 2010 16:11:40 -0800
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Mon, 13 Dec 2010 16:23:56 -0800
> 
> x86, suspend: Avoid unnecessary smp alternatives switch during suspend/resume
> 
> During suspend, we disable all the non boot cpus. And during resume we bring
> them all back again. So no need to do alternatives_smp_switch() in between.
> 
> On my core 2 based laptop, this speeds up the suspend path by 15msec and the
> resume path by 5 msec (suspend/resume speed up differences can be attributed
> to the different P-states that the cpu is in during suspend/resume).
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> LKML-Reference: <1290557500.4946.8.camel@sbsiddha-MOBL3.sc.intel.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

OK, I guess there's no nicer way to implement that.

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/include/asm/alternative.h |    1 +
>  arch/x86/kernel/alternative.c      |    3 ++-
>  arch/x86/kernel/smpboot.c          |   14 ++++++++++++++
>  kernel/cpu.c                       |   11 +++++++++++
>  4 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index 76561d2..01171f6 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -66,6 +66,7 @@ extern void alternatives_smp_module_add(struct module *mod, char *name,
>  extern void alternatives_smp_module_del(struct module *mod);
>  extern void alternatives_smp_switch(int smp);
>  extern int alternatives_text_reserved(void *start, void *end);
> +extern bool skip_smp_alternatives;
>  #else
>  static inline void alternatives_smp_module_add(struct module *mod, char *name,
>  					       void *locks, void *locks_end,
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 5079f24..9f98eb4 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -353,6 +353,7 @@ void __init_or_module alternatives_smp_module_del(struct module *mod)
>  	mutex_unlock(&smp_alt);
>  }
>  
> +bool skip_smp_alternatives;
>  void alternatives_smp_switch(int smp)
>  {
>  	struct smp_alt_module *mod;
> @@ -368,7 +369,7 @@ void alternatives_smp_switch(int smp)
>  	printk("lockdep: fixing up alternatives.\n");
>  #endif
>  
> -	if (noreplace_smp || smp_alt_once)
> +	if (noreplace_smp || smp_alt_once || skip_smp_alternatives)
>  		return;
>  	BUG_ON(!smp && (num_online_cpus() > 1));
>  
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 083e99d..837c81e 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1166,6 +1166,20 @@ out:
>  	preempt_enable();
>  }
>  
> +void arch_disable_nonboot_cpus_begin(void)
> +{
> +	/*
> +	 * Avoid the smp alternatives switch during the disable_nonboot_cpus().
> +	 * In the suspend path, we will be back in the SMP mode shortly anyways.
> +	 */
> +	skip_smp_alternatives = true;
> +}
> +
> +void arch_disable_nonboot_cpus_end(void)
> +{
> +	skip_smp_alternatives = false;
> +}
> +
>  void arch_enable_nonboot_cpus_begin(void)
>  {
>  	set_mtrr_aps_delayed_init();
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index f6e726f..8ccc182 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -386,6 +386,14 @@ out:
>  #ifdef CONFIG_PM_SLEEP_SMP
>  static cpumask_var_t frozen_cpus;
>  
> +void __weak arch_disable_nonboot_cpus_begin(void)
> +{
> +}
> +
> +void __weak arch_disable_nonboot_cpus_end(void)
> +{
> +}
> +
>  int disable_nonboot_cpus(void)
>  {
>  	int cpu, first_cpu, error = 0;
> @@ -397,6 +405,7 @@ int disable_nonboot_cpus(void)
>  	 * with the userspace trying to use the CPU hotplug at the same time
>  	 */
>  	cpumask_clear(frozen_cpus);
> +	arch_disable_nonboot_cpus_begin();
>  
>  	printk("Disabling non-boot CPUs ...\n");
>  	for_each_online_cpu(cpu) {
> @@ -412,6 +421,8 @@ int disable_nonboot_cpus(void)
>  		}
>  	}
>  
> +	arch_disable_nonboot_cpus_end();
> +
>  	if (!error) {
>  		BUG_ON(num_online_cpus() > 1);
>  		/* Make sure the CPUs won't be enabled by someone else */
> 
> 


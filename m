Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab2FDChy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:37:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:11589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544Ab2FDChx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:37:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="147649290"
Message-ID: <4FCC1F7C.5000008@linux.intel.com>
Date: Mon, 04 Jun 2012 10:37:48 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 2/2] x86: mce: Implement cmci poll mode for intel machines
References: <20120524174943.989990966@linutronix.de> <20120524175056.478167482@linutronix.de>
In-Reply-To: <20120524175056.478167482@linutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas

I have some confusion in your patch please help to give me some updates.

于 2012/5/25 1:54, Thomas Gleixner 写道:
> Intentionally left blank to be filled out by someone who wants that and
> can explain the reason for this better than me.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-internal.h |    8 ++
>  arch/x86/kernel/cpu/mcheck/mce.c          |   41 +++++++++++++--
>  arch/x86/kernel/cpu/mcheck/mce_intel.c    |   81 +++++++++++++++++++++++++++++-
>  3 files changed, 125 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce-internal.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce-internal.h
> @@ -28,6 +28,14 @@ extern int mce_ser;
>  
>  extern struct mce_bank *mce_banks;
>  
> +#ifdef CONFIG_X86_MCE_INTEL
> +unsigned long mce_intel_adjust_timer(unsigned long interval);
> +#else
> +# define mce_intel_adjust_timer mce_adjust_timer_default
> +#endif
> +
> +void mce_timer_kick(unsigned long interval);
> +
>  #ifdef CONFIG_ACPI_APEI
>  int apei_write_mce(struct mce *m);
>  ssize_t apei_read_mce(struct mce *m, u64 *record_id);
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1242,6 +1242,14 @@ static unsigned long check_interval = 5 
>  static DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in jiffies */
>  static DEFINE_PER_CPU(struct timer_list, mce_timer);
>  
> +static unsigned long mce_adjust_timer_default(unsigned long interval)
> +{
> +	return interval;
> +}
> +
> +static unsigned long (*mce_adjust_timer)(unsigned long interval) =
> +	mce_adjust_timer_default;
> +
>  static void mce_timer_fn(unsigned long data)
>  {
>  	struct timer_list *t = &__get_cpu_var(mce_timer);
> @@ -1259,14 +1267,37 @@ static void mce_timer_fn(unsigned long d
>  	 * polling interval, otherwise increase the polling interval.
>  	 */
>  	iv = __this_cpu_read(mce_next_interval);
> -	if (mce_notify_irq())
> +	if (mce_notify_irq()) {
>  		iv = max(iv, (unsigned long) HZ/100);
> -	else
> +	} else {
>  		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
> +		iv = mce_adjust_timer(iv);
> +	}
>  	__this_cpu_write(mce_next_interval, iv);
> +	/* Might have become 0 after CMCI storm subsided */
> +	if (iv) {
> +		t->expires = jiffies + iv;
> +		add_timer_on(t, smp_processor_id());
> +	}
> +}
>  
> -	t->expires = jiffies + iv;
> -	add_timer_on(t, smp_processor_id());
> +/*
> + * Ensure that the timer is firing in @interval from now.
> + */
> +void mce_timer_kick(unsigned long interval)
> +{
> +	struct timer_list *t = &__get_cpu_var(mce_timer);
> +	unsigned long when = jiffies + interval;
> +	unsigned long iv = __this_cpu_read(mce_next_interval);
> +
> +	if (time_before(when, t->expires) && timer_pending(t)) {
> +		mod_timer(t, when);
> +	} else if (!mce_next_interval) {

Why using mce_next_interval, it is a per_cpu var, should be non-NULL
definitely, right? How about using *iv* here?

> +		t->expires = round_jiffies(jiffies + iv);
> +		add_timer_on(t, smp_processor_id());
> +	}
> +	if (interval < iv)
> +		__this_cpu_write(mce_next_interval, iv);
>  }

This code should be __this_cpu_write(mce_next_interval, interval);?

>  
>  /* Must not be called in IRQ context where del_timer_sync() can deadlock */
> @@ -1531,6 +1562,7 @@ static void __mcheck_cpu_init_vendor(str
>  	switch (c->x86_vendor) {
>  	case X86_VENDOR_INTEL:
>  		mce_intel_feature_init(c);
> +		mce_adjust_timer = mce_intel_adjust_timer;
>  		break;
>  	case X86_VENDOR_AMD:
>  		mce_amd_feature_init(c);
> @@ -1550,6 +1582,7 @@ static void __mcheck_cpu_init_timer(void
>  	if (mce_ignore_ce)
>  		return;
>  
> +	iv = mce_adjust_timer(check_interval * HZ);
>  	__this_cpu_write(mce_next_interval, iv);
>  	if (!iv)
>  		return;

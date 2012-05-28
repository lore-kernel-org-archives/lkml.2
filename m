Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab2E1Jxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:53:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:29370 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab2E1Jxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:53:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="171944934"
Message-ID: <4FC34AEC.2000801@linux.intel.com>
Date: Mon, 28 May 2012 17:52:44 +0800
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

于 2012/5/25 1:54, Thomas Gleixner 写道:
> Intentionally left blank to be filled out by someone who wants that
> and can explain the reason for this better than me.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de> --- 
> arch/x86/kernel/cpu/mcheck/mce-internal.h |    8 ++ 
> arch/x86/kernel/cpu/mcheck/mce.c          |   41 +++++++++++++-- 
> arch/x86/kernel/cpu/mcheck/mce_intel.c    |   81
> +++++++++++++++++++++++++++++- 3 files changed, 125 insertions(+),
> 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce-internal.h 
> ===================================================================
>
> 
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce-internal.h
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce-internal.h @@ -28,6
> +28,14 @@ extern int mce_ser;
> 
> extern struct mce_bank *mce_banks;
> 
> +#ifdef CONFIG_X86_MCE_INTEL +unsigned long
> mce_intel_adjust_timer(unsigned long interval); +#else +# define
> mce_intel_adjust_timer mce_adjust_timer_default +#endif + +void
> mce_timer_kick(unsigned long interval); + #ifdef CONFIG_ACPI_APEI 
> int apei_write_mce(struct mce *m); ssize_t apei_read_mce(struct mce
> *m, u64 *record_id); Index:
> linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c 
> ===================================================================
>
> 
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c @@ -1242,6 +1242,14
> @@ static unsigned long check_interval = 5 static
> DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in jiffies */ 
> static DEFINE_PER_CPU(struct timer_list, mce_timer);
> 
> +static unsigned long mce_adjust_timer_default(unsigned long
> interval) +{ +	return interval; +} + +static unsigned long
> (*mce_adjust_timer)(unsigned long interval) = +
> mce_adjust_timer_default; + static void mce_timer_fn(unsigned long
> data) { struct timer_list *t = &__get_cpu_var(mce_timer); @@
> -1259,14 +1267,37 @@ static void mce_timer_fn(unsigned long d *
> polling interval, otherwise increase the polling interval. */ iv =
> __this_cpu_read(mce_next_interval); -	if (mce_notify_irq()) +	if
> (mce_notify_irq()) { iv = max(iv, (unsigned long) HZ/100);

You don't use old logic max(iv / 2, xxx), so it should not decrease any
more. Any defect for the old logic?

> -	else +	} else { iv = min(iv * 2,
> round_jiffies_relative(check_interval * HZ)); +		iv =
> mce_adjust_timer(iv); +	} __this_cpu_write(mce_next_interval, iv); 
> +	/* Might have become 0 after CMCI storm subsided */ +	if (iv) { +
> t->expires = jiffies + iv; +		add_timer_on(t, smp_processor_id()); 
> +	} +}
> 
> -	t->expires = jiffies + iv; -	add_timer_on(t,
> smp_processor_id()); +/* + * Ensure that the timer is firing in
> @interval from now. + */ +void mce_timer_kick(unsigned long
> interval) +{ +	struct timer_list *t = &__get_cpu_var(mce_timer); +
> unsigned long when = jiffies + interval; +	unsigned long iv =
> __this_cpu_read(mce_next_interval); + +	if (time_before(when,
> t->expires) && timer_pending(t)) { +		mod_timer(t, when); +	} else
> if (!mce_next_interval) {

Why using mce_next_interval, it is a per_cpu var, should be non-NULL
definitely, right? How about using *iv* here?

> +		t->expires = round_jiffies(jiffies + iv); +		add_timer_on(t,
> smp_processor_id()); +	} +	if (interval < iv) +
> __this_cpu_write(mce_next_interval, iv);

This code should be __this_cpu_write(mce_next_interval, interval); ?

> }
> 
> /* Must not be called in IRQ context where del_timer_sync() can
> deadlock */ @@ -1531,6 +1562,7 @@ static void
> __mcheck_cpu_init_vendor(str switch (c->x86_vendor) { case
> X86_VENDOR_INTEL: mce_intel_feature_init(c); +		mce_adjust_timer =
> mce_intel_adjust_timer; break; case X86_VENDOR_AMD: 
> mce_amd_feature_init(c); @@ -1550,6 +1582,7 @@ static void
> __mcheck_cpu_init_timer(void if (mce_ignore_ce) return;
> 
> +	iv = mce_adjust_timer(check_interval * HZ); 
> __this_cpu_write(mce_next_interval, iv); if (!iv) return; Index:
> linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c 
> ===================================================================
>
> 
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce_intel.c @@ -15,6 +15,8
> @@ #include <asm/msr.h> #include <asm/mce.h>
> 
> +#include "mce-internal.h" + /* * Support for Intel Correct Machine
> Check Interrupts. This allows * the CPU to raise an interrupt when
> a corrected machine check happened. @@ -30,7 +32,22 @@ static
> DEFINE_PER_CPU(mce_banks_t, mce_b */ static
> DEFINE_RAW_SPINLOCK(cmci_discover_lock);
> 
> -#define CMCI_THRESHOLD 1 +#define CMCI_THRESHOLD		1 +#define
> CMCI_POLL_INTERVAL	(30 * HZ) +#define CMCI_STORM_INTERVAL	(1 * HZ) 
> +#define CMCI_STORM_TRESHOLD	5 + +static DEFINE_PER_CPU(unsigned
> long, cmci_time_stamp); +static DEFINE_PER_CPU(unsigned int,
> cmci_storm_cnt); +static DEFINE_PER_CPU(unsigned int,
> cmci_storm_state); + +enum { +	CMCI_STORM_NONE, +
> CMCI_STORM_ACTIVE, +	CMCI_STORM_SUBSIDED, +}; + +static atomic_t
> cmci_storm_on_cpus;
> 
> static int cmci_supported(int *banks) { @@ -53,6 +70,66 @@ static
> int cmci_supported(int *banks) return !!(cap & MCG_CMCI_P); }
> 
> +unsigned long mce_intel_adjust_timer(unsigned long interval) +{ +
> if (interval < CMCI_POLL_INTERVAL) +		return interval; + +	switch
> (__this_cpu_read(cmci_storm_state)) { +	case CMCI_STORM_ACTIVE: +
> /* +		 * We switch back to interrupt mode once the poll timer has +
> * silenced itself. That means no events recorded and the +		 *
> timer interval is back to our poll interval. +		 */ +
> __this_cpu_write(cmci_storm_state, CMCI_STORM_SUBSIDED); +
> atomic_dec(&cmci_storm_on_cpus); + +	case CMCI_STORM_SUBSIDED: +
> /* +		 * We wait for all cpus to go back to SUBSIDED +		 * state.
> When that happens we switch back to +		 * interrupt mode. +		 */ +
> if (!atomic_read(&cmci_storm_on_cpus)) { +
> __this_cpu_write(cmci_storm_state, CMCI_STORM_NONE); +
> cmci_reenable(); +			cmci_recheck(); +		} +		return
> CMCI_POLL_INTERVAL; +	default: +		/* +		 * We have shiny wheather,
> let the poll do whatever it +		 * thinks. +		 */ +		return
> interval; +	} +} + +static bool cmci_storm_detect(void) +{ +
> unsigned int cnt = __this_cpu_read(cmci_storm_cnt); +	unsigned long
> ts = __this_cpu_read(cmci_time_stamp); +	unsigned long now =
> jiffies; + +	if (time_before_eq(now, ts + CMCI_STORM_INTERVAL)) { +
> cnt++; +	} else { +		cnt = 1; +		__this_cpu_write(cmci_time_stamp,
> now); +	} +	__this_cpu_write(cmci_storm_cnt, cnt); + +	if (cnt <=
> CMCI_STORM_TRESHOLD) +		return false; + +	cmci_clear(); +
> __this_cpu_write(cmci_storm_state, CMCI_STORM_ACTIVE); +
> atomic_inc(&cmci_storm_on_cpus); +
> mce_timer_kick(CMCI_POLL_INTERVAL); +	return true; +} + /* * The
> interrupt handler. This is called on every event. * Just call the
> poller directly to log any events. @@ -61,6 +138,8 @@ static int
> cmci_supported(int *banks) */ static void
> intel_threshold_interrupt(void) { +	if (cmci_storm_detect()) +
> return; machine_check_poll(MCP_TIMESTAMP,
> &__get_cpu_var(mce_banks_owned)); mce_notify_irq(); }
> 
> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html Please read the FAQ at
> http://www.tux.org/lkml/
> 



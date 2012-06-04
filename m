Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab2FDCWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 22:22:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:37866 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755175Ab2FDCWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 22:22:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="160178247"
Message-ID: <4FCC1BE4.3070404@linux.intel.com>
Date: Mon, 04 Jun 2012 10:22:28 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, tony.luck@intel.com, bp@amd64.org,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/2] x86: mce Cleanup timer mess
References: <20120524174943.989990966@linutronix.de> <20120524175056.391516712@linutronix.de>
In-Reply-To: <20120524175056.391516712@linutronix.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tony and Thomas

This patch has been merged, but It still have some confusion, please
see inline comment and give me some explanation.

于 2012/5/25 1:54, Thomas Gleixner 写道:
> Use unsigned long for dealing with jiffies not int. Rename the 
> callback to something sensible. Use __this_cpu_read/write for 
> accessing per cpu data.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de> --- 
> arch/x86/kernel/cpu/mcheck/mce.c |   31 
> ++++++++++++++++--------------- 1 file changed, 16 insertions(+), 
> 15 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c 
> ===================================================================
>
>
> 
--- linux-2.6.orig/arch/x86/kernel/cpu/mcheck/mce.c
> +++ linux-2.6/arch/x86/kernel/cpu/mcheck/mce.c @@ -1237,15
> +1237,15 @@ void mce_log_therm_throt_event(__u64 sta * poller finds
> an MCE, poll 2x faster.  When the poller finds no more * errors,
> poll 2x slower (up to check_interval seconds). */ -static int 
> check_interval = 5 * 60; /* 5 minutes */ +static unsigned long 
> check_interval = 5 * 60; /* 5 minutes */
> 
> -static DEFINE_PER_CPU(int, mce_next_interval); /* in jiffies */ 
> +static DEFINE_PER_CPU(unsigned long, mce_next_interval); /* in 
> jiffies */ static DEFINE_PER_CPU(struct timer_list, mce_timer);
> 
> -static void mce_start_timer(unsigned long data) +static void 
> mce_timer_fn(unsigned long data) { -	struct timer_list *t = 
> &per_cpu(mce_timer, data); -	int *n; +	struct timer_list *t = 
> &__get_cpu_var(mce_timer); +	unsigned long iv;
> 
> WARN_ON(smp_processor_id() != data);
> 
> @@ -1258,13 +1258,14 @@ static void mce_start_timer(unsigned lon * 
> Alert userspace if needed.  If we logged an MCE, reduce the * 
> polling interval, otherwise increase the polling interval. */ -	n
> = &__get_cpu_var(mce_next_interval); +	iv = 
> __this_cpu_read(mce_next_interval); if (mce_notify_irq()) -		*n = 
> max(*n/2, HZ/100); +		iv = max(iv, (unsigned long) HZ/100);

Here Thomas changed original mode from "*n = max(*n/2, HZ/100);"
to "iv = max(iv, (unsigned long) HZ/100);", which means *iv* will not
be decremented but only incremented in _else_ branch. If so, eventually
the *iv will be equal to *check_interval*. I don't think it makes sense.
Even we use new logic, the comment before these codes should be updated.

So Thomas, would you please explain why you use this new logic?

> else -		*n = min(*n*2, 
> (int)round_jiffies_relative(check_interval*HZ)); +		iv = min(iv * 
> 2, round_jiffies_relative(check_interval * HZ)); + 
> __this_cpu_write(mce_next_interval, iv);
> 
> -	t->expires = jiffies + *n; +	t->expires = jiffies + iv; 
> add_timer_on(t, smp_processor_id()); }
> 
> @@ -1542,17 +1543,17 @@ static void __mcheck_cpu_init_vendor(str 
> static void __mcheck_cpu_init_timer(void) { struct timer_list *t = 
> &__get_cpu_var(mce_timer); -	int *n = 
> &__get_cpu_var(mce_next_interval); +	unsigned long iv = 
> __this_cpu_read(mce_next_interval);
> 
> -	setup_timer(t, mce_start_timer, smp_processor_id()); + 
> setup_timer(t, mce_timer_fn, smp_processor_id());
> 
> if (mce_ignore_ce) return;
> 
> -	*n = check_interval * HZ; -	if (!*n) + 
> __this_cpu_write(mce_next_interval, iv); +	if (!iv) return; - 
> t->expires = round_jiffies(jiffies + *n); +	t->expires = 
> round_jiffies(jiffies + iv); add_timer_on(t, smp_processor_id()); 
> }
> 
> @@ -2262,7 +2263,7 @@ mce_cpu_callback(struct notifier_block *
> case CPU_DOWN_FAILED_FROZEN: if (!mce_ignore_ce && check_interval)
> { t->expires = round_jiffies(jiffies + - 
> __get_cpu_var(mce_next_interval)); +
> per_cpu(mce_next_interval, cpu)); add_timer_on(t, cpu); }
> smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
> 
> 
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3AHUpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:45:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3AHUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:45:15 -0500
X-Authority-Analysis: v=2.0 cv=T70Ovo2Q c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=S0zgfAou480A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=-V7fij46oSQA:10 a=Uteb_GDmd8kTGGLJaxcA:9 a=PUjeQqilurYA:10 a=YbCfVPFhYjzITOEL:21 a=t7QQPwizLJ3O26vV:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357677912.5190.32.camel@gandalf.local.home>
Subject: Re: [PATCH 03/33] cputime: Generic on-demand virtual cputime
 accounting
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 Jan 2013 15:45:12 -0500
In-Reply-To: <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	 <1357610913-1080-4-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:

> +#ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
> +static DEFINE_PER_CPU(long, last_jiffies) = INITIAL_JIFFIES;
> +
> +static cputime_t get_vtime_delta(void)
> +{
> +	long delta;
> +
> +	delta = jiffies - __this_cpu_read(last_jiffies);
> +	__this_cpu_add(last_jiffies, delta);
> +
> +	return jiffies_to_cputime(delta);
> +}
> +
> +void vtime_account_system(struct task_struct *tsk)
> +{
> +	cputime_t delta_cpu = get_vtime_delta();
> +
> +	account_system_time(tsk, irq_count(), delta_cpu, cputime_to_scaled(delta_cpu));
> +}
> +
> +void vtime_account_user(struct task_struct *tsk)
> +{
> +	cputime_t delta_cpu = get_vtime_delta();
> +
> +	/*
> +	 * This is an unfortunate hack: if we flush user time only on
> +	 * irq entry, we miss the jiffies update and the time is spuriously
> +	 * accounted to system time.
> +	 */
> +	if (context_tracking_in_user())
> +		account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));

Hmm, you called get_vtime_delta() up above, which updates the
last_jiffies per_cpu variable, but if for some reason,
context_tracking_in_user() isn't true, we throw away the delta. What
happens to those lost jiffies? They go nowhere.

Shouldn't it be? :

	if (context_tracking_in_user()) {
		delta_cpu = get_vtime_delta();
		account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
	}

-- Steve

> +}
> +
> +void vtime_account_idle(struct task_struct *tsk)
> +{
> +	cputime_t delta_cpu = get_vtime_delta();
> +
> +	account_idle_time(delta_cpu);
> +}
> +
> +static int __cpuinit vtime_cpu_notify(struct notifier_block *self,
> +				      unsigned long action, void *hcpu)
> +{
> +	long cpu = (long)hcpu;
> +	long *last_jiffies_cpu = per_cpu_ptr(&last_jiffies, cpu);
> +
> +	switch (action) {
> +	case CPU_UP_PREPARE:
> +	case CPU_UP_PREPARE_FROZEN:
> +		/*
> +		 * CHECKME: ensure that's visible by the CPU
> +		 * once it wakes up
> +		 */
> +		*last_jiffies_cpu = jiffies;
> +	default:
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int __init init_vtime(void)
> +{
> +	cpu_notifier(vtime_cpu_notify, 0);
> +	return 0;
> +}
> +early_initcall(init_vtime);
> +#endif /* CONFIG_VIRT_CPU_ACCOUNTING_GEN */



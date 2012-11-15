Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab2KOE1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:27:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11664 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab2KOE07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:26:59 -0500
X-Authority-Analysis: v=2.0 cv=RoZH3VaK c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PgzfAm7JgvwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=e4ZfzG6rw4cA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8 a=_5230WynsYERRVR-4xoA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=3Rfx1nUSh_UA:10 a=Zh68SRI7RUMA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1352953617.18025.94.camel@gandalf.local.home>
Subject: Re: [PATCH 7/7] printk: Wake up klogd using irq_work
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 14 Nov 2012 23:26:57 -0500
In-Reply-To: <1352925457-15700-8-git-send-email-fweisbec@gmail.com>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	 <1352925457-15700-8-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-14 at 21:37 +0100, Frederic Weisbecker wrote:
> klogd is woken up asynchronously from the tick in order
> to do it safely.
> 
> However if printk is called when the tick is stopped, the reader
> won't be woken up until the next interrupt, which might not fire
> for a while. As a result, the user may miss some message.
> 
> To fix this, lets implement the printk tick using a lazy irq work.
> This subsystem takes care of the timer tick state and can
> fix up accordingly.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  include/linux/printk.h   |    3 ---
>  init/Kconfig             |    1 +
>  kernel/printk.c          |   36 ++++++++++++++++++++----------------
>  kernel/time/tick-sched.c |    2 +-
>  kernel/timer.c           |    1 -
>  5 files changed, 22 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index 9afc01e..86c4b62 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -98,9 +98,6 @@ int no_printk(const char *fmt, ...)
>  extern asmlinkage __printf(1, 2)
>  void early_printk(const char *fmt, ...);
>  
> -extern int printk_needs_cpu(int cpu);
> -extern void printk_tick(void);
> -
>  #ifdef CONFIG_PRINTK
>  asmlinkage __printf(5, 0)
>  int vprintk_emit(int facility, int level,
> diff --git a/init/Kconfig b/init/Kconfig
> index cdc152c..c575566 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1196,6 +1196,7 @@ config HOTPLUG
>  config PRINTK
>  	default y
>  	bool "Enable support for printk" if EXPERT
> +	select IRQ_WORK
>  	help
>  	  This option enables normal printk support. Removing it
>  	  eliminates most of the message strings from the kernel image
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 2d607f4..c9104fe 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -42,6 +42,7 @@
>  #include <linux/notifier.h>
>  #include <linux/rculist.h>
>  #include <linux/poll.h>
> +#include <linux/irq_work.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -1955,30 +1956,32 @@ int is_console_locked(void)
>  static DEFINE_PER_CPU(int, printk_pending);
>  static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
>  
> -void printk_tick(void)
> +static void wake_up_klogd_work_func(struct irq_work *irq_work)
>  {
> -	if (__this_cpu_read(printk_pending)) {
> -		int pending = __this_cpu_xchg(printk_pending, 0);
> -		if (pending & PRINTK_PENDING_SCHED) {
> -			char *buf = __get_cpu_var(printk_sched_buf);
> -			printk(KERN_WARNING "[sched_delayed] %s", buf);
> -		}
> -		if (pending & PRINTK_PENDING_WAKEUP)
> -			wake_up_interruptible(&log_wait);
> +	int pending = __this_cpu_xchg(printk_pending, 0);
> +
> +	if (pending & PRINTK_PENDING_SCHED) {
> +		char *buf = __get_cpu_var(printk_sched_buf);
> +		printk(KERN_WARNING "[sched_delayed] %s", buf);
>  	}
> -}
>  
> -int printk_needs_cpu(int cpu)
> -{
> -	if (cpu_is_offline(cpu))
> -		printk_tick();

I'm a little worried about this patch, because of the above code.
(see below)

> -	return __this_cpu_read(printk_pending);
> +	if (pending & PRINTK_PENDING_WAKEUP)
> +		wake_up_interruptible(&log_wait);
>  }
>  
> +static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
> +	.func = wake_up_klogd_work_func,
> +	.flags = IRQ_WORK_LAZY,
> +};
> +
>  void wake_up_klogd(void)
>  {
> -	if (waitqueue_active(&log_wait))
> +	preempt_disable();
> +	if (waitqueue_active(&log_wait)) {
>  		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
> +		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
> +	}
> +	preempt_enable();
>  }
>  
>  static void console_cont_flush(char *text, size_t size)
> @@ -2458,6 +2461,7 @@ int printk_sched(const char *fmt, ...)
>  	va_end(args);
>  
>  	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
> +	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
>  	local_irq_restore(flags);
>  
>  	return r;
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index f249e8c..822d757 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -289,7 +289,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>  		time_delta = timekeeping_max_deferment();
>  	} while (read_seqretry(&xtime_lock, seq));
>  
> -	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
> +	if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||

If the CPU is going offline, the printk_tick() would be executed here.
But now that printk_tick() is done with the irq_work code, it wont be
executed till the next tick.  Could this cause a missed printk because
of this, if the cpu is going offline?

Actually, how does irq_work in general handle cpu offline work?

-- Steve

>  	    arch_needs_cpu(cpu) || irq_work_needs_cpu()) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
> diff --git a/kernel/timer.c b/kernel/timer.c
> index 367d008..ff3b516 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1351,7 +1351,6 @@ void update_process_times(int user_tick)
>  	account_process_tick(p, user_tick);
>  	run_local_timers();
>  	rcu_check_callbacks(cpu, user_tick);
> -	printk_tick();
>  #ifdef CONFIG_IRQ_WORK
>  	if (in_irq())
>  		irq_work_run();



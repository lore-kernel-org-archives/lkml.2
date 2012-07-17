Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2GQDQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:16:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24383 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab2GQDQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:16:39 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=WJAvg6Q9looA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=MZppKOj8ZZuc3HeZz00A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1342494998.24525.6.camel@gandalf.stny.rr.com>
Subject: Re: [patch RT 1/3] cpu/rt: Rework cpu down for PREEMPT_RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        RT-users <linux-rt-users@vger.kernel.org>
Date: Mon, 16 Jul 2012 23:16:38 -0400
In-Reply-To: <20120715091932.036115656@linutronix.de>
References: <20120715090141.942753287@linutronix.de>
	 <20120715091932.036115656@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 08:07 +0000, Thomas Gleixner wrote:

I know you are on vacation (hope you are enjoying yourself ;-)


> ---
>  include/linux/sched.h |    7 ++
>  kernel/cpu.c          |  236 +++++++++++++++++++++++++++++++++++++++++--------
>  kernel/sched/core.c   |   82 +++++++++++++++++-
>  3 files changed, 285 insertions(+), 40 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 7fc8321..777f7bb 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1973,6 +1973,10 @@ extern void do_set_cpus_allowed(struct task_struct *p,
>  
>  extern int set_cpus_allowed_ptr(struct task_struct *p,
>  				const struct cpumask *new_mask);
> +int migrate_me(void);
> +void tell_sched_cpu_down_begin(int cpu);
> +void tell_sched_cpu_down_done(int cpu);
> +
>  #else
>  static inline void do_set_cpus_allowed(struct task_struct *p,
>  				      const struct cpumask *new_mask)
> @@ -1985,6 +1989,9 @@ static inline int set_cpus_allowed_ptr(struct task_struct *p,
>  		return -EINVAL;
>  	return 0;
>  }
> +static inline int migrate_me(void) { return 0; }
> +static inline void tell_sched_cpu_down_begin(int cpu) { }
> +static inline void tell_sched_cpu_down_done(int cpu) { }
>  #endif
>  
>  #ifndef CONFIG_CPUMASK_OFFSTACK
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index d79d33a..c5b3273 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -46,12 +46,7 @@ static int cpu_hotplug_disabled;
>  
>  static struct {
>  	struct task_struct *active_writer;
> -#ifdef CONFIG_PREEMPT_RT_FULL
> -	/* Makes the lock keep the task's state */
> -	spinlock_t lock;
> -#else
>  	struct mutex lock; /* Synchronizes accesses to refcount, */
> -#endif
>  	/*
>  	 * Also blocks the new readers during
>  	 * an ongoing cpu hotplug operation.
> @@ -67,20 +62,42 @@ static struct {

As I was backporting this to 3.0-rt, I noticed that the following is
needed too:

diff --git a/kernel/cpu.c b/kernel/cpu.c
index c5b3273..3e722c0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -54,11 +54,7 @@ static struct {
 	int refcount;
 } cpu_hotplug = {
 	.active_writer = NULL,
-#ifdef CONFIG_PREEMPT_RT_FULL
-	.lock = __SPIN_LOCK_UNLOCKED(cpu_hotplug.lock),
-#else
 	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
-#endif
 	.refcount = 0,
 };

As this goes with part of the applied patch above.
 
I'll add this on top, if no one objects.

-- Steve



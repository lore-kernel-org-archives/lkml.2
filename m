Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab2D0VNB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:13:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57980 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab2D0VM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:12:59 -0400
Date: Fri, 27 Apr 2012 14:12:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: mingo@redhat.com, peterz@infradead.org, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl, dzickus@redhat.com, msb@chromium.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        olofj@chromium.org
Subject: Re: [PATCH] watchdog: fix for lockup detector breakage on resume
Message-Id: <20120427141257.c90f43e0.akpm@linux-foundation.org>
In-Reply-To: <1335550240-17765-1-git-send-email-snanda@chromium.org>
References: <1335550240-17765-1-git-send-email-snanda@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 11:10:40 -0700
Sameer Nanda <snanda@chromium.org> wrote:

> On the suspend/resume path the boot CPU does not go though an
> offline->online transition.  This breaks the NMI detector
> post-resume since it depends on PMU state that is lost when
> the system gets suspended.
> 
> Fix this by forcing a CPU offline->online transition for the
> lockup detector on the boot CPU during resume.
> 
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> ---
> To provide more context, we enable NMI watchdog on
> Chrome OS.  We have seen several reports of systems freezing
> up completely which indicated that the NMI watchdog was not
> firing for some reason.
> 
> Debugging further, we found a simple way of repro'ing system
> freezes -- issuing the command 'tasket 1 sh -c "echo nmilockup > /proc/breakme"'
> after the system has been suspended/resumed one or more times.
> 
> With this patch in place, the system freeze result in panics,
> as expected.  These panics provide a nice stack trace for us
> to debug the actual issue causing the freeze.
> 
> ...
>
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -317,6 +317,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
>  				  size_t *lenp, loff_t *ppos);
>  extern unsigned int  softlockup_panic;
>  void lockup_detector_init(void);
> +void lockup_detector_bootcpu_resume(void);
>  #else
>  static inline void touch_softlockup_watchdog(void)
>  {
> @@ -330,6 +331,9 @@ static inline void touch_all_softlockup_watchdogs(void)
>  static inline void lockup_detector_init(void)
>  {
>  }
> +static inline void lockup_detector_bootcpu_resume(void)
> +{
> +}
>  #endif
>  
>  #ifdef CONFIG_DETECT_HUNG_TASK
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 396d262..0d262a8 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -177,6 +177,9 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>  	arch_suspend_enable_irqs();
>  	BUG_ON(irqs_disabled());
>  
> +	/* Kick the lockup detector */
> +	lockup_detector_bootcpu_resume();
> +
>   Enable_cpus:
>  	enable_nonboot_cpus();
>  
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index df30ee0..dd2ac93 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -585,6 +585,22 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
>  	.notifier_call = cpu_callback
>  };
>  
> +void lockup_detector_bootcpu_resume(void)
> +{
> +	void *cpu = (void *)(long)smp_processor_id();
> +
> +	/*
> +	 * On the suspend/resume path the boot CPU does not go though the
> +	 * offline->online transition. This breaks the NMI detector post
> +	 * resume. Force an offline->online transition for the boot CPU on
> +	 * resume.
> +	 */
> +	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
> +	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
> +
> +	return;
> +}

I have issues with the comment ;) It describes some old bug which isn't
there any more and which nobody cares about.  A better comment would
simply describe the function in the usual fashion.  Something like
this:

--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix
+++ a/kernel/watchdog.c
@@ -597,20 +597,17 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
+/*
+ * On entry to suspend we force an offline->online transition on the boot CPU so
+ * that PMU state is available to that CPU when it comes back online after
+ * resume.  This information is required for restarting the NMI watchdog.
+ */
 void lockup_detector_bootcpu_resume(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 
-	/*
-	 * On the suspend/resume path the boot CPU does not go though the
-	 * offline->online transition. This breaks the NMI detector post
-	 * resume. Force an offline->online transition for the boot CPU on
-	 * resume.
-	 */
 	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
-
-	return;
 }
 
 void __init lockup_detector_init(void)
_


But I'm not sure how accurate it is.  Is it true that the PMU data was
required for starting the NMI hardware?


Also, this is all dead code if CONFIG_SUSPEND=n, so how about

--- a/include/linux/sched.h~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
+++ a/include/linux/sched.h
@@ -317,7 +317,6 @@ extern int proc_dowatchdog_thresh(struct
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 void lockup_detector_init(void);
-void lockup_detector_bootcpu_resume(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -331,6 +330,11 @@ static inline void touch_all_softlockup_
 static inline void lockup_detector_init(void)
 {
 }
+#endif
+
+#if defined(CONFIG_LOCKUP_DETECTOR) && defined(CONFIG_SUSPEND)
+void lockup_detector_bootcpu_resume(void);
+#else
 static inline void lockup_detector_bootcpu_resume(void)
 {
 }
--- a/kernel/watchdog.c~nmi-watchdog-fix-for-lockup-detector-breakage-on-resume-fix-fix
+++ a/kernel/watchdog.c
@@ -597,6 +597,7 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
+#ifdef CONFIG_SUSPEND
 /*
  * On entry to suspend we force an offline->online transition on the boot CPU so
  * that PMU state is available to that CPU when it comes back online after
@@ -609,6 +610,7 @@ void lockup_detector_bootcpu_resume(void
 	cpu_callback(&cpu_nfb, CPU_DEAD, cpu);
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 }
+#endif
 
 void __init lockup_detector_init(void)
 {
_


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1HEJso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:48:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45872 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1HEJsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:48:43 -0400
Message-ID: <4E3BBC73.8050402@linux.vnet.ibm.com>
Date: Fri, 05 Aug 2011 15:18:35 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
CC: Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>,
        Len Brown <len.brown@intel.com>, linux-pm@lists.linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 5/5] cpuidle: stop depending on pm_idle
References: <8e24ed2af46a5d008d85bfeb128d25efc394a3fd.1312400543.git.len.brown@intel.com> <1312400648-17636-1-git-send-email-lenb@kernel.org> <619b3f9e65307529dd4bbc98efe9d2f3b632646c.1312400543.git.len.brown@intel.com> <CAAXLqgrnRi25WM2HpHxe-R4ePrgdbVROky4+=3Jr489M7zbgUA@mail.gmail.com>
In-Reply-To: <CAAXLqgrnRi25WM2HpHxe-R4ePrgdbVROky4+=3Jr489M7zbgUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,
The following code would not compile on ARM.
The patch for this has already been posted by Trinabh
earlier on, in the following link.
https://lkml.org/lkml/2011/4/25/54

On Thursday 04 August 2011 10:51 PM, Trinabh Gupta wrote:
> 
> 
> On Wed, Aug 3, 2011 at 12:44 PM, Len Brown <lenb@kernel.org <mailto:lenb@kernel.org>> wrote:
> 
>     From: Len Brown <len.brown@intel.com <mailto:len.brown@intel.com>>
> 
>     cpuidle users should call cpuidle_call_idle() directly
>     rather than via (pm_idle)() function pointer.
> 
>     Architecture may choose to continue using (pm_idle)(),
>     but cpuidle need not depend on it:
> 
>      my_arch_cpu_idle()
>            ...
>            if(cpuidle_call_idle())
>                    pm_idle();
> 
>     cc: x86@kernel.org <mailto:x86@kernel.org>
>     cc: Kevin Hilman <khilman@deeprootsystems.com <mailto:khilman@deeprootsystems.com>>
>     cc: Paul Mundt <lethal@linux-sh.org <mailto:lethal@linux-sh.org>>
>     Signed-off-by: Len Brown <len.brown@intel.com <mailto:len.brown@intel.com>>
>     ---
>      arch/arm/kernel/process.c    |    4 +++-
>      arch/sh/kernel/idle.c        |    6 ++++--
>      arch/x86/kernel/process_32.c |    4 +++-
>      arch/x86/kernel/process_64.c |    4 +++-
>      drivers/cpuidle/cpuidle.c    |   38 ++++++++++++++++++--------------------
>      include/linux/cpuidle.h      |    2 ++
>      6 files changed, 33 insertions(+), 25 deletions(-)
> 
>     diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
>     index 5e1e541..d7ee0d4 100644
>     --- a/arch/arm/kernel/process.c
>     +++ b/arch/arm/kernel/process.c
>     @@ -30,6 +30,7 @@
>      #include <linux/uaccess.h>
>      #include <linux/random.h>
>      #include <linux/hw_breakpoint.h>
>     +#include <linux/cpuidle.h>
> 
>      #include <asm/cacheflush.h>
>      #include <asm/leds.h>
>     @@ -196,7 +197,8 @@ void cpu_idle(void)
>                                    cpu_relax();
>                            } else {
>                                    stop_critical_timings();
>     -                               pm_idle();
>     +                               if (cpuidle_call_idle())
> 
> 
> Hi Len,
> 
> This should be cpuidle_idle_call()
>  
> 
>     +                                       pm_idle();
>                                    start_critical_timings();
>                                    /*
>                                     * This will eventually be removed - pm_idle
>     diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
>     index 425d604..9c7099e 100644
>     --- a/arch/sh/kernel/idle.c
>     +++ b/arch/sh/kernel/idle.c
>     @@ -16,12 +16,13 @@
>      #include <linux/thread_info.h>
>      #include <linux/irqflags.h>
>      #include <linux/smp.h>
>     +#include <linux/cpuidle.h>
>      #include <asm/pgalloc.h>
>      #include <asm/system.h>
>      #include <asm/atomic.h>
>      #include <asm/smp.h>
> 
>     -void (*pm_idle)(void) = NULL;
>     +static void (*pm_idle)(void);
> 
>      static int hlt_counter;
> 
>     @@ -100,7 +101,8 @@ void cpu_idle(void)
>                            local_irq_disable();
>                            /* Don't trace irqs off for idle */
>                            stop_critical_timings();
>     -                       pm_idle();
>     +                       if (cpuidle_call_idle())
> 
>  
> Again this should be cpuidle_idle_call() 
> 
>     +                               pm_idle();
>                            /*
>                             * Sanity check to ensure that pm_idle() returns
>                             * with IRQs enabled
>     diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
>     index a3d0dc5..7a3b651 100644
>     --- a/arch/x86/kernel/process_32.c
>     +++ b/arch/x86/kernel/process_32.c
>     @@ -38,6 +38,7 @@
>      #include <linux/uaccess.h>
>      #include <linux/io.h>
>      #include <linux/kdebug.h>
>     +#include <linux/cpuidle.h>
> 
>      #include <asm/pgtable.h>
>      #include <asm/system.h>
>     @@ -109,7 +110,8 @@ void cpu_idle(void)
>                            local_irq_disable();
>                            /* Don't trace irqs off for idle */
>                            stop_critical_timings();
>     -                       pm_idle();
>     +                       if (cpuidle_idle_call())
>     +                               pm_idle();
>                            start_critical_timings();
>                    }
>                    tick_nohz_restart_sched_tick();
>     diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
>     index ca6f7ab..f693e44 100644
>     --- a/arch/x86/kernel/process_64.c
>     +++ b/arch/x86/kernel/process_64.c
>     @@ -37,6 +37,7 @@
>      #include <linux/uaccess.h>
>      #include <linux/io.h>
>      #include <linux/ftrace.h>
>     +#include <linux/cpuidle.h>
> 
>      #include <asm/pgtable.h>
>      #include <asm/system.h>
>     @@ -136,7 +137,8 @@ void cpu_idle(void)
>                            enter_idle();
>                            /* Don't trace irqs off for idle */
>                            stop_critical_timings();
>     -                       pm_idle();
>     +                       if (cpuidle_idle_call())
>     +                               pm_idle();
>                            start_critical_timings();
> 
>                            /* In many cases the interrupt that ended idle
>     diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>     index 041df0b..d4c5423 100644
>     --- a/drivers/cpuidle/cpuidle.c
>     +++ b/drivers/cpuidle/cpuidle.c
>     @@ -25,10 +25,10 @@ DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
> 
>      DEFINE_MUTEX(cpuidle_lock);
>      LIST_HEAD(cpuidle_detected_devices);
>     -static void (*pm_idle_old)(void);
> 
>      static int enabled_devices;
>      static int off __read_mostly;
>     +static int initialized __read_mostly;
> 
>      int cpuidle_disabled(void)
>      {
>     @@ -56,25 +56,23 @@ static int __cpuidle_register_device(struct cpuidle_device *dev);
>      * cpuidle_idle_call - the main idle loop
>      *
>      * NOTE: no locks or semaphores should be used here
>     + * return non-zero on failure
>      */
>     -static void cpuidle_idle_call(void)
>     +int cpuidle_idle_call(void)
>      {
>            struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
>            struct cpuidle_state *target_state;
>            int next_state;
> 
>     +       if (off)
>     +               return -ENODEV;
>     +
>     +       if (!initialized)
>     +               return -ENODEV;
>     +
>            /* check if the device is ready */
>     -       if (!dev || !dev->enabled) {
>     -               if (pm_idle_old)
>     -                       pm_idle_old();
>     -               else
>     -#if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
>     -                       default_idle();
>     -#else
>     -                       local_irq_enable();
>     -#endif
>     -               return;
>     -       }
>     +       if (!dev || !dev->enabled)
>     +               return -EBUSY;
> 
>      #if 0
>            /* shows regressions, re-enable for 2.6.29 */
>     @@ -99,7 +97,7 @@ static void cpuidle_idle_call(void)
>            next_state = cpuidle_curr_governor->select(dev);
>            if (need_resched()) {
>                    local_irq_enable();
>     -               return;
>     +               return 0;
>            }
> 
>            target_state = &dev->states[next_state];
>     @@ -124,6 +122,8 @@ static void cpuidle_idle_call(void)
>            /* give the governor an opportunity to reflect on the outcome */
>            if (cpuidle_curr_governor->reflect)
>                    cpuidle_curr_governor->reflect(dev);
>     +
>     +       return 0;
>      }
> 
>      /**
>     @@ -131,10 +131,10 @@ static void cpuidle_idle_call(void)
>      */
>      void cpuidle_install_idle_handler(void)
>      {
>     -       if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
>     +       if (enabled_devices) {
>                    /* Make sure all changes finished before we switch to new idle */
>                    smp_wmb();
>     -               pm_idle = cpuidle_idle_call;
>     +               initialized = 1;
>            }
>      }
> 
>     @@ -143,8 +143,8 @@ void cpuidle_install_idle_handler(void)
>      */
>      void cpuidle_uninstall_idle_handler(void)
>      {
>     -       if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
>     -               pm_idle = pm_idle_old;
>     +       if (enabled_devices) {
>     +               initialized = 0;
>                    cpuidle_kick_cpus();
>            }
>      }
>     @@ -440,8 +440,6 @@ static int __init cpuidle_init(void)
>            if (cpuidle_disabled())
>                    return -ENODEV;
> 
>     -       pm_idle_old = pm_idle;
>     -
>            ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
>            if (ret)
>                    return ret;
>     diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
>     index b89f67d..b51629e 100644
>     --- a/include/linux/cpuidle.h
>     +++ b/include/linux/cpuidle.h
>     @@ -123,6 +123,7 @@ struct cpuidle_driver {
> 
>      #ifdef CONFIG_CPU_IDLE
>      extern void disable_cpuidle(void);
>     +extern int cpuidle_idle_call(void);
> 
>      extern int cpuidle_register_driver(struct cpuidle_driver *drv);
>      struct cpuidle_driver *cpuidle_get_driver(void);
>     @@ -137,6 +138,7 @@ extern void cpuidle_disable_device(struct cpuidle_device *dev);
> 
>      #else
>      static inline void disable_cpuidle(void) { }
>     +static inline int cpuidle_idle_call(void) { return -ENODEV; }
> 
>      static inline int cpuidle_register_driver(struct cpuidle_driver *drv)
>      {return -ENODEV; }
>     --
>     1.7.6.396.ge0613
> 
>     _______________________________________________
>     linux-pm mailing list
>     linux-pm@lists.linux-foundation.org <mailto:linux-pm@lists.linux-foundation.org>
>     https://lists.linux-foundation.org/mailman/listinfo/linux-pm
> 
> 
> 
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
Regards,
Deepthi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0G1VVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:21:16 -0400
Received: from imr3.ericy.com ([198.24.6.13]:35955 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab0G1VVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:21:12 -0400
Subject: Re: [PATH V2 4/5] Package Level Thermal Control and Power Limit
 Notification: power limit
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <1280343653-26380-5-git-send-email-fenghua.yu@intel.com>
References: <1280343653-26380-1-git-send-email-fenghua.yu@intel.com>
	 <1280343653-26380-5-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Wed, 28 Jul 2010 14:17:40 -0700
Message-ID: <1280351860.17322.1.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-28 at 15:00 -0400, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Power limit notification feature is published in Intel 64 and IA-32
> Architectures SDMV Vol 3A 14.5.6 Power Limit Notification.
> 
> It is implemented first on Intel Sandy Bridge platform.
> 
> The patch handles notification interrupt. Interrupt handler dumps power limit
> information in log_buf, logs the event in mce log, and increases the event
> counters (core_power_limit and package_power_limit). Upper level applications
> could use the data to detect system health or diagnose functionality/performance
> issues.
> 
> In the future, the event could be handled in a more fancy way.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> Reviewed-by: Len Brown <len.brown@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h         |    4 +
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |  186 +++++++++++++++++++++---------
>  2 files changed, 136 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index f1c1b82..f3c8a7a 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -226,10 +226,12 @@
> 
>  #define THERM_INT_HIGH_ENABLE          (1 << 0)
>  #define THERM_INT_LOW_ENABLE           (1 << 1)
> +#define THERM_INT_PLN_ENABLE           (1 << 24)
> 
>  #define MSR_IA32_THERM_STATUS          0x0000019c
> 
>  #define THERM_STATUS_PROCHOT           (1 << 0)
> +#define THERM_STATUS_POWER_LIMIT       (1 << 10)
> 
>  #define MSR_THERM2_CTL                 0x0000019d
> 
> @@ -242,11 +244,13 @@
>  #define MSR_IA32_PACKAGE_THERM_STATUS          0x000001b1
> 
>  #define PACKAGE_THERM_STATUS_PROCHOT           (1 << 0)
> +#define PACKAGE_THERM_STATUS_POWER_LIMIT       (1 << 10)
> 
>  #define MSR_IA32_PACKAGE_THERM_INTERRUPT       0x000001b2
> 
>  #define PACKAGE_THERM_INT_HIGH_ENABLE          (1 << 0)
>  #define PACKAGE_THERM_INT_LOW_ENABLE           (1 << 1)
> +#define PACKAGE_THERM_INT_PLN_ENABLE           (1 << 24)
> 
>  /* MISC_ENABLE bits: architectural */
>  #define MSR_IA32_MISC_ENABLE_FAST_STRING       (1ULL << 0)
> diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> index d307f9f..0c3d1e0 100644
> --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> @@ -34,20 +34,25 @@
>  /* How long to wait between reporting thermal events */
>  #define CHECK_INTERVAL         (300 * HZ)
> 
> +#define THERMAL_THROTTLING_EVENT       0
> +#define POWER_LIMIT_EVENT              1
> +
>  /*
> - * Current thermal throttling state:
> + * Current thermal event state:
>   */
>  struct _thermal_state {
> -       bool                    is_throttled;
> -
> +       bool                    new_event;
> +       int                     event;
>         u64                     next_check;
> -       unsigned long           throttle_count;
> -       unsigned long           last_throttle_count;
> +       unsigned long           count;
> +       unsigned long           last_count;
>  };
> 
>  struct thermal_state {
> -       struct _thermal_state core;
> -       struct _thermal_state package;
> +       struct _thermal_state core_throttle;
> +       struct _thermal_state core_power_limit;
> +       struct _thermal_state package_throttle;
> +       struct _thermal_state package_power_limit;
>  };
> 
>  static DEFINE_PER_CPU(struct thermal_state, thermal_state);
> @@ -62,9 +67,9 @@ static u32 lvtthmr_init __read_mostly;
>                            therm_throt_sysdev_show_##_name,             \
>                                    NULL)                                \
> 
> -#define define_therm_throt_sysdev_show_func(level, name)               \
> +#define define_therm_throt_sysdev_show_func(event, name)               \
>                                                                         \
> -static ssize_t therm_throt_sysdev_show_##level##_##name(               \
> +static ssize_t therm_throt_sysdev_show_##event##_##name(               \
>                         struct sys_device *dev,                         \
>                         struct sysdev_attribute *attr,                  \
>                         char *buf)                                      \
> @@ -75,7 +80,7 @@ static ssize_t therm_throt_sysdev_show_##level##_##name(              \
>         preempt_disable();      /* CPU hotplug */                       \
>         if (cpu_online(cpu)) {                                          \
>                 ret = sprintf(buf, "%lu\n",                             \
> -                             per_cpu(thermal_state, cpu).level.name);  \
> +                             per_cpu(thermal_state, cpu).event.name);  \
>         } else                                                          \
>                 ret = 0;                                                \
>         preempt_enable();                                               \
> @@ -83,23 +88,32 @@ static ssize_t therm_throt_sysdev_show_##level##_##name(            \
>         return ret;                                                     \
>  }
> 
> -define_therm_throt_sysdev_show_func(core, throttle_count);
> +define_therm_throt_sysdev_show_func(core_throttle, count);
>  define_therm_throt_sysdev_one_ro(core_throttle_count);
> 
> -define_therm_throt_sysdev_show_func(package, throttle_count);
> +define_therm_throt_sysdev_show_func(core_power_limit, count);
> +define_therm_throt_sysdev_one_ro(core_power_limit_count);
> +
> +define_therm_throt_sysdev_show_func(package_throttle, count);
>  define_therm_throt_sysdev_one_ro(package_throttle_count);
> 
> +define_therm_throt_sysdev_show_func(package_power_limit, count);
> +define_therm_throt_sysdev_one_ro(package_power_limit_count);
> +
>  static struct attribute *thermal_throttle_attrs[] = {
>         &attr_core_throttle_count.attr,
>         NULL
>  };
> 
> -static struct attribute_group thermal_throttle_attr_group = {
> +static struct attribute_group thermal_attr_group = {
>         .attrs  = thermal_throttle_attrs,
>         .name   = "thermal_throttle"
>  };
>  #endif /* CONFIG_SYSFS */
> 
> +#define CORE_LEVEL     0
> +#define PACKAGE_LEVEL  1
> +
>  /***
>   * therm_throt_process - Process thermal throttling event from interrupt
>   * @curr: Whether the condition is current or not (boolean), since the
> @@ -116,49 +130,73 @@ static struct attribute_group thermal_throttle_attr_group = {
>   *          1 : Event should be logged further, and a message has been
>   *              printed to the syslog.
>   */
> -#define CORE_LEVEL     0
> -#define PACKAGE_LEVEL  1
> -static int therm_throt_process(bool is_throttled, int level)
> +static int therm_throt_process(bool new_event, int event, int level)
>  {
>         struct _thermal_state *state;
> -       unsigned int this_cpu;
> -       bool was_throttled;
> +       unsigned int this_cpu = smp_processor_id();
> +       bool old_event;
>         u64 now;
> +       struct thermal_state *pstate = &per_cpu(thermal_state, this_cpu);
> +
> +       if (!new_event)
> +               return 0;
> 
As a result of this check and return, events will never be reset.

> -       this_cpu = smp_processor_id();
>         now = get_jiffies_64();
> -       if (level == CORE_LEVEL)
> -               state = &per_cpu(thermal_state, this_cpu).core;
> -       else
> -               state = &per_cpu(thermal_state, this_cpu).package;
> +       if (level == CORE_LEVEL) {
> +               if (event == THERMAL_THROTTLING_EVENT)
> +                       state = &pstate->core_throttle;
> +               else if (event == POWER_LIMIT_EVENT)
> +                       state = &pstate->core_power_limit;
> +               else
> +                        return 0;
> +       } else if (level == PACKAGE_LEVEL) {
> +               if (event == THERMAL_THROTTLING_EVENT)
> +                       state = &pstate->package_throttle;
> +               else if (event == POWER_LIMIT_EVENT)
> +                       state = &pstate->package_power_limit;
> +               else
> +                       return 0;
> +       } else
> +               return 0;
> 
> -       was_throttled = state->is_throttled;
> -       state->is_throttled = is_throttled;
> +       old_event = state->new_event;
> +       state->new_event = new_event;
> 
> -       if (is_throttled)
> -               state->throttle_count++;
> +       if (new_event)
> +               state->count++;
> 
>         if (time_before64(now, state->next_check) &&
> -                       state->throttle_count != state->last_throttle_count)
> +                       state->count != state->last_count)
>                 return 0;
> 
>         state->next_check = now + CHECK_INTERVAL;
> -       state->last_throttle_count = state->throttle_count;
> +       state->last_count = state->count;
> 
>         /* if we just entered the thermal event */
> -       if (is_throttled) {
> -               printk(KERN_CRIT "CPU%d: %s temperature above threshold, cpu clock throttled (total events = %lu)\n",
> -                     this_cpu,
> -                     level == CORE_LEVEL ? "Core" : "Package",
> -                     state->throttle_count);
> +       if (new_event) {
> +               if (event == THERMAL_THROTTLING_EVENT)
> +                       printk(KERN_CRIT "CPU%d: %s temperature above threshold, cpu clock throttled (total events = %lu)\n",
> +                               this_cpu,
> +                               level == CORE_LEVEL ? "Core" : "Package",
> +                               state->count);
> +               else
> +                       printk(KERN_CRIT "CPU%d: %s power limit notification (total events = %lu)\n",
> +                               this_cpu,
> +                               level == CORE_LEVEL ? "Core" : "Package",
> +                               state->count);
> 
>                 add_taint(TAINT_MACHINE_CHECK);
>                 return 1;
>         }

Since new_event is always true, code below will never be executed.
That doesn't make sense to me.

> -       if (was_throttled) {
> -               printk(KERN_INFO "CPU%d: %s temperature/speed normal\n",
> -                      this_cpu,
> -                      level == CORE_LEVEL ? "Core" : "Package");
> +       if (old_event) {
> +               if (event == THERMAL_THROTTLING_EVENT)
> +                       printk(KERN_INFO "CPU%d: %s temperature/speed normal\n",
> +                               this_cpu,
> +                               level == CORE_LEVEL ? "Core" : "Package");
> +               else
> +                       printk(KERN_INFO "CPU%d: %s power limit normal\n",
> +                               this_cpu,
> +                               level == CORE_LEVEL ? "Core" : "Package");
>                 return 1;
>         }
> 
> @@ -172,21 +210,29 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
>         int err;
>         struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> 
> -       err = sysfs_create_group(&sys_dev->kobj, &thermal_throttle_attr_group);
> +       err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
>         if (err)
>                 return err;
> 
> +       if (cpu_has(c, X86_FEATURE_PLN))
> +               err = sysfs_add_file_to_group(&sys_dev->kobj,
> +                                             &attr_core_power_limit_count.attr,
> +                                             thermal_attr_group.name);
>         if (cpu_has(c, X86_FEATURE_PTS))
>                 err = sysfs_add_file_to_group(&sys_dev->kobj,
>                                               &attr_package_throttle_count.attr,
> -                                             thermal_throttle_attr_group.name);
> +                                             thermal_attr_group.name);
> +               if (cpu_has(c, X86_FEATURE_PLN))
> +                       err = sysfs_add_file_to_group(&sys_dev->kobj,
> +                                       &attr_package_power_limit_count.attr,
> +                                       thermal_attr_group.name);
> 
>         return err;
>  }
> 
>  static __cpuinit void thermal_throttle_remove_dev(struct sys_device *sys_dev)
>  {
> -       sysfs_remove_group(&sys_dev->kobj, &thermal_throttle_attr_group);
> +       sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
>  }
> 
>  /* Mutex protecting device creation against CPU hotplug: */
> @@ -257,6 +303,17 @@ device_initcall(thermal_throttle_init_device);
> 
>  #endif /* CONFIG_SYSFS */
> 
> +/*
> + * Set up the most two significant bit to notify mce log that this thermal
> + * event type.
> + * This is a temp solution. May be changed in the future with mce log
> + * infrasture.
> + */
> +#define CORE_THROTTLED         (0)
> +#define CORE_POWER_LIMIT       ((__u64)1 << 62)
> +#define PACKAGE_THROTTLED      ((__u64)2 << 62)
> +#define PACKAGE_POWER_LIMIT    ((__u64)3 << 62)
> +
>  /* Thermal transition interrupt handler */
>  static void intel_thermal_interrupt(void)
>  {
> @@ -264,21 +321,31 @@ static void intel_thermal_interrupt(void)
>         struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
> 
>         rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
> +
>         if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT,
> +                               THERMAL_THROTTLING_EVENT,
>                                 CORE_LEVEL) != 0)
> -               mce_log_therm_throt_event(msr_val);
> +               mce_log_therm_throt_event(CORE_THROTTLED | msr_val);
> +
> +       if (cpu_has(c, X86_FEATURE_PLN))
> +               if (therm_throt_process(msr_val & THERM_STATUS_POWER_LIMIT,
> +                                       POWER_LIMIT_EVENT,
> +                                       CORE_LEVEL) != 0)
> +                       mce_log_therm_throt_event(CORE_POWER_LIMIT | msr_val);
> 
>         if (cpu_has(c, X86_FEATURE_PTS)) {
>                 rdmsrl(MSR_IA32_PACKAGE_THERM_STATUS, msr_val);
>                 if (therm_throt_process(msr_val & PACKAGE_THERM_STATUS_PROCHOT,
> +                                       THERMAL_THROTTLING_EVENT,
>                                         PACKAGE_LEVEL) != 0)
> -                       /*
> -                        * Set up the most significant bit to notify mce log
> -                        * that this thermal event is a package level event.
> -                        * This is a temp solution. May be changed in the future
> -                        * with mce log infrasture.
> -                        */
> -                       mce_log_therm_throt_event(((__u64)1 << 63) | msr_val);
> +                       mce_log_therm_throt_event(PACKAGE_THROTTLED | msr_val);
> +               if (cpu_has(c, X86_FEATURE_PLN))
> +                       if (therm_throt_process(msr_val &
> +                                       PACKAGE_THERM_STATUS_POWER_LIMIT,
> +                                       POWER_LIMIT_EVENT,
> +                                       PACKAGE_LEVEL) != 0)
> +                               mce_log_therm_throt_event(PACKAGE_POWER_LIMIT
> +                                                         | msr_val);
>         }
>  }
> 
> @@ -381,14 +448,25 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
>         apic_write(APIC_LVTTHMR, h);
> 
>         rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
> -       wrmsr(MSR_IA32_THERM_INTERRUPT,
> -               l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
> +       if (cpu_has(c, X86_FEATURE_PLN))
> +               wrmsr(MSR_IA32_THERM_INTERRUPT,
> +                     l | (THERM_INT_LOW_ENABLE
> +                       | THERM_INT_HIGH_ENABLE | THERM_INT_PLN_ENABLE), h);
> +       else
> +               wrmsr(MSR_IA32_THERM_INTERRUPT,
> +                     l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
> 
>         if (cpu_has(c, X86_FEATURE_PTS)) {
>                 rdmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, l, h);
> -               wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT,
> -                       l | (PACKAGE_THERM_INT_LOW_ENABLE
> -                 | PACKAGE_THERM_INT_HIGH_ENABLE), h);
> +               if (cpu_has(c, X86_FEATURE_PLN))
> +                       wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT,
> +                             l | (PACKAGE_THERM_INT_LOW_ENABLE
> +                               | PACKAGE_THERM_INT_HIGH_ENABLE
> +                               | PACKAGE_THERM_INT_PLN_ENABLE), h);
> +               else
> +                       wrmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT,
> +                             l | (PACKAGE_THERM_INT_LOW_ENABLE
> +                               | PACKAGE_THERM_INT_HIGH_ENABLE), h);
>         }
> 
>         smp_thermal_vector = intel_thermal_interrupt;
> --
> 1.7.2
> 



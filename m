Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1HIEuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 00:50:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40222 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HIEt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 00:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B5B8057C306@shsmsx502.ccr.corp.intel.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B8057C306@shsmsx502.ccr.corp.intel.com>
Date: Tue, 9 Aug 2011 13:49:57 +0900
Message-ID: <CAJ0PZbQ4Bk7Up9texX2hU8NP583da7UP9Hk3GRHE6-VKsg69kA@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH v3] PM: add statistics debugfs file for suspend
 to ram
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Liu, ShuoX" <shuox.liu@intel.com>
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>,
        Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 11:27 AM, Liu, ShuoX <shuox.liu@intel.com> wrote:
> From: ShuoX Liu <shuox.liu@intel.com>
>
> Record S3 failure time about each reason and the latest two failed
> devices' names in S3 progress.
> We can check it through 'suspend_stats' entry in debugfs.
>
> The motivation of the patch:
>
> We are enabling power features on Medfield. Comparing with PC/notebook,
> a mobile enters/exits suspend-2-ram (we call it s3 on Medfield) far
> more frequently. If it can't enter suspend-2-ram in time, the power
> might be used up soon.
>
> We often find sometimes, a device suspend fails. Then, system retries
> s3 over and over again. As display is off, testers and developers
> don't know what happens.
>
> Some testers and developers complain they don't know if system
> tries suspend-2-ram, and what device fails to suspend. They need
> such info for a quick check. The patch adds suspend_stats under
> debugfs for users to check suspend to RAM statistics quickly.
>
> If not using this patch, we have other methods to get info about
> what device fails. One is to turn on  CONFIG_PM_DEBUG, but users
> would get too much info and testers need recompile the system.
>
> In addition, dynamic debug is another good tool to dump debug info.
> But it still doesn't match our utilization scenario closely.
> 1) user need write a user space parser to process the syslog output;
> 2) Our testing scenario is we leave the mobile for at least hours.
>   Then, check its status. No serial console available during the
>   testing. One is because console would be suspended, and the other
>   is serial console connecting with spi or HSU devices would consume
>   power. These devices are powered off at suspend-2-ram.
>
> Thank Greg and Rafael for their great comments.
>
> Change Log:
>  V3: Change some programming styles.
>  V2:
>        1) Change the sysfs entry to debugfs.
>        2) Add some explanation in document file.
>
> Contribution:
>        yanmin_zhang@linux.intel.com
>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
>  Documentation/power/basic-pm-debugging.txt |   19 +++++++++
>  drivers/base/power/main.c                  |   35 ++++++++++++++--
>  include/linux/suspend.h                    |   16 +++++++
>  kernel/power/main.c                        |   59 ++++++++++++++++++++++++++++
>  kernel/power/suspend.c                     |   15 ++++++-
>  5 files changed, 136 insertions(+), 8 deletions(-)
>

This patch looks very helpful. Great! :)

Anyway, how about including the error value induced by the device
along with the device name?
For example,

failed_devs:
         last_failed: alarm -5
                      adc -10

or

failed_devs:
         last_failed: alarm
                      adc
         last_errorno: -5
                      -10

Or, even, we may consider including the failed step:
failed_devs:
         last_failed: alarm
                      adc
         last_errorno: -5
                      -10
         last_step: suspend
                      suspend_noirq


Cheers!
MyungJoo

> diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
> index ddd7817..acbd3e0 100644
> --- a/Documentation/power/basic-pm-debugging.txt
> +++ b/Documentation/power/basic-pm-debugging.txt
> @@ -201,3 +201,22 @@ case, you may be able to search for failing drivers by following the procedure
>  analogous to the one described in section 1.  If you find some failing drivers,
>  you will have to unload them every time before an STR transition (ie. before
>  you run s2ram), and please report the problems with them.
> +
> +There is a debugfs entry which shows the suspend to RAM statistics. Here is an
> +example of its output.
> +       # mount -t debugfs none /sys/kernel/debug
> +       # cat /sys/kernel/debug/suspend_stats
> +       success: 20
> +       fail: 5
> +       failed_freeze: 0
> +       failed_prepare: 0
> +       failed_suspend: 5
> +       failed_suspend_noirq: 0
> +       failed_resume: 0
> +       failed_resume_noirq: 0
> +       failed_devs:
> +         last_failed: alarm
> +                      adc
> +Field success means the success number of suspend to RAM, and field fail means
> +the failure number. Others are the failure number of different steps of suspend
> +to RAM. suspend_stats just lists the last 2 failed devices.
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index a854591..111f86c 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -46,6 +46,7 @@ LIST_HEAD(dpm_prepared_list);
>  LIST_HEAD(dpm_suspended_list);
>  LIST_HEAD(dpm_noirq_list);
>
> +struct suspend_stats suspend_stats;
>  static DEFINE_MUTEX(dpm_list_mtx);
>  static pm_message_t pm_transition;
>
> @@ -180,6 +181,15 @@ static void initcall_debug_report(struct device *dev, ktime_t calltime,
>        }
>  }
>
> +static void dpm_save_dev_name(const char *name)
> +{
> +       strlcpy(suspend_stats.failed_devs[suspend_stats.last_failed],
> +               name,
> +               sizeof(suspend_stats.failed_devs[0]));
> +       suspend_stats.last_failed++;
> +       suspend_stats.last_failed %= REC_FAILED_DEV_NUM;
> +}
> +
>  /**
>  * dpm_wait - Wait for a PM operation to complete.
>  * @dev: Device to wait for.
> @@ -464,8 +474,11 @@ void dpm_resume_noirq(pm_message_t state)
>                mutex_unlock(&dpm_list_mtx);
>
>                error = device_resume_noirq(dev, state);
> -               if (error)
> +               if (error) {
> +                       suspend_stats.failed_resume_noirq++;
> +                       dpm_save_dev_name(dev_name(dev));
>                        pm_dev_err(dev, state, " early", error);
> +               }
>
>                mutex_lock(&dpm_list_mtx);
>                put_device(dev);
> @@ -626,8 +639,11 @@ void dpm_resume(pm_message_t state)
>                        mutex_unlock(&dpm_list_mtx);
>
>                        error = device_resume(dev, state, false);
> -                       if (error)
> +                       if (error) {
> +                               suspend_stats.failed_resume++;
> +                               dpm_save_dev_name(dev_name(dev));
>                                pm_dev_err(dev, state, "", error);
> +                       }
>
>                        mutex_lock(&dpm_list_mtx);
>                }
> @@ -802,6 +818,8 @@ int dpm_suspend_noirq(pm_message_t state)
>                mutex_lock(&dpm_list_mtx);
>                if (error) {
>                        pm_dev_err(dev, state, " late", error);
> +                       suspend_stats.failed_suspend_noirq++;
> +                       dpm_save_dev_name(dev_name(dev));
>                        put_device(dev);
>                        break;
>                }
> @@ -923,8 +941,10 @@ static void async_suspend(void *data, async_cookie_t cookie)
>        int error;
>
>        error = __device_suspend(dev, pm_transition, true);
> -       if (error)
> +       if (error) {
> +               dpm_save_dev_name(dev_name(dev));
>                pm_dev_err(dev, pm_transition, " async", error);
> +       }
>
>        put_device(dev);
>  }
> @@ -967,6 +987,7 @@ int dpm_suspend(pm_message_t state)
>                mutex_lock(&dpm_list_mtx);
>                if (error) {
>                        pm_dev_err(dev, state, "", error);
> +                       dpm_save_dev_name(dev_name(dev));
>                        put_device(dev);
>                        break;
>                }
> @@ -980,7 +1001,9 @@ int dpm_suspend(pm_message_t state)
>        async_synchronize_full();
>        if (!error)
>                error = async_error;
> -       if (!error)
> +       if (error)
> +               suspend_stats.failed_suspend++;
> +       else
>                dpm_show_time(starttime, state, NULL);
>        return error;
>  }
> @@ -1088,7 +1111,9 @@ int dpm_suspend_start(pm_message_t state)
>        int error;
>
>        error = dpm_prepare(state);
> -       if (!error)
> +       if (error)
> +               suspend_stats.failed_prepare++;
> +       else
>                error = dpm_suspend(state);
>        return error;
>  }
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 6bbcef2..6a8ff23 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -34,6 +34,22 @@ typedef int __bitwise suspend_state_t;
>  #define PM_SUSPEND_MEM         ((__force suspend_state_t) 3)
>  #define PM_SUSPEND_MAX         ((__force suspend_state_t) 4)
>
> +struct suspend_stats {
> +       int     success;
> +       int     fail;
> +       int     failed_freeze;
> +       int     failed_prepare;
> +       int     failed_suspend;
> +       int     failed_suspend_noirq;
> +       int     failed_resume;
> +       int     failed_resume_noirq;
> +#define        REC_FAILED_DEV_NUM      2
> +       char    failed_devs[REC_FAILED_DEV_NUM][40];
> +       int     last_failed;
> +};
> +
> +extern struct suspend_stats suspend_stats;
> +
>  /**
>  * struct platform_suspend_ops - Callbacks for managing platform dependent
>  *     system sleep states.
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 6c601f8..0977f5d 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -12,6 +12,8 @@
>  #include <linux/string.h>
>  #include <linux/resume-trace.h>
>  #include <linux/workqueue.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
>
>  #include "power.h"
>
> @@ -133,6 +135,59 @@ power_attr(pm_test);
>
>  #endif /* CONFIG_PM_SLEEP */
>
> +#ifdef CONFIG_DEBUG_FS
> +static int suspend_stats_show(struct seq_file *s, void *unused)
> +{
> +       int i, index, last_index;
> +
> +       last_index = suspend_stats.last_failed + REC_FAILED_DEV_NUM - 1;
> +       last_index %= REC_FAILED_DEV_NUM;
> +       seq_printf(s, "%s: %d\n%s: %d\n%s: %d\n%s: %d\n"
> +                       "%s: %d\n%s: %d\n%s: %d\n%s: %d\n",
> +                       "success", suspend_stats.success,
> +                       "fail", suspend_stats.fail,
> +                       "failed_freeze", suspend_stats.failed_freeze,
> +                       "failed_prepare", suspend_stats.failed_prepare,
> +                       "failed_suspend", suspend_stats.failed_suspend,
> +                       "failed_suspend_noirq",
> +                               suspend_stats.failed_suspend_noirq,
> +                       "failed_resume", suspend_stats.failed_resume,
> +                       "failed_resume_noirq",
> +                               suspend_stats.failed_resume_noirq);
> +       seq_printf(s,   "failed_devs:\n  last_failed:\t%s\n",
> +                       suspend_stats.failed_devs[last_index]);
> +       for (i = 1; i < REC_FAILED_DEV_NUM; i++) {
> +               index = last_index + REC_FAILED_DEV_NUM - i;
> +               index %= REC_FAILED_DEV_NUM;
> +               seq_printf(s, "\t\t%s\n",
> +                       suspend_stats.failed_devs[index]);
> +       }
> +
> +       return 0;
> +}
> +
> +static int suspend_stats_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, suspend_stats_show, NULL);
> +}
> +
> +static const struct file_operations suspend_stats_operations = {
> +       .open           = suspend_stats_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
> +static int __init pm_debugfs_init(void)
> +{
> +       debugfs_create_file("suspend_stats", S_IFREG | S_IRUGO,
> +                       NULL, NULL, &suspend_stats_operations);
> +       return 0;
> +}
> +
> +late_initcall(pm_debugfs_init);
> +#endif /* CONFIG_DEBUG_FS */
> +
>  struct kobject *power_kobj;
>
>  /**
> @@ -194,6 +249,10 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>        }
>        if (state < PM_SUSPEND_MAX && *s)
>                error = enter_state(state);
> +               if (error)
> +                       suspend_stats.fail++;
> +               else
> +                       suspend_stats.success++;
>  #endif
>
>  Exit:
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index b6b71ad..e5197a0 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -104,7 +104,9 @@ static int suspend_prepare(void)
>                goto Finish;
>
>        error = suspend_freeze_processes();
> -       if (!error)
> +       if (error)
> +               suspend_stats.failed_freeze++;
> +       else
>                return 0;
>
>        suspend_thaw_processes();
> @@ -315,8 +317,15 @@ int enter_state(suspend_state_t state)
>  */
>  int pm_suspend(suspend_state_t state)
>  {
> -       if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX)
> -               return enter_state(state);
> +       int ret;
> +       if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX) {
> +               ret = enter_state(state);
> +               if (ret)
> +                       suspend_stats.fail++;
> +               else
> +                       suspend_stats.success++;
> +               return ret;
> +       }
>        return -EINVAL;
>  }
>  EXPORT_SYMBOL(pm_suspend);
> --
> 1.7.1
>
>
>
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858

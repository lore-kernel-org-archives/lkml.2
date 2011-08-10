Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1HJVFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 17:05:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab1HJVFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 17:05:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Liu, ShuoX" <shuox.liu@intel.com>
Subject: Re: [PATCH v4] PM: add statistics debugfs file for suspend to ram
Date: Wed, 10 Aug 2011 23:07:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "Brown, Len" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "Yanmin_zhang@linux.intel.com" <Yanmin_zhang@linux.intel.com>
References: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
In-Reply-To: <6E3BC7F7C9A4BF4286DD4C043110F30B5B847F42F9@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108102307.20958.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 10, 2011, Liu, ShuoX wrote:
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
> what device fails. One is to turn on  CONFIG_PM_DEBUG, but users
> would get too much info and testers need recompile the system.
> 
> In addition, dynamic debug is another good tool to dump debug info.
> But it still doesn't match our utilization scenario closely.
> 1) user need write a user space parser to process the syslog output;
> 2) Our testing scenario is we leave the mobile for at least hours.
>    Then, check its status. No serial console available during the
>    testing. One is because console would be suspended, and the other
>    is serial console connecting with spi or HSU devices would consume
>    power. These devices are powered off at suspend-2-ram.
> 
> Thank Greg, MyungJoo and Rafael for their great comments.
> 
> Change Log:
>   V4: Improve output format.
>   V3: Change some programming styles.
>   V2:
> 	1) Change the sysfs entry to debugfs.
> 	2) Add some explanation in document file.
> 
> Contribution:
> 	yanmin_zhang@linux.intel.com
> 
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>

Applied to linux-pm/linux-next as 3.2 material.

Thanks,
Rafael


> ---
>  Documentation/power/basic-pm-debugging.txt |   24 +++++++
>  drivers/base/power/main.c                  |   31 +++++++--
>  include/linux/suspend.h                    |   52 ++++++++++++++
>  kernel/power/main.c                        |  102 ++++++++++++++++++++++++++++
>  kernel/power/suspend.c                     |   17 ++++-
>  5 files changed, 218 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
> index ddd7817..62eca08 100644
> --- a/Documentation/power/basic-pm-debugging.txt
> +++ b/Documentation/power/basic-pm-debugging.txt
> @@ -201,3 +201,27 @@ case, you may be able to search for failing drivers by following the procedure
>  analogous to the one described in section 1.  If you find some failing drivers,
>  you will have to unload them every time before an STR transition (ie. before
>  you run s2ram), and please report the problems with them.
> +
> +There is a debugfs entry which shows the suspend to RAM statistics. Here is an
> +example of its output.
> +	# mount -t debugfs none /sys/kernel/debug
> +	# cat /sys/kernel/debug/suspend_stats
> +	success: 20
> +	fail: 5
> +	failed_freeze: 0
> +	failed_prepare: 0
> +	failed_suspend: 5
> +	failed_suspend_noirq: 0
> +	failed_resume: 0
> +	failed_resume_noirq: 0
> +	failures:
> +	  last_failed_dev:	alarm
> +				adc
> +	  last_failed_errno:	-16
> +				-16
> +	  last_failed_step:	suspend
> +				suspend
> +Field success means the success number of suspend to RAM, and field fail means
> +the failure number. Others are the failure number of different steps of suspend
> +to RAM. suspend_stats just lists the last 2 failed devices, error number and
> +failed step of suspend.
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index a854591..23b755d 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -46,6 +46,7 @@ LIST_HEAD(dpm_prepared_list);
>  LIST_HEAD(dpm_suspended_list);
>  LIST_HEAD(dpm_noirq_list);
>  
> +struct suspend_stats suspend_stats;
>  static DEFINE_MUTEX(dpm_list_mtx);
>  static pm_message_t pm_transition;
>  
> @@ -464,8 +465,12 @@ void dpm_resume_noirq(pm_message_t state)
>  		mutex_unlock(&dpm_list_mtx);
>  
>  		error = device_resume_noirq(dev, state);
> -		if (error)
> +		if (error) {
> +			suspend_stats.failed_resume_noirq++;
> +			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
> +			dpm_save_failed_dev(dev_name(dev));
>  			pm_dev_err(dev, state, " early", error);
> +		}
>  
>  		mutex_lock(&dpm_list_mtx);
>  		put_device(dev);
> @@ -626,8 +631,12 @@ void dpm_resume(pm_message_t state)
>  			mutex_unlock(&dpm_list_mtx);
>  
>  			error = device_resume(dev, state, false);
> -			if (error)
> +			if (error) {
> +				suspend_stats.failed_resume++;
> +				dpm_save_failed_step(SUSPEND_RESUME);
> +				dpm_save_failed_dev(dev_name(dev));
>  				pm_dev_err(dev, state, "", error);
> +			}
>  
>  			mutex_lock(&dpm_list_mtx);
>  		}
> @@ -802,6 +811,9 @@ int dpm_suspend_noirq(pm_message_t state)
>  		mutex_lock(&dpm_list_mtx);
>  		if (error) {
>  			pm_dev_err(dev, state, " late", error);
> +			suspend_stats.failed_suspend_noirq++;
> +			dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
> +			dpm_save_failed_dev(dev_name(dev));
>  			put_device(dev);
>  			break;
>  		}
> @@ -923,8 +935,10 @@ static void async_suspend(void *data, async_cookie_t cookie)
>  	int error;
>  
>  	error = __device_suspend(dev, pm_transition, true);
> -	if (error)
> +	if (error) {
> +		dpm_save_failed_dev(dev_name(dev));
>  		pm_dev_err(dev, pm_transition, " async", error);
> +	}
>  
>  	put_device(dev);
>  }
> @@ -967,6 +981,7 @@ int dpm_suspend(pm_message_t state)
>  		mutex_lock(&dpm_list_mtx);
>  		if (error) {
>  			pm_dev_err(dev, state, "", error);
> +			dpm_save_failed_dev(dev_name(dev));
>  			put_device(dev);
>  			break;
>  		}
> @@ -980,7 +995,10 @@ int dpm_suspend(pm_message_t state)
>  	async_synchronize_full();
>  	if (!error)
>  		error = async_error;
> -	if (!error)
> +	if (error) {
> +		suspend_stats.failed_suspend++;
> +		dpm_save_failed_step(SUSPEND_SUSPEND);
> +	} else
>  		dpm_show_time(starttime, state, NULL);
>  	return error;
>  }
> @@ -1088,7 +1106,10 @@ int dpm_suspend_start(pm_message_t state)
>  	int error;
>  
>  	error = dpm_prepare(state);
> -	if (!error)
> +	if (error) {
> +		suspend_stats.failed_prepare++;
> +		dpm_save_failed_step(SUSPEND_PREPARE);
> +	} else
>  		error = dpm_suspend(state);
>  	return error;
>  }
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 6bbcef2..76f42e4 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -34,6 +34,58 @@ typedef int __bitwise suspend_state_t;
>  #define PM_SUSPEND_MEM		((__force suspend_state_t) 3)
>  #define PM_SUSPEND_MAX		((__force suspend_state_t) 4)
>  
> +enum suspend_stat_step {
> +	SUSPEND_FREEZE = 1,
> +	SUSPEND_PREPARE,
> +	SUSPEND_SUSPEND,
> +	SUSPEND_SUSPEND_NOIRQ,
> +	SUSPEND_RESUME_NOIRQ,
> +	SUSPEND_RESUME
> +};
> +
> +struct suspend_stats {
> +	int	success;
> +	int	fail;
> +	int	failed_freeze;
> +	int	failed_prepare;
> +	int	failed_suspend;
> +	int	failed_suspend_noirq;
> +	int	failed_resume;
> +	int	failed_resume_noirq;
> +#define	REC_FAILED_NUM	2
> +	int	last_failed_dev;
> +	char	failed_devs[REC_FAILED_NUM][40];
> +	int	last_failed_errno;
> +	int	errno[REC_FAILED_NUM];
> +	int	last_failed_step;
> +	enum suspend_stat_step	failed_steps[REC_FAILED_NUM];
> +};
> +
> +extern struct suspend_stats suspend_stats;
> +
> +static inline void dpm_save_failed_dev(const char *name)
> +{
> +	strlcpy(suspend_stats.failed_devs[suspend_stats.last_failed_dev],
> +		name,
> +		sizeof(suspend_stats.failed_devs[0]));
> +	suspend_stats.last_failed_dev++;
> +	suspend_stats.last_failed_dev %= REC_FAILED_NUM;
> +}
> +
> +static inline void dpm_save_failed_errno(int err)
> +{
> +	suspend_stats.errno[suspend_stats.last_failed_errno] = err;
> +	suspend_stats.last_failed_errno++;
> +	suspend_stats.last_failed_errno %= REC_FAILED_NUM;
> +}
> +
> +static inline void dpm_save_failed_step(enum suspend_stat_step step)
> +{
> +	suspend_stats.failed_steps[suspend_stats.last_failed_step] = step;
> +	suspend_stats.last_failed_step++;
> +	suspend_stats.last_failed_step %= REC_FAILED_NUM;
> +}
> +
>  /**
>   * struct platform_suspend_ops - Callbacks for managing platform dependent
>   *	system sleep states.
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 6c601f8..2757acb 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -12,6 +12,8 @@
>  #include <linux/string.h>
>  #include <linux/resume-trace.h>
>  #include <linux/workqueue.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
>  
>  #include "power.h"
>  
> @@ -133,6 +135,101 @@ power_attr(pm_test);
>  
>  #endif /* CONFIG_PM_SLEEP */
>  
> +#ifdef CONFIG_DEBUG_FS
> +static char *suspend_step_name(enum suspend_stat_step step)
> +{
> +	switch (step) {
> +	case SUSPEND_FREEZE:
> +		return "freeze";
> +	case SUSPEND_PREPARE:
> +		return "prepare";
> +	case SUSPEND_SUSPEND:
> +		return "suspend";
> +	case SUSPEND_SUSPEND_NOIRQ:
> +		return "suspend_noirq";
> +	case SUSPEND_RESUME_NOIRQ:
> +		return "resume_noirq";
> +	case SUSPEND_RESUME:
> +		return "resume";
> +	default:
> +		return "";
> +	}
> +}
> +
> +static int suspend_stats_show(struct seq_file *s, void *unused)
> +{
> +	int i, index, last_dev, last_errno, last_step;
> +
> +	last_dev = suspend_stats.last_failed_dev + REC_FAILED_NUM - 1;
> +	last_dev %= REC_FAILED_NUM;
> +	last_errno = suspend_stats.last_failed_errno + REC_FAILED_NUM - 1;
> +	last_errno %= REC_FAILED_NUM;
> +	last_step = suspend_stats.last_failed_step + REC_FAILED_NUM - 1;
> +	last_step %= REC_FAILED_NUM;
> +	seq_printf(s, "%s: %d\n%s: %d\n%s: %d\n%s: %d\n"
> +			"%s: %d\n%s: %d\n%s: %d\n%s: %d\n",
> +			"success", suspend_stats.success,
> +			"fail", suspend_stats.fail,
> +			"failed_freeze", suspend_stats.failed_freeze,
> +			"failed_prepare", suspend_stats.failed_prepare,
> +			"failed_suspend", suspend_stats.failed_suspend,
> +			"failed_suspend_noirq",
> +				suspend_stats.failed_suspend_noirq,
> +			"failed_resume", suspend_stats.failed_resume,
> +			"failed_resume_noirq",
> +				suspend_stats.failed_resume_noirq);
> +	seq_printf(s,	"failures:\n  last_failed_dev:\t%-s\n",
> +			suspend_stats.failed_devs[last_dev]);
> +	for (i = 1; i < REC_FAILED_NUM; i++) {
> +		index = last_dev + REC_FAILED_NUM - i;
> +		index %= REC_FAILED_NUM;
> +		seq_printf(s, "\t\t\t%-s\n",
> +			suspend_stats.failed_devs[index]);
> +	}
> +	seq_printf(s,	"  last_failed_errno:\t%-d\n",
> +			suspend_stats.errno[last_errno]);
> +	for (i = 1; i < REC_FAILED_NUM; i++) {
> +		index = last_errno + REC_FAILED_NUM - i;
> +		index %= REC_FAILED_NUM;
> +		seq_printf(s, "\t\t\t%-d\n",
> +			suspend_stats.errno[index]);
> +	}
> +	seq_printf(s,	"  last_failed_step:\t%-s\n",
> +			suspend_step_name(
> +				suspend_stats.failed_steps[last_step]));
> +	for (i = 1; i < REC_FAILED_NUM; i++) {
> +		index = last_step + REC_FAILED_NUM - i;
> +		index %= REC_FAILED_NUM;
> +		seq_printf(s, "\t\t\t%-s\n",
> +			suspend_step_name(
> +				suspend_stats.failed_steps[index]));
> +	}
> +
> +	return 0;
> +}
> +
> +static int suspend_stats_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, suspend_stats_show, NULL);
> +}
> +
> +static const struct file_operations suspend_stats_operations = {
> +	.open           = suspend_stats_open,
> +	.read           = seq_read,
> +	.llseek         = seq_lseek,
> +	.release        = single_release,
> +};
> +
> +static int __init pm_debugfs_init(void)
> +{
> +	debugfs_create_file("suspend_stats", S_IFREG | S_IRUGO,
> +			NULL, NULL, &suspend_stats_operations);
> +	return 0;
> +}
> +
> +late_initcall(pm_debugfs_init);
> +#endif /* CONFIG_DEBUG_FS */
> +
>  struct kobject *power_kobj;
>  
>  /**
> @@ -194,6 +291,11 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	}
>  	if (state < PM_SUSPEND_MAX && *s)
>  		error = enter_state(state);
> +		if (error) {
> +			suspend_stats.fail++;
> +			dpm_save_failed_errno(error);
> +		} else
> +			suspend_stats.success++;
>  #endif
>  
>   Exit:
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index b6b71ad..595a3dd 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -104,7 +104,10 @@ static int suspend_prepare(void)
>  		goto Finish;
>  
>  	error = suspend_freeze_processes();
> -	if (!error)
> +	if (error) {
> +		suspend_stats.failed_freeze++;
> +		dpm_save_failed_step(SUSPEND_FREEZE);
> +	} else
>  		return 0;
>  
>  	suspend_thaw_processes();
> @@ -315,8 +318,16 @@ int enter_state(suspend_state_t state)
>   */
>  int pm_suspend(suspend_state_t state)
>  {
> -	if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX)
> -		return enter_state(state);
> +	int ret;
> +	if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX) {
> +		ret = enter_state(state);
> +		if (ret) {
> +			suspend_stats.fail++;
> +			dpm_save_failed_errno(ret);
> +		} else
> +			suspend_stats.success++;
> +		return ret;
> +	}
>  	return -EINVAL;
>  }
>  EXPORT_SYMBOL(pm_suspend);
> 


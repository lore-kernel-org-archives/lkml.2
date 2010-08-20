Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0HTIfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:35:36 -0400
Received: from bamako.nerim.net ([62.4.17.28]:50719 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab0HTIfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:35:31 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 04:35:30 EDT
Date: Fri, 20 Aug 2010 10:26:46 +0200
From: Jean Delvare <khali@nerim.net>
To: "Fenghua Yu" <fenghua.yu@intel.com>
Cc: "Rudolf Marek" <r.marek@assembler.cz>, "Huaxu Wan" <huaxu.wan@intel.com>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Chen Gong" <gong.chen@linux.intel.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "lm-sensors" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] drivers/hwmon/coretemp: Fix incorrect hot-removed CPU's
 core sensor issue
Message-ID: <20100820102646.7659b6b7@hyperion.delvare>
In-Reply-To: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
References: <1282172027-640-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fenghua,

On Wed, 18 Aug 2010 15:53:45 -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> In current coretemp driver, when a CPU in dev_list is hot-removed, although its
> HT sibling is still running, its core sensor is gone and not available to user
> level application any more.
> 
> When a CPU is hot-removed, its core sensor should be still available to upper
> level application as long as the hot-removed CPU's HT sibling is still running.
> A core sensor is invisible to user level only when all of siblings in a core are
> hot-removed.

Good point. I admit I didn't think about this scenario when fixing the
duplicate HT entries. I thought both hyperthreads would go away at the
same time, but since then I learned that individual HT can be removed
using the sysfs "online" attributes.

That being said, I'm curious if this is really a problem in practice?
Why would one disable only one hyperthread on a given core? I can't
think of a real-world scenario.

I don't mean to suggest that we don't have to fix the problem. I'm
simply trying to figure out how fast we need to fix it, and whether the
fix is worth adding to the stable kernel series or not.

> 
> This patch fixes this issue.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  drivers/hwmon/coretemp.c |   25 ++++++++++++++++++++++---
>  1 files changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index c070c97..2257cc4 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -418,7 +418,7 @@ struct pdev_entry {
>  static LIST_HEAD(pdev_list);
>  static DEFINE_MUTEX(pdev_list_mutex);
>  
> -static int __cpuinit coretemp_device_add(unsigned int cpu)
> +static int coretemp_device_add(unsigned int cpu)
>  {
>  	int err;
>  	struct platform_device *pdev;
> @@ -483,15 +483,34 @@ exit:
>  static void coretemp_device_remove(unsigned int cpu)
>  {
>  	struct pdev_entry *p, *n;
> -	mutex_lock(&pdev_list_mutex);
> +#ifdef CONFIG_SMP
> +	int s;
> +#endif
> +
>  	list_for_each_entry_safe(p, n, &pdev_list, list) {
>  		if (p->cpu == cpu) {
> +			mutex_lock(&pdev_list_mutex);
>  			platform_device_unregister(p->pdev);
>  			list_del(&p->list);
>  			kfree(p);
> +			mutex_unlock(&pdev_list_mutex);
> +
> +#ifdef CONFIG_SMP
> +			/*
> +			 * Add removed CPU's HT sibling to dev_list.
> +			 * If there is no sibling available, the core sensor
> +			 * is invisiable to user space any more.
> +			 */
> +			for_each_cpu(s, cpu_sibling_mask(cpu)) {
> +				if (s != cpu) {
> +					coretemp_device_add(s);
> +					break;
> +				}
> +			}
> +#endif
> +			return;
>  		}
>  	}
> -	mutex_unlock(&pdev_list_mutex);
>  }

I am not convinced by this implementation. See the following comment
sequence:

* * * * *
localhost:/home/khali # sensors
coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +47.0°C  (high = +90.0°C, crit = +100.0°C)  

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +46.0°C  (high = +90.0°C, crit = +100.0°C)  

coretemp-isa-0002
Adapter: ISA adapter
Core 2:      +48.0°C  (high = +90.0°C, crit = +100.0°C)  

coretemp-isa-0003
Adapter: ISA adapter
Core 3:      +46.0°C  (high = +90.0°C, crit = +100.0°C)  

localhost:/home/khali # echo 0 > /sys/devices/system/cpu/cpu1/online
localhost:/home/khali # sensors
coretemp-isa-0005
Adapter: ISA adapter
Core 1:      +48.0°C  (high = +90.0°C, crit = +100.0°C)  

coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +48.0°C  (high = +90.0°C, crit = +100.0°C)  

coretemp-isa-0002
Adapter: ISA adapter
Core 2:      +49.0°C  (high = +90.0°C, crit = +100.0°C)  

coretemp-isa-0003
Adapter: ISA adapter
Core 3:      +48.0°C  (high = +90.0°C, crit = +100.0°C)  

localhost:/home/khali #
* * * * *

As you can see, the switch of hyperthreads on Core 1 caused hwmon
device coretemp-isa-0001 to be removed and be replaced with
coretemp-isa-0005. There is also a change in the underlying
directories, /sys/class/hwmon/hwmon1/device now points
to /sys/devices/platform/coretemp.5 instead
of /sys/devices/platform/coretemp.1. This has three drawbacks:
1* Configuration statements from /etc/sensors.conf will no longer be
   applied.
2* Some monitoring applications may lose their path to the sensors.
   Thankfully, libsensors uses hwmon device paths rather than physical
   device paths, so the effect should be limited, but other tools (e.g.
   the fancontrol script) tend to prefer physical device paths, so they
   will break.
3* If you disable several HTs at once, you have no guarantee that the
   new hwmon devices will be numbered in the same order as the old hwmon
   devices. If you are unlucky and the number changes, then all
   libsensors-based applications will start reporting garbage.

I admit that these issues are not critical ones, and are rather
unlikely to happen in the real world, but so is the problem you are
trying to solve in the first place.

Point 1* could be easily solved by changing the way the coretemp device
ID is allocated. Instead of using the CPU ID directly, we would use the
smallest CPU ID amongst all the siblings. This ensures a consistent ID
no matter which sibling is used.

Points 2* and 3*, however, can't be solved without reworking the driver
significantly. I think we should not only skip duplicate HT entries on
driver registration as my naive patch did. We should instead keep track
of them, i.e. all coretemp entries should know the list of CPU entries
they are backed up by, and a coretemp device would be unregistered only
when this list shrinks to zero elements (all HT have been removed.)

As you said you agree to give a try to a rework of the coretemp driver
to keep all related cores into the same hwmon device, I think this
additional constraint might fit well in the new driver design. What do
you think?

-- 
Jean Delvare

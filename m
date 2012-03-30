Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab2C3Nl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:41:58 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:34360 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933323Ab2C3Nlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:41:52 -0400
Date: Fri, 30 Mar 2012 16:41:19 +0300
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Joe Perches <joe@perches.com>, Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 17/76] thermal_sys: convert printks to
 pr_<level>
Message-ID: <20120330134119.GA13130@besouro>
Reply-To: eduardo.valentin@ti.com
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
 <c5a01dd52dc4903772f464ea580895ccc36e911d.1333101989.git.len.brown@intel.com>
MIME-Version: 1.0
In-Reply-To: <c5a01dd52dc4903772f464ea580895ccc36e911d.1333101989.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe, Len,

On Fri, Mar 30, 2012 at 06:13:20AM -0400, Len Brown wrote:
> From: Joe Perches <joe@perches.com>
> 
> Use the current logging style.
> 
> Remove PREFIX, add pr_fmt, convert the printks.  All dmesg output now
> prefixed with "thermal_sys: ".
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Jesper Juhl <jj@chaosbits.net>
> Cc: Len Brown <lenb@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/thermal/thermal_sys.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index db5d8f8..fab970d 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -23,6 +23,8 @@
>   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   */
>  
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
> @@ -39,8 +41,6 @@ MODULE_AUTHOR("Zhang Rui");
>  MODULE_DESCRIPTION("Generic thermal management sysfs support");
>  MODULE_LICENSE("GPL");
>  
> -#define PREFIX "Thermal: "
> -
>  struct thermal_cooling_device_instance {
>  	int id;
>  	char name[THERMAL_NAME_LENGTH];
> @@ -1023,8 +1023,7 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
>  
>  	if (tz->ops->get_temp(tz, &temp)) {
>  		/* get_temp failed - retry it later */
> -		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
> -		       "%d\n", tz->id);
> +		pr_warn("failed to read out thermal zone %d\n", tz->id);

We should get the struct dev in thermal_zone_device, I think it makes more sense to use the dev_* helper functions.

>  		goto leave;
>  	}
>  
> @@ -1039,9 +1038,8 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
>  					ret = tz->ops->notify(tz, count,
>  							      trip_type);
>  				if (!ret) {
> -					printk(KERN_EMERG
> -					       "Critical temperature reached (%ld C), shutting down.\n",
> -					       temp/1000);
> +					pr_emerg("Critical temperature reached (%ld C), shutting down\n",
> +						 temp/1000);

dito.

>  					orderly_poweroff(true);
>  				}
>  			}
> @@ -1345,7 +1343,7 @@ int thermal_generate_netlink_event(u32 orig, enum events event)
>  
>  	result = genlmsg_multicast(skb, 0, thermal_event_mcgrp.id, GFP_ATOMIC);
>  	if (result)
> -		printk(KERN_INFO "failed to send netlink event:%d", result);
> +		pr_info("failed to send netlink event:%d\n", result);

Here we probably would want to do the same, but we don't have the reference for the thermal zone device.


The orig argument could probably be changed to a thermal zone device and the we use it's id as orig for the message.

What do you think?

>  
>  	return result;
>  }
> -- 
> 1.7.10.rc2.19.gfae9d
> 
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-pm

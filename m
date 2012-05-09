Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194Ab2EIU7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:59:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34418 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759268Ab2EIU7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:59:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCHv4 2/4] cpuidle: fix error handling in __cpuidle_register_device
Date: Wed, 9 May 2012 23:04:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Kevin Hilman <khilman@ti.com>,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
References: <1336438662-10484-1-git-send-email-ccross@android.com> <1336438662-10484-3-git-send-email-ccross@android.com>
In-Reply-To: <1336438662-10484-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201205092304.01272.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012, Colin Cross wrote:
> Fix the error handling in __cpuidle_register_device to include
> the missing list_del.  Move it to a label, which will simplify
> the error handling when coupled states are added.
> 
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Tested-by: Kevin Hilman <khilman@ti.com>
> Signed-off-by: Colin Cross <ccross@android.com>

I've said

Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>

to this already too.

Rafael


> ---
>  drivers/cpuidle/cpuidle.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 3e3e3e4..4540672 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -403,13 +403,18 @@ static int __cpuidle_register_device(struct cpuidle_device *dev)
>  
>  	per_cpu(cpuidle_devices, dev->cpu) = dev;
>  	list_add(&dev->device_list, &cpuidle_detected_devices);
> -	if ((ret = cpuidle_add_sysfs(cpu_dev))) {
> -		module_put(cpuidle_driver->owner);
> -		return ret;
> -	}
> +	ret = cpuidle_add_sysfs(cpu_dev);
> +	if (ret)
> +		goto err_sysfs;
>  
>  	dev->registered = 1;
>  	return 0;
> +
> +err_sysfs:
> +	list_del(&dev->device_list);
> +	per_cpu(cpuidle_devices, dev->cpu) = NULL;
> +	module_put(cpuidle_driver->owner);
> +	return ret;
>  }
>  
>  /**
> 


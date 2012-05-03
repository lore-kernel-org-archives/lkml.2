Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab2ECUpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:45:41 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:52178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758602Ab2ECUpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:45:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCHv3 2/5] cpuidle: fix error handling in __cpuidle_register_device
Date: Thu, 3 May 2012 22:50:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>, Len Brown <len.brown@intel.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
References: <1335816551-27756-1-git-send-email-ccross@android.com> <1335816551-27756-3-git-send-email-ccross@android.com>
In-Reply-To: <1335816551-27756-3-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205032250.26434.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 30, 2012, Colin Cross wrote:
> Fix the error handling in __cpuidle_register_device to include
> the missing list_del.  Move it to a label, which will simplify
> the error handling when coupled states are added.
> 
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Reviewed-by: Kevin Hilman <khilman@ti.com>
> Tested-by: Kevin Hilman <khilman@ti.com>
> Signed-off-by: Colin Cross <ccross@android.com>

Reviewed-by: Rafael J. Wysocki <rjw@sisk.pl>

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


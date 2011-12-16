Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964900Ab1LPWFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:05:04 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:26131 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534Ab1LPWE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:04:58 -0500
Date: Fri, 16 Dec 2011 17:03:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: ke.yu@intel.com, kevin.tian@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rjw@sisk.pl
Cc: xen-devel@lists.xensource.com, jeremy@goop.org, konrad@kernel.org,
        stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        mike.mcclurg@citrix.com, liang.tang@oracle.com
Subject: Re: [PATCH 3/8] ACPI: processor: add
 __acpi_processor_[un]register_driver helpers.
Message-ID: <20111216220342.GC9832@phenom.dumpdata.com>
References: <1322673664-14642-1-git-send-email-konrad.wilk@oracle.com>
 <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322673664-14642-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EEBC080.0113,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 12:20:59PM -0500, Konrad Rzeszutek Wilk wrote:
> From: Tang Liang <liang.tang@oracle.com>
> 
> This patch implement __acpi_processor_[un]register_driver helper,
> so we can registry override processor driver function. Specifically
> the Xen processor driver.

Liang,

Is the reason we are doing this b/c we need to call acpi_bus_register_driver
and inhibit the registration of 'acpi_processor_driver' ?

And the reason we don't want 'acpi_processor_driver' to run is b/c of what?
If the cpuidle is disabled what is the harm of running the 'acpi_processor_driver'
driver?

> 
> By default the values are set to the native one.
> 
> Signed-off-by: Tang Liang <liang.tang@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/acpi/processor_driver.c |   35 +++++++++++++++++++++++++++++------
>  include/acpi/processor.h        |    6 +++++-
>  2 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
> index 211c078..55f0b89 100644
> --- a/drivers/acpi/processor_driver.c
> +++ b/drivers/acpi/processor_driver.c
> @@ -90,6 +90,11 @@ static const struct acpi_device_id processor_device_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(acpi, processor_device_ids);
>  
> +int (*__acpi_processor_register_driver)(void) = acpi_processor_register_driver;
> +void (*__acpi_processor_unregister_driver)(void) \
> +	= acpi_processor_unregister_driver;
> +
> +
>  static struct acpi_driver acpi_processor_driver = {
>  	.name = "processor",
>  	.class = ACPI_PROCESSOR_CLASS,
> @@ -779,6 +784,22 @@ void acpi_processor_uninstall_hotplug_notify(void)
>  	unregister_hotcpu_notifier(&acpi_cpu_notifier);
>  }
>  
> +int acpi_processor_register_driver(void)
> +{
> +	int result = 0;
> +
> +	result = acpi_bus_register_driver(&acpi_processor_driver);
> +	return result;
> +}
> +
> +void acpi_processor_unregister_driver(void)
> +{
> +	acpi_bus_unregister_driver(&acpi_processor_driver);
> +
> +	cpuidle_unregister_driver(&acpi_idle_driver);
> +
> +	return;
> +}
>  /*
>   * We keep the driver loaded even when ACPI is not running.
>   * This is needed for the powernow-k8 driver, that works even without
> @@ -794,9 +815,11 @@ static int __init acpi_processor_init(void)
>  
>  	memset(&errata, 0, sizeof(errata));
>  
> -	result = acpi_bus_register_driver(&acpi_processor_driver);
> -	if (result < 0)
> -		return result;
> +	if (__acpi_processor_register_driver) {
> +		result = __acpi_processor_register_driver();
> +		if (result < 0)
> +			return result;
> +	}
>  
>  	acpi_processor_install_hotplug_notify();
>  
> @@ -809,6 +832,7 @@ static int __init acpi_processor_init(void)
>  	return 0;
>  }
>  
> +
>  static void __exit acpi_processor_exit(void)
>  {
>  	if (acpi_disabled)
> @@ -820,9 +844,8 @@ static void __exit acpi_processor_exit(void)
>  
>  	acpi_processor_uninstall_hotplug_notify();
>  
> -	acpi_bus_unregister_driver(&acpi_processor_driver);
> -
> -	cpuidle_unregister_driver(&acpi_idle_driver);
> +	if (__acpi_processor_unregister_driver)
> +		__acpi_processor_unregister_driver();
>  
>  	return;
>  }
> diff --git a/include/acpi/processor.h b/include/acpi/processor.h
> index bd99fb6..969cbc9 100644
> --- a/include/acpi/processor.h
> +++ b/include/acpi/processor.h
> @@ -225,6 +225,9 @@ struct acpi_processor_errata {
>  	} piix4;
>  };
>  
> +extern int (*__acpi_processor_register_driver)(void);
> +extern void (*__acpi_processor_unregister_driver)(void);
> +
>  extern int acpi_processor_preregister_performance(struct
>  						  acpi_processor_performance
>  						  __percpu *performance);
> @@ -242,7 +245,8 @@ int acpi_processor_notify_smm(struct module *calling_module);
>  
>  void acpi_processor_install_hotplug_notify(void);
>  void acpi_processor_uninstall_hotplug_notify(void);
> -
> +int acpi_processor_register_driver(void);
> +void acpi_processor_unregister_driver(void);
>  int acpi_processor_add(struct acpi_device *device);
>  int acpi_processor_remove(struct acpi_device *device, int type);
>  void acpi_processor_notify(struct acpi_device *device, u32 event);
> -- 
> 1.7.7.3

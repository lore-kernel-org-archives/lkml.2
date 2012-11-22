Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab2KVS4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:55 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:60335 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078Ab2KVS4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-acpi@vger.kernel.org, lenb@kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com, bhelgaas@google.com, isimatu.yasuaki@jp.fujitsu.com,
        vijaymohan.pandarathil@hp.com
Subject: Re: [PATCH v7-1 1/5] ACPI: Add acpi_handle_<level>() interfaces
Date: Thu, 22 Nov 2012 01:13:08 +0100
Message-ID: <15759755.f5L9LAVF83@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353461788-808-1-git-send-email-toshi.kani@hp.com>
References: <1353461788-808-1-git-send-email-toshi.kani@hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 20, 2012 06:36:28 PM Toshi Kani wrote:
> This patch introduces acpi_handle_<level>(), where <level> is
> a kernel message level such as err/warn/info, to support improved
> logging messages for ACPI, esp. hot-plug operations.
> acpi_handle_<level>() appends "ACPI" prefix and ACPI object path
> to the messages.  This improves diagnosis of hotplug operations
> since an error message in a log file identifies an object that
> caused an issue.  This interface acquires the global namespace
> mutex to obtain an object path.  In interrupt context, it shows
> the object path as <n/a>.
> 
> acpi_handle_<level>() takes acpi_handle as an argument, which is
> passed to ACPI hotplug notify handlers from the ACPICA.  Therefore,
> it is always available unlike other kernel objects, such as device.
> 
> For example:
>   acpi_handle_err(handle, "Device don't exist, dropping EJECT\n");
> logs an error message like this at KERN_ERR.
>   ACPI: \_SB_.SCK4.CPU4: Device don't exist, dropping EJECT
> 
> ACPI hot-plug drivers can use acpi_handle_<level>() when they need
> to identify a target ACPI object path in their messages, such as
> error cases.  The usage model is similar to dev_<level>().
> acpi_handle_<level>() can be used when a device is not created or
> is invalid during hot-plug operations.  ACPI object path is also
> consistent on the platform, unlike device name that gets incremented
> over hotplug operations.
> 
> ACPI drivers should use dev_<level>() when a device object is valid.
> Device name provides more user friendly information, and avoids
> acquiring the global ACPI namespace mutex.  ACPI drivers also
> continue to use pr_<level>() when they do not need to specify device
> information, such as boot-up messages.
> 
> Note: ACPI_[WARNING|INFO|ERROR]() are intended for the ACPICA and
> are not associated with the kernel message level.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Tested-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
> 
> Hi Rafael,
> This patch replaces the [PATCH v7 1/5] below in the v7 series.
> https://lkml.org/lkml/2012/11/20/719

I've applied the entire v7 series to linux-pm.git/linux-next as v3.8 material.

As far as the .sys_notify series is concerned, I don't really like it.
I'll send you my comments in the next few days.

Thanks,
Rafael


> ---
>  drivers/acpi/utils.c | 38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/acpi.h | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 81 insertions(+)
> 
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 462f7e3..74437130 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -28,6 +28,8 @@
>  #include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/types.h>
> +#include <linux/hardirq.h>
> +#include <linux/acpi.h>
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
>  
> @@ -457,3 +459,39 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
>  #endif
>  }
>  EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
> +
> +/**
> + * acpi_handle_printk: Print message with ACPI prefix and object path
> + *
> + * This function is called through acpi_handle_<level> macros and prints
> + * a message with ACPI prefix and object path.  This function acquires
> + * the global namespace mutex to obtain an object path.  In interrupt
> + * context, it shows the object path as <n/a>.
> + */
> +void
> +acpi_handle_printk(const char *level, acpi_handle handle, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	struct acpi_buffer buffer = {
> +		.length = ACPI_ALLOCATE_BUFFER,
> +		.pointer = NULL
> +	};
> +	const char *path;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	if (in_interrupt() ||
> +	    acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer) != AE_OK)
> +		path = "<n/a>";
> +	else
> +		path = buffer.pointer;
> +
> +	printk("%sACPI: %s: %pV", level, path, &vaf);
> +
> +	va_end(args);
> +	kfree(buffer.pointer);
> +}
> +EXPORT_SYMBOL(acpi_handle_printk);
> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> index 0bb2070..417c96c 100644
> --- a/include/linux/acpi.h
> +++ b/include/linux/acpi.h
> @@ -517,4 +517,47 @@ static inline int acpi_dev_pm_attach(struct device *dev) { return -ENODEV; }
>  static inline void acpi_dev_pm_detach(struct device *dev) {}
>  #endif
>  
> +#ifdef CONFIG_ACPI
> +__printf(3, 4)
> +void acpi_handle_printk(const char *level, acpi_handle handle,
> +			const char *fmt, ...);
> +#else	/* !CONFIG_ACPI */
> +static inline __printf(3, 4) void
> +acpi_handle_printk(const char *level, void *handle, const char *fmt, ...) {}
> +#endif	/* !CONFIG_ACPI */
> +
> +/*
> + * acpi_handle_<level>: Print message with ACPI prefix and object path
> + * 
> + * These interfaces acquire the global namespace mutex to obtain an object
> + * path.  In interrupt context, it shows the object path as <n/a>.
> + */
> +#define acpi_handle_emerg(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_EMERG, handle, fmt, ##__VA_ARGS__)
> +#define acpi_handle_alert(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_ALERT, handle, fmt, ##__VA_ARGS__)
> +#define acpi_handle_crit(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_CRIT, handle, fmt, ##__VA_ARGS__)
> +#define acpi_handle_err(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_ERR, handle, fmt, ##__VA_ARGS__)
> +#define acpi_handle_warn(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_WARNING, handle, fmt, ##__VA_ARGS__)
> +#define acpi_handle_notice(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_NOTICE, handle, fmt, ##__VA_ARGS__)
> +#define acpi_handle_info(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_INFO, handle, fmt, ##__VA_ARGS__)
> +
> +/* REVISIT: Support CONFIG_DYNAMIC_DEBUG when necessary */
> +#if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
> +#define acpi_handle_debug(handle, fmt, ...)				\
> +	acpi_handle_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__)
> +#else
> +#define acpi_handle_debug(handle, fmt, ...)				\
> +({									\
> +	if (0)								\
> +		acpi_handle_printk(KERN_DEBUG, handle, fmt, ##__VA_ARGS__); \
> +	0;								\
> +})
> +#endif
> +
>  #endif	/*_LINUX_ACPI_H*/
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

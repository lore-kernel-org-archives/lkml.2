Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0CYI50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:57:26 -0400
Received: from poutre.nerim.net ([62.4.16.124]:51171 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab0CYI5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:57:24 -0400
Date: Thu, 25 Mar 2010 09:57:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-pm@lists.linux-foundation.org, Linux I2C <linux-i2c@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: Fix bus-level power management callbacks
Message-ID: <20100325095720.0b115056@hyperion.delvare>
In-Reply-To: <201003192344.09000.rjw@sisk.pl>
References: <201003132204.30905.rjw@sisk.pl>
	<201003192344.09000.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Fri, 19 Mar 2010 23:44:08 +0100, Rafael J. Wysocki wrote:
> I assume the lack of responses except for the Alan's one means the patch
> wasn't correct, so below is one that I think is better.  It fixes all of the
> issues described above without breaking backwards compatibility.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: i2c: Fix bus-level power management callbacks
> 
> There are three issues with the i2c bus type's power management
> callbacks at the moment.  First, they don't include any hibernate
> callbacks, although they should at least include the .restore()
> callback (there's no guarantee that the driver will be present in
> memory before loading the image kernel and we must restore the
> pre-hibernation state of the device).  Second, the "legacy"
> callbacks are not going to be invoked by the PM core since the bus
> type's pm object is not NULL.  Finally, the system sleep PM
> (ie. suspend/resume) callbacks don't check if the device has been
> already suspended at run time, in which case they should skip
> suspending it.  Also, it looks like the i2c bus type can use the
> generic subsystem-level runtime PM callbacks.
> 
> For these reasons, rework the system sleep PM callbacks provided by
> the i2c bus type to handle hibernation correctly and to invoke the
> "legacy" callbacks for drivers that provide them.  In addition to
> that make the i2c bus type use the generic subsystem-level runtime
> PM callbacks.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Mark, you contributed the initial runtime PM support for the i2c
subsystem, I thought you would have comments on Rafael's
reimplementation?

> ---
>  drivers/i2c/i2c-core.c     |  168 ++++++++++++++++++++++++++-------------------
>  include/linux/pm_runtime.h |    7 +

I am a little surprised to see changes to a generic header file here,
how is the i2c subsystem so special that we have needs other subsystems
did not?

>  2 files changed, 105 insertions(+), 70 deletions(-)
> 
> Index: linux-2.6/drivers/i2c/i2c-core.c
> ===================================================================
> --- linux-2.6.orig/drivers/i2c/i2c-core.c
> +++ linux-2.6/drivers/i2c/i2c-core.c
> @@ -156,107 +156,131 @@ static void i2c_device_shutdown(struct d
>  		driver->shutdown(client);
>  }
>  
> -#ifdef CONFIG_SUSPEND
> -static int i2c_device_pm_suspend(struct device *dev)
> +static int i2c_legacy_suspend(struct device *dev, pm_message_t mesg)
>  {
> -	const struct dev_pm_ops *pm;
> +	struct i2c_client *client = i2c_verify_client(dev);
> +	struct i2c_driver *driver;
>  
> -	if (!dev->driver)
> +	if (!client || !dev->driver)
>  		return 0;
> -	pm = dev->driver->pm;
> -	if (!pm || !pm->suspend)
> +	driver = to_i2c_driver(dev->driver);
> +	if (!driver->suspend)
>  		return 0;
> -	return pm->suspend(dev);
> +	return driver->suspend(client, mesg);
>  }
>  
> -static int i2c_device_pm_resume(struct device *dev)
> +static int i2c_legacy_resume(struct device *dev)
>  {
> -	const struct dev_pm_ops *pm;
> +	struct i2c_client *client = i2c_verify_client(dev);
> +	struct i2c_driver *driver;
>  
> -	if (!dev->driver)
> +	if (!client || !dev->driver)
>  		return 0;
> -	pm = dev->driver->pm;
> -	if (!pm || !pm->resume)
> +	driver = to_i2c_driver(dev->driver);
> +	if (!driver->resume)
>  		return 0;
> -	return pm->resume(dev);
> +	return driver->resume(client);
>  }
> -#else
> -#define i2c_device_pm_suspend	NULL
> -#define i2c_device_pm_resume	NULL
> -#endif

I fail to see why the functions above are outside of the #ifdef
CONFIG_PM_SLEEP scope. They are only called by functions which are
inside the #ifdef CONFIG_PM_SLEEP scope, so you'll get a build-time
warning if CONFIG_PM_SLEEP isn't set.

Is there a plan to get rid of the above legacy functions at some point
in time?

>  
> -#ifdef CONFIG_PM_RUNTIME
> -static int i2c_device_runtime_suspend(struct device *dev)
> +#ifdef CONFIG_PM_SLEEP
> +static int i2c_device_pm_suspend(struct device *dev)
>  {
> -	const struct dev_pm_ops *pm;
> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>  
> -	if (!dev->driver)
> -		return 0;
> -	pm = dev->driver->pm;
> -	if (!pm || !pm->runtime_suspend)
> +	if (pm_runtime_suspended(dev))
>  		return 0;
> -	return pm->runtime_suspend(dev);
> -}
> (...)

Apart from the above, the code looks sane to me, but then again I don't
know a thing about power management. I'll keep this patch in my i2c
tree, scheduled for merge in 2.6.35. If there are any updates, please
send them over, either as a new patch or as incremental changes which I
will merge myself.

-- 
Jean Delvare

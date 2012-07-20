Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2GTMwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 08:52:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54094 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab2GTMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 08:52:15 -0400
Date: Fri, 20 Jul 2012 14:52:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot
 and resume
Message-ID: <20120720125213.GA17647@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ming Lei <tom.leiming@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-usb <linux-usb@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 08:33:32PM +0800, Ming Lei wrote:
> The RFC patch is just for discussing if the idea of deferring
> request_firmware is doable for addressing the issue of
> request_firmware in resume path, which is caused by driver
> unbind/rebind during resume.
> 
> At least usb bus is involved in such things, one driver may be
> unbound and rebound in resume path at several situations, and
> request_firmware is often called inside probe().
> 
> Also the idea should be helpful for other hotplug buses too,
> at least there was the similar problem report on pcmcia bus.
> 
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 6cd2c6c..fb02eff 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -123,7 +123,7 @@ static bool driver_deferred_probe_enable = false;
>   * list and schedules the deferred probe workqueue to process them.  It
>   * should be called anytime a driver is successfully bound to a device.
>   */
> -static void driver_deferred_probe_trigger(void)
> +void driver_deferred_probe_trigger(void)
>  {
>  	if (!driver_deferred_probe_enable)
>  		return;
> @@ -144,6 +144,7 @@ static void driver_deferred_probe_trigger(void)
>  	 */
>  	queue_work(deferred_wq, &deferred_probe_work);
>  }
> +EXPORT_SYMBOL_GPL(driver_deferred_probe_trigger);
> 
>  /**
>   * deferred_probe_initcall() - Enable probing of deferred devices
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 5401814..4fe742f 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -593,6 +593,9 @@ request_firmware(const struct firmware
> **firmware_p, const char *name,
>  	if (IS_ERR_OR_NULL(fw_priv))
>  		return PTR_RET(fw_priv);
> 
> +	if (system_state != SYSTEM_RUNNING)
> +		return -EPROBE_DEFER;
> +
>  	ret = usermodehelper_read_trylock();
>  	if (WARN_ON(ret)) {
>  		dev_err(device, "firmware: %s will not be loaded\n", name);
> diff --git a/include/linux/device.h b/include/linux/device.h
> index d0e4d99..a63d3171 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -244,7 +244,7 @@ extern struct device_driver *driver_find(const char *name,
>  					 struct bus_type *bus);
>  extern int driver_probe_done(void);
>  extern void wait_for_device_probe(void);
> -
> +extern void driver_deferred_probe_trigger(void);
> 
>  /* sysfs interface for exporting driver attributes */
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index e07f5e0..c8d74c6 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -378,6 +378,7 @@ extern enum system_states {
>  	SYSTEM_POWER_OFF,
>  	SYSTEM_RESTART,
>  	SYSTEM_SUSPEND_DISK,
> +	SYSTEM_SUSPEND,
>  } system_state;
> 
>  #define TAINT_PROPRIETARY_MODULE	0
> diff --git a/init/main.c b/init/main.c
> index e60679d..237eae1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -809,6 +809,8 @@ static noinline int init_post(void)
>  	current->signal->flags |= SIGNAL_UNKILLABLE;
>  	flush_delayed_fput();
> 
> +	driver_deferred_probe_trigger();
> +
>  	if (ramdisk_execute_command) {
>  		run_init_process(ramdisk_execute_command);
>  		printk(KERN_WARNING "Failed to execute %s\n",
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 1da39ea..dbf6ffb 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -224,6 +224,9 @@ int suspend_devices_and_enter(suspend_state_t state)
>  		goto Recover_platform;
>  	}
>  	suspend_test_finish("suspend devices");
> +
> +	system_state = SYSTEM_SUSPEND;

This new SYSTEM_SUSPEND state is declared above and only assigned here
to system_state without being tested anywhere. AFAICT, the only test
you're doing is system_state != SYSTEM_RUNNING and that works without
defining a new SYSTEM_SUSPEND state.

So are you sure you really need it?

-- 
Regards/Gruss,
Boris.

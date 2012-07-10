Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2GJQfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:35:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab2GJQfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:35:23 -0400
Date: Tue, 10 Jul 2012 11:35:16 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120710163516.GE10194@thinkpad-t410>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	Arun Raghavan <arun.raghavan@collabora.co.uk>,
	linux-kernel@vger.kernel.org, Andreas Heider <andreas@meetr.de>
References: <1341891593-6485-1-git-send-email-arun.raghavan@collabora.co.uk>
 <20120710160555.GA31562@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120710160555.GA31562@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Anreas on the Cc, looks like he was forgotten]

On Tue, Jul 10, 2012 at 05:05:55PM +0100, Matthew Garrett wrote:
> On Tue, Jul 10, 2012 at 09:09:53AM +0530, Arun Raghavan wrote:
> > After suspend and resume, the values of these registers seem to change
> > from what they were at suspend time, potentially preventing the actual
> > output lines from being enabled post-resume. This saves relevant state
> > at suspend and restores it when resumed.
> > 
> > This is at least required on the MacBook Pro 8.2 when the Intel GPU is
> > manually selected in GRUB config before the kernel is loaded.
> 
> I'd really rather add proper switcheroo support. Andreas, I have a patch 
> with your name on it that appears to work (attached) - any objections to 
> getting this merged?

I agree completely. I've really been wanting to get the switcheroo
support added, but I don't have hardware with working discrete graphics
under EFI boot to work with.

The patch seems to have some rough edges to work out, but once that's
done I'd be in favor of merging it as long as it's working well.

Seth

> 
> commit 225a5a4ba90e9cf3de836c936cd01e9828cd0765
> Author: Matthew Garrett <mjg@redhat.com>
> Date:   Thu Mar 22 09:28:27 2012 -0400
> 
>     gmux switcheroo
> 
> diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
> index 694a15a..ef2c9ac 100644
> --- a/drivers/platform/x86/apple-gmux.c
> +++ b/drivers/platform/x86/apple-gmux.c
> @@ -2,6 +2,7 @@
>   *  Gmux driver for Apple laptops
>   *
>   *  Copyright (C) Canonical Ltd. <seth.forshee@canonical.com>
> + *  Copyright (C) 2010-2012 Andreas Heider <andreas@meetr.de>
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License version 2 as
> @@ -20,13 +21,22 @@
>  #include <linux/slab.h>
>  #include <acpi/video.h>
>  #include <asm/io.h>
> +#include <linux/pci.h>
> +#include <linux/vga_switcheroo.h>
> +#include <linux/delay.h>
>  
> -struct apple_gmux_data {
> +static struct apple_gmux_data {
>  	unsigned long iostart;
>  	unsigned long iolen;
> +	acpi_handle dhandle;
> +	enum vga_switcheroo_client_id resume_client_id;
>  
>  	struct backlight_device *bdev;
> -};
> +} gmux_data;
> +
> +static struct pci_dev *discrete;
> +
> +DECLARE_COMPLETION(powerchange_done);
>  
>  /*
>   * gmux port offsets. Many of these are not yet used, but may be in the
> @@ -59,32 +69,29 @@ struct apple_gmux_data {
>  #define GMUX_BRIGHTNESS_MASK		0x00ffffff
>  #define GMUX_MAX_BRIGHTNESS		GMUX_BRIGHTNESS_MASK
>  
> -static inline u8 gmux_read8(struct apple_gmux_data *gmux_data, int port)
> +static inline u8 gmux_read8(int port)
>  {
> -	return inb(gmux_data->iostart + port);
> +	return inb(gmux_data.iostart + port);
>  }
>  
> -static inline void gmux_write8(struct apple_gmux_data *gmux_data, int port,
> -			       u8 val)
> +static inline void gmux_write8(int port, u8 val)
>  {
> -	outb(val, gmux_data->iostart + port);
> +	outb(val, gmux_data.iostart + port);
>  }
>  
> -static inline u32 gmux_read32(struct apple_gmux_data *gmux_data, int port)
> +static inline u32 gmux_read32(int port)
>  {
> -	return inl(gmux_data->iostart + port);
> +	return inl(gmux_data.iostart + port);
>  }
>  
>  static int gmux_get_brightness(struct backlight_device *bd)
>  {
> -	struct apple_gmux_data *gmux_data = bl_get_data(bd);
> -	return gmux_read32(gmux_data, GMUX_PORT_BRIGHTNESS) &
> +	return gmux_read32(GMUX_PORT_BRIGHTNESS) &
>  	       GMUX_BRIGHTNESS_MASK;
>  }
>  
>  static int gmux_update_status(struct backlight_device *bd)
>  {
> -	struct apple_gmux_data *gmux_data = bl_get_data(bd);
>  	u32 brightness = bd->props.brightness;
>  
>  	if (bd->props.state & BL_CORE_SUSPENDED)
> @@ -96,54 +103,225 @@ static int gmux_update_status(struct backlight_device *bd)
>  	 * accept a single u32 write, but the old method also works, so we
>  	 * just use the old method for all gmux versions.
>  	 */
> -	gmux_write8(gmux_data, GMUX_PORT_BRIGHTNESS, brightness);
> -	gmux_write8(gmux_data, GMUX_PORT_BRIGHTNESS + 1, brightness >> 8);
> -	gmux_write8(gmux_data, GMUX_PORT_BRIGHTNESS + 2, brightness >> 16);
> -	gmux_write8(gmux_data, GMUX_PORT_BRIGHTNESS + 3, 0);
> +	gmux_write8(GMUX_PORT_BRIGHTNESS, brightness);
> +	gmux_write8(GMUX_PORT_BRIGHTNESS + 1, brightness >> 8);
> +	gmux_write8(GMUX_PORT_BRIGHTNESS + 2, brightness >> 16);
> +	gmux_write8(GMUX_PORT_BRIGHTNESS + 3, 0);
> +
> +	return 0;
> +}
> +
> +static int gmux_switchto(enum vga_switcheroo_client_id id)
> +{
> +	if (id == VGA_SWITCHEROO_IGD) {
> +		gmux_write8(GMUX_PORT_SWITCH_DDC, 1);
> +		gmux_write8(GMUX_PORT_SWITCH_DISPLAY, 2);
> +		gmux_write8(GMUX_PORT_SWITCH_EXTERNAL, 2);
> +	} else {
> +		gmux_write8(GMUX_PORT_SWITCH_DDC, 2);
> +		gmux_write8(GMUX_PORT_SWITCH_DISPLAY, 3);
> +		gmux_write8(GMUX_PORT_SWITCH_EXTERNAL, 3);
> +	}
> +
> +	return 0;
> +}
> +
> +static int gmux_call_acpi_pwrd(int arg)
> +{
> +	acpi_handle gfx_handle = DEVICE_ACPI_HANDLE(&discrete->dev);
> +	acpi_handle pwrd_handle = NULL;
> +	acpi_status status = AE_OK;
> +	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
> +	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
> +	struct acpi_object_list arg_list = { 1, &arg0 };
> +
> +	if (!gfx_handle) {
> +		pr_err("Cannot find device ACPI handle\n");
> +		return -ENODEV;
> +	}
> +
> +	status = acpi_get_handle(gfx_handle, "PWRD", &pwrd_handle);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("Cannot get PWRD handle: %s\n",
> +		       acpi_format_exception(status));
> +		return -ENODEV;
> +	}
>  
> +	arg0.integer.value = arg;
> +
> +	status = acpi_evaluate_object(pwrd_handle, NULL, &arg_list, &buffer);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("PWRD call failed: %s\n",
> +		       acpi_format_exception(status));
> +		return -ENODEV;
> +	}
> +
> +	kfree(buffer.pointer);
>  	return 0;
>  }
>  
> +static int gmux_set_discrete_state(enum vga_switcheroo_state state)
> +{
> +	/* TODO: locking for completions needed? */
> +	init_completion(&powerchange_done);
> +
> +	if (state == VGA_SWITCHEROO_ON) {
> +		gmux_call_acpi_pwrd(0);
> +		gmux_write8(GMUX_PORT_DISCRETE_POWER, 1);
> +		gmux_write8(GMUX_PORT_DISCRETE_POWER, 3);
> +	} else {
> +		gmux_write8(GMUX_PORT_DISCRETE_POWER, 1);
> +		gmux_write8(GMUX_PORT_DISCRETE_POWER, 0);
> +		gmux_call_acpi_pwrd(1);
> +	}
> +
> +	if (wait_for_completion_interruptible_timeout(&powerchange_done,
> +						      msecs_to_jiffies(200)))
> +		pr_info("completion timeout\n");
> +
> +	return 0;
> +}
> +
> +static int gmux_set_power_state(enum vga_switcheroo_client_id id,
> +				enum vga_switcheroo_state state)
> +{
> +	if (id == VGA_SWITCHEROO_IGD)
> +		return 0;
> +
> +	return gmux_set_discrete_state(state);
> +}
> +
> +static int gmux_init(void)
> +{
> +	return 0;
> +}
> +
> +static int gmux_get_client_id(struct pci_dev *pdev)
> +{
> +	/* early mbps with switchable graphics use nvidia integrated graphics,
> +	 * hardcode that the 9400M is integrated */
> +	if (pdev->vendor == PCI_VENDOR_ID_INTEL) {
> +		return VGA_SWITCHEROO_IGD;
> +	} else if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
> +		   pdev->device == 0x0863) {
> +		return VGA_SWITCHEROO_IGD;
> +	} else {
> +		discrete = pdev;
> +		return VGA_SWITCHEROO_DIS;
> +	}
> +}
> +
> +static bool gmux_client_active(enum vga_switcheroo_client_id id)
> +{
> +	u8 state = gmux_read8(GMUX_PORT_SWITCH_DISPLAY);
> +
> +	if ((id == VGA_SWITCHEROO_IGD && state == 2) ||
> +	    (id == VGA_SWITCHEROO_DIS && state == 3))
> +		return true;
> +
> +	return false;
> +}
> +
> +static struct vga_switcheroo_handler gmux_handler = {
> +	.switchto = gmux_switchto,
> +	.power_state = gmux_set_power_state,
> +	.init = gmux_init,
> +	.get_client_id = gmux_get_client_id,
> +	.client_active = gmux_client_active,
> +};
> +
> +static void gmux_disable_interrupts(void)
> +{
> +	gmux_write8(GMUX_PORT_INTERRUPT_ENABLE, GMUX_INTERRUPT_DISABLE);
> +}
> +
> +static void gmux_enable_interrupts(void)
> +{
> +	gmux_write8(GMUX_PORT_INTERRUPT_ENABLE, GMUX_INTERRUPT_ENABLE);
> +}
> +
> +static int gmux_interrupt_get_status(void)
> +{
> +	return gmux_read8(GMUX_PORT_INTERRUPT_STATUS);
> +}
> +
> +static void gmux_interrupt_activate_status(void)
> +{
> +	int old_status;
> +	int new_status;
> +
> +	/* to reactivate interrupts write back current status */
> +	old_status = gmux_read8(GMUX_PORT_INTERRUPT_STATUS);
> +	gmux_write8(GMUX_PORT_INTERRUPT_STATUS, old_status);
> +	new_status = gmux_read8(GMUX_PORT_INTERRUPT_STATUS);
> +
> +	/* status = 0 indicates active interrupts */
> +	if (new_status)
> +		pr_info("gmux: error: activate_status, old_status %d new_status %d\n", old_status, new_status);
> +}
> +
> +static void gmux_notify_handler(acpi_handle device, u32 value, void *context)
> +{
> +	int status;
> +
> +	status = gmux_interrupt_get_status();
> +	gmux_disable_interrupts();
> +
> +	gmux_interrupt_activate_status();
> +	gmux_enable_interrupts();
> +
> +	if (status & GMUX_INTERRUPT_STATUS_POWER)
> +		complete(&powerchange_done);
> +}
> +
>  static const struct backlight_ops gmux_bl_ops = {
>  	.options = BL_CORE_SUSPENDRESUME,
>  	.get_brightness = gmux_get_brightness,
>  	.update_status = gmux_update_status,
>  };
>  
> +static int gmux_suspend(struct pnp_dev *dev, pm_message_t state)
> +{
> +	gmux_data.resume_client_id = gmux_read8(GMUX_PORT_SWITCH_DISPLAY) == 2 ?
> +		VGA_SWITCHEROO_IGD : VGA_SWITCHEROO_DIS;
> +	return 0;
> +}
> +
> +static int gmux_resume(struct pnp_dev *dev)
> +{
> +	gmux_switchto(gmux_data.resume_client_id);
> +	return 0;
> +}
> +
>  static int __devinit gmux_probe(struct pnp_dev *pnp,
>  				const struct pnp_device_id *id)
>  {
> -	struct apple_gmux_data *gmux_data;
>  	struct resource *res;
>  	struct backlight_properties props;
>  	struct backlight_device *bdev;
>  	u8 ver_major, ver_minor, ver_release;
> +	acpi_status status;
>  	int ret = -ENXIO;
>  
> -	gmux_data = kzalloc(sizeof(*gmux_data), GFP_KERNEL);
> -	if (!gmux_data)
> -		return -ENOMEM;
> -	pnp_set_drvdata(pnp, gmux_data);
> -
>  	res = pnp_get_resource(pnp, IORESOURCE_IO, 0);
>  	if (!res) {
>  		pr_err("Failed to find gmux I/O resource\n");
> -		goto err_free;
> +		goto err_begin;
>  	}
>  
> -	gmux_data->iostart = res->start;
> -	gmux_data->iolen = res->end - res->start;
> +	gmux_data.iostart = res->start;
> +	gmux_data.iolen = res->end - res->start;
>  
> -	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
> +	if (gmux_data.iolen < GMUX_MIN_IO_LEN) {
>  		pr_err("gmux I/O region too small (%lu < %u)\n",
> -		       gmux_data->iolen, GMUX_MIN_IO_LEN);
> -		goto err_free;
> +		       gmux_data.iolen, GMUX_MIN_IO_LEN);
> +		goto err_begin;
>  	}
>  
> -	if (!request_region(gmux_data->iostart, gmux_data->iolen,
> +	if (!request_region(gmux_data.iostart, gmux_data.iolen,
>  			    "Apple gmux")) {
>  		pr_err("gmux I/O already in use\n");
> -		goto err_free;
> +		goto err_begin;
>  	}
>  
>  	/*
> @@ -151,9 +329,9 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
>  	 * doesn't really have a gmux. Check for invalid version information
>  	 * to detect this.
>  	 */
> -	ver_major = gmux_read8(gmux_data, GMUX_PORT_VERSION_MAJOR);
> -	ver_minor = gmux_read8(gmux_data, GMUX_PORT_VERSION_MINOR);
> -	ver_release = gmux_read8(gmux_data, GMUX_PORT_VERSION_RELEASE);
> +	ver_major = gmux_read8(GMUX_PORT_VERSION_MAJOR);
> +	ver_minor = gmux_read8(GMUX_PORT_VERSION_MINOR);
> +	ver_release = gmux_read8(GMUX_PORT_VERSION_RELEASE);
>  	if (ver_major == 0xff && ver_minor == 0xff && ver_release == 0xff) {
>  		pr_info("gmux device not present\n");
>  		ret = -ENODEV;
> @@ -165,7 +343,7 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
>  
>  	memset(&props, 0, sizeof(props));
>  	props.type = BACKLIGHT_PLATFORM;
> -	props.max_brightness = gmux_read32(gmux_data, GMUX_PORT_MAX_BRIGHTNESS);
> +	props.max_brightness = gmux_read32(GMUX_PORT_MAX_BRIGHTNESS);
>  
>  	/*
>  	 * Currently it's assumed that the maximum brightness is less than
> @@ -177,44 +355,73 @@ static int __devinit gmux_probe(struct pnp_dev *pnp,
>  		props.max_brightness = GMUX_MAX_BRIGHTNESS;
>  
>  	bdev = backlight_device_register("gmux_backlight", &pnp->dev,
> -					 gmux_data, &gmux_bl_ops, &props);
> +					 NULL, &gmux_bl_ops, &props);
>  	if (IS_ERR(bdev)) {
>  		ret = PTR_ERR(bdev);
>  		goto err_release;
>  	}
>  
> -	gmux_data->bdev = bdev;
> +	gmux_data.bdev = bdev;
>  	bdev->props.brightness = gmux_get_brightness(bdev);
>  	backlight_update_status(bdev);
>  
> -	/*
> -	 * The backlight situation on Macs is complicated. If the gmux is
> -	 * present it's the best choice, because it always works for
> -	 * backlight control and supports more levels than other options.
> -	 * Disable the other backlight choices.
> -	 */
> -	acpi_video_unregister();
> -	apple_bl_unregister();
> +	gmux_data.dhandle = DEVICE_ACPI_HANDLE(&pnp->dev);
> +	if (!gmux_data.dhandle) {
> +		pr_err("Cannot find acpi device for pnp device %s\n",
> +		       dev_name(&pnp->dev));
> +		goto err_release;
> +	} else {
> +		struct acpi_buffer buf = { ACPI_ALLOCATE_BUFFER, NULL };
> +		acpi_get_name(gmux_data.dhandle, ACPI_SINGLE_NAME, &buf);
> +		pr_info("Found acpi handle for pnp device %s: %s\n",
> +			dev_name(&pnp->dev), (char *)buf.pointer);
> +		kfree(buf.pointer);
> +	}
> +
> +	status = acpi_install_notify_handler(gmux_data.dhandle,
> +				ACPI_DEVICE_NOTIFY, &gmux_notify_handler, pnp);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("Install notify handler failed: %s\n",
> +		       acpi_format_exception(status));
> +		goto err_notify;
> +	}
> +
> +	if (vga_switcheroo_register_handler(&gmux_handler))
> +		goto err_register;
> +
> +	init_completion(&powerchange_done);
> +	gmux_enable_interrupts();
>  
>  	return 0;
>  
> +err_register:
> +	status = acpi_remove_notify_handler(gmux_data.dhandle,
> +				     ACPI_DEVICE_NOTIFY, &gmux_notify_handler);
> +	if (ACPI_FAILURE(status))
> +		pr_err("Remove notify handler failed: %s\n",
> +		       acpi_format_exception(status));
> +err_notify:
> +	backlight_device_unregister(bdev);
>  err_release:
> -	release_region(gmux_data->iostart, gmux_data->iolen);
> -err_free:
> -	kfree(gmux_data);
> +	release_region(gmux_data.iostart, gmux_data.iolen);
> +err_begin:
>  	return ret;
>  }
>  
>  static void __devexit gmux_remove(struct pnp_dev *pnp)
>  {
> -	struct apple_gmux_data *gmux_data = pnp_get_drvdata(pnp);
> -
> -	backlight_device_unregister(gmux_data->bdev);
> -	release_region(gmux_data->iostart, gmux_data->iolen);
> -	kfree(gmux_data);
> -
> -	acpi_video_register();
> -	apple_bl_register();
> +	acpi_status status;
> +
> +	vga_switcheroo_unregister_handler();
> +	backlight_device_unregister(gmux_data.bdev);
> +	gmux_disable_interrupts();
> +	status = acpi_remove_notify_handler(gmux_data.dhandle,
> +				     ACPI_DEVICE_NOTIFY, &gmux_notify_handler);
> +	if (ACPI_FAILURE(status))
> +		pr_err("Remove notify handler failed: %s\n",
> +		       acpi_format_exception(status));
> +
> +	release_region(gmux_data.iostart, gmux_data.iolen);
>  }
>  
>  static const struct pnp_device_id gmux_device_ids[] = {
> @@ -227,6 +434,8 @@ static struct pnp_driver gmux_pnp_driver = {
>  	.probe		= gmux_probe,
>  	.remove		= __devexit_p(gmux_remove),
>  	.id_table	= gmux_device_ids,
> +	.suspend	= gmux_suspend,
> +	.resume		= gmux_resume
>  };
>  
>  static int __init apple_gmux_init(void)
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

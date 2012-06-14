Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2FNW0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 18:26:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39802 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2FNW0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 18:26:50 -0400
Date: Fri, 15 Jun 2012 02:26:41 +0400
From: Igor Murzov <intergalactic.anonymous@gmail.com>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>
Subject: Re: 3.5.0-rc2 bisected regression: Can't change brightness on Vaio
 laptop
Message-ID: <20120615022641.1556677f@garik>
In-Reply-To: <20120610163813.GA5721@Pilar.maths.private.cam.ac.uk>
References: <20120610163813.GA5721@Pilar.maths.private.cam.ac.uk>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please follow the discussion here:
https://bugzilla.kernel.org/show_bug.cgi?id=43168


> Commit ea9f8856bd6d4 ("ACPI video: Harden video bus adding") breaks the
> backlight controls on my Vaio laptop.
> 
> After this patch the folder /sys/class/backlight becomes empty and
> I can't change the lcd brightness anymore.
> 
> This regression is present in v3.4.2 as well as in the current
> v3.5.0-rc2. 
> 
> I tried to manually revert that commit from v3.5.0-rc2, and the resulting
> patch below fixes the issue for me.
> 
> My config is here:
> http://www.damtp.cam.ac.uk/user/crm66/config-3.5-rc1
> 
> and the dmesg of v3.5.0-rc2 plus the patch below is here:
> http://www.damtp.cam.ac.uk/user/crm66/dmesg_v3.5-rc2+patch.txt
> 
> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> index a576575..4612b1c 100644
> --- a/drivers/acpi/video.c
> +++ b/drivers/acpi/video.c
> @@ -548,27 +548,27 @@ acpi_video_device_EDID(struct acpi_video_device *device,
>   *		1. 	The system BIOS should NOT automatically control the brightness 
>   *			level of the LCD when the power changes from AC to DC.
>   * Return Value:
> - *		-EINVAL	wrong arg.
> + * 		-1	wrong arg.
>   */
>  
>  static int
>  acpi_video_bus_DOS(struct acpi_video_bus *video, int bios_flag, int lcd_flag)
>  {
> -	acpi_status status;
> +	u64 status = 0;
>  	union acpi_object arg0 = { ACPI_TYPE_INTEGER };
>  	struct acpi_object_list args = { 1, &arg0 };
>  
>  
> -	if (bios_flag < 0 || bios_flag > 3 || lcd_flag < 0 || lcd_flag > 1)
> -		return -EINVAL;
> +	if (bios_flag < 0 || bios_flag > 3 || lcd_flag < 0 || lcd_flag > 1) {
> +		status = -1;
> +		goto Failed;
> +	}
>  	arg0.integer.value = (lcd_flag << 2) | bios_flag;
>  	video->dos_setting = arg0.integer.value;
> -	status = acpi_evaluate_object(video->device->handle, "_DOS",
> -		&args, NULL);
> -	if (ACPI_FAILURE(status))
> -		return -EIO;
> +	acpi_evaluate_object(video->device->handle, "_DOS", &args, NULL);
>  
> -	return 0;
> +      Failed:
> +	return status;
>  }
>  
>  /*
> @@ -1343,17 +1343,15 @@ static int
>  acpi_video_bus_get_devices(struct acpi_video_bus *video,
>  			   struct acpi_device *device)
>  {
> -	int status;
> +	int status = 0;
>  	struct acpi_device *dev;
>  
> -	status = acpi_video_device_enumerate(video);
> -	if (status)
> -		return status;
> +	acpi_video_device_enumerate(video);
>  
>  	list_for_each_entry(dev, &device->children, node) {
>  
>  		status = acpi_video_bus_get_one_device(dev, video);
> -		if (status) {
> +		if (ACPI_FAILURE(status)) {
>  			printk(KERN_WARNING PREFIX
>  					"Can't attach device\n");
>  			continue;
> @@ -1655,9 +1653,8 @@ static int acpi_video_bus_add(struct acpi_device *device)
>  	mutex_init(&video->device_list_lock);
>  	INIT_LIST_HEAD(&video->video_device_list);
>  
> -	error = acpi_video_bus_get_devices(video, device);
> -	if (error)
> -		goto err_free_video;
> +	acpi_video_bus_get_devices(video, device);
> +	acpi_video_bus_start_devices(video);
>  
>  	video->input = input = input_allocate_device();
>  	if (!input) {
> @@ -1695,13 +1692,9 @@ static int acpi_video_bus_add(struct acpi_device *device)
>  
>  	video->pm_nb.notifier_call = acpi_video_resume;
>  	video->pm_nb.priority = 0;
> -	error = register_pm_notifier(&video->pm_nb);
> -	if (error)
> -		goto err_stop_video;
>  
> -	error = input_register_device(input);
> -	if (error)
> -		goto err_unregister_pm_notifier;
> +	register_pm_notifier(&video->pm_nb);
> +	input_register_device(input);
>  
>  	return 0;
>  
> 

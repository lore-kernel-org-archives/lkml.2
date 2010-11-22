Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0KVOsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:48:11 -0500
Received: from tex.lwn.net ([70.33.254.29]:50886 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080Ab0KVOsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:48:08 -0500
Date: Mon, 22 Nov 2010 07:48:06 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: mahatma@eu.by
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH v2] viafb: I2C/DDC LCD detection for VIA framebuffer
Message-ID: <20101122074806.01f75208@bike.lwn.net>
In-Reply-To: <4CEA7CD9.2060903@bspu.unibel.by>
References: <4CEA7CD9.2060903@bspu.unibel.by>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 16:23:21 +0200
Dzianis Kahanovich <mahatma@bspu.unibel.by> wrote:

> I2C/DDC LCD detection for VIA framebuffer
> 
> Adding legacy I2C/DDC support for VIA framebuffer, used to fix LCD
> panel size and (if "via_active_dev" is empty default) force LCD
> detection. This solving at least defaults on Chrome9 video
> on HP mini 2133 notebook, but must be good in other cases,
> include double-LCD. Also forcing viafb_active_dev to NULL as bugfix.

As a general note, it's good to Cc the authors and maintainers of the
code you're changing.  Florian has been acting as maintainer of the
viafb subsystem; I've added him to the list.

> 
> Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>
> ---
> diff -pruN a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
> --- a/drivers/video/via/via-core.c	2010-11-22 13:11:44.000000000 +0200
> +++ b/drivers/video/via/via-core.c	2010-11-22 13:59:07.000000000 +0200
> @@ -2,6 +2,7 @@
>   * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
>   * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
>   * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
> + * Copyright 2010 Dzianis Kahanovich <mahatma@eu.by>
>   */
> 
>  /*
> @@ -16,6 +17,8 @@
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
> 
> +extern char *viafb_active_dev;
> +
>  /*
>   * The default port config.
>   */
> @@ -576,6 +579,56 @@ static void via_teardown_subdevs(void)
>  }
> 
> +static void via_i2c_detect(void)
> +{
> +	u8 *edid;
> +	struct fb_var_screeninfo var;
> +	int i, n = 0;
> +	struct i2c_adapter *adapter;
> +
> +	for (i = 0; i < VIAFB_NUM_PORTS; i++) {
> +		adapter = viafb_find_i2c_adapter(i);
> +		if (!adapter || !adapter->algo_data ||
> +		    !(edid = fb_ddc_read(adapter)))
> +			continue;

What happens if what's there is not an LCD, or if there's nothing
there?  Might this add significant boot delays?

> +		if (fb_parse_edid(edid, &var))
> +			goto free_edid;
> +		if (n) {

What's "n"?  Not the most descriptive variable name ever.  I take it
"n" is the number of monitors you've found so far?

> +			fb_edid_to_monspecs(edid, &viafbinfo1->monspecs);
> +			viaparinfo->lvds_setting_info2->lcd_panel_hres =
> +			    var.xres;
> +			viaparinfo->lvds_setting_info2->lcd_panel_vres =
> +			    var.yres;

There are times when trying to stick to the 80-column limit just isn't
worthwhile.

> +			if (!viafb_active_dev) {
> +				viafb_SAMM_ON = STATE_ON;
> +				if (viafbinfo1->monspecs.input & FB_DISP_DDI)
> +					viafb_LCD2_ON = STATE_ON;
> +			}
> +		} else {
> +			fb_edid_to_monspecs(edid, &viafbinfo->monspecs);
> +			viaparinfo->lvds_setting_info->lcd_panel_hres =
> +			    var.xres;
> +			viaparinfo->lvds_setting_info->lcd_panel_vres =
> +			    var.yres;
> +			if (!viafb_active_dev) {
> +				viafb_DVI_ON =
> +				    viaparinfo->tmds_setting_info->
> +				    max_hres ? STATE_ON : STATE_OFF;
> +				if (viafbinfo->monspecs.input & FB_DISP_DDI) {
> +					viafb_DeviceStatus = LCD_Device;
> +					viafb_primary_dev = LCD_Device;
> +					viafb_LCD_ON = STATE_ON;
> +				}
> +			}
> +		}
> +		n++;
> +free_edid:
> +		kfree(edid);
> +		if (n > 1)
> +			break;
> +	}
> +}
> +
> 
>  static int __devinit via_pci_probe(struct pci_dev *pdev,
>  		const struct pci_device_id *ent)
>  {
> @@ -607,6 +660,7 @@ static int __devinit via_pci_probe(struc
>  	ret = via_fb_pci_probe(&global_dev);
>  	if (ret)
>  		goto out_subdevs;
> +	via_i2c_detect();
>  	return 0;
> 
>  out_subdevs:
> diff -pruN a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
> --- a/drivers/video/via/viafbdev.c	2010-11-22 13:11:44.000000000 +0200
> +++ b/drivers/video/via/viafbdev.c	2010-11-22 13:59:07.000000000 +0200
> @@ -43,7 +43,7 @@ static int viafb_second_size;
>  static int viafb_accel = 1;
> 
>  /* Added for specifying active devices.*/
> -char *viafb_active_dev;
> +char *viafb_active_dev = NULL;

This is a file-static variable, it will be NULL by default.

More general comments:

 - I find the code hard to read.  I guess it will fit in well with the
   rest of viafb! :)

 - This is framebuffer-specific stuff which shouldn't be in
   via-core.c.  The fact that viafb_active_dev is defined in viafbdev.c
   is a hint; I'd be inclined to put this kind of detection code there.

 - It would be interesting to see how other via-based systems work with
   this patch; I won't be able to do that in the near future, so
   I'm adding Daniel (OLPC) to the Cc list.

Thanks,

jon

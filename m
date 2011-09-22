Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1IVJX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 05:23:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36978 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab1IVJXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 05:23:52 -0400
Date: Thu, 22 Sep 2011 11:23:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Lucas C. Villa Real" <lucasvr@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guya <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] Initialize pointer on request_firmware
Message-ID: <20110922092347.GD17640@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Lucas C. Villa Real" <lucasvr@gmail.com>,
	linux-kernel@vger.kernel.org, Wey-Yi Guya <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pekka Enberg <penberg@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110921235515.7476c5fe.lucasvr@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 11:55:15PM -0300, Lucas C. Villa Real wrote:
> Hello, folks,
> 
> I've seen some kernel oopses when suspending my machine. The problem comes from isight_firmware, which assumes that, on error, a call to request_firmware() will initialize the provided pointer to the firmware image to NULL.
> 
> The patch below fixes the isight_firmware side of the problem and also ensures that request_firmware() always sets the pointer to NULL on such cases (it currently does that for all except one situation).
> 
> Signed-off-by: Lucas C. Villa Real <lucasvr@gobolinux.org>
> 
> --- linux-3.0.4/drivers/base/firmware_class.c.orig	2011-09-21 21:03:01.000000000 -0300
> +++ linux-3.0.4/drivers/base/firmware_class.c	2011-09-21 21:03:13.000000000 -0300
> @@ -523,6 +523,7 @@ static int _request_firmware(const struc
>  
>  	if (WARN_ON(usermodehelper_is_disabled())) {
>  		dev_err(device, "firmware: %s will not be loaded\n", name);
> +		*firmware_p = NULL;
>  		return -EBUSY;
>  	}

Looks like f45f3c1f3f616 needs backporting to stable, if it hasn't
happened yet. Oh, and then there's caca9510ff4e5 too which adds this
exit path to the goto out label as the rest of the function.

Adding some more people to Cc.

>  
> --- linux-3.0.4/drivers/usb/misc/isight_firmware.c.orig	2011-09-21 20:47:39.000000000 -0300
> +++ linux-3.0.4/drivers/usb/misc/isight_firmware.c	2011-09-21 20:47:46.000000000 -0300
> @@ -39,7 +39,7 @@ static int isight_firmware_load(struct u
>  {
>  	struct usb_device *dev = interface_to_usbdev(intf);
>  	int llen, len, req, ret = 0;
> -	const struct firmware *firmware;
> +	const struct firmware *firmware = NULL;
>  	unsigned char *buf = kmalloc(50, GFP_KERNEL);
>  	unsigned char data[4];
>  	const u8 *ptr;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.

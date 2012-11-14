Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422669Ab2KNLri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:47:38 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52217 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161155Ab2KNLrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:47:36 -0500
Date: Wed, 14 Nov 2012 11:52:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Forconi <forconi@wavecomm.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: KMS Framebuffer on Intel N2600 (GMA3600)
Message-ID: <20121114115255.2dfaefc9@pyramind.ukuu.org.uk>
In-Reply-To: <2055189652.1317458.1352882446411.JavaMail.root@zmail.sgconsulting.it>
References: <1877610299.1316440.1352881150817.JavaMail.root@zmail.sgconsulting.it>
	<2055189652.1317458.1352882446411.JavaMail.root@zmail.sgconsulting.it>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - CPU: Intel Atom N2600
>  - Chipset: Intel NM10
>  - Integrated graphics system: Intel GMA 3600
>  - LCD Panel with LVDS controller (LCD resolution is 800x480, 18 bpp, 60Hz)

Ok

> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set

Ok

> CONFIG_DRM_GMA500=y
> # CONFIG_DRM_GMA600 is not set
> CONFIG_DRM_GMA3600=y

Ditto

> To boot my new kernel I use these parameters: video=LVDS-1:800x480-18@60D drm.debug=0x06
> 
> The kernel boots correctly but the LCD screen is completely black (with backlight off).
> Using SSH I can login to my system and have a look at dmesg:
> 

> [    5.749614] [drm:cdv_get_max_backlight], LVDS Panel PWM value is 0!
> [    5.749622] [drm:cdv_get_max_backlight], LVDS Panel PWM value is 0!
> [    5.749633] [drm] Initialized gma500 1.0.0 2011-06-06 for 0000:00:02.0 on minor 0

So the panel backlight register is set to indicate that the brightness
will be handled by the firmware in some other way and not by the graphics.
Do you have ACPI backlight support in your kernel ? Do you have the LVDS
panel enabled in the BIOS ?

It could be the value hasn't been initialised when it should have been,
it could be your hardware has some other interface for this.

If you look at cdv_device.c you'll see cdv_get_max_backlight() checks for
this case. If you can find out what the value should be then you can
substitute

        if (max == 0) {
                DRM_DEBUG_KMS("LVDS Panel PWM value is 0!\n");
                /* i915 does this, I believe which means that we should
                 * smash PWM control as firmware will take control of it.
        	return 1;
        }


with
	if (max == 0)
		max = max_value << 16;

and test that case. If that doesn't work then probably the backlight is
wired some other way. If ACPI handles it you may be able to handle it
that way. If it's a custom driver interface in Windows you may have a
problem.

Alan



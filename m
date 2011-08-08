Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1HHF6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 01:58:07 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:52158 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1HHF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 01:58:01 -0400
Date: Sun, 7 Aug 2011 22:57:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Anssi Hannula <anssi.hannula@iki.fi>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] [media] ati_remote: add keymap for Medion X10 RF
 remote
Message-ID: <20110808055754.GB7329@core.coreip.homeip.net>
References: <4E3DB2C2.7040104@iki.fi>
 <1312669093-23771-1-git-send-email-anssi.hannula@iki.fi>
 <1312669093-23771-6-git-send-email-anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1312669093-23771-6-git-send-email-anssi.hannula@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 01:18:11AM +0300, Anssi Hannula wrote:
> Add keymap for the Medion X10 RF remote which uses the ati_remote
> driver, and default to it based on the usb id.

Since rc-core supports loading custom keytmaps should we ass medion
keymap here?

I think we should keep the original keymap to avoid regressions, but new
keymaps should be offloaded to udev.

Thanks.

> 
> The keymap is adapted from an earlier patch by
> Jan Losinski <losinski@wh2.tu-dresden.de>:
> https://lkml.org/lkml/2011/4/18/104
> with KEY_PLAYPAUSE replaced by KEY_PAUSE.
> 
> Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
> ---
>  drivers/media/rc/ati_remote.c            |   17 +++--
>  drivers/media/rc/keymaps/Makefile        |    1 +
>  drivers/media/rc/keymaps/rc-medion-x10.c |  116 ++++++++++++++++++++++++++++++
>  include/media/rc-map.h                   |    1 +
>  4 files changed, 128 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/media/rc/keymaps/rc-medion-x10.c
> 
> diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
> index 74cc6b1..4576462 100644
> --- a/drivers/media/rc/ati_remote.c
> +++ b/drivers/media/rc/ati_remote.c
> @@ -151,11 +151,11 @@ MODULE_PARM_DESC(mouse, "Enable mouse device, default = yes");
>  #define err(format, arg...) printk(KERN_ERR format , ## arg)
>  
>  static struct usb_device_id ati_remote_table[] = {
> -	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID) },
> -	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID) },
> -	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID) },
> -	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID) },
> -	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID) },
> +	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_ATI_X10 },
> +	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA2_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_ATI_X10 },
> +	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, ATI_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_ATI_X10 },
> +	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, NVIDIA_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_ATI_X10 },
> +	{ USB_DEVICE(ATI_REMOTE_VENDOR_ID, MEDION_REMOTE_PRODUCT_ID),	.driver_info = (unsigned long)RC_MAP_MEDION_X10 },
>  	{}	/* Terminating entry */
>  };
>  
> @@ -714,8 +714,6 @@ static void ati_remote_rc_init(struct ati_remote *ati_remote)
>  
>  	usb_to_input_id(ati_remote->udev, &rdev->input_id);
>  	rdev->dev.parent = &ati_remote->interface->dev;
> -
> -	rdev->map_name = RC_MAP_ATI_X10;
>  }
>  
>  static int ati_remote_initialize(struct ati_remote *ati_remote)
> @@ -827,6 +825,11 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
>  	snprintf(ati_remote->mouse_name, sizeof(ati_remote->mouse_name),
>  		 "%s mouse", ati_remote->rc_name);
>  
> +	if (id->driver_info)
> +		rc_dev->map_name = (const char *)id->driver_info;
> +	else
> +		rc_dev->map_name = RC_MAP_ATI_X10;
> +
>  	ati_remote_rc_init(ati_remote);
>  	mutex_init(&ati_remote->open_mutex);
>  	
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index 3ca9265b7..c3d0f34 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -48,6 +48,7 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-lirc.o \
>  			rc-lme2510.o \
>  			rc-manli.o \
> +			rc-medion-x10.o \
>  			rc-msi-digivox-ii.o \
>  			rc-msi-digivox-iii.o \
>  			rc-msi-tvanywhere.o \
> diff --git a/drivers/media/rc/keymaps/rc-medion-x10.c b/drivers/media/rc/keymaps/rc-medion-x10.c
> new file mode 100644
> index 0000000..ff62aab
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-medion-x10.c
> @@ -0,0 +1,116 @@
> +/*
> + * Medion X10 RF remote keytable
> + *
> + * Copyright (C) 2011 Anssi Hannula <anssi.hannula@ıki.fi>
> + *
> + * This file is based on a keytable provided by
> + * Jan Losinski <losinski@wh2.tu-dresden.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +
> +#include <media/rc-map.h>
> +
> +static struct rc_map_table medion_x10[] = {
> +	{ 0xf12c, KEY_TV },    /* TV */
> +	{ 0xf22d, KEY_VCR },   /* VCR */
> +	{ 0xc904, KEY_DVD },   /* DVD */
> +	{ 0xcb06, KEY_AUDIO }, /* MUSIC */
> +
> +	{ 0xf32e, KEY_RADIO },     /* RADIO */
> +	{ 0xca05, KEY_DIRECTORY }, /* PHOTO */
> +	{ 0xf42f, KEY_INFO },      /* TV-PREVIEW */
> +	{ 0xf530, KEY_LIST },      /* CHANNEL-LST */
> +
> +	{ 0xe01b, KEY_SETUP }, /* SETUP */
> +	{ 0xf631, KEY_VIDEO }, /* VIDEO DESKTOP */
> +
> +	{ 0xcd08, KEY_VOLUMEDOWN },  /* VOL - */
> +	{ 0xce09, KEY_VOLUMEUP },    /* VOL + */
> +	{ 0xd00b, KEY_CHANNELUP },   /* CHAN + */
> +	{ 0xd10c, KEY_CHANNELDOWN }, /* CHAN - */
> +	{ 0xc500, KEY_MUTE },        /* MUTE */
> +
> +	{ 0xf732, KEY_RED }, /* red */
> +	{ 0xf833, KEY_GREEN }, /* green */
> +	{ 0xf934, KEY_YELLOW }, /* yellow */
> +	{ 0xfa35, KEY_BLUE }, /* blue */
> +	{ 0xdb16, KEY_TEXT }, /* TXT */
> +
> +	{ 0xd20d, KEY_1 },
> +	{ 0xd30e, KEY_2 },
> +	{ 0xd40f, KEY_3 },
> +	{ 0xd510, KEY_4 },
> +	{ 0xd611, KEY_5 },
> +	{ 0xd712, KEY_6 },
> +	{ 0xd813, KEY_7 },
> +	{ 0xd914, KEY_8 },
> +	{ 0xda15, KEY_9 },
> +	{ 0xdc17, KEY_0 },
> +	{ 0xe11c, KEY_SEARCH }, /* TV/RAD, CH SRC */
> +	{ 0xe520, KEY_DELETE }, /* DELETE */
> +
> +	{ 0xfb36, KEY_KEYBOARD }, /* RENAME */
> +	{ 0xdd18, KEY_SCREEN },   /* SNAPSHOT */
> +
> +	{ 0xdf1a, KEY_UP },    /* up */
> +	{ 0xe722, KEY_DOWN },  /* down */
> +	{ 0xe21d, KEY_LEFT },  /* left */
> +	{ 0xe41f, KEY_RIGHT }, /* right */
> +	{ 0xe31e, KEY_OK },    /* OK */
> +
> +	{ 0xfc37, KEY_SELECT }, /* ACQUIRE IMAGE */
> +	{ 0xfd38, KEY_EDIT },   /* EDIT IMAGE */
> +
> +	{ 0xe924, KEY_REWIND },   /* rewind  (<<) */
> +	{ 0xea25, KEY_PLAY },     /* play    ( >) */
> +	{ 0xeb26, KEY_FORWARD },  /* forward (>>) */
> +	{ 0xec27, KEY_RECORD },   /* record  ( o) */
> +	{ 0xed28, KEY_STOP },     /* stop    ([]) */
> +	{ 0xee29, KEY_PAUSE },    /* pause   ('') */
> +
> +	{ 0xe621, KEY_PREVIOUS },        /* prev */
> +	{ 0xfe39, KEY_SWITCHVIDEOMODE }, /* F SCR */
> +	{ 0xe823, KEY_NEXT },            /* next */
> +	{ 0xde19, KEY_MENU },            /* MENU */
> +	{ 0xff3a, KEY_LANGUAGE },        /* AUDIO */
> +
> +	{ 0xc702, KEY_POWER }, /* POWER */
> +};
> +
> +static struct rc_map_list medion_x10_map = {
> +	.map = {
> +		.scan    = medion_x10,
> +		.size    = ARRAY_SIZE(medion_x10),
> +		.rc_type = RC_TYPE_OTHER,
> +		.name    = RC_MAP_MEDION_X10,
> +	}
> +};
> +
> +static int __init init_rc_map_medion_x10(void)
> +{
> +	return rc_map_register(&medion_x10_map);
> +}
> +
> +static void __exit exit_rc_map_medion_x10(void)
> +{
> +	rc_map_unregister(&medion_x10_map);
> +}
> +
> +module_init(init_rc_map_medion_x10)
> +module_exit(exit_rc_map_medion_x10)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Anssi Hannula <anssi.hannula@iki.fi>");
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index 09e4451..86e7e85 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -106,6 +106,7 @@ void rc_map_init(void);
>  #define RC_MAP_LIRC                      "rc-lirc"
>  #define RC_MAP_LME2510                   "rc-lme2510"
>  #define RC_MAP_MANLI                     "rc-manli"
> +#define RC_MAP_MEDION_X10                "rc-medion-x10"
>  #define RC_MAP_MSI_DIGIVOX_II            "rc-msi-digivox-ii"
>  #define RC_MAP_MSI_DIGIVOX_III           "rc-msi-digivox-iii"
>  #define RC_MAP_MSI_TVANYWHERE_PLUS       "rc-msi-tvanywhere-plus"
> -- 
> 1.7.4.4
> 

-- 
Dmitry

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab1EYQcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:32:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63124 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758000Ab1EYQcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qkTXlrFU3i9ywpsaOSQneE1htglOFd0qKAYBPJSYfssDSWH8C1deIoXYAyLJ4Q9SMr
         QCQo49cInHQ7DkD7HuPkkLvELK5UB4t1ZeIHoVXz43B/Eu8Vhq/M5reWTkY+ap/VMqSV
         +eKLu4TRIOHZ2eeljj0Pl/8KdEsxzFh8o+VPQ=
Date: Wed, 25 May 2011 09:32:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [PATCH 1/1] Input: ati_remote - extend keytable for medion
 remotes
Message-ID: <20110525163204.GD22517@core.coreip.homeip.net>
References: <20110418104108.GA4876@atlantis.wh2.tu-dresden.de.de>
 <20110418104547.GB4876@atlantis.wh2.tu-dresden.de.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418104547.GB4876@atlantis.wh2.tu-dresden.de.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

On Mon, Apr 18, 2011 at 12:45:47PM +0200, Jan Losinski wrote:
> This extends the ati_remote to support multiple keytables. The table
> will be selected with the productId of the device.
> 
> It also provides a table for the medion rf remote control that enables
> all buttons on it.
> 

I am not a big fan of static keymaps in kernel drivers and would much
more prefer driver supporting adjusting keymaps via EVIOCSKEYCODE
ioctls. Unfortunately ati_remote key handling code is kind of involved
and I am not sure what is the best way of wiring it up.

I believe Anssi Hannula (CCed) mentioned that he has a version of
ati_remove ported to rc-core infrastructure that supports such
remapping. Anssi, could you tell me what is the status of that driver?
Is it usable with rc-core?

Thanks.

> Signed-off-by: Jan Losinski <losinski@wh2.tu-dresden.de>
> ---
>  drivers/input/misc/ati_remote.c |  155 ++++++++++++++++++++++++++++++++-------
>  1 files changed, 128 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/input/misc/ati_remote.c b/drivers/input/misc/ati_remote.c
> index bce5712..74a3d5c 100644
> --- a/drivers/input/misc/ati_remote.c
> +++ b/drivers/input/misc/ati_remote.c
> @@ -165,6 +165,14 @@ MODULE_DEVICE_TABLE(usb, ati_remote_table);
>  static char init1[] = { 0x01, 0x00, 0x20, 0x14 };
>  static char init2[] = { 0x01, 0x00, 0x20, 0x14, 0x20, 0x20, 0x20 };
>  
> +struct ati_event_table {
> +	short kind;
> +	unsigned char data1, data2;
> +	int type;
> +	unsigned int code;
> +	int value;
> +};
> +
>  struct ati_remote {
>  	struct input_dev *idev;
>  	struct usb_device *udev;
> @@ -191,6 +199,8 @@ struct ati_remote {
>  
>  	wait_queue_head_t wait;
>  	int send_flags;
> +
> +	const struct ati_event_table *event_table;
>  };
>  
>  /* "Kinds" of messages sent from the hardware to the driver. */
> @@ -204,13 +214,7 @@ struct ati_remote {
>  #define KIND_ACCEL      7   /* Directional keypad - left, right, up, down.*/
>  
>  /* Translation table from hardware messages to input events. */
> -static const struct {
> -	short kind;
> -	unsigned char data1, data2;
> -	int type;
> -	unsigned int code;
> -	int value;
> -}  ati_remote_tbl[] = {
> +static const struct  ati_event_table ati_dflt_event_tbl[] = {
>  	/* Directional control pad axes */
>  	{KIND_ACCEL,   0x35, 0x70, EV_REL, REL_X, -1},	 /* left */
>  	{KIND_ACCEL,   0x36, 0x71, EV_REL, REL_X, 1},    /* right */
> @@ -288,6 +292,88 @@ static const struct {
>  	{KIND_END, 0x00, 0x00, EV_MAX + 1, 0, 0}
>  };
>  
> +/* Translation table from hardware messages to input events.
> + * Special version for the Medion Remote */
> +static const struct ati_event_table ati_medion_event_tbl[] = {
> +
> +	{KIND_FILTERED, 0xf1, 0x2c, EV_KEY, KEY_TV, 1},    /* TV */
> +	{KIND_FILTERED, 0xf2, 0x2d, EV_KEY, KEY_VCR, 1},   /* VCR */
> +	{KIND_FILTERED, 0xc9, 0x04, EV_KEY, KEY_DVD, 1},   /* DVD */
> +	{KIND_FILTERED, 0xcb, 0x06, EV_KEY, KEY_AUDIO, 1}, /* MUSIC */
> +
> +	{KIND_FILTERED, 0xf3, 0x2e, EV_KEY, KEY_RADIO, 1},     /* RADIO */
> +	{KIND_FILTERED, 0xca, 0x05, EV_KEY, KEY_DIRECTORY, 1}, /* PHOTO */
> +	{KIND_FILTERED, 0xf4, 0x2f, EV_KEY, KEY_INFO, 1},      /* TV-PREVIEW */
> +	{KIND_FILTERED, 0xf5, 0x30, EV_KEY, KEY_LIST, 1},      /* CHANNEL-LST */
> +
> +	{KIND_FILTERED, 0xe0, 0x1b, EV_KEY, KEY_SETUP, 1}, /* SETUP */
> +	{KIND_FILTERED, 0xf6, 0x31, EV_KEY, KEY_VIDEO, 1}, /* VIDEO DESKTOP */
> +
> +	{KIND_FILTERED, 0xcd, 0x08, EV_KEY, KEY_VOLUMEDOWN, 1},  /* VOL - */
> +	{KIND_FILTERED, 0xce, 0x09, EV_KEY, KEY_VOLUMEUP, 1},    /* VOL + */
> +	{KIND_FILTERED, 0xd0, 0x0b, EV_KEY, KEY_CHANNELUP, 1},   /* CHAN + */
> +	{KIND_FILTERED, 0xd1, 0x0c, EV_KEY, KEY_CHANNELDOWN, 1}, /* CHAN - */
> +	{KIND_FILTERED, 0xc5, 0x00, EV_KEY, KEY_MUTE, 1},        /* MUTE */
> +
> +	{KIND_FILTERED, 0xf7, 0x32, EV_KEY, KEY_RED, 1}, /* red */
> +	{KIND_FILTERED, 0xf8, 0x33, EV_KEY, KEY_GREEN, 1}, /* green */
> +	{KIND_FILTERED, 0xf9, 0x34, EV_KEY, KEY_YELLOW, 1}, /* yellow */
> +	{KIND_FILTERED, 0xfa, 0x35, EV_KEY, KEY_BLUE, 1}, /* blue */
> +	{KIND_FILTERED, 0xdb, 0x16, EV_KEY, KEY_TEXT, 1}, /* TXT */
> +
> +	/* keyboard. */
> +	{KIND_FILTERED, 0xd2, 0x0d, EV_KEY, KEY_1, 1},
> +	{KIND_FILTERED, 0xd3, 0x0e, EV_KEY, KEY_2, 1},
> +	{KIND_FILTERED, 0xd4, 0x0f, EV_KEY, KEY_3, 1},
> +	{KIND_FILTERED, 0xd5, 0x10, EV_KEY, KEY_4, 1},
> +	{KIND_FILTERED, 0xd6, 0x11, EV_KEY, KEY_5, 1},
> +	{KIND_FILTERED, 0xd7, 0x12, EV_KEY, KEY_6, 1},
> +	{KIND_FILTERED, 0xd8, 0x13, EV_KEY, KEY_7, 1},
> +	{KIND_FILTERED, 0xd9, 0x14, EV_KEY, KEY_8, 1},
> +	{KIND_FILTERED, 0xda, 0x15, EV_KEY, KEY_9, 1},
> +	{KIND_FILTERED, 0xdc, 0x17, EV_KEY, KEY_0, 1},
> +	{KIND_FILTERED, 0xe1, 0x1c, EV_KEY, KEY_SEARCH, 1}, /* TV/RAD, CH SRC */
> +	{KIND_FILTERED, 0xe5, 0x20, EV_KEY, KEY_DELETE, 1}, /* DELETE */
> +
> +	{KIND_FILTERED, 0xfb, 0x36, EV_KEY, KEY_KEYBOARD, 1}, /* RENAME */
> +	{KIND_FILTERED, 0xdd, 0x18, EV_KEY, KEY_SCREEN, 1},   /* SNAPSHOT */
> +
> +	{KIND_FILTERED, 0xdf, 0x1a, EV_KEY, KEY_UP, 1},    /* up */
> +	{KIND_FILTERED, 0xe7, 0x22, EV_KEY, KEY_DOWN, 1},  /* down */
> +	{KIND_FILTERED, 0xe2, 0x1d, EV_KEY, KEY_LEFT, 1},  /* left */
> +	{KIND_FILTERED, 0xe4, 0x1f, EV_KEY, KEY_RIGHT, 1}, /* right */
> +	{KIND_FILTERED, 0xe3, 0x1e, EV_KEY, KEY_OK, 1},    /* OK */
> +
> +	{KIND_FILTERED, 0xfc, 0x37, EV_KEY, KEY_SELECT, 1}, /* AQUIRE IMAGE */
> +	{KIND_FILTERED, 0xfd, 0x38, EV_KEY, KEY_EDIT, 1},   /* EDIT IMAGE */
> +
> +	{KIND_FILTERED, 0xe9, 0x24, EV_KEY, KEY_REWIND, 1},   /* rewind  (<<) */
> +	{KIND_FILTERED, 0xea, 0x25, EV_KEY, KEY_PLAY, 1},     /* play    ( >) */
> +	{KIND_FILTERED, 0xeb, 0x26, EV_KEY, KEY_FORWARD, 1},  /* forward (>>) */
> +	{KIND_FILTERED, 0xec, 0x27, EV_KEY, KEY_RECORD, 1},   /* record  ( o) */
> +	{KIND_FILTERED, 0xed, 0x28, EV_KEY, KEY_STOP, 1},     /* stop    ([]) */
> +	{KIND_FILTERED, 0xee, 0x29, EV_KEY, KEY_PLAYPAUSE, 1},/* pause   ('') */
> +
> +	{KIND_FILTERED, 0xe6, 0x21, EV_KEY, KEY_PREVIOUS, 1},        /* prev */
> +	{KIND_FILTERED, 0xfe, 0x39, EV_KEY, KEY_SWITCHVIDEOMODE, 1}, /* F SCR */
> +	{KIND_FILTERED, 0xe8, 0x23, EV_KEY, KEY_NEXT, 1},            /* next */
> +	{KIND_FILTERED, 0xde, 0x19, EV_KEY, KEY_MENU, 1},            /* MENU */
> +	{KIND_FILTERED, 0xff, 0x3a, EV_KEY, KEY_LANGUAGE, 1},        /* AUDIO */
> +
> +	{KIND_FILTERED, 0xc7, 0x02, EV_KEY, KEY_POWER, 1}, /* POWER */
> +
> +	{KIND_END, 0x00, 0x00, EV_MAX + 1, 0, 0}
> +};
> +
> +/* key translation assignment table */
> +static const struct {
> +	__u16 product_id;
> +	const struct ati_event_table * const table;
> +} ati_remotes_table[] = {
> +	{MEDION_REMOTE_PRODUCT_ID, ati_medion_event_tbl},
> +	{}	/* Terminating entry */
> +};
> +
>  /* Local function prototypes */
>  static int ati_remote_open		(struct input_dev *inputdev);
>  static void ati_remote_close		(struct input_dev *inputdev);
> @@ -405,7 +491,8 @@ static int ati_remote_sendpacket(struct ati_remote *ati_remote, u16 cmd, unsigne
>  /*
>   *	ati_remote_event_lookup
>   */
> -static int ati_remote_event_lookup(int rem, unsigned char d1, unsigned char d2)
> +static int ati_remote_event_lookup(const struct ati_event_table *ati_remote_tbl,
> +				   int rem, unsigned char d1, unsigned char d2)
>  {
>  	int i;
>  
> @@ -489,7 +576,8 @@ static void ati_remote_input_report(struct urb *urb)
>  	}
>  
>  	/* Look up event code index in translation table */
> -	index = ati_remote_event_lookup(remote_num, data[1], data[2]);
> +	index = ati_remote_event_lookup(ati_remote->event_table,
> +					remote_num, data[1], data[2]);
>  	if (index < 0) {
>  		dev_warn(&ati_remote->interface->dev,
>  			 "Unknown input from channel 0x%02x: data %02x,%02x\n",
> @@ -498,19 +586,20 @@ static void ati_remote_input_report(struct urb *urb)
>  	}
>  	dbginfo(&ati_remote->interface->dev,
>  		"channel 0x%02x; data %02x,%02x; index %d; keycode %d\n",
> -		remote_num, data[1], data[2], index, ati_remote_tbl[index].code);
> +		remote_num, data[1], data[2], index,
> +		ati_remote->event_table[index].code);
>  
> -	if (ati_remote_tbl[index].kind == KIND_LITERAL) {
> -		input_event(dev, ati_remote_tbl[index].type,
> -			ati_remote_tbl[index].code,
> -			ati_remote_tbl[index].value);
> +	if (ati_remote->event_table[index].kind == KIND_LITERAL) {
> +		input_event(dev, ati_remote->event_table[index].type,
> +			ati_remote->event_table[index].code,
> +			ati_remote->event_table[index].value);
>  		input_sync(dev);
>  
>  		ati_remote->old_jiffies = jiffies;
>  		return;
>  	}
>  
> -	if (ati_remote_tbl[index].kind == KIND_FILTERED) {
> +	if (ati_remote->event_table[index].kind == KIND_FILTERED) {
>  		unsigned long now = jiffies;
>  
>  		/* Filter duplicate events which happen "too close" together. */
> @@ -539,11 +628,11 @@ static void ati_remote_input_report(struct urb *urb)
>  			return;
>  
>  
> -		input_event(dev, ati_remote_tbl[index].type,
> -			ati_remote_tbl[index].code, 1);
> +		input_event(dev, ati_remote->event_table[index].type,
> +			ati_remote->event_table[index].code, 1);
>  		input_sync(dev);
> -		input_event(dev, ati_remote_tbl[index].type,
> -			ati_remote_tbl[index].code, 0);
> +		input_event(dev, ati_remote->event_table[index].type,
> +			ati_remote->event_table[index].code, 0);
>  		input_sync(dev);
>  
>  	} else {
> @@ -555,11 +644,11 @@ static void ati_remote_input_report(struct urb *urb)
>  		 */
>  		acc = ati_remote_compute_accel(ati_remote);
>  
> -		switch (ati_remote_tbl[index].kind) {
> +		switch (ati_remote->event_table[index].kind) {
>  		case KIND_ACCEL:
> -			input_event(dev, ati_remote_tbl[index].type,
> -				ati_remote_tbl[index].code,
> -				ati_remote_tbl[index].value * acc);
> +			input_event(dev, ati_remote->event_table[index].type,
> +				ati_remote->event_table[index].code,
> +				ati_remote->event_table[index].value * acc);
>  			break;
>  		case KIND_LU:
>  			input_report_rel(dev, REL_X, -acc);
> @@ -579,7 +668,7 @@ static void ati_remote_input_report(struct urb *urb)
>  			break;
>  		default:
>  			dev_dbg(&ati_remote->interface->dev, "ati_remote kind=%d\n",
> -				ati_remote_tbl[index].kind);
> +				ati_remote->event_table[index].kind);
>  		}
>  		input_sync(dev);
>  
> @@ -669,9 +758,9 @@ static void ati_remote_input_init(struct ati_remote *ati_remote)
>  	idev->keybit[BIT_WORD(BTN_MOUSE)] = BIT_MASK(BTN_LEFT) |
>  		BIT_MASK(BTN_RIGHT) | BIT_MASK(BTN_SIDE) | BIT_MASK(BTN_EXTRA);
>  	idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y);
> -	for (i = 0; ati_remote_tbl[i].kind != KIND_END; i++)
> -		if (ati_remote_tbl[i].type == EV_KEY)
> -			set_bit(ati_remote_tbl[i].code, idev->keybit);
> +	for (i = 0; ati_remote->event_table[i].kind != KIND_END; i++)
> +		if (ati_remote->event_table[i].type == EV_KEY)
> +			set_bit(ati_remote->event_table[i].code, idev->keybit);
>  
>  	input_set_drvdata(idev, ati_remote);
>  
> @@ -736,6 +825,7 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
>  	struct ati_remote *ati_remote;
>  	struct input_dev *input_dev;
>  	int err = -ENOMEM;
> +	int i;
>  
>  	if (iface_host->desc.bNumEndpoints != 2) {
>  		err("%s: Unexpected desc.bNumEndpoints\n", __func__);
> @@ -785,6 +875,17 @@ static int ati_remote_probe(struct usb_interface *interface, const struct usb_de
>  			le16_to_cpu(ati_remote->udev->descriptor.idVendor),
>  			le16_to_cpu(ati_remote->udev->descriptor.idProduct));
>  
> +	/* choose the right translation table */
> +	ati_remote->event_table = ati_dflt_event_tbl;
> +	for (i = 0; ati_remotes_table[i].product_id ||
> +	     ati_remotes_table[i].table; i++) {
> +		if (le16_to_cpu(ati_remote->udev->descriptor.idProduct) ==
> +		    ati_remotes_table[i].product_id) {
> +			ati_remote->event_table = ati_remotes_table[i].table;
> +			break;
> +		}
> +	}
> +
>  	ati_remote_input_init(ati_remote);
>  
>  	/* Device Hardware Initialization - fills in ati_remote->idev from udev. */
> -- 
> 1.7.4.1
> 



-- 
Dmitry

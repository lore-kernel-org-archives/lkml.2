Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2LSIkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 03:40:53 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:43310 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2LSIkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 03:40:46 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AthMAMd80VBV5qjOPGdsb2JhbABEhVKFI7MeFwMBAQEBODSCHgEBBAEnExwjBQsIA0YUJQoaE4gNCrglFJAZYQOSV4MyhXuNQw
X-IronPort-AV: E=Sophos;i="4.84,315,1355094000"; 
   d="scan'208";a="471981586"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 19 Dec 2012 09:41:13 +0100
To: Christophe TORDEUX <christophe@tordeux.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tai-hwa Liang <avatar@sentelic.com>, Oskari Saarenmaa <os@ohmu.fi>,
        Paul Fox <pgf@laptop.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 01/01] Input multitouch: fix horizontal
 two-finger-scrolling on Sentelic touchpads
Message-ID: <20121219084113.GA2758@polaris.bitmath.org>
References: <20121212012135.GA9043@sherka.no-ip.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121212012135.GA9043@sherka.no-ip.biz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christophe,

> Fix horizontal two-finger scrolling on Sentelic touchpads. Currently
> horizontal two-fingers scrolling does not work with these touchpads.
> The patch also makes vertical two-finger scrolling smoother in some
> applications e.g. Firefox.
> 
> Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
> ----
> 
> This patch was inspired by the reading of
> drivers/input/mouse/synaptics.c. It is known to work (tested) on
> Sentelic touchpads version STL3888_C0. Very probably works on all later
> versions, and possibly works on some earlier versions of the hardware in
> question.

Thanks for the patch. I would prefer it if this driver was converted
to use input_mt_assign_slots() instead.

> 
> diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff 
> vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.c 
> linux-3.7-rc8/drivers/input/mouse/sentelic.c
> --- vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.c	2012-12-11 04:32:44.476930522 +0100
> +++ linux-3.7-rc8/drivers/input/mouse/sentelic.c	2012-12-12 01:16:41.766018017 +0100
> @@ -706,8 +706,10 @@ static psmouse_ret_t fsp_process_byte(st
>  	struct input_dev *dev = psmouse->dev;
>  	struct fsp_data *ad = psmouse->private;
>  	unsigned char *packet = psmouse->packet;
> +	unsigned char *last_packet = ad->last_pkt;
>  	unsigned char button_status = 0, lscroll = 0, rscroll = 0;
>  	unsigned short abs_x, abs_y, fgrs = 0;
> +	unsigned short last_abs_x, last_abs_y;
>  	int rel_x, rel_y;
>  
>  	if (psmouse->pktcnt < 4)
> @@ -734,6 +736,9 @@ static psmouse_ret_t fsp_process_byte(st
>  
>  		abs_x = GET_ABS_X(packet);
>  		abs_y = GET_ABS_Y(packet);
> +		last_abs_x = GET_ABS_X(last_packet);
> +		last_abs_y = GET_ABS_Y(last_packet);
> +		memcpy(ad->last_pkt, packet, psmouse->pktcnt);

Why not save the variables instead of the array?

>  
>  		if (packet[0] & FSP_PB0_MFMC) {
>  			/*
> @@ -753,10 +758,19 @@ static psmouse_ret_t fsp_process_byte(st
>  					 */
>  					fgrs = 1;
>  					fsp_set_slot(dev, 0, false, 0, 0);
> +
> +					/* We don't need to re-order
> +					 * coordinates if last finger
> +					 * was same finger
> +					 */
> +					last_abs_x = abs_x;
> +					last_abs_y = abs_y;
>  				}
>  				ad->last_mt_fgr = 2;
>  
> -				fsp_set_slot(dev, 1, fgrs == 2, abs_x, abs_y);
> +				fsp_set_slot(dev, 1, fgrs == 2,
> +						max(abs_x, last_abs_x),
> +						max(abs_y, last_abs_y));

Relying on the box (x1, y1, max(x1, x2), max(y1, y2)) seems to assume
a lot about the behavior of the device.

>  			} else {
>  				/* 1st finger */
>  				if (ad->last_mt_fgr == 1) {
> @@ -767,9 +781,18 @@ static psmouse_ret_t fsp_process_byte(st
>  					 */
>  					fgrs = 1;
>  					fsp_set_slot(dev, 1, false, 0, 0);
> +
> +					/* We don't need to re-order
> +					 * coordinates if last finger
> +					 * was same finger
> +					 */
> +					last_abs_x = abs_x;
> +					last_abs_y = abs_y;
>  				}
>  				ad->last_mt_fgr = 1;
> -				fsp_set_slot(dev, 0, fgrs != 0, abs_x, abs_y);
> +				fsp_set_slot(dev, 0, fgrs != 0,
> +						min(abs_x, last_abs_x),
> +						min(abs_y, last_abs_y));
>  			}
>  		} else {
>  			/* SFAC packet */
> @@ -788,12 +811,18 @@ static psmouse_ret_t fsp_process_byte(st
>  			if (abs_x != 0 && abs_y != 0)
>  				fgrs = 1;
>  
> +			/* We don't need to re-order
> +			 * coordinates of SFAC packets
> +			 */
> +			last_abs_x = abs_x;
> +			last_abs_y = abs_y;
> +
>  			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
>  			fsp_set_slot(dev, 1, false, 0, 0);
>  		}
>  		if (fgrs > 0) {
> -			input_report_abs(dev, ABS_X, abs_x);
> -			input_report_abs(dev, ABS_Y, abs_y);
> +			input_report_abs(dev, ABS_X, min(abs_x, last_abs_x));
> +			input_report_abs(dev, ABS_Y, min(abs_y, last_abs_y));

Looks like this point could differ from the reported MT positions.

>  		}
>  		input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
>  		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
> diff -uprN -X vanilla/linux-3.7-rc8/Documentation/dontdiff vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.h linux-3.7-rc8/drivers/input/mouse/sentelic.h
> --- vanilla/linux-3.7-rc8/drivers/input/mouse/sentelic.h	2012-12-11 04:32:44.476930522 +0100
> +++ linux-3.7-rc8/drivers/input/mouse/sentelic.h	2012-12-12 01:16:41.954018011 +0100
> @@ -117,6 +117,7 @@ struct fsp_data {
>  	unsigned char	last_reg;	/* Last register we requested read from */
>  	unsigned char	last_val;
>  	unsigned int	last_mt_fgr;	/* Last seen finger(multitouch) */
> +	unsigned char	last_pkt[8];    /* Last packet we processed from fsp */
>  };
>  
>  #ifdef CONFIG_MOUSE_PS2_SENTELIC

Thanks.
Henrik


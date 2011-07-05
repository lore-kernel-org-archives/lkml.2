Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GERxS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:53:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:40975 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1GERxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:53:17 -0400
Message-ID: <4E134F87.6080504@canonical.com>
Date: Tue, 05 Jul 2011 10:53:11 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: djkurtz@chromium.org
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Subject: Re: [PATCH 07/12] Input: synaptics - rename synaptics_data.mt to
 agm
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org> <1309324042-22943-8-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1309324042-22943-8-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 10:07 PM, djkurtz@chromium.org wrote:
> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Rename the synaptics_data.mt field to priv->agm to indicate it is the
> hardware state reported in a synaptics AGM packet.
> 
> When a Synaptics touchpad is in "AGM" mode, and multiple fingers are
> detected, the touchpad sends alternating "Advanced Gesture Mode" (AGM) and
> "Simple Gesture Mode" (SGM) packets.
>   The AGM packets have w=2, and contain reduced resolution finger data.
>   The SGM packets have w={0,1} and contain full resolution finger data.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/synaptics.c |    9 +++++----
>  drivers/input/mouse/synaptics.h |    2 +-
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index dc54675..4e5e454 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -436,10 +436,10 @@ static int synaptics_parse_hw_state(const unsigned char buf[],
>  
>  		if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) && hw->w == 2) {
>  			/* Gesture packet: (x, y, z) at half resolution */
> -			priv->mt.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
> -			priv->mt.y = INVERT_Y((((buf[4] & 0xf0) << 4)
> +			priv->agm.x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
> +			priv->agm.y = INVERT_Y((((buf[4] & 0xf0) << 4)
>  					      | buf[2]) << 1);
> -			priv->mt.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
> +			priv->agm.z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
>  			return 1;
>  		} else {
>  			hw->x = (((buf[3] & 0x10) << 8) |
> @@ -576,7 +576,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>  	}
>  
>  	if (SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
> -		synaptics_report_semi_mt_data(dev, &hw, &priv->mt, num_fingers);
> +		synaptics_report_semi_mt_data(dev, &hw, &priv->agm,
> +					      num_fingers);
>  
>  	/* Post events
>  	 * BTN_TOUCH has to be first as mousedev relies on it when doing
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index 8a68e66..e367239 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -147,7 +147,7 @@ struct synaptics_data {
>  
>  	struct serio *pt_port;			/* Pass-through serio port */
>  
> -	struct synaptics_hw_state mt;		/* current gesture packet */
> +	struct synaptics_hw_state agm;		/* last AGM packet */
>  };
>  
>  void synaptics_module_init(void);

I'm fine with changing the name of the element, especially if it
conforms to some protocol documentation. I'd like to ask that AGM be
spelled out in the comment, with a note that it contains half-resolution
second-touch data.

Otherwise:

Acked-by: Chase Douglas <chase.douglas@canonical.com>

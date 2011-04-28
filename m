Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab1D1I5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:57:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52417 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1D1I52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:57:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=QHfFYvzvl4tTPAIf5BW1P3MpfKymLW7Wwbqn5a0LWccb9MBS6L36qmunEh3h/z71Zj
         GfvuY3l33tugbkhWQihsBQu9kXpJSW0ucWFWd3oHEPCSLC+ym0aKl8xuWRK8ciap0olT
         ZL6gDg9dmU6H7QtI48n6AyL0F7Et81IL2y1Pw=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Date: Thu, 28 Apr 2011 18:55:50 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r3; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com>
In-Reply-To: <201104201358.50443.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104281855.50572.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure of the "bump" process, so I'll just go over each part of the patch.

Note that all the changes only affect the sabi_config where min_brightness
is 1 so you might not see in difference on your hardware.

On Wed, 20 Apr 2011 13:58:50 Jason Stubbs wrote:
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -370,15 +370,17 @@ static u8 read_brightness(void)
>  				  &sretval);
>  	if (!retval) {
>  		user_brightness = sretval.retval[0];
> -		if (user_brightness != 0)
> +		if (user_brightness > sabi_config->min_brightness)
>  			user_brightness -= sabi_config->min_brightness;
> +		else
> +			user_brightness = 0;

min_brightness is (and probably will always be) only 0 or 1 in the current
sabi_configs, so this patch doesn't actually change present behaviour. Should
there ever be a min_brightness > 1, however, this patch will be required or
user_brightness will end up going below 0 and wrapping around.

>  static void set_brightness(u8 user_brightness)
>  {
> -	u8 user_level = user_brightness - sabi_config->min_brightness;
> +	u8 user_level = user_brightness + sabi_config->min_brightness;

The sign here is definitely wrong. If the user sets a brightness of 0 when
using a sabi_config with a min_brightness of 1, user_level will become -1 and
that is the value that will be passed to the hardware.

> @@ -782,7 +784,8 @@ static int __init samsung_init(void)
>  	/* create a backlight device to talk to this one */
>  	memset(&props, 0, sizeof(struct backlight_properties));
>  	props.type = BACKLIGHT_PLATFORM;
> -	props.max_brightness = sabi_config->max_brightness;
> +	props.max_brightness = sabi_config->max_brightness -
> +				sabi_config->min_brightness;

Without subtracting the min_brightness, the user is offered a range of 0
through 8 for both sabi_configs. For the min_brightness == 1 case and with
set_brightness() fixed, a user setting of 8 would actually set 9 in hardware.

Regards,
Jason Stubbs

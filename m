Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab1KHD5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:57:51 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:33641 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1KHD5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:57:50 -0500
X-Spam-Flag: NO
X-Spam-Score: -9.468
Message-ID: <4EB8A8B6.1010205@tremplin-utc.net>
Date: Tue, 08 Nov 2011 04:57:42 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111006 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3lv02d: Avoid zero-division
References: <s5hy5vx9zmr.wl%tiwai@suse.de>
In-Reply-To: <s5hy5vx9zmr.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 03-11-11 13:09, Takashi Iwai schreef:
> In some weird situation, HP DriveGuard chip can't read ODR value
> correctly, and it results in a zero-division Oops in lis3lv02d driver.
> This patch fixes the Oops by checking the value appopriately, and skips
> if any weird value is read.
Hi Takashi,
Actually, a similar patch already just landed in linus' tree:
1510dd5954 (lis3lv02d: avoid divide by zero due to unchecked)

However, in the patch applied, the device is disabled (until next 
reboot) while in yours, the sleep is just skipped. Does it work again 
after the read of odr fails? If so, maybe I could improve the current 
version by, after the odr read fails, sleeping a long and safe time and 
then trying to read the odr again. Then if it fails again, we give up, 
otherwise the device can be used again.

Do you have such a device yourself? Could you let me know if after a 
failing read of the odr, the device keeps working?

Cheers,
Éric

>
> Cc:<stable@kernel.org>
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
> ---
>   drivers/misc/lis3lv02d/lis3lv02d.c |   14 +++++++++++---
>   1 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
> index 8b51cd6..c4eb2f3 100644
> --- a/drivers/misc/lis3lv02d/lis3lv02d.c
> +++ b/drivers/misc/lis3lv02d/lis3lv02d.c
> @@ -228,6 +228,14 @@ static int lis3lv02d_set_odr(int rate)
>   	return -EINVAL;
>   }
>
> +static void lis3lv02d_power_delay(struct lis3lv02d *lis3)
> +{
> +	int odr = lis3lv02d_get_odr();
> +	if (odr<= 0)
> +		return;
> +	msleep(lis3->pwron_delay / odr);
> +}
> +
>   static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
>   {
>   	u8 ctlreg, reg;
> @@ -266,7 +274,7 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
>
>   	lis3->read(lis3, ctlreg,&reg);
>   	lis3->write(lis3, ctlreg, (reg | selftest));
> -	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +	lis3lv02d_power_delay(lis3);
>
>   	/* Read directly to avoid axis remap */
>   	x = lis3->read_data(lis3, OUTX);
> @@ -275,7 +283,7 @@ static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
>
>   	/* back to normal settings */
>   	lis3->write(lis3, ctlreg, reg);
> -	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +	lis3lv02d_power_delay(lis3);
>
>   	results[0] = x - lis3->read_data(lis3, OUTX);
>   	results[1] = y - lis3->read_data(lis3, OUTY);
> @@ -385,7 +393,7 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
>   	}
>
>   	/* LIS3 power on delay is quite long */
> -	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
> +	lis3lv02d_power_delay(lis3);
>
>   	if (lis3->reg_ctrl)
>   		lis3_context_restore(lis3);


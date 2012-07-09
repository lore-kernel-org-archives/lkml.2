Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab2GIFLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 01:11:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41738 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab2GIFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 01:11:28 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-97-4ffa67fed96a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Alexandre Courbot'" <acourbot@nvidia.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1341807700-7103-1-git-send-email-acourbot@nvidia.com>
In-reply-to: <1341807700-7103-1-git-send-email-acourbot@nvidia.com>
Subject: RE: [PATCH] pwm_backlight: pass correct brightness to callback
Date: Mon, 09 Jul 2012 14:11:26 +0900
Message-id: <00a701cd5d91$4aa71f40$dff55dc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1dihv8xcIbr4FLR7CnWwVR+3pbFgABnP0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd3/6b/8DV41MVqc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKeHbQoeCJU8WHTMuYGxnb+LkZODgkBE4muZ6uZIWwx
	iQv31rN1MXJxCAksYpR4cnoBO4Tzi1Hi4YcZjCBVbAJqEl++HGYHsUUEUiTmzdnO1MXIwcEs
	kCzxc7oOSFhIwEli1/oLTCA2p4CzxJOFx9hASoQF3CUa/weBhFkEVCXO7+ljBbF5BWwlWhc8
	g7IFJX5MvscCYjMLaEms33mcCcKWl9i85i0zyBgJAXWJR391IQ4wkvjTf4sNokREYt+Ld4wT
	GIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDA/k9rBuLLB
	4hCjAAejEg9vQOovfyHWxLLiytxDjBIczEoivJXWP/2FeFMSK6tSi/Lji0pzUosPMUpzsCiJ
	8xp7f/UXEkhPLEnNTk0tSC2CyTJxcEo1MNb/v7jmZ+qZNMeESpvlX/5vXPvz5JyI4rXtaQs0
	FlpHGrtytHx4r3o2gc3kRq6T3+Jlxy/etnd/6rg1f/qG1vgmO4lN353/fV8QwJGyc0aIe2u+
	CO/nxtXOX/6paiY0cAcyC10vKl5R4Xy8Z+K356YHe6QcyrynBou9c3A8INq6/zxvrN1GWSWW
	4oxEQy3mouJEAFtED4RiAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 09, 2012 1:22 PM, Alexandre Courbot wrote:

> pwm_backlight_update_status calls two callbacks before and after
> applying the new PWM settings. However, the brightness scale is
> completely changed in between if brightness levels are used. This patch
> ensures that both callbacks are passed brightness values of the same
> meaning.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 057389d..dd4d24d 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -39,6 +39,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>  {
>  	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>  	int brightness = bl->props.brightness;
> +	int pwm_brightness;
>  	int max = bl->props.max_brightness;
> 
>  	if (bl->props.power != FB_BLANK_UNBLANK)
> @@ -55,13 +56,14 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>  		pwm_disable(pb->pwm);
>  	} else {
>  		if (pb->levels) {
> -			brightness = pb->levels[brightness];
> +			pwm_brightness = pb->levels[brightness];
>  			max = pb->levels[max];
> -		}
> +		} else
> +			pwm_brightness = brightness;

Hi Alexandre Courbot,

Please, use braces to keep the Coding Style.
Refer to Documentation/CodingStyle as follow:

169 This does not apply if only one branch of a conditional statement is a single
170 statement; in the latter case use braces in both branches:
171
172 if (condition) {
173         do_this();
174         do_that();
175 } else {
176         otherwise();
177 }

Best regards,
Jingoo Han

> 
> -		brightness = pb->lth_brightness +
> -			(brightness * (pb->period - pb->lth_brightness) / max);
> -		pwm_config(pb->pwm, brightness, pb->period);
> +		pwm_brightness = pb->lth_brightness +
> +		     (pwm_brightness * (pb->period - pb->lth_brightness) / max);
> +		pwm_config(pb->pwm, pwm_brightness, pb->period);
>  		pwm_enable(pb->pwm);
>  	}
> 
> --
> 1.7.11.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


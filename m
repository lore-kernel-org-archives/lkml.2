Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab1AFVFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:05:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030Ab1AFVFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:05:50 -0500
Date: Thu, 6 Jan 2011 13:04:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RESEND #2] [PATCH v2] LEDS: Add output invertion option to
 backlight trigger
Message-Id: <20110106130440.cfd77c8e.akpm@linux-foundation.org>
In-Reply-To: <201012091441.51846.jkrzyszt@tis.icnet.pl>
References: <201012091441.51846.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Dec 2010 14:41:50 +0100
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> This patch extends the LED backlight tirgger driver with an option that allows 
> for inverting the trigger output polarity.
> 
> With the invertion option provided, I (ab)use the backlight trigger for 
> driving a LED that indicates LCD display blank condtition on my Amstrad Delta 
> videophone. Since the machine has no dedicated power LED, it was not possible 
> to distinguish if the display was blanked, or the machine was turned off, 
> without touching it.
> 
> The invert sysfs control is patterned after a similiar function of the GPIO 
> trigger driver.
> 
> Created and tested against linux-2.6.36-rc5 on Amstrad Delta.
> Retested on linux-2.6.37-rc4.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
> 
> Resent because I still can't see any response received, while yet another 
> merge window is going to pass away soon.
> 
> Applies cleanly on top of 2.6.37-rc4, so no need for yet another refresh. Only 
> tried to clean up the commit message slightly - maybe my English is not good 
> enough to bother with, if not the code?
> 
> v1 -> v2 changes:
> - improve some conditional expressions to be more readable; thanks to Ralph 
>   Corderoy (from e3-hacking) and Lars-Peter Clausen for their suggestions,
> - refresh against linux-2.6.36-rc5.
> 
>  drivers/leds/ledtrig-backlight.c |   60 
> ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 56 insertions(+), 4 deletions(-)
> 
> diff -upr linux-2.6.36-rc5.orig/drivers/leds/ledtrig-backlight.c linux-2.6.36-rc5/drivers/leds/ledtrig-backlight.c
> --- linux-2.6.36-rc5.orig/drivers/leds/ledtrig-backlight.c	2010-09-24 15:35:13.000000000 +0200
> +++ linux-2.6.36-rc5/drivers/leds/ledtrig-backlight.c	2010-10-03 15:59:49.000000000 +0200
> @@ -26,6 +26,7 @@ struct bl_trig_notifier {
>  	int brightness;
>  	int old_status;
>  	struct notifier_block notifier;
> +	unsigned invert;
>  };
>  
>  static int fb_notifier_callback(struct notifier_block *p,
> @@ -36,23 +37,63 @@ static int fb_notifier_callback(struct n
>  	struct led_classdev *led = n->led;
>  	struct fb_event *fb_event = data;
>  	int *blank = fb_event->data;
> +	int new_status = *blank ? BLANK : UNBLANK;
>  
>  	switch (event) {
>  	case FB_EVENT_BLANK :
> -		if (*blank && n->old_status == UNBLANK) {
> +		if (new_status == n->old_status)
> +			break;
> +
> +		if ((n->old_status == UNBLANK) ^ n->invert) {
>  			n->brightness = led->brightness;
>  			led_set_brightness(led, LED_OFF);
> -			n->old_status = BLANK;
> -		} else if (!*blank && n->old_status == BLANK) {
> +		} else {
>  			led_set_brightness(led, n->brightness);
> -			n->old_status = UNBLANK;
>  		}
> +
> +		n->old_status = new_status;
> +
>  		break;
>  	}
>  
>  	return 0;
>  }
>  
> +static ssize_t bl_trig_invert_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	struct led_classdev *led = dev_get_drvdata(dev);
> +	struct bl_trig_notifier *n = led->trigger_data;
> +
> +	return sprintf(buf, "%s\n", n->invert ? "yes" : "no");
> +}

I think this should show "0" or "1", to match the thing which the user
wrote here.

> +static ssize_t bl_trig_invert_store(struct device *dev,
> +		struct device_attribute *attr, const char *buf, size_t num)
> +{
> +	struct led_classdev *led = dev_get_drvdata(dev);
> +	struct bl_trig_notifier *n = led->trigger_data;
> +	unsigned invert;
> +	int ret;
> +
> +	ret = sscanf(buf, "%u", &invert);

Here we should use strict_strtoul() so the kernel correctly rejects
input of the form "42foo".

> +	if (ret < 1) {
> +		dev_err(dev, "invalid value\n");
> +		return -EINVAL;
> +	}

And here it would be better to disallow any input other than 0 or 1. 
Because "2" makes no sense and who knows, some time in the future we
might *want* to permit 2.

So...

--- a/drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger-fix
+++ a/drivers/leds/ledtrig-backlight.c
@@ -65,7 +65,7 @@ static ssize_t bl_trig_invert_show(struc
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct bl_trig_notifier *n = led->trigger_data;
 
-	return sprintf(buf, "%s\n", n->invert ? "yes" : "no");
+	return sprintf(buf, "%u\n", n->invert);
 }
 
 static ssize_t bl_trig_invert_store(struct device *dev,
@@ -73,16 +73,17 @@ static ssize_t bl_trig_invert_store(stru
 {
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct bl_trig_notifier *n = led->trigger_data;
-	unsigned invert;
+	unsigned long invert;
 	int ret;
 
-	ret = sscanf(buf, "%u", &invert);
-	if (ret < 1) {
-		dev_err(dev, "invalid value\n");
+	ret = strict_strtoul(buf, 10, &invert);
+	if (ret < 0)
+		return ret;
+
+	if (invert > 1)
 		return -EINVAL;
-	}
 
-	n->invert = !!invert;
+	n->invert = invert;
 
 	/* After inverting, we need to update the LED. */
 	if ((n->old_status == BLANK) ^ n->invert)
_


Could you help test it please?

> +static DEVICE_ATTR(invert, 0644, bl_trig_invert_show, bl_trig_invert_store);

This new sysfs file should be documented.  Where would be an
appropriate place for that?  Documentation/leds-class.txt doesn't
mention a sysfs API at all.  

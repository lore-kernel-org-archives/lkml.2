Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933111Ab1AMTAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 14:00:01 -0500
Received: from d1.icnet.pl ([212.160.220.21]:53004 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab1AMS74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:59:56 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: akpm@linux-foundation.org
Subject: Re: + leds-add-output-inversion-option-to-backlight-trigger-fix.patch added to -mm tree
Date: Thu, 13 Jan 2011 19:58:31 +0100
User-Agent: KMail/1.9.10
Cc: lethal@linux-sh.org, richard.purdie@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <201101062104.p06L4rgv015392@imap1.linux-foundation.org>
In-Reply-To: <201101062104.p06L4rgv015392@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101131958.32984.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thursday 06 January 2011 22:04:53 akpm@linux-foundation.org wrote:
> The patch titled
>      leds-add-output-inversion-option-to-backlight-trigger-fix
> has been added to the -mm tree.  Its filename is
>      leds-add-output-inversion-option-to-backlight-trigger-fix.patch
...
> ------------------------------------------------------
> Subject: leds-add-output-inversion-option-to-backlight-trigger-fix
> From: Andrew Morton <akpm@linux-foundation.org>
>
> make output match input, tighten input checking
> 
> Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> 
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Richard Purdie <richard.purdie@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Hi Andrew,

FWIW, here are your fixes ported to the ledtrig-gpio driver, which 
suffers from the same sysfs API issues. Compile tested.

Thanks,
Janusz

---
--- linux-2.6.37/drivers/leds/ledtrig-gpio.c.orig	2011-01-10 02:43:10.000000000 +0100
+++ linux-2.6.37/drivers/leds/ledtrig-gpio.c	2011-01-13 18:24:40.000000000 +0100
@@ -99,7 +99,7 @@ static ssize_t gpio_trig_inverted_show(s
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct gpio_trig_data *gpio_data = led->trigger_data;
 
-	return sprintf(buf, "%s\n", gpio_data->inverted ? "yes" : "no");
+	return sprintf(buf, "%u\n", gpio_data->inverted);
 }
 
 static ssize_t gpio_trig_inverted_store(struct device *dev,
@@ -107,16 +107,17 @@ static ssize_t gpio_trig_inverted_store(
 {
 	struct led_classdev *led = dev_get_drvdata(dev);
 	struct gpio_trig_data *gpio_data = led->trigger_data;
-	unsigned inverted;
+	unsigned long inverted;
 	int ret;
 
-	ret = sscanf(buf, "%u", &inverted);
-	if (ret < 1) {
-		dev_err(dev, "invalid value\n");
+	ret = strict_strtoul(buf, 10, &inverted);
+	if (ret < 0)
+		return ret;
+
+	if (inverted > 1)
 		return -EINVAL;
-	}
 
-	gpio_data->inverted = !!inverted;
+	gpio_data->inverted = inverted;
 
 	/* After inverting, we need to update the LED. */
 	schedule_work(&gpio_data->work);
_
> ---
>
>  drivers/leds/ledtrig-backlight.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff -puN rivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to->backlight-trigger-fix drivers/leds/ledtrig-backlight.c
> --- a/drivers/leds/ledtrig-backlight.c~leds-add-output-inversion-option-to-backlight-trigger-fix
> +++ a/drivers/leds/ledtrig-backlight.c 
> @@ -65,7 +65,7 @@ static ssize_t bl_trig_invert_show(struc
>  	struct led_classdev *led = dev_get_drvdata(dev);
>  	struct bl_trig_notifier *n = led->trigger_data;
>
> -	return sprintf(buf, "%s\n", n->invert ? "yes" : "no");
> +	return sprintf(buf, "%u\n", n->invert);
>  }
>
>  static ssize_t bl_trig_invert_store(struct device *dev,
> @@ -73,16 +73,17 @@ static ssize_t bl_trig_invert_store(stru
>  {
>  	struct led_classdev *led = dev_get_drvdata(dev);
>  	struct bl_trig_notifier *n = led->trigger_data;
> -	unsigned invert;
> +	unsigned long invert;
>  	int ret;
>
> -	ret = sscanf(buf, "%u", &invert);
> -	if (ret < 1) {
> -		dev_err(dev, "invalid value\n");
> +	ret = strict_strtoul(buf, 10, &invert);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (invert > 1)
>  		return -EINVAL;
> -	}
>
> -	n->invert = !!invert;
> +	n->invert = invert;
>
>  	/* After inverting, we need to update the LED. */
>  	if ((n->old_status == BLANK) ^ n->invert)
> _

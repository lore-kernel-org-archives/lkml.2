Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562Ab1JGHip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:38:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:26831 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab1JGHio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:38:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="60027255"
Subject: Re: [PATCH 1/2] leds: save the delay values after a successful
 call to blink_set()
From: Johannes Berg <johannes.berg@intel.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1317938611-4418-2-git-send-email-ospite@studenti.unina.it>
References: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
	 <1317938611-4418-2-git-send-email-ospite@studenti.unina.it>
Date: Fri, 07 Oct 2011 09:38:38 +0200
Message-ID: <1317973118.3988.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p977csOR005685

On Thu, 2011-10-06 at 22:03 +0000, Antonio Ospite wrote:
> When calling the hardware blinking function implemented by blink_set(),
> the delay_on and delay_off values are not preserved across calls.
> 
> Fix that and make the "timer" trigger work as expected when hardware
> blinking is available.
> 
> BEFORE the fix:
>   $ cd /sys/class/leds/someled
>   $ echo timer > trigger
>   $ cat delay_on delay_off
>   0
>   0
>   $ echo 100 > delay_on
>   $ cat delay_on delay_off
>   0
>   0
>   $ echo 100 > delay_off
>   $ cat delay_on delay_off
>   0
>   0
> 
> AFTER the fix:
>   $ cd /sys/class/leds/someled
>   $ echo timer > trigger
>   $ cat delay_on delay_off
>   0
>   0
>   $ echo 100 > delay_on
>   $ cat delay_on delay_off
>   100
>   0
>   $ echo 100 > delay_off
>   $ cat delay_on delay_off
>   100
>   100
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>  drivers/leds/led-class.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index d5a4ade..939f24a 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -267,8 +267,11 @@ void led_blink_set(struct led_classdev *led_cdev,
>                    unsigned long *delay_off)
>  {
>         if (led_cdev->blink_set &&
> -           !led_cdev->blink_set(led_cdev, delay_on, delay_off))
> +           !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
> +               led_cdev->blink_delay_on = *delay_on;
> +               led_cdev->blink_delay_off = *delay_off;
>                 return;
> +       }

Looks good to me. I suspect I created this bug because originally it
might have put the values into there first and then called blink_set().

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

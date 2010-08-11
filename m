Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0HKHCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:02:55 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:58706 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0HKHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:02:54 -0400
Date: Wed, 11 Aug 2010 09:02:38 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 4/4] input: dynamically allocate ABS information
Message-ID: <20100811070238.GF10432@buzzloop.caiaq.de>
References: <1274289757-2723-1-git-send-email-daniel@caiaq.de>
 <1274289757-2723-5-git-send-email-daniel@caiaq.de>
 <20100524160805.GO30801@buzzloop.caiaq.de>
 <20100524161527.GC3182@core.coreip.homeip.net>
 <20100616083903.GU17833@buzzloop.caiaq.de>
 <20100721083048.GA21558@core.coreip.homeip.net>
 <20100721083150.GB21558@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721083150.GB21558@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, Jul 21, 2010 at 01:31:50AM -0700, Dmitry Torokhov wrote:
> Input: switch to input_abs_*() access functions
> 
> From: Daniel Mack <daniel@caiaq.de>
> 
> Change all call sites in drivers/input to not access the ABS axis
> information directly anymore. Make them use the access helpers instead.
> 
> Also use input_set_abs_params() when possible.
> Did some code refactoring as I was on it.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Hmm, there are three locations where some mysterious 'XX' characters
were introduced.

> diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
> index 05022f0..e90694f 100644
> --- a/drivers/input/joystick/amijoy.c
> +++ b/drivers/input/joystick/amijoy.c
> @@ -139,8 +139,8 @@ static int __init amijoy_init(void)
>  		amijoy_dev[i]->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
>  			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
>  		for (j = 0; j < 2; j++) {
> -			amijoy_dev[i]->absmin[ABS_X + j] = -1;
> -			amijoy_dev[i]->absmax[ABS_X + j] = 1;
> +			XXinput_set_abs_params(amijoy_dev[i], ABS_X + j,
                        ^^

[..]

> diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
> index c83f4b2..ddd5afd 100644
> --- a/drivers/input/keyboard/hil_kbd.c
> +++ b/drivers/input/keyboard/hil_kbd.c
> @@ -232,15 +232,16 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
>  		if (absdev) {
>  			val = lo + (hi << 8);
>  #ifdef TABLET_AUTOADJUST
> -			if (val < dev->absmin[ABS_X + i])
> -				dev->absmin[ABS_X + i] = val;
> -			if (val > dev->absmax[ABS_X + i])
> -				dev->absmax[ABS_X + i] = val;
> +			if (val < input_abs_min(dev, ABS_X + i))
> +				input_abs_set_min(dev, ABS_X + i, val);
> +			if (val > input_abs_max(dev, ABS_X + i))
> +				XXinput_abs_set_max(dev, ABS_X + i, val);
                                ^^

>  #endif
> -			if (i%3) val = dev->absmax[ABS_X + i] - val;
> +			if (i % 3)
> +				val = input_abs_max(dev, ABS_X + i) - val;
>  			input_report_abs(dev, ABS_X + i, val);
>  		} else {
> -			val = (int) (((int8_t)lo) | ((int8_t)hi << 8));
> +			val = (int) (((int8_t) lo) | ((int8_t) hi << 8));
>  			if (i % 3)
>  				val *= -1;
>  			input_report_rel(dev, REL_X + i, val);
> @@ -387,9 +388,11 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
>  
>  #ifdef TABLET_AUTOADJUST
>  		for (i = 0; i < ABS_MAX; i++) {
> -			int diff = input_dev->absmax[ABS_X + i] / 10;
> -			input_dev->absmin[ABS_X + i] += diff;
> -			input_dev->absmax[ABS_X + i] -= diff;
> +			int diff = input_abs_max(input_dev, ABS_X + i) / 10;
> +			input_abs_set_min(input_dev, ABS_X + i,
> +				input_abs_min(input_dev, ABS_X + i) + diff)
> +			XXinput_abs_set_max(input_dev, ABS_X + i,
                        ^^

I have no clue how they made it there, but they don't look right, unless
I miss some essential information.

Below is a patch to fix it up.

Thanks,
Daniel

>From 939d842964c8fd764a84702672be927a79d73e8f Mon Sep 17 00:00:00 2001
From: Daniel Mack <daniel@caiaq.de>
Date: Wed, 11 Aug 2010 08:59:53 +0200
Subject: [PATCH] drivers/input: fix faulty XXinput_* calls

They've been introduced by 987a6c02 ("Input: switch to input_abs_*()
access functions") and they appear to be some kind of debug left-over.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/amijoy.c  |    2 +-
 drivers/input/keyboard/hil_kbd.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index e90694f..0bc8620 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -139,7 +139,7 @@ static int __init amijoy_init(void)
 		amijoy_dev[i]->keybit[BIT_WORD(BTN_LEFT)] = BIT_MASK(BTN_LEFT) |
 			BIT_MASK(BTN_MIDDLE) | BIT_MASK(BTN_RIGHT);
 		for (j = 0; j < 2; j++) {
-			XXinput_set_abs_params(amijoy_dev[i], ABS_X + j,
+			input_set_abs_params(amijoy_dev[i], ABS_X + j,
 					     -1, 1, 0, 0);
 		}
 
diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
index ddd5afd..dcc86b9 100644
--- a/drivers/input/keyboard/hil_kbd.c
+++ b/drivers/input/keyboard/hil_kbd.c
@@ -235,7 +235,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
 			if (val < input_abs_min(dev, ABS_X + i))
 				input_abs_set_min(dev, ABS_X + i, val);
 			if (val > input_abs_max(dev, ABS_X + i))
-				XXinput_abs_set_max(dev, ABS_X + i, val);
+				input_abs_set_max(dev, ABS_X + i, val);
 #endif
 			if (i % 3)
 				val = input_abs_max(dev, ABS_X + i) - val;
@@ -391,7 +391,7 @@ static void hil_dev_pointer_setup(struct hil_dev *ptr)
 			int diff = input_abs_max(input_dev, ABS_X + i) / 10;
 			input_abs_set_min(input_dev, ABS_X + i,
 				input_abs_min(input_dev, ABS_X + i) + diff)
-			XXinput_abs_set_max(input_dev, ABS_X + i,
+			input_abs_set_max(input_dev, ABS_X + i,
 				input_abs_max(input_dev, ABS_X + i) - diff)
 		}
 #endif
-- 
1.7.0.4


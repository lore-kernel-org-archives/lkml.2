Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab2DJNZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:25:06 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:54095 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab2DJNZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:25:04 -0400
Message-ID: <1334064283.10826.6.camel@ted>
Subject: Re: [PATCH RESEND] LEDS-One-Shot-Timer-Trigger-implementation
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: shuahkhan@gmail.com
Cc: akpm@linux-foundation.org, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 10 Apr 2012 14:24:43 +0100
In-Reply-To: <1333310039.2879.4.camel@lorien2>
References: <1333310039.2879.4.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 13:53 -0600, Shuah Khan wrote:
> LED infrastructure lacks support for one shot timer trigger and activation.
> The current support allows for setting two timers, one for specifying how
> long a state to be on, and the second for how long the state to be off. For
> example, delay_on value specifies the time period an LED should stay in on
> state, followed by a delay_off value that specifies how long the LED should
> stay in off state. The on and off cycle repeats until the trigger gets
> deactivated. There is no provision for one time activation to implement
> features that require an on or off state to be held just once and then stay
> in the original state forever.
> 
> This feature will help implement vibrate functionality which requires one
> time activation of vibrate mode without a continuous vibrate on/off cycles.
> 
> From 1ebe0fd67580da833f8f06fc3119445e9991100f Mon Sep 17 00:00:00 2001
> From: Shuah Khan <shuahkhan@gmail.com>
> Date: Sat, 31 Mar 2012 21:56:07 -0600
> Subject: [PATCH] LEDS-One-Shot-Timer-Trigger-implementation
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> Reviewed-by: NeilBrown <neilb@suse.de>
> Cc: Richard Purdie <rpurdie@linux.intel.com>
> ---
>  Documentation/leds/leds-one-shot-timer.txt |   79 +++++++++++++++++++++
>  drivers/leds/led-class.c                   |    4 +-
>  drivers/leds/led-core.c                    |   26 ++++++-
>  drivers/leds/leds.h                        |    2 +
>  drivers/leds/ledtrig-timer.c               |  104 ++++++++++++++++++++--------
>  5 files changed, 180 insertions(+), 35 deletions(-)
>  create mode 100644 Documentation/leds/leds-one-shot-timer.txt
> 
> diff --git a/Documentation/leds/leds-one-shot-timer.txt b/Documentation/leds/leds-one-shot-timer.txt
> new file mode 100644
> index 0000000..a5429dd
> --- /dev/null
> +++ b/Documentation/leds/leds-one-shot-timer.txt
> @@ -0,0 +1,79 @@
> +
> +LED one shot timer feature
> +===========================
> +
> +LED infrastructure lacks support for one shot timer trigger and activation.
> +The current support allows for setting two timers, one for specifying how
> +long a state to be on, and the second for how long the state to be off. For
> +example, delay_on value specifies the time period an LED should stay in on
> +state, followed by a delay_off value that specifies how long the LED should
> +stay in off state. The on and off cycle repeats until the trigger gets
> +deactivated. There is no provision for one time activation to implement
> +features that require an on or off state to be held just once and then stay
> +in the original state forever.
> +
> +This feature will help implement vibrate functionality which requires one
> +time activation of vibrate mode without a continuous vibrate on/off cycles.
> +
> +This patch implements the timer-no-default trigger support by enhancing the
> +current led-class, led-core, and ledtrig-timer drivers to:
> +
> +- Add support for forever timer case. forever tag can be written to delay_on
> +  or delay_off files. Internally forever is mapped to ULONG_MAX with no timer
> +  associated with it.
> +
> +- The led_blink_set() which takes two pointers to times one each for delay_on
> +  and delay_off has been extended so that a NULL instead of a pointer means
> +  "forever".
> +
> +- Add a new timer-no-default trigger to ledtrig-timer
> +
> +The above enhancements support the following use-cases:
> +
> +use-case 1:
> +echo timer-no-default > /sys/class/leds/SOMELED/trigger
> +echo forever > /sys/class/leds/SOMELED/delay_off
> +echo 2000 > /sys/class/leds/SOMELED/delay_on
> +
> +When timer-no-default is activated in step1, unlike the timer trigger case,
> +timer-no-default activate routine activates the trigger without starting
> +any timers. The default 1 HZ delay_on and delay_off timers won't be started
> +like in the case of timer trigger activation. Not starting timers ensures
> +that the one time state isn't stuck if some error occurs before actual timer
> +periods are specified. delay_on and delay_off files get created with 0
> +values. Please note that it is important to set delay_off to forever prior
> +to setting delay_on value. If the order is reversed, the LED will be turned
> +on, with no timer set to turn it off.
> +
> +When delay_off value is specified in step 2, delay_off_store recognizes the
> +special forever tag and records it and returns without starting any timer.
> +Internally forever maps to ULONG_MAX. The led_blink_set() which takes
> +two pointers to times one each for delay_on and delay_off has been extended
> +so that a NULL instead of a pointer means "forever".
> +
> +When delay_on value is specified in step 3, a timer gets started for
> +delay_on period, and delay_off stays at ULONG_MAX with no timer associated
> +with it.
> +
> +use-case 2:
> +echo timer-no-default > /sys/class/leds/SOMELED/trigger
> +echo forever > /sys/class/leds/SOMELED/delay_on
> +echo 2000 > /sys/class/leds/SOMELED/delay_off
> +
> +When timer-no-default is activated in step1, unlike the timer trigger case,
> +timer-no-default activate routine activates the trigger without starting
> +any timers. The default 1 HZ delay_on and delay_off timers won't be started
> +like in the case of timer trigger activation. Not starting timers ensures
> +that the one time state isn't stuck if some error occurs before actual timer
> +periods are specified. delay_on and delay_off files get created with 0
> +values. Please note that it is important to set delay_on to forever prior
> +to setting delay_off value. If the order is reversed, the LED will be turned
> +off, with no timer set to turn it back on.
> +
> +When delay_on value is specified in step 2, delay_on_store recognizes the
> +special forever tag and records it and returns without starting any timer.
> +Internally forever maps to ULONG_MAX.
> +
> +When delay_off value is specified in step 3, a timer gets started for
> +delay_off period, and delay_on stays at ULONG_MAX with no timer associated
> +with it.

Having looked at the code and read through the thread and Andrew's patch
review, I'm left wondering why you didn't add a new trigger for this
functionality?

The reason I ask that there do seem to be a number of questions about
backwards compatibility and this also seems to complicate the standard
timer trigger in non-obvious ways. Having a new trigger for this
functionality would allow for a much clearer namespace and no backwards
compatibility issues. It also means additional functionality can be
added later in a contained place. I'm wondering if there is a downside
to a separate trigger I'm missing?

Dimity raises some valid questions about the force-feedback framework in
the input system too. We need to make a decision about where phone
vibration framework belongs and then stick to that. You can argue this
to either subsystem, neither "led" or "input" is a obvious description
of phone vibration at a first glance!

Cheers,

Richard



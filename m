Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab1DHEnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 00:43:47 -0400
Received: from [77.233.226.4] ([77.233.226.4]:50369 "EHLO
	mail.doredevelopment.dk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751296Ab1DHEnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 00:43:46 -0400
From: Esben Haabendal <eha@dev.doredevelopment.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eha@doredevelopment.dk, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: Support automatic start of blinking with ledtrig-timer
References: <1300446199-3234-1-git-send-email-eha@doredevelopment.dk>
	<20110407163415.0eb0f545.akpm@linux-foundation.org>
Date: Fri, 08 Apr 2011 06:43:41 +0200
In-Reply-To: <20110407163415.0eb0f545.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 7 Apr 2011 16:34:15 -0700")
Message-ID: <87wrj5bbeq.fsf@eha.doredevelopment.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 18 Mar 2011 12:03:19 +0100
> eha@doredevelopment.dk wrote:
>
>> From: Esben Haabendal <eha@doredevelopment.dk>
>> 
>> By setting initial values blink_delay_on and blink_delay_off in a
>> led_classdev struct, this change starts the blinking when the led
>> is initialized.
>> 
>> Signed-off-by: Esben Haabendal <eha@doredevelopment.dk>
>> ---
>>  drivers/leds/led-class.c     |    3 ++-
>>  drivers/leds/ledtrig-timer.c |    3 +++
>>  2 files changed, 5 insertions(+), 1 deletions(-)
>> 
>> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
>> index d5a4ade..d7bdef8 100644
>> --- a/drivers/leds/led-class.c
>> +++ b/drivers/leds/led-class.c
>> @@ -131,7 +131,8 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
>>  	if (!led_cdev->blink_brightness)
>>  		led_cdev->blink_brightness = led_cdev->max_brightness;
>>  
>> -	if (delay_on == led_cdev->blink_delay_on &&
>> +	if (led_cdev->trigger_data &&
>> +	    delay_on == led_cdev->blink_delay_on &&
>>  	    delay_off == led_cdev->blink_delay_off)
>>  		return;
>>  
>> diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
>> index b09bcbe..d87c9d0 100644
>> --- a/drivers/leds/ledtrig-timer.c
>> +++ b/drivers/leds/ledtrig-timer.c
>> @@ -91,6 +91,9 @@ static void timer_trig_activate(struct led_classdev *led_cdev)
>>  	if (rc)
>>  		goto err_out_delayon;
>>  
>> +	led_blink_set(led_cdev, &led_cdev->blink_delay_on,
>> +		      &led_cdev->blink_delay_off);
>> +
>>  	led_cdev->trigger_data = (void *)1;
>>  
>>  	return;
>
> It's unclear (to me) exactly what this patch does.  Could you please
> send a more complete description of the user-visible change in
> behaviour?

With this patch, you can initialize blink_delay_on and blink_delay_off
in led_classdev with default_trigger set to "timer", and the led start
up blinking.  The current ledtrig-timer implementation ignores any
initial blink_delay_on/blink_delay_off settings, and requires setting
blink_delay_on/blink_delay_off (typically from user-space) before the
led blinks.

/Esben

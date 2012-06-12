Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2FLHwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:52:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40732 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2FLHwK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:52:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120612071649.GA1306@gmail.com>
References: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
 <1339450705.23857.16.camel@lorien2> <20120612071649.GA1306@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 12 Jun 2012 15:51:49 +0800
X-Google-Sender-Auth: V4vxRFXFdp8fqmsM8k47PMOhdR4
Message-ID: <CAK5ve-+D7vPO1U4gZDHRBmafJtF5T_EYBPCSAT2YOXjbc_u4zQ@mail.gmail.com>
Subject: Re: [PATCH] leds: use led_brightness_set in led_trigger_event
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 3:16 PM, Fabio Baltieri
<fabio.baltieri@gmail.com> wrote:
> On Mon, Jun 11, 2012 at 03:38:25PM -0600, Shuah Khan wrote:
>> On Mon, 2012-06-11 at 22:57 +0200, Fabio Baltieri wrote:
>> > Fix led_trigger_event() to use led_brightness_set() instead of
>> > led_set_brightness(), so that any pending blink timer is stopped before
>> > setting the new brightness value.  Without this fix LED status may be
>> > overridden by a pending timer.
>> >
>> > This allows a trigger to use a mix of led_trigger_event(),
>> > led_trigger_blink() and led_trigger_blink_oneshot() without races.
>> >
>> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
>> > Cc: Bryan Wu <bryan.wu@canonical.com>
>> > ---
>> > Hi Bryan,
>> >
>> > I found this one while working on another patch but I think it's also needed by
>> > other drivers which mixes led_trigger_blink() and led_trigger_event(), such as
>> > power_supply_leds.
>> >
>> > Without this a led don't stop blinking as it should when calling
>> > led_trigger_event().
>>
>> Good find. This is very subtle race though because both timer and
>> oneshot triggers call led_brightness_set() from their deactivate
>> routines. Is this when these events triggered using oneshot trigger?
>
> Actually that was when mixing blink (both timer and oneshot, they use
> the same timer) and standard trigger-event-set. It should be safe if
> only internal (core) functions call set_brightness.
>
>> >
>> > Should not cause any harm on other drivers.
>> >
>> > (I'm starting to find the whole led_set_brightness/led_brightness_set thing a
>> > bit confusing BTW...)
>>
>> I agree with the names are confusing. :) It found it confusing as well.
>> Probably why we have this bug hiding until led_trigger_blink() came
>> along.
>>
>> led_brightness_set() calls led_set_brightness(). led_set_brightness()
>> takes cares about whether the driver is in suspend state and invokes
>> driver's brightness_set interface. Maybe led_clear_blink_timer() would
>> be a better name for this led_brightness_set() routine.
>
> I think maybe we should just rename the function to led_set_brightness()
> for the safe one (the one whichh also deactivate the time) and
> _led_set_brightness() for the internal one, to put some emphasis to the
> "internal" nature of the second.
>

Thanks for catching this. It's a good idea we sort out those confusing name.
Probably __led_set_bringness() is more conventional than _led_set_brightness().

And might also need to revisit other function names.

>> I can volunteer to make this change if we agree that this will be a good
>> one to clear this naming confusion.
>

OK, good Shuah, please go ahead and submit patches and I will hold
this patch for a while and wait for the final fixing.

-Bryan

> That would save some headache in the future! :-)
>
> Fabio
>
>>
>> -- Shuah
>>
>> >
>> > Fabio
>> >
>> >  drivers/leds/led-triggers.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
>> > index fa0b9be..b88d3b9 100644
>> > --- a/drivers/leds/led-triggers.c
>> > +++ b/drivers/leds/led-triggers.c
>> > @@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
>> >             struct led_classdev *led_cdev;
>> >
>> >             led_cdev = list_entry(entry, struct led_classdev, trig_list);
>> > -           led_set_brightness(led_cdev, brightness);
>> > +           led_brightness_set(led_cdev, brightness);
>>
>> This is in-line with led_trigger_set() which is calling
>> led_bightness_set() correctly. Also led_classdev_unregister() calls it I
>> think for the same reason so the blink timer can be stopped.
>>
>> >     }
>> >     read_unlock(&trig->leddev_list_lock);
>> >  }
>>
>>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com

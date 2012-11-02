Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930Ab2KBOXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:23:44 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60758 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab2KBOXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:23:42 -0400
MIME-Version: 1.0
In-Reply-To: <20121031191630.GA1752@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-11-git-send-email-benjamin.tissoires@gmail.com>
	<20121029224331.GA15608@polaris.bitmath.org>
	<CAN+gG=G8F3m+UUDxm0qioipyMaAFHuQzKhmqn+-2qpGUGWwk6Q@mail.gmail.com>
	<20121031191630.GA1752@polaris.bitmath.org>
Date: Fri, 2 Nov 2012 15:23:40 +0100
Message-ID: <CAN+gG=EVHm0+6sMPR4vHaKd6M7Ee=72RUeC_VSBh4J1itZ7WUA@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] HID: introduce Scan Time
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 8:16 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> > This is a nice feature, useful in many other contexts. As such, I
>> > think it should be defined in the context of the input subsystem, with
>> > a more specific definition added to the documentation. For instance,
>> > is 100us suitable? When should it start at zero, at BTN_TOUCH? Or
>> > should it perhaps wrap around on unsigned integer instead? Or display
>> > the difference from the last event?
>>
>> Well, the thing is that I didn't wanted to copy/paste win 8 definition
>> for ScanTime. So I put it with my words and not in a very
>> understandable way :)
>> This allows me to forward the incoming events without having to do
>> anything on them...
>>
>> - 100us: suitable, not sure, but it would be good to define a standard
>> unit for time too
>
> Units of 100us might be fine, but maybe 64 or 128 or even 1 might be
> better suited for implementations.
>
>> - start at zero at BTN_TOUCH: no. This information allows us to do
>> much better false release detection. If we reset this counter, then we
>> will loose the time between the two touch/release.
>
> Good point.
>
>> The spec says that
>> it is up to the device to reset it after a period of time (not
>> defined, but can be one second for instance). Last, BTN_TOUCH is not
>> reliable for hovering devices because we will still get finger
>> information without BTN_TOUCH.
>
> Agreed.
>
>> - difference from the last event: not sure how it is implemented in
>> windows, but I'm not sure it's a good way of doing if the gesture
>> engine needs the time from the beginning of the touch...
>
> Probably more complicated than it needs to be, yes.
>
>> Anyway, I would be happy to have other comments/proposals for this event code.
>
> Here is my proposal: Let ABS_SCAN_TIME be the number of microseconds
> since the last reset. Let it be coded as an uint32 value, which is
> allowed to wrap around with no special consequence. It is assumed that
> the time difference between two consecutive events is reliable on a
> reasonable time scale (hours).  A reset to zero can happen, in which
> case the time since the last event is unknown. A definition like
> time_valid = (time || (time - prev_time) < MAX_SCAN_INTERVAL) ought to
> work for most cases.

all right, I'm fine with it.

>
>> >> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
>> >> index 53305bd..8f8c908 100644
>> >> --- a/Documentation/input/event-codes.txt
>> >> +++ b/Documentation/input/event-codes.txt
>> >> @@ -174,6 +174,13 @@ A few EV_ABS codes have special meanings:
>> >>      the input device may be used freely in three dimensions, consider ABS_Z
>> >>      instead.
>> >>
>> >> +* ABS_SCAN_TIME:
>> >> +  - Used when the device provides a timestamp for each frame. The unit must be
>> >> +    100us, and may be reset when the device don't send any events for a
>> >> +    period of time. The values increment at each frame and thus, it can roll
>> >> +    back to 0 when reach logical_max. If the device does not provide this
>> >> +    information, the driver must not provide it to the user space.
>> >> +
>> >>  * ABS_MT_<name>:
>> >>    - Used to describe multitouch input events. Please see
>> >>      multi-touch-protocol.txt for details.
>> >> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> >> index 16cc89a..5fe7bd3 100644
>> >> --- a/drivers/hid/hid-input.c
>> >> +++ b/drivers/hid/hid-input.c
>> >> @@ -675,6 +675,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>> >>                       map_key_clear(BTN_STYLUS2);
>> >>                       break;
>> >>
>> >> +             case 0x56: /* Scan Time */
>> >> +                     map_abs(ABS_SCAN_TIME);
>> >> +                     break;
>> >> +
>> >
>> > Is it not enough to map it in the case below? Or you mean this is
>> > picked up by hid core?
>> >
>>
>> in hidinput_configure_usage, it's enough to just map it.
>>
>> In hid-multitouch, We also just need to map it, and it will be handled
>> by hid-core in the .event callback.
>
> I think you should intercept it, convert it, and send it out with the touch frame.

With the definition inspired from Win 8, I didn't need to convert it,
thus the hid-core could handle it.
Now, it's clear that if we want to transform it, it needs to be intercepted.

Cheers,
Benjamin

>
> Thanks,
> Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab2KSOu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:50:56 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52661 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <20121116200926.GA652@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
	<1352908766-4492-15-git-send-email-benjamin.tissoires@gmail.com>
	<20121114195852.GA14840@polaris.bitmath.org>
	<50A40CB3.8070105@gmail.com>
	<20121116200926.GA652@polaris.bitmath.org>
Date: Mon, 19 Nov 2012 15:50:53 +0100
Message-ID: <CAN+gG=F=bHdJF0=0LHGuVQ+ObHvWKJnL0GYcAEWBeD+Z-yyGSA@mail.gmail.com>
Subject: Re: [PATCH v4 14/14] HID: hid-multitouch: forwards MSC_TIMESTAMP
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Nov 16, 2012 at 9:09 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> > This was not what I envisioned from the discussion yesterday, I was
>> > probably too vague. Firstly, the absolute time interval checked seems
>> > to be 500 ms, which is arbitrary. Second, the wrap should probably use
>>
>> Not exactly. The time interval was 5s, near enough the minimum requirement for this field (6.5535 s).
>
> Sorry about that, but the argument remains; it should depend on logical_maximum.

I must be tired when I read your mail, I only understand now what you
meant by logical_maximum in your first mail... sorry.

So, totally agree, we could make this kind of thing depending on logical_max.

>
>> > (logical_maximum + 1). Third, we are still not sure whether we should
>> > take the 'time = 0 means reset' logic literally, I think it needs to
>> > be tested.
>>
>> Again, the device I have never does any reset at the first touch, it just wraps the counter.
>> The problem is that when there is no event, we now that no events occurred since the previous timestamp, modulus 6.5535 seconds.
>
> So the very first win8 device we test already diverges from the win8
> specification, how nice.

hehe... well, the scan time is not as critical as can be the other
fields. Anyway, it's fun :)

>
> Ok, you have conviced me that comparing to a proper time makes
> sense. However, I am not happy about using a separate time for this,
> given that we will fill in the event time later in the
> chain.

that may explains the delta I observed from the kernel time and the device time.

>
> In addition, it would make perfect sense to extend the validity of the
> hardware time with the event time for longer intervals. The relative
> error only makes a difference on milisecond intervals.
>
> A patch that seamlessly extends the validity of the hardware time,
> ideally using the event time, seems like a viable solution.

Just to be sure:
When I receive scan_time, I increment timestamp with the device value.
When not, I find out the number of counter wrap I missed with the
kernel timer (jiffies) to get the actual device time.

Is that ok for you?

>
>> > +static void mt_compute_timestamp(struct mt_device *td, struct hid_field *field,
>> > +                            unsigned value)
>> > +{
>> > +   unsigned dt;
>> > +
>> > +   if (value) {
>> > +           dt = (value - td->dev_time) % (field->logical_maximum + 1);
>>
>> The curious thing is that this is not working on my kernel:
>
> Oups, I suspect (value - td->dev_time) needs to be explicitly converted to unsigned.

I can't remember if I tried this one, but I'll try to make it one line
in the next version.

>
>> I don't understand the meaning of adding !td->timestamp. :/
>
> With the definition that timestamp == 0 means an unknown interval, we
> do not want to send that value by accident.

ok, makes sense.

Cheers,
Benjamin

>
> Thanks,
> Henrik

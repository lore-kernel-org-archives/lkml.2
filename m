Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2KMR3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:29:20 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56558 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2KMR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:15 -0500
MIME-Version: 1.0
In-Reply-To: <20121113164239.GA712@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
	<1352306256-12180-12-git-send-email-benjamin.tissoires@gmail.com>
	<20121113164239.GA712@polaris.bitmath.org>
Date: Tue, 13 Nov 2012 18:29:12 +0100
Message-ID: <CAN+gG=EbAdfOG_vwt2uamV+JcAKLFqM=zTo9oRQ9RLayrpdsoA@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] HID: hid-multitouch: support for hovering devices
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

thanks for the review of the patchset. I'll do my best for the next version :)

On Tue, Nov 13, 2012 at 5:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Nov 07, 2012 at 05:37:34PM +0100, Benjamin Tissoires wrote:
>> Win8 devices supporting hovering must provides InRange HID field.
>
> provide the
>
>> The information that the finger is here but is not touching the surface
>> is sent to the user space through ABS_MT_DISTANCE as required by the
>> multitouch protocol.
>
> In the absence of more detailed information, use ABS_MT_DISTANCE with
> a [0,1] interval to distinguish between presence (1) and touch (0).
>
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 24 ++++++++++++++++++++----
>>  1 file changed, 20 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index b393c6c..1f3d1e0 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -59,6 +59,7 @@ struct mt_slot {
>>       __s32 x, y, cx, cy, p, w, h;
>>       __s32 contactid;        /* the device ContactID assigned to this slot */
>>       bool touch_state;       /* is the touch valid? */
>> +     bool inrange_state;     /* is the finger in proximity of the sensor? */
>>  };
>>
>>  struct mt_class {
>> @@ -397,6 +398,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>       case HID_UP_DIGITIZER:
>>               switch (usage->hid) {
>>               case HID_DG_INRANGE:
>> +                     if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED) {
>> +                             hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_DISTANCE);
>> +                             input_set_abs_params(hi->input,
>> +                                     ABS_MT_DISTANCE, -1, 1, 0, 0);
>
> Why [-1,1] here?

At first, I only used [0,1]. However, it's still the same problem with
the information being kept between the touches:
if you start an application after having touched your device, you
normally have to ask for the different per-touche states to get x, y,
distance, pressure, etc...
However, this is not much mandatory because the protocol in its
current form ensures that you will get the new states of the axes when
a new touch occurs.

ABS_MT_DISTANCE is a little bit different here because the protocol
guarantees that once you get the "not in range" state through
tracking_id == -1, distance should be 1.
When the new touch of the very same slot occurs, you also have the
guarantee that distance is at 1 too.

So basically, if you don't ask for the slot states, you will never get
that very first distance.

I know that it's a user-space problem, but honestly, I don't want to
fix several user-space problems when we could fix it through the
protocol.

I can see 2 solutions:
- set the range to: [0,1] and still sending -1 (or 2) for the invalid
distance value (if it's not clamped)
- set the range to: [0,2] and having: 0 for touch, 1 for hovering, and
2 for not in range

Does that make sense?

>
>> +                     }
>>                       mt_store_field(usage, td, hi);
>>                       td->last_field_index = field->index;
>>                       return 1;
>> @@ -516,6 +523,10 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>               if (slotnum < 0 || slotnum >= td->maxcontacts)
>>                       return;
>>
>> +             if (!test_bit(ABS_MT_DISTANCE, input->absbit))
>> +                     /* If InRange is not present, rely on TipSwitch */
>> +                     s->inrange_state = s->touch_state;
>> +
>
> This could be skipped, see below.
>
>>               if (td->mtclass.quirks & MT_QUIRK_IGNORE_DUPLICATES &&
>>                   input_mt_is_active(&input->mt->slots[slotnum]) &&
>>                   input_mt_is_used(input->mt, &input->mt->slots[slotnum]))
>> @@ -523,9 +534,9 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>
>>               input_mt_slot(input, slotnum);
>>               input_mt_report_slot_state(input, MT_TOOL_FINGER,
>> -                     s->touch_state);
>> -             if (s->touch_state) {
>> -                     /* this finger is on the screen */
>> +                     s->inrange_state);
>> +             if (s->inrange_state) {
>> +                     /* this finger is in proximity of the sensor */
>
> Using (s->touch_state || s->inrange_state) here seems simpler.

agree.

>
>>                       int wide = (s->w > s->h);
>>                       /* divided by two to match visual scale of touch */
>>                       int major = max(s->w, s->h) >> 1;
>> @@ -535,11 +546,14 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>                       input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
>>                       input_event(input, EV_ABS, ABS_MT_TOOL_X, s->cx);
>>                       input_event(input, EV_ABS, ABS_MT_TOOL_Y, s->cy);
>> +                     input_event(input, EV_ABS, ABS_MT_DISTANCE,
>> +                             !s->touch_state);
>>                       input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>>                       input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>>                       input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
>>                       input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
>> -             }
>> +             } else
>> +                     input_event(input, EV_ABS, ABS_MT_DISTANCE, -1);
>
> Just skip this, please.

see above.

Cheers,
Benjamin

>
>>       }
>>
>>       td->num_received++;
>> @@ -567,6 +581,8 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>               case HID_DG_INRANGE:
>>                       if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>>                               td->curvalid = value;
>> +                     if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
>> +                             td->curdata.inrange_state = value;
>>                       break;
>>               case HID_DG_TIPSWITCH:
>>                       if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
>> --
>> 1.7.11.7
>>
>
> Thanks,
> Henrik

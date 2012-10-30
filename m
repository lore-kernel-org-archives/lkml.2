Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab2J3Knc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:43:32 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:46151 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052Ab2J3Kna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <20121029223109.GA15589@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-10-git-send-email-benjamin.tissoires@gmail.com>
	<20121029223109.GA15589@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:43:28 +0100
Message-ID: <CAN+gG=Fs1f8BThHMbn3-NG4vp6dTbR8uKCEx+5cB0d7nnfqFxQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] HID: hid-multitouch: support for hovering devices
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:31 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Win8 devices supporting hovering must provides InRange HID field.
>> The information that the finger is here but is not touching the surface
>> is sent to the user space through ABS_MT_DISTANCE as required by the
>> multitouch protocol.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 21 +++++++++++++++++++--
>>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> I suppose the idea here is to send position and distance values even
> when there is no touch, but the code does not seem to do that?

Well, the code does it, but I agree it's not very clear.

The touch_state field is not for win8 with hovering the fact that the
finger is touching the surface, but the fact that a finger is in range
of the device.
This is why tipswitch is filling z instead of touch_state.

I agree, it's not that clear, I'll try to do better in v3.

>
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index bd23f19..c0ab1c6 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -55,7 +55,7 @@ MODULE_LICENSE("GPL");
>>  #define MT_QUIRK_WIN_8_CERTIFIED     (1 << 10)
>>
>>  struct mt_slot {
>> -     __s32 x, y, cx, cy, p, w, h;
>> +     __s32 x, y, cx, cy, z, p, w, h;
>>       __s32 contactid;        /* the device ContactID assigned to this slot */
>>       bool touch_state;       /* is the touch valid? */
>>  };
>> @@ -394,6 +394,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>       case HID_UP_DIGITIZER:
>>               switch (usage->hid) {
>>               case HID_DG_INRANGE:
>> +                     if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED) {
>> +                             hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_DISTANCE);
>> +                             input_set_abs_params(hi->input,
>> +                                     ABS_MT_DISTANCE, 0, 1, 0, 0);
>> +                     }
>>                       mt_store_field(usage, td, hi);
>>                       td->last_field_index = field->index;
>>                       return 1;
>> @@ -511,6 +517,11 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>               struct mt_slot *s = &td->curdata;
>>
>>               if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
>> +                 !test_bit(ABS_MT_DISTANCE, input->absbit))
>> +                     /* If InRange is not present, rely on TipSwitch */
>> +                     s->touch_state = !s->z;
>> +
>> +             if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
>>                   !s->touch_state) {
>>                       struct input_mt_slot *slot = &input->mt->slots[slotnum];
>>                       int prv_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
>> @@ -543,6 +554,7 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>                               input_event(input, EV_ABS, ABS_MT_TOOL_Y,
>>                                       s->cy);
>>                       }
>> +                     input_event(input, EV_ABS, ABS_MT_DISTANCE, s->z);
>
> This only happens if touch_state is true?

mmm, yes, we should move it outside this condition.

>
>>                       input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>>                       input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>>                       input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
>> @@ -575,11 +587,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>               case HID_DG_INRANGE:
>>                       if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>>                               td->curvalid = value;
>> +                     if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
>> +                             td->curdata.touch_state = value;
>>                       break;
>>               case HID_DG_TIPSWITCH:
>>                       if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
>>                               td->curvalid = value;
>> -                     td->curdata.touch_state = value;
>> +                     if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
>> +                             td->curdata.z = !value;
>
> Here, z is a boolean?

this is what is written in Win 8 specification. So ABS_MT_DISTANCE
will have a range of [0..1] and this behavior is right. When we will
have device with real Z hovering measures, then it will be the time to
change this, but currently, we only have a boolean in InRange.

Cheers,
Benjamin

>
>> +                     else
>> +                             td->curdata.touch_state = value;
>>                       break;
>>               case HID_DG_CONFIDENCE:
>>                       if (quirks & MT_QUIRK_VALID_IS_CONFIDENCE)
>> --
>> 1.7.11.7
>>
>
> Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab2J3KQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:16:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59361 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2J3KQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <20121029220058.GB15413@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-7-git-send-email-benjamin.tissoires@gmail.com>
	<20121029220058.GB15413@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:16:14 +0100
Message-ID: <CAN+gG=GRd6re056mn_C-UH0r8NgPiH98npxShMe3Ost_dcnzfg@mail.gmail.com>
Subject: Re: [PATCH v2 06/11] HID: hid-multitouch: support T and C for win8 devices
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

On Mon, Oct 29, 2012 at 11:00 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Win8 input specification clarifies the X and Y sent by devices.
>> It distincts the position where the user wants to Touch (T) from
>> the center of the ellipsoide (C). This patch enable supports for this
>> distinction in hid-multitouch.
>>
>> We recognize Win8 certified devices from their vendor feature 0xff0000c5
>> where Microsoft put a signed blob in the report to check if the device
>> passed the certification.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 53 ++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 44 insertions(+), 9 deletions(-)
>
> This is great, just a few comments below.
>
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 41f2981..000c979 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -52,9 +52,10 @@ MODULE_LICENSE("GPL");
>>  #define MT_QUIRK_VALID_IS_CONFIDENCE (1 << 6)
>>  #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE (1 << 8)
>>  #define MT_QUIRK_NO_AREA             (1 << 9)
>> +#define MT_QUIRK_WIN_8_CERTIFIED     (1 << 10)
>>
>>  struct mt_slot {
>> -     __s32 x, y, p, w, h;
>> +     __s32 x, y, cx, cy, p, w, h;
>>       __s32 contactid;        /* the device ContactID assigned to this slot */
>>       bool touch_state;       /* is the touch valid? */
>>  };
>> @@ -292,6 +293,10 @@ static void mt_feature_mapping(struct hid_device *hdev,
>>                       td->maxcontacts = td->mtclass.maxcontacts;
>>
>>               break;
>> +     case 0xff0000c5:
>> +             if (field->report_count == 256 && field->report_size == 8)
>> +                     td->mtclass.quirks |= MT_QUIRK_WIN_8_CERTIFIED;
>> +             break;
>>       }
>>  }
>>
>> @@ -350,18 +355,36 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>       case HID_UP_GENDESK:
>>               switch (usage->hid) {
>>               case HID_GD_X:
>> -                     hid_map_usage(hi, usage, bit, max,
>> +                     if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED &&
>
> Parenthesis, please. Precedence is not always enough.

oops

>
>> +                             usage_index) {
>> +                             hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_TOOL_X);
>> +                             set_abs(hi->input, ABS_MT_TOOL_X, field,
>> +                                     cls->sn_move);
>> +                     } else {
>> +                             hid_map_usage(hi, usage, bit, max,
>>                                       EV_ABS, ABS_MT_POSITION_X);
>> -                     set_abs(hi->input, ABS_MT_POSITION_X, field,
>> -                             cls->sn_move);
>> +                             set_abs(hi->input, ABS_MT_POSITION_X, field,
>> +                                     cls->sn_move);
>> +                     }
>> +
>
> Do we really want to do the latter several times, even if the device is not a win8 one?

I don't get your point here. The only difference with the previous
release is that it will treat differently the first in the array than
the others. For non win8 devices, there is no changes in the behavior.
Could you elaborate a little bit more, please?

>
>>                       mt_store_field(usage, td, hi);
>>                       td->last_field_index = field->index;
>>                       return 1;
>>               case HID_GD_Y:
>> -                     hid_map_usage(hi, usage, bit, max,
>> +                     if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED &&
>
> Ditto.
>
>> +                             usage_index) {
>> +                             hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_TOOL_Y);
>> +                             set_abs(hi->input, ABS_MT_TOOL_Y, field,
>> +                                     cls->sn_move);
>> +                     } else {
>> +                             hid_map_usage(hi, usage, bit, max,
>>                                       EV_ABS, ABS_MT_POSITION_Y);
>> -                     set_abs(hi->input, ABS_MT_POSITION_Y, field,
>> -                             cls->sn_move);
>> +                             set_abs(hi->input, ABS_MT_POSITION_Y, field,
>> +                                     cls->sn_move);
>> +                     }
>> +
>
> Ditto.
>
>>                       mt_store_field(usage, td, hi);
>>                       td->last_field_index = field->index;
>>                       return 1;
>> @@ -502,6 +525,12 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>
>>                       input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
>>                       input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
>> +                     if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED) {
>> +                             input_event(input, EV_ABS, ABS_MT_TOOL_X,
>> +                                     s->cx);
>
> Won't this fit on one line?

I'm afraid not: 81 columns... ;-)

>
>> +                             input_event(input, EV_ABS, ABS_MT_TOOL_Y,
>> +                                     s->cy);
>> +                     }
>>                       input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>>                       input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>>                       input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
>> @@ -553,10 +582,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>                       td->curdata.p = value;
>>                       break;
>>               case HID_GD_X:
>> -                     td->curdata.x = value;
>> +                     if (usage->code == ABS_MT_POSITION_X)
>> +                             td->curdata.x = value;
>> +                     else
>> +                             td->curdata.cx = value;
>
> Since cx is the new value, reversing the logic would make sense here.

ok

Cheers,
Benjamin

>
>>                       break;
>>               case HID_GD_Y:
>> -                     td->curdata.y = value;
>> +                     if (usage->code == ABS_MT_POSITION_Y)
>> +                             td->curdata.y = value;
>> +                     else
>> +                             td->curdata.cy = value;
>>                       break;
>>               case HID_DG_WIDTH:
>>                       td->curdata.w = value;
>> --
>> 1.7.11.7
>>
>
> Thanks,
> Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab2J3KHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:07:46 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51749 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2J3KHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:07:44 -0400
MIME-Version: 1.0
In-Reply-To: <20121029190554.GA15015@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-3-git-send-email-benjamin.tissoires@gmail.com>
	<20121029190554.GA15015@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:07:42 +0100
Message-ID: <CAN+gG=EVx_U-Ldoi9Dnbn6A7nn0mztnrYbCCCRo9SDzv=fM0PA@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] HID: core: fix unit exponent parsing
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

On Mon, Oct 29, 2012 at 8:05 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> HID spec details special values for the HID field unit exponent.
>> Basically, the range [0x8..0xf] correspond to [-8..-1].
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>
> Standard two's complement, in other words?

yes, but for 4-bits values. The thing is that I didn't managed to
figure out if it was allowed to give unit exponent with more than 4
bits...

>
>>  drivers/hid/hid-core.c  | 10 +++++++++-
>>  drivers/hid/hid-input.c | 19 +++++++++++++------
>>  2 files changed, 22 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 9904776..6bde6e4 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -315,6 +315,7 @@ static s32 item_sdata(struct hid_item *item)
>>
>>  static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
>>  {
>> +     __u32 raw_value;
>>       switch (item->tag) {
>>       case HID_GLOBAL_ITEM_TAG_PUSH:
>>
>> @@ -365,7 +366,14 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
>>               return 0;
>>
>>       case HID_GLOBAL_ITEM_TAG_UNIT_EXPONENT:
>> -             parser->global.unit_exponent = item_sdata(item);
>> +             /* Units exponent negative numbers are given through a special
>> +              * table.
>> +              * See "6.2.2.7 Global Items" for more information. */
>> +             raw_value = item_udata(item);
>> +             if ((raw_value >> 3) == 1)
>> +                     parser->global.unit_exponent = raw_value - 16;
>> +             else
>> +                     parser->global.unit_exponent = raw_value;
>
> I beleive the function you want is snto32(value, 4).

but to be sure, we should still do a test against (raw_value & 0xf0)
for values with more than 4 bits, no?

Cheers,
Benjamin

>
>>               return 0;
>>
>>       case HID_GLOBAL_ITEM_TAG_UNIT:
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index 1b0adc3..fc9f2b5 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -215,7 +215,7 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
>>                                       field->logical_minimum;
>>       __s32 physical_extents = field->physical_maximum -
>>                                       field->physical_minimum;
>> -     __s32 prev;
>> +     __s32 prev, tmp_exponent;
>>
>>       /* Check if the extents are sane */
>>       if (logical_extents <= 0 || physical_extents <= 0)
>> @@ -235,17 +235,24 @@ __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code)
>>       case ABS_MT_TOOL_Y:
>>       case ABS_MT_TOUCH_MAJOR:
>>       case ABS_MT_TOUCH_MINOR:
>> -             if (field->unit == 0x11) {              /* If centimeters */
>> +             if (field->unit & 0xffffff00)           /* Not a length */
>> +                     return 0;
>> +             tmp_exponent = field->unit >> 4;
>> +             if ((tmp_exponent >> 3) == 1)
>> +                     tmp_exponent -= 16;
>
> Ditto.
>
>> +             switch (field->unit & 0xf) {
>> +             case 0x1:                               /* If centimeters */
>>                       /* Convert to millimeters */
>> -                     unit_exponent += 1;
>> -             } else if (field->unit == 0x13) {       /* If inches */
>> +                     unit_exponent += tmp_exponent;
>> +                     break;
>> +             case 0x3:                               /* If inches */
>>                       /* Convert to millimeters */
>>                       prev = physical_extents;
>>                       physical_extents *= 254;
>>                       if (physical_extents < prev)
>>                               return 0;
>> -                     unit_exponent -= 1;
>> -             } else {
>> +                     unit_exponent += tmp_exponent - 2;
>> +             default:
>>                       return 0;
>>               }
>>               break;
>> --
>> 1.7.11.7
>>
>
> Thanks,
> Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab2J3KYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:24:23 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:53614 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab2J3KYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:24:21 -0400
MIME-Version: 1.0
In-Reply-To: <20121029221905.GA15537@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-9-git-send-email-benjamin.tissoires@gmail.com>
	<20121029221905.GA15537@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:24:19 +0100
Message-ID: <CAN+gG=ESZLHneinkc6kdkazRBfsGP70GaBPfV=jLhnTtZMVrKQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] HID: hid-multitouch: fix Win 8 protocol
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

On Mon, Oct 29, 2012 at 11:19 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Oct 26, 2012 at 10:44:24AM +0200, Benjamin Tissoires wrote:
>> Win 8 specification is much more precise than the Win 7 one.
>> Moreover devices that need to take certification must be submitted
>> to Microsoft.
>>
>> The result is a better protocol support and we can rely on that to
>> skip all the messy tests we used to do.
>>
>> The protocol specify the fact that each valid touch must be reported
>> within a frame, and that the release touch coordinate must be the
>> same than the last known touch.
>> So we can use the always_valid quirk and dismiss reports when we
>> touch coordiante do not follow this rule.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> Why do we need this patch?

This patch prevents a corner case where the device use contactID 0 for
it's first reported touch.
Once you got the invalid touches, most of the time, contactID will be
0, x, y, and other fields too. So this ensures to avoid conflict
between valid values and garbage values. The problem lies in the fact
that we don't have the whole overview of the frame (with the contact
count) to decide which contacts are good and which are not.

Cheers,
Benjamin

>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 43bd8e8..bd23f19 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -510,6 +510,18 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>               int slotnum = mt_compute_slot(td, input);
>>               struct mt_slot *s = &td->curdata;
>>
>> +             if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
>> +                 !s->touch_state) {
>> +                     struct input_mt_slot *slot = &input->mt->slots[slotnum];
>> +                     int prv_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
>> +                     int prv_y = input_mt_get_value(slot, ABS_MT_POSITION_Y);
>> +                     /* valid releases occurs when the last x and y positions
>> +                      * are the same as the last known touch. */
>> +                     if (!input_mt_is_active(slot) ||
>> +                         prv_x != s->x || prv_y != s->y)
>> +                             return;
>> +             }
>> +
>>               if (slotnum < 0 || slotnum >= td->maxcontacts)
>>                       return;
>>
>> @@ -681,8 +693,8 @@ static void mt_post_parse_default_settings(struct mt_device *td)
>>  {
>>       __s32 quirks = td->mtclass.quirks;
>>
>> -     /* unknown serial device needs special quirks */
>> -     if (td->touches_by_report == 1) {
>> +     /* unknown serial devices or win8 ones need special quirks */
>> +     if (td->touches_by_report == 1 || quirks & MT_QUIRK_WIN_8_CERTIFIED) {
>>               quirks |= MT_QUIRK_ALWAYS_VALID;
>>               quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
>>               quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
>> --
>> 1.7.11.7
>>
>
> Henrik

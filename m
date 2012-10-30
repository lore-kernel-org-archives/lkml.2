Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab2J3KT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:19:29 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44951 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab2J3KTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <20121029221605.GA15432@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-8-git-send-email-benjamin.tissoires@gmail.com>
	<20121029221605.GA15432@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:19:21 +0100
Message-ID: <CAN+gG=ER5mHDyBmw=6E5+p-0tUNz=iSH0wG_NoVisqOhk9Wh+w@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] HID: hid-multitouch: move ALWAYS_VALID quirk check
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:16 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Win 8 device specification changed the requirements for the hid usages
>> of the multitouch devices. Now InRange is optional and must be only
>> used when the device supports hovering.
>>
>> This ensures that the quirk ALWAYS_VALID is taken into account and
>> also ensures its precedence over the other VALID* quirks.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> Since we seem to never actually reset td, this seems equivalent,
> unless some device added ALWAYS VALID by mistake, even if INRANGE is
> not part of the report descriptor.

Yes, it is equivalent for Win7 devices. The field InRange was
mandatory, and currently, nobody mixed ALWAYS_VALID with other quirks.
But now, InRange is optional, and device not supporting hovering
should not use it, so it's mandatory to move it at a place we can be
sure it will be taken into account.

>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 000c979..43bd8e8 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -506,7 +506,7 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
>>   */
>>  static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>  {
>> -     if (td->curvalid) {
>> +     if (td->curvalid || td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID) {
>
> I found at least one presence of this construct in the kernel, but I
> think the overwhelming majority use parenthesis.

oops, I was really angry against parenthesis in this patch series :)

Cheers,
Benjamin

>
>>               int slotnum = mt_compute_slot(td, input);
>>               struct mt_slot *s = &td->curdata;
>>
>> @@ -561,9 +561,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>       if (hid->claimed & HID_CLAIMED_INPUT) {
>>               switch (usage->hid) {
>>               case HID_DG_INRANGE:
>> -                     if (quirks & MT_QUIRK_ALWAYS_VALID)
>> -                             td->curvalid = true;
>> -                     else if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>> +                     if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>>                               td->curvalid = value;
>>                       break;
>>               case HID_DG_TIPSWITCH:
>> --
>> 1.7.11.7
>>
>
> Thanks,
> Henrik

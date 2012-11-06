Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab2KFN4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:56:05 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54743 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2KFN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:56:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAN+gG=HLmCszdxgdcmt5AgzNyt08HamCdd2BjzCaTB5k7wYcnQ@mail.gmail.com>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-4-git-send-email-benjamin.tissoires@gmail.com>
	<20121029192558.GA15061@polaris.bitmath.org>
	<CAN+gG=HLmCszdxgdcmt5AgzNyt08HamCdd2BjzCaTB5k7wYcnQ@mail.gmail.com>
Date: Tue, 6 Nov 2012 14:56:01 +0100
Message-ID: <CAN+gG=GiAsn-5kefjRj_xgFfbuEXxj_PL7PaPES05wiZs+J-Ug@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] HID: hid-input: add usage_index argument in
 input_mapping and event.
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

On Tue, Oct 30, 2012 at 11:09 AM, Benjamin Tissoires
<benjamin.tissoires@gmail.com> wrote:
> On Mon, Oct 29, 2012 at 8:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> Hi Benjamin,
>>
>>> Currently, there is no way to know the index of the current field
>>> in the .input_mapping and .event callbacks  when this field is inside
>>> an array of HID fields.
>>> This patch forwards this index to the input_mapping and event
>>> callbacks.
>>
>> I agree with the idea, but the function argument list is becoming
>> ridiculously long... Could we remove the usage pointer argument, at
>> least?
>
> yeah, totally agree. Let me just check whether it will not introduce
> more problems than it solves for my driver.

Well, after a deeper look, it's a really bad idea. Every drivers that
implements input_mapping, input_mapped, event use at least once the
struct usage. So this would require change nearly every hid driver.

To solve that, and to minimize the impact on the other drivers, I'm
going to add a field in struct usage with the appropriate index.

Cheers,
Benjamin

>
>>
>>         int (*event)(struct hid_device *hdev, struct hid_field *field,
>>                         unsigned int usage_index, __s32 value);
>>
>>
>>> @@ -1071,19 +1072,24 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
>>>       for (n = 0; n < count; n++) {
>>>
>>>               if (HID_MAIN_ITEM_VARIABLE & field->flags) {
>>> -                     hid_process_event(hid, field, &field->usage[n], value[n], interrupt);
>>> +                     hid_process_event(hid, field, &field->usage[n], n,
>>> +                             value[n], interrupt);
>>>                       continue;
>>>               }
>>>
>>>               if (field->value[n] >= min && field->value[n] <= max
>>>                       && field->usage[field->value[n] - min].hid
>>>                       && search(value, field->value[n], count))
>>> -                             hid_process_event(hid, field, &field->usage[field->value[n] - min], 0, interrupt);
>>> +                             hid_process_event(hid, field,
>>> +                                     &field->usage[field->value[n] - min], n,
>>> +                                     0, interrupt);
>>
>> Wrong index?
>
> oops, I'll have to check that.
>
> Thanks,
> Benjamin
>
>>
>>>
>>>               if (value[n] >= min && value[n] <= max
>>>                       && field->usage[value[n] - min].hid
>>>                       && search(field->value, value[n], count))
>>> -                             hid_process_event(hid, field, &field->usage[value[n] - min], 1, interrupt);
>>> +                             hid_process_event(hid, field,
>>> +                                     &field->usage[value[n] - min], n,
>>> +                                     1, interrupt);
>>
>> Wrong index?
>>
>>>       }
>>>
>>>       memcpy(field->value, value, count * sizeof(__s32));
>>
>> Thanks,
>> Henrik

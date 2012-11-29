Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2K2Pbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:31:47 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34293 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2K2Pbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121127202150.GA895@polaris.bitmath.org>
References: <1353684694-5723-1-git-send-email-benjamin.tissoires@gmail.com>
	<1353684694-5723-4-git-send-email-benjamin.tissoires@gmail.com>
	<20121127202150.GA895@polaris.bitmath.org>
Date: Thu, 29 Nov 2012 16:31:43 +0100
Message-ID: <CAN+gG=HqecBrhdnZtfgxhByhtXf+uGELPHGsbcD9OAj6Gx7odg@mail.gmail.com>
Subject: Re: [PATCH 03/11] HID: hid-input: export hidinput_allocation function
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 9:21 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Fri, Nov 23, 2012 at 04:31:26PM +0100, Benjamin Tissoires wrote:
>> During the probe, third party drivers can now safely create a new
>> input devices depending on the parsing of the reports descriptor.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-input.c | 14 +++++++++++---
>>  include/linux/hid.h     |  1 +
>>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> I can think of two mechanisms that might be useful in finding a
> way to achieve this cleanly: a) Let a driver return a value telling
> whether to change input device, and b) Let a second driver have a go
> at the same device report. Some return value or state could determine
> logic in the hid core saying "we are not done with this device, try
> another driver". Or something. Just not this way, please.

Hi Henrik,

ok for the implementation of this patch series, it has to be reworked.

As for your proposals:

a) We can not rely on input_mapping because there is a temporal issue:
we already want to have the new input when we are in input_mapping.
So, this implies to create a new callback.

b) This would implies just too much work in hid-core for taking into
account a special case of one type of devices.
Here, we have in the same usb interface 2 different type of reports
coming from different sensors. It's far too different from the usual
configuration we have with legacy devices: when we have several hid
drivers handling the same usb device, it was when hardware makers
split the different sensors in different interfaces. This situation is
correctly handled in the usb subsystem and the hid layer has only to
deal with one driver at a time for a specific interface.

So, in the next series, I propose a new callback ("new_report" -- the
name is awful, but I can not manage to find another one ATM) which
will be called before we call input_mapping for a whole report.
The driver will then have the possibility to:
- continue normally (default behavior)
- ask for a new input device
- skip the entire report

Anyway, Henrik , could you also have a look at patches 7 to 11, they
have nothing to do with pen support, and I'm sure that you want to say
something on them too.

Cheers,
Benjamin

>
>>
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index eea02b0..b0572d0 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -1163,7 +1163,7 @@ static void report_features(struct hid_device *hid)
>>                       }
>>  }
>>
>> -static struct hid_input *hidinput_allocate(struct hid_device *hid)
>> +struct hid_input *hidinput_allocate(struct hid_device *hid)
>>  {
>>       struct hid_input *hidinput = kzalloc(sizeof(*hidinput), GFP_KERNEL);
>>       struct input_dev *input_dev = input_allocate_device();
>> @@ -1190,10 +1190,16 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
>>       input_dev->id.version = hid->version;
>>       input_dev->dev.parent = hid->dev.parent;
>>       hidinput->input = input_dev;
>> -     list_add_tail(&hidinput->list, &hid->inputs);
>> +     list_add(&hidinput->list, &hid->inputs);
>>
>>       return hidinput;
>>  }
>> +EXPORT_SYMBOL_GPL(hidinput_allocate);
>> +
>> +static struct hid_input *hid_get_latest_hidinput(struct hid_device *hid)
>> +{
>> +     return list_first_entry(&hid->inputs, struct hid_input, list);
>> +}
>>
>>  /*
>>   * Register the input device; print a message.
>> @@ -1243,9 +1249,11 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
>>                       }
>>
>>                       for (i = 0; i < report->maxfield; i++)
>> -                             for (j = 0; j < report->field[i]->maxusage; j++)
>> +                             for (j = 0; j < report->field[i]->maxusage; j++) {
>> +                                     hidinput = hid_get_latest_hidinput(hid);
>>                                       hidinput_configure_usage(hidinput, report->field[i],
>>                                                                report->field[i]->usage + j);
>> +                             }
>>
>>                       if (hid->quirks & HID_QUIRK_MULTI_INPUT) {
>>                               /* This will leave hidinput NULL, so that it
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index d2c42dd..42b02d6 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -701,6 +701,7 @@ extern void hidinput_hid_event(struct hid_device *, struct hid_field *, struct h
>>  extern void hidinput_report_event(struct hid_device *hid, struct hid_report *report);
>>  extern int hidinput_connect(struct hid_device *hid, unsigned int force);
>>  extern void hidinput_disconnect(struct hid_device *);
>> +extern struct hid_input *hidinput_allocate(struct hid_device *hid);
>>
>>  int hid_set_field(struct hid_field *, unsigned, __s32);
>>  int hid_input_report(struct hid_device *, int type, u8 *, int, int);
>> --
>> 1.8.0
>>
>
> Thanks,
> Henrik

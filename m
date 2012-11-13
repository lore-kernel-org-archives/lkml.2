Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2KMRpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:45:11 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47694 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab2KMRpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:45:09 -0500
MIME-Version: 1.0
In-Reply-To: <20121113172711.GA856@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
	<1352306256-12180-14-git-send-email-benjamin.tissoires@gmail.com>
	<50A25990.6040302@gmail.com>
	<20121113172711.GA856@polaris.bitmath.org>
Date: Tue, 13 Nov 2012 18:45:07 +0100
Message-ID: <CAN+gG=HdOqVu1M2pycMZUBd4Z7wK9Bx=NLkCaaFwFie1-E3tdQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] HID: hid-multitouch: forwards ABS_SCAN_TIME
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

On Tue, Nov 13, 2012 at 6:27 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> Date: Tue, 13 Nov 2012 15:12:17 +0100
>> Subject: [PATCH v4] HID: hid-multitouch: forwards MSC_TIMESTAMP
>>
>> Computes the device timestamp according to the specification.
>> It also ensures that if the time between two events is greater
>> than MAX_TIMESTAMP_INTERVAL, the timestamp will be reset.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  drivers/hid/hid-multitouch.c | 46 +++++++++++++++++++++++++++++++++++++++++---
>>  include/linux/hid.h          |  1 +
>>  2 files changed, 44 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index caf0f0b..3f8432d 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -32,6 +32,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/usb.h>
>>  #include <linux/input/mt.h>
>> +#include <linux/jiffies.h>
>
> Why?
>
>>  #include "usbhid/usbhid.h"
>>
>>
>> @@ -98,6 +99,9 @@ struct mt_device {
>>       bool serial_maybe;      /* need to check for serial protocol */
>>       bool curvalid;          /* is the current contact valid? */
>>       unsigned mt_flags;      /* flags to pass to input-mt */
>> +     __s32 dev_time;         /* the scan time provided by the device */
>> +     unsigned long jiffies;  /* the frame's jiffies */
>> +     unsigned timestamp;     /* the timestamp to be sent */
>
> Why not just dev_time here?

because max dev_time is at least 65535 according to the norm, and the
win 8 device I have has his max value of 65535.
Which means that every 6 seconds and a half the counter resets, and
the value is not properly reset in the way I understand the
specification. The device just forwards an internal clock that is
never reset.
So if you wait 653500 us + 8ms, everything happens as if the device
sent this frame right after the previous one (you get the same value).

I think that it's the job of the kernel to provide clean and coherent
values through evdev, which won't be the case if the jiffies thing is
not in place: every devices will have a different behavior, leading to
complicate things in the user-space.

>
>>  };
>>
>>  /* classes of device behavior */
>> @@ -126,6 +130,8 @@ struct mt_device {
>>  #define MT_DEFAULT_MAXCONTACT        10
>>  #define MT_MAX_MAXCONTACT    250
>>
>> +#define MAX_TIMESTAMP_INTERVAL       500000
>> +
>
> Needs to be done in userland anyways, so no need to check this in the kernel.
>
>>  #define MT_USB_DEVICE(v, p)  HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH, v, p)
>>  #define MT_BT_DEVICE(v, p)   HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH, v, p)
>>
>> @@ -451,12 +457,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>                       mt_store_field(usage, td, hi);
>>                       td->last_field_index = field->index;
>>                       return 1;
>> +             case HID_DG_SCANTIME:
>> +                     hid_map_usage(hi, usage, bit, max,
>> +                             EV_MSC, MSC_TIMESTAMP);
>> +                     set_bit(MSC_TIMESTAMP, hi->input->mscbit);
>> +                     td->last_field_index = field->index;
>> +                     return 1;
>>               case HID_DG_CONTACTCOUNT:
>>                       td->last_field_index = field->index;
>>                       return 1;
>>               case HID_DG_CONTACTMAX:
>> -                     /* we don't set td->last_slot_field as contactcount and
>> -                      * contact max are global to the report */
>> +                     /* we don't set td->last_slot_field as scan time,
>> +                      * contactcount and contact max are global to the
>> +                      * report */
>>                       td->last_field_index = field->index;
>>                       return -1;
>>               }
>> @@ -485,7 +498,8 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>>               struct hid_field *field, struct hid_usage *usage,
>>               unsigned long **bit, int *max)
>>  {
>> -     if (usage->type == EV_KEY || usage->type == EV_ABS)
>> +     if (usage->type == EV_KEY || usage->type == EV_ABS ||
>> +         usage->type == EV_MSC)
>>               set_bit(usage->type, hi->input->evbit);
>>
>>       return -1;
>> @@ -565,11 +579,34 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>>   */
>>  static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
>>  {
>> +     input_event(input, EV_MSC, MSC_TIMESTAMP, td->timestamp);
>
> I think this should go after the frame sync,
>
>>       input_mt_sync_frame(input);
>
> And the computation (100 * td->dev_time) should work fine. It will wrap
> properly.
>
>>       input_sync(input);
>>       td->num_received = 0;
>>  }
>>
>> +static void mt_compute_timestamp(struct mt_device *td, struct hid_field *field,
>> +             __s32 value)
>> +{
>> +     long delta = value - td->dev_time;
>> +     unsigned long jdelta = jiffies_to_usecs(jiffies - td->jiffies);
>> +
>> +     td->jiffies = jiffies;
>> +     td->dev_time = value;
>> +
>> +     if (delta < 0)
>> +             delta += field->logical_maximum;
>> +
>> +     /* HID_DG_SCANTIME is expressed in 100us, we want it in ms. */
>> +     delta *= 100;
>> +
>> +     if (abs(delta - jdelta) > MAX_TIMESTAMP_INTERVAL)
>> +             /* obviously wrong clock -> the device time has been reset */
>> +             td->timestamp = 0;
>> +     else
>> +             td->timestamp += delta;
>> +}
>> +
>
> Can be skipped entirely.
>
>>  static int mt_event(struct hid_device *hid, struct hid_field *field,
>>                               struct hid_usage *usage, __s32 value)
>>  {
>> @@ -617,6 +654,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>               case HID_DG_HEIGHT:
>>                       td->curdata.h = value;
>>                       break;
>> +             case HID_DG_SCANTIME:
>> +                     mt_compute_timestamp(td, field, value);
>
> Just td->dev_time = value should work fine here.
>
>> +                     break;
>>               case HID_DG_CONTACTCOUNT:
>>                       /*
>>                        * Includes multi-packet support where subsequent
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index 6b4f322..0337e50 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -279,6 +279,7 @@ struct hid_item {
>>  #define HID_DG_DEVICEINDEX   0x000d0053
>>  #define HID_DG_CONTACTCOUNT  0x000d0054
>>  #define HID_DG_CONTACTMAX    0x000d0055
>> +#define HID_DG_SCANTIME              0x000d0056
>
> Was this missing this the old patch, or did it get moved here?

Sorry for that. I moved it there because I cleaned a little the other
patch by removing the hid things.

Cheers,
Benjamin

>
>>
>>  /*
>>   * HID report types --- Ouch! HID spec says 1 2 3!
>> --
>> 1.8.0
>
> Thanks,
> Henrik

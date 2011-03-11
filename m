Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1CKH0o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:26:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46617 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1CKH0l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:26:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=orZxTvyogqlD8hVnoAcRZ29NgNcOXkSjoo8chTKzfZD/5gaGWY65QzIKuvTKZARBPI
         FgfD1C9wWRlpko2LwoTZaiqQAg60gjSpYyv1xCOGcTdpq4NbhZVppKsfVl+m7wu0eOPt
         7bDNsI9BRi/PhPkdWIrdFLrunB4OBW7nTj7O0=
MIME-Version: 1.0
In-Reply-To: <20110310155225.GA23034@polaris.bitmath.org>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
	<1299686450-5475-5-git-send-email-benjamin.tissoires@enac.fr>
	<20110310155225.GA23034@polaris.bitmath.org>
Date: Fri, 11 Mar 2011 08:26:39 +0100
X-Google-Sender-Auth: raohtINgc-YhfHikY4PQ27i__i0
Message-ID: <AANLkTi=jnd_gq8U+Fv7YSNk1iqt19paFQ3do=f5VrcSC@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] hid-multitouch: migrate 3M PCT touch screens to hid-multitouch
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Thu, Mar 10, 2011 at 16:52, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index 02a77f9..0b92dfc 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -5,6 +5,11 @@
>>   *  Copyright (c) 2010-2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>>   *  Copyright (c) 2010-2011 Ecole Nationale de l'Aviation Civile, France
>>   *
>> + *  based on hid-3m-pct.c copyrighted as follows:
>> + *    Copyright (c) 2009-2010 Stephane Chatty <chatty@enac.fr>
>> + *    Copyright (c) 2010      Henrik Rydberg <rydberg@euromail.se>
>> + *    Copyright (c) 2010      Canonical, Ltd.
>> + *
>>   */
>>
>>  /*
>> @@ -62,6 +67,8 @@ struct mt_class {
>>       __s32 name;     /* MT_CLS */
>>       __s32 quirks;
>>       __s32 sn_move;  /* Signal/noise ratio for move events */
>> +     __s32 sn_width; /* Signal/noise ratio for width events */
>> +     __s32 sn_height;        /* Signal/noise ratio for height events */
>>       __s32 sn_pressure;      /* Signal/noise ratio for pressure events */
>>       __u8 maxcontacts;
>>  };
>> @@ -72,6 +79,7 @@ struct mt_class {
>>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER    3
>>  #define MT_CLS_CYPRESS                               4
>>  #define MT_CLS_STANTUM                               5
>> +#define MT_CLS_3M                            6
>>
>>  /*
>>   * these device-dependent functions determine what slot corresponds
>> @@ -123,6 +131,12 @@ struct mt_class mt_classes[] = {
>>               .maxcontacts = 10 },
>>       { .name = MT_CLS_STANTUM,
>>               .quirks = MT_QUIRK_VALID_IS_CONFIDENCE },
>
> I realize several of the entries are missing maxcontacts now, so all
> patches needs to be checked...

This is really annoying. The idea behind the auto-detection was to
simplify the writing of the driver and to let the device inform us on
its capabilities.
It's not a bug, it's a feature in this particular case. My idea was to
remove all those .maxcontact (for instance, I know that it works for
cypress, stantum and 3M) but I didn't want to bother my testers about
such a little change.

Can I remember you that you where the first complaining about the
maxcontact? You asked if it could not be given by the device. And as
we where in a hurry, we didn't include it and said that we will do it
later.

>
>> +     { .name = MT_CLS_3M,
>> +             .quirks = MT_QUIRK_VALID_IS_CONFIDENCE |
>> +                     MT_QUIRK_SLOT_IS_CONTACTID,
>> +             .sn_move = 2048,
>> +             .sn_width = 128,
>> +             .sn_height = 128 },
>
> And this one does too

And this one would be false: should I write 10 or 60? As it depends on
the device, we'll have to let the device decide.
If you remember the commit message of the auto-detection patch, I have
written that we keep the .maxcontact field in case the device _lies_.
And 3M does not lie.

>>
>>       { }
>>  };
>> @@ -206,11 +220,15 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>               case HID_DG_WIDTH:
>>                       hid_map_usage(hi, usage, bit, max,
>>                                       EV_ABS, ABS_MT_TOUCH_MAJOR);
>> +                     set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
>> +                             cls->sn_width);
>>                       td->last_slot_field = usage->hid;
>>                       return 1;
>>               case HID_DG_HEIGHT:
>>                       hid_map_usage(hi, usage, bit, max,
>>                                       EV_ABS, ABS_MT_TOUCH_MINOR);
>> +                     set_abs(hi->input, ABS_MT_TOUCH_MINOR, field,
>> +                             cls->sn_height);
>>                       field->logical_maximum = 1;
>>                       field->logical_minimum = 0;
>
> These limits are not right - I doubt they are for any device.

I was a little surprise too while looking at these. But This is not
related to ABS_MT_TOUCH_MINOR, but ABS_MT_ORIENTATION.
And if I'm forced to modify those values this way it's because _you_
made me introduce the set_abs function which takes in parameter the
field. Thus, it's more complicated to introduce new fields and usages.

>
>>                       set_abs(hi->input, ABS_MT_ORIENTATION, field, 0);
>> @@ -307,11 +325,18 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>>               input_mt_report_slot_state(input, MT_TOOL_FINGER,
>>                       s->touch_state);
>>               if (s->touch_state) {
>> +                     /* this finger is on the screen */
>> +                     int wide = (s->w > s->h);
>> +                     /* divided by two to match visual scale of touch */
>> +                     int major = max(s->w, s->h) >> 1;
>> +                     int minor = min(s->w, s->h) >> 1;
>> +
>>                       input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
>>                       input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
>> +                     input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>>                       input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>> -                     input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, s->w);
>> -                     input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, s->h);
>> +                     input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
>> +                     input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
>>               }
>>               s->seen_in_this_frame = false;
>>
>> @@ -481,6 +506,14 @@ static void mt_remove(struct hid_device *hdev)
>>
>>  static const struct hid_device_id mt_devices[] = {
>>
>> +     /* 3M panels */
>> +     { .driver_data = MT_CLS_3M,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_3M,
>> +                     USB_DEVICE_ID_3M1968) },
>> +     { .driver_data = MT_CLS_3M,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_3M,
>> +                     USB_DEVICE_ID_3M2256) },
>> +
>>       /* Cando panels */
>>       { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
>>               HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
>> --
>> 1.7.4
>>
>
> Also, this line needs to be added in case no feature reports are sent:
>
> @@ -481,6 +481,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>                return -ENOMEM;
>        }
>        td->mtclass = mtclass;
> +       td->maxcontacts = mtclass->maxcontacts;
>        td->inputmode = -1;
>        hid_set_drvdata(hdev, td);
>

So:
1) If a device does not send the feature report related to maxcontact,
then it won't pass the Win7 certification, then we will need to write
a special driver for it.
2) This is wrong because I do not want to add in all those classes the
field maxcontact. So I'll revert the MT_DEFAULT_MAXCONTACT, and I will
add this sort of line just before allocating the slots.
Oh, and I'll remove the .maxcontact = 2 for MT_CLS_DEFAULT.

Cheers,
Benjamin

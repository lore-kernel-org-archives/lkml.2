Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab1AGJjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:39:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40750 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab1AGJi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VkXQAbluBQyvCCqvFyGuOGGa1MafkvgioutesOo+XoJj5nWuUeWrBS61ec8B3s4DEn
         QxV1tysca1Mn6+vejApU1f5VffC20JfqPc16hULkLNgWerfpmwMJMusOI1f9/5hHJk/k
         o982Lfpd8zGm7kSF0w3Fo2a8BpOaOlElWwp74=
MIME-Version: 1.0
In-Reply-To: <20110106172528.GD1790@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294248468-19979-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110106172528.GD1790@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 10:38:57 +0100
X-Google-Sender-Auth: D9TTOQIf2j4hEoMCYjnxVFVQJUA
Message-ID: <AANLkTimhk80b+jkqsNrxmFzSgmHX=_wdzbwE09NoFgV1@mail.gmail.com>
Subject: Re: [RFC v2 03/10] hid-multitouch: support for PixCir-based panels
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 6:25 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Wed, Jan 05, 2011 at 06:27:41PM +0100, Benjamin Tissoires wrote:
>> Created a driver for PixCir based dual-touch panels, including the one
>> in the Hanvon tablet.  This is done in a code structure aimed at unifying
>> support for several existing HID multitouch panels.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
>> Signed-off-by: Stéphane Chatty <chatty@enac.fr>
>> ---
>>  drivers/hid/Kconfig          |    6 +
>>  drivers/hid/Makefile         |    1 +
>>  drivers/hid/hid-core.c       |    2 +
>>  drivers/hid/hid-ids.h        |    4 +
>>  drivers/hid/hid-multitouch.c |  434 ++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 447 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/hid/hid-multitouch.c
>>
>> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
>> index 401acec..6519981 100644
>> --- a/drivers/hid/Kconfig
>> +++ b/drivers/hid/Kconfig
>> @@ -285,6 +285,12 @@ config HID_MONTEREY
>>       ---help---
>>       Support for Monterey Genius KB29E.
>>
>> +config HID_MULTITOUCH
>> +     tristate "HID Multitouch panels"
>> +     depends on USB_HID
>> +     ---help---
>> +     Generic support for HID multitouch panels.
>> +
>
> Please provide a bit more information under this config option. The
> usual "what should I do", and roughly what devices are supported.

Will try, but don't hesitate to send one if you feel in a good mood for writing.

I can propose:

+        ---help---
+          Generic support for HID multitouch panels.
+          Currently supported panels are:
+          - PixCir touchscreen
+          - Cypress TrueTouch
+          - 'Sensing Win7-TwoFinger' panel by GeneralTouch

>
>>  config HID_NTRIG
>>       tristate "N-Trig touch screen"
>>       depends on USB_HID
>> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
>> index c335605..ec991d4 100644
>> --- a/drivers/hid/Makefile
>> +++ b/drivers/hid/Makefile
>> @@ -46,6 +46,7 @@ obj-$(CONFIG_HID_MAGICMOUSE)    += hid-magicmouse.o
>>  obj-$(CONFIG_HID_MICROSOFT)  += hid-microsoft.o
>>  obj-$(CONFIG_HID_MONTEREY)   += hid-monterey.o
>>  obj-$(CONFIG_HID_MOSART)     += hid-mosart.o
>> +obj-$(CONFIG_HID_MULTITOUCH) += hid-multitouch.o
>>  obj-$(CONFIG_HID_NTRIG)              += hid-ntrig.o
>>  obj-$(CONFIG_HID_ORTEK)              += hid-ortek.o
>>  obj-$(CONFIG_HID_PRODIKEYS)  += hid-prodikeys.o
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index 88668ae..2b4d9b9 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -1286,6 +1286,7 @@ static const struct hid_device_id hid_blacklist[] = {
>>       { HID_USB_DEVICE(USB_VENDOR_ID_BELKIN, USB_DEVICE_ID_FLIP_KVM) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
>> @@ -1312,6 +1313,7 @@ static const struct hid_device_id hid_blacklist[] = {
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_HANVON, USB_DEVICE_ID_HANVON_MULTITOUCH) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>> index 0f150c7..17b444b 100644
>> --- a/drivers/hid/hid-ids.h
>> +++ b/drivers/hid/hid-ids.h
>> @@ -134,6 +134,7 @@
>>  #define USB_DEVICE_ID_BTC_EMPREX_REMOTE_2    0x5577
>>
>>  #define USB_VENDOR_ID_CANDO          0x2087
>> +#define USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH 0x0703
>>  #define USB_DEVICE_ID_CANDO_MULTI_TOUCH      0x0a01
>>  #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6 0x0b03
>>  #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6 0x0f01
>> @@ -306,6 +307,9 @@
>>  #define USB_DEVICE_ID_HANWANG_TABLET_FIRST   0x5000
>>  #define USB_DEVICE_ID_HANWANG_TABLET_LAST    0x8fff
>>
>> +#define USB_VENDOR_ID_HANVON         0x20b3
>> +#define USB_DEVICE_ID_HANVON_MULTITOUCH      0x0a18
>> +
>>  #define USB_VENDOR_ID_HAPP           0x078b
>>  #define USB_DEVICE_ID_UGCI_DRIVING   0x0010
>>  #define USB_DEVICE_ID_UGCI_FLYING    0x0020
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> new file mode 100644
>> index 0000000..aea0e32
>> --- /dev/null
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -0,0 +1,434 @@
>> +/*
>> + *  HID driver for multitouch panels
>> + *
>> + *  Copyright (c) 2010-2011 Stephane Chatty <chatty@enac.fr>
>> + *  Copyright (c) 2010-2011 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> + *  Copyright (c) 2010-2011 Enac
>> + *
>> + */
>> +
>> +/*
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the Free
>> + * Software Foundation; either version 2 of the License, or (at your option)
>> + * any later version.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/hid.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include <linux/usb.h>
>> +#include <linux/input/mt.h>
>> +#include "usbhid/usbhid.h"
>> +
>> +
>> +MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
>> +MODULE_DESCRIPTION("HID multitouch panels");
>> +MODULE_LICENSE("GPL");
>> +
>> +#include "hid-ids.h"
>> +
>> +
>> +struct mt_slot {
>> +     __s32 x, y, p;
>> +     __s32 contactid;        /* the device ContactID assigned to this slot */
>> +     __u16 trkid;    /* the tracking ID that was assigned to this slot */
>> +     bool valid;     /* did we just get valid contact data for this slot? */
>> +     bool prev_valid;/* was this slot previously valid/active? */
>> +};
>
> The trkid and prev_valid are no longer needed. The touch state seems to be missing.

Concerning the trkid, agree.
I can assure you that prev_valid is needed by at least the Cypress
device. In a sense, it has the same problem than mt protocol A: it
does not send the release information except when the last finger has
been released. This gymnastic is thus required.

I think that the misunderstanding comes from the name. We have this 2
flags (valid and prev_valid) to tell whether the device sent data
during this report or the previous one. It's not the same meaning that
the touch you're talking about. For Cypress device, those 2 flags are
mandatory.

Maybe introducing data + prev_data + touch (3 flags instead of 2->
touch can go into mt_buffer, and data and prev_data only in mt_slot as
they are not given by the device) is clearer.


>
>> +
>> +struct mt_buffer {
>> +     __s32 x, y, p;
>> +     __s32 contactid;        /* the device ContactID assigned to this slot */
>> +};
>
> The only different to mt_slot are the valid and touch field, which is
> also needed for incoming data. I'd say those should be merged.
>

Well, the point is that the buffer and the slot have 2 different meanings:
one is the incoming data, the other is the processed data. It strikes
us to have only one struct as the slot contains extra information for
it to be processed.

>> +
>> +struct mt_device {
>> +     struct mt_buffer curdata;       /* placeholder of incoming data */
>> +     struct mt_class *mtclass;       /* our mt device class */
>> +     unsigned last_field_index;      /* last field index of the report */
>> +     unsigned last_slot_field;       /* the last field of a slot */
>> +     __u16 lasttrkid;        /* the last tracking ID we assigned */
>
> No longer needed.

agree (I must have read your patch too quickly).

>
>> +     __s8 inputmode;         /* InputMode HID feature, -1 if non-existent */
>> +     __u8 num_received;      /* how many contacts we received */
>> +     __u8 maxcontact;        /* expected last contact index */
>> +     bool curvalid;          /* is the current contact valid? */
>
> This value should probably be a mt_slot struct as well.

I was bothering too. Renaming the field (see above) may solve the
problem: we have curvalid (or curdata with the name I propose) which
is only needed for algorithm reasons, and touch that goes into
mt_buffer as it comes from the device.

>
>> +     struct mt_slot slots[0];        /* first slot */
>> +};
>> +
>> +struct mt_class {
>> +     int (*compute_slot)(struct mt_device *);
>> +     __u8 maxcontacts;
>> +};
>
> I imagine maxcontacts could be variable for devices within the same
> class. Perhaps it should be a member of the device instead? The
> resolution and fuzz could be added here as well.

resolution and fuzz: I let you implement it (when adding egalax or
3m). But isn't it something we can't get from the report descriptors?

concerning the device vs. class, currently, we have only seen classes
(one or more device sharing the same behavior), but we didn't bother
about resolution and fuzz.
It would be a shame to have to duplicate the mt_class (or mt_device),
one by vendorID/deviceID, as many devices may share the same
properties (at least those that have been manufactured by the same
company and that behave the same way: cando, stantum, etc...).
I also like the concept of default class as it will help people easily
adding devices.

>
>> +
>> +/* classes of device behavior */
>> +#define MT_CLS_DEFAULT 0
>> +#define MT_CLS_DUAL1 1
>> +
>> +/*
>> + * these device-dependent functions determine what slot corresponds
>> + * to a valid contact that was just read.
>> + */
>> +
>> +static int slot_is_contactid(struct mt_device *td)
>> +{
>> +     return td->curdata.contactid;
>> +}
>> +
>> +static int find_slot_from_contactid(struct mt_device *td)
>> +{
>> +     int i;
>> +     for (i = 0; i < td->mtclass->maxcontacts; ++i) {
>> +             if (td->slots[i].prev_valid &&
>
> Why prev_valid? Ought to be valid, right?

Because the code resets valid after each sending -> implementation dependent.

>
>> +                     td->slots[i].contactid == td->curdata.contactid)
>> +                     return i;
>> +     }
>> +     for (i = 0; i < td->mtclass->maxcontacts; ++i) {
>> +             if (!td->slots[i].valid && !td->slots[i].prev_valid)
>> +                     return i;
>
> Simplifaction here too without the prev_valid.

Related to current implementation too

>
>> +     }
>> +     return -1; /* should not occurs */
>
> And what should happen if it does?

good question. This would means that the device sent more touches that
it says in the report descriptor. It is ignored then.
Will add a comment.

>
>> +}
>> +
>> +struct mt_class mt_classes[] = {
>> +     { find_slot_from_contactid, 10 },     /* MT_CLS_DEFAULT */
>> +     { slot_is_contactid, 2 },             /* MT_CLS_DUAL1 */
>> +};
>
> It seems likely that this will become a device-specific list, rather than classes.

see above. Maybe we should add this patch with classes, and when
resolution and fuzz are added, we may turn it into devices if
required.

>
>> +
>> +static void mt_feature_mapping(struct hid_device *hdev, struct hid_input *hi,
>> +             struct hid_field *field, struct hid_usage *usage)
>> +{
>> +     if (usage->hid == HID_DG_INPUTMODE) {
>> +             struct mt_device *td = hid_get_drvdata(hdev);
>> +             td->inputmode = field->report->id;
>> +     }
>> +}
>> +
>> +static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>> +             struct hid_field *field, struct hid_usage *usage,
>> +             unsigned long **bit, int *max)
>> +{
>> +     struct mt_device *td = hid_get_drvdata(hdev);
>> +     switch (usage->hid & HID_USAGE_PAGE) {
>> +
>> +     case HID_UP_GENDESK:
>> +             switch (usage->hid) {
>> +             case HID_GD_X:
>> +                     hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_POSITION_X);
>> +                     input_set_abs_params(hi->input, ABS_MT_POSITION_X,
>> +                                             field->logical_minimum,
>> +                                             field->logical_maximum, 0, 0);
>> +                     /* touchscreen emulation */
>> +                     input_set_abs_params(hi->input, ABS_X,
>> +                                             field->logical_minimum,
>> +                                             field->logical_maximum, 0, 0);
>> +                     td->last_slot_field = usage->hid;
>> +                     return 1;
>> +             case HID_GD_Y:
>> +                     hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_POSITION_Y);
>> +                     input_set_abs_params(hi->input, ABS_MT_POSITION_Y,
>> +                                             field->logical_minimum,
>> +                                             field->logical_maximum, 0, 0);
>> +                     /* touchscreen emulation */
>> +                     input_set_abs_params(hi->input, ABS_Y,
>> +                                             field->logical_minimum,
>> +                                             field->logical_maximum, 0, 0);
>> +                     td->last_slot_field = usage->hid;
>> +                     return 1;
>> +             }
>> +             return 0;
>
> Nice solution to the end-of-data issue. It would be good if the input
> setup was abstracted into a function like in hid-egalax, to simplify
> further additions.

thanks.
I was not very happy in making this abstraction for just one line of
code. I thought you could do it when adding the additions.

>
>> +
>> +     case HID_UP_DIGITIZER:
>> +             switch (usage->hid) {
>> +             case HID_DG_INRANGE:
>> +             case HID_DG_CONFIDENCE:
>> +                     td->last_slot_field = usage->hid;
>> +                     return 1;
>
> The inrange field has meaning for some drivers, I think these should be split.

if you want.

>
>> +             case HID_DG_TIPSWITCH:
>> +                     hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
>> +                     input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
>> +                     td->last_slot_field = usage->hid;
>> +                     return 1;
>> +             case HID_DG_CONTACTID:
>> +                     if (!hi->input->mt)
>
> This test can be dropped now.

will do

>
>> +                             input_mt_init_slots(hi->input,
>> +                                             td->mtclass->maxcontacts);
>
> Maxcontacts should probably take the hid description into account as well.

I don't understand your point here

>
>> +                     td->last_slot_field = usage->hid;
>> +                     return 1;
>> +             case HID_DG_TIPPRESSURE:
>> +                     hid_map_usage(hi, usage, bit, max,
>> +                                     EV_ABS, ABS_MT_PRESSURE);
>> +                     td->last_slot_field = usage->hid;
>> +                     return 1;
>
> And ABS_PRESSURE.

I thought that the mouse emulation was restricted to X and Y.

>
>> +             case HID_DG_CONTACTCOUNT:
>> +                     td->last_field_index = field->report->maxfield - 1;
>
> A fall-through here does not seem very useful.

ok

>
>> +             case HID_DG_CONTACTMAX:
>> +                     /* we don't set td->last_slot_field as contactcount and
>> +                      * contact max are global to the report */
>> +                     return -1;
>> +             }
>> +             /* let hid-input decide for the others */
>> +             return 0;
>> +
>> +     case 0xff000000:
>> +             /* we do not want to map these: no input-oriented meaning */
>> +             return -1;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>> +             struct hid_field *field, struct hid_usage *usage,
>> +             unsigned long **bit, int *max)
>> +{
>> +     if (usage->type == EV_KEY || usage->type == EV_ABS)
>> +             set_bit(usage->type, hi->input->evbit);
>> +
>> +     return -1;
>> +}
>
> There are some hid drivers that need to setup fuzz in order to work
> properly. We should either add it to hid core or use the same bypass as
> in hid-egalax and hid-3m-pct.

Can I let you do this in further updates? (for the new devices and
those I sent, this works out of the box)

>
>> +
>> +/*
>> + * this function is called when a whole contact has been processed,
>> + * so that it can assign it to a slot and store the data there
>> + */
>> +static void mt_complete_slot(struct mt_device *td)
>> +{
>> +     if (td->curvalid) {
>> +             struct mt_slot *slot;
>> +             int slotnum = td->mtclass->compute_slot(td);
>> +
>> +             if (slotnum >= 0 && slotnum <= td->mtclass->maxcontacts - 1) {
>
> Please use "< maxcontacts".

oops

>
>> +                     slot = td->slots + slotnum;
>> +
>> +                     slot->valid = true;
>> +                     memcpy(slot, &(td->curdata), sizeof(struct mt_buffer));
>
> Valid is not always true for sure, and touch should be in here as
> well. A simple copy of the current data into the right slot will
> suffice - the validity will be copied too.

see curvalid/valid/prev_valid proposal above

>
>> +             }
>> +     }
>> +     td->num_received++;
>> +}
>> +
>> +
>> +/*
>> + * this function is called when a whole packet has been received and processed,
>> + * so that it can decide what to send to the input layer.
>> + */
>> +static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < td->mtclass->maxcontacts; ++i) {
>> +             struct mt_slot *s = &(td->slots[i]);
>> +             if (!s->valid) {
>> +                     /*
>> +                      * this slot does not contain useful data,
>> +                      * notify its closure if necessary
>> +                      */
>> +                     if (s->prev_valid) {
>> +                             input_mt_slot(input, i);
>> +                             input_mt_report_slot_state(input,
>> +                                     MT_TOOL_FINGER, false);
>> +                             s->prev_valid = false;
>> +                     }
>> +                     continue;
>> +             }
>> +             if (!s->prev_valid)
>> +                     s->trkid = td->lasttrkid++;
>
> Most of the above can be removed.

Cypress device does not sends touch information when a touch is
released. This piece of code is required for devices that behave the
same way.

>
>> +
>> +             input_mt_slot(input, i);
>> +             input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
>
> "true" here should simply be slot->touch state.
>
>> +             input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
>> +             input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
>> +             input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>> +             s->prev_valid = true;
>> +             s->valid = false;
>
> Invalidating the data of a tracked slots seems wrong. If the device
> sends tracked data properly, no special consideration is needed - it
> will get cleared when appropriate. Other cases could be dealt with
> separately.

already discussed (pb in naming the fields I think)

>
>> +
>> +     }
>> +
>> +     input_mt_report_pointer_emulation(input, true);
>> +     input_sync(input);
>> +     td->num_received = 0;
>> +}
>> +
>> +
>> +
>> +static int mt_event(struct hid_device *hid, struct hid_field *field,
>> +                             struct hid_usage *usage, __s32 value)
>> +{
>> +     struct mt_device *td = hid_get_drvdata(hid);
>> +
>> +     if (hid->claimed & HID_CLAIMED_INPUT) {
>> +             switch (usage->hid) {
>> +             case HID_DG_INRANGE:
>> +                     break;
>
> Egalax uses this field as validity.
>
>> +             case HID_DG_TIPSWITCH:
>> +                     td->curvalid = value;
>
> Most drivers seem to use this as touch state.

agree and that is how it is used in the current implementation. We
really should change the name.

>
>> +                     break;
>> +             case HID_DG_CONFIDENCE:
>> +                     break;
>> +             case HID_DG_CONTACTID:
>> +                     td->curdata.contactid = value;
>> +                     break;
>> +             case HID_DG_TIPPRESSURE:
>> +                     td->curdata.p = value;
>> +                     break;
>> +             case HID_GD_X:
>> +                     td->curdata.x = value;
>> +                     break;
>> +             case HID_GD_Y:
>> +                     td->curdata.y = value;
>> +                     break;
>> +             case HID_DG_CONTACTCOUNT:
>> +                     /*
>> +                      * We must not overwrite the previous value (some
>> +                      * devices send one sequence splitted over several
>> +                      * messages)
>> +                      */
>> +                     if (value)
>> +                             td->maxcontact = value - 1;
>
> Is td->maxcontact ever reset? And why not num_expected or something
> instead of maxcontact - odd semantics.

maxcontact is not reset (not needed as it is sent in each report).
Concerning the name, agree.

>
>> +                     break;
>> +             case HID_DG_CONTACTMAX:
>> +                     break;
>
> This one was filtered already.

ok

>
>> +
>> +             default:
>> +                     /* fallback to the generic hidinput handling */
>> +                     return 0;
>> +             }
>> +     }
>> +
>> +     if (usage->hid == td->last_slot_field)
>> +             mt_complete_slot(td);
>> +
>> +     if (field->index == td->last_field_index
>> +             && td->num_received > td->maxcontact) {
>> +             struct input_dev *input = field->hidinput->input;
>
> No need to declare a temp variable for one access.

bad refactoring, will change

>
>> +             mt_emit_event(td, input);
>
> Resetting expected countact count here would be good.

if you want, but not really needed.

>
>> +     }
>> +
>> +     /* we have handled the hidinput part, now remains hiddev */
>> +     if (hid->claimed & HID_CLAIMED_HIDDEV && hid->hiddev_hid_event)
>> +             hid->hiddev_hid_event(hid, field, usage, value);
>> +
>> +     return 1;
>> +}
>> +
>> +static void mt_set_input_mode(struct hid_device *hdev)
>> +{
>> +     struct mt_device *td = hid_get_drvdata(hdev);
>> +     struct hid_report *r;
>> +     struct hid_report_enum *re;
>> +
>> +     if (td->inputmode < 0)
>> +             return;
>> +
>> +     re = &(hdev->report_enum[HID_FEATURE_REPORT]);
>> +     r = re->report_id_hash[td->inputmode];
>> +     if (r) {
>> +             r->field[0]->value[0] = 0x02;
>> +             usbhid_submit_report(hdev, r, USB_DIR_OUT);
>> +     }
>> +}
>
> Nice reduction.

thanks ;)

Cheers,
Benjamin

>
>> +
>> +static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>> +{
>> +     int ret;
>> +     struct mt_device *td;
>> +     struct mt_class *mtclass = mt_classes + id->driver_data;
>> +
>> +     /* This allows the driver to correctly support devices
>> +      * that emit events over several HID messages.
>> +      */
>> +     hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
>> +
>> +     td = kzalloc(sizeof(struct mt_device) +
>> +                             mtclass->maxcontacts * sizeof(struct mt_slot),
>> +                             GFP_KERNEL);
>> +     if (!td) {
>> +             dev_err(&hdev->dev, "cannot allocate multitouch data\n");
>> +             return -ENOMEM;
>> +     }
>> +     td->mtclass = mtclass;
>> +     td->inputmode = -1;
>> +     hid_set_drvdata(hdev, td);
>> +
>> +     ret = hid_parse(hdev);
>> +     if (ret != 0)
>> +             goto fail;
>> +
>> +     ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
>> +     if (ret != 0)
>> +             goto fail;
>> +
>> +     mt_set_input_mode(hdev);
>> +
>> +     return 0;
>> +
>> +fail:
>> +     kfree(td);
>> +     return ret;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +static int mt_reset_resume(struct hid_device *hdev)
>> +{
>> +     mt_set_input_mode(hdev);
>> +     return 0;
>> +}
>> +#endif
>> +
>> +static void mt_remove(struct hid_device *hdev)
>> +{
>> +     struct mt_device *td = hid_get_drvdata(hdev);
>> +     hid_hw_stop(hdev);
>> +     kfree(td);
>> +     hid_set_drvdata(hdev, NULL);
>> +}
>> +
>> +static const struct hid_device_id mt_devices[] = {
>> +
>> +     /* PixCir-based panels */
>> +     { .driver_data = MT_CLS_DUAL1,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_HANVON,
>> +                     USB_DEVICE_ID_HANVON_MULTITOUCH) },
>> +     { .driver_data = MT_CLS_DUAL1,
>> +             HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
>> +                     USB_DEVICE_ID_CANDO_PIXCIR_MULTI_TOUCH) },
>> +
>> +     { }
>> +};
>> +MODULE_DEVICE_TABLE(hid, mt_devices);
>> +
>> +static const struct hid_usage_id mt_grabbed_usages[] = {
>> +     { HID_ANY_ID, HID_ANY_ID, HID_ANY_ID },
>> +     { HID_ANY_ID - 1, HID_ANY_ID - 1, HID_ANY_ID - 1}
>> +};
>> +
>> +static struct hid_driver mt_driver = {
>> +     .name = "hid-multitouch",
>> +     .id_table = mt_devices,
>> +     .probe = mt_probe,
>> +     .remove = mt_remove,
>> +     .input_mapping = mt_input_mapping,
>> +     .input_mapped = mt_input_mapped,
>> +     .feature_mapping = mt_feature_mapping,
>> +     .usage_table = mt_grabbed_usages,
>> +     .event = mt_event,
>> +#ifdef CONFIG_PM
>> +     .reset_resume = mt_reset_resume,
>> +#endif
>> +};
>> +
>> +static int __init mt_init(void)
>> +{
>> +     return hid_register_driver(&mt_driver);
>> +}
>> +
>> +static void __exit mt_exit(void)
>> +{
>> +     hid_unregister_driver(&mt_driver);
>> +}
>> +
>> +module_init(mt_init);
>> +module_exit(mt_exit);
>> --
>> 1.7.3.4
>>
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

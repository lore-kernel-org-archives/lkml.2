Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab2APRaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:30:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63365 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab2APRaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:30:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120116145304.GA9828@polaris.bitmath.org>
References: <1326469531-26808-1-git-send-email-benjamin.tissoires@enac.fr>
	<20120116145304.GA9828@polaris.bitmath.org>
Date: Mon, 16 Jan 2012 18:30:01 +0100
X-Google-Sender-Auth: qb-OaqTttKzHmr5fOOSoS6yMqEE
Message-ID: <CAN+gG=EaZ3vzZh6CxRQgy4irRUkN4Fiv5_b0YR4hLq-3koQwRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] hid-multitouch: add support for trackpads
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

thanks for the review.

Comments in-lined:

On Mon, Jan 16, 2012 at 15:53, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> * some multitouch trackpads present the touch usage. This needs to be
>> filtered as it will conflict with mt-implementation.
>> * trackpads send BTN_TOOL_* to notify how many fingers are present
>> (this is used by xorg to use synaptics instead of generic evdev)
>> * trackpads like Perixx 701 are not different from a hid point of view
>> from a touchscreen, and we need to manually set them as touchpad.
>
> Missing subject line?

.... see the subject of the mail "[PATCH 1/2] hid-multitouch: add
support for trackpads"

we can eventually change it...



>
>> @@ -265,17 +266,31 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>  {
>>       struct mt_device *td = hid_get_drvdata(hdev);
>>       struct mt_class *cls = &td->mtclass;
>> +     int code;
>>
>>       /* Only map fields from TouchScreen or TouchPad collections.
>>           * We need to ignore fields that belong to other collections
>>           * such as Mouse that might have the same GenericDesktop usages. */
>>       if (field->application == HID_DG_TOUCHSCREEN)
>>               set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
>> -     else if (field->application == HID_DG_TOUCHPAD)
>> -             set_bit(INPUT_PROP_POINTER, hi->input->propbit);
>> -     else
>> +     else if (field->application != HID_DG_TOUCHPAD)
>>               return 0;
>>
>> +     /* In case of an indirect device (touchpad), we need to add
>> +      * specific BTN_TOOL_* to be handled by the synaptics xorg
>> +      * driver.
>> +      * We also consider that touchscreens providing buttons are touchpads.
>> +      */
>> +     if (field->application == HID_DG_TOUCHPAD ||
>> +         (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON ||
>> +         cls->is_indirect) {
>> +             set_bit(INPUT_PROP_POINTER, hi->input->propbit);
>> +             set_bit(BTN_TOOL_FINGER, hi->input->keybit);
>> +             set_bit(BTN_TOOL_DOUBLETAP, hi->input->keybit);
>> +             set_bit(BTN_TOOL_TRIPLETAP, hi->input->keybit);
>> +             set_bit(BTN_TOOL_QUADTAP, hi->input->keybit);
>> +     }
>> +
>>       /* eGalax devices provide a Digitizer.Stylus input which overrides
>>        * the correct Digitizers.Finger X/Y ranges.
>>        * Let's just ignore this input. */
>> @@ -389,9 +404,20 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>                               td->last_field_index = field->index;
>>                       return -1;
>>               }
>> +             case HID_DG_TOUCH:
>> +                     /* Legacy devices use TIPSWITCH and not TOUCH.
>> +                      * Let's just ignore this field. */
>> +                     return -1;
>>               /* let hid-input decide for the others */
>>               return 0;
>>
>> +     case HID_UP_BUTTON:
>> +             code = ((usage->hid - 1) & HID_USAGE);
>> +             code += BTN_MOUSE;
>
> Any reason not to write ((usage->hid - 1) & HID_USAGE) | BTN_MOUSE?

Just copy/paste from hid-input.c

but agree, this can be factorized.

I'll send a v2 with the next patch

Thanks,
Benjamin

>
>> +             hid_map_usage(hi, usage, bit, max, EV_KEY, code);
>> +             input_set_capability(hi->input, EV_KEY, code);
>> +             return 1;
>> +
>>       case 0xff000000:
>>               /* we do not want to map these: no input-oriented meaning */
>>               return -1;
>> @@ -453,6 +479,7 @@ static void mt_complete_slot(struct mt_device *td)
>>  static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>>  {
>>       int i;
>> +     int finger_count = 0;
>>
>>       for (i = 0; i < td->maxcontacts; ++i) {
>>               struct mt_slot *s = &(td->slots[i]);
>> @@ -477,12 +504,14 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>>                       input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>>                       input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
>>                       input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
>> +                     finger_count++;
>>               }
>>               s->seen_in_this_frame = false;
>>
>>       }
>>
>>       input_mt_report_pointer_emulation(input, true);
>> +     input_mt_report_finger_count(input, finger_count);
>>       input_sync(input);
>>       td->num_received = 0;
>>  }
>> @@ -538,6 +567,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>>                       if (value)
>>                               td->num_expected = value;
>>                       break;
>> +             case HID_DG_TOUCH:
>> +                     /* do nothing */
>> +                     break;
>>
>>               default:
>>                       /* fallback to the generic hidinput handling */
>> --
>> 1.7.4.4
>
> Looks good otherwise.
>
> Thanks,
> Henrik

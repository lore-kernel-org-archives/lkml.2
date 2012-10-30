Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318Ab2J3KyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:54:24 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:55367 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2J3KyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121029224331.GA15608@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
	<1351241067-9521-11-git-send-email-benjamin.tissoires@gmail.com>
	<20121029224331.GA15608@polaris.bitmath.org>
Date: Tue, 30 Oct 2012 11:54:20 +0100
Message-ID: <CAN+gG=G8F3m+UUDxm0qioipyMaAFHuQzKhmqn+-2qpGUGWwk6Q@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] HID: introduce Scan Time
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:43 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> Win 8 digitizer devices provides the actual scan time computed by the
>> hardware itself. The value is global to the frame and is not specific
>> to the multitouch protocol (though only touch, not pen, should use it
>> according to the specification).
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
>> ---
>>  Documentation/input/event-codes.txt |  7 +++++++
>>  drivers/hid/hid-input.c             |  4 ++++
>>  drivers/hid/hid-multitouch.c        | 11 +++++++++--
>>  include/linux/hid.h                 |  1 +
>>  include/linux/input.h               |  1 +
>>  5 files changed, 22 insertions(+), 2 deletions(-)
>
> This is a nice feature, useful in many other contexts. As such, I
> think it should be defined in the context of the input subsystem, with
> a more specific definition added to the documentation. For instance,
> is 100us suitable? When should it start at zero, at BTN_TOUCH? Or
> should it perhaps wrap around on unsigned integer instead? Or display
> the difference from the last event?

Well, the thing is that I didn't wanted to copy/paste win 8 definition
for ScanTime. So I put it with my words and not in a very
understandable way :)
This allows me to forward the incoming events without having to do
anything on them...

- 100us: suitable, not sure, but it would be good to define a standard
unit for time too
- start at zero at BTN_TOUCH: no. This information allows us to do
much better false release detection. If we reset this counter, then we
will loose the time between the two touch/release. The spec says that
it is up to the device to reset it after a period of time (not
defined, but can be one second for instance). Last, BTN_TOUCH is not
reliable for hovering devices because we will still get finger
information without BTN_TOUCH.
- difference from the last event: not sure how it is implemented in
windows, but I'm not sure it's a good way of doing if the gesture
engine needs the time from the beginning of the touch...

Anyway, I would be happy to have other comments/proposals for this event code.

>
>> diff --git a/Documentation/input/event-codes.txt b/Documentation/input/event-codes.txt
>> index 53305bd..8f8c908 100644
>> --- a/Documentation/input/event-codes.txt
>> +++ b/Documentation/input/event-codes.txt
>> @@ -174,6 +174,13 @@ A few EV_ABS codes have special meanings:
>>      the input device may be used freely in three dimensions, consider ABS_Z
>>      instead.
>>
>> +* ABS_SCAN_TIME:
>> +  - Used when the device provides a timestamp for each frame. The unit must be
>> +    100us, and may be reset when the device don't send any events for a
>> +    period of time. The values increment at each frame and thus, it can roll
>> +    back to 0 when reach logical_max. If the device does not provide this
>> +    information, the driver must not provide it to the user space.
>> +
>>  * ABS_MT_<name>:
>>    - Used to describe multitouch input events. Please see
>>      multi-touch-protocol.txt for details.
>> diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
>> index 16cc89a..5fe7bd3 100644
>> --- a/drivers/hid/hid-input.c
>> +++ b/drivers/hid/hid-input.c
>> @@ -675,6 +675,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
>>                       map_key_clear(BTN_STYLUS2);
>>                       break;
>>
>> +             case 0x56: /* Scan Time */
>> +                     map_abs(ABS_SCAN_TIME);
>> +                     break;
>> +
>
> Is it not enough to map it in the case below? Or you mean this is
> picked up by hid core?
>

in hidinput_configure_usage, it's enough to just map it.

In hid-multitouch, We also just need to map it, and it will be handled
by hid-core in the .event callback.

Cheers,
Benjamin

>>               default:  goto unknown;
>>               }
>>               break;
>> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
>> index c0ab1c6..21a120b 100644
>> --- a/drivers/hid/hid-multitouch.c
>> +++ b/drivers/hid/hid-multitouch.c
>> @@ -447,12 +447,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>>                       mt_store_field(usage, td, hi);
>>                       td->last_field_index = field->index;
>>                       return 1;
>> +             case HID_DG_SCANTIME:
>> +                     hid_map_usage(hi, usage, bit, max,
>> +                             EV_ABS, ABS_SCAN_TIME);
>> +                     set_abs(hi->input, ABS_SCAN_TIME, field, 0);
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
>>               case HID_DG_TOUCH:
>> diff --git a/include/linux/hid.h b/include/linux/hid.h
>> index 6216529..99a6418 100644
>> --- a/include/linux/hid.h
>> +++ b/include/linux/hid.h
>> @@ -279,6 +279,7 @@ struct hid_item {
>>  #define HID_DG_DEVICEINDEX   0x000d0053
>>  #define HID_DG_CONTACTCOUNT  0x000d0054
>>  #define HID_DG_CONTACTMAX    0x000d0055
>> +#define HID_DG_SCANTIME              0x000d0056
>>
>>  /*
>>   * HID report types --- Ouch! HID spec says 1 2 3!
>> diff --git a/include/linux/input.h b/include/linux/input.h
>> index ba48743..73c3a96 100644
>> --- a/include/linux/input.h
>> +++ b/include/linux/input.h
>> @@ -796,6 +796,7 @@ struct input_keymap_entry {
>>  #define ABS_TILT_X           0x1a
>>  #define ABS_TILT_Y           0x1b
>>  #define ABS_TOOL_WIDTH               0x1c
>> +#define ABS_SCAN_TIME                0x1d
>>
>>  #define ABS_VOLUME           0x20
>>
>> --
>> 1.7.11.7
>>
>
> Thanks,
> Henrik

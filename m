Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2EUQnc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 12:43:32 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61323 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab2EUQna convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 12:43:30 -0400
MIME-Version: 1.0
In-Reply-To: <6008DE3C35C7C04D85C2A4C813D36515481E5D29@ORSMSX101.amr.corp.intel.com>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
	<1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com>
	<20120506190146.GA12571@polaris.bitmath.org>
	<CAN+gG=G9y_0Le-Mja2z68r76nBmz0De95Lc6671EkrrMZRSEHw@mail.gmail.com>
	<6008DE3C35C7C04D85C2A4C813D36515481E5D29@ORSMSX101.amr.corp.intel.com>
Date: Mon, 21 May 2012 18:43:29 +0200
Message-ID: <CAN+gG=G4+Jbcw_KBeV=tVsXaqG--acioA9y2x4YgUsVrmcEwfw@mail.gmail.com>
Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "Drews, Paul" <paul.drews@intel.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Fri, May 18, 2012 at 11:14 PM, Drews, Paul <paul.drews@intel.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Benjamin Tissoires
>> Sent: Wednesday, May 09, 2012 12:04 PM
>> To: Henrik Rydberg
>> Cc: Dmitry Torokhov; Jiri Kosina; Stephane Chatty; linux-input@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
>>
>
>> On Sun, May 6, 2012 at 9:01 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Hi Benjamin,
>> >
>> >> The previous implementation introduced a randomness in the splitting
>> >> of the different touches reported by the device. This version is more
>> >> robust as we don't rely on hi->input->absbit, but on our own structure.
>> >>
>
>> >> +
>> >>  struct mt_device {
>> >>       struct mt_slot curdata; /* placeholder of incoming data */
>> >>       struct mt_class mtclass;        /* our mt device class */
>> >> +     struct mt_fields *fields;       /* temporary placeholder for storing the
>> >> +                                        multitouch fields */
>> >
>> > Why not skip the pointer here?
>>
>> well, the idea was to keep the memory footprint low. As these values
>> are only needed at init, then I freed them once I finished using them.
>> I can of course skip the pointer, but in that case, wouldn't the
>> struct declaration be worthless?
>>
>> >
>
>> >>
>> >> +static void mt_post_parse(struct mt_device *td)
>> >> +{
>> >> +     struct mt_fields *f = td->fields;
>> >> +
>> >> +     if (td->touches_by_report > 0) {
>> >> +             int field_count_per_touch = f->length / td->touches_by_report;
>> >> +             td->last_slot_field = f->usages[field_count_per_touch - 1]->hid;
>> >> +     }
>> >> +}
>> >> +
>
> It sounds as though:
>
> () Reviewers are a little uncomfortable with the memory footprint and
>    allocation/free
> () The patch as it stands relies on the pattern of "usage" values repeating
>    for each touch, and deeming the last one in the repetition pattern to
>    be the last-slot-field marker.
>
> If this is the case, how about avoiding storing all the slot-field values
> and just detecting the point of repetition to use the most-recently-seen
> usage value as the last-slot-field marker.  I have been successfully using
> the patch below based on this notion.  It took the failure rate from about
> 1-per-10 boots to 250+ boots with no failures on an Atmel MaXTouch.
> I don't have others to try it with, including the "buggy" one that led
> to all this trouble in the first place.

Thank you very much for this patch. However, Jiri already applied mine
with the allocation/free mechanism.

You're idea is good but it has one big problem with Win8 devices:
As we can have 2 X and 2 Y per touch report, if these dual-X reporting
or dual-Y reporting is present in the report, we will stop at the
second X or the second Y seen, which will lead to a buggy touchscreen
(the first touch won't get it's second coordinate). However, without
this particularity, the patch would have worked ;-)

If the Win8 norm has came earlier, the initial implementation that
relies on the collection would have suffice, but some hardware makers
made a bad use of it, leading us to stop using this, and relying on a
more brutal approach.

I found a little problem in the patch too:

>
> Patch follows:
> ==========================================================
> From 242f6773babe0fc0215764abbeeeff6510f3ca92 Mon Sep 17 00:00:00 2001
> From: Paul Drews <paul.drews@intel.com>
> Date: Wed, 16 May 2012 11:15:00 -0700
> Subject: [PATCH] Repair detection of last slot in multitouch reports
>
> The logic for detecting the last per-touch slot in a
> multitouch report erroneously used hid usage values (large
> numbers such as 0xd0032) as indices into the smaller absbit
> bitmap (with bit indexes up to 0x3f).  This caused
> intermittent failures in the configuration of the last-slot
> value leading to stale x,y coordinates being reported in
> multi-touch input events.  It also carried the risk of a
> segmentation fault due to the out-of-range bitmap index.
>
> This patch takes a different approach of detecting the last
> per-touch slot:  when the hid usage value wraps around to
> the first hid usage value we have seen already, we must be
> looking at the slots for the next touch of a multi-touch
> report, so the last hid usage value we have seen so far must
> be the last per-touch value.
>
> Issue: AIA-446
> Change-Id: Ic1872998502874298bb60705df9bd2fc70de1738
> Signed-off-by: Paul Drews <paul.drews@intel.com>
> ---
>  drivers/hid/hid-multitouch.c |   39 ++++++++++++++++++++++++++-------------
>  1 files changed, 26 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 2e6d187..226f828 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -75,6 +75,9 @@ struct mt_device {
>        struct mt_class mtclass;        /* our mt device class */
>        unsigned last_field_index;      /* last field index of the report */
>        unsigned last_slot_field;       /* the last field of a slot */
> +       bool last_slot_field_found;     /* last_slot_field has full init */
> +       unsigned first_slot_field;
> +       bool first_slot_field_found;    /* for detecting wrap to next touch */
>        __s8 inputmode;         /* InputMode HID feature, -1 if non-existent */
>        __s8 maxcontact_report_id;      /* Maximum Contact Number HID feature,
>                                   -1 if non-existent */
> @@ -275,11 +278,21 @@ static void set_abs(struct input_dev *input, unsigned int code,
>        input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
>  }
>
> -static void set_last_slot_field(struct hid_usage *usage, struct mt_device *td,
> -               struct hid_input *hi)
> +static void update_last_slot_field(struct hid_usage *usage,
> +               struct mt_device *td)
>  {
> -       if (!test_bit(usage->hid, hi->input->absbit))
> -               td->last_slot_field = usage->hid;
> +       if (!td->last_slot_field_found) {
> +               if (td->first_slot_field_found) {
> +                       if (td->last_slot_field == usage->hid)

I'm sure you wanted to put here:
                       if (td->first_slot_field == usage->hid)

Cheers,
Benjamin

> +                               td->last_slot_field_found = true; /* wrapped */
> +                       else
> +                               td->last_slot_field = usage->hid;
> +               } else {
> +                       td->first_slot_field = usage->hid;
> +                       td->first_slot_field_found = true;
> +                       td->last_slot_field = usage->hid;
> +               }
> +       }
>  }
>
>  static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> @@ -340,7 +353,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                                cls->sn_move);
>                        /* touchscreen emulation */
>                        set_abs(hi->input, ABS_X, field, cls->sn_move);
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_GD_Y:
> @@ -350,7 +363,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                                cls->sn_move);
>                        /* touchscreen emulation */
>                        set_abs(hi->input, ABS_Y, field, cls->sn_move);
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                }
> @@ -359,24 +372,24 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>        case HID_UP_DIGITIZER:
>                switch (usage->hid) {
>                case HID_DG_INRANGE:
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_DG_CONFIDENCE:
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_DG_TIPSWITCH:
>                        hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
>                        input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_DG_CONTACTID:
>                        if (!td->maxcontacts)
>                                td->maxcontacts = MT_DEFAULT_MAXCONTACT;
>                        input_mt_init_slots(hi->input, td->maxcontacts);
> -                       td->last_slot_field = usage->hid;
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        td->touches_by_report++;
>                        return 1;
> @@ -385,7 +398,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                                        EV_ABS, ABS_MT_TOUCH_MAJOR);
>                        set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
>                                cls->sn_width);
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_DG_HEIGHT:
> @@ -395,7 +408,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                                cls->sn_height);
>                        input_set_abs_params(hi->input,
>                                        ABS_MT_ORIENTATION, 0, 1, 0, 0);
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_DG_TIPPRESSURE:
> @@ -406,7 +419,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                        /* touchscreen emulation */
>                        set_abs(hi->input, ABS_PRESSURE, field,
>                                cls->sn_pressure);
> -                       set_last_slot_field(usage, td, hi);
> +                       update_last_slot_field(usage, td);
>                        td->last_field_index = field->index;
>                        return 1;
>                case HID_DG_CONTACTCOUNT:
> --
> 1.7.3.4
> ==========================================================

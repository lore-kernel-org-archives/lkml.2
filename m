Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab2HTNgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:36:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42048 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab2HTNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <1344807757-2217-20-git-send-email-rydberg@euromail.se>
References: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
	<1344807757-2217-20-git-send-email-rydberg@euromail.se>
Date: Mon, 20 Aug 2012 15:36:31 +0200
X-Google-Sender-Auth: hDM9zslubg262K6hXG3ppLgMtSc
Message-ID: <CAN+gG=F6hhOxU--mF2v3sCTzFLHqd6vK5JqcvvDXigss7EkPHQ@mail.gmail.com>
Subject: Re: [PATCH 19/19] HID: multitouch: Remove the redundant touch state
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrik,

On Sun, Aug 12, 2012 at 11:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> With the input_mt_sync_frame() function in place, there is no longer
> any need to keep the full touch state in the driver. This patch
> removes the slot state and replaces the lookup code with the input-mt
> equivalent. The initialization code is moved to mt_input_configured(),
> to make sure the full HID report has been seen.

This patch seems to be a little bit complex.
It has very good things, but also many things that hinders the readability.

And you should also remove the /* touchscreen emulation */ things in
mt_input_mapping as input_mt_init_slots handles now the init of ABS_X
ABS_Y and ABS_PRESSURE.

>
> Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-multitouch.c | 162 ++++++++++++++++++-------------------------
>  1 file changed, 66 insertions(+), 96 deletions(-)
>
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index b15133c..bd4bc3c 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -52,13 +52,6 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_VALID_IS_CONFIDENCE   (1 << 6)
>  #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE   (1 << 8)
>
> -struct mt_slot {
> -       __s32 x, y, p, w, h;
> -       __s32 contactid;        /* the device ContactID assigned to this slot */
> -       bool touch_state;       /* is the touch valid? */
> -       bool seen_in_this_frame;/* has this slot been updated */
> -};

Why removing this struct?
Removing it infers a lot of unneeded changes in the patch.

As the mt_sync_frame handle the quirk NOT_SEEN_MEANS_UP, we should
just remove the field seen_in_this_frame.

> -
>  struct mt_class {
>         __s32 name;     /* MT_CLS */
>         __s32 quirks;
> @@ -76,7 +69,6 @@ struct mt_fields {
>  };
>
>  struct mt_device {
> -       struct mt_slot curdata; /* placeholder of incoming data */
>         struct mt_class mtclass;        /* our mt device class */
>         struct mt_fields *fields;       /* temporary placeholder for storing the
>                                            multitouch fields */
> @@ -93,7 +85,9 @@ struct mt_device {
>                                 * 1 means we should use a serial protocol
>                                 * > 1 means hybrid (multitouch) protocol */
>         bool curvalid;          /* is the current contact valid? */
> -       struct mt_slot *slots;
> +       __s32 x, y, p, w, h;
> +       __s32 contactid;        /* the device ContactID assigned to this slot */
> +       bool touch_state;       /* is the touch valid? */

Again, by keeping the first field, you don't lose any memory and
things are packed and organized!
(having x, y, etc... at the root of the device struct is kind of weird...)

>  };
>
>  /* classes of device behavior */
> @@ -128,31 +122,12 @@ struct mt_device {
>
>  static int cypress_compute_slot(struct mt_device *td)
>  {
> -       if (td->curdata.contactid != 0 || td->num_received == 0)
> -               return td->curdata.contactid;
> +       if (td->contactid != 0 || td->num_received == 0)
> +               return td->contactid;

This patch contains many unneeded modifications of this type.... :-(

>         else
>                 return -1;
>  }
>
> -static int find_slot_from_contactid(struct mt_device *td)
> -{
> -       int i;
> -       for (i = 0; i < td->maxcontacts; ++i) {
> -               if (td->slots[i].contactid == td->curdata.contactid &&
> -                       td->slots[i].touch_state)
> -                       return i;
> -       }
> -       for (i = 0; i < td->maxcontacts; ++i) {
> -               if (!td->slots[i].seen_in_this_frame &&
> -                       !td->slots[i].touch_state)
> -                       return i;
> -       }
> -       /* should not occurs. If this happens that means
> -        * that the device sent more touches that it says
> -        * in the report descriptor. It is ignored then. */
> -       return -1;
> -}
> -

I'm always happy to remove code.... ;-)

>  static struct mt_class mt_classes[] = {
>         { .name = MT_CLS_DEFAULT,
>                 .quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
> @@ -390,7 +365,6 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>                 case HID_DG_CONTACTID:
>                         if (!td->maxcontacts)
>                                 td->maxcontacts = MT_DEFAULT_MAXCONTACT;
> -                       input_mt_init_slots(hi->input, td->maxcontacts, 0);

this thing was worrying me, so it's better this way.

>                         mt_store_field(usage, td, hi);
>                         td->last_field_index = field->index;
>                         td->touches_by_report++;
> @@ -464,12 +438,31 @@ static int mt_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>         return -1;
>  }
>
> -static int mt_compute_slot(struct mt_device *td)
> +static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
> +
> +{
> +       struct mt_device *td = hid_get_drvdata(hdev);
> +       struct mt_class *cls = &td->mtclass;
> +       struct input_dev *input = hi->input;
> +       unsigned int flags = 0;
> +
> +       if (test_bit(INPUT_PROP_POINTER, input->propbit))
> +               flags |= INPUT_MT_POINTER;
> +       if (test_bit(INPUT_PROP_DIRECT, input->propbit))
> +               flags |= INPUT_MT_DIRECT;

These two tests are really strange: the function input_mt_init_slots
already sets those bits....
Maybe we should handle INPUT_PROP_POINTER, INPUT_PROP_DIRECT by
keeping the flag instead of setting the bits and re-read them to
finally re-set them...

And yes, I know that input_mt_init_slots does a lot more than just
setting those two bits, but it's the impression I feel when reading
this.

Anyway, besides this things, I'm happy with the input_configured callback.

> +
> +       if (cls->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
> +               flags |= INPUT_MT_DROP_UNUSED;
> +
> +       input_mt_init_slots(input, td->maxcontacts, flags);
> +}
> +
> +static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
>  {
>         __s32 quirks = td->mtclass.quirks;
>
>         if (quirks & MT_QUIRK_SLOT_IS_CONTACTID)
> -               return td->curdata.contactid;
> +               return td->contactid;
>
>         if (quirks & MT_QUIRK_CYPRESS)
>                 return cypress_compute_slot(td);
> @@ -478,25 +471,43 @@ static int mt_compute_slot(struct mt_device *td)
>                 return td->num_received;
>
>         if (quirks & MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE)
> -               return td->curdata.contactid - 1;
> +               return td->contactid - 1;
>
> -       return find_slot_from_contactid(td);
> +       return input_mt_assign_slot_by_id(input, td->contactid);
>  }
>
>  /*
>   * this function is called when a whole contact has been processed,
>   * so that it can assign it to a slot and store the data there
>   */
> -static void mt_complete_slot(struct mt_device *td)
> +static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  {
> -       td->curdata.seen_in_this_frame = true;
> -       if (td->curvalid) {
> -               int slotnum = mt_compute_slot(td);
> +       int slot;
>
> -               if (slotnum >= 0 && slotnum < td->maxcontacts)
> -                       td->slots[slotnum] = td->curdata;
> -       }
>         td->num_received++;
> +       if (!td->curvalid)
> +               return;
> +
> +       slot = mt_compute_slot(td, input);
> +       if (slot < 0 || slot >= td->maxcontacts)
> +               return;
> +
> +       input_mt_slot(input, slot);
> +       input_mt_report_slot_state(input, MT_TOOL_FINGER, td->touch_state);
> +       if (td->touch_state) {
> +               /* this finger is on the screen */
> +               int wide = (td->w > td->h);
> +               /* divided by two to match visual scale of touch */
> +               int major = max(td->w, td->h) >> 1;
> +               int minor = min(td->w, td->h) >> 1;
> +
> +               input_event(input, EV_ABS, ABS_MT_POSITION_X, td->x);
> +               input_event(input, EV_ABS, ABS_MT_POSITION_Y, td->y);
> +               input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
> +               input_event(input, EV_ABS, ABS_MT_PRESSURE, td->p);
> +               input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> +               input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
> +       }
>  }
>
>
> @@ -504,52 +515,20 @@ static void mt_complete_slot(struct mt_device *td)
>   * this function is called when a whole packet has been received and processed,
>   * so that it can decide what to send to the input layer.
>   */
> -static void mt_emit_event(struct mt_device *td, struct input_dev *input)
> +static void mt_sync_frame(struct mt_device *td, struct input_dev *input)
>  {
> -       int i;
> -
> -       for (i = 0; i < td->maxcontacts; ++i) {
> -               struct mt_slot *s = &(td->slots[i]);
> -               if ((td->mtclass.quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
> -                       !s->seen_in_this_frame) {
> -                       s->touch_state = false;
> -               }
> -
> -               input_mt_slot(input, i);
> -               input_mt_report_slot_state(input, MT_TOOL_FINGER,
> -                       s->touch_state);
> -               if (s->touch_state) {
> -                       /* this finger is on the screen */
> -                       int wide = (s->w > s->h);
> -                       /* divided by two to match visual scale of touch */
> -                       int major = max(s->w, s->h) >> 1;
> -                       int minor = min(s->w, s->h) >> 1;
> -
> -                       input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
> -                       input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
> -                       input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
> -                       input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
> -                       input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> -                       input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
> -               }
> -               s->seen_in_this_frame = false;
> -
> -       }
> -
> -       input_mt_report_pointer_emulation(input, true);
> +       input_mt_sync_frame(input);
>         input_sync(input);
>         td->num_received = 0;
>  }
>
> -
> -
>  static int mt_event(struct hid_device *hid, struct hid_field *field,
>                                 struct hid_usage *usage, __s32 value)
>  {
>         struct mt_device *td = hid_get_drvdata(hid);
>         __s32 quirks = td->mtclass.quirks;
>
> -       if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {
> +       if (hid->claimed & HID_CLAIMED_INPUT) {

the "td->slots" test was ugly ;-)

Thanks,
Benjamin

>                 switch (usage->hid) {
>                 case HID_DG_INRANGE:
>                         if (quirks & MT_QUIRK_ALWAYS_VALID)
> @@ -560,29 +539,29 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>                 case HID_DG_TIPSWITCH:
>                         if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
>                                 td->curvalid = value;
> -                       td->curdata.touch_state = value;
> +                       td->touch_state = value;
>                         break;
>                 case HID_DG_CONFIDENCE:
>                         if (quirks & MT_QUIRK_VALID_IS_CONFIDENCE)
>                                 td->curvalid = value;
>                         break;
>                 case HID_DG_CONTACTID:
> -                       td->curdata.contactid = value;
> +                       td->contactid = value;
>                         break;
>                 case HID_DG_TIPPRESSURE:
> -                       td->curdata.p = value;
> +                       td->p = value;
>                         break;
>                 case HID_GD_X:
> -                       td->curdata.x = value;
> +                       td->x = value;
>                         break;
>                 case HID_GD_Y:
> -                       td->curdata.y = value;
> +                       td->y = value;
>                         break;
>                 case HID_DG_WIDTH:
> -                       td->curdata.w = value;
> +                       td->w = value;
>                         break;
>                 case HID_DG_HEIGHT:
> -                       td->curdata.h = value;
> +                       td->h = value;
>                         break;
>                 case HID_DG_CONTACTCOUNT:
>                         /*
> @@ -602,11 +581,11 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>                 }
>
>                 if (usage->hid == td->last_slot_field)
> -                       mt_complete_slot(td);
> +                       mt_complete_slot(td, field->hidinput->input);
>
>                 if (field->index == td->last_field_index
>                         && td->num_received >= td->num_expected)
> -                       mt_emit_event(td, field->hidinput->input);
> +                       mt_sync_frame(td, field->hidinput->input);
>
>         }
>
> @@ -733,15 +712,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>         if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
>                 mt_post_parse_default_settings(td);
>
> -       td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
> -                               GFP_KERNEL);
> -       if (!td->slots) {
> -               dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
> -               hid_hw_stop(hdev);
> -               ret = -ENOMEM;
> -               goto fail;
> -       }
> -
>         ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
>
>         mt_set_maxcontacts(hdev);
> @@ -772,7 +742,6 @@ static void mt_remove(struct hid_device *hdev)
>         struct mt_device *td = hid_get_drvdata(hdev);
>         sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
>         hid_hw_stop(hdev);
> -       kfree(td->slots);
>         kfree(td);
>         hid_set_drvdata(hdev, NULL);
>  }
> @@ -1085,6 +1054,7 @@ static struct hid_driver mt_driver = {
>         .remove = mt_remove,
>         .input_mapping = mt_input_mapping,
>         .input_mapped = mt_input_mapped,
> +       .input_configured = mt_input_configured,
>         .feature_mapping = mt_feature_mapping,
>         .usage_table = mt_grabbed_usages,
>         .event = mt_event,
> --
> 1.7.11.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AGPM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:12:29 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48823 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab1AGPM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=bThxfMOppxOXmERR1t8VardM5OBBdryFADHEwFYN/HW3cNiu/ayJkojQSNzXw7Lq4+
         H+TS5X4A2yaVJxIICtPFanZXskNVbdRTOJquKB5uK2IgjOk82nARGu88k7ausVtiEHkh
         vWtwJFURFsLKIhrYooo/4RuN8iWx+xvZjdPUs=
MIME-Version: 1.0
In-Reply-To: <20110107122338.GB2312@polaris.bitmath.org>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
	<1294248468-19979-4-git-send-email-benjamin.tissoires@enac.fr>
	<20110106172528.GD1790@polaris.bitmath.org>
	<AANLkTimhk80b+jkqsNrxmFzSgmHX=_wdzbwE09NoFgV1@mail.gmail.com>
	<20110107122338.GB2312@polaris.bitmath.org>
Date: Fri, 7 Jan 2011 16:12:24 +0100
X-Google-Sender-Auth: 1Z3DIHV2uS7fRjjByU79lD-ApNw
Message-ID: <AANLkTimYaZcvLyijtEm-iu+PzNXdozcNbFJQ6+PzD4vK@mail.gmail.com>
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

Hi Henrik,

I've made the changes and I pushed them on the git of our lab. I
thought it was easier for you to have a look at the changes instead of
resending the whole patch. But v3 will be for this afternoon.

the repo is at:
http://lii-enac.fr/cgi-bin/gitweb.cgi?p=linux-input/enac-drivers.git;a=summary
the changes are on the branch "hid-multitouch-dtor" from "Copyright
notice" to the head ("hid-input: better way of handling
HID_FEATURE_REPORT").

To summarize:

- I used touch_state and seen_in_this_frame -> I hope the semantic is
now clearer. I was able to test it on stantum and cypress device. I
should do the test for pixcir as soon as I can have some time in the
afternoon, and the test against generaltouch should happend in the
beginning of the week.

- I integrated fuzz (please check)

- I re-factorized set_abs (just copied-pasted your code)

- I made other small changes

- Concerning the quirks, I am not very in favor ATM: a flag for
compute slot will infer a switch of 5 cases in the emit_event, and the
idea was to be able to have a constant time access (1) when using
specific function.
The Quirk MT_QUIRK_NOT_SEEN_MEANS_UP is better (it will speed up a
little the code: 1 test against 1 test and 1 affectation) but I don't
think it worse the effort for further device additions.

- The Egalax problem: I am pretty sure that Stéphane took this driver
into account when writing the original patch. BTW I propose to
postpone the problem for 2.6.39.

Cheers,
Benjamin

On Fri, Jan 7, 2011 at 1:23 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Please provide a bit more information under this config option. The
>> > usual "what should I do", and roughly what devices are supported.
>>
>> Will try, but don't hesitate to send one if you feel in a good mood for writing.
>>
>> I can propose:
>>
>> +        ---help---
>> +          Generic support for HID multitouch panels.
>> +          Currently supported panels are:
>> +          - PixCir touchscreen
>> +          - Cypress TrueTouch
>> +          - 'Sensing Win7-TwoFinger' panel by GeneralTouch
>
> This is fine, but needs the "to compile as a module" etc, examples are
> all around the Kconfig file.
>
>> >> +struct mt_slot {
>> >> +     __s32 x, y, p;
>> >> +     __s32 contactid;        /* the device ContactID assigned to this slot */
>> >> +     __u16 trkid;    /* the tracking ID that was assigned to this slot */
>> >> +     bool valid;     /* did we just get valid contact data for this slot? */
>> >> +     bool prev_valid;/* was this slot previously valid/active? */
>> >> +};
>> >
>> > The trkid and prev_valid are no longer needed. The touch state seems to be missing.
>>
>> Concerning the trkid, agree.
>> I can assure you that prev_valid is needed by at least the Cypress
>> device. In a sense, it has the same problem than mt protocol A: it
>> does not send the release information except when the last finger has
>> been released. This gymnastic is thus required.
>
> Perhaps I did not explain properly. What is needed is a way to clear
> the touch state of the active slots not yet seen in a touch
> frame. Because of the mixup of semantics around "valid" and "touch",
> it looks more complicated than it really is. My point is that the
> previous frame has nothing to do with it.
>
>>
>> I think that the misunderstanding comes from the name. We have this 2
>> flags (valid and prev_valid) to tell whether the device sent data
>> during this report or the previous one. It's not the same meaning that
>> the touch you're talking about. For Cypress device, those 2 flags are
>> mandatory.
>
> The names are indeed confusing. A valid packet means the incoming
> packet contains information about a slot, and brings updates to the
> touch state and the touch properties. The touch state just needs to be
> set, it is the same logic everytime.
>
>>
>> Maybe introducing data + prev_data + touch (3 flags instead of 2->
>> touch can go into mt_buffer, and data and prev_data only in mt_slot as
>> they are not given by the device) is clearer.
>
> This would be unnecessarily complicated. Either (touch_state,
> seen_in_this_frame), or (touch_state,
> last_frame_revision_of_this_slot) would be enough.
>
>>
>> >
>> >> +
>> >> +struct mt_buffer {
>> >> +     __s32 x, y, p;
>> >> +     __s32 contactid;        /* the device ContactID assigned to this slot */
>> >> +};
>> >
>> > The only different to mt_slot are the valid and touch field, which is
>> > also needed for incoming data. I'd say those should be merged.
>> >
>>
>> Well, the point is that the buffer and the slot have 2 different meanings:
>> one is the incoming data, the other is the processed data. It strikes
>> us to have only one struct as the slot contains extra information for
>> it to be processed.
>
> This is not true. The data that comes via a valid packet is the touch
> state and the property updates, the rest is about handling the
> validity. But let's say you use (touch, revision, props), for
> instance.  The incoming valid packet would update curdata.touch and
> curdata.props. When the slot is finished, curdata is copied to the
> right place. At the end of the frame, a device with the
> slots-not-send-in-this-frame-are-considered-unused quirk would reset
> the touch of the slots with slot[i].revision !=
> curdata.revision. Finally, curdata.revision would be incremented.
>
>> >
>> >> +     __s8 inputmode;         /* InputMode HID feature, -1 if non-existent */
>> >> +     __u8 num_received;      /* how many contacts we received */
>> >> +     __u8 maxcontact;        /* expected last contact index */
>> >> +     bool curvalid;          /* is the current contact valid? */
>> >
>> > This value should probably be a mt_slot struct as well.
>>
>> I was bothering too. Renaming the field (see above) may solve the
>> problem: we have curvalid (or curdata with the name I propose) which
>> is only needed for algorithm reasons, and touch that goes into
>> mt_buffer as it comes from the device.
>
> Looking again, it seems to me that curvalid should really be where it
> is now.
>
>> >
>> >> +     struct mt_slot slots[0];        /* first slot */
>> >> +};
>> >> +
>> >> +struct mt_class {
>> >> +     int (*compute_slot)(struct mt_device *);
>> >> +     __u8 maxcontacts;
>> >> +};
>> >
>> > I imagine maxcontacts could be variable for devices within the same
>> > class. Perhaps it should be a member of the device instead? The
>> > resolution and fuzz could be added here as well.
>>
>> resolution and fuzz: I let you implement it (when adding egalax or
>> 3m). But isn't it something we can't get from the report descriptors?
>
> Resolution, yes, but defaults might still be needed. And maybe
> compute_slot should be a bitmask of quirks instead. So far we would
> have MT_QUIRK_SLOT_IS_CONTACTID and MT_QUIRK_NOT_SEEN_MEANS_UP.
>
>> concerning the device vs. class, currently, we have only seen classes
>> (one or more device sharing the same behavior), but we didn't bother
>> about resolution and fuzz.
>> It would be a shame to have to duplicate the mt_class (or mt_device),
>> one by vendorID/deviceID, as many devices may share the same
>> properties (at least those that have been manufactured by the same
>> company and that behave the same way: cando, stantum, etc...).
>> I also like the concept of default class as it will help people easily
>> adding devices.
>
> The statement comes from observing what seems to happen over time with
> device lists, but sure, it won't really hurt to have the classes.
>
>> >
>> >> +
>> >> +/* classes of device behavior */
>> >> +#define MT_CLS_DEFAULT 0
>> >> +#define MT_CLS_DUAL1 1
>> >> +
>> >> +/*
>> >> + * these device-dependent functions determine what slot corresponds
>> >> + * to a valid contact that was just read.
>> >> + */
>> >> +
>> >> +static int slot_is_contactid(struct mt_device *td)
>> >> +{
>> >> +     return td->curdata.contactid;
>> >> +}
>> >> +
>> >> +static int find_slot_from_contactid(struct mt_device *td)
>> >> +{
>> >> +     int i;
>> >> +     for (i = 0; i < td->mtclass->maxcontacts; ++i) {
>> >> +             if (td->slots[i].prev_valid &&
>> >
>> > Why prev_valid? Ought to be valid, right?
>>
>> Because the code resets valid after each sending -> implementation dependent.
>
> The prev_valid and valid are only different because prev_valid is used
> with touch semantics, whereas valid is not and is reset at each frame
> emission. Once we stop mixing fruits, it will all become clear and
> simple.
>
>> > Nice solution to the end-of-data issue. It would be good if the input
>> > setup was abstracted into a function like in hid-egalax, to simplify
>> > further additions.
>>
>> thanks.
>> I was not very happy in making this abstraction for just one line of
>> code. I thought you could do it when adding the additions.
>
> Or you could do it right away - it will simplify the existing
> patch, and make subsequent patches simpler as well.
>
>> >
>> >> +                             input_mt_init_slots(hi->input,
>> >> +                                             td->mtclass->maxcontacts);
>> >
>> > Maxcontacts should probably take the hid description into account as well.
>>
>> I don't understand your point here
>
> Take 3M as an example. The controller supports up to 60 contacts, but
> different devices may not be needing that many. Having a way to trim
> the number of allocated slots to just the right size for the current
> devices seems like a good idea.
>
>> >
>> > And ABS_PRESSURE.
>>
>> I thought that the mouse emulation was restricted to X and Y.
>
> Look at the psmouse, wacom and generic MT emulation code for counter examples.
>
>> > There are some hid drivers that need to setup fuzz in order to work
>> > properly. We should either add it to hid core or use the same bypass as
>> > in hid-egalax and hid-3m-pct.
>>
>> Can I let you do this in further updates? (for the new devices and
>> those I sent, this works out of the box)
>
> Why not do it right away? It is quite simple, and mostly copy and
> paste from those drivers.
>
>> >> +/*
>> >> + * this function is called when a whole packet has been received and processed,
>> >> + * so that it can decide what to send to the input layer.
>> >> + */
>> >> +static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>> >> +{
>> >> +     int i;
>> >> +
>> >> +     for (i = 0; i < td->mtclass->maxcontacts; ++i) {
>> >> +             struct mt_slot *s = &(td->slots[i]);
>> >> +             if (!s->valid) {
>> >> +                     /*
>> >> +                      * this slot does not contain useful data,
>> >> +                      * notify its closure if necessary
>> >> +                      */
>> >> +                     if (s->prev_valid) {
>> >> +                             input_mt_slot(input, i);
>> >> +                             input_mt_report_slot_state(input,
>> >> +                                     MT_TOOL_FINGER, false);
>> >> +                             s->prev_valid = false;
>> >> +                     }
>
> This code will have exactly the same result without the "if
> (s->prev_valid)", since prev_valid is a copy of the last touch
> state. The input core will filter away any duplicate calls. Thus, it
> can all be replaced by
>
> input_mt_slot(input, i);
> input_mt_report_slot_state(input, MT_TOOL_FINGER, s->valid);
>
> Further assuming that valid will change to touch, it is all starting
> to look conceptually correct. We could then prepend this line
>
> if ((device_quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) && s->revision != curdata.revision)
>    s->state = false;
>
> and we would have support for the devices you mention.
>
>> >> +                     continue;
>> >> +             }
>> >> +             if (!s->prev_valid)
>> >> +                     s->trkid = td->lasttrkid++;
>> >
>> > Most of the above can be removed.
>>
>> Cypress device does not sends touch information when a touch is
>> released. This piece of code is required for devices that behave the
>> same way.
>
> See the above example.
>
>> >
>> >> +
>> >> +             input_mt_slot(input, i);
>> >> +             input_mt_report_slot_state(input, MT_TOOL_FINGER, true);
>> >
>> > "true" here should simply be slot->touch state.
>> >
>> >> +             input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
>> >> +             input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
>> >> +             input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>> >> +             s->prev_valid = true;
>> >> +             s->valid = false;
>> >
>> > Invalidating the data of a tracked slots seems wrong. If the device
>> > sends tracked data properly, no special consideration is needed - it
>> > will get cleared when appropriate. Other cases could be dealt with
>> > separately.
>>
>> already discussed (pb in naming the fields I think)
>
> The egalax driver has a different behavior, for instance.
>
>> >> +             case HID_DG_TIPSWITCH:
>> >> +                     td->curvalid = value;
>> >
>> > Most drivers seem to use this as touch state.
>>
>> agree and that is how it is used in the current implementation. We
>> really should change the name.
>
> I believe the curvalid is fine, but it should be updated differently.
> The INRANGE and CONFIDENCE fields seem to do that for some devices,
> yet others rely on the contactcount. The TIPSWITCH field should rather
> update curdata.touch.
>
>> >> +             case HID_DG_CONTACTCOUNT:
>> >> +                     /*
>> >> +                      * We must not overwrite the previous value (some
>> >> +                      * devices send one sequence splitted over several
>> >> +                      * messages)
>> >> +                      */
>> >> +                     if (value)
>> >> +                             td->maxcontact = value - 1;
>> >
>> > Is td->maxcontact ever reset? And why not num_expected or something
>> > instead of maxcontact - odd semantics.
>>
>> maxcontact is not reset (not needed as it is sent in each report).
>> Concerning the name, agree.
>
> You are right, this will work, too.
>
> Thanks,
> Henrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

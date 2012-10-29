Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2J2W0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:26:34 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:35922 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab2J2W0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:26:32 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhWdAD0Bj1BV5h1yPGdsb2JhbABEilK3KgICgQgZAQEBATg0gh4BAQQBJxMcIwULCANGFA0YChoTh3QDCQqyLA2JVBSKeoEdgSaCJ4F5YQOUH4FUhXmFOYdzDg
X-IronPort-AV: E=Sophos;i="4.80,674,1344204000"; 
   d="scan'208";a="435648226"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 23:31:09 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/11] HID: hid-multitouch: support for hovering
 devices
Message-ID: <20121029223109.GA15589@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-10-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241067-9521-10-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Win8 devices supporting hovering must provides InRange HID field.
> The information that the finger is here but is not touching the surface
> is sent to the user space through ABS_MT_DISTANCE as required by the
> multitouch protocol.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)

I suppose the idea here is to send position and distance values even
when there is no touch, but the code does not seem to do that?

> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index bd23f19..c0ab1c6 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -55,7 +55,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_WIN_8_CERTIFIED	(1 << 10)
>  
>  struct mt_slot {
> -	__s32 x, y, cx, cy, p, w, h;
> +	__s32 x, y, cx, cy, z, p, w, h;
>  	__s32 contactid;	/* the device ContactID assigned to this slot */
>  	bool touch_state;	/* is the touch valid? */
>  };
> @@ -394,6 +394,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	case HID_UP_DIGITIZER:
>  		switch (usage->hid) {
>  		case HID_DG_INRANGE:
> +			if (cls->quirks & MT_QUIRK_WIN_8_CERTIFIED) {
> +				hid_map_usage(hi, usage, bit, max,
> +					EV_ABS, ABS_MT_DISTANCE);
> +				input_set_abs_params(hi->input,
> +					ABS_MT_DISTANCE, 0, 1, 0, 0);
> +			}
>  			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
> @@ -511,6 +517,11 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  		struct mt_slot *s = &td->curdata;
>  
>  		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
> +		    !test_bit(ABS_MT_DISTANCE, input->absbit))
> +			/* If InRange is not present, rely on TipSwitch */
> +			s->touch_state = !s->z;
> +
> +		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
>  		    !s->touch_state) {
>  			struct input_mt_slot *slot = &input->mt->slots[slotnum];
>  			int prv_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
> @@ -543,6 +554,7 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  				input_event(input, EV_ABS, ABS_MT_TOOL_Y,
>  					s->cy);
>  			}
> +			input_event(input, EV_ABS, ABS_MT_DISTANCE, s->z);

This only happens if touch_state is true?

>  			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>  			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>  			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> @@ -575,11 +587,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  		case HID_DG_INRANGE:
>  			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>  				td->curvalid = value;
> +			if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
> +				td->curdata.touch_state = value;
>  			break;
>  		case HID_DG_TIPSWITCH:
>  			if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
>  				td->curvalid = value;
> -			td->curdata.touch_state = value;
> +			if (quirks & MT_QUIRK_WIN_8_CERTIFIED)
> +				td->curdata.z = !value;

Here, z is a boolean?

> +			else
> +				td->curdata.touch_state = value;
>  			break;
>  		case HID_DG_CONFIDENCE:
>  			if (quirks & MT_QUIRK_VALID_IS_CONFIDENCE)
> -- 
> 1.7.11.7
> 

Henrik

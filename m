Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423194Ab2KNSgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:36:43 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:54319 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423146Ab2KNSgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:36:42 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtWeAHfko1BV5h1yPGdsb2JhbABEile3XAOBARkBAQEBHxkNJ4IeAQEFJxMcEwEPEAgDGC4UDRgKGhOHeAMTsWUNiVQUizBpcoRZYQOUJ4FUhXuFOIgB
X-IronPort-AV: E=Sophos;i="4.83,252,1352070000"; 
   d="scan'208";a="229592059"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 14 Nov 2012 19:43:07 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 12/14] HID: hid-multitouch: support for hovering
 devices
Message-ID: <20121114184307.GA9372@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-13-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352908766-4492-13-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 04:59:24PM +0100, Benjamin Tissoires wrote:
> Win8 devices supporting hovering must provides InRange HID field.
> The information that the finger is here but is not touching the surface
> is sent to the user space through ABS_MT_DISTANCE as required by the
> multitouch protocol.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index c5b81a7..5f26b2f 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -53,11 +53,13 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
>  #define MT_QUIRK_NO_AREA		(1 << 9)
>  #define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
> +#define MT_QUIRK_HOVERING		(1 << 11)
>  
>  struct mt_slot {
>  	__s32 x, y, cx, cy, p, w, h;
>  	__s32 contactid;	/* the device ContactID assigned to this slot */
>  	bool touch_state;	/* is the touch valid? */
> +	bool inrange_state;	/* is the finger in proximity of the sensor? */
>  };
>  
>  struct mt_class {
> @@ -392,6 +394,12 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	case HID_UP_DIGITIZER:
>  		switch (usage->hid) {
>  		case HID_DG_INRANGE:
> +			if (cls->quirks & MT_QUIRK_HOVERING) {
> +				hid_map_usage(hi, usage, bit, max,
> +					EV_ABS, ABS_MT_DISTANCE);
> +				input_set_abs_params(hi->input,
> +					ABS_MT_DISTANCE, 0, 1, 0, 0);
> +			}
>  			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
> @@ -521,9 +529,9 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  
>  		input_mt_slot(input, slotnum);
>  		input_mt_report_slot_state(input, MT_TOOL_FINGER,
> -			s->touch_state);
> -		if (s->touch_state) {
> -			/* this finger is on the screen */
> +			s->touch_state || s->inrange_state);
> +		if (s->touch_state || s->inrange_state) {
> +			/* this finger is in proximity of the sensor */
>  			int wide = (s->w > s->h);
>  			/* divided by two to match visual scale of touch */
>  			int major = max(s->w, s->h) >> 1;
> @@ -533,6 +541,8 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
>  			input_event(input, EV_ABS, ABS_MT_TOOL_X, s->cx);
>  			input_event(input, EV_ABS, ABS_MT_TOOL_Y, s->cy);
> +			input_event(input, EV_ABS, ABS_MT_DISTANCE,
> +				!s->touch_state);
>  			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>  			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>  			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> @@ -565,6 +575,8 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  		case HID_DG_INRANGE:
>  			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>  				td->curvalid = value;
> +			if (quirks & MT_QUIRK_HOVERING)
> +				td->curdata.inrange_state = value;
>  			break;
>  		case HID_DG_TIPSWITCH:
>  			if (quirks & MT_QUIRK_NOT_SEEN_MEANS_UP)
> -- 
> 1.8.0
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

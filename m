Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab2KMPtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:49:49 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:46026 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab2KMPtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:49:46 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjWwAOppolBV5h1yPGdsb2JhbABEhTGFI7gXAgF+GQEBAQEfGQ0ngh4BAQUnExwTAQ8QCAMYLhQNGAoaE4d4AxOqAIZSDYlUFIstaXmBfoJ8YQOUJ4FUgR2EXoU4iAE
X-IronPort-AV: E=Sophos;i="4.80,767,1344204000"; 
   d="scan'208";a="228956547"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 16:56:06 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 07/13] HID: hid-multitouch: support T and C for win8
 devices
Message-ID: <20121113155606.GA561@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-8-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352306256-12180-8-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 05:37:30PM +0100, Benjamin Tissoires wrote:
> Win8 input specification clarifies the X and Y sent by devices.
> It distincts the position where the user wants to Touch (T) from
> the center of the ellipsoide (C). This patch enable supports for this
> distinction in hid-multitouch.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 46 +++++++++++++++++++++++++++++++++++---------
>  1 file changed, 37 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index ae57b8f..54367f4 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -54,7 +54,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_NO_AREA		(1 << 9)
>  
>  struct mt_slot {
> -	__s32 x, y, p, w, h;
> +	__s32 x, y, cx, cy, p, w, h;
>  	__s32 contactid;	/* the device ContactID assigned to this slot */
>  	bool touch_state;	/* is the touch valid? */
>  };
> @@ -323,6 +323,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	struct mt_device *td = hid_get_drvdata(hdev);
>  	struct mt_class *cls = &td->mtclass;
>  	int code;
> +	struct hid_usage *prev_usage = NULL;
>  
>  	/* Only map fields from TouchScreen or TouchPad collections.
>  	* We need to ignore fields that belong to other collections
> @@ -345,23 +346,42 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	if (field->physical == HID_DG_STYLUS)
>  		return -1;
>  
> +	if (usage->usage_index)
> +		prev_usage = &field->usage[usage->usage_index - 1];
> +
>  	switch (usage->hid & HID_USAGE_PAGE) {
>  
>  	case HID_UP_GENDESK:
>  		switch (usage->hid) {
>  		case HID_GD_X:
> -			hid_map_usage(hi, usage, bit, max,
> +			if (prev_usage && (prev_usage->hid == usage->hid)) {
> +				hid_map_usage(hi, usage, bit, max,
> +					EV_ABS, ABS_MT_TOOL_X);
> +				set_abs(hi->input, ABS_MT_TOOL_X, field,
> +					cls->sn_move);
> +			} else {
> +				hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_POSITION_X);
> -			set_abs(hi->input, ABS_MT_POSITION_X, field,
> -				cls->sn_move);
> +				set_abs(hi->input, ABS_MT_POSITION_X, field,
> +					cls->sn_move);
> +			}
> +
>  			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_GD_Y:
> -			hid_map_usage(hi, usage, bit, max,
> +			if (prev_usage && (prev_usage->hid == usage->hid)) {
> +				hid_map_usage(hi, usage, bit, max,
> +					EV_ABS, ABS_MT_TOOL_Y);
> +				set_abs(hi->input, ABS_MT_TOOL_Y, field,
> +					cls->sn_move);
> +			} else {
> +				hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_POSITION_Y);
> -			set_abs(hi->input, ABS_MT_POSITION_Y, field,
> -				cls->sn_move);
> +				set_abs(hi->input, ABS_MT_POSITION_Y, field,
> +					cls->sn_move);
> +			}
> +
>  			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
> @@ -502,6 +522,8 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  
>  			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
>  			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
> +			input_event(input, EV_ABS, ABS_MT_TOOL_X, s->cx);
> +			input_event(input, EV_ABS, ABS_MT_TOOL_Y, s->cy);
>  			input_event(input, EV_ABS, ABS_MT_ORIENTATION, wide);
>  			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>  			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
> @@ -553,10 +575,16 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  			td->curdata.p = value;
>  			break;
>  		case HID_GD_X:
> -			td->curdata.x = value;
> +			if (usage->code == ABS_MT_TOOL_X)
> +				td->curdata.cx = value;
> +			else
> +				td->curdata.x = value;
>  			break;
>  		case HID_GD_Y:
> -			td->curdata.y = value;
> +			if (usage->code == ABS_MT_TOOL_Y)
> +				td->curdata.cy = value;
> +			else
> +				td->curdata.y = value;
>  			break;
>  		case HID_DG_WIDTH:
>  			td->curdata.w = value;
> -- 
> 1.7.11.7
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

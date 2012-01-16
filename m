Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab2APOxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 09:53:11 -0500
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:42583 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2APOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 09:53:08 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AopGAO04FE9V5qrvPGdsb2JhbABDiVihL4ElgQoZAQEBATcygXIBAQUnExwjEAgDRhQlChqID7ViE4keBAkFAQUJCQUBBQYPCgEbBwkNEAECAQEIAQEBAwsCAgEDCAIQBQgMBwQZDR4BCAgDhRVjBJUQhWGMYg
X-IronPort-AV: E=Sophos;i="4.71,518,1320620400"; 
   d="scan'208";a="1792084873"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 16 Jan 2012 15:53:04 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>
Subject: Re: [PATCH 1/2] hid-multitouch: add support for trackpads
Message-ID: <20120116145304.GA9828@polaris.bitmath.org>
References: <1326469531-26808-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326469531-26808-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> * some multitouch trackpads present the touch usage. This needs to be
> filtered as it will conflict with mt-implementation.
> * trackpads send BTN_TOOL_* to notify how many fingers are present
> (this is used by xorg to use synaptics instead of generic evdev)
> * trackpads like Perixx 701 are not different from a hid point of view
> from a touchscreen, and we need to manually set them as touchpad.

Missing subject line?

> @@ -265,17 +266,31 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  {
>  	struct mt_device *td = hid_get_drvdata(hdev);
>  	struct mt_class *cls = &td->mtclass;
> +	int code;
>  
>  	/* Only map fields from TouchScreen or TouchPad collections.
>           * We need to ignore fields that belong to other collections
>           * such as Mouse that might have the same GenericDesktop usages. */
>  	if (field->application == HID_DG_TOUCHSCREEN)
>  		set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
> -	else if (field->application == HID_DG_TOUCHPAD)
> -		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
> -	else
> +	else if (field->application != HID_DG_TOUCHPAD)
>  		return 0;
>  
> +	/* In case of an indirect device (touchpad), we need to add
> +	 * specific BTN_TOOL_* to be handled by the synaptics xorg
> +	 * driver.
> +	 * We also consider that touchscreens providing buttons are touchpads.
> +	 */
> +	if (field->application == HID_DG_TOUCHPAD ||
> +	    (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON ||
> +	    cls->is_indirect) {
> +		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
> +		set_bit(BTN_TOOL_FINGER, hi->input->keybit);
> +		set_bit(BTN_TOOL_DOUBLETAP, hi->input->keybit);
> +		set_bit(BTN_TOOL_TRIPLETAP, hi->input->keybit);
> +		set_bit(BTN_TOOL_QUADTAP, hi->input->keybit);
> +	}
> +
>  	/* eGalax devices provide a Digitizer.Stylus input which overrides
>  	 * the correct Digitizers.Finger X/Y ranges.
>  	 * Let's just ignore this input. */
> @@ -389,9 +404,20 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  				td->last_field_index = field->index;
>  			return -1;
>  		}
> +		case HID_DG_TOUCH:
> +			/* Legacy devices use TIPSWITCH and not TOUCH.
> +			 * Let's just ignore this field. */
> +			return -1;
>  		/* let hid-input decide for the others */
>  		return 0;
>  
> +	case HID_UP_BUTTON:
> +		code = ((usage->hid - 1) & HID_USAGE);
> +		code += BTN_MOUSE;

Any reason not to write ((usage->hid - 1) & HID_USAGE) | BTN_MOUSE?

> +		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
> +		input_set_capability(hi->input, EV_KEY, code);
> +		return 1;
> +
>  	case 0xff000000:
>  		/* we do not want to map these: no input-oriented meaning */
>  		return -1;
> @@ -453,6 +479,7 @@ static void mt_complete_slot(struct mt_device *td)
>  static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>  {
>  	int i;
> +	int finger_count = 0;
>  
>  	for (i = 0; i < td->maxcontacts; ++i) {
>  		struct mt_slot *s = &(td->slots[i]);
> @@ -477,12 +504,14 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>  			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
>  			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
>  			input_event(input, EV_ABS, ABS_MT_TOUCH_MINOR, minor);
> +			finger_count++;
>  		}
>  		s->seen_in_this_frame = false;
>  
>  	}
>  
>  	input_mt_report_pointer_emulation(input, true);
> +	input_mt_report_finger_count(input, finger_count);
>  	input_sync(input);
>  	td->num_received = 0;
>  }
> @@ -538,6 +567,9 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  			if (value)
>  				td->num_expected = value;
>  			break;
> +		case HID_DG_TOUCH:
> +			/* do nothing */
> +			break;
>  
>  		default:
>  			/* fallback to the generic hidinput handling */
> -- 
> 1.7.4.4

Looks good otherwise.

Thanks,
Henrik

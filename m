Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2ATQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:09:28 -0500
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:55846 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab2ATQJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:09:27 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgFFADmQGU9V5qrvPGdsb2JhbABDiUuiFYIkGQEBAQE3MoFyAQEEAScTHCMFCwgDRhQlChqIDwK4TxOLMGMElRiFZYxo
X-IronPort-AV: E=Sophos;i="4.71,543,1320620400"; 
   d="scan'208";a="252639276"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 20 Jan 2012 17:09:48 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hid-multitouch: add support for trackpads
Message-ID: <20120120160948.GA18530@polaris.bitmath.org>
References: <1326887468-5148-1-git-send-email-benjamin.tissoires@enac.fr>
 <1326887468-5148-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326887468-5148-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> @@ -389,9 +404,19 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
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
> +		code = ((usage->hid - 1) & HID_USAGE) + BTN_MOUSE;

Why '+' here instead of '|' is  beyond me...

> +		hid_map_usage(hi, usage, bit, max, EV_KEY, code);
> +		input_set_capability(hi->input, EV_KEY, code);
> +		return 1;
> +
>  	case 0xff000000:
>  		/* we do not want to map these: no input-oriented meaning */
>  		return -1;
> @@ -453,6 +478,7 @@ static void mt_complete_slot(struct mt_device *td)
>  static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>  {
>  	int i;
> +	int finger_count = 0;
>  
>  	for (i = 0; i < td->maxcontacts; ++i) {
>  		struct mt_slot *s = &(td->slots[i]);
> @@ -477,12 +503,14 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
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

This function is already called from input_mt_report_pointer_emulation().

>  	input_sync(input);
>  	td->num_received = 0;
>  }

Thanks,
Henrik

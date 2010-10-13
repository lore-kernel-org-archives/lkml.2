Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab0JMRnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 13:43:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42142 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab0JMRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 13:43:09 -0400
Subject: Re: [PATCH 2/6] hid: egalax: Setup input device manually
From: Chase Douglas <chase.douglas@canonical.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1286978302-30034-3-git-send-email-rydberg@euromail.se>
References: <1286978302-30034-1-git-send-email-rydberg@euromail.se>
	 <1286978302-30034-3-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 13:43:03 -0400
Message-ID: <1286991783.31864.195.camel@mini>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 15:58 +0200, Henrik Rydberg wrote:
> The hid core does not yet handle input filtering. Take over the setup
> of the input device, so that proper signal-to-noise ratios can be
> used.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-egalax.c |   37 +++++++++++++++++++++++++------------
>  1 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hid/hid-egalax.c b/drivers/hid/hid-egalax.c
> index 5a1b52e..23f832b 100644
> --- a/drivers/hid/hid-egalax.c
> +++ b/drivers/hid/hid-egalax.c
> @@ -25,6 +25,8 @@ MODULE_LICENSE("GPL");
>  
>  #include "hid-ids.h"
>  
> +#define MAX_EVENTS		120
> +
>  struct egalax_data {
>  	__u16 x, y, z;
>  	__u8 id;
> @@ -34,10 +36,21 @@ struct egalax_data {
>  	__u16 lastx, lasty, lastz;	/* latest valid (x, y, z) in the frame */
>  };
>  
> +static void set_abs(struct input_dev *input, unsigned int code,
> +		    struct hid_field *field, int snratio)
> +{
> +	int fmin = field->logical_minimum;
> +	int fmax = field->logical_maximum;
> +	int fuzz = snratio ? (fmax - fmin) / snratio : 0;
> +	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
> +}
> +
>  static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		struct hid_field *field, struct hid_usage *usage,
>  		unsigned long **bit, int *max)
>  {
> +	struct input_dev *input = hi->input;
> +
>  	switch (usage->hid & HID_USAGE_PAGE) {
>  
>  	case HID_UP_GENDESK:
> @@ -45,18 +58,16 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		case HID_GD_X:
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_POSITION_X);
> +			set_abs(input, ABS_MT_POSITION_X, field, 0);
>  			/* touchscreen emulation */
> -			input_set_abs_params(hi->input, ABS_X,
> -						field->logical_minimum,
> -						field->logical_maximum, 0, 0);
> +			set_abs(input, ABS_X, field, 0);
>  			return 1;
>  		case HID_GD_Y:
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_POSITION_Y);
> +			set_abs(input, ABS_MT_POSITION_Y, field, 0);
>  			/* touchscreen emulation */
> -			input_set_abs_params(hi->input, ABS_Y,
> -						field->logical_minimum,
> -						field->logical_maximum, 0, 0);
> +			set_abs(input, ABS_Y, field, 0);
>  			return 1;
>  		}
>  		return 0;
> @@ -66,6 +77,7 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		case HID_DG_TIPSWITCH:
>  			/* touchscreen emulation */
>  			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
> +			input_set_capability(input, EV_KEY, BTN_TOUCH);
>  			return 1;
>  		case HID_DG_INRANGE:
>  		case HID_DG_CONFIDENCE:
> @@ -75,14 +87,15 @@ static int egalax_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  		case HID_DG_CONTACTID:
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_TRACKING_ID);
> +			set_abs(input, ABS_MT_TRACKING_ID, field, 0);
> +			input_set_events_per_packet(input, MAX_EVENTS);
>  			return 1;
>  		case HID_DG_TIPPRESSURE:
>  			hid_map_usage(hi, usage, bit, max,
>  					EV_ABS, ABS_MT_PRESSURE);
> +			set_abs(input, ABS_MT_PRESSURE, field, 0);
>  			/* touchscreen emulation */
> -			input_set_abs_params(hi->input, ABS_PRESSURE,
> -						field->logical_minimum,
> -						field->logical_maximum, 0, 0);
> +			set_abs(input, ABS_PRESSURE, field, 0);
>  			return 1;
>  		}
>  		return 0;
> @@ -96,10 +109,10 @@ static int egalax_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>  		struct hid_field *field, struct hid_usage *usage,
>  		unsigned long **bit, int *max)
>  {
> +	/* tell hid-input to skip setup of these event types */
>  	if (usage->type == EV_KEY || usage->type == EV_ABS)
> -		clear_bit(usage->code, *bit);
> -
> -	return 0;
> +		set_bit(usage->type, hi->input->evbit);
> +	return -1;
>  }
>  
>  /*

Seems reasonable to me. For others, it's not obvious what this changes
until you see patch 5/6. I'm curious why you don't just squash the two
patches together?

Acked-by: Chase Douglas <chase.douglas@canonical.com>


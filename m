Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2EFS4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 14:56:51 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:52616 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab2EFS4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 14:56:49 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApZ/AGTIpk9V5qg+PGdsb2JhbABEijSnFASBHhkBAQEBNzSCDAEBBAEnExwjBQsIA0YUJQoaE4gJCbliE4srhH5jBJV9hgaNKIFUGQ
X-IronPort-AV: E=Sophos;i="4.75,539,1330902000"; 
   d="scan'208";a="327722180"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 6 May 2012 21:01:46 +0200
To: "benjamin.tissoires" <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
Message-ID: <20120506190146.GA12571@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> The previous implementation introduced a randomness in the splitting
> of the different touches reported by the device. This version is more
> robust as we don't rely on hi->input->absbit, but on our own structure.
> 
> This also prepares hid-multitouch to better support Win8 devices.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
>  drivers/hid/hid-multitouch.c |   58 +++++++++++++++++++++++++++++++++--------
>  1 files changed, 46 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 84bb32e..c6ffb05 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -70,9 +70,16 @@ struct mt_class {
>  	bool is_indirect;	/* true for touchpads */
>  };
>  
> +struct mt_fields {
> +	unsigned usages[HID_MAX_FIELDS];
> +	unsigned int length;
> +};
> +
>  struct mt_device {
>  	struct mt_slot curdata;	/* placeholder of incoming data */
>  	struct mt_class mtclass;	/* our mt device class */
> +	struct mt_fields *fields;	/* temporary placeholder for storing the
> +					   multitouch fields */

Why not skip the pointer here?

>  	unsigned last_field_index;	/* last field index of the report */
>  	unsigned last_slot_field;	/* the last field of a slot */
>  	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
> @@ -275,11 +282,15 @@ static void set_abs(struct input_dev *input, unsigned int code,
>  	input_set_abs_params(input, code, fmin, fmax, fuzz, 0);
>  }
>  
> -static void set_last_slot_field(struct hid_usage *usage, struct mt_device *td,
> +static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
>  		struct hid_input *hi)

How about adding the last_field_index here also, using a function like

static void mt_store_field(struct mt_device *td, struct hid_input *hi,
       	    		struct hid_field *field, struct hid_usage *usage)

>  {
> -	if (!test_bit(usage->hid, hi->input->absbit))
> -		td->last_slot_field = usage->hid;
> +	struct mt_fields *f = td->fields;

And inserting td->last_field_index = field->index here.

> +
> +	if (f->length >= HID_MAX_FIELDS)
> +		return;
> +
> +	f->usages[f->length++] = usage->hid;
>  }
>  
>  static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> @@ -330,7 +341,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  				cls->sn_move);
>  			/* touchscreen emulation */
>  			set_abs(hi->input, ABS_X, field, cls->sn_move);
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_GD_Y:
> @@ -340,7 +351,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  				cls->sn_move);
>  			/* touchscreen emulation */
>  			set_abs(hi->input, ABS_Y, field, cls->sn_move);
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		}
> @@ -349,24 +360,24 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  	case HID_UP_DIGITIZER:
>  		switch (usage->hid) {
>  		case HID_DG_INRANGE:
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_CONFIDENCE:
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_TIPSWITCH:
>  			hid_map_usage(hi, usage, bit, max, EV_KEY, BTN_TOUCH);
>  			input_set_capability(hi->input, EV_KEY, BTN_TOUCH);
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_CONTACTID:
>  			if (!td->maxcontacts)
>  				td->maxcontacts = MT_DEFAULT_MAXCONTACT;
>  			input_mt_init_slots(hi->input, td->maxcontacts);
> -			td->last_slot_field = usage->hid;
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			td->touches_by_report++;
>  			return 1;
> @@ -375,7 +386,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  					EV_ABS, ABS_MT_TOUCH_MAJOR);
>  			set_abs(hi->input, ABS_MT_TOUCH_MAJOR, field,
>  				cls->sn_width);
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_HEIGHT:
> @@ -385,7 +396,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  				cls->sn_height);
>  			input_set_abs_params(hi->input,
>  					ABS_MT_ORIENTATION, 0, 1, 0, 0);
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_TIPPRESSURE:
> @@ -396,7 +407,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  			/* touchscreen emulation */
>  			set_abs(hi->input, ABS_PRESSURE, field,
>  				cls->sn_pressure);
> -			set_last_slot_field(usage, td, hi);
> +			mt_store_field(usage, td, hi);
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_CONTACTCOUNT:
> @@ -650,6 +661,16 @@ static void mt_post_parse_default_settings(struct mt_device *td)
>  	td->mtclass.quirks = quirks;
>  }
>  
> +static void mt_post_parse(struct mt_device *td)
> +{
> +	struct mt_fields *f = td->fields;
> +
> +	if (td->touches_by_report > 0) {
> +		int field_count_per_touch = f->length / td->touches_by_report;
> +		td->last_slot_field = f->usages[field_count_per_touch - 1]->hid;
> +	}
> +}
> +
>  static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  {
>  	int ret, i;
> @@ -680,6 +701,13 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	td->maxcontact_report_id = -1;
>  	hid_set_drvdata(hdev, td);
>  
> +	td->fields = kzalloc(sizeof(struct mt_fields), GFP_KERNEL);
> +	if (!td->fields) {
> +		dev_err(&hdev->dev, "cannot allocate multitouch fields data\n");
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +

This can be skipped.

>  	ret = hid_parse(hdev);
>  	if (ret != 0)
>  		goto fail;
> @@ -688,6 +716,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	if (ret)
>  		goto fail;
>  
> +	mt_post_parse(td);
> +
>  	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
>  		mt_post_parse_default_settings(td);
>  
> @@ -705,9 +735,13 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	mt_set_maxcontacts(hdev);
>  	mt_set_input_mode(hdev);
>  
> +	kfree(td->fields);
> +	td->fields = NULL;
> +

Ditto.

>  	return 0;
>  
>  fail:
> +	kfree(td->fields);

Ditto.

>  	kfree(td);
>  	return ret;
>  }
> -- 
> 1.7.7.6
> 

Thanks,
Henrik

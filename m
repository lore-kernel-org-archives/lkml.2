Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2J2TVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 15:21:24 -0400
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:43633 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2J2TVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 15:21:22 -0400
X-Greylist: delayed 1688 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 15:21:21 EDT
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av+eAJnWjlBV5h1yPGdsb2JhbABEilK0Y4JEAgKBCBkBAQEBODSCHgEBBAEnExwjBQsIA0YUJQoaiBMKu3sUjBeBJoQgYQOVc4V5g0+Jaw
X-IronPort-AV: E=Sophos;i="4.80,674,1344204000"; 
   d="scan'208";a="219443829"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 20:25:58 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/11] HID: hid-input: add usage_index argument in
 input_mapping and event.
Message-ID: <20121029192558.GA15061@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-4-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241067-9521-4-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Currently, there is no way to know the index of the current field
> in the .input_mapping and .event callbacks  when this field is inside
> an array of HID fields.
> This patch forwards this index to the input_mapping and event
> callbacks.

I agree with the idea, but the function argument list is becoming
ridiculously long... Could we remove the usage pointer argument, at
least?

	int (*event)(struct hid_device *hdev, struct hid_field *field,
			unsigned int usage_index, __s32 value);


> @@ -1071,19 +1072,24 @@ static void hid_input_field(struct hid_device *hid, struct hid_field *field,
>  	for (n = 0; n < count; n++) {
>  
>  		if (HID_MAIN_ITEM_VARIABLE & field->flags) {
> -			hid_process_event(hid, field, &field->usage[n], value[n], interrupt);
> +			hid_process_event(hid, field, &field->usage[n], n,
> +				value[n], interrupt);
>  			continue;
>  		}
>  
>  		if (field->value[n] >= min && field->value[n] <= max
>  			&& field->usage[field->value[n] - min].hid
>  			&& search(value, field->value[n], count))
> -				hid_process_event(hid, field, &field->usage[field->value[n] - min], 0, interrupt);
> +				hid_process_event(hid, field,
> +					&field->usage[field->value[n] - min], n,
> +					0, interrupt);

Wrong index?

>  
>  		if (value[n] >= min && value[n] <= max
>  			&& field->usage[value[n] - min].hid
>  			&& search(field->value, value[n], count))
> -				hid_process_event(hid, field, &field->usage[value[n] - min], 1, interrupt);
> +				hid_process_event(hid, field,
> +					&field->usage[value[n] - min], n,
> +					1, interrupt);

Wrong index?

>  	}
>  
>  	memcpy(field->value, value, count * sizeof(__s32));

Thanks,
Henrik

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab2KMQTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:19:15 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:42299 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2KMQTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:19:12 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjOwABFyolBV5h1yPGdsb2JhbABEhTGFI7gXAgF+GQEBAQEfGQ0ngh4BAQQBJxMcIwULCANGFA0YChoTh3gDCQqpeoZPDYlUFIstgWKBfoJ8YQOUJ4FUhXuDToFqiAE
X-IronPort-AV: E=Sophos;i="4.80,768,1344204000"; 
   d="scan'208";a="448606684"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 13 Nov 2012 17:25:31 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/13] HID: hid-multitouch: add
 MT_QUIRK_IGNORE_DUPLICATES
Message-ID: <20121113162531.GA669@polaris.bitmath.org>
References: <1352306256-12180-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352306256-12180-10-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352306256-12180-10-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> this prevents a device to reuse contact id 0 several time when
> sending garbage values to complete the report.

This quirk allows a device to reuse a contact id when sending garbage
inactive contacts at the end of a report.

> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 6 ++++++
>  include/linux/input/mt.h     | 6 ++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 2352770..351c814 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -52,6 +52,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 6)
>  #define MT_QUIRK_SLOT_IS_CONTACTID_MINUS_ONE	(1 << 8)
>  #define MT_QUIRK_NO_AREA		(1 << 9)
> +#define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
>  
>  struct mt_slot {
>  	__s32 x, y, cx, cy, p, w, h;
> @@ -510,6 +511,11 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  		if (slotnum < 0 || slotnum >= td->maxcontacts)
>  			return;
>  
> +		if (td->mtclass.quirks & MT_QUIRK_IGNORE_DUPLICATES &&

Don't like parenthesis, i see :-)

> +		    input_mt_is_active(&input->mt->slots[slotnum]) &&
> +		    input_mt_is_used(input->mt, &input->mt->slots[slotnum]))
> +				return;
> +

It init_mt_slots failed earlier (no checks), input->mt can be NULL
here. Also, a local variable instead of repetition would be nice.

>  		input_mt_slot(input, slotnum);
>  		input_mt_report_slot_state(input, MT_TOOL_FINGER,
>  			s->touch_state);
> diff --git a/include/linux/input/mt.h b/include/linux/input/mt.h
> index cc5cca7..2e86bd0 100644
> --- a/include/linux/input/mt.h
> +++ b/include/linux/input/mt.h
> @@ -69,6 +69,12 @@ static inline bool input_mt_is_active(const struct input_mt_slot *slot)
>  	return input_mt_get_value(slot, ABS_MT_TRACKING_ID) >= 0;
>  }
>  
> +static inline bool input_mt_is_used(const struct input_mt *mt,
> +				    const struct input_mt_slot *slot)
> +{
> +	return slot->frame == mt->frame;
> +}
> +

This is ok, although I would prefer to also change input-mt.c to use
this helper function. Possibly that turns this hunk into a separate patch.

>  int input_mt_init_slots(struct input_dev *dev, unsigned int num_slots,
>  			unsigned int flags);
>  void input_mt_destroy_slots(struct input_dev *dev);
> -- 
> 1.7.11.7
> 

Thanks,
Henrik

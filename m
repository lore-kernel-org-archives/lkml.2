Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1AKNMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 08:12:05 -0500
Received: from csmtp3.one.com ([91.198.169.23]:38294 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1AKNMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 08:12:03 -0500
From: "Henrik Rydberg" <rydberg@bitmath.org>
Date: Tue, 11 Jan 2011 14:11:54 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Stephane Chatty <chatty@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-multitouch: changes from the review process
Message-ID: <20110111131154.GC1961@polaris.bitmath.org>
References: <1294743194-2310-1-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294743194-2310-1-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

seems we are cloing in now, although there is still an outstanding
issue with the setting of curvalid, as replied in your previous
mail. Some comments on this patch, too.

>  struct mt_class mt_classes[] = {
> -	{ 0, 0, 0, 10 },                             /* MT_CLS_DEFAULT */
> -	{ MT_QUIRK_SLOT_IS_CONTACTID, 0, 0, 2 },     /* MT_CLS_DUAL1 */
> -	{ MT_QUIRK_SLOT_IS_CONTACTNUMBER, 0, 0, 10 },    /* MT_CLS_DUAL2 */
> -	{ MT_QUIRK_CYPRESS | MT_QUIRK_NOT_SEEN_MEANS_UP, 0, 0, 10 }, /* MT_CLS_CYPRESS */
> +	{ .name = MT_CLS_DEFAULT,
> +		.quirks = 0,

Please do not zero-initialize.

> +		.sn_move = 0,
> +		.sn_pressure = 0,
> +		.maxcontacts = 10 },
> +	{ .name = MT_CLS_DUAL1,
> +		.quirks = MT_QUIRK_SLOT_IS_CONTACTID,
> +		.sn_move = 0,
> +		.sn_pressure = 0,
> +		.maxcontacts = 2 },
> +	{ .name = MT_CLS_DUAL2,
> +		.quirks = MT_QUIRK_SLOT_IS_CONTACTNUMBER,
> +		.sn_move = 0,
> +		.sn_pressure = 0,
> +		.maxcontacts = 2 },
> +	{ .name = MT_CLS_CYPRESS,
> +		.quirks = MT_QUIRK_CYPRESS,
> +		.sn_move = 0,
> +		.sn_pressure = 0,
> +		.maxcontacts = 10 },
> +
> +	{ }
>  };

So no device is marked as NOT_SEEN_MEANS_UP, although allegedly some devices should...

> @@ -282,11 +297,10 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>  
>  	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
>  		struct mt_slot *s = &(td->slots[i]);
> -		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
> -			!s->seen_in_this_frame) {
> +		if (!s->seen_in_this_frame) {
>  			/*
> -			 * this slot does not contain useful data,
> -			 * notify its closure
> +			 * FixMe: use MT_QUIRK_NOT_SEEN_MEANS_UP here.
> +			 * This requires to change the curvalid logic.
>  			 */
>  			s->touch_state = false;
>  		}

If we were to push this broken behavior, simply to avoid changing the
currently tested code, we would only push the problem of testing onto
the next cycle, with a larger risk of introducing regressions. I
really think we need to sort this out now.

> @@ -392,9 +407,16 @@ static void mt_set_input_mode(struct hid_device *hdev)
>  
>  static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  {
> -	int ret;
> +	int ret, i;
>  	struct mt_device *td;
> -	struct mt_class *mtclass = mt_classes + id->driver_data;
> +	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
> +
> +	for (i = 0; mt_classes[i].name ; i++) {
> +		if (id->driver_data == mt_classes[i].name) {
> +			mtclass = &(mt_classes[i]);
> +			break;
> +		}
> +	}

Nice.

Thanks,
Henrik

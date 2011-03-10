Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1CJMoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 07:44:24 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:35895 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab1CJMoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 07:44:23 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 10 Mar 2011 13:45:30 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110310124530.GA3378@polaris.bitmath.org>
References: <1299686450-5475-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299686450-5475-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299686450-5475-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxfCO-00040s-9M.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PxfCO-00040s-9M 81ff7ac3cce56e8107148966a81eb63c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

thanks for this, just a couple of things...

> @@ -126,9 +127,19 @@ struct mt_class mt_classes[] = {
>  static void mt_feature_mapping(struct hid_device *hdev,
>  		struct hid_field *field, struct hid_usage *usage)
>  {
> -	if (usage->hid == HID_DG_INPUTMODE) {
> -		struct mt_device *td = hid_get_drvdata(hdev);
> +	struct mt_device *td = hid_get_drvdata(hdev);
> +
> +	switch (usage->hid) {
> +	case HID_DG_INPUTMODE:
>  		td->inputmode = field->report->id;
> +		break;
> +	case HID_DG_CONTACTMAX:
> +		td->maxcontacts = *(field->value);

field->value[0] seems more standard-ish

> +		if (td->mtclass->maxcontacts > td->maxcontacts)
> +			/* check if the maxcontacts is given by the class */
> +			td->maxcontacts = td->mtclass->maxcontacts;
> +
> +		break;
>  	}
>  }
>  
> @@ -317,7 +327,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  	struct mt_device *td = hid_get_drvdata(hid);
>  	__s32 quirks = td->mtclass->quirks;
>  
> -	if (hid->claimed & HID_CLAIMED_INPUT) {
> +	if (hid->claimed & HID_CLAIMED_INPUT && td->slots) {

The extra test could in principle be placed after the usage switch, which would prevent partially filled contact data, should this ever occur. Something like

if (!td->slots)
   break;

>  		switch (usage->hid) {
>  		case HID_DG_INRANGE:
>  			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
> @@ -415,9 +425,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	 */
>  	hdev->quirks |= HID_QUIRK_NO_INPUT_SYNC;
>  
> -	td = kzalloc(sizeof(struct mt_device) +
> -				mtclass->maxcontacts * sizeof(struct mt_slot),
> -				GFP_KERNEL);
> +	td = kzalloc(sizeof(struct mt_device), GFP_KERNEL);
>  	if (!td) {
>  		dev_err(&hdev->dev, "cannot allocate multitouch data\n");
>  		return -ENOMEM;
> @@ -434,6 +442,14 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	if (ret)
>  		goto fail;
>  
> +	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
> +				GFP_KERNEL);
> +	if (!td->slots) {
> +		dev_err(&hdev->dev, "cannot allocate multitouch slots\n");
> +		ret = -ENOMEM;
> +		goto fail;

This exit leaves the device running.

> +	}
> +
>  	mt_set_input_mode(hdev);
>  
>  	return 0;
> @@ -455,6 +471,7 @@ static void mt_remove(struct hid_device *hdev)
>  {
>  	struct mt_device *td = hid_get_drvdata(hdev);
>  	hid_hw_stop(hdev);
> +	kfree(td->slots);
>  	kfree(td);
>  	hid_set_drvdata(hdev, NULL);
>  }
> -- 
> 1.7.4
> 

Thanks,
Henrik

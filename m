Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1CILUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 06:20:16 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:36298 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758Ab1CILUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:20:14 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 9 Mar 2011 12:22:55 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] hid-multitouch: Auto detection of maxcontacts
Message-ID: <20110309112255.GA9020@polaris.bitmath.org>
References: <1299601979-4871-1-git-send-email-benjamin.tissoires@enac.fr>
 <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299601979-4871-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1PxHR2-0002Xz-Cj.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PxHR2-0002Xz-Cj 0c8844da1a2633033272990ed27ec13c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 05:32:56PM +0100, Benjamin Tissoires wrote:
> This patch enables support of autodetection of maxcontacts.
> We can still manually provide maxcontact in case the device
> lies on it.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---
>  drivers/hid/hid-multitouch.c |   43 ++++++++++++++++++++++++++++-------------
>  1 files changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 65e7f20..363ca08 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -38,6 +38,8 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_VALID_IS_INRANGE	(1 << 4)
>  #define MT_QUIRK_VALID_IS_CONFIDENCE	(1 << 5)
>  
> +#define MT_CONTACTMAX_DEFAULT	11
> +

I think this one can be removed, se below.

>  struct mt_slot {
>  	__s32 x, y, p, w, h;
>  	__s32 contactid;	/* the device ContactID assigned to this slot */
> @@ -53,8 +55,9 @@ struct mt_device {
>  	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
>  	__u8 num_received;	/* how many contacts we received */
>  	__u8 num_expected;	/* expected last contact index */
> +	__u8 maxcontacts;
>  	bool curvalid;		/* is the current contact valid? */
> -	struct mt_slot slots[0];	/* first slot */
> +	struct mt_slot *slots;
>  };
>  
>  struct mt_class {
> @@ -87,12 +90,12 @@ static int cypress_compute_slot(struct mt_device *td)
>  static int find_slot_from_contactid(struct mt_device *td)
>  {
>  	int i;
> -	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
> +	for (i = 0; i < td->maxcontacts; ++i) {
>  		if (td->slots[i].contactid == td->curdata.contactid &&
>  			td->slots[i].touch_state)
>  			return i;
>  	}
> -	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
> +	for (i = 0; i < td->maxcontacts; ++i) {
>  		if (!td->slots[i].seen_in_this_frame &&
>  			!td->slots[i].touch_state)
>  			return i;
> @@ -105,8 +108,7 @@ static int find_slot_from_contactid(struct mt_device *td)
>  
>  struct mt_class mt_classes[] = {
>  	{ .name = MT_CLS_DEFAULT,
> -		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
> -		.maxcontacts = 10 },
> +		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },

Keeping .maxcontacts at two here seems sensible

>  	{ .name = MT_CLS_DUAL_INRANGE_CONTACTID,
>  		.quirks = MT_QUIRK_VALID_IS_INRANGE |
>  			MT_QUIRK_SLOT_IS_CONTACTID,
> @@ -126,9 +128,22 @@ struct mt_class mt_classes[] = {
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
> +		if (td->mtclass->maxcontacts)

if (td->mtclass->maxcontacts > td->maxcontacts)

> +			/* check if the maxcontacts is given by the class */
> +			td->maxcontacts = td->mtclass->maxcontacts;
> +
> +		if (!td->maxcontacts)
> +			td->maxcontacts = MT_CONTACTMAX_DEFAULT;

this part can be then dropped

> +
> +		break;
>  	}
>  }
>  
> @@ -186,8 +201,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  			td->last_slot_field = usage->hid;
>  			return 1;
>  		case HID_DG_CONTACTID:
> -			input_mt_init_slots(hi->input,
> -					td->mtclass->maxcontacts);
> +			input_mt_init_slots(hi->input, td->maxcontacts);
>  			td->last_slot_field = usage->hid;
>  			return 1;
>  		case HID_DG_WIDTH:
> @@ -268,7 +282,7 @@ static void mt_complete_slot(struct mt_device *td)
>  	if (td->curvalid) {
>  		int slotnum = mt_compute_slot(td);
>  
> -		if (slotnum >= 0 && slotnum < td->mtclass->maxcontacts)
> +		if (slotnum >= 0 && slotnum < td->maxcontacts)
>  			td->slots[slotnum] = td->curdata;
>  	}
>  	td->num_received++;
> @@ -283,7 +297,7 @@ static void mt_emit_event(struct mt_device *td, struct input_dev *input)
>  {
>  	int i;
>  
> -	for (i = 0; i < td->mtclass->maxcontacts; ++i) {
> +	for (i = 0; i < td->maxcontacts; ++i) {
>  		struct mt_slot *s = &(td->slots[i]);
>  		if ((td->mtclass->quirks & MT_QUIRK_NOT_SEEN_MEANS_UP) &&
>  			!s->seen_in_this_frame) {
> @@ -415,9 +429,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
> @@ -434,6 +446,9 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	if (ret)
>  		goto fail;
>  
> +	td->slots = kzalloc(td->maxcontacts * sizeof(struct mt_slot),
> +				GFP_KERNEL);
> +

Don't we have a race problem here?  It seems the device is started at
this point, so I worry that events will be handled when slots is still
NULL.

>  	mt_set_input_mode(hdev);
>  
>  	return 0;
> -- 
> 1.7.4
> 

Thanks,
Henrik

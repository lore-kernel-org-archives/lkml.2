Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab1GYJYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 05:24:16 -0400
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:50041 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1GYJYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 05:24:06 -0400
Subject: Re: [PATCH 2/3] hid-multitouch: Filter collections by application  usage.
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <1311545261-34067-2-git-send-email-jeffbrown@android.com>
Date: Mon, 25 Jul 2011 11:16:36 +0200
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, rydberg@euromail.se,
        benjamin.tissoires@enac.fr, Jeff Brown <jeffbrown@google.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <13989665-31A9-4C70-B578-5559987CC9F5@enac.fr>
References: <1311545261-34067-1-git-send-email-jeffbrown@android.com> <1311545261-34067-2-git-send-email-jeffbrown@android.com>
To: jeffbrown@android.com
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 25 juil. 2011 à 00:07, jeffbrown@android.com a écrit :

> From: Jeff Brown <jeffbrown@google.com>
> 
> This change fixes two problems.
> 
> First, it ensures that the hid-multitouch driver does not incorrectly
> map GenericDesktop usages that are intended for other applications,
> such as a Mouse.
> 
> Second, it sets the appropriate input properties so that user-space
> can distinguish TouchScreen devices (INPUT_PROP_DIRECT) from
> TouchPad devices (INPUT_PROP_POINTER) and configure them accordingly.
> 
> Signed-off-by: jeffbrown@android.com
> ---
> drivers/hid/hid-multitouch.c |   10 ++++++++++
> 1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 58d0e7a..4ee21ac 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -213,6 +213,16 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
> 	struct mt_class *cls = td->mtclass;
> 	__s32 quirks = cls->quirks;
> 
> +	/* Only map fields from TouchScreen or TouchPad collections.
> +         * We need to ignore fields that belong to other collections
> +         * such as Mouse that might have the same GenericDesktop usages. */
> +	if (field->application == HID_DG_TOUCHSCREEN)
> +		set_bit(INPUT_PROP_DIRECT, hi->input->propbit);
> +	else if (field->application == HID_DG_TOUCHPAD)
> +		set_bit(INPUT_PROP_POINTER, hi->input->propbit);
> +	else
> +		return 0;
> +
> 	switch (usage->hid & HID_USAGE_PAGE) {
> 
> 	case HID_UP_GENDESK:
> -- 
> 1.7.0.4
> 


Looks clever to me. Still, in principle we should check that all (or at least most) known devices fill the application field properly. I'll try to have a look at the report descriptors we have here.

St.




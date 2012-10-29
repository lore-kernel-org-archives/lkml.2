Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2J2WLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:11:43 -0400
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:57320 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab2J2WL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:11:28 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhqdAMr9jlBV5h1yPGdsb2JhbABEilK3KgICgQgZAQEBATg0gh4BAQQBJxMcIwULCAMtGRQNGAoaEx6HVgMJCrIrDYlUFIp6gR2BJoFRVoF5YQOUH4FUhXmDT4Fqh3MO
X-IronPort-AV: E=Sophos;i="4.80,675,1344204000"; 
   d="scan'208";a="141756192"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 23:16:05 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] HID: hid-multitouch: move ALWAYS_VALID quirk
 check
Message-ID: <20121029221605.GA15432@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-8-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241067-9521-8-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Win 8 device specification changed the requirements for the hid usages
> of the multitouch devices. Now InRange is optional and must be only
> used when the device supports hovering.
> 
> This ensures that the quirk ALWAYS_VALID is taken into account and
> also ensures its precedence over the other VALID* quirks.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Since we seem to never actually reset td, this seems equivalent,
unless some device added ALWAYS VALID by mistake, even if INRANGE is
not part of the report descriptor.

> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 000c979..43bd8e8 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -506,7 +506,7 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
>   */
>  static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  {
> -	if (td->curvalid) {
> +	if (td->curvalid || td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID) {

I found at least one presence of this construct in the kernel, but I
think the overwhelming majority use parenthesis.

>  		int slotnum = mt_compute_slot(td, input);
>  		struct mt_slot *s = &td->curdata;
>  
> @@ -561,9 +561,7 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
>  	if (hid->claimed & HID_CLAIMED_INPUT) {
>  		switch (usage->hid) {
>  		case HID_DG_INRANGE:
> -			if (quirks & MT_QUIRK_ALWAYS_VALID)
> -				td->curvalid = true;
> -			else if (quirks & MT_QUIRK_VALID_IS_INRANGE)
> +			if (quirks & MT_QUIRK_VALID_IS_INRANGE)
>  				td->curvalid = value;
>  			break;
>  		case HID_DG_TIPSWITCH:
> -- 
> 1.7.11.7
> 

Thanks,
Henrik

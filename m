Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab2KNSCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 13:02:20 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:39485 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2KNSCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:02:19 -0500
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtueAErco1BV5h1yPGdsb2JhbABEile3ZAOBARkBAQEBHxkNJ4IeAQEEAScTHBMBDwULCAMYLhQNGAoaE4d4AwkKsWENiVQUizBpcoRZYQOUJ4FUhXuDToFqiAE
X-IronPort-AV: E=Sophos;i="4.83,252,1352070000"; 
   d="scan'208";a="229581267"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 14 Nov 2012 19:08:46 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 11/14] HID: hid-multitouch: add
 MT_QUIRK_IGNORE_DUPLICATES
Message-ID: <20121114180846.GA6574@polaris.bitmath.org>
References: <1352908766-4492-1-git-send-email-benjamin.tissoires@gmail.com>
 <1352908766-4492-12-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352908766-4492-12-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 04:59:23PM +0100, Benjamin Tissoires wrote:
> This quirk allows a device to reuse a contact id when sending garbage
> inactive contacts at the end of a report.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 2352770..c5b81a7 100644
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
> @@ -506,10 +507,18 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
>  		int slotnum = mt_compute_slot(td, input);
>  		struct mt_slot *s = &td->curdata;
> +		struct input_mt *mt = input->mt;
>  
>  		if (slotnum < 0 || slotnum >= td->maxcontacts)
>  			return;
>  
> +		if ((td->mtclass.quirks & MT_QUIRK_IGNORE_DUPLICATES) && mt) {
> +			struct input_mt_slot *slot = &mt->slots[slotnum];
> +			if (input_mt_is_active(slot) &&
> +			    input_mt_is_used(mt, slot))
> +				return;
> +		}
> +

Slightly ugly, but I cannot see how to make it any prettier. :-)

>  		input_mt_slot(input, slotnum);
>  		input_mt_report_slot_state(input, MT_TOOL_FINGER,
>  			s->touch_state);
> -- 
> 1.8.0
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik

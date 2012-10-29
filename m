Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330Ab2J2WOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:14:31 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:38749 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237Ab2J2WO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:14:27 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhqdAKH+jlBV5h1yPGdsb2JhbABEilK3KgICgQgZAQEBATg0gh4BAQQBJxMcIwULCAMYLhQNGAoaEx6HVgMJCrItDYlUFIp6ZzaBJoIngXlhA5QfgVSFeYU5h3MO
X-IronPort-AV: E=Sophos;i="4.80,674,1344204000"; 
   d="scan'208";a="215245992"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 29 Oct 2012 23:19:05 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/11] HID: hid-multitouch: fix Win 8 protocol
Message-ID: <20121029221905.GA15537@polaris.bitmath.org>
References: <1351241067-9521-1-git-send-email-benjamin.tissoires@gmail.com>
 <1351241067-9521-9-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351241067-9521-9-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 10:44:24AM +0200, Benjamin Tissoires wrote:
> Win 8 specification is much more precise than the Win 7 one.
> Moreover devices that need to take certification must be submitted
> to Microsoft.
> 
> The result is a better protocol support and we can rely on that to
> skip all the messy tests we used to do.
> 
> The protocol specify the fact that each valid touch must be reported
> within a frame, and that the release touch coordinate must be the
> same than the last known touch.
> So we can use the always_valid quirk and dismiss reports when we
> touch coordiante do not follow this rule.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)

Why do we need this patch?

> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 43bd8e8..bd23f19 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -510,6 +510,18 @@ static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  		int slotnum = mt_compute_slot(td, input);
>  		struct mt_slot *s = &td->curdata;
>  
> +		if (td->mtclass.quirks & MT_QUIRK_WIN_8_CERTIFIED &&
> +		    !s->touch_state) {
> +			struct input_mt_slot *slot = &input->mt->slots[slotnum];
> +			int prv_x = input_mt_get_value(slot, ABS_MT_POSITION_X);
> +			int prv_y = input_mt_get_value(slot, ABS_MT_POSITION_Y);
> +			/* valid releases occurs when the last x and y positions
> +			 * are the same as the last known touch. */
> +			if (!input_mt_is_active(slot) ||
> +			    prv_x != s->x || prv_y != s->y)
> +				return;
> +		}
> +
>  		if (slotnum < 0 || slotnum >= td->maxcontacts)
>  			return;
>  
> @@ -681,8 +693,8 @@ static void mt_post_parse_default_settings(struct mt_device *td)
>  {
>  	__s32 quirks = td->mtclass.quirks;
>  
> -	/* unknown serial device needs special quirks */
> -	if (td->touches_by_report == 1) {
> +	/* unknown serial devices or win8 ones need special quirks */
> +	if (td->touches_by_report == 1 || quirks & MT_QUIRK_WIN_8_CERTIFIED) {
>  		quirks |= MT_QUIRK_ALWAYS_VALID;
>  		quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
>  		quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
> -- 
> 1.7.11.7
> 

Henrik

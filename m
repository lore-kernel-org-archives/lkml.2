Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0ICOHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:07:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:32994 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab0ICOHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:07:43 -0400
Date: Fri, 3 Sep 2010 16:07:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Michael Poole <mdpoole@troilus.org>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7 v3] HID: magicmouse: simplify touch data bit
 manipulation
In-Reply-To: <1283306184-28833-4-git-send-email-chase.douglas@canonical.com>
Message-ID: <alpine.LNX.2.00.1009031607330.26813@pobox.suse.cz>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com> <1283306184-28833-4-git-send-email-chase.douglas@canonical.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Aug 2010, Chase Douglas wrote:

> The new format should be easier to read to determine which bits
> correspond to which data. It also brings all the manipulation logic to
> the top of the function. This makes size and orientation reading more
> clear.
> 
> Note that the impetus for this change is the forthcoming support for the
> Magic Trackpad, which has a different touch data protocol.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Acked-by: Michael Poole <mdpoole@troilus.org>

Applied, thanks.

> ---
>  drivers/hid/hid-magicmouse.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 8a2fe78..2ee59a8 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -166,18 +166,21 @@ static void magicmouse_emit_buttons(struct magicmouse_sc *msc, int state)
>  static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tdata)
>  {
>  	struct input_dev *input = msc->input;
> -	__s32 x_y = tdata[0] << 8 | tdata[1] << 16 | tdata[2] << 24;
> -	int misc = tdata[5] | tdata[6] << 8;
> -	int id = (misc >> 6) & 15;
> -	int x = x_y << 12 >> 20;
> -	int y = -(x_y >> 20);
> -	int down = (tdata[7] & TOUCH_STATE_MASK) != TOUCH_STATE_NONE;
> +	int id = (tdata[6] << 2 | tdata[5] >> 6) & 0xf;
> +	int x = (tdata[1] << 28 | tdata[0] << 20) >> 20;
> +	int y = -((tdata[2] << 24 | tdata[1] << 16) >> 20);
> +	int size = tdata[5] & 0x3f;
> +	int orientation = (tdata[6] >> 2) - 32;
> +	int touch_major = tdata[3];
> +	int touch_minor = tdata[4];
> +	int state = tdata[7] & TOUCH_STATE_MASK;
> +	int down = state != TOUCH_STATE_NONE;
>  
>  	/* Store tracking ID and other fields. */
>  	msc->tracking_ids[raw_id] = id;
>  	msc->touches[id].x = x;
>  	msc->touches[id].y = y;
> -	msc->touches[id].size = misc & 63;
> +	msc->touches[id].size = size;
>  
>  	/* If requested, emulate a scroll wheel by detecting small
>  	 * vertical touch motions.
> @@ -188,7 +191,7 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>  		int step_y = msc->touches[id].scroll_y - y;
>  
>  		/* Calculate and apply the scroll motion. */
> -		switch (tdata[7] & TOUCH_STATE_MASK) {
> +		switch (state) {
>  		case TOUCH_STATE_START:
>  			msc->touches[id].scroll_x = x;
>  			msc->touches[id].scroll_y = y;
> @@ -224,13 +227,11 @@ static void magicmouse_emit_touch(struct magicmouse_sc *msc, int raw_id, u8 *tda
>  
>  	/* Generate the input events for this touch. */
>  	if (report_touches && down) {
> -		int orientation = (misc >> 10) - 32;
> -
>  		msc->touches[id].down = 1;
>  
>  		input_report_abs(input, ABS_MT_TRACKING_ID, id);
> -		input_report_abs(input, ABS_MT_TOUCH_MAJOR, tdata[3]);
> -		input_report_abs(input, ABS_MT_TOUCH_MINOR, tdata[4]);
> +		input_report_abs(input, ABS_MT_TOUCH_MAJOR, touch_major);
> +		input_report_abs(input, ABS_MT_TOUCH_MINOR, touch_minor);
>  		input_report_abs(input, ABS_MT_ORIENTATION, orientation);
>  		input_report_abs(input, ABS_MT_POSITION_X, x);
>  		input_report_abs(input, ABS_MT_POSITION_Y, y);
> -- 
> 1.7.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

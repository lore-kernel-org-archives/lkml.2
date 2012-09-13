Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2IMG5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:57:31 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37058 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab2IMG52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:57:28 -0400
Date: Wed, 12 Sep 2012 23:57:24 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 13/20] Input: bcm5974 - Drop pressure and width
 emulation
Message-ID: <20120913065723.GH17105@core.coreip.homeip.net>
References: <1346528835-363-1-git-send-email-rydberg@euromail.se>
 <1346528835-363-14-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346528835-363-14-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 09:47:08PM +0200, Henrik Rydberg wrote:
> The ABS_PRESSURE and ABS_WIDTH have special scales, and were initially
> added solely for thumb and palm recognition in the synaptics driver.
> This never really get used, however, and userspace quickly moved to
> MT solutions instead. This patch drops the unused events.

How can you know that? There could still be people using ST emulation
with this device. I think we should keep it.

Thanks.

> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/input/mouse/bcm5974.c | 26 +++++---------------------
>  1 file changed, 5 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
> index 2de974c..e033d3a 100644
> --- a/drivers/input/mouse/bcm5974.c
> +++ b/drivers/input/mouse/bcm5974.c
> @@ -417,10 +417,6 @@ static void setup_events_to_report(struct input_dev *input_dev,
>  {
>  	__set_bit(EV_ABS, input_dev->evbit);
>  
> -	input_set_abs_params(input_dev, ABS_PRESSURE,
> -				0, cfg->p.dim, cfg->p.fuzz, 0);
> -	input_set_abs_params(input_dev, ABS_TOOL_WIDTH,
> -				0, cfg->w.dim, cfg->w.fuzz, 0);
>  	input_set_abs_params(input_dev, ABS_X,
>  				0, cfg->x.dim, cfg->x.fuzz, 0);
>  	input_set_abs_params(input_dev, ABS_Y,
> @@ -504,9 +500,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
>  	const struct bcm5974_config *c = &dev->cfg;
>  	const struct tp_finger *f;
>  	struct input_dev *input = dev->input;
> -	int raw_p, raw_w, raw_x, raw_y, raw_n, i;
> +	int raw_p, raw_x, raw_y, raw_n, i;
>  	int ptest, origin, ibt = 0, nmin = 0, nmax = 0;
> -	int abs_p = 0, abs_w = 0, abs_x = 0, abs_y = 0;
> +	int abs_x = 0, abs_y = 0;
>  
>  	if (size < c->tp_offset || (size - c->tp_offset) % SIZEOF_FINGER != 0)
>  		return -EIO;
> @@ -523,22 +519,19 @@ static int report_tp_state(struct bcm5974 *dev, int size)
>  			report_finger_data(input, c, &f[i]);
>  
>  		raw_p = raw2int(f->touch_major);
> -		raw_w = raw2int(f->tool_major);
>  		raw_x = raw2int(f->abs_x);
>  		raw_y = raw2int(f->abs_y);
>  
>  		dprintk(9,
>  			"bcm5974: "
> -			"raw: p: %+05d w: %+05d x: %+05d y: %+05d n: %d\n",
> -			raw_p, raw_w, raw_x, raw_y, raw_n);
> +			"raw: p: %+05d x: %+05d y: %+05d n: %d\n",
> +			raw_p, raw_x, raw_y, raw_n);
>  
>  		ptest = int2bound(&c->p, raw_p);
>  		origin = raw2int(f->origin);
>  
>  		/* while tracking finger still valid, count all fingers */
>  		if (ptest > PRESSURE_LOW && origin) {
> -			abs_p = ptest;
> -			abs_w = int2bound(&c->w, raw_w);
>  			abs_x = int2bound(&c->x, raw_x - c->x.devmin);
>  			abs_y = int2bound(&c->y, c->y.devmax - raw_y);
>  			while (raw_n--) {
> @@ -568,18 +561,9 @@ static int report_tp_state(struct bcm5974 *dev, int size)
>  	input_report_key(input, BTN_TOOL_TRIPLETAP, dev->fingers == 3);
>  	input_report_key(input, BTN_TOOL_QUADTAP, dev->fingers > 3);
>  
> -	input_report_abs(input, ABS_PRESSURE, abs_p);
> -	input_report_abs(input, ABS_TOOL_WIDTH, abs_w);
> -
> -	if (abs_p) {
> +	if (dev->fingers > 0) {
>  		input_report_abs(input, ABS_X, abs_x);
>  		input_report_abs(input, ABS_Y, abs_y);
> -
> -		dprintk(8,
> -			"bcm5974: abs: p: %+05d w: %+05d x: %+05d y: %+05d "
> -			"nmin: %d nmax: %d n: %d ibt: %d\n", abs_p, abs_w,
> -			abs_x, abs_y, nmin, nmax, dev->fingers, ibt);
> -
>  	}
>  
>  	/* type 2 reports button events via ibt only */
> -- 
> 1.7.12
> 

-- 
Dmitry

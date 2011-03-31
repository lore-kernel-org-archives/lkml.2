Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab1CaBgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 21:36:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59646 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1CaBgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 21:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=POLTRVTou3cA3VAM7n8DvCBa56i7Dx5V3vhSydL1txUNuD/1FwN6I8yVN+PQPnbTRm
         aPBMIEvELdnMT2Odi+cJhCB9RLxgRDSBY26C568jELDKCmhaCI1eAXAgP01TgsbsiQSC
         gqoUfqrwnNU3E0kbav0CSjFtcF3Ej9XLuDHUc=
Date: Thu, 31 Mar 2011 09:36:02 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: wanlong.gao@gmail.com
Cc: khali@linux-fr.org, broonie@opensource.wolfsonmicro.com,
        rpurdie@linux.intel.com, w.sang@pengutronix.de,
        dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH V2] Add the support of the touchscreen keypad of
 tsc2007 .
Message-ID: <20110331013600.GA3163@gmail.com>
Mail-Followup-To: wanlong.gao@gmail.com, khali@linux-fr.org,
	broonie@opensource.wolfsonmicro.com, rpurdie@linux.intel.com,
	w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
References: <1301219192-5293-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301219192-5293-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 05:46:32PM +0800, wanlong.gao@gmail.com wrote:
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Many touchscreens support touch-keypad .
> Open the definition of the TOUCHSCREEN_TSC2007_WITH_KEYPAD, you can
> open the support of the touchscreen's keypad .
> We can add the support of the touchscreen keypad in the driver.
> In this patch , add the ts_key_pos array to determine the position
> of the key's X. And the ts_key_sensitivity can use to detemine the
> key's sensitivity. You can modify the ts_key_pos array for you own
> touchscreen keys . And modify the ts_key_sensitivity for you own
> key's sensitivity .
> If you want to modify the ts_key_map, change the position of the
> keys ,too.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Reviewed-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  drivers/input/touchscreen/tsc2007.c |   48 +++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
> index 80467f2..8f70fca 100644
> --- a/drivers/input/touchscreen/tsc2007.c
> +++ b/drivers/input/touchscreen/tsc2007.c
> @@ -83,6 +83,51 @@ struct tsc2007 {
>  	void			(*clear_penirq)(void);
>  };
>  
> +/*
> +#define	TOUCHSCREEN_TSC2007_WITH_KEYPAD
> +*/
> +#ifndef	TOUCHSCREEN_TSC2007_WITH_KEYPAD
> +static void ts_key_set_capacity(struct input_dev *input) {};
> +static void ts_key_up(struct input_dev *input) {};
> +static void ts_key_event(struct input_dev *input, u16 x, u16 y) {};
> +#else
> +static int ts_key_pos[] = {700, 1650, 2550, 3500};
> +static int ts_key_map[] = {KEY_MENU, KEY_HOME, KEY_BACK, KEY_SEARCH};
> +/* you can modify this value to change the touch_key's sensitivity */
> +static int ts_key_sensitivity = 50;
> +
> +static void ts_key_set_capacity(struct input_dev *input)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(ts_key_map); i++) {
> +		input_set_capability(input, EV_KEY, ts_key_map[i]);
> +	}
You only have one statement after 'for-recycle', so it should program
like following.
for (i = 0; i < ARRAY_SIZE(ts_key_map); i++)
	input_set_capability(input, EV_KEY, ts_key_map[i]);
> +}
> +
> +/* you must have an input_sync() followed this func . */
> +static void ts_key_up(struct input_dev *input)
> +{
> +	int i;
> +	for (i = 0; i < ARRAY_SIZE(ts_key_map); i++) {
> +		input_report_key(input, ts_key_map[i], 0);
> +	}
for (i = 0; i < ARRAY_SIZE(ts_key_map); i++)
	input_report_key(input, ts_key_map[i], 0);
> +}
> +
> +static void ts_key_event(struct input_dev *input, u16 x, u16 y)
> +{
> +	int i;
> +	if (y > MAX_12BIT) {
> +		for (i = 0; i < ARRAY_SIZE(ts_key_pos); i++) {
> +			if ((x > (ts_key_pos[i] - ts_key_sensitivity)) &&
> +				(x < (ts_key_pos[i] + ts_key_sensitivity))) {
> +				input_report_key(input, ts_key_map[i], 1);
> +				input_sync(input);
> +			}
> +		}
> +	}
> +}
> +#endif
> +
>  static inline int tsc2007_xfer(struct tsc2007 *tsc, u8 cmd)
>  {
>  	s32 data;
> @@ -149,6 +194,7 @@ static void tsc2007_send_up_event(struct tsc2007 *tsc)
>  
>  	input_report_key(input, BTN_TOUCH, 0);
>  	input_report_abs(input, ABS_PRESSURE, 0);
> +	ts_key_up(input);
>  	input_sync(input);
>  }
>  
> @@ -201,6 +247,7 @@ static void tsc2007_work(struct work_struct *work)
>  		if (!ts->pendown) {
>  			dev_dbg(&ts->client->dev, "DOWN\n");
>  
> +			ts_key_event(input, tc.x, tc.y);
>  			input_report_key(input, BTN_TOUCH, 1);
>  			ts->pendown = true;
>  		}
> @@ -308,6 +355,7 @@ static int __devinit tsc2007_probe(struct i2c_client *client,
>  	input_set_abs_params(input_dev, ABS_X, 0, MAX_12BIT, 0, 0);
>  	input_set_abs_params(input_dev, ABS_Y, 0, MAX_12BIT, 0, 0);
>  	input_set_abs_params(input_dev, ABS_PRESSURE, 0, MAX_12BIT, 0, 0);
> +	ts_key_set_capacity(input_dev);
>  
>  	if (pdata->init_platform_hw)
>  		pdata->init_platform_hw();
> -- 
> 1.7.3
> 

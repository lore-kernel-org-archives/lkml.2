Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0LEJNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 04:13:04 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:50732 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab0LEJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 04:12:58 -0500
Message-ID: <4CFB5734.6080309@euromail.se>
Date: Sun, 05 Dec 2010 10:11:16 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kevin McNeely <kev@cypress.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Luotao Fu <l.fu@pengutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [v2] touchscreen Cypress TTSP G3 MTDEV Core Driver
References: <Kevin McNeely <kev@cypress.com> <1291428384-26364-1-git-send-email-kev@cypress.com>
In-Reply-To: <1291428384-26364-1-git-send-email-kev@cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PPAdc-00006H-CI.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PPAdc-00006H-CI cc074c47de442c47ba749bbc60847d18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2010 03:06 AM, Kevin McNeely wrote:

> Amended version of Cypress TTSP Gen3 Core Driver.
> Core Driver includes platform data definition file,
> core driver definition file, and core touchscreen
> touch handling of device data. Generates
> multi-touch input events.
> Amendments include changes recommended by reviewers
> of initial version.  Kconfig is for I2C and SPI modules
> including the core.
> 
> Signed-off-by: Kevin McNeely <kev@cypress.com>


Hi Kevin, please send full patches rather than diffs next round.

> @@ -87,8 +89,8 @@
>  
>  /* Touch structure */
>  struct cyttsp_touch {
> -	u16 x __attribute__ ((packed));
> -	u16 y __attribute__ ((packed));
> +	u8 x[2];
> +	u8 y[2];
>  	u8 z;
>  };


Any particular reason why this could not stay as u16?


> @@ -500,35 +492,27 @@ static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
>  	 * is missing from the current event
>  	 */
>  	for (id = 0; id < CY_NUM_TRK_ID; id++) {
> -		if (t->cur_trk[id].tch) {
> +		if (cur_trk[id].tch) {


Here tch is used as a bool, and yet the values CY_NTCH and CY_TCH exist, which
is inconsistent. Removing the defines reduces some lines and makes the code
easier to read.

>  			/* put active current track data */
>  			input_report_abs(ts->input,
> -				ABS_MT_TRACKING_ID, id);
> -			input_report_abs(ts->input,
> -				ABS_MT_WIDTH_MAJOR, t->cur_trk[id].w);
> +				ABS_MT_POSITION_X, cur_trk[id].x);
>  			input_report_abs(ts->input,
> -				ABS_MT_POSITION_X, t->cur_trk[id].x);
> +				ABS_MT_POSITION_Y, cur_trk[id].y);
>  			input_report_abs(ts->input,
> -				ABS_MT_POSITION_Y, t->cur_trk[id].y);
> -			input_report_abs(ts->input,
> -				ABS_MT_TOUCH_MAJOR, t->cur_trk[id].z);
> +				ABS_MT_TOUCH_MAJOR, cur_trk[id].z);
>  			input_mt_sync(ts->input);
>  
> -			dev_dbg(ts->dev, "%s: MT1: X=%d Y=%d Z=%d\n",
> -				__func__,
> -				t->cur_trk[id].x,
> -				t->cur_trk[id].y,
> -				t->cur_trk[id].z);
> -			/* save current track data into previous track data */
> -			ts->prv_trk[id] = t->cur_trk[id];
> +			dev_dbg(ts->dev, "%s: MT% 2d: X=%d Y=%d Z=%d\n",
> +				__func__, id,
> +				cur_trk[id].x,
> +				cur_trk[id].y,
> +				cur_trk[id].z);
> +			/* save current touch xy_data as previous track data */
> +			ts->prv_trk[id] = cur_trk[id];

>  			cnt++;
>  		} else if (ts->prv_trk[id].tch) {
>  			/* put lift-off previous track data */
>  			input_report_abs(ts->input,
> -				ABS_MT_TRACKING_ID, id);
> -			input_report_abs(ts->input,
> -				ABS_MT_WIDTH_MAJOR, ts->prv_trk[id].w);
> -			input_report_abs(ts->input,
>  				ABS_MT_POSITION_X, ts->prv_trk[id].x);
>  			input_report_abs(ts->input,
>  				ABS_MT_POSITION_Y, ts->prv_trk[id].y);
> @@ -536,11 +520,12 @@ static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
>  				ABS_MT_TOUCH_MAJOR, CY_NTCH);
>  			input_mt_sync(ts->input);
>  
> -			dev_dbg(ts->dev, "%s: MT1: X=%d Y=%d Z=%d lift-off\n",
> -				__func__,
> +			dev_dbg(ts->dev, "%s: MT% 2d: X=%d Y=%d Z=%d liftoff\n",
> +				__func__, id,
>  				ts->prv_trk[id].x,
>  				ts->prv_trk[id].y,
>  				CY_NTCH);
> +			/* clear previous touch indication */
>  			ts->prv_trk[id].tch = CY_NTCH;
>  			cnt++;
>  		}


There seems to be no reason to keep the debug code and setting of prk_trk[] in
different branches. Please simplify.

> @@ -551,27 +536,21 @@ static void handle_multi_touch(struct cyttsp_track_data *t, struct cyttsp *ts)
>  		input_sync(ts->input);
>  }
>  
> -static void cyttsp_get_xydata(struct cyttsp *ts,
> -	struct cyttsp_track_data *t,
> -	u8 id, u8 w, u16 x, u16 y, u8 z)
> -{
> -	struct cyttsp_trk *trk;
> -
> -	trk = &(t->cur_trk[id]);
> -	trk->tch = CY_TCH;
> -	trk->w = w;
> -	trk->x = x;
> -	trk->y = y;
> -	trk->z = z;
> -}
> -
> +/* read xy_data for all current touches */
>  static int cyttsp_xy_worker(struct cyttsp *ts)
>  {
>  	u8 cur_tch = 0;
>  	u8 tch;
> -	struct cyttsp_track_data trk;
> +	u8 id;
> +	u8 *x;
> +	u8 *y;
> +	u8 z;


Please move these to the loop, if the loop is really needed.

> +	struct cyttsp_trk cur_trk[CY_NUM_TRK_ID];
>  
> -	/* get event data from CYTTSP device */
> +	/* Get event data from CYTTSP device.
> +	 * The event data includes all data
> +	 * for all active touches.
> +	 */
>  	if (ttsp_read_block_data(ts,
>  		CY_REG_BASE, sizeof(struct cyttsp_xydata), &ts->xy_data))
>  		return 0;
> @@ -585,9 +564,11 @@ static int cyttsp_xy_worker(struct cyttsp *ts)
>  		if (cyttsp_hndshk(ts, ts->xy_data.hst_mode))
>  			return 0;
>  
> +	/* determine number of currently active touches */
>  	cur_tch = GET_NUM_TOUCHES(ts->xy_data.tt_stat);
>  
> -	if (ts->bus_ops->power_state == CY_IDLE_STATE)
> +	/* check for any error conditions */
> +	if (ts->power_state == CY_IDLE_STATE)
>  		return 0;
>  	else if (GET_BOOTLOADERMODE(ts->xy_data.tt_mode)) {
>  		return -1;
> @@ -605,44 +586,70 @@ static int cyttsp_xy_worker(struct cyttsp *ts)
>  		dev_dbg(ts->dev, "%s: Invalid buffer detected\n", __func__);
>  	}
>  
> -	/* process the touches */
> -	cyttsp_init_cur_trks(&trk);
> +	/* clear current touch tracking structures */
> +	memset(cur_trk, CY_NTCH, sizeof(cur_trk));
>  
> +	/* extract xy_data for all currently reported touches */
>  	for (tch = 0; tch < cur_tch; tch++) {
> -		cyttsp_get_xydata(ts, &trk,
> -			tch & 0x01 ?
> +		id = tch & 0x01 ?
>  			(*(ts->tch_map[tch].id) & 0x0F) :
> -			(*(ts->tch_map[tch].id) & 0xF0) >> 4,
> -			CY_SMALL_TOOL_WIDTH,
> -			be16_to_cpu((ts->tch_map[tch].tch)->x),
> -			be16_to_cpu((ts->tch_map[tch].tch)->y),
> -			(ts->tch_map[tch].tch)->z);
> +			(*(ts->tch_map[tch].id) & 0xF0) >> 4;
> +		x = (u8 *)&((ts->tch_map[tch].tch)->x);
> +		y = (u8 *)&((ts->tch_map[tch].tch)->y);
> +		z = (ts->tch_map[tch].tch)->z;
> +		cur_trk[id].tch = CY_TCH;
> +		cur_trk[id].x = ((u16)x[0] << 8) + x[1];
> +		cur_trk[id].y = ((u16)y[0] << 8) + y[1];
> +		cur_trk[id].z = z;
>  	}
>  
> -	handle_multi_touch(&trk, ts);
> +	/* provide input event signaling for each active touch */
> +	handle_multi_touch(cur_trk, ts);
>  
>  	return 0;
>  }


This change does not seem to actually simplify much. How likely is it that this
driver will support more than two fingers and still be using the type A
protocol? A function setting up cur_trk[] explicitly from the device data would
be cleaner.

Thanks,
Henrik


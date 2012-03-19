Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab2CSIY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:24:28 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:57932 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab2CSIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:24:26 -0400
X-SENDER-IP: [85.230.168.211]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhFSANjrZk9V5qjTPGdsb2JhbABCigOsRRkBAQEBNzSCCQEBBAEnExwcBwULCAMOOBQlChoTiAUJuT8TkAZjBJVnhX2DUYlC
X-IronPort-AV: E=Sophos;i="4.73,611,1325458800"; 
   d="scan'208";a="288573995"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 19 Mar 2012 09:26:53 +0100
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Iiro Valkonen <iiro.valkonen@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 12/20] Input: atmel_mxt_ts - simplify event reporting
Message-ID: <20120319082653.GB15965@polaris.bitmath.org>
References: <1331640263-18935-1-git-send-email-djkurtz@chromium.org>
 <1331640263-18935-13-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331640263-18935-13-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Instead of carrying around per-finger state in the driver instance, just
> report each finger as it arrives to the input layer, and let the input
> layer (evdev) hold the event state (which it does anyway).
> 
> Also, the atmel pad reports "amplitude", which is reported to userspace
> using the "PRESSURE" event type.  The variables now reflect this.
> 
> Note: this driver does not really do MT-B properly. Each input report
> (a goup of input events followed by a SYN_REPORT) only contains data for
> a single contact.  When multiple fingers are present on a device, each is
> properly reported in its own MT_SLOT.  However, there is only ever one
> MT_SLOT per SYN_REPORT.  This is fixed in a subsequent patch.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---

Simplification looking good overall, together with that later
patch. Please find some comments below.

>  drivers/input/touchscreen/atmel_mxt_ts.c |  122 +++++++++---------------------
>  1 files changed, 36 insertions(+), 86 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 4363511..fa692e5 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -194,6 +194,7 @@
>  #define MXT_BOOT_STATUS_MASK	0x3f
>  
>  /* Touch status */
> +#define MXT_UNGRIP		(1 << 0)
>  #define MXT_SUPPRESS		(1 << 1)
>  #define MXT_AMP			(1 << 2)
>  #define MXT_VECTOR		(1 << 3)
> @@ -238,14 +239,6 @@ struct mxt_message {
>  	u8 message[7];
>  };
>  
> -struct mxt_finger {
> -	int status;
> -	int x;
> -	int y;
> -	int area;
> -	int pressure;
> -};
> -
>  /* Each client has this additional data */
>  struct mxt_data {
>  	struct i2c_client *client;
> @@ -253,7 +246,6 @@ struct mxt_data {
>  	const struct mxt_platform_data *pdata;
>  	struct mxt_object *object_table;
>  	struct mxt_info info;
> -	struct mxt_finger finger[MXT_MAX_FINGER];
>  	unsigned int irq;
>  	unsigned int max_x;
>  	unsigned int max_y;
> @@ -526,97 +518,55 @@ static int mxt_write_object(struct mxt_data *data,
>  	return mxt_write_reg(data->client, reg + offset, 1, &val);
>  }
>  
> -static void mxt_input_report(struct mxt_data *data, int single_id)
> -{
> -	struct mxt_finger *finger = data->finger;
> -	struct input_dev *input_dev = data->input_dev;
> -	int status = finger[single_id].status;
> -	int finger_num = 0;
> -	int id;
> -
> -	for (id = 0; id < MXT_MAX_FINGER; id++) {
> -		if (!finger[id].status)
> -			continue;
> -
> -		input_mt_slot(input_dev, id);
> -		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
> -				finger[id].status != MXT_RELEASE);
> -
> -		if (finger[id].status != MXT_RELEASE) {
> -			finger_num++;
> -			input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR,
> -					finger[id].area);
> -			input_report_abs(input_dev, ABS_MT_POSITION_X,
> -					finger[id].x);
> -			input_report_abs(input_dev, ABS_MT_POSITION_Y,
> -					finger[id].y);
> -			input_report_abs(input_dev, ABS_MT_PRESSURE,
> -					finger[id].pressure);
> -		} else {
> -			finger[id].status = 0;
> -		}
> -	}
> -
> -	input_report_key(input_dev, BTN_TOUCH, finger_num > 0);
> -
> -	if (status != MXT_RELEASE) {
> -		input_report_abs(input_dev, ABS_X, finger[single_id].x);
> -		input_report_abs(input_dev, ABS_Y, finger[single_id].y);
> -		input_report_abs(input_dev,
> -				 ABS_PRESSURE, finger[single_id].pressure);
> -	}
> -
> -	input_sync(input_dev);
> -}
> -
>  static void mxt_input_touchevent(struct mxt_data *data,
> -				      struct mxt_message *message, int id)
> +				 struct mxt_message *message, int id)
>  {
> -	struct mxt_finger *finger = data->finger;
>  	struct device *dev = &data->client->dev;
> -	u8 status = message->message[0];
> +	struct input_dev *input_dev = data->input_dev;
> +	u8 status;
>  	int x;
>  	int y;
>  	int area;
> -	int pressure;
> -
> -	/* Check the touch is present on the screen */
> -	if (!(status & MXT_DETECT)) {
> -		if (status & MXT_RELEASE) {
> -			dev_dbg(dev, "[%d] released\n", id);
> -
> -			finger[id].status = MXT_RELEASE;
> -			mxt_input_report(data, id);
> -		}
> -		return;
> -	}
> -
> -	/* Check only AMP detection */
> -	if (!(status & (MXT_PRESS | MXT_MOVE)))
> -		return;
> +	int amplitude;
>  
> +	status = message->message[0];
>  	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
>  	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
>  	if (data->max_x < 1024)
> -		x = x >> 2;
> +		x >>= 2;
>  	if (data->max_y < 1024)
> -		y = y >> 2;
> +		y >>= 2;
>  
>  	area = message->message[4];
> -	pressure = message->message[5];
> -
> -	dev_dbg(dev, "[%d] %s x: %d, y: %d, area: %d\n", id,
> -		status & MXT_MOVE ? "moved" : "pressed",
> -		x, y, area);
> -
> -	finger[id].status = status & MXT_MOVE ?
> -				MXT_MOVE : MXT_PRESS;
> -	finger[id].x = x;
> -	finger[id].y = y;
> -	finger[id].area = area;
> -	finger[id].pressure = pressure;
> +	amplitude = message->message[5];
> +
> +	dev_dbg(dev,
> +		"[%d] %c%c%c%c%c%c%c%c x: %d y: %d area: %d amp: %d\n",
> +		id,
> +		(status & MXT_DETECT) ? 'D' : '.',
> +		(status & MXT_PRESS) ? 'P' : '.',
> +		(status & MXT_RELEASE) ? 'R' : '.',
> +		(status & MXT_MOVE) ? 'M' : '.',
> +		(status & MXT_VECTOR) ? 'V' : '.',
> +		(status & MXT_AMP) ? 'A' : '.',
> +		(status & MXT_SUPPRESS) ? 'S' : '.',
> +		(status & MXT_UNGRIP) ? 'U' : '.',
> +		x, y, area, amplitude);
> +
> +	input_mt_slot(input_dev, id);
> +	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
> +				   status & MXT_DETECT);
> +
> +	if (status & MXT_DETECT) {
> +		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
> +		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
> +		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
> +		/* TODO: This should really be sqrt(area) */
> +		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);

The functional relationship might not be perfect, but at least the
reported scale should match the position units, as several userspace
drivers depend on its accuracy. If the line size looks reasonable in
mtview, for instance, it should be fine.

> +	}
>  
> -	mxt_input_report(data, id);
> +	input_mt_report_pointer_emulation(input_dev, false);
> +	input_sync(input_dev);
>  }
>  
>  static irqreturn_t mxt_interrupt(int irq, void *dev_id)
> -- 

Thanks,
Henrik

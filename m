Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0JJPjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 11:39:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65365 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab0JJPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 11:38:58 -0400
Message-ID: <4CB1DDB3.1090503@cnpbagwell.com>
Date: Sun, 10 Oct 2010 10:37:23 -0500
From: Chris Bagwell <chris@cnpbagwell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Chase Douglas <chase.douglas@canonical.com>
CC: linux-input@vger.kernel.org, xorg-devel@lists.x.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: Re: [PATCH 1/3] Input: synaptics - add multitouch support
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com> <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
In-Reply-To: <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 09:57 AM, Chase Douglas wrote:
> Newer Synaptics devices support multitouch. It appears there is no touch
> tracking, so the non-slotted protocol is used.
>
> Multitouch mode is disabled by default because it makes click-and-drag
> on touchpads with integrated buttons even more difficult than it already
> is. Maybe if/when the X synaptics input module works around this issue
> we can enable it by default.

I don't have access to a clickpad and I'm trying to understand its 
unique issues better.  Can you give a little more information on how X 
synaptics driver behaves differently with MT enabled compared to how it 
behaves with MT disabled?

On non-clickpad's, the X/Y will always track close to first finger 
touch.  If clickpad's continue this behaviour in non-MT mode then I'd 
assume click-and-drag will only work if you touch the drag finger before 
the click finger.  If you click first then at best I'd expect extremely 
slow movement since it tracks close but not exactly to first finger.

Does MT mode change behaviour?  Your patch #3 description sounds like 
the non-MT packet tracks moving finger always and so it constantly 
swapping its finger meaning.  Off hand, I'd think that helps 
click-and-drag issue although it creates others.

As example of what issues it creates, I'd expect xf86-input-synaptics to 
go crazy with cursor jumps when its 2 finger gestures are turned off and 
you randomly touch an extra finger to touchpad since the meaning of 
ABS_X/ABS_Y is changing without warning to it (and it doesn't understand 
MT right now).

I agree with the other comments that we want to avoid options as much as 
possible.

>
> Credit goes to Tobyn Bertram for reverse engineering the protocol.
>
> Reported-by: Tobyn Bertram
> Signed-off-by: Chase Douglas<chase.douglas@canonical.com>
> ---
>   drivers/input/mouse/synaptics.c |   78 +++++++++++++++++++++++++++++++++++----
>   drivers/input/mouse/synaptics.h |    3 +
>   2 files changed, 73 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
> index 96b70a4..990598f 100644
> --- a/drivers/input/mouse/synaptics.c
> +++ b/drivers/input/mouse/synaptics.c
> @@ -44,6 +44,10 @@
>   #define YMIN_NOMINAL 1408
>   #define YMAX_NOMINAL 4448
>
> +static bool synaptics_multitouch;
> +module_param(synaptics_multitouch, bool, 0644);
> +MODULE_PARM_DESC(synaptics_multitouch,
> +		 "Enable multitouch mode on Synaptics devices");
>
>   /*****************************************************************************
>    *	Stuff we need even when we do not want native Synaptics support
> @@ -279,6 +283,22 @@ static void synaptics_set_rate(struct psmouse *psmouse, unsigned int rate)
>   	synaptics_mode_cmd(psmouse, priv->mode);
>   }
>
> +static void synaptics_set_multitouch_mode(struct psmouse *psmouse)
> +{
> +	static unsigned char param = 0xc8;
> +	struct synaptics_data *priv = psmouse->private;
> +
> +	if (!SYN_CAP_MULTITOUCH(priv->ext_cap_0c) || !synaptics_multitouch)
> +		return;
> +	if (psmouse_sliced_command(psmouse, SYN_QUE_MODEL))
> +		return;
> +	if (ps2_command(&psmouse->ps2dev,&param, PSMOUSE_CMD_SETRATE))
> +		return;
> +
> +	priv->multitouch = 1;
> +	printk(KERN_INFO "Synaptics: Multitouch mode enabled\n");
> +}
> +
>   /*****************************************************************************
>    *	Synaptics pass-through PS/2 port support
>    ****************************************************************************/
> @@ -362,18 +382,30 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
>   	memset(hw, 0, sizeof(struct synaptics_hw_state));
>
>   	if (SYN_MODEL_NEWABS(priv->model_id)) {
> -		hw->x = (((buf[3]&  0x10)<<  8) |
> -			 ((buf[1]&  0x0f)<<  8) |
> -			 buf[4]);
> -		hw->y = (((buf[3]&  0x20)<<  7) |
> -			 ((buf[1]&  0xf0)<<  4) |
> -			 buf[5]);
> -
> -		hw->z = buf[2];
>   		hw->w = (((buf[0]&  0x30)>>  2) |
>   			 ((buf[0]&  0x04)>>  1) |
>   			 ((buf[3]&  0x04)>>  2));
>
> +		if (SYN_MULTITOUCH(priv, hw)) {
> +			/* Multitouch data is half normal resolution */
> +			hw->x = (((buf[4]&  0x0f)<<  8) |
> +				 buf[1])<<  1;
> +			hw->y = (((buf[4]&  0xf0)<<  4) |
> +				 buf[2])<<  1;
> +
> +			hw->z = ((buf[3]&  0x30) |
> +				 (buf[5]&  0x0f))<<  1;
> +		} else {
> +			hw->x = (((buf[3]&  0x10)<<  8) |
> +				 ((buf[1]&  0x0f)<<  8) |
> +				 buf[4]);
> +			hw->y = (((buf[3]&  0x20)<<  7) |
> +				 ((buf[1]&  0xf0)<<  4) |
> +				 buf[5]);
> +
> +			hw->z = buf[2];
> +		}
> +
>   		hw->left  = (buf[0]&  0x01) ? 1 : 0;
>   		hw->right = (buf[0]&  0x02) ? 1 : 0;
>
> @@ -445,6 +477,18 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>
>   	synaptics_parse_hw_state(psmouse->packet, priv,&hw);
>
> +	if (SYN_MULTITOUCH(priv,&hw)) {
> +		if (hw.z>  0) {
> +			input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
> +			input_report_abs(dev, ABS_MT_POSITION_Y,
> +					 YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
> +			input_report_abs(dev, ABS_MT_PRESSURE, hw.z);
> +		}
> +
> +		input_mt_sync(dev);
> +		return;
> +	}
> +
>   	if (hw.scroll) {
>   		priv->scroll += hw.scroll;
>
> @@ -499,6 +543,12 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>   	if (hw.z>  0) {
>   		input_report_abs(dev, ABS_X, hw.x);
>   		input_report_abs(dev, ABS_Y, YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
> +		if (priv->multitouch) {
> +			input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
> +			input_report_abs(dev, ABS_MT_POSITION_Y,
> +					 YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
> +			input_report_abs(dev, ABS_MT_PRESSURE, hw.z);
> +		}
>   	}
>   	input_report_abs(dev, ABS_PRESSURE, hw.z);
>
> @@ -525,6 +575,8 @@ static void synaptics_process_packet(struct psmouse *psmouse)
>   	for (i = 0; i<  SYN_CAP_MULTI_BUTTON_NO(priv->ext_cap); i++)
>   		input_report_key(dev, BTN_0 + i, hw.ext_buttons&  (1<<  i));
>
> +	if (priv->multitouch)
> +		input_mt_sync(dev);

This mt_sync would seem more nature to be sent after ABS_MT_PRESSURE to 
match MT packet processing.

Chris

>   	input_sync(dev);
>   }
>
> @@ -605,6 +657,14 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>   			     YMIN_NOMINAL, priv->y_max ?: YMAX_NOMINAL, 0, 0);
>   	input_set_abs_params(dev, ABS_PRESSURE, 0, 255, 0, 0);
>
> +	if (priv->multitouch) {
> +		input_set_abs_params(dev, ABS_MT_POSITION_X, XMIN_NOMINAL,
> +				     priv->x_max ?: XMAX_NOMINAL, 0, 0);
> +		input_set_abs_params(dev, ABS_MT_POSITION_Y, YMIN_NOMINAL,
> +				     priv->y_max ?: YMAX_NOMINAL, 0, 0);
> +		input_set_abs_params(dev, ABS_MT_PRESSURE, 0, 255, 0, 0);
> +	}
> +
>   	if (SYN_CAP_PALMDETECT(priv->capabilities))
>   		input_set_abs_params(dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
>
> @@ -745,6 +805,8 @@ int synaptics_init(struct psmouse *psmouse)
>   		goto init_fail;
>   	}
>
> +	synaptics_set_multitouch_mode(psmouse);
> +
>   	priv->pkt_type = SYN_MODEL_NEWABS(priv->model_id) ? SYN_NEWABS : SYN_OLDABS;
>
>   	printk(KERN_INFO "Synaptics Touchpad, model: %ld, fw: %ld.%ld, id: %#lx, caps: %#lx/%#lx/%#lx\n",
> diff --git a/drivers/input/mouse/synaptics.h b/drivers/input/mouse/synaptics.h
> index b6aa7d2..5126c9c 100644
> --- a/drivers/input/mouse/synaptics.h
> +++ b/drivers/input/mouse/synaptics.h
> @@ -53,6 +53,7 @@
>   #define SYN_CAP_PRODUCT_ID(ec)		(((ec)&  0xff0000)>>  16)
>   #define SYN_CAP_CLICKPAD(ex0c)		((ex0c)&  0x100100)
>   #define SYN_CAP_MAX_DIMENSIONS(ex0c)	((ex0c)&  0x020000)
> +#define SYN_CAP_MULTITOUCH(ex0c)	((ex0c)&  0x080000)
>
>   /* synaptics modes query bits */
>   #define SYN_MODE_ABSOLUTE(m)		((m)&  (1<<  7))
> @@ -78,6 +79,7 @@
>   #define SYN_NEWABS_STRICT		1
>   #define SYN_NEWABS_RELAXED		2
>   #define SYN_OLDABS			3
> +#define SYN_MULTITOUCH(priv, hw)	((priv)->multitouch&&  (hw)->w == 2)
>
>   /*
>    * A structure to describe the state of the touchpad hardware (buttons and pad)
> @@ -110,6 +112,7 @@ struct synaptics_data {
>   	unsigned char pkt_type;			/* packet type - old, new, etc */
>   	unsigned char mode;			/* current mode byte */
>   	int scroll;
> +	int multitouch;				/* Whether device provides MT */
>   };
>
>   void synaptics_module_init(void);


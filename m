Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2EKLBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:01:08 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4065 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab2EKLBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:01:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: volokh84@gmail.com
Subject: Re: [PATCH] staging: media: go7007: Adlink MPG24 board issues
Date: Fri, 11 May 2012 13:00:00 +0200
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc3-tschai; KDE/4.7.4; x86_64; ; )
Cc: mchehab@infradead.org, gregkh@linuxfoundation.org, dhowells@redhat.com,
        rdunlap@xenotime.net, pete@sensoray.com, justinmattock@gmail.com,
        pradheep.sh@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Volokh Konstantin <my84@bk.ru>
References: <1336717117-13964-1-git-send-email-volokh84@gmail.com>
In-Reply-To: <1336717117-13964-1-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205111300.00516.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Volokh!

First of all, thanks for the patch!

Everything looks OK, except for one thing, see below...

On Fri May 11 2012 08:18:37 volokh84@gmail.com wrote:
> From: Volokh Konstantin <my84@bk.ru>
> 
> This issuses applyed only for Adlink MPG24 board with go7007
>  & wis2804, all whese changes was tested for continuos
>  load&restart mode
> 
> This is minimal changes needed for start up go7007&wis2804 to work correctly
>   in 3.4 branch
> 
> Changes:
>   - When go7007 reset device, i2c was not worked (need rewrite GPIO5)
>   - As wis2804 has i2c_addr=0x00/*really*/, so Need set I2C_CLIENT_TEN flag for validity
>   - some main nonzero initialization, rewrites with kzalloc instead kmalloc
>   - STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
>     failed v4l2_device_unregister with kernel panic (OOPS)
>   - some new v4l2 style features as call_all(...s_stream...) for using subdev calls
>   - wis-tw2804.ko module code was incompatible with 3.4 branch in initialization v4l2_subdev parts.
>     now i2c_get_clientdata(...) contains v4l2_subdev struct instead non standart wis_tw2804 struct

I would very much appreciate it if you could convert this tw2804 driver to
use the control framework instead. It will simplify it and since I am in the
process myself of converting all drivers to use the control framework it would be
very helpful indeed. See Documentation/video4linux/v4l2-controls.txt for more
information. A simple driver like drivers/media/video/wm8775.c will provide a
good example for you.

This driver really needs work to get it out of staging. An initial attempt was
made back in 2009 (http://www.spinics.net/lists/linux-media/msg10252.html), but
it was never finished, unfortunately.

Regards,

	Hans

> 
> Adds:
>   - Additional chipset tw2804 controls with: gain,auto gain,inputs[0,1],color kill,chroma gain,gain balances,
>     for all 4 channels (from tw2804.pdf)
>   - Power control for each 4 ADC (tw2804) up when s_stream(...,1), down otherwise
> 
>   Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
> ---
>  drivers/staging/media/go7007/README          |   18 +
>  drivers/staging/media/go7007/go7007-driver.c |   27 +-
>  drivers/staging/media/go7007/go7007-priv.h   |    2 +-
>  drivers/staging/media/go7007/go7007-usb.c    |    5 +-
>  drivers/staging/media/go7007/go7007-v4l2.c   |    7 +-
>  drivers/staging/media/go7007/wis-tw2804.c    |  512 ++++++++++++++++++--------
>  6 files changed, 407 insertions(+), 164 deletions(-)
> 
> diff --git a/drivers/staging/media/go7007/README b/drivers/staging/media/go7007/README
> index 48f4476..082a681 100644
> --- a/drivers/staging/media/go7007/README
> +++ b/drivers/staging/media/go7007/README
> @@ -5,6 +5,24 @@ Todo:
>  	  and added to the build.
>  	- testing?
>  	- handle churn in v4l layer.
> +	- Some features for wis-tw2804 subdev control (comb filter,motion detector sensitive & mask,more over...)
> +	- go7007-v4l2.c need rewrite with new v4l2 style without nonstandart IO controls (set detector & bitrate)
> +
> +05/05/2012 3.4.0-rc+:
> +Changes:
> +  - When go7007 reset device, i2c was not worked (need rewrite GPIO5)
> +  - As wis2804 has i2c_addr=0x00/*really*/, so Need set I2C_CLIENT_TEN flag for validity
> +  - Some main nonzero initialization, rewrites with kzalloc instead kmalloc
> +  - STATUS_SHUTDOWN was placed in incorrect place, so if firmware wasn`t loaded, we
> +    failed v4l2_device_unregister with kernel panic (OOPS)
> +  - Some new v4l2 style features as call_all(...s_stream...) for using subdev calls
> +  - wis-tw2804.ko module code was incompatible with 3.4.x branch in initialization v4l2_subdev parts.
> +    now i2c_get_clientdata(...) contains v4l2_subdev struct instead non standart wis_tw2804 struct
> +
> +Adds:
> +  - Additional chipset wis2804 controls with: gain,auto gain,inputs[0,1],color kill,chroma gain,gain balances,
> +    for all 4 channels (from tw2804.pdf)
> +  - Power control for each 4 ADC up when s_stream(...,1), down otherwise in wis-tw2804 module
>  
>  Please send patchs to Greg Kroah-Hartman <greg@kroah.com> and Cc: Ross
>  Cohen <rcohen@snurgle.org> as well.
> diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
> index ece2dd1..2dff9b5 100644
> --- a/drivers/staging/media/go7007/go7007-driver.c
> +++ b/drivers/staging/media/go7007/go7007-driver.c
> @@ -173,6 +173,11 @@ static int go7007_init_encoder(struct go7007 *go)
>  		go7007_write_addr(go, 0x3c82, 0x0001);
>  		go7007_write_addr(go, 0x3c80, 0x00fe);
>  	}
> +	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
> +		/* set GPIO5 to be an output, currently low */
> +		go7007_write_addr(go, 0x3c82, 0x0000);
> +		go7007_write_addr(go, 0x3c80, 0x00df);
> +	}
>  	return 0;
>  }
>  
> @@ -192,17 +197,23 @@ int go7007_reset_encoder(struct go7007 *go)
>  /*
>   * Attempt to instantiate an I2C client by ID, probably loading a module.
>   */
> -static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
> -			   int addr)
> +static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *const i2c)
>  {
>  	struct go7007 *go = i2c_get_adapdata(adapter);
>  	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
> +	struct i2c_board_info info;
> +
> +	memset(&info, 0, sizeof(info));
> +	strlcpy(info.type, i2c->type, sizeof(info.type));
> +	info.addr = i2c->addr;
>  
> -	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
> +	if (i2c->id == I2C_DRIVERID_WIS_TW2804)
> +		info.flags |= I2C_CLIENT_TEN;
> +	if (v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, NULL))
>  		return 0;
>  
> -	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
> -	return -1;
> +	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", i2c->type);
> +	return -EINVAL;
>  }
>  
>  /*
> @@ -238,9 +249,7 @@ int go7007_register_encoder(struct go7007 *go)
>  	}
>  	if (go->i2c_adapter_online) {
>  		for (i = 0; i < go->board_info->num_i2c_devs; ++i)
> -			init_i2c_module(&go->i2c_adapter,
> -					go->board_info->i2c_devs[i].type,
> -					go->board_info->i2c_devs[i].addr);
> +			init_i2c_module(&go->i2c_adapter, &go->board_info->i2c_devs[i]);
>  		if (go->board_id == GO7007_BOARDID_ADLINK_MPG24)
>  			i2c_clients_command(&go->i2c_adapter,
>  				DECODER_SET_CHANNEL, &go->channel_number);
> @@ -571,7 +580,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
>  	struct go7007 *go;
>  	int i;
>  
> -	go = kmalloc(sizeof(struct go7007), GFP_KERNEL);
> +	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
>  	if (go == NULL)
>  		return NULL;
>  	go->dev = dev;
> diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
> index b58c394..b7b939a 100644
> --- a/drivers/staging/media/go7007/go7007-priv.h
> +++ b/drivers/staging/media/go7007/go7007-priv.h
> @@ -88,7 +88,7 @@ struct go7007_board_info {
>  	int audio_bclk_div;
>  	int audio_main_div;
>  	int num_i2c_devs;
> -	struct {
> +	struct go_i2c {
>  		const char *type;
>  		int id;
>  		int addr;
> diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
> index 5443e25..9dbf5ec 100644
> --- a/drivers/staging/media/go7007/go7007-usb.c
> +++ b/drivers/staging/media/go7007/go7007-usb.c
> @@ -1110,9 +1110,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
>  			} else {
>  				u16 channel;
>  
> -				/* set GPIO5 to be an output, currently low */
> -				go7007_write_addr(go, 0x3c82, 0x0000);
> -				go7007_write_addr(go, 0x3c80, 0x00df);
>  				/* read channel number from GPIO[1:0] */
>  				go7007_read_addr(go, 0x3c81, &channel);
>  				channel &= 0x3;
> @@ -1245,7 +1242,6 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
>  	struct urb *vurb, *aurb;
>  	int i;
>  
> -	go->status = STATUS_SHUTDOWN;
>  	usb_kill_urb(usb->intr_urb);
>  
>  	/* Free USB-related structs */
> @@ -1269,6 +1265,7 @@ static void go7007_usb_disconnect(struct usb_interface *intf)
>  	kfree(go->hpi_context);
>  
>  	go7007_remove(go);
> +	go->status = STATUS_SHUTDOWN;
>  }
>  
>  static struct usb_driver go7007_usb_driver = {
> diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
> index 3ef4cd8..e31b338 100644
> --- a/drivers/staging/media/go7007/go7007-v4l2.c
> +++ b/drivers/staging/media/go7007/go7007-v4l2.c
> @@ -100,7 +100,7 @@ static int go7007_open(struct file *file)
>  
>  	if (go->status != STATUS_ONLINE)
>  		return -EBUSY;
> -	gofh = kmalloc(sizeof(struct go7007_file), GFP_KERNEL);
> +	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
>  	if (gofh == NULL)
>  		return -ENOMEM;
>  	++go->ref_count;
> @@ -955,6 +955,7 @@ static int vidioc_streamon(struct file *file, void *priv,
>  	}
>  	mutex_unlock(&go->hw_lock);
>  	mutex_unlock(&gofh->lock);
> +	call_all(&go->v4l2_dev, video, s_stream, 1);
>  
>  	return retval;
>  }
> @@ -970,6 +971,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
>  	mutex_lock(&gofh->lock);
>  	go7007_streamoff(go);
>  	mutex_unlock(&gofh->lock);
> +	call_all(&go->v4l2_dev, video, s_stream, 0);
>  
>  	return 0;
>  }
> @@ -1834,5 +1836,6 @@ void go7007_v4l2_remove(struct go7007 *go)
>  	mutex_unlock(&go->hw_lock);
>  	if (go->video_dev)
>  		video_unregister_device(go->video_dev);
> -	v4l2_device_unregister(&go->v4l2_dev);
> +	if (go->status != STATUS_SHUTDOWN)
> +		v4l2_device_unregister(&go->v4l2_dev);
>  }
> diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
> index 9134f03..9afc5df 100644
> --- a/drivers/staging/media/go7007/wis-tw2804.c
> +++ b/drivers/staging/media/go7007/wis-tw2804.c
> @@ -21,16 +21,27 @@
>  #include <linux/videodev2.h>
>  #include <linux/ioctl.h>
>  #include <linux/slab.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-device.h>
>  
>  #include "wis-i2c.h"
>  
>  struct wis_tw2804 {
> -	int channel;
> +	struct v4l2_subdev sd;
> +	u8 channel:2;
> +	u8 input:1;
> +	u8 update:1;
> +	u8 auto_gain:1;
> +	u8 ckil:1;
>  	int norm;
> -	int brightness;
> -	int contrast;
> -	int saturation;
> -	int hue;
> +	u8 brightness;
> +	u8 contrast;
> +	u8 saturation;
> +	u8 hue;
> +	u8 gain;
> +	u8 cr_gain;
> +	u8 r_balance;
> +	u8 b_balance;
>  };
>  
>  static u8 global_registers[] = {
> @@ -41,6 +52,7 @@ static u8 global_registers[] = {
>  	0x3d, 0x80,
>  	0x3e, 0x82,
>  	0x3f, 0x82,
> +	0x78, 0x0f,
>  	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
>  };
>  
> @@ -103,29 +115,358 @@ static u8 channel_registers[] = {
>  	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
>  };
>  
> -static int write_reg(struct i2c_client *client, u8 reg, u8 value, int channel)
> +static s32 write_reg(struct i2c_client *client, u8 reg, u8 value, u8 channel)
>  {
>  	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
>  }
>  
> -static int write_regs(struct i2c_client *client, u8 *regs, int channel)
> +static int write_regs(struct i2c_client *client, u8 *regs, u8 channel)
>  {
>  	int i;
>  
>  	for (i = 0; regs[i] != 0xff; i += 2)
>  		if (i2c_smbus_write_byte_data(client,
>  				regs[i] | (channel << 6), regs[i + 1]) < 0)
> -			return -1;
> +			return -EINVAL;
>  	return 0;
>  }
>  
> +static s32 read_reg(struct i2c_client *client, u8 reg, u8 channel)
> +{
> +	return i2c_smbus_read_byte_data(client, (reg) | (channel << 6));
> +}
> +
> +static inline struct wis_tw2804 *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct wis_tw2804, sd);
> +}
> +
> +static int tw2804_log_status(struct v4l2_subdev *sd)
> +{
> +	struct wis_tw2804 *state = to_state(sd);
> +	v4l2_info(sd, "Standard: %s\n", state->norm == V4L2_STD_NTSC ? "NTSC" :
> +					state->norm == V4L2_STD_PAL ? "PAL" : "unknown");
> +	v4l2_info(sd, "Channel: %d\n", state->channel);
> +	v4l2_info(sd, "Input: %d\n", state->input);
> +	v4l2_info(sd, "Brightness: %d\n", state->brightness);
> +	v4l2_info(sd, "Contrast: %d\n", state->contrast);
> +	v4l2_info(sd, "Saturation: %d\n", state->saturation);
> +	v4l2_info(sd, "Hue: %d\n", state->hue);
> +	return 0;
> +}
> +
> +static int tw2804_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *query)
> +{
> +	static const u32 user_ctrls[] = {
> +		V4L2_CID_USER_CLASS,
> +		V4L2_CID_BRIGHTNESS,
> +		V4L2_CID_CONTRAST,
> +		V4L2_CID_SATURATION,
> +		V4L2_CID_HUE,
> +		V4L2_CID_AUTOGAIN,
> +		V4L2_CID_COLOR_KILLER,
> +		V4L2_CID_GAIN,
> +		V4L2_CID_CHROMA_GAIN,
> +		V4L2_CID_BLUE_BALANCE,
> +		V4L2_CID_RED_BALANCE,
> +		0
> +	};
> +
> +	static const u32 *ctrl_classes[] = {
> +		user_ctrls,
> +		NULL
> +	};
> +
> +	query->id = v4l2_ctrl_next(ctrl_classes, query->id);
> +
> +	switch (query->id) {
> +	case V4L2_CID_USER_CLASS:
> +		return v4l2_ctrl_query_fill(query, 0, 0, 0, 0);
> +	case V4L2_CID_BRIGHTNESS:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
> +	case V4L2_CID_CONTRAST:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
> +	case V4L2_CID_SATURATION:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
> +	case V4L2_CID_HUE:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
> +	case V4L2_CID_AUTOGAIN:
> +		return v4l2_ctrl_query_fill(query, 0, 1, 1, 0);
> +	case V4L2_CID_COLOR_KILLER:
> +		return v4l2_ctrl_query_fill(query, 0, 1, 1, 0);
> +	case V4L2_CID_GAIN:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
> +	case V4L2_CID_CHROMA_GAIN:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 128);
> +	case V4L2_CID_BLUE_BALANCE:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 122);
> +	case V4L2_CID_RED_BALANCE:
> +		return v4l2_ctrl_query_fill(query, 0, 255, 1, 122);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +s32 get_ctrl_addr(int ctrl)
> +{
> +	switch (ctrl) {
> +	case V4L2_CID_BRIGHTNESS:
> +		return 0x12;
> +	case V4L2_CID_CONTRAST:
> +		return 0x11;
> +	case V4L2_CID_SATURATION:
> +		return 0x10;
> +	case V4L2_CID_HUE:
> +		return 0x0f;
> +	case V4L2_CID_AUTOGAIN:
> +		return 0x02;
> +	case V4L2_CID_COLOR_KILLER:
> +		return 0x14;
> +	case V4L2_CID_GAIN:
> +		return 0x3c;
> +	case V4L2_CID_CHROMA_GAIN:
> +		return 0x3d;
> +	case V4L2_CID_RED_BALANCE:
> +		return 0x3f;
> +	case V4L2_CID_BLUE_BALANCE:
> +		return 0x3e;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int tw2804_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct wis_tw2804 *state = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	s32 addr = get_ctrl_addr(ctrl->id);
> +	s32 val = 0;
> +
> +	if (addr == -EINVAL)
> +		return -EINVAL;
> +
> +	if (state->update) {
> +		val = read_reg(client, addr, ctrl->id == V4L2_CID_GAIN ||
> +					ctrl->id == V4L2_CID_CHROMA_GAIN ||
> +					ctrl->id == V4L2_CID_RED_BALANCE ||
> +					ctrl->id == V4L2_CID_BLUE_BALANCE ? 0 : state->channel);
> +		if (val < 0)
> +			return val;
> +	}
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_BRIGHTNESS:
> +		if (state->update)
> +			state->brightness = val;
> +		ctrl->value = state->brightness;
> +		break;
> +	case V4L2_CID_CONTRAST:
> +		if (state->update)
> +			state->contrast = val;
> +		ctrl->value = state->contrast;
> +		break;
> +	case V4L2_CID_SATURATION:
> +		if (state->update)
> +			state->saturation = val;
> +		ctrl->value = state->saturation;
> +		break;
> +	case V4L2_CID_HUE:
> +		if (state->update)
> +			state->hue = val;
> +		ctrl->value = state->hue;
> +		break;
> +	case V4L2_CID_AUTOGAIN:
> +		if (state->update)
> +			state->auto_gain = val & (1<<7) ? 1 : 0;
> +		ctrl->value = state->auto_gain;
> +		break;
> +	case V4L2_CID_COLOR_KILLER:
> +		if (state->update)
> +			state->ckil = (val & 0x03) == 0x03 ? 1 : 0;
> +		ctrl->value = state->ckil;
> +		break;
> +	case V4L2_CID_GAIN:
> +		if (state->update)
> +			state->gain = val;
> +		ctrl->value = state->gain;
> +		break;
> +	case V4L2_CID_CHROMA_GAIN:
> +		if (state->update)
> +			state->cr_gain = val;
> +		ctrl->value = state->cr_gain;
> +		break;
> +	case V4L2_CID_RED_BALANCE:
> +		if (state->update)
> +			state->r_balance = val;
> +		ctrl->value = state->r_balance;
> +		break;
> +	case V4L2_CID_BLUE_BALANCE:
> +		if (state->update)
> +			state->b_balance = val;
> +		ctrl->value = state->b_balance;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	state->update = 0;
> +	return 0;
> +}
> +
> +static int tw2804_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct wis_tw2804 *dec = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	s32 reg = 0;
> +	s32 addr = get_ctrl_addr(ctrl->id);
> +
> +	if (addr == -EINVAL)
> +		return -EINVAL;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUTOGAIN:
> +		reg = read_reg(client, addr, dec->channel);
> +		if (reg > 0) {
> +			if (ctrl->value == 0)
> +				ctrl->value = reg & ~(1<<7);
> +			else
> +				ctrl->value = reg | 1<<7;
> +		} else
> +			return reg;
> +		break;
> +	case V4L2_CID_COLOR_KILLER:
> +		reg = read_reg(client, addr, dec->channel);
> +		if (reg > 0)
> +			ctrl->value = (reg & ~(0x03)) | (ctrl->value == 0 ? 0x02 : 0x03);
> +		else
> +			return reg;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	ctrl->value = ctrl->value > 255 ? 255 : (ctrl->value < 0 ? 0 : ctrl->value);
> +	reg = write_reg(client, addr, (u8)ctrl->value, ctrl->id == V4L2_CID_GAIN ||
> +						ctrl->id == V4L2_CID_CHROMA_GAIN ||
> +						ctrl->id == V4L2_CID_RED_BALANCE ||
> +						ctrl->id == V4L2_CID_BLUE_BALANCE ? 0 : dec->channel);
> +
> +	if (reg < 0) {
> +		v4l2_err(&dec->sd, "Can`t set_ctrl value:id=%d;value=%d\n", ctrl->id, ctrl->value);
> +		return reg;
> +	}
> +
> +	dec->update = 1;
> +	return tw2804_g_ctrl(sd, ctrl);
> +}
> +
> +static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> +{
> +	struct wis_tw2804 *dec = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	u8 regs[] = {
> +		0x01, norm&V4L2_STD_NTSC ? 0xc4 : 0x84,
> +		0x09, norm&V4L2_STD_NTSC ? 0x07 : 0x04,
> +		0x0a, norm&V4L2_STD_NTSC ? 0xf0 : 0x20,
> +		0x0b, norm&V4L2_STD_NTSC ? 0x07 : 0x04,
> +		0x0c, norm&V4L2_STD_NTSC ? 0xf0 : 0x20,
> +		0x0d, norm&V4L2_STD_NTSC ? 0x40 : 0x4a,
> +		0x16, norm&V4L2_STD_NTSC ? 0x00 : 0x40,
> +		0x17, norm&V4L2_STD_NTSC ? 0x00 : 0x40,
> +		0x20, norm&V4L2_STD_NTSC ? 0x07 : 0x0f,
> +		0x21, norm&V4L2_STD_NTSC ? 0x07 : 0x0f,
> +		0xff, 0xff,
> +	};
> +	write_regs(client, regs, dec->channel);
> +	dec->norm = norm;
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_core_ops tw2804_core_ops = {
> +	.log_status = tw2804_log_status,
> +	.g_ctrl = tw2804_g_ctrl,
> +	.s_ctrl = tw2804_s_ctrl,
> +	.queryctrl = tw2804_queryctrl,
> +	.s_std = tw2804_s_std,
> +};
> +
> +static int tw2804_s_video_routing(struct v4l2_subdev *sd, u32 input, u32 output,
> +	u32 config)
> +{
> +	struct wis_tw2804 *dec = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	s32 reg = 0;
> +
> +	if (0 > input || input > 1)
> +		return -EINVAL;
> +
> +	if (input == dec->input && !dec->update)
> +		return 0;
> +
> +	reg = read_reg(client, 0x22, dec->channel);
> +
> +	if (reg >= 0) {
> +		if (input == 0)
> +			reg &= ~(1<<2);
> +		else
> +			reg |= 1<<2;
> +		reg = write_reg(client, 0x22, (u8)reg, dec->channel);
> +	}
> +
> +	if (reg >= 0) {
> +		dec->input = input;
> +		dec->update = 0;
> +	} else
> +		return reg;
> +	return 0;
> +}
> +
> +static int tw2804_s_mbus_fmt(struct v4l2_subdev *sd,
> +	struct v4l2_mbus_framefmt *fmt)
> +{
> +	/*TODO need select between 3fmt:
> +	 * bt_656,
> +	 * bt_601_8bit,
> +	 * bt_656_dual,
> +	 */
> +	return 0;
> +}
> +
> +int tw2804_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct wis_tw2804 *dec = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	u32 reg = read_reg(client, 0x78, 0);
> +
> +	if (enable == 1)
> +		write_reg(client, 0x78, reg & ~(1<<dec->channel), 0);
> +	else
> +		write_reg(client, 0x78, reg | (1<<dec->channel), 0);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops tw2804_video_ops = {
> +	.s_routing = tw2804_s_video_routing,
> +	.s_mbus_fmt = tw2804_s_mbus_fmt,
> +	.s_stream = tw2804_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops tw2804_ops = {
> +	.core = &tw2804_core_ops,
> +	.video = &tw2804_video_ops,
> +};
> +
>  static int wis_tw2804_command(struct i2c_client *client,
>  				unsigned int cmd, void *arg)
>  {
> -	struct wis_tw2804 *dec = i2c_get_clientdata(client);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct wis_tw2804 *dec = to_state(sd);
> +	int *input;
>  
>  	if (cmd == DECODER_SET_CHANNEL) {
> -		int *input = arg;
> +		input = arg;
>  
>  		if (*input < 0 || *input > 3) {
>  			printk(KERN_ERR "wis-tw2804: channel %d is not "
> @@ -154,139 +495,6 @@ static int wis_tw2804_command(struct i2c_client *client,
>  				"channel number is set\n", cmd);
>  		return 0;
>  	}
> -
> -	switch (cmd) {
> -	case VIDIOC_S_STD:
> -	{
> -		v4l2_std_id *input = arg;
> -		u8 regs[] = {
> -			0x01, *input & V4L2_STD_NTSC ? 0xc4 : 0x84,
> -			0x09, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
> -			0x0a, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
> -			0x0b, *input & V4L2_STD_NTSC ? 0x07 : 0x04,
> -			0x0c, *input & V4L2_STD_NTSC ? 0xf0 : 0x20,
> -			0x0d, *input & V4L2_STD_NTSC ? 0x40 : 0x4a,
> -			0x16, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
> -			0x17, *input & V4L2_STD_NTSC ? 0x00 : 0x40,
> -			0x20, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
> -			0x21, *input & V4L2_STD_NTSC ? 0x07 : 0x0f,
> -			0xff,	0xff,
> -		};
> -		write_regs(client, regs, dec->channel);
> -		dec->norm = *input;
> -		break;
> -	}
> -	case VIDIOC_QUERYCTRL:
> -	{
> -		struct v4l2_queryctrl *ctrl = arg;
> -
> -		switch (ctrl->id) {
> -		case V4L2_CID_BRIGHTNESS:
> -			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -			strncpy(ctrl->name, "Brightness", sizeof(ctrl->name));
> -			ctrl->minimum = 0;
> -			ctrl->maximum = 255;
> -			ctrl->step = 1;
> -			ctrl->default_value = 128;
> -			ctrl->flags = 0;
> -			break;
> -		case V4L2_CID_CONTRAST:
> -			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -			strncpy(ctrl->name, "Contrast", sizeof(ctrl->name));
> -			ctrl->minimum = 0;
> -			ctrl->maximum = 255;
> -			ctrl->step = 1;
> -			ctrl->default_value = 128;
> -			ctrl->flags = 0;
> -			break;
> -		case V4L2_CID_SATURATION:
> -			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -			strncpy(ctrl->name, "Saturation", sizeof(ctrl->name));
> -			ctrl->minimum = 0;
> -			ctrl->maximum = 255;
> -			ctrl->step = 1;
> -			ctrl->default_value = 128;
> -			ctrl->flags = 0;
> -			break;
> -		case V4L2_CID_HUE:
> -			ctrl->type = V4L2_CTRL_TYPE_INTEGER;
> -			strncpy(ctrl->name, "Hue", sizeof(ctrl->name));
> -			ctrl->minimum = 0;
> -			ctrl->maximum = 255;
> -			ctrl->step = 1;
> -			ctrl->default_value = 128;
> -			ctrl->flags = 0;
> -			break;
> -		}
> -		break;
> -	}
> -	case VIDIOC_S_CTRL:
> -	{
> -		struct v4l2_control *ctrl = arg;
> -
> -		switch (ctrl->id) {
> -		case V4L2_CID_BRIGHTNESS:
> -			if (ctrl->value > 255)
> -				dec->brightness = 255;
> -			else if (ctrl->value < 0)
> -				dec->brightness = 0;
> -			else
> -				dec->brightness = ctrl->value;
> -			write_reg(client, 0x12, dec->brightness, dec->channel);
> -			break;
> -		case V4L2_CID_CONTRAST:
> -			if (ctrl->value > 255)
> -				dec->contrast = 255;
> -			else if (ctrl->value < 0)
> -				dec->contrast = 0;
> -			else
> -				dec->contrast = ctrl->value;
> -			write_reg(client, 0x11, dec->contrast, dec->channel);
> -			break;
> -		case V4L2_CID_SATURATION:
> -			if (ctrl->value > 255)
> -				dec->saturation = 255;
> -			else if (ctrl->value < 0)
> -				dec->saturation = 0;
> -			else
> -				dec->saturation = ctrl->value;
> -			write_reg(client, 0x10, dec->saturation, dec->channel);
> -			break;
> -		case V4L2_CID_HUE:
> -			if (ctrl->value > 255)
> -				dec->hue = 255;
> -			else if (ctrl->value < 0)
> -				dec->hue = 0;
> -			else
> -				dec->hue = ctrl->value;
> -			write_reg(client, 0x0f, dec->hue, dec->channel);
> -			break;
> -		}
> -		break;
> -	}
> -	case VIDIOC_G_CTRL:
> -	{
> -		struct v4l2_control *ctrl = arg;
> -
> -		switch (ctrl->id) {
> -		case V4L2_CID_BRIGHTNESS:
> -			ctrl->value = dec->brightness;
> -			break;
> -		case V4L2_CID_CONTRAST:
> -			ctrl->value = dec->contrast;
> -			break;
> -		case V4L2_CID_SATURATION:
> -			ctrl->value = dec->saturation;
> -			break;
> -		case V4L2_CID_HUE:
> -			ctrl->value = dec->hue;
> -			break;
> -		}
> -		break;
> -	}
> -	default:
> -		break;
> -	}
>  	return 0;
>  }
>  
> @@ -295,21 +503,28 @@ static int wis_tw2804_probe(struct i2c_client *client,
>  {
>  	struct i2c_adapter *adapter = client->adapter;
>  	struct wis_tw2804 *dec;
> +	struct v4l2_subdev *sd;
>  
>  	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -ENODEV;
>  
> -	dec = kmalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
> +	dec = kzalloc(sizeof(struct wis_tw2804), GFP_KERNEL);
> +
>  	if (dec == NULL)
>  		return -ENOMEM;
> -
> +	sd = &dec->sd;
> +	dec->update = 1;
>  	dec->channel = -1;
>  	dec->norm = V4L2_STD_NTSC;
>  	dec->brightness = 128;
>  	dec->contrast = 128;
>  	dec->saturation = 128;
>  	dec->hue = 128;
> -	i2c_set_clientdata(client, dec);
> +	dec->gain = 128;
> +	dec->cr_gain = 128;
> +	dec->b_balance = 122;
> +	dec->r_balance = 122;
> +	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
>  
>  	printk(KERN_DEBUG "wis-tw2804: creating TW2804 at address %d on %s\n",
>  		client->addr, adapter->name);
> @@ -319,9 +534,10 @@ static int wis_tw2804_probe(struct i2c_client *client,
>  
>  static int wis_tw2804_remove(struct i2c_client *client)
>  {
> -	struct wis_tw2804 *dec = i2c_get_clientdata(client);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
>  
> -	kfree(dec);
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
>  	return 0;
>  }
>  
> 

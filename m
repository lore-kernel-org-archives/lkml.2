Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2IJIuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:50:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49150 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab2IJIuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:50:14 -0400
Date: Mon, 10 Sep 2012 11:48:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Volokh Konstantin <volokh84@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
Subject: Re: [PATCH 01/10] staging: media: go7007: Some additional code for
 TW2804 driver functionality
Message-ID: <20120910084834.GH19396@mwanda>
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345632319-23224-1-git-send-email-volokh84@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch got corrupted somewhere so it doesn't apply.  There are
some minor style issues as well.

On Wed, Aug 22, 2012 at 02:45:10PM +0400, Volokh Konstantin wrote:
> - using new v4l2 framework controls
> - function for reading volatile controls via i2c bus
> - separate V4L2_CID_ ctrls into each V4L2 calls
> 
> Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
> ---
>  drivers/staging/media/go7007/wis-tw2804.c |  248 +++++++++++++++++++++++++++++
>  1 files changed, 248 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/media/go7007/wis-tw2804.c b/drivers/staging/media/go7007/wis-tw2804.c
> index 9134f03..05851d3 100644
> --- a/drivers/staging/media/go7007/wis-tw2804.c
> +++ b/drivers/staging/media/go7007/wis-tw2804.c
> @@ -21,10 +21,18 @@
>  #include <linux/videodev2.h>
>  #include <linux/ioctl.h>
>  #include <linux/slab.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-ctrls.h>
>  
>  #include "wis-i2c.h"
>  
>  struct wis_tw2804 {
> +	struct v4l2_subdev sd;
> +	struct v4l2_ctrl_handler hdl;
> +	u8 channel:2;
> +	u8 input:1;
>  	int channel;
>  	int norm;
>  	int brightness;
> @@ -116,9 +124,246 @@ static int write_regs(struct i2c_client *client, u8 *regs, int channel)
>  		if (i2c_smbus_write_byte_data(client,
>  				regs[i] | (channel << 6), regs[i + 1]) < 0)
>  			return -1;
> +static s32 read_reg(struct i2c_client *client, u8 reg, u8 channel)
> +{

Look at the five lines above.  This patch introduces a new function
in the middle of an existing function.

> +	return i2c_smbus_read_byte_data(client, (reg) | (channel << 6));
> +}
> +
> +inline struct wis_tw2804 *to_state(struct v4l2_subdev *sd)

Should this be static?  Otherwise the name is very generic.

> +{
> +	return container_of(sd, struct wis_tw2804, sd);
> +}
> +
> +inline struct wis_tw2804 *to_state_from_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	return container_of(ctrl->handler, struct wis_tw2804, hdl);
> +}
> +
> +static int tw2804_log_status(struct v4l2_subdev *sd)
> +{
> +	struct wis_tw2804 *state = to_state(sd);

Blank line here.

> +	v4l2_info(sd, "Standard: %s\n",
> +			state->norm == V4L2_STD_NTSC ? "NTSC" :
> +			state->norm == V4L2_STD_PAL ? "PAL" : "unknown");
> +	v4l2_info(sd, "Channel: %d\n", state->channel);
> +	v4l2_info(sd, "Input: %d\n", state->input);
> +	v4l2_ctrl_handler_log_status(&state->hdl, sd->name);
> +	return 0;
> +}
> +
> +static s32 get_ctrl_addr(int ctrl)

Just use int instead of s32.  s32 and int are the same but s32 is
only needed in special circumstances.  It is for when the hardware
or protocol specifies a signed 32 bit.  You use it throughout
instead of using ints.

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
> +static int tw2804_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = &to_state_from_ctrl(ctrl)->sd;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	s32 addr = get_ctrl_addr(ctrl->id);
> +
> +	if (addr == -EINVAL)
> +		return -EINVAL;

This should be:
	if (addr < 0)
		return addr;

> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +	case V4L2_CID_CHROMA_GAIN:
> +	case V4L2_CID_RED_BALANCE:
> +	case V4L2_CID_BLUE_BALANCE:
> +		ctrl->cur.val = read_reg(client, addr, 0);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int tw2804_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct wis_tw2804 *state = to_state_from_ctrl(ctrl);
> +	struct v4l2_subdev *sd = &state->sd;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	s32 reg = ctrl->val;
> +	s32 addr = get_ctrl_addr(ctrl->id);
> +
> +	if (addr == -EINVAL)
> +		return -EINVAL;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUTOGAIN:
> +		reg = read_reg(client, addr, state->channel);
> +		if (reg > 0) {
> +			if (ctrl->val == 0)
> +				reg &= ~(1<<7);
> +			else
> +				reg |= 1<<7;

Spaces around the operations:
				reg &= ~(1 << 7);
			else
				reg |= 1 << 7;

> +		} else
> +			return reg;
> +		break;
> +	case V4L2_CID_COLOR_KILLER:
> +		reg = read_reg(client, addr, state->channel);
> +		if (reg > 0)
> +			reg = (reg & ~(0x03)) | (ctrl->val == 0 ? 0x02 : 0x03);
> +		else
> +			return reg;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	reg = reg > 255 ? 255 : (reg < 0 ? 0 : reg);
> +	reg = write_reg(client, addr, (u8)reg,
                                      ^^^^
Not needed.



> +			ctrl->id == V4L2_CID_GAIN ||
> +			ctrl->id == V4L2_CID_CHROMA_GAIN ||
> +			ctrl->id == V4L2_CID_RED_BALANCE ||
> +			ctrl->id == V4L2_CID_BLUE_BALANCE ? 0 : state->channel);
> +
> +	if (reg < 0) {
> +		v4l2_err(sd, "Can`t set_ctrl value:id=%d;value=%d\n", ctrl->id,
> +								    ctrl->val);
> +		return reg;
> +	}
> +	return 0;
> +}
> +
> +static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
> +{
> +	struct wis_tw2804 *dec = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +

No blank line here.

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

This is hard to read without proper white space:
		0x01, norm & V4L2_STD_NTSC ? 0xc4 : 0x84,
		0x09, norm & V4L2_STD_NTSC ? 0x07 : 0x04,

> +		0xff, 0xff,
> +	};

Put a blank line here.

> +	write_regs(client, regs, dec->channel);
> +	dec->norm = norm;
> +	return 0;
> +}
> +
> +static int tw2804_g_chip_ident(struct v4l2_subdev *sd,
> +				struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	return v4l2_chip_ident_i2c_client(client, chip,
> +					V4L2_IDENT_TW2804, 0x0e);
> +}
> +
> +static const struct v4l2_ctrl_ops tw2804_ctrl_ops = {
> +	.g_volatile_ctrl = tw2804_g_volatile_ctrl,
> +	.s_ctrl = tw2804_s_ctrl,
> +};
> +
> +static const struct v4l2_subdev_core_ops tw2804_core_ops = {
> +	.log_status = tw2804_log_status,
> +	.g_chip_ident = tw2804_g_chip_ident,
> +	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
> +	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
> +	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> +	.g_ctrl = v4l2_subdev_g_ctrl,
> +	.s_ctrl = v4l2_subdev_s_ctrl,
> +	.queryctrl = v4l2_subdev_queryctrl,
> +	.querymenu = v4l2_subdev_querymenu,
> +	.s_std = tw2804_s_std,
> +};
> +
> +static int tw2804_s_video_routing(struct v4l2_subdev *sd, u32 input, u32 output,
> +	u32 config)
> +{
> +	struct wis_tw2804 *dec = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	s32 reg = 0;

The initialization is not needed here.

> +
> +	if (0 > input || input > 1)
> +		return -EINVAL;
> +
> +	if (input == dec->input)
> +		return 0;
> +
> +	reg = read_reg(client, 0x22, dec->channel);

Move the error handling next to the function call.  It makes the
code simpler and you can pull everything in an indent level.

	reg = read_reg(client, 0x22, dec->channel);
	if (reg < 0)
		return reg;

	if (input == 0)
		reg &= ~(1 << 2);
	else
		reg |= 1 << 2;

	reg = write_reg(client, 0x22, reg, dec->channel);
	if (reg < 0)
		return reg;

	dec->input = input;
	return 0;

regards,
dan carpenter

> +
> +	if (reg >= 0) {
> +		if (input == 0)
> +			reg &= ~(1<<2);
> +		else
> +			reg |= 1<<2;
> +		reg = write_reg(client, 0x22, (u8)reg, dec->channel);
> +	}
> +
> +	if (reg >= 0)
> +		dec->input = input;
> +	else
> +		return reg;
>  	return 0;
>  }
>  
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
> +static int tw2804_s_stream(struct v4l2_subdev *sd, int enable)
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
> @@ -355,3 +600,6 @@ module_init(wis_tw2804_init);
>  module_exit(wis_tw2804_cleanup);
>  
>  MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("TW2804/TW2802 V4L2 i2c driver");
> +MODULE_AUTHOR("Volokh Konstantin <volokh84@gmail.com>");
> +MODULE_AUTHOR("Micronas USA Inc");
> -- 
> 1.7.7.6
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

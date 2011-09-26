Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1IZKIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:08:12 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2052 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1IZKIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:08:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Deepthy Ravi <deepthy.ravi@ti.com>
Subject: Re: [PATCH 3/8] tvp514x: Migrate to media-controller framework
Date: Mon, 26 Sep 2011 12:06:42 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-4.slh.3-aptosid-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mchehab@infradead.org,
        laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
        Vaibhav Hiremath <hvaibhav@ti.com>
References: <1315488900-16106-1-git-send-email-deepthy.ravi@ti.com>
In-Reply-To: <1315488900-16106-1-git-send-email-deepthy.ravi@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261206.43076.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for the late reply, I'm plowing through weeks of backlog...)

On Thursday, September 08, 2011 15:35:00 Deepthy Ravi wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> Migrate tvp5146 driver to media controller framework. The
> driver registers as a sub-device entity to MC framwork
> and sub-device to V4L2 layer. The default format code was
> V4L2_MBUS_FMT_YUYV10_2X10. Changed it to V4L2_MBUS_FMT_UYVY8_2X8

Does this mean that the old 2X10 format code is no longer used?
This change basically not just sets a new default format code but removes
the old format code as well. Is that really intended?

If someone else is using that old format already, then this change may well
break his board.

Regards,

	Hans


> and hence added the new format code to ccdc and isp format
> arrays.
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Deepthy Ravi <deepthy.ravi@ti.com>
> ---
>  drivers/media/video/omap3isp/ispccdc.c  |    1 +
>  drivers/media/video/omap3isp/ispvideo.c |    3 +
>  drivers/media/video/tvp514x.c           |  241 ++++++++++++++++++++++++++++---
>  include/media/v4l2-subdev.h             |    7 +-
>  4 files changed, 222 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
> index 9d3459d..d58fe45 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -57,6 +57,7 @@ static const unsigned int ccdc_fmts[] = {
>  	V4L2_MBUS_FMT_SRGGB12_1X12,
>  	V4L2_MBUS_FMT_SBGGR12_1X12,
>  	V4L2_MBUS_FMT_SGBRG12_1X12,
> +	V4L2_MBUS_FMT_UYVY8_2X8,
>  };
>  
>  /*
> diff --git a/drivers/media/video/omap3isp/ispvideo.c b/drivers/media/video/omap3isp/ispvideo.c
> index fd965ad..d5b8236 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -100,6 +100,9 @@ static struct isp_format_info formats[] = {
>  	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
>  	  V4L2_MBUS_FMT_YUYV8_1X16, 0,
>  	  V4L2_PIX_FMT_YUYV, 16, },
> +	{ V4L2_MBUS_FMT_UYVY8_2X8, V4L2_MBUS_FMT_UYVY8_2X8,
> +	  V4L2_MBUS_FMT_UYVY8_2X8, 0,
> +	  V4L2_PIX_FMT_UYVY, 16, },
>  };
>  
>  const struct isp_format_info *
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 9b3e828..10f3e87 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -32,11 +32,14 @@
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/videodev2.h>
> +#include <linux/v4l2-mediabus.h>
>  
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
> -#include <media/v4l2-mediabus.h>
>  #include <media/v4l2-chip-ident.h>
> +#include <media/v4l2-subdev.h>
> +#include <media/v4l2-ctrls.h>
> +
>  #include <media/v4l2-ctrls.h>
>  #include <media/tvp514x.h>
>  
> @@ -78,6 +81,8 @@ struct tvp514x_std_info {
>  	unsigned long height;
>  	u8 video_std;
>  	struct v4l2_standard standard;
> +	unsigned int mbus_code;
> +	struct v4l2_mbus_framefmt format;
>  };
>  
>  static struct tvp514x_reg tvp514x_reg_list_default[0x40];
> @@ -101,6 +106,7 @@ struct tvp514x_decoder {
>  	struct v4l2_ctrl_handler hdl;
>  	struct tvp514x_reg tvp514x_regs[ARRAY_SIZE(tvp514x_reg_list_default)];
>  	const struct tvp514x_platform_data *pdata;
> +	struct media_pad pad;
>  
>  	int ver;
>  	int streaming;
> @@ -207,29 +213,46 @@ static struct tvp514x_reg tvp514x_reg_list_default[] = {
>  static const struct tvp514x_std_info tvp514x_std_list[] = {
>  	/* Standard: STD_NTSC_MJ */
>  	[STD_NTSC_MJ] = {
> -	 .width = NTSC_NUM_ACTIVE_PIXELS,
> -	 .height = NTSC_NUM_ACTIVE_LINES,
> -	 .video_std = VIDEO_STD_NTSC_MJ_BIT,
> -	 .standard = {
> -		      .index = 0,
> -		      .id = V4L2_STD_NTSC,
> -		      .name = "NTSC",
> -		      .frameperiod = {1001, 30000},
> -		      .framelines = 525
> -		     },
> -	/* Standard: STD_PAL_BDGHIN */
> +		.width = NTSC_NUM_ACTIVE_PIXELS,
> +		.height = NTSC_NUM_ACTIVE_LINES,
> +		.video_std = VIDEO_STD_NTSC_MJ_BIT,
> +		.mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
> +		.standard = {
> +			.index = 0,
> +			.id = V4L2_STD_NTSC,
> +			.name = "NTSC",
> +			.frameperiod = {1001, 30000},
> +			.framelines = 525
> +		},
> +		.format = {
> +			.width = NTSC_NUM_ACTIVE_PIXELS,
> +			.height = NTSC_NUM_ACTIVE_LINES,
> +			.code = V4L2_MBUS_FMT_UYVY8_2X8,
> +			.field = V4L2_FIELD_INTERLACED,
> +			.colorspace = V4L2_COLORSPACE_SMPTE170M,
> +		}
> +
>  	},
> +	/* Standard: STD_PAL_BDGHIN */
>  	[STD_PAL_BDGHIN] = {
> -	 .width = PAL_NUM_ACTIVE_PIXELS,
> -	 .height = PAL_NUM_ACTIVE_LINES,
> -	 .video_std = VIDEO_STD_PAL_BDGHIN_BIT,
> -	 .standard = {
> -		      .index = 1,
> -		      .id = V4L2_STD_PAL,
> -		      .name = "PAL",
> -		      .frameperiod = {1, 25},
> -		      .framelines = 625
> -		     },
> +		.width = PAL_NUM_ACTIVE_PIXELS,
> +		.height = PAL_NUM_ACTIVE_LINES,
> +		.video_std = VIDEO_STD_PAL_BDGHIN_BIT,
> +		.mbus_code = V4L2_MBUS_FMT_UYVY8_2X8,
> +		.standard = {
> +			.index = 1,
> +			.id = V4L2_STD_PAL,
> +			.name = "PAL",
> +			.frameperiod = {1, 25},
> +			.framelines = 625
> +		},
> +		.format = {
> +			.width = PAL_NUM_ACTIVE_PIXELS,
> +			.height = PAL_NUM_ACTIVE_LINES,
> +			.code = V4L2_MBUS_FMT_UYVY8_2X8,
> +			.field = V4L2_FIELD_INTERLACED,
> +			.colorspace = V4L2_COLORSPACE_SMPTE170M,
> +		},
>  	},
>  	/* Standard: need to add for additional standard */
>  };
> @@ -792,7 +815,7 @@ tvp514x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
>  	if (index)
>  		return -EINVAL;
>  
> -	*code = V4L2_MBUS_FMT_YUYV10_2X10;
> +	*code = V4L2_MBUS_FMT_UYVY8_2X8;
>  	return 0;
>  }
>  
> @@ -815,7 +838,7 @@ tvp514x_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
>  	/* Calculate height and width based on current standard */
>  	current_std = decoder->current_std;
>  
> -	f->code = V4L2_MBUS_FMT_YUYV10_2X10;
> +	f->code = V4L2_MBUS_FMT_UYVY8_2X8;
>  	f->width = decoder->std_list[current_std].width;
>  	f->height = decoder->std_list[current_std].height;
>  	f->field = V4L2_FIELD_INTERLACED;
> @@ -952,11 +975,154 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int enable)
>  	return err;
>  }
>  
> +static int tvp514x_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct tvp514x_decoder *decoder = to_decoder(sd);
> +
> +	if (decoder->pdata && decoder->pdata->s_power)
> +		return decoder->pdata->s_power(sd, on);
> +
> +	return 0;
> +}
> +
> +/*
> +* tvp514x_enum_mbus_code - V4L2 sensor interface handler for pad_ops
> +* @subdev: pointer to standard V4L2 sub-device structure
> +* @fh: pointer to standard V4L2 sub-device file handle
> +* @code: pointer to v4l2_subdev_pad_mbus_code_enum structure
> +*/
> +static int tvp514x_enum_mbus_code(struct v4l2_subdev *subdev,
> +		struct v4l2_subdev_fh *fh,
> +		struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	if (code->index >= ARRAY_SIZE(tvp514x_std_list))
> +		return -EINVAL;
> +	code->code = V4L2_MBUS_FMT_UYVY8_2X8;
> +
> +	return 0;
> +}
> +
> +static int tvp514x_get_pad_format(struct v4l2_subdev *subdev,
> +		struct v4l2_subdev_fh *fh,
> +		struct v4l2_subdev_format *fmt)
> +{
> +	struct tvp514x_decoder *decoder = to_decoder(subdev);
> +	enum tvp514x_std current_std;
> +
> +	/* query the current standard */
> +	current_std = tvp514x_query_current_std(subdev);
> +	if (current_std == STD_INVALID) {
> +		v4l2_err(subdev, "Unable to query std\n");
> +		return -EINVAL;
> +	}
> +
> +	fmt->format = decoder->std_list[current_std].format;
> +
> +	return 0;
> +}
> +
> +static int tvp514x_set_pad_format(struct v4l2_subdev *subdev,
> +		struct v4l2_subdev_fh *fh,
> +		struct v4l2_subdev_format *fmt)
> +{
> +	struct tvp514x_decoder *decoder = to_decoder(subdev);
> +	enum tvp514x_std current_std;
> +
> +	/* query the current standard */
> +	current_std = tvp514x_query_current_std(subdev);
> +	if (current_std == STD_INVALID) {
> +		v4l2_err(subdev, "Unable to query std\n");
> +		return -EINVAL;
> +	}
> +
> +	fmt->format.width = decoder->std_list[current_std].width;
> +	fmt->format.height = decoder->std_list[current_std].height;
> +	fmt->format.code = V4L2_MBUS_FMT_UYVY8_2X8;
> +	fmt->format.field = V4L2_FIELD_INTERLACED;
> +	fmt->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	return 0;
> +}
> +
> +static int tvp514x_enum_frame_size(struct v4l2_subdev *subdev,
> +		struct v4l2_subdev_fh *fh,
> +		struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct tvp514x_decoder *decoder = to_decoder(subdev);
> +	enum tvp514x_std current_std;
> +
> +	if (fse->code != V4L2_MBUS_FMT_UYVY8_2X8)
> +		return -EINVAL;
> +
> +	/* query the current standard */
> +	current_std = tvp514x_query_current_std(subdev);
> +	if (current_std == STD_INVALID) {
> +		v4l2_err(subdev, "Unable to query std\n");
> +		return -EINVAL;
> +	}
> +
> +	fse->min_width = decoder->std_list[current_std].width;
> +	fse->min_height = decoder->std_list[current_std].height;
> +	fse->max_width = fse->min_width;
> +	fse->max_height = fse->min_height;
> +
> +	return 0;
> +}
> +
> +/*
> +* V4L2 subdev internal operations
> +*/
> +static int tvp514x_registered(struct v4l2_subdev *subdev)
> +{
> +	enum tvp514x_std current_std;
> +
> +	tvp514x_s_stream(subdev, 1);
> +	/* query the current standard */
> +	current_std = tvp514x_query_current_std(subdev);
> +	if (current_std == STD_INVALID) {
> +		v4l2_err(subdev, "Unable to query std\n");
> +		return -EINVAL;
> +	}
> +
> +	tvp514x_s_stream(subdev, 0);
> +
> +	return 0;
> +}
> +
> +static int tvp514x_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
> +{
> +	enum tvp514x_std current_std;
> +
> +	tvp514x_s_stream(subdev, 1);
> +	/* query the current standard */
> +	current_std = tvp514x_query_current_std(subdev);
> +	if (current_std == STD_INVALID) {
> +		v4l2_err(subdev, "Unable to query std\n");
> +		return -EINVAL;
> +	}
> +
> +	tvp514x_s_stream(subdev, 0);
> +
> +	return 0;
> +}
> +
> +/*
> +* V4L2 subdev core operations
> +*/
> +static int tvp514x_g_chip_ident(struct v4l2_subdev *subdev,
> +				struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(subdev);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TVP5146, 0);
> +}
> +
>  static const struct v4l2_ctrl_ops tvp514x_ctrl_ops = {
>  	.s_ctrl = tvp514x_s_ctrl,
>  };
>  
>  static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
> +	.g_chip_ident = tvp514x_g_chip_ident,
>  	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
>  	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
>  	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
> @@ -965,6 +1131,12 @@ static const struct v4l2_subdev_core_ops tvp514x_core_ops = {
>  	.queryctrl = v4l2_subdev_queryctrl,
>  	.querymenu = v4l2_subdev_querymenu,
>  	.s_std = tvp514x_s_std,
> +	.s_power = tvp514x_s_power,
> +};
> +
> +static struct v4l2_subdev_internal_ops tvp514x_subdev_internal_ops = {
> +	.registered	= tvp514x_registered,
> +	.open		= tvp514x_open,
>  };
>  
>  static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
> @@ -979,9 +1151,17 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
>  	.s_stream = tvp514x_s_stream,
>  };
>  
> +static const struct v4l2_subdev_pad_ops tvp514x_pad_ops = {
> +	.enum_mbus_code = tvp514x_enum_mbus_code,
> +	.enum_frame_size = tvp514x_enum_frame_size,
> +	.get_fmt = tvp514x_get_pad_format,
> +	.set_fmt = tvp514x_set_pad_format,
> +};
> +
>  static const struct v4l2_subdev_ops tvp514x_ops = {
>  	.core = &tvp514x_core_ops,
>  	.video = &tvp514x_video_ops,
> +	.pad = &tvp514x_pad_ops,
>  };
>  
>  static struct tvp514x_decoder tvp514x_dev = {
> @@ -1005,6 +1185,7 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>  	struct tvp514x_decoder *decoder;
>  	struct v4l2_subdev *sd;
> +	int ret;
>  
>  	/* Check if the adapter supports the needed features */
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> @@ -1046,6 +1227,17 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  	sd = &decoder->sd;
>  	v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
>  
> +	decoder->sd.internal_ops = &tvp514x_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	decoder->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	ret = media_entity_init(&decoder->sd.entity, 1, &decoder->pad, 0);
> +	if (ret < 0) {
> +		v4l2_err(client, "failed to register as a media entity!!\n");
> +		kfree(decoder);
> +		return ret;
> +	}
> +
>  	v4l2_ctrl_handler_init(&decoder->hdl, 5);
>  	v4l2_ctrl_new_std(&decoder->hdl, &tvp514x_ctrl_ops,
>  		V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
> @@ -1087,6 +1279,7 @@ static int tvp514x_remove(struct i2c_client *client)
>  
>  	v4l2_device_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(&decoder->hdl);
> +	media_entity_cleanup(&decoder->sd.entity);
>  	kfree(decoder);
>  	return 0;
>  }
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 257da1a..0e9aa30 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -514,9 +514,8 @@ struct v4l2_subdev_internal_ops {
>     stand-alone or embedded in a larger struct.
>   */
>  struct v4l2_subdev {
> -#if defined(CONFIG_MEDIA_CONTROLLER)
>  	struct media_entity entity;
> -#endif
> +
>  	struct list_head list;
>  	struct module *owner;
>  	u32 flags;
> @@ -547,16 +546,13 @@ struct v4l2_subdev {
>   */
>  struct v4l2_subdev_fh {
>  	struct v4l2_fh vfh;
> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  	struct v4l2_mbus_framefmt *try_fmt;
>  	struct v4l2_rect *try_crop;
> -#endif
>  };
>  
>  #define to_v4l2_subdev_fh(fh)	\
>  	container_of(fh, struct v4l2_subdev_fh, vfh)
>  
> -#if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>  static inline struct v4l2_mbus_framefmt *
>  v4l2_subdev_get_try_format(struct v4l2_subdev_fh *fh, unsigned int pad)
>  {
> @@ -568,7 +564,6 @@ v4l2_subdev_get_try_crop(struct v4l2_subdev_fh *fh, unsigned int pad)
>  {
>  	return &fh->try_crop[pad];
>  }
> -#endif
>  
>  extern const struct v4l2_file_operations v4l2_subdev_fops;
>  
> 

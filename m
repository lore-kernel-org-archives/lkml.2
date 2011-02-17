Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1BQJE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 04:04:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1BQJEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 04:04:54 -0500
Date: Thu, 17 Feb 2011 10:04:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Chew <achew@nvidia.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchehab@redhat.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v3 1/1] [media] ov9740: Initial submit of OV9740 driver.
In-Reply-To: <1297900360-2457-1-git-send-email-achew@nvidia.com>
Message-ID: <Pine.LNX.4.64.1102170945480.27679@axis700.grange>
References: <1297900360-2457-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Rmtzry/aNxDpbA2VUe6a/izMK46K5lY7PqjB397ZwoO
 NcoFLNWsyolhTJdwc7D6OOFsId+PzY1mBT8JKUivStUnW/sBsD
 sVirRNA9I55AIw2EfZFzt4JVC+JB8yhz+L6IYe3AMil1Alok7E
 XSmhlq/r0Y5QM3gwZ9dDqjibCiyehauf9UAxiKjXvywIN9PeS2
 IxbHG4POuCSjkSS44K3a1PtcROzkKhwuOvAkoLg+c4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew

Thanks for an update, looks much better now, still, a couple of things 
_have_ to be corrected before we can push it:

On Wed, 16 Feb 2011, achew@nvidia.com wrote:

> From: Andrew Chew <achew@nvidia.com>
> 
> This soc_camera driver is for Omnivision's OV9740 sensor.  This initial
> submission provides support for YUV422 output at 1280x720 (720p), which is
> the sensor's native resolution.  640x480 (VGA) is also supported, with
> cropping and scaling performed by the sensor's ISP.
> 
> This driver is heavily based off of the existing OV9640 driver.
> 
> Change-Id: I2f3b731e667a8f16df44e03eb5187176d3abb1f4
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> Applied all of the suggestions from Guennadi Liakhovetski, to wit:
> 
> Renamed to_ov9740_sensor macro to to_ov9740.
> Added spaces to the sides of comments.
> Some renaming of 1280x720 to 720P, and 640x480 to VGA.
> Added global array of supported resolutions and their extents.
> Fixed spacing problem with curly braces.
> Removed register arrays for the start and stop streaming register pokes.
> Removed IS_ERR_VALUE uses.
> Changed a set of tiny memcpy's to assignment operations.
> Renamed "ary" to "array" in all cases.
> Removed a comment accidentally carried over from the OV9640 regarding bus width.
> Renamed ov9740_set_res_code() to ov9740_set_res().
> Changed ov9740_try_fmt() to not return an error if format is not supported.
> Removed __devinit and __devexit.
> Fixed an endianness issue with reading the 16-bit model.
> Removed unnecessary "devname" variable in probe call.
> Implemented cropcap() and g_crop() methods.
> 
>  drivers/media/video/Kconfig     |    6 +
>  drivers/media/video/Makefile    |    1 +
>  drivers/media/video/ov9740.c    | 1013 +++++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-chip-ident.h |    1 +
>  4 files changed, 1021 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/ov9740.c
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index d40a8fc..52b6271 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig

> diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
> new file mode 100644
> index 0000000..e5eee66
> --- /dev/null
> +++ b/drivers/media/video/ov9740.c
> @@ -0,0 +1,1013 @@

[snip]

> +/* Start/Stop streaming from the device */
> +static int ov9740_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct ov9740_priv *priv = to_ov9740(sd);
> +	int ret;
> +
> +	/* Program orientation register. */
> +	if (priv->flag_vflip)
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0x2, 0);
> +	else
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0, 0x2);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (priv->flag_hflip)
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0x1, 0);
> +	else
> +		ret = ov9740_reg_rmw(client, OV9740_IMAGE_ORT, 0, 0x1);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (enable) {
> +		dev_info(&client->dev, "Enabling Streaming\n");

This

> +		ret = ov9740_reg_write(client, OV9740_MODE_SELECT, 0x01);
> +
> +	} else {
> +		dev_info(&client->dev, "Disabling Streaming\n");

and this dev_info() you might want to change to dev_dbg(). You don't want 
the driver to be too noisy. A couple more occasions below

> +		ret = ov9740_reg_write(client, OV9740_SOFTWARE_RESET, 0x01);
> +		if (ret < 0)
> +			return ret;
> +		ret = ov9740_reg_write(client, OV9740_MODE_SELECT, 0x00);

In the previous version you had comments for streamoff::

+	/* Software Reset */
and
+	/* Setting Streaming to Standby */

you can still use them now. Besides, the following is a bit shorter and I 
find it slightly better readable:

+		ret = ov9740_reg_write(client, OV9740_SOFTWARE_RESET, 0x01);
+		if (!ret)
+			ret = ov9740_reg_write(client, OV9740_MODE_SELECT, 0x00);

> +	}
> +
> +	return ret;
> +}
> +
> +/* Alter bus settings on camera side */
> +static int ov9740_set_bus_param(struct soc_camera_device *icd,
> +				unsigned long flags)
> +{
> +	return 0;
> +}
> +
> +/* Request bus settings on camera side */
> +static unsigned long ov9740_query_bus_param(struct soc_camera_device *icd)
> +{
> +	struct soc_camera_link *icl = to_soc_camera_link(icd);
> +
> +	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
> +		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
> +		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;

I asked you to use the platform data here... If you don't do that, then 
at least, please, preserve your comment from the original version:

+	/*
+	 * REVISIT: the camera probably can do 10 bit transfers, but I don't
+	 *          have those pins connected on my hardware.
+	 */

> +
> +	return soc_camera_apply_sensor_flags(icl, flags);
> +}

[snip]

> +/* Setup registers according to resolution and color encoding */
> +static int ov9740_set_res(struct i2c_client *client, u32 width,
> +			  enum v4l2_mbus_pixelcode code)
> +{

Why don't you just remove the "code" parameter as I proposed in my 
previous review? I don't see why you need it, and if it is ever needed, 
it can always be re-added.

> +	int ret;
> +
> +	/* select register configuration for given resolution */
> +	if (width == ov9740_resolutions[OV9740_VGA].width) {
> +		dev_info(&client->dev, "Setting image size to 640x480\n");

dev_dbg()

> +		ret = ov9740_reg_write_array(client, ov9740_regs_vga,
> +					     ARRAY_SIZE(ov9740_regs_vga));
> +	} else if (width == ov9740_resolutions[OV9740_720P].width) {
> +		dev_info(&client->dev, "Setting image size to 1280x720\n");

dev_dbg()

> +		ret = ov9740_reg_write_array(client, ov9740_regs_720p,
> +					     ARRAY_SIZE(ov9740_regs_720p));
> +	} else {
> +		dev_err(&client->dev, "Failed to select resolution!\n");
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}

> +static int ov9740_try_fmt(struct v4l2_subdev *sd,
> +			  struct v4l2_mbus_framefmt *mf)
> +{
> +	ov9740_res_roundup(&mf->width, &mf->height);
> +
> +	mf->field = V4L2_FIELD_NONE;
> +
> +	switch (mf->code) {
> +	case V4L2_MBUS_FMT_YUYV8_2X8:
> +		mf->colorspace = V4L2_COLORSPACE_SRGB;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;

Ok, this is the important one: sorry, this is not what I meant. You 
shouldn't fail try_fmt(), that's right, but you should _always_ return 
valid data from it. In your case you just can set mf->code and 
mf->colorspace always to your fixed values and remove the switch 
completely.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

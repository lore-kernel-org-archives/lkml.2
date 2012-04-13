Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab2DMHVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 03:21:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25725 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2DMHVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 03:21:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Fri, 13 Apr 2012 09:21:40 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 10/13] s5p-tv: Add DT-support for HDMI driver
In-reply-to: <1334256332-29867-11-git-send-email-k.lewandowsk@samsung.com>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        thomas.abraham@linaro.org, m.szyprowski@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        olof@lixom.net, kgene.kim@samsung.com,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <4F87D404.8060908@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310
 Thunderbird/11.0
References: <1334256332-29867-1-git-send-email-k.lewandowsk@samsung.com>
 <1334256332-29867-11-git-send-email-k.lewandowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karol,
Thanks for the patch.

Please refer to the comments below.

On 04/12/2012 08:45 PM, Karol Lewandowski wrote:
> Includes v4l2/dt helper function (hdmi_of_get_i2c_subdev() that probably
> should be implemented in v4l2 core itself.
> 
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>  drivers/media/video/s5p-tv/hdmi_drv.c |   68 ++++++++++++++++++++++++++++++++-
>  1 files changed, 67 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
> index fff3cab..a402e8f 100644
> --- a/drivers/media/video/s5p-tv/hdmi_drv.c
> +++ b/drivers/media/video/s5p-tv/hdmi_drv.c
> @@ -29,6 +29,8 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/clk.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/of.h>
> +#include <linux/of_i2c.h>
>  
>  #include <media/s5p_hdmi.h>
>  #include <media/v4l2-common.h>
> @@ -712,6 +714,56 @@ static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
>  	return v4l_fill_dv_preset_info(hdmi_conf[preset->index].preset, preset);
>  }
>  
> +#ifdef CONFIG_OF
> +/* Heavily based[1] on v4l2_i2c_new_subdev_board()
> + *
> + * [1] Copy-pasted, that is
> + */
> +struct v4l2_subdev *hdmi_of_get_i2c_subdev(struct v4l2_device *v4l2_dev,
> +	struct device_node *np, const char *propname)
> +{
> +	struct v4l2_subdev *sd = NULL;
> +	struct i2c_client *client;
> +	struct device_node *cnp;
> +
> +	BUG_ON(!v4l2_dev);

Crashing a kernel is not a good idea in general. Especially when it is possible
to handle a situation. I think that "if (WARN_ON(..)) return NULL" combo
is a preferred way for handling such an error.

> +
> +	cnp = of_parse_phandle(np, propname, 0);
> +	if (!cnp) {
> +		dev_err(v4l2_dev->dev, "Can't find subdev %s\n", propname);
> +		goto err;
> +	}
> +
> +	client = of_find_i2c_device_by_node(cnp);
> +	if (!client) {
> +		dev_err(v4l2_dev->dev, "subdev %s doesn't reference correct node\n",
> +			propname);
> +		goto err;
> +	}
> +

Maybe you should combine the check below with the check above.

> +	if (client == NULL || client->driver == NULL)
> +		goto err;
> +
> +	/* Lock the module so we can safely get the v4l2_subdev pointer */
> +	if (!try_module_get(client->driver->driver.owner))
> +		goto err;
> +	sd = i2c_get_clientdata(client);
> +
> +	/* Register with the v4l2_device which increases the module's
> +	   use count as well. */
> +	if (v4l2_device_register_subdev(v4l2_dev, sd)) {
> +		printk(KERN_ERR "%s: failed to register subdev\n", __func__);
> +		sd = NULL;
> +	}
> +	/* Decrease the module use count to match the first try_module_get. */
> +	module_put(client->driver->driver.owner);

This label 'err' is not only used for error cleanups. Maybe you should rename it
to 'cleanup' or 'done'.

> +err:
> +	of_node_put(cnp);
> +
> +	return sd;
> +}
> +#endif

I think that you should strongly consider adding the function above to
the V4L2 core to drivers/media/video/videobuf2-core.c file and post
the patch to linux-media list.

> +
>  static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
>  	.s_power = hdmi_s_power,
>  };
> @@ -875,6 +927,12 @@ static struct v4l2_subdev *hdmi_get_subdev(
>  	struct i2c_adapter *adapter;
>  	struct device *dev = hdmi_dev->dev;
> 

Now I see why hdmi_get_subdev is called with NULL arguments in the
previous patch :).

However I think that you should introduce two explicit paths in probe
function for handling non-DT and DT cases.

> +#ifdef CONFIG_OF
> +	if (dev->of_node)
> +		return hdmi_of_get_i2c_subdev(&hdmi_dev->v4l2_dev,
> +					   dev->of_node, propname);
> +#endif
> +
>  	if (!bdinfo) {
>  		dev_err(dev, "%s info is missing in platform data\n",
>  			propname);
> @@ -913,7 +971,7 @@ static int __devinit hdmi_probe(struct platform_device *pdev)
>  
>  	dev_dbg(dev, "probe start\n");
>  
> -	if (!pdata) {
> +	if (!pdata && !dev->of_node) {
>  		dev_err(dev, "platform data is missing\n");
>  		ret = -ENODEV;
>  		goto fail;
> @@ -1037,6 +1095,13 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id hdmi_dt_match[] = {
> +	{ .compatible = "samsung,s5pv210-hdmi" },
> +	{ },
> +};
> +#endif
> +
>  static struct platform_driver hdmi_driver __refdata = {
>  	.probe = hdmi_probe,
>  	.remove = __devexit_p(hdmi_remove),
> @@ -1045,6 +1110,7 @@ static struct platform_driver hdmi_driver __refdata = {
>  		.name = "s5p-hdmi",
>  		.owner = THIS_MODULE,
>  		.pm = &hdmi_pm_ops,
> +		.of_match_table = of_match_ptr(hdmi_dt_match),
>  	}
>  };
> 

Regards,
Tomasz Stanislawski


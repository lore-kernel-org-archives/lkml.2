Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab2K2HhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:37:18 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44492 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2K2HhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:37:16 -0500
Message-ID: <50B710A0.4080907@gmail.com>
Date: Thu, 29 Nov 2012 15:37:04 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC,v2,8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 09:19 PM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> Add client driver for 2D device.
> 
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
> 
> ---
> 
[...]
> +
> +static int
> +tegra_drm_ioctl_open_channel(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)
> +{
> +	struct tegra_drm_open_channel_args *args = data;
> +	struct tegra_drm_client *client;
> +	struct tegra_drm_context *context;
> +	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
> +	int err = 0;
> +
> +	dev_dbg(drm->dev, "> %s(fpriv=%p, class=%x)\n", __func__,
> +			fpriv, args->class);
> +
> +	context = kzalloc(sizeof(*context), GFP_KERNEL);
> +	if (!context) {
> +		err = -ENOMEM;
> +		goto out;

Change to "return -ENOMEM". Otherwise the NULL "context" will be kfree.

> +	}
> +
> +	list_for_each_entry(client, &tegra_drm_subdrv_list, list) {
> +		if (client->class == args->class) {
> +			dev_dbg(drm->dev, "opening client %x\n", args->class);
> +			context->client = client;
> +			err = client->ops->open_channel(client, context);
> +			if (err)
> +				goto out;
> +
> +			dev_dbg(drm->dev, "context %p\n", context);
> +			list_add(&context->list, &fpriv->contexts);
> +			args->context = context;
> +			goto out;
> +		}
> +	}
> +	err = -ENODEV;
> +
> +out:
> +	if (err)
> +		kfree(context);
> +
> +	dev_dbg(drm->dev, "< %s() = %d\n", __func__, err);
> +	return err;
> +}
> +
> +static int
> +tegra_drm_ioctl_close_channel(struct drm_device *drm, void *data,
> +			 struct drm_file *file_priv)
> +{
> +	struct tegra_drm_open_channel_args *args = data;
> +	struct tegra_drm_context *context;
> +	struct tegra_drm_fpriv *fpriv = tegra_drm_fpriv(file_priv);
> +	int err = 0;
> +
> +	dev_dbg(drm->dev, "> %s(fpriv=%p)\n", __func__, fpriv);
> +	list_for_each_entry(context, &fpriv->contexts, list) {

Consider "list_for_each_entry_safe" cause you remove list members during
the loop.

> +		if (context == args->context) {
> +			context->client->ops->close_channel(context);
> +			list_del(&context->list);
> +			kfree(context);
> +			goto out;
> +		}
> +	}
> +	err = -EINVAL;
> +
> +out:
> +	dev_dbg(drm->dev, "< %s() = %d\n", __func__, err);
> +	return err;
> +}
> +
[...]
> +
> +static int gr2d_submit(struct tegra_drm_context *context,
> +		struct tegra_drm_submit_args *args)

I'm still in the middle of code reading of job submit, so I'll get you
back if I find something.

[...]
> +
> +static struct of_device_id gr2d_match[] __devinitdata = {
> +	{ .compatible = "nvidia,tegra20-gr2d", },
> +	{ .compatible = "nvidia,tegra30-gr2d", },

Just as swarren mentioned, you'd better place "nvidia,tegra30-gr2d" in
the front of "nvidia,tegra20-gr2d"...

[...]
> +
> +#define DRM_TEGRA_GEM_CREATE		0x00
> +
> +#define DRM_IOCTL_TEGRA_GEM_CREATE	DRM_IOWR(DRM_COMMAND_BASE + \
> +		DRM_TEGRA_GEM_CREATE, struct tegra_gem_create)
> +

Just a very minor suggestion: could you put them at the end of this
file? I mean, stay with other IOCTLs like SYNCPT_READ, SYNCPT_WAIT...

[...]
> +
> +#define DRM_TEGRA_DRM_SYNCPT_READ 0x01
> +#define DRM_TEGRA_DRM_SYNCPT_INCR 0x02
> +#define DRM_TEGRA_DRM_SYNCPT_WAIT 0x03
> +#define DRM_TEGRA_DRM_OPEN_CHANNEL 0x04
> +#define DRM_TEGRA_DRM_CLOSE_CHANNEL 0x05
> +#define DRM_TEGRA_DRM_GET_SYNCPOINTS 0x06
> +#define DRM_TEGRA_DRM_GET_MODMUTEXES 0x07
> +#define DRM_TEGRA_DRM_SUBMIT 0x08
> +
> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_READ DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_READ, struct tegra_drm_syncpt_read_args)
> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_INCR DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_INCR, struct tegra_drm_syncpt_incr_args)
> +#define DRM_IOCTL_TEGRA_DRM_SYNCPT_WAIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SYNCPT_WAIT, struct tegra_drm_syncpt_wait_args)
> +#define DRM_IOCTL_TEGRA_DRM_OPEN_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_OPEN_CHANNEL, struct tegra_drm_open_channel_args)
> +#define DRM_IOCTL_TEGRA_DRM_CLOSE_CHANNEL DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_CLOSE_CHANNEL, struct tegra_drm_open_channel_args)
> +#define DRM_IOCTL_TEGRA_DRM_GET_SYNCPOINTS DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_SYNCPOINTS, struct tegra_drm_get_channel_param_args)
> +#define DRM_IOCTL_TEGRA_DRM_GET_MODMUTEXES DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_GET_MODMUTEXES, struct tegra_drm_get_channel_param_args)
> +#define DRM_IOCTL_TEGRA_DRM_SUBMIT DRM_IOWR(DRM_COMMAND_BASE + DRM_TEGRA_DRM_SUBMIT, struct tegra_drm_submit_args)
> +
> +#endif
> 

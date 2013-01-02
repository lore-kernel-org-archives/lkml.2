Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3ABJUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 04:20:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8090 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3ABJUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 04:20:45 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Jan 2013 01:20:32 -0800
Message-ID: <50E3FD17.80402@nvidia.com>
Date: Wed, 2 Jan 2013 11:25:43 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Zhang <nvmarkzhang@gmail.com>
CC: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dev@lynxeye.de" <dev@lynxeye.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv4 0/8] Support for Tegra 2D hardware
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com> <50DAC678.5060601@gmail.com>
In-Reply-To: <50DAC678.5060601@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.12.2012 11:42, Mark Zhang wrote:
> diff --git a/drivers/gpu/drm/tegra/gr2d.c b/drivers/gpu/drm/tegra/gr2d.c
> index a936902..28954b3 100644
> --- a/drivers/gpu/drm/tegra/gr2d.c
> +++ b/drivers/gpu/drm/tegra/gr2d.c
> @@ -247,6 +247,10 @@ static int __devinit gr2d_probe(struct
> platform_device *dev)
>  {
>         int err;
>         struct gr2d *gr2d = NULL;
> +       /* Cause drm_device is created in host1x driver. So
> +          if host1x drivers loads after tegradrm, then in this
> +          gr2d_probe function, this "drm_device" will be NULL.
> +          How can we handle this? Defer driver probe? */

I will push a new proposal about how the devices & drivers get probed.

>         struct platform_device *drm_device =
>                 host1x_drm_device(to_platform_device(dev->dev.parent));
>         struct tegradrm *tegradrm = platform_get_drvdata(drm_device);
> @@ -273,6 +277,11 @@ static int __devinit gr2d_probe(struct
> platform_device *dev)
> 
>         gr2d->syncpt = host1x_syncpt_alloc(dev, 0);
>         if (!gr2d->syncpt) {
> +               /* Do we really need this?
> +                  After "host1x_channel_alloc", the refcount of this
> +                  channel is 0. So calling host1x_channel_put here will
> +                  make the refcount going to negative.
> +                  I suppose we should call "host1x_free_channel" here. */

True. I need to also export host1x_channel_free (I will change the name,
too).

>                 host1x_channel_put(gr2d->channel);
>                 return -ENOMEM;
>         }
> @@ -284,6 +293,7 @@ static int __devinit gr2d_probe(struct
> platform_device *dev)
> 
>         err = tegra_drm_register_client(tegradrm, &gr2d->client);
>         if (err)
> +               /* Add "host1x_free_channel" */

Will do.

>                 return err;
> 
>         platform_set_drvdata(dev, gr2d);
> diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
> index 3705cae..ed83b9e 100644
> --- a/drivers/gpu/host1x/channel.c
> +++ b/drivers/gpu/host1x/channel.c
> @@ -95,6 +95,9 @@ struct host1x_channel *host1x_channel_alloc(struct
> platform_device *pdev)
>         int max_channels = host1x->info.nb_channels;
>         int err;
> 
> +       /* Is it necessary to add mutex protection here?
> +          I'm just wondering in a smp system, multiple host1x clients
> +          may try to alloc their channels simultaneously... */

I'll add locking.

>         if (chindex > max_channels)
>                 return NULL;
> 
> diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
> index 86d5c70..f2bd5aa 100644
> --- a/drivers/gpu/host1x/debug.c
> +++ b/drivers/gpu/host1x/debug.c
> @@ -164,6 +164,10 @@ static const struct file_operations
> host1x_debug_fops = {
> 
>  void host1x_debug_init(struct host1x *host1x)
>  {
> +       /* I think it's better to set this directory name the same with
> +          the driver's name -- defined in dev.c:
> +          #define DRIVER_NAME  "tegra-host1x"
> +          */
>         struct dentry *de = debugfs_create_dir("tegra_host", NULL);

Will do.

> 
>         if (!de)
> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
> index 07e8813..01ed10d 100644
> --- a/drivers/gpu/host1x/dev.c
> +++ b/drivers/gpu/host1x/dev.c
> @@ -38,6 +38,7 @@
> 
>  struct host1x *host1x;
> 
> +/* Called by drm unlocked ioctl function. So do we need a lock here? */
>  void host1x_syncpt_incr_byid(u32 id)

No, host1x_syncpt_incr_byid is SMP safe.

>  {
>         struct host1x_syncpt *sp = host1x->syncpt + id;
> @@ -52,6 +53,7 @@ u32 host1x_syncpt_read_byid(u32 id)
>  }
>  EXPORT_SYMBOL(host1x_syncpt_read_byid);
> 
> +/* Called by drm unlocked ioctl function. So do we need a lock here? */
>  int host1x_syncpt_wait_byid(u32 id, u32 thresh, long timeout, u32 *value)

Same here, SMP safe.

>  {
>         struct host1x_syncpt *sp = host1x->syncpt + id;
> @@ -161,6 +163,8 @@ static int host1x_probe(struct platform_device *dev)
> 
>         err = host1x_alloc_resources(host);
>         if (err) {
> +               /* We don't have chip_ops right now, so here the
> +                  error message is somewhat improper */
>                 dev_err(&dev->dev, "failed to init chip support\n");
>                 goto fail;
>         }

Actually, alloc_resources only allocates intr->syncpt, so I the code to
host1x_intr_init().

> @@ -175,6 +179,14 @@ static int host1x_probe(struct platform_device *dev)
>         if (!host->syncpt)
>                 goto fail;
> 
> +       /* I suggest create a dedicate function for initializing nop sp.
> +          First this "_host1x_syncpt_alloc" looks like an internal/static
> +          function.
> +          Then actually "host1x_syncpt_alloc" & "_host1x_syncpt_alloc" all
> +          serve host1x client(e.g: gr2d) so it's not suitable to use them
> +          for nop sp.
> +          Just create a wrapper function to call _host1x_syncpt_alloc is OK.
> +          This will make the code more readable. */
>         host->nop_sp = _host1x_syncpt_alloc(host, NULL, 0);

_host1x_syncpt_alloc is an internal function, not exported.
host1x_syncpt_alloc is exported. I think it's even better if I just move
allocation of nop_sp to happen in host1x_syncpt_init.

>         if (!host->nop_sp)
>                 goto fail;
> @@ -191,6 +203,7 @@ static int host1x_probe(struct platform_device *dev)
>         }
> 
>         err = clk_prepare_enable(host->clk);
> +       /* Add a dev_err here */
>         if (err < 0)
>                 goto fail;
> 
> @@ -209,9 +222,12 @@ static int host1x_probe(struct platform_device *dev)
>         return 0;
> 
>  fail:
> +       /* host1x->syncpt isn't released here... */
> +       /* host1x->intr isn't release here... */
> +       /* Remove debugfs stuffs? */
>         host1x_syncpt_free(host->nop_sp);
>         host1x_unregister_drm_device(host);
> -       kfree(host);
> +       kfree(host); /* not necessary*/
>         return err;
>  }

I added a few other dev_err()'s and checked the deinitialization on
error, too.

> 
> @@ -222,6 +238,7 @@ static int __exit host1x_remove(struct
> platform_device *dev)
>         host1x_syncpt_deinit(host);
>         host1x_unregister_drm_device(host);
>         clk_disable_unprepare(host->clk);
> +       /* Remove debugfs stuffs? */
>         return 0;
>  }

Will do.

> 
> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
> index 05f8544..58f4c71 100644
> --- a/drivers/gpu/host1x/dev.h
> +++ b/drivers/gpu/host1x/dev.h
> @@ -36,6 +36,7 @@ struct platform_device;
>  struct output;
> 
>  struct host1x_channel_ops {
> +       /* Seems no one uses this member. Remove it. */
>         const char *soc_name;
>         int (*init)(struct host1x_channel *,
>                     struct host1x *,
> @@ -125,12 +126,18 @@ struct host1x {
>         struct host1x_syncpt *syncpt;
>         struct host1x_intr intr;
>         struct platform_device *dev;
> +
> +       /* Seems no one uses this. Remove it. */
>         atomic_t clientid;
>         struct host1x_device_info info;
>         struct clk *clk;
> 
> +       /* Put some comments for this member.
> +          For guys who're not familiar with nop sp, I think they'll
> +          definitely get confused about this. */
>         struct host1x_syncpt *nop_sp;
> 
> +       /* Seems no one uses this member. Remove it. */
>         const char *soc_name;
>         struct host1x_channel_ops channel_op;
>         struct host1x_cdma_ops cdma_op;
> @@ -140,6 +147,7 @@ struct host1x {
>         struct host1x_intr_ops intr_op;
> 
>         struct host1x_channel chlist;
> +
>         int allocated_channels;
> 
>         struct dentry *debugfs;

I removed the extra entries, and I added a short comment about nop_sp.

> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
> index efcb9be..e112001 100644
> --- a/drivers/gpu/host1x/intr.c
> +++ b/drivers/gpu/host1x/intr.c
> @@ -329,8 +329,13 @@ void host1x_intr_deinit(struct host1x_intr *intr)
>  void host1x_intr_start(struct host1x_intr *intr, u32 hz)
>  {
>         struct host1x *host1x = intr_to_host1x(intr);
> +
> +       /* Why we need to lock here? Seems like this function is
> +          called by host1x's probe only. */
>         mutex_lock(&intr->mutex);
> 
> +       /* "init_host_sync" has already been called in function
> +          host1x_intr_init. Remove this line. */
>         host1x->intr_op.init_host_sync(intr);
>         host1x->intr_op.set_host_clocks_per_usec(intr,
>                         DIV_ROUND_UP(hz, 1000000));

In future, we'll call host1x_intr_start() whenever host1x is turned on.
Thus we need locking.

init_host_sync() should actually be called from host1x_intr_start(), not
_init().

> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
> index 07cbca5..9a234ad 100644
> --- a/drivers/gpu/host1x/syncpt.c
> +++ b/drivers/gpu/host1x/syncpt.c
> @@ -309,6 +309,8 @@ struct host1x_syncpt *host1x_syncpt_init(struct
> host1x *host)
>         struct host1x_syncpt *syncpt, *sp;
>         int i;
> 
> +       /* Consider devm_kzalloc here. Then you can forget the release
> +          stuffs about this "syncpt". */
>         syncpt = sp = kzalloc(sizeof(struct host1x_syncpt) * host->info.nb_pts,
>                 GFP_KERNEL);
>         if (!syncpt)

Will do.

Thanks!

Terje

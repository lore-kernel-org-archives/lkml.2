Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2KMHQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:16:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13289 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2KMHQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 02:16:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 12 Nov 2012 23:15:54 -0800
Message-ID: <50A1F3A3.40905@nvidia.com>
Date: Tue, 13 Nov 2012 15:15:47 +0800
From: Mark Zhang <markz@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Dave Airlie <airlied@redhat.com>, Rob Clark <robdclark@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] drm: Add NVIDIA Tegra20 support
References: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de> <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1352757358-14001-2-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 05:55 AM, Thierry Reding wrote:
> This commit adds a KMS driver for the Tegra20 SoC. This includes basic
> support for host1x and the two display controllers found on the Tegra20
> SoC. Each display controller can drive a separate RGB/LVDS output.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> Changes in v2:
> - drop Linux-specific drm subdirectory for DT bindings documentation
> - remove display helper leftovers that belong in a later patch
> - reuse debugfs infrastructure provided by the DRM core
> - move vblank syncpoint defines to dc.h
> - use drm_compat_ioctl()
> 
[...]
> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
> new file mode 100644
> index 0000000..be1daf7
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/Kconfig
> @@ -0,0 +1,23 @@
> +config DRM_TEGRA
> +       tristate "NVIDIA Tegra DRM"
> +       depends on DRM && OF && ARCH_TEGRA
> +       select DRM_KMS_HELPER
> +       select DRM_GEM_CMA_HELPER
> +       select DRM_KMS_CMA_HELPER

Just for curious, according to my testing, why the "CONFIG_CMA" is not
enabled while DRM_GEM_CMA_HELPER & DRM_KMS_CMA_HELPER are enabled here?

> +       select FB_CFB_FILLRECT
> +       select FB_CFB_COPYAREA
> +       select FB_CFB_IMAGEBLIT
> +       help
> +         Choose this option if you have an NVIDIA Tegra SoC.
> +
> +         To compile this driver as a module, choose M here: the module
> +         will be called tegra-drm.
> +
> +if DRM_TEGRA
> +
> +config DRM_TEGRA_DEBUG
> +       bool "NVIDIA Tegra DRM debug support"
> +       help
> +         Say yes here to enable debugging support.
> +
> +endif
> diff --git a/drivers/gpu/drm/tegra/Makefile b/drivers/gpu/drm/tegra/Makefile
> new file mode 100644
> index 0000000..624a807
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/Makefile
> @@ -0,0 +1,7 @@
> +ccflags-y := -Iinclude/drm
> +ccflags-$(CONFIG_DRM_TEGRA_DEBUG) += -DDEBUG
> +
> +tegra-drm-y := drm.o fb.o dc.o host1x.o
> +tegra-drm-y += output.o rgb.o
> +
> +obj-$(CONFIG_DRM_TEGRA) += tegra-drm.o
> diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
> new file mode 100644
> index 0000000..3f759a4
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/dc.c
> @@ -0,0 +1,846 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/debugfs.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#include <mach/clk.h>
> +
> +#include "drm.h"
> +#include "dc.h"
[...]
> +
> +static int tegra_dc_drm_exit(struct host1x_client *client)
> +{
> +       struct tegra_dc *dc = host1x_client_to_dc(client);
> +       int err;
> +
> +       devm_free_irq(dc->dev, dc->irq, dc);
> +
> +       if (IS_ENABLED(CONFIG_DEBUG_FS)) {
> +               err = tegra_dc_debugfs_exit(dc);
> +               if (err < 0)
> +                       dev_err(dc->dev, "debugfs cleanup failed: %d\n", err);
> +       }
> +
> +       err = tegra_dc_rgb_exit(dc);
> +       if (err) {
> +               dev_err(dc->dev, "failed to shutdown RGB output: %d\n", err);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct host1x_client_ops dc_client_ops = {
> +       .drm_init = tegra_dc_drm_init,
> +       .drm_exit = tegra_dc_drm_exit,
> +};
> +
> +static int tegra_dc_probe(struct platform_device *pdev)
> +{
> +       struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
> +       struct resource *regs;
> +       struct tegra_dc *dc;
> +       int err;
> +
> +       dc = devm_kzalloc(&pdev->dev, sizeof(*dc), GFP_KERNEL);
> +       if (!dc)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(&dc->list);
> +       dc->dev = &pdev->dev;
> +
> +       dc->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR_OR_NULL(dc->clk)) {
> +               dev_err(&pdev->dev, "failed to get clock\n");
> +               return -ENXIO;
> +       }
> +
> +       regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!regs) {
> +               dev_err(&pdev->dev, "failed to get registers\n");
> +               return -ENXIO;
> +       }
> +
> +       dc->regs = devm_request_and_ioremap(&pdev->dev, regs);
> +       if (!dc->regs) {
> +               dev_err(&pdev->dev, "failed to remap registers\n");
> +               return -ENXIO;
> +       }
> +
> +       dc->irq = platform_get_irq(pdev, 0);
> +       if (dc->irq < 0) {
> +               dev_err(&pdev->dev, "failed to get IRQ\n");
> +               return -ENXIO;
> +       }
> +
> +       INIT_LIST_HEAD(&dc->client.list);
> +       dc->client.ops = &dc_client_ops;
> +       dc->client.dev = &pdev->dev;
> +
> +       err = host1x_register_client(host1x, &dc->client);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "failed to register host1x client: %d\n",
> +                       err);
> +               return err;
> +       }
> +
> +       platform_set_drvdata(pdev, dc);
> +
> +       return 0;
> +}
> +
> +static int tegra_dc_remove(struct platform_device *pdev)
> +{
> +       struct host1x *host1x = dev_get_drvdata(pdev->dev.parent);
> +       struct tegra_dc *dc = platform_get_drvdata(pdev);
> +       int err;
> +
> +       err = host1x_unregister_client(host1x, &dc->client);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "failed to unregister host1x client: %d\n",
> +                       err);
> +               return err;
> +       }
> +
> +       return 0;
> +}
> +
> +static struct of_device_id tegra_dc_of_match[] = {
> +       { .compatible = "nvidia,tegra20-dc", },
> +       { .compatible = "nvidia,tegra30-dc", },

If you don't want add Tegra 3 support in this patch set, remove
{ .compatible = "nvidia,tegra30-dc", } here.

> +       { },
> +};
> +
> +struct platform_driver tegra_dc_driver = {
> +       .driver = {
> +               .name = "tegra-dc",
> +               .owner = THIS_MODULE,
> +               .of_match_table = tegra_dc_of_match,
> +       },
> +       .probe = tegra_dc_probe,
> +       .remove = tegra_dc_remove,
> +};
> diff --git a/drivers/gpu/drm/tegra/dc.h b/drivers/gpu/drm/tegra/dc.h
> new file mode 100644
> index 0000000..99977b5
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/dc.h
> @@ -0,0 +1,388 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef TEGRA_DC_H
> +#define TEGRA_DC_H 1
> +
[...]
> +
> +#endif /* TEGRA_DC_H */
> diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
> new file mode 100644
> index 0000000..3a503c9
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/drm.c
> @@ -0,0 +1,115 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +
> +#include <mach/clk.h>
> +#include <linux/dma-mapping.h>
> +#include <asm/dma-iommu.h>
> +
> +#include "drm.h"
> +
> +#define DRIVER_NAME "tegra"
> +#define DRIVER_DESC "NVIDIA Tegra graphics"
> +#define DRIVER_DATE "20120330"
> +#define DRIVER_MAJOR 0
> +#define DRIVER_MINOR 0
> +#define DRIVER_PATCHLEVEL 0
> +
> +static int tegra_drm_load(struct drm_device *drm, unsigned long flags)
> +{
> +       struct device *dev = drm->dev;
> +       struct host1x *host1x;
> +       int err;
> +
> +       host1x = dev_get_drvdata(dev);
> +       drm->dev_private = host1x;
> +       host1x->drm = drm;
> +
> +       drm_mode_config_init(drm);
> +
> +       err = host1x_drm_init(host1x, drm);
> +       if (err < 0)
> +               return err;
> +
> +       err = tegra_drm_fb_init(drm);
> +       if (err < 0)
> +               return err;
> +
> +       drm_kms_helper_poll_init(drm);
> +
> +       return 0;
> +}
> +
> +static int tegra_drm_unload(struct drm_device *drm)
> +{
> +       drm_kms_helper_poll_fini(drm);
> +       tegra_drm_fb_exit(drm);
> +
> +       drm_mode_config_cleanup(drm);
> +
> +       return 0;
> +}
> +
> +static int tegra_drm_open(struct drm_device *drm, struct drm_file *filp)
> +{
> +       return 0;
> +}
> +
> +static void tegra_drm_lastclose(struct drm_device *drm)
> +{
> +       struct host1x *host1x = drm->dev_private;
> +
> +       drm_fbdev_cma_restore_mode(host1x->fbdev);
> +}
> +
> +static struct drm_ioctl_desc tegra_drm_ioctls[] = {
> +};
> +
> +static const struct file_operations tegra_drm_fops = {
> +       .owner = THIS_MODULE,
> +       .open = drm_open,
> +       .release = drm_release,
> +       .unlocked_ioctl = drm_ioctl,
> +       .mmap = drm_gem_cma_mmap,
> +       .poll = drm_poll,
> +       .fasync = drm_fasync,
> +       .read = drm_read,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl = drm_compat_ioctl,
> +#endif
> +       .llseek = noop_llseek,
> +};
> +
> +struct drm_driver tegra_drm_driver = {
> +       .driver_features = DRIVER_BUS_PLATFORM | DRIVER_MODESET | DRIVER_GEM,
> +       .load = tegra_drm_load,
> +       .unload = tegra_drm_unload,
> +       .open = tegra_drm_open,
> +       .lastclose = tegra_drm_lastclose,
> +
> +       .gem_free_object = drm_gem_cma_free_object,
> +       .gem_vm_ops = &drm_gem_cma_vm_ops,
> +       .dumb_create = drm_gem_cma_dumb_create,
> +       .dumb_map_offset = drm_gem_cma_dumb_map_offset,
> +       .dumb_destroy = drm_gem_cma_dumb_destroy,
> +
> +       .ioctls = tegra_drm_ioctls,
> +       .num_ioctls = ARRAY_SIZE(tegra_drm_ioctls),
> +       .fops = &tegra_drm_fops,
> +
> +       .name = DRIVER_NAME,
> +       .desc = DRIVER_DESC,
> +       .date = DRIVER_DATE,
> +       .major = DRIVER_MAJOR,
> +       .minor = DRIVER_MINOR,
> +       .patchlevel = DRIVER_PATCHLEVEL,
> +};
> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> new file mode 100644
> index 0000000..a1a891e
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/drm.h
> @@ -0,0 +1,231 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef TEGRA_DRM_H
> +#define TEGRA_DRM_H 1
> +
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_edid.h>
> +#include <drm/drm_fb_helper.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_fb_cma_helper.h>
> +#include <drm/drm_fixed.h>
> +
> +struct tegra_framebuffer {
> +       struct drm_framebuffer base;
> +       struct drm_gem_cma_object *obj;
> +};
> +
> +static inline struct tegra_framebuffer *to_tegra_fb(struct drm_framebuffer *fb)
> +{
> +       return container_of(fb, struct tegra_framebuffer, base);
> +}
> +
> +struct host1x {
> +       struct drm_device *drm;
> +       struct device *dev;
> +       void __iomem *regs;
> +       struct clk *clk;
> +       int syncpt;
> +       int irq;
> +
> +       struct mutex drm_clients_lock;
> +       struct list_head drm_clients;
> +       struct list_head drm_active;
> +
> +       struct mutex clients_lock;
> +       struct list_head clients;
> +
> +       struct drm_fbdev_cma *fbdev;
> +       struct tegra_framebuffer fb;
> +};
> +
> +struct host1x_client;
> +
> +struct host1x_client_ops {
> +       int (*drm_init)(struct host1x_client *client, struct drm_device *drm);
> +       int (*drm_exit)(struct host1x_client *client);
> +};
> +
> +struct host1x_client {
> +       struct host1x *host1x;
> +       struct device *dev;
> +
> +       const struct host1x_client_ops *ops;
> +
> +       struct list_head list;
> +};
> +
> +extern int host1x_drm_init(struct host1x *host1x, struct drm_device *drm);
> +extern int host1x_drm_exit(struct host1x *host1x);
> +
> +extern int host1x_register_client(struct host1x *host1x,
> +                                 struct host1x_client *client);
> +extern int host1x_unregister_client(struct host1x *host1x,
> +                                   struct host1x_client *client);
> +
> +struct tegra_output;
> +
> +struct tegra_dc {
> +       struct host1x_client client;
> +
> +       struct host1x *host1x;
> +       struct device *dev;
> +
> +       struct drm_crtc base;
> +       int pipe;
> +
> +       struct clk *clk;
> +       bool enabled;
> +
> +       void __iomem *regs;
> +       int irq;
> +
> +       struct tegra_output *rgb;
> +
> +       struct list_head list;
> +
> +       struct drm_info_list *debugfs_files;
> +       struct drm_minor *minor;
> +       struct dentry *debugfs;
> +};
> +
> +static inline struct tegra_dc *host1x_client_to_dc(struct host1x_client *client)
> +{
> +       return container_of(client, struct tegra_dc, client);
> +}
> +
> +static inline struct tegra_dc *to_tegra_dc(struct drm_crtc *crtc)
> +{
> +       return container_of(crtc, struct tegra_dc, base);
> +}
> +
> +static inline void tegra_dc_writel(struct tegra_dc *dc, unsigned long value,
> +                                  unsigned long reg)
> +{
> +       writel(value, dc->regs + (reg << 2));
> +}
> +
> +static inline unsigned long tegra_dc_readl(struct tegra_dc *dc,
> +                                          unsigned long reg)
> +{
> +       return readl(dc->regs + (reg << 2));
> +}
> +
> +struct tegra_output_ops {
> +       int (*enable)(struct tegra_output *output);
> +       int (*disable)(struct tegra_output *output);
> +       int (*setup_clock)(struct tegra_output *output, struct clk *clk,
> +                          unsigned long pclk);
> +       int (*check_mode)(struct tegra_output *output,
> +                         struct drm_display_mode *mode,
> +                         enum drm_mode_status *status);
> +};
> +
> +enum tegra_output_type {
> +       TEGRA_OUTPUT_RGB,
> +};
> +
> +struct tegra_output {
> +       struct device_node *of_node;
> +       struct device *dev;
> +
> +       const struct tegra_output_ops *ops;
> +       enum tegra_output_type type;
> +
> +       struct i2c_adapter *ddc;
> +       const struct edid *edid;
> +       unsigned int hpd_irq;
> +       int hpd_gpio;
> +
> +       struct drm_encoder encoder;
> +       struct drm_connector connector;
> +};
> +
> +static inline struct tegra_output *encoder_to_output(struct drm_encoder *e)
> +{
> +       return container_of(e, struct tegra_output, encoder);
> +}
> +
> +static inline struct tegra_output *connector_to_output(struct drm_connector *c)
> +{
> +       return container_of(c, struct tegra_output, connector);
> +}
> +
> +static inline int tegra_output_enable(struct tegra_output *output)
> +{
> +       if (output && output->ops && output->ops->enable)
> +               return output->ops->enable(output);
> +
> +       return output ? -ENOSYS : -EINVAL;
> +}
> +
> +static inline int tegra_output_disable(struct tegra_output *output)
> +{
> +       if (output && output->ops && output->ops->disable)
> +               return output->ops->disable(output);
> +
> +       return output ? -ENOSYS : -EINVAL;
> +}
> +
> +static inline int tegra_output_setup_clock(struct tegra_output *output,
> +                                          struct clk *clk, unsigned long pclk)
> +{
> +       if (output && output->ops && output->ops->setup_clock)
> +               return output->ops->setup_clock(output, clk, pclk);
> +
> +       return output ? -ENOSYS : -EINVAL;
> +}
> +
> +static inline int tegra_output_check_mode(struct tegra_output *output,
> +                                         struct drm_display_mode *mode,
> +                                         enum drm_mode_status *status)
> +{
> +       if (output && output->ops && output->ops->check_mode)
> +               return output->ops->check_mode(output, mode, status);
> +
> +       return output ? -ENOSYS : -EINVAL;
> +}
> +
> +/* from rgb.c */
> +extern int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc);
> +extern int tegra_dc_rgb_exit(struct tegra_dc *dc);
> +
> +/* from output.c */
> +extern int tegra_output_init(struct drm_device *drm, struct tegra_output *output);
> +extern int tegra_output_exit(struct tegra_output *output);
> +
> +/* from gem.c */
> +extern struct tegra_gem_object *tegra_gem_alloc(struct drm_device *drm,
> +                                               size_t size);
> +extern int tegra_gem_handle_create(struct drm_device *drm,
> +                                  struct drm_file *file, size_t size,
> +                                  unsigned long flags, uint32_t *handle);
> +extern int tegra_gem_dumb_create(struct drm_file *file, struct drm_device *drm,
> +                                struct drm_mode_create_dumb *args);
> +extern int tegra_gem_dumb_map_offset(struct drm_file *file,
> +                                    struct drm_device *drm, uint32_t handle,
> +                                    uint64_t *offset);
> +extern int tegra_gem_dumb_destroy(struct drm_file *file,
> +                                 struct drm_device *drm, uint32_t handle);
> +extern int tegra_drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
> +extern int tegra_gem_init_object(struct drm_gem_object *obj);
> +extern void tegra_gem_free_object(struct drm_gem_object *obj);
> +extern struct vm_operations_struct tegra_gem_vm_ops;
> +
> +/* from fb.c */
> +extern int tegra_drm_fb_init(struct drm_device *drm);
> +extern void tegra_drm_fb_exit(struct drm_device *drm);
> +
> +extern struct platform_driver tegra_host1x_driver;
> +extern struct platform_driver tegra_dc_driver;
> +extern struct drm_driver tegra_drm_driver;
> +
> +#endif /* TEGRA_DRM_H */
> diff --git a/drivers/gpu/drm/tegra/fb.c b/drivers/gpu/drm/tegra/fb.c
> new file mode 100644
> index 0000000..97993c6
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/fb.c
> @@ -0,0 +1,56 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "drm.h"
> +
> +static void tegra_drm_fb_output_poll_changed(struct drm_device *drm)
> +{
> +       struct host1x *host1x = drm->dev_private;
> +
> +       drm_fbdev_cma_hotplug_event(host1x->fbdev);
> +}
> +
> +static const struct drm_mode_config_funcs tegra_drm_mode_funcs = {
> +       .fb_create = drm_fb_cma_create,
> +       .output_poll_changed = tegra_drm_fb_output_poll_changed,
> +};
> +
> +int tegra_drm_fb_init(struct drm_device *drm)
> +{
> +       struct host1x *host1x = drm->dev_private;
> +       struct drm_fbdev_cma *fbdev;
> +
> +       drm->mode_config.min_width = 0;
> +       drm->mode_config.min_height = 0;
> +
> +       drm->mode_config.max_width = 4096;
> +       drm->mode_config.max_height = 4096;
> +
> +       drm->mode_config.funcs = &tegra_drm_mode_funcs;
> +
> +       fbdev = drm_fbdev_cma_init(drm, 32, drm->mode_config.num_crtc,
> +                                  drm->mode_config.num_connector);
> +       if (IS_ERR(fbdev))
> +               return PTR_ERR(fbdev);
> +
> +#ifndef CONFIG_FRAMEBUFFER_CONSOLE
> +       drm_fbdev_cma_restore_mode(fbdev);
> +#endif
> +
> +       host1x->fbdev = fbdev;
> +
> +       return 0;
> +}
> +
> +void tegra_drm_fb_exit(struct drm_device *drm)
> +{
> +       struct host1x *host1x = drm->dev_private;
> +
> +       drm_fbdev_cma_fini(host1x->fbdev);
> +}
> diff --git a/drivers/gpu/drm/tegra/host1x.c b/drivers/gpu/drm/tegra/host1x.c
> new file mode 100644
> index 0000000..ed2af1a
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/host1x.c
> @@ -0,0 +1,313 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#include "drm.h"
> +
> +struct host1x_drm_client {
> +       struct host1x_client *client;
> +       struct device_node *np;
> +       struct list_head list;
> +};
> +
> +static int host1x_add_drm_client(struct host1x *host1x, struct device_node *np)
> +{
> +       struct host1x_drm_client *client;
> +
> +       client = kzalloc(sizeof(*client), GFP_KERNEL);
> +       if (!client)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(&client->list);
> +       client->np = of_node_get(np);
> +
> +       list_add_tail(&client->list, &host1x->drm_clients);
> +
> +       return 0;
> +}
> +
> +static int host1x_activate_drm_client(struct host1x *host1x,
> +                                     struct host1x_drm_client *drm,
> +                                     struct host1x_client *client)
> +{
> +       mutex_lock(&host1x->drm_clients_lock);
> +       list_del_init(&drm->list);
> +       list_add_tail(&drm->list, &host1x->drm_active);

Why we need this "drm_active" list? We can combine this function and
function "host1x_remove_drm_client" and free the drm client just here.
It's useless after host1x clients registered themselves.

> +       drm->client = client;
> +       mutex_unlock(&host1x->drm_clients_lock);
> +
> +       return 0;
> +}
> +
> +static int host1x_remove_drm_client(struct host1x *host1x,
> +                                   struct host1x_drm_client *client)
> +{
> +       mutex_lock(&host1x->drm_clients_lock);
> +       list_del_init(&client->list);
> +       mutex_unlock(&host1x->drm_clients_lock);
> +
> +       of_node_put(client->np);
> +       kfree(client);
> +
> +       return 0;
> +}
> +
> +static int host1x_parse_dt(struct host1x *host1x)
> +{
> +       static const char * const compat[] = {
> +               "nvidia,tegra20-dc",
> +       };
> +       unsigned int i;
> +       int err;
> +
> +       for (i = 0; i < ARRAY_SIZE(compat); i++) {
> +               struct device_node *np;
> +
> +               for_each_child_of_node(host1x->dev->of_node, np) {
> +                       if (of_device_is_compatible(np, compat[i]) &&
> +                           of_device_is_available(np)) {
> +                               err = host1x_add_drm_client(host1x, np);
> +                               if (err < 0)
> +                                       return err;
> +                       }
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int tegra_host1x_probe(struct platform_device *pdev)
> +{
> +       struct host1x *host1x;
> +       struct resource *regs;
> +       int err;
> +
> +       host1x = devm_kzalloc(&pdev->dev, sizeof(*host1x), GFP_KERNEL);
> +       if (!host1x)
> +               return -ENOMEM;
> +
> +       mutex_init(&host1x->drm_clients_lock);
> +       INIT_LIST_HEAD(&host1x->drm_clients);
> +       INIT_LIST_HEAD(&host1x->drm_active);
> +       mutex_init(&host1x->clients_lock);
> +       INIT_LIST_HEAD(&host1x->clients);
> +       host1x->dev = &pdev->dev;
> +
> +       err = host1x_parse_dt(host1x);
> +       if (err < 0) {
> +               dev_err(&pdev->dev, "failed to parse DT: %d\n", err);
> +               return err;
> +       }
> +
> +       host1x->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR_OR_NULL(host1x->clk))
> +               return PTR_ERR(host1x->clk);
> +
> +       err = clk_prepare_enable(host1x->clk);
> +       if (err < 0)
> +               return err;
> +
> +       regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!regs) {
> +               err = -ENXIO;
> +               goto err;
> +       }
> +
> +       err = platform_get_irq(pdev, 0);
> +       if (err < 0)
> +               goto err;
> +
> +       host1x->syncpt = err;
> +
> +       err = platform_get_irq(pdev, 1);
> +       if (err < 0)
> +               goto err;
> +
> +       host1x->irq = err;
> +
> +       host1x->regs = devm_request_and_ioremap(&pdev->dev, regs);
> +       if (!host1x->regs) {
> +               err = -EADDRNOTAVAIL;
> +               goto err;
> +       }
> +
> +       platform_set_drvdata(pdev, host1x);
> +
> +       return 0;
> +
> +err:
> +       clk_disable_unprepare(host1x->clk);
> +       return err;
> +}
> +
> +static int tegra_host1x_remove(struct platform_device *pdev)
> +{
> +       struct host1x *host1x = platform_get_drvdata(pdev);
> +
> +       clk_disable_unprepare(host1x->clk);
> +
> +       return 0;
> +}
> +
> +int host1x_drm_init(struct host1x *host1x, struct drm_device *drm)
> +{
> +       struct host1x_client *client;
> +
> +       mutex_lock(&host1x->clients_lock);
> +
> +       list_for_each_entry(client, &host1x->clients, list) {
> +               if (client->ops && client->ops->drm_init) {
> +                       int err = client->ops->drm_init(client, drm);
> +                       if (err < 0) {
> +                               dev_err(host1x->dev,
> +                                       "DRM setup failed for %s: %d\n",
> +                                       dev_name(client->dev), err);
> +                               return err;
> +                       }
> +               }
> +       }
> +
> +       mutex_unlock(&host1x->clients_lock);
> +
> +       return 0;
> +}
> +
> +int host1x_drm_exit(struct host1x *host1x)
> +{
> +       struct platform_device *pdev = to_platform_device(host1x->dev);
> +       struct host1x_client *client;
> +
> +       if (!host1x->drm)
> +               return 0;
> +
> +       mutex_lock(&host1x->clients_lock);
> +
> +       list_for_each_entry_reverse(client, &host1x->clients, list) {
> +               if (client->ops && client->ops->drm_exit) {
> +                       int err = client->ops->drm_exit(client);
> +                       if (err < 0) {
> +                               dev_err(host1x->dev,
> +                                       "DRM cleanup failed for %s: %d\n",
> +                                       dev_name(client->dev), err);
> +                               return err;
> +                       }
> +               }
> +       }
> +
> +       mutex_unlock(&host1x->clients_lock);
> +
> +       drm_platform_exit(&tegra_drm_driver, pdev);
> +       host1x->drm = NULL;
> +
> +       return 0;
> +}
> +
> +int host1x_register_client(struct host1x *host1x, struct host1x_client *client)
> +{
> +       struct host1x_drm_client *drm, *tmp;
> +       int err;
> +
> +       mutex_lock(&host1x->clients_lock);
> +       list_add_tail(&client->list, &host1x->clients);
> +       mutex_unlock(&host1x->clients_lock);
> +
> +       list_for_each_entry_safe(drm, tmp, &host1x->drm_clients, list)
> +               if (drm->np == client->dev->of_node)
> +                       host1x_activate_drm_client(host1x, drm, client);
> +
> +       if (list_empty(&host1x->drm_clients)) {
> +               struct platform_device *pdev = to_platform_device(host1x->dev);
> +
> +               err = drm_platform_init(&tegra_drm_driver, pdev);
> +               if (err < 0) {
> +                       dev_err(host1x->dev, "drm_platform_init(): %d\n", err);
> +                       return err;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +int host1x_unregister_client(struct host1x *host1x,
> +                            struct host1x_client *client)
> +{
> +       struct host1x_drm_client *drm, *tmp;
> +       int err;
> +
> +       list_for_each_entry_safe(drm, tmp, &host1x->drm_active, list) {
> +               if (drm->client == client) {
> +                       err = host1x_drm_exit(host1x);

Although this code works but I think it looks confusing.
"host1x_drm_exit" calls every client's "drm_exit" callback then free all
the host1x clients, but this function is placed inside a loop.

I think the better way is, free this host1x_client first, then remove it
from host1x's "clients" list, finally free the host1x(call
host1x_drm_exit) when the "clients" list get empty.

> +                       if (err < 0) {
> +                               dev_err(host1x->dev, "host1x_drm_exit(): %d\n",
> +                                       err);
> +                               return err;
> +                       }
> +
> +                       host1x_remove_drm_client(host1x, drm);
> +                       break;
> +               }
> +       }
> +
> +       mutex_lock(&host1x->clients_lock);
> +       list_del_init(&client->list);
> +       mutex_unlock(&host1x->clients_lock);
> +
> +       return 0;
> +}
> +
> +static struct of_device_id tegra_host1x_of_match[] = {
> +       { .compatible = "nvidia,tegra20-host1x", },
> +       { },
> +};
> +
> +struct platform_driver tegra_host1x_driver = {
> +       .driver = {
> +               .name = "tegra-host1x",
> +               .owner = THIS_MODULE,
> +               .of_match_table = tegra_host1x_of_match,
> +       },
> +       .probe = tegra_host1x_probe,
> +       .remove = tegra_host1x_remove,
> +};
> +
> +static int __init tegra_host1x_init(void)
> +{
> +       int err;
> +
> +       err = platform_driver_register(&tegra_host1x_driver);
> +       if (err < 0)
> +               return err;
> +
> +       err = platform_driver_register(&tegra_dc_driver);
> +       if (err < 0)
> +               goto unregister_host1x;
> +
> +       return 0;
> +
> +unregister_host1x:
> +       platform_driver_unregister(&tegra_host1x_driver);
> +       return err;
> +}
> +module_init(tegra_host1x_init);
> +
> +static void __exit tegra_host1x_exit(void)
> +{
> +       platform_driver_unregister(&tegra_dc_driver);
> +       platform_driver_unregister(&tegra_host1x_driver);
> +}
> +module_exit(tegra_host1x_exit);
> +
> +MODULE_AUTHOR("Thierry Reding <thierry.reding@avionic-design.de>");
> +MODULE_DESCRIPTION("NVIDIA Tegra DRM driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/output.c
> new file mode 100644
> index 0000000..6df2553
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/output.c
> @@ -0,0 +1,262 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_i2c.h>
> +
> +#include "drm.h"
> +
> +static int tegra_connector_get_modes(struct drm_connector *connector)
> +{
> +       struct tegra_output *output = connector_to_output(connector);
> +       struct edid *edid = NULL;
> +       int err = 0;
> +
> +       if (output->edid)
> +               edid = kmemdup(output->edid, sizeof(*edid), GFP_KERNEL);
> +       else if (output->ddc)
> +               edid = drm_get_edid(connector, output->ddc);
> +
> +       drm_mode_connector_update_edid_property(connector, edid);
> +
> +       if (edid) {
> +               err = drm_add_edid_modes(connector, edid);
> +               kfree(edid);
> +       }
> +
> +       return err;
> +}
> +
> +static int tegra_connector_mode_valid(struct drm_connector *connector,
> +                                     struct drm_display_mode *mode)
> +{
> +       struct tegra_output *output = connector_to_output(connector);
> +       enum drm_mode_status status = MODE_OK;
> +       int err;
> +
> +       err = tegra_output_check_mode(output, mode, &status);
> +       if (err < 0)
> +               return MODE_ERROR;
> +
> +       return status;
> +}
> +
> +static struct drm_encoder *
> +tegra_connector_best_encoder(struct drm_connector *connector)
> +{
> +       struct tegra_output *output = connector_to_output(connector);
> +
> +       return &output->encoder;
> +}
> +
> +static const struct drm_connector_helper_funcs connector_helper_funcs = {
> +       .get_modes = tegra_connector_get_modes,
> +       .mode_valid = tegra_connector_mode_valid,
> +       .best_encoder = tegra_connector_best_encoder,
> +};
> +
> +static enum drm_connector_status
> +tegra_connector_detect(struct drm_connector *connector, bool force)
> +{
> +       struct tegra_output *output = connector_to_output(connector);
> +       enum drm_connector_status status = connector_status_unknown;
> +
> +       if (gpio_is_valid(output->hpd_gpio)) {
> +               if (gpio_get_value(output->hpd_gpio) == 0)
> +                       status = connector_status_disconnected;
> +               else
> +                       status = connector_status_connected;
> +       } else {
> +               if (connector->connector_type == DRM_MODE_CONNECTOR_LVDS)
> +                       status = connector_status_connected;
> +       }
> +
> +       return status;
> +}
> +
> +static void tegra_connector_destroy(struct drm_connector *connector)
> +{
> +       drm_sysfs_connector_remove(connector);
> +       drm_connector_cleanup(connector);
> +}
> +
> +static const struct drm_connector_funcs connector_funcs = {
> +       .dpms = drm_helper_connector_dpms,
> +       .detect = tegra_connector_detect,
> +       .fill_modes = drm_helper_probe_single_connector_modes,
> +       .destroy = tegra_connector_destroy,
> +};
> +
> +static void tegra_encoder_destroy(struct drm_encoder *encoder)
> +{
> +       drm_encoder_cleanup(encoder);
> +}
> +
> +static const struct drm_encoder_funcs encoder_funcs = {
> +       .destroy = tegra_encoder_destroy,
> +};
> +
> +static void tegra_encoder_dpms(struct drm_encoder *encoder, int mode)
> +{
> +}
> +
> +static bool tegra_encoder_mode_fixup(struct drm_encoder *encoder,
> +                                    const struct drm_display_mode *mode,
> +                                    struct drm_display_mode *adjusted)
> +{
> +       return true;
> +}
> +
> +static void tegra_encoder_prepare(struct drm_encoder *encoder)
> +{
> +}
> +
> +static void tegra_encoder_commit(struct drm_encoder *encoder)
> +{
> +}
> +
> +static void tegra_encoder_mode_set(struct drm_encoder *encoder,
> +                                  struct drm_display_mode *mode,
> +                                  struct drm_display_mode *adjusted)
> +{
> +       struct tegra_output *output = encoder_to_output(encoder);
> +       int err;
> +
> +       err = tegra_output_enable(output);
> +       if (err < 0)
> +               dev_err(encoder->dev->dev, "tegra_output_enable(): %d\n", err);
> +}
> +
> +static const struct drm_encoder_helper_funcs encoder_helper_funcs = {
> +       .dpms = tegra_encoder_dpms,
> +       .mode_fixup = tegra_encoder_mode_fixup,
> +       .prepare = tegra_encoder_prepare,
> +       .commit = tegra_encoder_commit,
> +       .mode_set = tegra_encoder_mode_set,
> +};
> +
> +static irqreturn_t hpd_irq(int irq, void *data)
> +{
> +       struct tegra_output *output = data;
> +
> +       drm_helper_hpd_irq_event(output->connector.dev);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +int tegra_output_init(struct drm_device *drm, struct tegra_output *output)
> +{
> +       int connector, encoder, err;
> +       enum of_gpio_flags flags;
> +       struct device_node *ddc;
> +       size_t size;
> +
> +       if (!output->of_node)
> +               output->of_node = output->dev->of_node;
> +
> +       output->edid = of_get_property(output->of_node, "nvidia,edid", &size);
> +
> +       ddc = of_parse_phandle(output->of_node, "nvidia,ddc-i2c-bus", 0);
> +       if (ddc) {
> +               output->ddc = of_find_i2c_adapter_by_node(ddc);

The i2c adapter may not be ready at this time. For Tegra 2, the I2C bus
for HDMI is not dedicated and we need the i2cmux driver loaded before
this i2c can be used. It proved that sometimes i2cmux driver loads after
drm driver.

So we need to add some logics to support driver probe deferral here.
Anyway, I'm just want you know about this and we can improve this later.

> +               of_node_put(ddc);
> +       }
> +
> +       if (!output->edid && !output->ddc)
> +               return -ENODEV;
> +
> +       output->hpd_gpio = of_get_named_gpio_flags(output->of_node,
> +                                                  "nvidia,hpd-gpio", 0,
> +                                                  &flags);
> +
> +       switch (output->type) {
> +       case TEGRA_OUTPUT_RGB:
> +               connector = DRM_MODE_CONNECTOR_LVDS;
> +               encoder = DRM_MODE_ENCODER_LVDS;
> +               break;
> +
> +       case TEGRA_OUTPUT_HDMI:
> +               connector = DRM_MODE_CONNECTOR_HDMIA;
> +               encoder = DRM_MODE_ENCODER_TMDS;
> +               break;
> +
> +       default:
> +               connector = DRM_MODE_CONNECTOR_Unknown;
> +               encoder = DRM_MODE_ENCODER_NONE;
> +               break;
> +       }
> +
> +       drm_connector_init(drm, &output->connector, &connector_funcs,
> +                          connector);
> +       drm_connector_helper_add(&output->connector, &connector_helper_funcs);
> +
> +       drm_encoder_init(drm, &output->encoder, &encoder_funcs, encoder);
> +       drm_encoder_helper_add(&output->encoder, &encoder_helper_funcs);
> +
> +       drm_mode_connector_attach_encoder(&output->connector, &output->encoder);
> +       drm_sysfs_connector_add(&output->connector);
> +
> +       output->encoder.possible_crtcs = 0x3;
> +
> +       if (gpio_is_valid(output->hpd_gpio)) {
> +               unsigned long flags;
> +
> +               err = gpio_request_one(output->hpd_gpio, GPIOF_DIR_IN,
> +                                      "HDMI hotplug detect");
> +               if (err < 0) {
> +                       dev_err(output->dev, "gpio_request_one(): %d\n", err);
> +                       goto put_i2c;
> +               }
> +
> +               err = gpio_to_irq(output->hpd_gpio);
> +               if (err < 0) {
> +                       dev_err(output->dev, "gpio_to_irq(): %d\n", err);
> +                       goto free_hpd;
> +               }
> +
> +               output->hpd_irq = err;
> +
> +               flags = IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING |
> +                       IRQF_ONESHOT;
> +
> +               err = request_threaded_irq(output->hpd_irq, NULL, hpd_irq,
> +                                          flags, "hpd", output);
> +               if (err < 0) {
> +                       dev_err(output->dev, "failed to request IRQ#%u: %d\n",
> +                               output->hpd_irq, err);
> +                       goto free_hpd;
> +               }
> +
> +               output->connector.polled = DRM_CONNECTOR_POLL_HPD;
> +       }
> +
> +       return 0;
> +
> +free_hpd:
> +       gpio_free(output->hpd_gpio);
> +put_i2c:
> +       if (output->ddc)
> +               put_device(&output->ddc->dev);
> +
> +       return err;
> +}
> +
> +int tegra_output_exit(struct tegra_output *output)
> +{
> +       if (gpio_is_valid(output->hpd_gpio)) {
> +               free_irq(output->hpd_irq, output);
> +               gpio_free(output->hpd_gpio);
> +       }
> +
> +       if (output->ddc)
> +               put_device(&output->ddc->dev);
> +
> +       return 0;
> +}
> diff --git a/drivers/gpu/drm/tegra/rgb.c b/drivers/gpu/drm/tegra/rgb.c
> new file mode 100644
> index 0000000..67ad87e
> --- /dev/null
> +++ b/drivers/gpu/drm/tegra/rgb.c
> @@ -0,0 +1,200 @@
> +/*
> + * Copyright (C) 2012 Avionic Design GmbH
> + * Copyright (C) 2012 NVIDIA CORPORATION.  All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#include "drm.h"
> +#include "dc.h"
> +
> +struct tegra_rgb {
> +       struct tegra_output output;
> +       struct clk *clk_parent;
> +       struct clk *clk;
> +};
> +
> +static inline struct tegra_rgb *to_rgb(struct tegra_output *output)
> +{
> +       return container_of(output, struct tegra_rgb, output);
> +}
> +
> +struct reg_entry {
> +       unsigned long offset;
> +       unsigned long value;
> +};
> +
> +static const struct reg_entry rgb_enable[] = {
> +       { DC_COM_PIN_OUTPUT_ENABLE(0),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(1),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(2),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(3),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(1), 0x01000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_DATA(0),     0x00000000 },
> +       { DC_COM_PIN_OUTPUT_DATA(1),     0x00000000 },
> +       { DC_COM_PIN_OUTPUT_DATA(2),     0x00000000 },
> +       { DC_COM_PIN_OUTPUT_DATA(3),     0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(4),   0x00210222 },
> +       { DC_COM_PIN_OUTPUT_SELECT(5),   0x00002200 },
> +       { DC_COM_PIN_OUTPUT_SELECT(6),   0x00020000 },
> +};
> +
> +static const struct reg_entry rgb_disable[] = {
> +       { DC_COM_PIN_OUTPUT_SELECT(6),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(5),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(4),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(3),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(2),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(1),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_SELECT(0),   0x00000000 },
> +       { DC_COM_PIN_OUTPUT_DATA(3),     0xaaaaaaaa },
> +       { DC_COM_PIN_OUTPUT_DATA(2),     0xaaaaaaaa },
> +       { DC_COM_PIN_OUTPUT_DATA(1),     0xaaaaaaaa },
> +       { DC_COM_PIN_OUTPUT_DATA(0),     0xaaaaaaaa },
> +       { DC_COM_PIN_OUTPUT_POLARITY(3), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(2), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(1), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_POLARITY(0), 0x00000000 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(3),   0x55555555 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(2),   0x55555555 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(1),   0x55150005 },
> +       { DC_COM_PIN_OUTPUT_ENABLE(0),   0x55555555 },
> +};
> +
> +static void tegra_dc_write_regs(struct tegra_dc *dc,
> +                               const struct reg_entry *table,
> +                               unsigned int num)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < num; i++)
> +               tegra_dc_writel(dc, table[i].value, table[i].offset);
> +}
> +
> +static int tegra_output_rgb_enable(struct tegra_output *output)
> +{
> +       struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
> +
> +       tegra_dc_write_regs(dc, rgb_enable, ARRAY_SIZE(rgb_enable));
> +
> +       return 0;
> +}
> +
> +static int tegra_output_rgb_disable(struct tegra_output *output)
> +{
> +       struct tegra_dc *dc = to_tegra_dc(output->encoder.crtc);
> +
> +       tegra_dc_write_regs(dc, rgb_disable, ARRAY_SIZE(rgb_disable));
> +
> +       return 0;
> +}
> +
> +static int tegra_output_rgb_setup_clock(struct tegra_output *output,
> +                                       struct clk *clk, unsigned long pclk)
> +{
> +       struct tegra_rgb *rgb = to_rgb(output);
> +
> +       return clk_set_parent(clk, rgb->clk_parent);
> +}
> +
> +static int tegra_output_rgb_check_mode(struct tegra_output *output,
> +                                      struct drm_display_mode *mode,
> +                                      enum drm_mode_status *status)
> +{
> +       /*
> +        * FIXME: For now, always assume that the mode is okay. There are
> +        * unresolved issues with clk_round_rate(), which doesn't always
> +        * reliably report whether a frequency can be set or not.
> +        */
> +
> +       *status = MODE_OK;
> +
> +       return 0;
> +}
> +
> +static const struct tegra_output_ops rgb_ops = {
> +       .enable = tegra_output_rgb_enable,
> +       .disable = tegra_output_rgb_disable,
> +       .setup_clock = tegra_output_rgb_setup_clock,
> +       .check_mode = tegra_output_rgb_check_mode,
> +};
> +
> +int tegra_dc_rgb_init(struct drm_device *drm, struct tegra_dc *dc)
> +{
> +       struct device_node *np;
> +       struct tegra_rgb *rgb;
> +       int err;
> +
> +       np = of_get_child_by_name(dc->dev->of_node, "rgb");
> +       if (!np || !of_device_is_available(np))
> +               return -ENODEV;
> +
> +       rgb = devm_kzalloc(dc->dev, sizeof(*rgb), GFP_KERNEL);
> +       if (!rgb)
> +               return -ENOMEM;
> +
> +       rgb->clk = devm_clk_get(dc->dev, NULL);
> +       if (IS_ERR_OR_NULL(rgb->clk))
> +               return PTR_ERR(rgb->clk);
> +
> +       rgb->clk_parent = devm_clk_get(dc->dev, "parent");
> +       if (IS_ERR_OR_NULL(rgb->clk_parent))
> +               return PTR_ERR(rgb->clk_parent);
> +
> +       err = clk_set_parent(rgb->clk, rgb->clk_parent);
> +       if (err < 0) {
> +               dev_err(dc->dev, "failed to set parent clock: %d\n", err);
> +               return err;
> +       }

Okay, seems this works with the "CLK_DUPLICATE" in tegra20_clocks_data.c.
I think the purpose of all these is to make sure the dc has a correct
parent clock. Hm... But I feel this may bring confusing to do dc clock
settings in a drm output component.

> +
> +       rgb->output.type = TEGRA_OUTPUT_RGB;
> +       rgb->output.ops = &rgb_ops;
> +       rgb->output.dev = dc->dev;
> +       rgb->output.of_node = np;
> +
> +       err = tegra_output_init(dc->base.dev, &rgb->output);
> +       if (err < 0) {
> +               dev_err(dc->dev, "output setup failed: %d\n", err);
> +               return err;
> +       }
> +
> +       /*
> +        * By default, outputs can be associated with each display controller.
> +        * RGB outputs are an exception, so we make sure they can be attached
> +        * to only their parent display controller.
> +        */
> +       rgb->output.encoder.possible_crtcs = 1 << dc->pipe;
> +
> +       dc->rgb = &rgb->output;
> +
> +       return 0;
> +}
> +
> +int tegra_dc_rgb_exit(struct tegra_dc *dc)
> +{
> +       if (dc->rgb) {
> +               int err = tegra_output_exit(dc->rgb);
> +               if (err < 0) {
> +                       dev_err(dc->dev, "output cleanup failed: %d\n", err);
> +                       return err;
> +               }
> +
> +               dc->rgb = NULL;
> +       }
> +
> +       return 0;
> +}
> --
> 1.8.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

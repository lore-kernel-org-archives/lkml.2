Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2LUNx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 08:53:57 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:46168 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153Ab2LUNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 08:53:52 -0500
Message-ID: <1356098031.1490.111.camel@tellur>
Subject: Re: [PATCHv4 8/8] gpu: host1x: Register DRM dummy device
From: Lucas Stach <dev@lynxeye.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: thierry.reding@avionic-design.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Dec 2012 14:53:51 +0100
In-Reply-To: <1356089964-5265-9-git-send-email-tbergstrom@nvidia.com>
References: <1356089964-5265-1-git-send-email-tbergstrom@nvidia.com>
	 <1356089964-5265-9-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 21.12.2012, 13:39 +0200 schrieb Terje Bergstrom:
> Register a dummy device for tegradrm, and provide a getter to
> access the device.
> 
> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
> ---
[...]
> diff --git a/drivers/gpu/host1x/drm.c b/drivers/gpu/host1x/drm.c
> new file mode 100644
> index 0000000..eaaaeed
> --- /dev/null
> +++ b/drivers/gpu/host1x/drm.c
> @@ -0,0 +1,51 @@
> +/*
> + * Tegra host1x driver DRM dummy device
> + *
> + * Copyright (c) 2012, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/module.h>
> +#include "drm.h"
> +#include "dev.h"
> +
> +int host1x_register_drm_device(struct host1x *host1x)
> +{
> +	struct platform_device *drm_device;
> +
> +	drm_device = platform_device_register_simple("tegradrm", -1, NULL, 0);
> +	if (!drm_device)
> +		return -ENOMEM;
> +	dma_set_coherent_mask(&drm_device->dev, DMA_BIT_MASK(32));
> +
This might not be necessary once we move the allocator to host1x.

> +	host1x->drm_device = drm_device;
> +	return 0;
> +}
> +EXPORT_SYMBOL(host1x_register_drm_device);
> +
> +void host1x_unregister_drm_device(struct host1x *host1x)
> +{
> +	if (host1x->drm_device)
> +		platform_device_unregister(host1x->drm_device);
> +}
> +EXPORT_SYMBOL(host1x_unregister_drm_device);
> +
> +struct platform_device *host1x_drm_device(struct platform_device *pdev)
> +{
> +	struct host1x *host = platform_get_drvdata(pdev);
> +	return host->drm_device;
> +}
> +EXPORT_SYMBOL(host1x_drm_device);
This should be called host1x_get_drm_device





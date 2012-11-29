Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2K2JLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:11:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53856 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2K2JK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:10:58 -0500
Message-ID: <50B72696.3030205@gmail.com>
Date: Thu, 29 Nov 2012 17:10:46 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Terje Bergstrom <tbergstrom@nvidia.com>
CC: thierry.reding@avionic-design.de, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC,v2,1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
In-Reply-To: <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 09:19 PM, Terje Bergström <tbergstrom@nvidia.com> wrote:
> Add nvhost, the driver for host1x. This patch adds support for reading and
> incrementing sync points and dynamic power management.
> 
> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
> 
> ---
> drivers/video/Kconfig                              |    2 +
>  drivers/video/Makefile                             |    2 +
>  drivers/video/tegra/host/Kconfig                   |    5 +
>  drivers/video/tegra/host/Makefile                  |   10 +
>  drivers/video/tegra/host/chip_support.c            |   48 ++
>  drivers/video/tegra/host/chip_support.h            |   52 +++
>  drivers/video/tegra/host/dev.c                     |   96 ++++
>  drivers/video/tegra/host/host1x/Makefile           |    7 +
>  drivers/video/tegra/host/host1x/host1x.c           |  204 +++++++++
>  drivers/video/tegra/host/host1x/host1x.h           |   78 ++++
>  drivers/video/tegra/host/host1x/host1x01.c         |   37 ++
>  drivers/video/tegra/host/host1x/host1x01.h         |   29 ++
>  .../video/tegra/host/host1x/host1x01_hardware.h    |   36 ++
>  drivers/video/tegra/host/host1x/host1x_syncpt.c    |  156 +++++++
>  drivers/video/tegra/host/host1x/hw_host1x01_sync.h |  398 ++++++++++++++++
>  drivers/video/tegra/host/nvhost_acm.c              |  481 ++++++++++++++++++++
>  drivers/video/tegra/host/nvhost_acm.h              |   45 ++
>  drivers/video/tegra/host/nvhost_syncpt.c           |  333 ++++++++++++++
>  drivers/video/tegra/host/nvhost_syncpt.h           |  136 ++++++
>  include/linux/nvhost.h                             |  143 ++++++
>  20 files changed, 2298 insertions(+)
[...]
> diff --git a/drivers/video/tegra/host/chip_support.c b/drivers/video/tegra/host/chip_support.c
> +#include "chip_support.h"
> +#include "host1x/host1x01.h"
> +
> +struct nvhost_chip_support *nvhost_chip_ops;
> +
> +struct nvhost_chip_support *nvhost_get_chip_ops(void)
> +{
> +	return nvhost_chip_ops;
> +}

If you wanna hide "nvhost_chip_ops" from other source files, declare it
as "static". So this is not a static member which means other files is
able to touch it by "extern" but we also define a function to get it,
and this looks redundant.

[...]
> diff --git a/drivers/video/tegra/host/host1x/Makefile b/drivers/video/tegra/host/host1x/Makefile
> new file mode 100644
> index 0000000..330d507
> --- /dev/null
> +++ b/drivers/video/tegra/host/host1x/Makefile
> @@ -0,0 +1,7 @@
> +ccflags-y = -Idrivers/video/tegra/host
> +
> +nvhost-host1x-objs  = \
> +	host1x.o \
> +	host1x01.o

Can we rename this "host1x01.c"? I just really don't like this kind of
variables/files, I mean, I can't imagine the purpose of the file
according to it's name...

[...]
> +
> +static int __devinit nvhost_alloc_resources(struct nvhost_master *host)
> +{
> +	int err;
> +
> +	err = nvhost_init_chip_support(host);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}

Just "return nvhost_init_chip_support(host)" is enough. If so, do we
still need this function?

[...]
> +
> +static int __devinit nvhost_probe(struct platform_device *dev)
> +
[...]
> +	dev_info(&dev->dev, "initialized\n");
> +
> +	return 0;
> +
> +fail:

Add more "free" codes here. Actually, "nvhost_free_resources" frees the
host->intr.syncpt which is not needed to free manually.
Seems at least we need to add "nvhost_syncpt_deinit" here.

[...]
> +
> +static struct of_device_id host1x_match[] __devinitdata = {
> +	{ .compatible = "nvidia,tegra20-host1x", },
> +	{ .compatible = "nvidia,tegra30-host1x", },

Again, place tegra30-host1x before tegra20-host1x.

[...]
> +
> +/**
> + * Write a cpu syncpoint increment to the hardware, without touching
> + * the cache. Caller is responsible for host being powered.
> + */
> +static void host1x_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id)
> +{
> +	struct nvhost_master *dev = syncpt_to_dev(sp);
> +	u32 reg_offset = id / 32;
> +
> +	if (!nvhost_module_powered(dev->dev)) {
> +		dev_err(&syncpt_to_dev(sp)->dev->dev,
> +			"Trying to access host1x when it's off");
> +		return;
> +	}
> +
> +	if (!nvhost_syncpt_client_managed(sp, id)
> +			&& nvhost_syncpt_min_eq_max(sp, id)) {
> +		dev_err(&syncpt_to_dev(sp)->dev->dev,
> +			"Trying to increment syncpoint id %d beyond max\n",
> +			id);
> +		return;
> +	}
> +	writel(BIT_MASK(id), dev->sync_aperture +
> +			host1x_sync_syncpt_cpu_incr_r() + reg_offset * 4);

I have a stupid question: According to the name and the context of this
function, seems it increases the syncpt value which specified by param
"id". So how does this "writel" increase the value? I don't know much
about host1x/syncpt reg operations, so could you explain a little bit or
I just completely have a wrong understanding?

[...]
> +
> +static ssize_t powergate_delay_store(struct kobject *kobj,
> +	struct kobj_attribute *attr, const char *buf, size_t count)
> +{
> +	int powergate_delay = 0, ret = 0;
> +	struct nvhost_device_power_attr *power_attribute =
> +		container_of(attr, struct nvhost_device_power_attr,
> +			power_attr[NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY]);
> +	struct platform_device *dev = power_attribute->ndev;
> +	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
> +
> +	if (!pdata->can_powergate) {
> +		dev_info(&dev->dev, "does not support power-gating\n");
> +		return count;
> +	}
> +
> +	mutex_lock(&pdata->lock);
> +	ret = sscanf(buf, "%d", &powergate_delay);
> +	if (ret == 1 && powergate_delay >= 0)
> +		pdata->powergate_delay = powergate_delay;
> +	else
> +		dev_err(&dev->dev, "Invalid powergate delay\n");
> +	mutex_unlock(&pdata->lock);
> +
> +	return count;

Why we need to return an unchanged param? Seems param "count" doesn't
make sense here.

[...]
> +
> +int nvhost_module_init(struct platform_device *dev)
> +{
> +	int i = 0, err = 0;
> +	struct kobj_attribute *attr = NULL;
> +	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
> +
> +	/* initialize clocks to known state */
> +	while (pdata->clocks[i].name && i < NVHOST_MODULE_MAX_CLOCKS) {
> +		long rate = pdata->clocks[i].default_rate;
> +		struct clk *c;
> +
> +		c = devm_clk_get(&dev->dev, pdata->clocks[i].name);
> +		if (IS_ERR_OR_NULL(c)) {
> +			dev_err(&dev->dev, "Cannot get clock %s\n",
> +					pdata->clocks[i].name);
> +			return -ENODEV;
> +		}
> +
> +		rate = clk_round_rate(c, rate);
> +		clk_prepare_enable(c);
> +		clk_set_rate(c, rate);
> +		clk_disable_unprepare(c);
> +		pdata->clk[i] = c;
> +		i++;
> +	}
> +	pdata->num_clks = i;
> +
> +	mutex_init(&pdata->lock);
> +	init_waitqueue_head(&pdata->idle_wq);
> +	INIT_DELAYED_WORK(&pdata->powerstate_down, powerstate_down_handler);
> +
> +	/* power gate units that we can power gate */
> +	if (pdata->can_powergate) {
> +		do_powergate_locked(pdata->powergate_ids[0]);
> +		do_powergate_locked(pdata->powergate_ids[1]);

Seems we don't set these 2 powergate_ids. Does this mean we have not
enabled power management feature in this version?

[...]
> +
> +int nvhost_module_suspend(struct platform_device *dev)
> +{
> +	int ret;
> +	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
> +
> +	ret = wait_event_timeout(pdata->idle_wq, is_module_idle(dev),
> +			ACM_SUSPEND_WAIT_FOR_IDLE_TIMEOUT);
> +	if (ret == 0) {
> +		dev_info(&dev->dev, "%s prevented suspend\n",
> +				dev_name(&dev->dev));
> +		return -EBUSY;
> +	}
> +

I'm not sure whether there is a race condition here. We wait until this
module is idle(refcount == 0), then try to powergate it next. But the
wait queue function "powerstate_down_handler" might already powergate
it. So we need to either  "cancel_delayed_work(&pdate->powerstate_down)"
before waiting the module to idle state or add some protection codes in
"to_state_powergated_locked".

> +	mutex_lock(&pdata->lock);
> +	cancel_delayed_work(&pdata->powerstate_down);
> +	to_state_powergated_locked(dev);
> +	mutex_unlock(&pdata->lock);
> +
> +	if (pdata->suspend_ndev)
> +		pdata->suspend_ndev(dev);
> +
> +	return 0;
> +}
> +
[...]
> +
> +int nvhost_syncpt_init(struct platform_device *dev,
> +		struct nvhost_syncpt *sp)
> +{
> +	int i;
> +	struct nvhost_master *host = syncpt_to_dev(sp);
> +	int err = 0;
> +
> +	/* Allocate structs for min, max and base values */
> +	sp->min_val = kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_pts(sp),
> +			GFP_KERNEL);
> +	sp->max_val = kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_pts(sp),
> +			GFP_KERNEL);
> +	sp->base_val = kzalloc(sizeof(u32) * nvhost_syncpt_nb_bases(sp),
> +			GFP_KERNEL);
> +	sp->lock_counts =
> +		kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_mlocks(sp),
> +			GFP_KERNEL);
> +
> +	if (!(sp->min_val && sp->max_val && sp->base_val && sp->lock_counts)) {
> +		/* frees happen in the deinit */
> +		err = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	sp->kobj = kobject_create_and_add("syncpt", &dev->dev.kobj);
> +	if (!sp->kobj) {
> +		err = -EIO;
> +		goto fail;
> +	}
> +
> +	/* Allocate two attributes for each sync point: min and max */
> +	sp->syncpt_attrs = kzalloc(sizeof(*sp->syncpt_attrs)
> +			* nvhost_syncpt_nb_pts(sp) * 2, GFP_KERNEL);
> +	if (!sp->syncpt_attrs) {
> +		err = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	/* Fill in the attributes */
> +	for (i = 0; i < nvhost_syncpt_nb_pts(sp); i++) {
> +		char name[MAX_SYNCPT_LENGTH];
> +		struct kobject *kobj;
> +		struct nvhost_syncpt_attr *min = &sp->syncpt_attrs[i*2];
> +		struct nvhost_syncpt_attr *max = &sp->syncpt_attrs[i*2+1];
> +
> +		/* Create one directory per sync point */
> +		snprintf(name, sizeof(name), "%d", i);
> +		kobj = kobject_create_and_add(name, sp->kobj);

Where do we "kobject_put" this kobj?

[...]
> +		if (!kobj) {
> +			err = -EIO;
> +			goto fail;
> +		}
> +
> +		min->id = i;
> +		min->host = host;
> +		min->attr.attr.name = min_name;
> +		min->attr.attr.mode = S_IRUGO;
> +		min->attr.show = syncpt_min_show;
> +		if (sysfs_create_file(kobj, &min->attr.attr)) {
> +			err = -EIO;
> +			goto fail;
> +		}
> +
> +		max->id = i;
> +		max->host = host;
> +		max->attr.attr.name = max_name;
> +		max->attr.attr.mode = S_IRUGO;
> +		max->attr.show = syncpt_max_show;
> +		if (sysfs_create_file(kobj, &max->attr.attr)) {
> +			err = -EIO;
> +			goto fail;
> +		}
> +	}
> +
> +	return err;
> +
> +fail:
> +	nvhost_syncpt_deinit(sp);
> +	return err;
> +}
> +
[...]
> +/* public host1x sync-point management APIs */
> +u32 host1x_syncpt_incr_max(u32 id, u32 incrs);
> +void host1x_syncpt_incr(u32 id);
> +u32 host1x_syncpt_read(u32 id);
> +
> +#endif
> 

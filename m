Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2K1VXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:23:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2K1VXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:23:09 -0500
Date: Wed, 28 Nov 2012 22:23:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
Message-ID: <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3FErX3jagTVnlR95dD/TqCWs9gVn4bGynjXYyuLCSBl
 WckYFl0mhGZJ/zB4gtZ7fjpr9CrjK5T8cLkUDN5B+cqLLYJQHl
 Gb2iGQV1mS8PZOm5CeF5Ngjalq35sMPATq2wE35HNghgQB69WS
 1+jUEPi++YiHuMTcFjpqCw9C4c4Tvums1A7KrSpzskdwfRJ9gc
 MyrORQZZCYGxKYb2TSKCwMqRI8VAYFGbpED4n4NNEhYKwFkc8L
 fN1qif2OBnsnX00BXDfFX/8pFDNco+TO8dpGv+aq5l/PigJgLt
 0/k2uUyRXr7rbAwKh00H4ss4UksTPz+jA6sWgO6ivi+S/9x1UQ
 jhs5df4WSac5IqhD2IG+FfkR74xirYWrky0FEKYlBLs1PovCQt
 Sz27TNHLeIydUXTn2pnC0O1Gz51Kx4DzdCOji9o0++x/7hSUoW
 JsbXP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26, 2012 at 03:19:07PM +0200, Terje Bergstrom wrote:
[...]
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index fb9a14e..94c861b 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2463,4 +2463,6 @@ config FB_SH_MOBILE_MERAM
>  	  Up to 4 memory channels can be configured, allowing 4 RGB or
>  	  2 YCbCr framebuffers to be configured.
> =20
> +source "drivers/video/tegra/host/Kconfig"
> +

This could be problematic. Since drivers/video and drivers/gpu/drm are
separate trees, this would entail a continuous burden on keeping both
trees synchronized. While I realize that eventually it might be better
to put the host1x driver in a separate place to accomodate for its use
by other subsystems, I'm not sure moving it here right away is the best
approach.

I'm not sure drivers/video is the best location either. Perhaps
drivers/bus would be better? Or maybe we need a new subdirectory for
this kind of device.

> diff --git a/drivers/video/tegra/host/chip_support.c b/drivers/video/tegr=
a/host/chip_support.c
> new file mode 100644
> index 0000000..5a44147
> --- /dev/null
> +++ b/drivers/video/tegra/host/chip_support.c
> @@ -0,0 +1,48 @@
> +/*
> + * drivers/video/tegra/host/chip_support.c

I think the general nowadays is to no longer use filenames in comments.

[...]
> +struct nvhost_chip_support *nvhost_chip_ops;
> +
> +struct nvhost_chip_support *nvhost_get_chip_ops(void)
> +{
> +	return nvhost_chip_ops;
> +}

This seems like it should be more tightly coupled to the host1x device.
And it shouldn't be a global variable.

> +
> +int nvhost_init_chip_support(struct nvhost_master *host)
> +{
> +	if (nvhost_chip_ops =3D=3D NULL) {
> +		nvhost_chip_ops =3D kzalloc(sizeof(*nvhost_chip_ops), GFP_KERNEL);
> +		if (nvhost_chip_ops =3D=3D NULL) {
> +			pr_err("%s: Cannot allocate nvhost_chip_support\n",
> +				__func__);
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	nvhost_init_host1x01_support(host, nvhost_chip_ops);
> +	return 0;
> +}

We also don't need this. This should really be done by the central
host1x device's initialization.

> diff --git a/drivers/video/tegra/host/chip_support.h b/drivers/video/tegr=
a/host/chip_support.h
[...]
> +struct output;

What's this? It doesn't seem to be used anywhere.

> +struct nvhost_master;

Why do you suffix this with _master? The whole point of host1x is to be
the "master" so you can just as well call it nvhost, right? Ideally
you'd call it host1x, but I'm repeating myself. =3D)

> +struct nvhost_syncpt;
> +struct platform_device;
> +
> +struct nvhost_syncpt_ops {
> +	void (*reset)(struct nvhost_syncpt *, u32 id);
> +	void (*reset_wait_base)(struct nvhost_syncpt *, u32 id);
> +	void (*read_wait_base)(struct nvhost_syncpt *, u32 id);
> +	u32 (*update_min)(struct nvhost_syncpt *, u32 id);
> +	void (*cpu_incr)(struct nvhost_syncpt *, u32 id);
> +	void (*debug)(struct nvhost_syncpt *);
> +	const char * (*name)(struct nvhost_syncpt *, u32 id);
> +};

Why are these even defined as ops structure? Tegra20 and Tegra30 seem to
be compatible when it comes to handling syncpoints. I thought they would
even be compatible in all other aspects as well, so why even have this?

> +
> +struct nvhost_chip_support {
> +	const char *soc_name;
> +	struct nvhost_syncpt_ops syncpt;
> +};
> +
> +struct nvhost_chip_support *nvhost_get_chip_ops(void);
> +
> +#define syncpt_op()		(nvhost_get_chip_ops()->syncpt)

You really shouldn't be doing this, but rather use explicit accesses for
these structures. If you're design doesn't scatter these definitions
across several files then it isn't difficult to obtain the correct
pointers and you don't need these "shortcuts".

> diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host/de=
v.c
[...]
> +u32 host1x_syncpt_incr_max(u32 id, u32 incrs)
> +{
> +	struct nvhost_syncpt *sp =3D &nvhost->syncpt;
> +	return nvhost_syncpt_incr_max(sp, id, incrs);
> +}
> +EXPORT_SYMBOL(host1x_syncpt_incr_max);

This API looks odd. Should syncpoints not be considered as regular
resources, much like interrupts? In that case it would be easier to
abstract them away behind an opaque type. It looks like you already use
the struct nvhost_syncpt to refer to the set of syncpoints associated
with a host1x device.

How about you use nvhost/host1x_syncpt to refer to individual syncpoints
instead. You could export an array of those from your host1x device and
implement a basic resource allocation mechanism on top, similar to how
other resources are handled in the kernel.

So a host1x client device could call host1x_request_syncpt() to allocate
a syncpoint from it's host1x parent dynamically along with passing a
name and a syncpoint handler to it.

> +
> +void host1x_syncpt_incr(u32 id)
> +{
> +	struct nvhost_syncpt *sp =3D &nvhost->syncpt;
> +	nvhost_syncpt_incr(sp, id);
> +}
> +EXPORT_SYMBOL(host1x_syncpt_incr);

Similarly, instead of passing an integer here, host1x clients would pass
a pointer to the requested syncpoint instead.

> +bool host1x_powered(struct platform_device *dev)
> +{
[...]
> +}
> +EXPORT_SYMBOL(host1x_powered);
> +
> +void host1x_busy(struct platform_device *dev)
> +{
[...]
> +}
> +EXPORT_SYMBOL(host1x_busy);
> +
> +void host1x_idle(struct platform_device *dev)
> +{
[...]
> +}
> +EXPORT_SYMBOL(host1x_idle);

These look like a reimplementation of the runtime power-management
framework.

> diff --git a/drivers/video/tegra/host/host1x/host1x.c b/drivers/video/teg=
ra/host/host1x/host1x.c
[...]
> +struct nvhost_master *nvhost;

Bad habbit. I know that this is a popular shortcut. However this also
leads to very bad designs because you're allowed to reuse this pointer
=66rom wherever you like.

When I wrote the tegra-drm code I explicitly made sure to not use any
such global variable. In the end it forces you to clean up the driver
design.

As a bonus you automatically get support for any number of host1x
devices on the same SoC. Now you will probably tell me that this is
never going to happen. People also used to think that a computers would
never use more than a single CPU...

> +static void power_on_host(struct platform_device *dev)
> +{
> +	struct nvhost_master *host =3D nvhost_get_private_data(dev);
> +
> +	nvhost_syncpt_reset(&host->syncpt);
> +}
> +
> +static int power_off_host(struct platform_device *dev)
> +{
> +	struct nvhost_master *host =3D nvhost_get_private_data(dev);
> +
> +	nvhost_syncpt_save(&host->syncpt);
> +	return 0;
> +}

These seem like possible candidates for runtime PM.

> +
> +static void nvhost_free_resources(struct nvhost_master *host)
> +{
> +}

This should be removed since it's empty.

> +
> +static int __devinit nvhost_alloc_resources(struct nvhost_master *host)
> +{
> +	int err;
> +
> +	err =3D nvhost_init_chip_support(host);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}

Again, this chip support concept is not useful, so this function can go
away as well. Also nvhost_init_chip_support() doesn't allocate any
resources so it shouldn't be called from this function in the first
place.

> +
> +static int __devinit nvhost_probe(struct platform_device *dev)
> +{
> +	struct nvhost_master *host;
> +	struct resource *regs, *intr0, *intr1;
> +	int i, err;
> +	struct nvhost_device_data *pdata =3D
> +		(struct nvhost_device_data *)dev->dev.platform_data;

Platform data should not be used. Tegra is DT only.

> +	regs =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
> +	intr0 =3D platform_get_resource(dev, IORESOURCE_IRQ, 0);
> +	intr1 =3D platform_get_resource(dev, IORESOURCE_IRQ, 1);
> +
> +	if (!regs || !intr0 || !intr1) {

I prefer to have these checked for explicitly, one by one for
readability and potentially more useful diagnostics.

Also you should be using platform_get_irq() for interrupts. Furthermore
the host1x DT node (and the TRM) name the interrupts "syncpt" and
"general", so maybe those would be more useful variable names than
"intr0" and "intr1".

But since you don't use them anyway they shouldn't be part of this
patch.

> +	host =3D devm_kzalloc(&dev->dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	nvhost =3D host;
> +
> +	host->dev =3D dev;
> +
> +	/* Copy host1x parameters. The private_data gets replaced
> +	 * by nvhost_master later */

Multiline comments should be in this format:

	/*
	 * foo
	 */

> +	memcpy(&host->info, pdata->private_data,
> +			sizeof(struct host1x_device_info));

I don't think passing data in this way shouldn't be necessary as
discussed in the subthread on the Tegra AUXDATA.

> +
> +	pdata->finalize_poweron =3D power_on_host;
> +	pdata->prepare_poweroff =3D power_off_host;
> +
> +	pdata->pdev =3D dev;
> +
> +	/* set common host1x device data */
> +	platform_set_drvdata(dev, pdata);
> +
> +	/* set private host1x device data */
> +	nvhost_set_private_data(dev, host);
> +
> +	host->aperture =3D devm_request_and_ioremap(&dev->dev, regs);
> +	if (!host->aperture) {

aperture is confusing as it is typically used for GTT-type memory
regions, so it may be mistaken for the GART found on Tegra 2. Why not
call it "regs" instead?

> +		dev_err(&dev->dev, "failed to remap host registers\n");

This is unnecessary. devm_request_and_ioremap() already prints an error
message on failure.

> +	for (i =3D 0; i < pdata->num_clks; i++)
> +		clk_prepare_enable(pdata->clk[i]);
> +	nvhost_syncpt_reset(&host->syncpt);
> +	for (i =3D 0; i < pdata->num_clks; i++)
> +		clk_disable_unprepare(pdata->clk[i]);

Stephen already hinted at this when discussing the AUXDATA. You should
explicitly request the clocks.

> +static int __exit nvhost_remove(struct platform_device *dev)

This should really be __devexit to allow the driver to be built as a
module. However, __dev* are deprecated and in the process of being
removed so you can just drop __exit as well.

> +static struct of_device_id host1x_match[] __devinitdata =3D {

__devinitdata can be dropped.

> +	{ .compatible =3D "nvidia,tegra20-host1x", },
> +	{ .compatible =3D "nvidia,tegra30-host1x", },
> +	{ },
> +};
> +
> +static struct platform_driver platform_driver =3D {
> +	.probe =3D nvhost_probe,
> +	.remove =3D __exit_p(nvhost_remove),

__exit_p also.

> +	.suspend =3D nvhost_suspend,
> +	.resume =3D nvhost_resume,
> +	.driver =3D {
> +		.owner =3D THIS_MODULE,
> +		.name =3D DRIVER_NAME,
> +		.of_match_table =3D of_match_ptr(host1x_match),

No need for of_match_ptr().

> +static int __init nvhost_mod_init(void)
> +{
> +	return platform_driver_register(&platform_driver);
> +}
> +
> +static void __exit nvhost_mod_exit(void)
> +{
> +	platform_driver_unregister(&platform_driver);
> +}
> +
> +module_init(nvhost_mod_init);
> +module_exit(nvhost_mod_exit);

Use module_platform_driver().

> diff --git a/drivers/video/tegra/host/host1x/host1x.h b/drivers/video/teg=
ra/host/host1x/host1x.h
[...]
> +#define TRACE_MAX_LENGTH	128U
> +#define IFACE_NAME		"nvhost"

None of these seem to be used.

> +static inline void *nvhost_get_private_data(struct platform_device *_dev)
> +{
> +	struct nvhost_device_data *pdata =3D
> +		(struct nvhost_device_data *)platform_get_drvdata(_dev);
> +	WARN_ON(!pdata);
> +	return (pdata && pdata->private_data) ? pdata->private_data : NULL;
> +}
> +
> +static inline void nvhost_set_private_data(struct platform_device *_dev,
> +	void *priv_data)
> +{
> +	struct nvhost_device_data *pdata =3D
> +		(struct nvhost_device_data *)platform_get_drvdata(_dev);
> +	WARN_ON(!pdata);
> +	if (pdata)
> +		pdata->private_data =3D priv_data;
> +}

You should need none of these. Instead put all the data you need into
you struct host1x and associate that with the platform device using
platform_set_drvdata().

> +static inline
> +struct nvhost_master *nvhost_get_host(struct platform_device *_dev)
> +{
> +	struct platform_device *pdev;
> +
> +	if (_dev->dev.parent) {
> +		pdev =3D to_platform_device(_dev->dev.parent);
> +		return nvhost_get_private_data(pdev);
> +	} else
> +		return nvhost_get_private_data(_dev);
> +}
> +
> +static inline
> +struct platform_device *nvhost_get_parent(struct platform_device *_dev)
> +{
> +	return _dev->dev.parent ? to_platform_device(_dev->dev.parent) : NULL;
> +}

These don't seem to be used.

> diff --git a/drivers/video/tegra/host/host1x/host1x01.c b/drivers/video/t=
egra/host/host1x/host1x01.c
> new file mode 100644
> index 0000000..d53302d
> --- /dev/null
> +++ b/drivers/video/tegra/host/host1x/host1x01.c
> @@ -0,0 +1,37 @@
> +/*
> + * drivers/video/tegra/host/host1x01.c
> + *
> + * Host1x init for T20 and T30 Architecture Chips
> + *
> + * Copyright (c) 2011-2012, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/nvhost.h>
> +
> +#include "host1x/host1x01.h"
> +#include "host1x/host1x.h"
> +#include "host1x/host1x01_hardware.h"
> +#include "chip_support.h"
> +
> +#include "host1x/host1x_syncpt.c"
> +
> +int nvhost_init_host1x01_support(struct nvhost_master *host,
> +	struct nvhost_chip_support *op)
> +{
> +	host->sync_aperture =3D host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;

Usually you don't keep separate variables for subregions. This can
equally well be done with just adding a corresponding offset.

Then again, I already said that this whole chip support concept is
unnecessary and can be dropped.

> diff --git a/drivers/video/tegra/host/host1x/host1x_syncpt.c b/drivers/vi=
deo/tegra/host/host1x/host1x_syncpt.c
[...]
> +/**
> + * Write the current syncpoint value back to hw.
> + */
> +static void host1x_syncpt_reset(struct nvhost_syncpt *sp, u32 id)
> +{
> +	struct nvhost_master *dev =3D syncpt_to_dev(sp);
> +	int min =3D nvhost_syncpt_read_min(sp, id);
> +	writel(min, dev->sync_aperture + (host1x_sync_syncpt_0_r() + id * 4));
> +}

Again, better to represent individual syncpoints with opaque pointers
and dereference them here. Obviously this file will need access to the
structure definition.

> +static void host1x_syncpt_debug(struct nvhost_syncpt *sp)
> +{
> +	u32 i;
> +	for (i =3D 0; i < nvhost_syncpt_nb_pts(sp); i++) {
> +		u32 max =3D nvhost_syncpt_read_max(sp, i);
> +		u32 min =3D nvhost_syncpt_update_min(sp, i);
> +		if (!max && !min)
> +			continue;
> +		dev_info(&syncpt_to_dev(sp)->dev->dev,
> +			"id %d (%s) min %d max %d\n",
> +			i, syncpt_op().name(sp, i),
> +			min, max);
> +
> +	}
> +
> +	for (i =3D 0; i < nvhost_syncpt_nb_bases(sp); i++) {
> +		u32 base_val;
> +		host1x_syncpt_read_wait_base(sp, i);
> +		base_val =3D sp->base_val[i];
> +		if (base_val)
> +			dev_info(&syncpt_to_dev(sp)->dev->dev,
> +					"waitbase id %d val %d\n",
> +					i, base_val);
> +
> +	}
> +}

This should probably be integrated with debugfs.

> diff --git a/drivers/video/tegra/host/host1x/hw_host1x01_sync.h b/drivers=
/video/tegra/host/host1x/hw_host1x01_sync.h

Autogenerated files are generally not acceptable. And I already
mentioned before that you should be using #define instead of static
inline functions for register and bit definitions.

> diff --git a/drivers/video/tegra/host/nvhost_acm.c b/drivers/video/tegra/=
host/nvhost_acm.c
[...]

This whole file largely looks like a reimplementation of runtime PM. You
should investigate if you can't reuse the existing infrastructure.

> +	/* Init the power sysfs attributes for this device */
> +	pdata->power_attrib =3D devm_kzalloc(&dev->dev,
> +			sizeof(struct nvhost_device_power_attr),
> +		GFP_KERNEL);
> +	if (!pdata->power_attrib) {
> +		dev_err(&dev->dev, "Unable to allocate sysfs attributes\n");
> +		return -ENOMEM;
> +	}
> +	pdata->power_attrib->ndev =3D dev;
> +
> +	pdata->power_kobj =3D kobject_create_and_add("acm", &dev->dev.kobj);
> +	if (!pdata->power_kobj) {
> +		dev_err(&dev->dev, "Could not add dir 'power'\n");
> +		err =3D -EIO;
> +		goto fail_attrib_alloc;
> +	}
> +
> +	attr =3D &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_CLO=
CKGATE_DELAY];
> +	attr->attr.name =3D "clockgate_delay";
> +	attr->attr.mode =3D S_IWUSR | S_IRUGO;
> +	attr->show =3D clockgate_delay_show;
> +	attr->store =3D clockgate_delay_store;
> +	if (sysfs_create_file(pdata->power_kobj, &attr->attr)) {
> +		dev_err(&dev->dev, "Could not create sysfs attribute clockgate_delay\n=
");
> +		err =3D -EIO;
> +		goto fail_clockdelay;
> +	}
> +
> +	attr =3D &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_POW=
ERGATE_DELAY];
> +	attr->attr.name =3D "powergate_delay";
> +	attr->attr.mode =3D S_IWUSR | S_IRUGO;
> +	attr->show =3D powergate_delay_show;
> +	attr->store =3D powergate_delay_store;
> +	if (sysfs_create_file(pdata->power_kobj, &attr->attr)) {
> +		dev_err(&dev->dev, "Could not create sysfs attribute powergate_delay\n=
");
> +		err =3D -EIO;
> +		goto fail_powergatedelay;
> +	}
> +
> +	attr =3D &pdata->power_attrib->power_attr[NVHOST_POWER_SYSFS_ATTRIB_REF=
COUNT];
> +	attr->attr.name =3D "refcount";
> +	attr->attr.mode =3D S_IRUGO;
> +	attr->show =3D refcount_show;
> +	if (sysfs_create_file(pdata->power_kobj, &attr->attr)) {
> +		dev_err(&dev->dev, "Could not create sysfs attribute refcount\n");
> +		err =3D -EIO;
> +		goto fail_refcount;
> +	}

This is a very funky way of creating sysfs attributes. What you probably
want here are device attributes. See Documentation/filesystems/sysfs.txt
and include/linux/sysfs.h.

But if you can replace this by runtime PM, you'll get similar
functionality for free anyway.

> diff --git a/drivers/video/tegra/host/nvhost_syncpt.c b/drivers/video/teg=
ra/host/nvhost_syncpt.c
[...]
> +/**
> + * Returns true if syncpoint is expired, false if we may need to wait
> + */
> +bool nvhost_syncpt_is_expired(
> +	struct nvhost_syncpt *sp,
> +	u32 id,
> +	u32 thresh)
> +{
> +	u32 current_val;
> +	u32 future_val;
> +	smp_rmb();

What do you need a read memory barrier for?

> +/* Displays the current value of the sync point via sysfs */
> +static ssize_t syncpt_min_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct nvhost_syncpt_attr *syncpt_attr =3D
> +		container_of(attr, struct nvhost_syncpt_attr, attr);
> +
> +	return snprintf(buf, PAGE_SIZE, "%u",
> +			nvhost_syncpt_read(&syncpt_attr->host->syncpt,
> +				syncpt_attr->id));
> +}
> +
> +static ssize_t syncpt_max_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct nvhost_syncpt_attr *syncpt_attr =3D
> +		container_of(attr, struct nvhost_syncpt_attr, attr);
> +
> +	return snprintf(buf, PAGE_SIZE, "%u",
> +			nvhost_syncpt_read_max(&syncpt_attr->host->syncpt,
> +				syncpt_attr->id));
> +}

This looks like it belongs in debugfs.

> +int nvhost_syncpt_init(struct platform_device *dev,
> +		struct nvhost_syncpt *sp)
> +{
> +	int i;
> +	struct nvhost_master *host =3D syncpt_to_dev(sp);
> +	int err =3D 0;
> +
> +	/* Allocate structs for min, max and base values */
> +	sp->min_val =3D kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_pts(sp),
> +			GFP_KERNEL);
> +	sp->max_val =3D kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_pts(sp),
> +			GFP_KERNEL);
> +	sp->base_val =3D kzalloc(sizeof(u32) * nvhost_syncpt_nb_bases(sp),
> +			GFP_KERNEL);
> +	sp->lock_counts =3D
> +		kzalloc(sizeof(atomic_t) * nvhost_syncpt_nb_mlocks(sp),
> +			GFP_KERNEL);

Again, I really think that syncpoints should be objects with
corresponding attributes instead of keeping them in these arrays.

> diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
[...]
> +struct host1x_device_info {
> +	int		nb_channels;	/* host1x: num channels supported */
> +	int		nb_pts;		/* host1x: num syncpoints supported */
> +	int		nb_bases;	/* host1x: num syncpoints supported */
> +	u32		client_managed; /* host1x: client managed syncpts */
> +	int		nb_mlocks;	/* host1x: number of mlocks */
> +	const char	**syncpt_names;	/* names of sync points */
> +};
> +
> +struct nvhost_device_data {
> +	int		version;	/* ip version number of device */
> +	int		id;		/* Separates clients of same hw */
> +	int		index;		/* Hardware channel number */
> +	void __iomem	*aperture;	/* Iomem mapped to kernel */
> +
> +	u32		syncpts;	/* Bitfield of sync points used */
> +	u32		modulemutexes;	/* Bit field of module mutexes */
> +
> +	u32		class;		/* Device class */
> +	bool		serialize;	/* Serialize submits in the channel */
> +
> +	int		powergate_ids[NVHOST_MODULE_MAX_POWERGATE_IDS];
> +	bool		can_powergate;	/* True if module can be power gated */
> +	int		clockgate_delay;/* Delay before clock gated */
> +	int		powergate_delay;/* Delay before power gated */
> +	struct nvhost_clock clocks[NVHOST_MODULE_MAX_CLOCKS];/* Clock names */
> +
> +	struct delayed_work powerstate_down;/* Power state management */
> +	int		num_clks;	/* Number of clocks opened for dev */
> +	struct clk	*clk[NVHOST_MODULE_MAX_CLOCKS];
> +	struct mutex	lock;		/* Power management lock */
> +	int		powerstate;	/* Current power state */
> +	int		refcount;	/* Number of tasks active */
> +	wait_queue_head_t idle_wq;	/* Work queue for idle */
> +
> +	struct nvhost_channel *channel;	/* Channel assigned for the module */
> +	struct kobject *power_kobj;	/* kobj to hold power sysfs entries */
> +	struct nvhost_device_power_attr *power_attrib;	/* sysfs attributes */
> +	struct dentry *debugfs;		/* debugfs directory */
> +
> +	void *private_data;		/* private platform data */
> +	struct platform_device *pdev;	/* owner platform_device */
> +
> +	/* Finalize power on. Can be used for context restore. */
> +	void (*finalize_poweron)(struct platform_device *dev);
> +
> +	/* Device is busy. */
> +	void (*busy)(struct platform_device *);
> +
> +	/* Device is idle. */
> +	void (*idle)(struct platform_device *);
> +
> +	/* Device is going to be suspended */
> +	void (*suspend_ndev)(struct platform_device *);
> +
> +	/* Device is initialized */
> +	void (*init)(struct platform_device *dev);
> +
> +	/* Device is de-initialized. */
> +	void (*deinit)(struct platform_device *dev);
> +
> +	/* Preparing for power off. Used for context save. */
> +	int (*prepare_poweroff)(struct platform_device *dev);
> +
> +	/* Clock gating callbacks */
> +	int (*prepare_clockoff)(struct platform_device *dev);
> +	void (*finalize_clockon)(struct platform_device *dev);
> +};

A lot of this can be removed if you use existing infrastructure and
simplify the design a bit. Most of it can probably move into the main
struct host1x to avoid needless indirections that make the code hard to
follow and maintain.

Thierry

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtoC1AAoJEN0jrNd/PrOhARsP/A36c7DpZ1PGh0U080k4ENUw
o/MFEscd1r2pNVla/9+ysxrX1TEj/qBAErP/Lhmk5nGZzp+vXrihz3DZnTYxv1AV
4yCf7DDg2t1Cx9d/e2UeprUKSIHtmn3wJ+RRvsbJGrhgfcSsFbR9N4/S2x/jDcbs
sM1b+tDZci+ouQIp0ZSpUJUWIUtEYoSCDQhP1ug2OC1qtfqJ5vUw8AOHKu27nQdF
aB4YrZwOckbi4YjTJY26NcqTCVG1kFa4cPpS0L/Yl6iyLaEMTSTCbeIZ7ASEo3gv
QQmEOD/SZumNgBt4BoAIADHiN4X9UdQIRF2D1fnmHxxCZI9iEK2vvV4veKNAwAgp
10XVA2YWqoXHGq130hSQbjjE3r5OJ30LcwjgcQoJP9l0ZoLCOxDYhkUIe12Pl123
+eR4o8+JdeOonzk5HZ6zrDLgo6zlQ62madmkHoa3bZjxT8TIcaggR9MRNVxinRC4
FVXykogm97Uu2Sxd6VnhmYUDfaVgKPiqe+Nm7qxFnR/rbCl5rE2xQ7tN9Vm+MKbo
lj9Cx2558iTXX0hE0ESgV0ygCk79csnSr/8IIkqVKYm2dMbjYQxQsc7ePJQ/qxEL
nPdJ4f4ZaZO0fyMjAdYxZxfAuAq1cUAcw3yVoKGEoZTTyH7Ma6gx+U/jllwF9zHa
4b/mvYz9Yxtj/4up14p0
=G5S6
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--

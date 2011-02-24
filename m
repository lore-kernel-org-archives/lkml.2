Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1BYIOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:14:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1BYIOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:14:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 01/15] dt/powerpc: move of_bus_type infrastructure to ibmebus
Date: Thu, 24 Feb 2011 15:46:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
        davem@davemloft.net, sparclinux@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6> <20110223043340.20795.84024.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043340.20795.84024.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241546.48790.arnd@arndb.de>
X-Provags-ID: V02:K0:cOtC8GCqwlQJTr4ICRDrM6aFD/mGpC+YtYYfdwe/QxN
 yq8UUWHdtsSrZnPCJLJIvrnC/cZsJ6+PYK3mYb0zAhZ2SvS+oe
 s+FqXYQkntRRg8CWBPt3wF/38XAAx22LEJiee5mnzSmoQuS1Cg
 d+jXwwDmpiwQNnHxEfknla0xjQVFxNOq7toFHB4L76SjmmHxWL
 lWDX0b2OXRFRkmoFjOq7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 February 2011, Grant Likely wrote:
> arch/powerpc/kernel/ibmebus.c is the only remaining user of the
> of_bus_type support code for initializing the bus and registering
> drivers.  All others have either been switched to the vanilla platform
> bus or already have their own infrastructure.
> 
> This patch moves the functionality that ibmebus is using out of
> drivers/of/{platform,device}.c and into ibmebus.c where it is actually
> used.  Also renames the moved symbols from of_platform_* to
> ibmebus_bus_* to reflect the actual usage.
> 
> This patch is part of moving all of the of_platform_bus_type users
> over to the platform_bus_type.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

The ibmebus is essentially the platform bus of the IBM Power Systems (a.k.a.
pSeries a.k.a. System p), I think it would make a lot of sense to convert
the two drivers (ehca and ehea) on this bus into platform drivers as well.

The original reason for this bus was to provide a different IOMMU for them
than what is used on the PCI devices. This should now be possible in simpler
ways.
 
>
> +static void ibmebus_bus_device_shutdown(struct device *dev)
> +{
> +	struct platform_device *of_dev = to_platform_device(dev);
> +	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
> +
> +	if (dev->driver && drv->shutdown)
> +		drv->shutdown(of_dev);
> +}

neither of the drivers provides a shutdown function.

> +#ifdef CONFIG_PM_SLEEP
> +static int ibmebus_bus_legacy_suspend(struct device *dev, pm_message_t mesg)
> +{
> +	struct platform_device *of_dev = to_platform_device(dev);
> +	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
> +	int ret = 0;
> +
> +	if (dev->driver && drv->suspend)
> +		ret = drv->suspend(of_dev, mesg);
> +	return ret;
> +}
> +
> +static int ibmebus_bus_legacy_resume(struct device *dev)
> +{
> +	struct platform_device *of_dev = to_platform_device(dev);
> +	struct of_platform_driver *drv = to_of_platform_driver(dev->driver);
> +	int ret = 0;
> +
> +	if (dev->driver && drv->resume)
> +		ret = drv->resume(of_dev);
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_prepare(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (drv && drv->pm && drv->pm->prepare)
> +		ret = drv->pm->prepare(dev);
> +
> +	return ret;
> +}
> +
> +static void ibmebus_bus_pm_complete(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +
> +	if (drv && drv->pm && drv->pm->complete)
> +		drv->pm->complete(dev);
> +}
> +
> +#ifdef CONFIG_SUSPEND
> +
> +static int ibmebus_bus_pm_suspend(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->suspend)
> +			ret = drv->pm->suspend(dev);
> +	} else {
> +		ret = ibmebus_bus_legacy_suspend(dev, PMSG_SUSPEND);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_suspend_noirq(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->suspend_noirq)
> +			ret = drv->pm->suspend_noirq(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_resume(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->resume)
> +			ret = drv->pm->resume(dev);
> +	} else {
> +		ret = ibmebus_bus_legacy_resume(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_resume_noirq(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->resume_noirq)
> +			ret = drv->pm->resume_noirq(dev);
> +	}
> +
> +	return ret;
> +}

These are also unused in the drivers.

> +#ifdef CONFIG_HIBERNATION
> +
> +static int ibmebus_bus_pm_freeze(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->freeze)
> +			ret = drv->pm->freeze(dev);
> +	} else {
> +		ret = ibmebus_bus_legacy_suspend(dev, PMSG_FREEZE);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_freeze_noirq(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->freeze_noirq)
> +			ret = drv->pm->freeze_noirq(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_thaw(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->thaw)
> +			ret = drv->pm->thaw(dev);
> +	} else {
> +		ret = ibmebus_bus_legacy_resume(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_thaw_noirq(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->thaw_noirq)
> +			ret = drv->pm->thaw_noirq(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_poweroff(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->poweroff)
> +			ret = drv->pm->poweroff(dev);
> +	} else {
> +		ret = ibmebus_bus_legacy_suspend(dev, PMSG_HIBERNATE);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_poweroff_noirq(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->poweroff_noirq)
> +			ret = drv->pm->poweroff_noirq(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_restore(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->restore)
> +			ret = drv->pm->restore(dev);
> +	} else {
> +		ret = ibmebus_bus_legacy_resume(dev);
> +	}
> +
> +	return ret;
> +}
> +
> +static int ibmebus_bus_pm_restore_noirq(struct device *dev)
> +{
> +	struct device_driver *drv = dev->driver;
> +	int ret = 0;
> +
> +	if (!drv)
> +		return 0;
> +
> +	if (drv->pm) {
> +		if (drv->pm->restore_noirq)
> +			ret = drv->pm->restore_noirq(dev);
> +	}
> +
> +	return ret;
> +}

And these, too.

	Arnd


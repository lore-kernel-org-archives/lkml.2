Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab1HKM5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:57:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54468 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1HKM5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:57:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kenneth Heitke <kheitke@codeaurora.org>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Thu, 11 Aug 2011 14:55:55 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
In-Reply-To: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108111455.56319.arnd@arndb.de>
X-Provags-ID: V02:K0:sJNMPyazsPycN85+kq4WaZE1ToPnTcmAaFyfEyUua9c
 kRJskQNM/BAOMUcX2+McS+ITugSwGogeqwVX27tqUqvp7roieT
 OTOWAMHMjXFY6T/EUGVqEUtaf67gmcu3j2cTrpGpTKW54TGxhJ
 nb5X8Ta1tPUP5dvTs+xjG+5FCcR3ILcTUYevi8un3+07tSjXSj
 211VEHIy3/gUun+J8fXaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 August 2011, Kenneth Heitke wrote:
> From: Sagar Dharia <sdharia@codeaurora.org>
> 
> SLIMbus (Serial Low Power Interchip Media Bus) is a specification
> developed by MIPI (Mobile Industry Processor Interface) alliance.

Hi Kenneth and Sagar,

On a very high level, I think the driver is in the right place here,
and it's appropriate to have a new bus type along with similar
existing bus_types like i2c. It's also good to see that you have
a good documentation file for this bus.

My main issue with the driver is the device registration method
that now looks a bit aged. More about this below.

> +
> +struct device slimbus_dev = {
> +	.init_name = "slimbus",
> +};
> +
> +static void __exit slimbus_exit(void)
> +{
> +	device_unregister(&slimbus_dev);
> +	bus_unregister(&slimbus_type);
> +}
> +
> +static int __init slimbus_init(void)
> +{
> +	int retval;
> +
> +	retval = bus_register(&slimbus_type);
> +	if (!retval)
> +		retval = device_register(&slimbus_dev);
> +
> +	if (retval)
> +		bus_unregister(&slimbus_type);
> +
> +	return retval;
> +}
> +postcore_initcall(slimbus_init);
> +module_exit(slimbus_exit);

Why do you need slimbus_dev? I think it would be cleaner to
set the parent of each controller to the device that actually
acts as their physical parent, e.g. an SOC device or an AMBA
bus.

> +static int slim_drv_probe(struct device *dev)
> +{
> +	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
> +
> +	if (sdrv->probe)
> +		return sdrv->probe(to_slim_device(dev));
> +	return -ENODEV;
> +}
> +
> +static int slim_drv_remove(struct device *dev)
> +{
> +	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
> +
> +	if (sdrv->remove)
> +		return sdrv->remove(to_slim_device(dev));
> +	return -ENODEV;
> +}
> +
> +static void slim_drv_shutdown(struct device *dev)
> +{
> +	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
> +
> +	if (sdrv->shutdown)
> +		sdrv->shutdown(to_slim_device(dev));
> +}
> +
> +/*
> + * slim_driver_register: Client driver registration with slimbus
> + * @drv:Client driver to be associated with client-device.
> + * This API will register the client driver with the slimbus
> + * It is called from the driver's module-init function.
> + */
> +int slim_driver_register(struct slim_driver *drv)
> +{
> +	drv->driver.bus = &slimbus_type;
> +	if (drv->probe)
> +		drv->driver.probe = slim_drv_probe;
> +
> +	if (drv->remove)
> +		drv->driver.remove = slim_drv_remove;
> +
> +	if (drv->shutdown)
> +		drv->driver.shutdown = slim_drv_shutdown;
> +
> +	return driver_register(&drv->driver);
> +}
> +EXPORT_SYMBOL_GPL(slim_driver_register);

No need to check the ->probe/->remove/->shutdown fields twice.

> +/*
> + * slim_add_device: Add a new device without register board info.
> + * @ctrl: Controller to which this device is to be added to.
> + * Called when device doesn't have an explicit client-driver to be probed, or
> + * the client-driver is a module installed dynamically.
> + */
> +int slim_add_device(struct slim_controller *ctrl, struct slim_device *sbdev)
> +{
> +	int ret = 0;
> +
> +	sbdev->dev.bus = &slimbus_type;
> +	sbdev->dev.parent = ctrl->dev.parent;
> +	sbdev->dev.type = &slim_dev_type;
> +	sbdev->ctrl = ctrl;
> +	slim_ctrl_get(ctrl);
> +	dev_set_name(&sbdev->dev, "%s", sbdev->name);
> +	/* probe slave on this controller */
> +	ret = device_register(&sbdev->dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	mutex_init(&sbdev->sldev_reconf);
> +	INIT_LIST_HEAD(&sbdev->mark_define);
> +	INIT_LIST_HEAD(&sbdev->mark_suspend);
> +	INIT_LIST_HEAD(&sbdev->mark_removal);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(slim_add_device);

I don't think this should be exported: AFAICT, the set of slim_devices
is a property of the platform, so I don't see how any other device driver
would add another device.

> +/*
> + * slim_register_board_info: Board-initialization routine.
> + * @info: List of all devices on all controllers present on the board.
> + * @n: number of entries.
> + * API enumerates respective devices on corresponding controller.
> + * Called from board-init function.
> + */
> +int slim_register_board_info(struct slim_boardinfo const *info, unsigned n)
> +{
> +	struct sbi_boardinfo *bi;
> +	int i;
> +
> +	bi = kzalloc(n * sizeof(*bi), GFP_KERNEL);
> +	if (!bi)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < n; i++, bi++, info++) {
> +		struct slim_controller *ctrl;
> +
> +		memcpy(&bi->board_info, info, sizeof(*info));
> +		mutex_lock(&board_lock);
> +		list_add_tail(&bi->list, &board_list);
> +		list_for_each_entry(ctrl, &slim_ctrl_list, list)
> +			slim_match_ctrl_to_boardinfo(ctrl, &bi->board_info);
> +		mutex_unlock(&board_lock);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(slim_register_board_info);

We are trying to gradually convert platforms that have hardcoded device
lists and cannot probe devices by looking at the hardware over to using
device tree files that list all the devices.

I think that this would work well for slimbus and should be done
right from the start. This means however that you should not
register a "board_info" but instead change the slim_register_controller
function so that it adds all devices listed as children of the
controller in the device tree.

> +/*
> + * slim_busnum_to_ctrl: Map bus number to controller
> + * @busnum: Bus number
> + * Returns controller representing this bus number
> + */
> +struct slim_controller *slim_busnum_to_ctrl(u32 bus_num)
> +{
> +	struct slim_controller *ctrl;
> +	mutex_lock(&board_lock);
> +	list_for_each_entry(ctrl, &slim_ctrl_list, list)
> +		if (bus_num == ctrl->nr) {
> +			mutex_unlock(&board_lock);
> +			return ctrl;
> +		}
> +	mutex_unlock(&board_lock);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(slim_busnum_to_ctrl);

What is this function used for? I would expect that no other driver
should care about bus numbers if you get the probing right.

> +/*
> + * slim_add_numbered_controller: Controller bring-up.
> + * @ctrl: Controller to be registered.
> + * A controller is registered with the framework using this API. ctrl->nr is the
> + * desired number with which slimbus framework registers the controller.
> + * Function will return -EBUSY if the number is in use.
> + */
> +int slim_add_numbered_controller(struct slim_controller *ctrl)

Same for this one.

> +static int slim_sched_chans(struct slim_device *sb, u32 clkgear,
> +			u32 *ctrlw, u32 *subfrml)

I don't understand what this function does, but I can see that it's
too long to be readable. Please just split it into smaller functions.

	Arnd

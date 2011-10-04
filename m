Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab1JDOwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:52:17 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51000 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab1JDOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:52:09 -0400
Date: Tue, 4 Oct 2011 20:21:48 +0530
From: "G, Manjunath Kondaiah" <manjugk@ti.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <greg@kroah.com>, Dilan Lee <dilee@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Message-ID: <20111004145148.GA8021@manju-desktop>
References: <20110922184614.25419.84606.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110922184614.25419.84606.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, Sep 22, 2011 at 12:51:23PM -0600, Grant Likely wrote:
> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.
> 
> This should completely solve the problem of getting devices
> initialized in the right order.  Right now this is mostly handled by
> mucking about with initcall ordering which is a complete hack, and
> doesn't even remotely handle the case where device drivers are in
> modules.  This approach completely sidesteps the issues by allowing
> driver registration to occur in any order, and any driver can request
> to be retried after a few more other drivers get probed.
> 
> v3: - Hold off workqueue scheduling until late_initcall so that the bulk
>       of driver probes are complete before we start retrying deferred devices.
>     - Tested with simple use cases.  Still needs more testing though.
>       Using it to get rid of the gpio early_initcall madness, or to replace
>       the ASoC internal probe deferral code would be ideal.
> v2: - added locking so it should no longer be utterly broken in that regard
>     - remove device from deferred list at device_del time.
>     - Still completely untested with any real use case, but has been
>       boot tested.
> 
> TODO: - Create a separate singlethread_workqueue so that drivers can't
>         mess things up by calling flush_work().
>       - Maybe this should be wrapped with a kconfig symbol so it can
>         be compiled out on systems that don't care.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Greg Kroah-Hartman <greg@kroah.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Dilan Lee <dilee@nvidia.com>
> Cc: Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>
> ---
> 
> Hi Manjunath,
> 
> Here's the current state of the patch.  The major think that needs to
> be done is to convert it to use a separate workqueue as described in
> the TODO above.  It also needs some users adapted to it.  One of the
> gpio drivers would work; preferably one of the newer drivers that
> doesn't have a lot of drivers depending on the early_initcall()
> behaviour yet.

I have tested this patch on omap3 beagle board by making:
1. omap-gpio driver init as late_initcall instead of postcore_initcall
2. mmc driver probe will request gpio through gpio_request and gpio driver
returns -EDEFER_PROBE which in turn makes mmc driver to request deferral probe.
3. When deferral probe gets activated, it scans driver entries and it will not 
find any match for mmc driver probe.

After step 3, mmc driver probe will not get called due to device and driver
mismatch during "bus_for_each_drv" execution.

The behaviour is no different when it is used with singlethread_workqueue.

Here is bootlog:
Texas Instruments X-Loader 1.4.2 (Feb 19 2009 - 12:01:24)
Reading boot sector
Loading u-boot.bin from mmc


U-Boot 2009.11 (Feb 23 2010 - 15:33:48)

OMAP3530-GP ES3.0, CPU-OPP2 L3-165MHz
OMAP3 Beagle board + LPDDR/NAND
I2C:   ready
DRAM:  128 MB
NAND:  256 MiB
In:    serial
Out:   serial
Err:   serial
Board revision Ax/Bx
Die ID #5ac400030000000004013f8901001001
Hit any key to stop autoboot:  0 
mmc0 is available
mmc - MMC sub-system

Usage:
mmc init [dev] - init MMC sub system
mmc device [dev] - show or set current device
reading uImage

3237432 bytes read
## Booting kernel from Legacy Image at 80000000 ...
      Image Name:   Linux-3.1.0-rc8-00001-g4dc9843-d
      Image Type:   ARM Linux Kernel Image (uncompressed)
      Data Size:    3237368 Bytes =  3.1 MB
      Load Address: 80008000
      Entry Point:  80008000
      Verifying Checksum ... OK
      Kernel Image ... OK
OK

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
[    0.000000] Linux version 3.1.0-rc8-00001-g4dc9843-dirty (manju@manju-desktop) (gcc version 4.5.2 (Ubuntu/Linaro4.5.2-8ubuntu3) ) #7 SMP Tue Oct 4 19:19:49 IST 2011
[    0.000000] CPU: ARMv7 Processor [411fc083] revision 3 (ARMv7), cr=10c53c7f
[    0.000000] CPU: VIPT nonaliasing data cache, VIPT nonaliasing instruction cache
[    0.000000] Machine: OMAP3 Beagle Board
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] OMAP3430/3530 ES3.0 (l2cache iva sgx neon isp)

...

[    3.554656] driver_probe_device: drv->name: omap_hsmmc
[    3.560241] omap_hsmmc_probe: ...........Enter *********************
[    3.566955] omap_hsmmc_gpio_init: ..... enter .........!!!!
[    3.572906] platform omap_hsmmc.0: Driver omap_hsmmc requests probe deferral

...

[    3.712097] driver_probe_device: drv->name: omap_gpio
[    3.717681] omap_device: omap_gpio.0: new worst case activate latency 0: 30517
[    3.727813] OMAP GPIO hardware version 2.5
[    3.732421] driver_probe_device: drv->name: omap_gpio
[    3.739776] driver_probe_device: drv->name: omap_gpio
[    3.747039] driver_probe_device: drv->name: omap_gpio
[    3.754241] driver_probe_device: drv->name: omap_gpio
[    3.761413] driver_probe_device: drv->name: omap_gpio
...
[    3.800170] platform omap_hsmmc.0: Retrying from deferred list
[    3.806304] bus_probe_device: device autoprobe 
[    3.811096] device_attach: ...........test-1
[    3.815643] __device_attach: ...........test-4
[    3.820312] __device_attach: ...........test-4
[    3.825012] __device_attach: ...........test-4
[    3.829681] __device_attach: ...........test-4
[    3.834411] __device_attach: ...........test-4
[    3.839111] __device_attach: ...........test-4
[    3.843749] __device_attach: ...........test-4
[    3.848480] __device_attach: ...........test-4
[    3.853118] __device_attach: ...........test-4
[    3.857818] __device_attach: ...........test-4
[    3.862548] __device_attach: ...........test-4
[    3.867218] __device_attach: ...........test-4
[    3.871917] __device_attach: ...........test-4
[    3.876556] __device_attach: ...........test-4
[    3.881286] __device_attach: ...........test-4
[    3.885986] __device_attach: ...........test-4
[    3.890655] __device_attach: ...........test-4
[    3.895355] __device_attach: ...........test-4
[    3.900024] __device_attach: ...........test-4
[    3.904724] __device_attach: ...........test-4
[    3.909423] __device_attach: ...........test-4
[    3.914093] __device_attach: ...........test-4
[    3.918792] __device_attach: ...........test-4
[    3.923461] __device_attach: ...........test-4
[    3.928192] __device_attach: ...........test-4
[    3.932891] __device_attach: ...........test-4
[    3.937530] __device_attach: ...........test-4

[    3.944458] input: gpio-keys as /devices/platform/gpio-keys/input/input1
[    3.955657] twl_rtc twl_rtc: setting system clock to 2000-01-01 00:01:59 UTC (946684919)
[    3.969390] Waiting for root device /dev/mmcblk0p2...

Here it hangs since MMC driver is not ready!

-Manjunath


> 
> Mark Brown may also be able to suggest specific examples.
> 
> For everyone else; this is the current state of the patch.  I think it
> is in pretty good shape other than the TODO item above.  I'm turning
> it over to Manjunath to  polish up for merging.  I would appreciate
> any feedback.
> 
> g.
> 
> 
>  drivers/base/base.h    |    1 
>  drivers/base/core.c    |    2 +
>  drivers/base/dd.c      |  134 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |    5 ++
>  4 files changed, 141 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index a34dca0..9641309 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -105,6 +105,7 @@ extern void bus_remove_driver(struct device_driver *drv);
>  
>  extern void driver_detach(struct device_driver *drv);
>  extern int driver_probe_device(struct device_driver *drv, struct device *dev);
> +extern void driver_deferred_probe_del(struct device *dev);
>  static inline int driver_match_device(struct device_driver *drv,
>  				      struct device *dev)
>  {
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index bc8729d..0d37e18 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -588,6 +588,7 @@ void device_initialize(struct device *dev)
>  {
>  	dev->kobj.kset = devices_kset;
>  	kobject_init(&dev->kobj, &device_ktype);
> +	INIT_LIST_HEAD(&dev->deferred_probe);
>  	INIT_LIST_HEAD(&dev->dma_pools);
>  	mutex_init(&dev->mutex);
>  	lockdep_set_novalidate_class(&dev->mutex);
> @@ -1119,6 +1120,7 @@ void device_del(struct device *dev)
>  	device_remove_file(dev, &uevent_attr);
>  	device_remove_attrs(dev);
>  	bus_remove_device(dev);
> +	driver_deferred_probe_del(dev);
>  
>  	/*
>  	 * Some platform devices are driven without driver attached
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 6658da7..8be5b33 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -28,6 +28,129 @@
>  #include "base.h"
>  #include "power/power.h"
>  
> +/*
> + * Deferred Probe infrastructure.
> + *
> + * Sometimes driver probe order matters, but the kernel doesn't always have
> + * dependency information which means some drivers will get probed before a
> + * resource it depends on is available.  For example, an SDHCI driver may
> + * first need a GPIO line from an i2c GPIO controller before it can be
> + * initialized.  If a required resource is not available yet, a driver can
> + * request probing to be deferred by returning -EAGAIN from its probe hook
> + *
> + * Deferred probe maintains two lists of devices, a pending list and an active
> + * list.  A driver returning -EAGAIN causes the device to be added to the
> + * pending list.
> + *
> + * The deferred_probe_mutex *must* be held any time the deferred_probe_*_list
> + * of the (struct device*)->deferred_probe pointers are manipulated
> + */
> +static DEFINE_MUTEX(deferred_probe_mutex);
> +static LIST_HEAD(deferred_probe_pending_list);
> +static LIST_HEAD(deferred_probe_active_list);
> +
> +/**
> + * deferred_probe_work_func() - Retry probing devices in the active list.
> + */
> +static void deferred_probe_work_func(struct work_struct *work)
> +{
> +	struct device *dev;
> +	/*
> +	 * This bit is tricky.  We want to process every device in the
> +	 * deferred list, but devices can be removed from the list at any
> +	 * time while inside this for-each loop.  There are two things that
> +	 * need to be protected against:
> +	 * - if the device is removed from the deferred_probe_list, then we
> +	 *   loose our place in the loop.  Since any device can be removed
> +	 *   asynchronously, list_for_each_entry_safe() wouldn't make things
> +	 *   much better.  Simplest solution is to restart walking the list
> +	 *   whenever the current device gets removed.  Not the most efficient,
> +	 *   but is simple to implement and easy to audit for correctness.
> +	 * - if the device is unregistered, and freed, then there is a risk
> +	 *   of a null pointer dereference.  This code uses get/put_device()
> +	 *   to ensure the device cannot disappear from under our feet.
> +	 */
> +	mutex_lock(&deferred_probe_mutex);
> +	while (!list_empty(&deferred_probe_active_list)) {
> +		dev = list_first_entry(&deferred_probe_active_list,
> +					typeof(*dev), deferred_probe);
> +		list_del_init(&dev->deferred_probe);
> +
> +		get_device(dev);
> +
> +		/* Drop the mutex while probing each device; the probe path
> +		 * may manipulate the deferred list */
> +		mutex_unlock(&deferred_probe_mutex);
> +		dev_dbg(dev, "Retrying from deferred list\n");
> +		bus_probe_device(dev);
> +		mutex_lock(&deferred_probe_mutex);
> +
> +		put_device(dev);
> +	}
> +	mutex_unlock(&deferred_probe_mutex);
> +}
> +static DECLARE_WORK(deferred_probe_work, deferred_probe_work_func);
> +
> +static void driver_deferred_probe_add(struct device *dev)
> +{
> +	mutex_lock(&deferred_probe_mutex);
> +	if (list_empty(&dev->deferred_probe)) {
> +		dev_dbg(dev, "Added to deferred list\n");
> +		list_add(&dev->deferred_probe, &deferred_probe_pending_list);
> +	}
> +	mutex_unlock(&deferred_probe_mutex);
> +}
> +
> +void driver_deferred_probe_del(struct device *dev)
> +{
> +	mutex_lock(&deferred_probe_mutex);
> +	if (!list_empty(&dev->deferred_probe)) {
> +		dev_dbg(dev, "Removed from deferred list\n");
> +		list_del_init(&dev->deferred_probe);
> +	}
> +	mutex_unlock(&deferred_probe_mutex);
> +}
> +
> +static bool driver_deferred_probe_enable = false;
> +/**
> + * driver_deferred_probe_trigger() - Kick off re-probing deferred devices
> + *
> + * This functions moves all devices from the pending list to the active
> + * list and schedules the deferred probe workqueue to process them.  It
> + * should be called anytime a driver is successfully bound to a device.
> + */
> +static void driver_deferred_probe_trigger(void)
> +{
> +	if (!driver_deferred_probe_enable)
> +		return;
> +
> +	/* A successful probe means that all the devices in the pending list
> +	 * should be triggered to be reprobed.  Move all the deferred devices
> +	 * into the active list so they can be retried by the workqueue */
> +	mutex_lock(&deferred_probe_mutex);
> +	list_splice_tail_init(&deferred_probe_pending_list,
> +			      &deferred_probe_active_list);
> +	mutex_unlock(&deferred_probe_mutex);
> +
> +	/* Kick the re-probe thread.  It may already be scheduled, but
> +	 * it is safe to kick it again. */
> +	schedule_work(&deferred_probe_work);
> +}
> +
> +/**
> + * deferred_probe_initcall() - Enable probing of deferred devices
> + *
> + * We don't want to get in the way when the bulk of drivers are getting probed.
> + * Instead, this initcall makes sure that deferred probing is delayed until
> + * late_initcall time.
> + */
> +static int deferred_probe_initcall(void)
> +{
> +	driver_deferred_probe_enable = true;
> +	driver_deferred_probe_trigger();
> +	return 0;
> +}
> +late_initcall(deferred_probe_initcall);
>  
>  static void driver_bound(struct device *dev)
>  {
> @@ -42,6 +165,11 @@ static void driver_bound(struct device *dev)
>  
>  	klist_add_tail(&dev->p->knode_driver, &dev->driver->p->klist_devices);
>  
> +	/* Make sure the device is no longer in one of the deferred lists
> +	 * and kick off retrying all pending devices */
> +	driver_deferred_probe_del(dev);
> +	driver_deferred_probe_trigger();
> +
>  	if (dev->bus)
>  		blocking_notifier_call_chain(&dev->bus->p->bus_notifier,
>  					     BUS_NOTIFY_BOUND_DRIVER, dev);
> @@ -142,7 +270,11 @@ probe_failed:
>  	driver_sysfs_remove(dev);
>  	dev->driver = NULL;
>  
> -	if (ret != -ENODEV && ret != -ENXIO) {
> +	if (ret == -EAGAIN) {
> +		/* Driver requested deferred probing */
> +		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
> +		driver_deferred_probe_add(dev);
> +	} else if (ret != -ENODEV && ret != -ENXIO) {
>  		/* driver matched but the probe failed */
>  		printk(KERN_WARNING
>  		       "%s: probe of %s failed with error %d\n",
> diff --git a/include/linux/device.h b/include/linux/device.h
> index c20dfbf..dab93a4 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -506,6 +506,10 @@ struct device_dma_parameters {
>   * @mutex:	Mutex to synchronize calls to its driver.
>   * @bus:	Type of bus device is on.
>   * @driver:	Which driver has allocated this
> + * @deferred_probe: entry in deferred_probe_list which is used to retry the
> + * 		binding of drivers which were unable to get all the resources
> + * 		needed by the device; typically because it depends on another
> + * 		driver getting probed first.
>   * @platform_data: Platform data specific to the device.
>   * 		Example: For devices on custom boards, as typical of embedded
>   * 		and SOC based hardware, Linux often uses platform_data to point
> @@ -564,6 +568,7 @@ struct device {
>  	struct bus_type	*bus;		/* type of bus device is on */
>  	struct device_driver *driver;	/* which driver has allocated this
>  					   device */
> +	struct list_head	deferred_probe;
>  	void		*platform_data;	/* Platform specific data, device
>  					   core doesn't touch it */
>  	struct dev_pm_info	power;
> 

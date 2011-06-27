Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1F0UvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 16:51:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33334 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab1F0UuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 16:50:04 -0400
Date: Mon, 27 Jun 2011 14:49:58 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>, Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 1/8] drivers: add generic remoteproc framework
Message-ID: <20110627204958.GB20865@ponder.secretlab.ca>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <1308640714-17961-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308640714-17961-2-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 10:18:27AM +0300, Ohad Ben-Cohen wrote:
> Some systems have slave heterogeneous remote processor devices,
> that are usually used to offload cpu-intensive computations
> (e.g. multimedia codec tasks).
> 
> Booting a remote processor typically involves:
> - Loading a firmware which contains the OS image (mainly text and data)
> - If needed, programming an IOMMU
> - Powering on the device
> 
> This patch introduces a generic remoteproc framework that allows drivers
> to start and stop those remote processor devices, load up their firmware
> (which might not necessarily be Linux-based), and in the future also
> support power management and error recovery.
> 
> It's still not clear how much this is really reusable for other
> platforms/architectures, especially the part that deals with the
> firmware.
> 
> Moreover, it's not entirely clear whether this should really be an
> independent layer, or if it should just be squashed with the host-specific
> component of the rpmsg framework (there isn't really a remoteproc use case
> that doesn't require rpmsg).
> 
> That said, it did prove useful for us on two completely different
> platforms: OMAP and Davinci, each with its different remote
> processor (Cortex-M3 and a C674x DSP, respectively). So to avoid
> egregious duplication of code, remoteproc must not be omap-only.
> 
> Firmware loader is based on code by Mark Grosen <mgrosen@ti.com>.
> 
> TODO:
> - drop rproc_da_to_pa(), use iommu_iova_to_phys() instead
>   (requires completion of omap's iommu migration and some generic iommu
>    API work)
> - instead of ioremapping reserved memory and handling IOMMUs, consider
>   moving to the generic DMA mapping API (with a CMA backend)
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Hi Ohad,

Overall, looks pretty nice to me.  Comments below...

> ---
>  Documentation/remoteproc.txt    |  170 +++++++++
>  drivers/Kconfig                 |    2 +
>  drivers/Makefile                |    1 +
>  drivers/remoteproc/Kconfig      |    7 +
>  drivers/remoteproc/Makefile     |    5 +
>  drivers/remoteproc/remoteproc.c |  780 +++++++++++++++++++++++++++++++++++++++
>  include/linux/remoteproc.h      |  273 ++++++++++++++
>  7 files changed, 1238 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/remoteproc.txt
>  create mode 100644 drivers/remoteproc/Kconfig
>  create mode 100644 drivers/remoteproc/Makefile
>  create mode 100644 drivers/remoteproc/remoteproc.c
>  create mode 100644 include/linux/remoteproc.h
> 
> diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
> new file mode 100644
> index 0000000..3075813
> --- /dev/null
> +++ b/Documentation/remoteproc.txt
> @@ -0,0 +1,170 @@
> +Remote Processor Framework
> +
> +1. Introduction
> +
> +Modern SoCs typically have heterogeneous remote processor devices in asymmetric
> +multiprocessing (AMP) configurations, which may be running different instances
> +of operating system, whether it's Linux or any other flavor of real-time OS.
> +
> +OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
> +In a typical configuration, the dual cortex-A9 is running Linux in a SMP
> +configuration, and each of the other three cores (two M3 cores and a DSP)
> +is running its own instance of RTOS in an AMP configuration.
> +
> +The generic remoteproc driver allows different platforms/architectures to
> +control (power on, load firmware, power off) those remote processors while
> +abstracting the hardware differences, so the entire driver doesn't need to be
> +duplicated.
> +
> +2. User API
> +
> +  struct rproc *rproc_get(const char *name);
> +   - power up the remote processor, identified by the 'name' argument,
> +     and boot it. If the remote processor is already powered on, the
> +     function immediately succeeds.
> +     On success, returns the rproc handle. On failure, NULL is returned.
> +
> +  void rproc_put(struct rproc *rproc);
> +   - power off the remote processor, identified by the rproc handle.
> +     Every call to rproc_get() must be (eventually) accompanied by a call
> +     to rproc_put(). Calling rproc_put() redundantly is a bug.
> +     Note: the remote processor will actually be powered off only when the
> +     last user calls rproc_put().
> +
> +3. Typical usage
> +
> +#include <linux/remoteproc.h>
> +
> +int dummy_rproc_example(void)
> +{
> +	struct rproc *my_rproc;
> +
> +	/* let's power on and boot the image processing unit */
> +	my_rproc = rproc_get("ipu");

I tend to be suspicious of apis whose primary interface is by-name
lookup.  It works fine when the system is small, but it can get
unwieldy when the client driver doesn't have a direct relation to the
setup code that chooses the name.  At some point I suspect that there
will need to be different lookup mechanism, such as which AMP
processor is currently available (if there are multiple of the same
type).

It also leaves no option for drivers to obtain a reference to the
rproc instance, and bring it up/down as needed (without the name
lookup every time).

That said, it looks like only the rproc_get() api is using by-name
lookup, and everything else is via the structure.  Can (should) the
by-name lookup part be factored out into a rproc_get_by_name()
accessor?

> +	if (!my_rproc) {
> +		/*
> +		 * something went wrong. handle it and leave.
> +		 */
> +	}
> +
> +	/*
> +	 * the 'ipu' remote processor is now powered on... let it work !
> +	 */
> +
> +	/* if we no longer need ipu's services, power it down */
> +	rproc_put(my_rproc);
> +}
> +
> +4. API for implementors
> +
> +  int rproc_register(struct device *dev, const char *name,
> +				const struct rproc_ops *ops,
> +				const char *firmware,
> +				const struct rproc_mem_entry *memory_maps,
> +				struct module *owner);
> +   - should be called from the underlying platform-specific implementation, in
> +     order to register a new remoteproc device. 'dev' is the underlying
> +     device, 'name' is the name of the remote processor, which will be
> +     specified by users calling rproc_get(), 'ops' is the platform-specific
> +     start/stop handlers, 'firmware' is the name of the firmware file to
> +     boot the processor with, 'memory_maps' is a table of da<->pa memory
> +     mappings which should be used to configure the IOMMU (if not relevant,
> +     just pass NULL here), 'owner' is the underlying module that should
> +     not be removed while the remote processor is in use.

Since rproc_register is allocating a struct rproc instance that
represent the device, shouldn't the pointer to that device be returned
to the caller?  Also, consider the use case that at some point someone
will need separate rproc_alloc and rproc_add steps so that it can
modify the structure between allocating and adding.  Otherwise you're
stuck in the model of having to modify the function signature to
rproc_register() every time a new feature is added that required
additional data; regardless of whether or not all drivers will use it.

> +
> +     Returns 0 on success, or an appropriate error code on failure.
> +
> +  int rproc_unregister(const char *name);

I definitely would not do this by name.  I think it is better to pass
the actual instance pointer to rproc_unregister.

> +   - should be called from the underlying platform-specific implementation, in
> +     order to unregister a remoteproc device that was previously registered
> +     with rproc_register().
> +
> +5. Implementation callbacks
> +
> +Every remoteproc implementation must provide these handlers:
> +
> +struct rproc_ops {
> +	int (*start)(struct rproc *rproc, u64 bootaddr);
> +	int (*stop)(struct rproc *rproc);
> +};
> +
> +The ->start() handler takes a rproc handle and an optional bootaddr argument,
> +and should power on the device and boot it (using the bootaddr argument
> +if the hardware requires one).

Naive question: Why is bootaddr an argument?  Wouldn't rproc drivers
keep track of the boot address in their driver private data?

> +On success, 0 is returned, and on failure, an appropriate error code.
> +
> +The ->stop() handler takes a rproc handle and powers the device off.
> +On success, 0 is returned, and on failure, an appropriate error code.
> +
> +6. Binary Firmware Structure
> +
> +The following enums and structures define the binary format of the images
> +remoteproc loads and boot the remote processors with.
> +
> +The general binary format is as follows:
> +
> +struct {
> +      char magic[4] = { 'R', 'P', 'R', 'C' };
> +      u32 version;
> +      u32 header_len;
> +      char header[...] = { header_len bytes of unformatted, textual header };
> +      struct section {
> +          u32 type;
> +          u64 da;
> +          u32 len;
> +          u8 content[...] = { len bytes of binary data };
> +      } [ no limit on number of sections ];
> +} __packed;

Other have commented on the image format, so I'll skip this bit other
than saying that I agree it would be great to have a common format.

> +Most likely this kind of static allocations of hardware resources for
> +remote processors can also use DT, so it's interesting to see how
> +this all work out when DT materializes.

I imagine that it will be quite straight forward.  There will probably
be a node in the tree to represent each slave AMP processor, and other
devices attached to it could be represented using 'phandle' links
between the nodes.  Any configuration of the AMP process can be
handled with arbitrary device-specific properties in the AMP
processor's node.

> diff --git a/drivers/Kconfig b/drivers/Kconfig
> index 3bb154d..1f6d6d3 100644
> --- a/drivers/Kconfig
> +++ b/drivers/Kconfig
> @@ -126,4 +126,6 @@ source "drivers/hwspinlock/Kconfig"
>  
>  source "drivers/clocksource/Kconfig"
>  
> +source "drivers/remoteproc/Kconfig"
> +

Hmmm, I wonder if the end of the drivers list is the best place for
this.  The drivers menu in kconfig is getting quite unwieldy.

>  endmenu
> diff --git a/drivers/Makefile b/drivers/Makefile
> index 09f3232..4d53a18 100644
> --- a/drivers/Makefile
> +++ b/drivers/Makefile
> @@ -122,3 +122,4 @@ obj-y				+= ieee802154/
>  obj-y				+= clk/
>  
>  obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
> +obj-$(CONFIG_REMOTE_PROC)	+= remoteproc/
> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> new file mode 100644
> index 0000000..a60bb12
> --- /dev/null
> +++ b/drivers/remoteproc/Kconfig
> @@ -0,0 +1,7 @@
> +#
> +# Generic framework for controlling remote processors
> +#
> +
> +# REMOTE_PROC gets selected by whoever wants it
> +config REMOTE_PROC
> +	tristate
> diff --git a/drivers/remoteproc/Makefile b/drivers/remoteproc/Makefile
> new file mode 100644
> index 0000000..d0f60c7
> --- /dev/null
> +++ b/drivers/remoteproc/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Generic framework for controlling remote processors
> +#
> +
> +obj-$(CONFIG_REMOTE_PROC)		+= remoteproc.o
> diff --git a/drivers/remoteproc/remoteproc.c b/drivers/remoteproc/remoteproc.c
> new file mode 100644
> index 0000000..2b0514b
> --- /dev/null
> +++ b/drivers/remoteproc/remoteproc.c
> @@ -0,0 +1,780 @@
> +/*
> + * Remote Processor Framework
> + *
> + * Copyright (C) 2011 Texas Instruments, Inc.
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * Ohad Ben-Cohen <ohad@wizery.com>
> + * Mark Grosen <mgrosen@ti.com>
> + * Brian Swetland <swetland@google.com>
> + * Fernando Guzman Lugo <fernando.lugo@ti.com>
> + * Robert Tivy <rtivy@ti.com>
> + * Armando Uribe De Leon <x0095078@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt)    "%s: " fmt, __func__
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/firmware.h>
> +#include <linux/io.h>
> +#include <linux/list.h>
> +#include <linux/debugfs.h>
> +#include <linux/remoteproc.h>
> +
> +/* list of the available remote processors */
> +static LIST_HEAD(rprocs);
> +/*
> + * This lock should be taken when the list of rprocs is accessed.
> + * Consider using RCU instead, since remote processors only get registered
> + * once (usually at boot), and then the list is only read accessed.
> + * Though right now the list is pretty short, and only rarely accessed.
> + */
> +static DEFINE_SPINLOCK(rprocs_lock);
> +
> +/* debugfs parent dir */
> +static struct dentry *rproc_dbg;
> +
> +/*
> + * Some remote processors may support dumping trace logs into a shared
> + * memory buffer. We expose this trace buffer using debugfs, so users
> + * can easily tell what's going on remotely.
> + */
> +static ssize_t rproc_format_trace_buf(char __user *userbuf, size_t count,
> +				    loff_t *ppos, const void *src, int size)
> +{
> +	const char *buf = (const char *) src;
> +	int i;
> +
> +	/*
> +	 * find the end of trace buffer (does not account for wrapping).
> +	 * desirable improvement: use a ring buffer instead.
> +	 */
> +	for (i = 0; i < size && buf[i]; i++);

Hmmm, I wonder if this could make use of the ftrace ring buffer.

> +
> +	return simple_read_from_buffer(userbuf, count, ppos, src, i);
> +}
> +
> +static int rproc_open_generic(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +#define DEBUGFS_READONLY_FILE(name, value, len)				\
> +static ssize_t name## _rproc_read(struct file *filp,			\
> +		char __user *userbuf, size_t count, loff_t *ppos)	\
> +{									\
> +	struct rproc *rproc = filp->private_data;			\
> +	return rproc_format_trace_buf(userbuf, count, ppos, value, len);\
> +}									\
> +									\
> +static const struct file_operations name ##_rproc_ops = {		\
> +	.read = name ##_rproc_read,					\
> +	.open = rproc_open_generic,					\
> +	.llseek	= generic_file_llseek,					\
> +};
> +
> +/*
> + * Currently we allow two trace buffers for each remote processor.
> + * This is helpful in case a single remote processor has two independent
> + * cores, each of which is running an independent OS image.
> + * The current implementation is straightforward and simple, and is
> + * rather limited to 2 trace buffers. If, in time, we'd realize we
> + * need additional trace buffers, then the code should be refactored
> + * and generalized.
> + */
> +DEBUGFS_READONLY_FILE(trace0, rproc->trace_buf0, rproc->trace_len0);
> +DEBUGFS_READONLY_FILE(trace1, rproc->trace_buf1, rproc->trace_len1);
> +
> +/* The state of the remote processor is exposed via debugfs, too */
> +const char *rproc_state_string(int state)
> +{
> +	const char *result;
> +
> +	switch (state) {
> +	case RPROC_OFFLINE:
> +		result = "offline";
> +		break;
> +	case RPROC_SUSPENDED:
> +		result = "suspended";
> +		break;
> +	case RPROC_RUNNING:
> +		result = "running";
> +		break;
> +	case RPROC_LOADING:
> +		result = "loading";
> +		break;
> +	case RPROC_CRASHED:
> +		result = "crashed";
> +		break;
> +	default:
> +		result = "invalid state";
> +		break;
> +	}

Me thinks this is asking for a lookup table.

> +
> +	return result;
> +}
> +
> +static ssize_t rproc_state_read(struct file *filp, char __user *userbuf,
> +						size_t count, loff_t *ppos)
> +{
> +	struct rproc *rproc = filp->private_data;
> +	int state = rproc->state;
> +	char buf[100];

100 bytes?  I count at most ~30.

> +	int i;
> +
> +	i = snprintf(buf, 100, "%s (%d)\n", rproc_state_string(state), state);
> +
> +	return simple_read_from_buffer(userbuf, count, ppos, buf, i);
> +}
> +
> +static const struct file_operations rproc_state_ops = {
> +	.read = rproc_state_read,
> +	.open = rproc_open_generic,
> +	.llseek	= generic_file_llseek,
> +};
> +
> +/* The name of the remote processor is exposed via debugfs, too */
> +static ssize_t rproc_name_read(struct file *filp, char __user *userbuf,
> +						size_t count, loff_t *ppos)
> +{
> +	struct rproc *rproc = filp->private_data;
> +	/* need room for the name, a newline and a terminating null */
> +	char buf[RPROC_MAX_NAME + 2];
> +	int i;
> +
> +	i = snprintf(buf, RPROC_MAX_NAME + 2, "%s\n", rproc->name);
> +
> +	return simple_read_from_buffer(userbuf, count, ppos, buf, i);
> +}
> +
> +static const struct file_operations rproc_name_ops = {
> +	.read = rproc_name_read,
> +	.open = rproc_open_generic,
> +	.llseek	= generic_file_llseek,
> +};
> +
> +#define DEBUGFS_ADD(name)						\
> +	debugfs_create_file(#name, 0400, rproc->dbg_dir,		\
> +			rproc, &name## _rproc_ops)

You might want to split the debug stuff off into a separate patch,
just to keep the review load down.  (up to you though).

> +
> +/**
> + * __find_rproc_by_name() - find a registered remote processor by name
> + * @name: name of the remote processor
> + *
> + * Internal function that returns the rproc @name, or NULL if @name does
> + * not exists.
> + */
> +static struct rproc *__find_rproc_by_name(const char *name)
> +{
> +	struct rproc *rproc;
> +	struct list_head *tmp;
> +
> +	spin_lock(&rprocs_lock);
> +
> +	list_for_each(tmp, &rprocs) {
> +		rproc = list_entry(tmp, struct rproc, next);
> +		if (!strcmp(rproc->name, name))
> +			break;
> +		rproc = NULL;
> +	}
> +
> +	spin_unlock(&rprocs_lock);

Unless you're going to be looking up the device at irq time, a mutex
is probably a better choice here.

> +
> +	return rproc;
> +}
> +

[ignoring da_to_pa bits because they are subject to change]
> +
> +/**
> + * rproc_start() - boot the remote processor
> + * @rproc: the remote processor
> + * @bootaddr: address of first instruction to execute (optional)
> + *
> + * Boot a remote processor (i.e. power it on, take it out of reset, etc..)
> + */
> +static void rproc_start(struct rproc *rproc, u64 bootaddr)
> +{
> +	struct device *dev = rproc->dev;
> +	int err;
> +
> +	err = mutex_lock_interruptible(&rproc->lock);
> +	if (err) {
> +		dev_err(dev, "can't lock remote processor %d\n", err);
> +		return;
> +	}
> +
> +	err = rproc->ops->start(rproc, bootaddr);
> +	if (err) {
> +		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, err);
> +		goto unlock_mutex;
> +	}
> +
> +	rproc->state = RPROC_RUNNING;
> +
> +	dev_info(dev, "remote processor %s is now up\n", rproc->name);

How often are remote processors likely to be brought up/down?  Do PM
events hard stop remote processors?  I only ask because I wonder if
this dev_info() will end up flooding the kernel log.

> +/**
> + * rproc_get() - boot the remote processor
> + * @name: name of the remote processor
> + *
> + * Boot a remote processor (i.e. load its firmware, power it on, take it
> + * out of reset, etc..).
> + *
> + * If the remote processor is already powered on, immediately return
> + * its rproc handle.
> + *
> + * On success, returns the rproc handle. On failure, NULL is returned.
> + */
> +struct rproc *rproc_get(const char *name)
> +{
> +	struct rproc *rproc, *ret = NULL;
> +	struct device *dev;
> +	int err;
> +
> +	rproc = __find_rproc_by_name(name);
> +	if (!rproc) {
> +		pr_err("can't find remote processor %s\n", name);
> +		return NULL;
> +	}
> +
> +	dev = rproc->dev;
> +
> +	err = mutex_lock_interruptible(&rproc->lock);
> +	if (err) {
> +		dev_err(dev, "can't lock remote processor %s\n", name);
> +		return NULL;
> +	}
> +
> +	/* prevent underlying implementation from being removed */
> +	if (!try_module_get(rproc->owner)) {
> +		dev_err(dev, "%s: can't get owner\n", __func__);
> +		goto unlock_mutex;
> +	}
> +
> +	/* skip the boot process if rproc is already (being) powered up */
> +	if (rproc->count++) {
> +		ret = rproc;
> +		goto unlock_mutex;
> +	}
> +
> +	/* rproc_put() calls should wait until async loader completes */
> +	init_completion(&rproc->firmware_loading_complete);
> +
> +	dev_info(dev, "powering up %s\n", name);
> +
> +	/* loading a firmware is required */
> +	if (!rproc->firmware) {
> +		dev_err(dev, "%s: no firmware to load\n", __func__);
> +		goto deref_rproc;
> +	}
> +
> +	/*
> +	 * Initiate an asynchronous firmware loading, to allow building
> +	 * remoteproc as built-in kernel code, without hanging the boot process
> +	 */
> +	err = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
> +			rproc->firmware, dev, GFP_KERNEL, rproc, rproc_load_fw);
> +	if (err < 0) {
> +		dev_err(dev, "request_firmware_nowait failed: %d\n", err);
> +		goto deref_rproc;
> +	}
> +
> +	rproc->state = RPROC_LOADING;
> +	ret = rproc;
> +	goto unlock_mutex;
> +
> +deref_rproc:
> +	complete_all(&rproc->firmware_loading_complete);
> +	module_put(rproc->owner);
> +	--rproc->count;
> +unlock_mutex:
> +	mutex_unlock(&rproc->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(rproc_get);
> +
> +/**
> + * rproc_put() - power off the remote processor
> + * @rproc: the remote processor
> + *
> + * Release an rproc handle previously acquired with rproc_get(),
> + * and if we're the last user, power the processor off.
> + *
> + * Every call to rproc_get() must be (eventually) accompanied by a call
> + * to rproc_put(). Calling rproc_put() redundantly is a bug.
> + */
> +void rproc_put(struct rproc *rproc)
> +{
> +	struct device *dev = rproc->dev;
> +	int ret;
> +
> +	/*
> +	 * make sure rproc_get() was called beforehand.
> +	 * it should be safe to check for zero without taking the lock.
> +	 */

However, it may be non-zero here, but drop to zero by the time you
take the lock.  Best be safe and put it inside the mutex.  Having it
under the mutex shouldn't be a performance hit since only buggy code
will get this test wrong.  In fact, it is probably appropriate to
WARN_ON() on the !rproc->count condition.

Actually, using a hand coded reference count like this shouldn't be
done.  Use a kobject or a kref instead.  Looking at the code, I
suspect you'll want separate reference counting for object references
and power up/down count so that clients can control power to a device
without giving up the pointer to the rproc instance.

> +	if (!rproc->count) {
> +		dev_err(dev, "asymmetric put (fogot to call rproc_get ?)\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* if rproc is just being loaded now, wait */
> +	wait_for_completion(&rproc->firmware_loading_complete);
> +
> +	ret = mutex_lock_interruptible(&rproc->lock);
> +	if (ret) {
> +		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, ret);
> +		return;
> +	}
> +
> +	/* if the remote proc is still needed, bail out */
> +	if (--rproc->count)
> +		goto out;
> +
> +	if (rproc->trace_buf0)
> +		/* iounmap normal memory, so make sparse happy */
> +		iounmap((__force void __iomem *) rproc->trace_buf0);
> +	if (rproc->trace_buf1)
> +		/* iounmap normal memory, so make sparse happy */
> +		iounmap((__force void __iomem *) rproc->trace_buf1);

Icky casting!  That suggests that how the trace buffer pointer is
managed needs work.

> +
> +	rproc->trace_buf0 = rproc->trace_buf1 = NULL;
> +
> +	/*
> +	 * make sure rproc is really running before powering it off.
> +	 * this is important, because the fw loading might have failed.
> +	 */
> +	if (rproc->state == RPROC_RUNNING) {
> +		ret = rproc->ops->stop(rproc);
> +		if (ret) {
> +			dev_err(dev, "can't stop rproc: %d\n", ret);
> +			goto out;
> +		}
> +	}
> +
> +	rproc->state = RPROC_OFFLINE;
> +
> +	dev_info(dev, "stopped remote processor %s\n", rproc->name);
> +
> +out:
> +	mutex_unlock(&rproc->lock);
> +	if (!ret)
> +		module_put(rproc->owner);
> +}
> +EXPORT_SYMBOL(rproc_put);
> +
> +/**
> + * rproc_register() - register a remote processor
> + * @dev: the underlying device
> + * @name: name of this remote processor
> + * @ops: platform-specific handlers (mainly start/stop)
> + * @firmware: name of firmware file to load
> + * @memory_maps: IOMMU settings for this rproc (optional)
> + * @owner: owning module
> + *
> + * Registers a new remote processor in the remoteproc framework.
> + *
> + * This is called by the underlying platform-specific implementation,
> + * whenever a new remote processor device is probed.
> + *
> + * On succes, 0 is return, and on failure an appropriate error code.
> + */
> +int rproc_register(struct device *dev, const char *name,
> +				const struct rproc_ops *ops,
> +				const char *firmware,
> +				const struct rproc_mem_entry *memory_maps,
> +				struct module *owner)
> +{
> +	struct rproc *rproc;
> +
> +	if (!dev || !name || !ops)
> +		return -EINVAL;
> +
> +	rproc = kzalloc(sizeof(struct rproc), GFP_KERNEL);
> +	if (!rproc) {
> +		dev_err(dev, "%s: kzalloc failed\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	rproc->dev = dev;
> +	rproc->name = name;
> +	rproc->ops = ops;
> +	rproc->firmware = firmware;
> +	rproc->memory_maps = memory_maps;
> +	rproc->owner = owner;
> +
> +	mutex_init(&rproc->lock);
> +
> +	rproc->state = RPROC_OFFLINE;
> +
> +	spin_lock(&rprocs_lock);
> +	list_add_tail(&rproc->next, &rprocs);
> +	spin_unlock(&rprocs_lock);
> +
> +	dev_info(dev, "%s is available\n", name);
> +
> +	if (!rproc_dbg)
> +		goto out;
> +
> +	rproc->dbg_dir = debugfs_create_dir(dev_name(dev), rproc_dbg);
> +	if (!rproc->dbg_dir) {
> +		dev_err(dev, "can't create debugfs dir\n");
> +		goto out;
> +	}
> +
> +	debugfs_create_file("name", 0400, rproc->dbg_dir, rproc,
> +							&rproc_name_ops);
> +	debugfs_create_file("state", 0400, rproc->dbg_dir, rproc,
> +							&rproc_state_ops);
> +
> +out:
> +	return 0;
> +}
> +EXPORT_SYMBOL(rproc_register);
> +
> +/**
> + * rproc_unregister() - unregister a remote processor
> + * @name: name of this remote processor
> + *
> + * Unregisters a remote processor.
> + *
> + * On succes, 0 is return. If this remote processor isn't found, -EINVAL
> + * is returned.
> + */
> +int rproc_unregister(const char *name)
> +{
> +	struct rproc *rproc;
> +
> +	rproc = __find_rproc_by_name(name);
> +	if (!rproc) {
> +		pr_err("can't find remote processor %s\n", name);
> +		return -EINVAL;
> +	}
> +
> +	dev_info(rproc->dev, "removing %s\n", name);
> +
> +	if (rproc->dbg_dir)
> +		debugfs_remove_recursive(rproc->dbg_dir);
> +
> +	spin_lock(&rprocs_lock);
> +	list_del(&rproc->next);
> +	spin_unlock(&rprocs_lock);
> +
> +	kfree(rproc);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(rproc_unregister);
> +
> +static int __init remoteproc_init(void)
> +{
> +	if (debugfs_initialized()) {
> +		rproc_dbg = debugfs_create_dir(KBUILD_MODNAME, NULL);
> +		if (!rproc_dbg)
> +			pr_err("can't create debugfs dir\n");
> +	}
> +
> +	return 0;
> +}
> +/* must be ready in time for device_initcall users */
> +subsys_initcall(remoteproc_init);
> +
> +static void __exit remoteproc_exit(void)
> +{
> +	if (rproc_dbg)
> +		debugfs_remove(rproc_dbg);
> +}
> +module_exit(remoteproc_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Generic Remote Processor Framework");
> diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
> new file mode 100644
> index 0000000..6cdb966
> --- /dev/null
> +++ b/include/linux/remoteproc.h
> @@ -0,0 +1,273 @@
> +/*
> + * Remote Processor Framework
> + *
> + * Copyright(c) 2011 Texas Instruments, Inc.
> + * Copyright(c) 2011 Google, Inc.
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * * Redistributions of source code must retain the above copyright
> + *   notice, this list of conditions and the following disclaimer.
> + * * Redistributions in binary form must reproduce the above copyright
> + *   notice, this list of conditions and the following disclaimer in
> + *   the documentation and/or other materials provided with the
> + *   distribution.
> + * * Neither the name Texas Instruments nor the names of its
> + *   contributors may be used to endorse or promote products derived
> + *   from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +#ifndef REMOTEPROC_H
> +#define REMOTEPROC_H
> +
> +#include <linux/mutex.h>
> +#include <linux/completion.h>
> +
> +/**
> + * DOC: The Binary Structure of the Firmware
> + *
> + * The following enums and structures define the binary format of the image
> + * we load and run the remote processors with.
> + *
> + * The binary format is as follows:
> + *
> + * struct {
> + *     char magic[4] = { 'R', 'P', 'R', 'C' };
> + *     u32 version;
> + *     u32 header_len;
> + *     char header[...] = { header_len bytes of unformatted, textual header };
> + *     struct section {
> + *         u32 type;
> + *         u64 da;
> + *         u32 len;
> + *         u8 content[...] = { len bytes of binary data };
> + *     } [ no limit on number of sections ];
> + * } __packed;
> + */
> +
> +/**
> + * struct fw_header - header of the firmware image
> + * @magic: 4-bytes magic (should contain "RPRC")
> + * @version: version number, should be bumped on binary changes
> + * @header_len: length, in bytes, of the following text header
> + * @header: free-style textual header, users can read with 'head'
> + *
> + * This structure defines the header of the remoteproc firmware.
> + */
> +struct fw_header {
> +	char magic[4];
> +	u32 version;
> +	u32 header_len;
> +	char header[0];
> +} __packed;
> +
> +/**
> + * struct fw_section - header of a firmware section
> + * @type: section type
> + * @da: device address that the rproc expects to find this section at.
> + * @len: length of the section (in bytes)
> + * @content: the section data
> + *
> + * This structure defines the header of a firmware section. All sections
> + * should be loaded to the address specified by @da, so the remote processor
> + * will find them.
> + *
> + * Note: if the remote processor is not behind an IOMMU, then da is a
> + * mere physical address
> + */
> +struct fw_section {
> +	u32 type;
> +	u64 da;
> +	u32 len;
> +	char content[0];
> +} __packed;
> +
> +/**
> + * enum fw_section_type - section type values
> + *
> + * @FW_RESOURCE: a resource section. this section contains static
> + *		resource requests (/announcements) that the remote
> + *		processor requires (/supports). Most of these requests
> + *		require that the host fulfill them (and usually
> + *		"reply" with a result) before the remote processor
> + *		is booted. See Documentation/remoteproc.h for more info
> + * @FW_TEXT: a text section
> + * @FW_DATA: a data section
> + *
> + * Note: text and data sections have different types so we can support stuff
> + * like crash dumps (which only requires dumping data sections) or loading
> + * text sections into faster memory. Currently, though, both section types
> + * are treated exactly the same.
> + */
> +enum fw_section_type {
> +	FW_RESOURCE	= 0,
> +	FW_TEXT		= 1,
> +	FW_DATA		= 2,
> +};
> +
> +/**
> + * struct fw_resource - describes an entry from the resource section
> + * @type: resource type
> + * @da: depends on the resource type
> + * @pa: depends on the resource type
> + * @len: depends on the resource type
> + * @flags: depends on the resource type
> + * @name: name of resource
> + *
> + * Some resources entries are mere announcements, where the host is informed
> + * of specific remoteproc configuration. Other entries require the host to
> + * do something (e.g. reserve a requested resource) and reply by overwriting
> + * a member inside struct fw_resource with the id of the allocated resource.
> + * There could also be resource entries where the remoteproc's image suggests
> + * a configuration, but the host may overwrite it with its own preference.
> + *
> + * Note: the vast majority of the resource types are not implemented yet,
> + * and this is all very much preliminary.
> + */
> +struct fw_resource {
> +	u32 type;
> +	u64 da;
> +	u64 pa;
> +	u32 len;
> +	u32 flags;
> +	u8 name[48];
> +} __packed;
> +
> +/**
> + * enum fw_resource_type - types of resource entries
> + *
> + * @RSC_TRACE: announces the availability of a trace buffer into which
> + *		the remote processor will be writing logs. In this case,
> + *		'da' indicates the device address where logs are written to,
> + *		and 'len' is the size of the trace buffer.
> + *		Currently we support two trace buffers per remote processor,
> + *		to support two autonomous cores running in a single rproc
> + *		device.
> + *		If additional trace buffers are needed, this should be
> + *		extended/generalized.
> + * @RSC_BOOTADDR: announces the address of the first instruction the remote
> + *		processor should be booted with (address indicated in 'da').
> + *
> + * Note: most of the resource types are not implemented yet, so they are
> + * not documented yet.
> + */
> +enum fw_resource_type {
> +	RSC_CARVEOUT	= 0,
> +	RSC_DEVMEM	= 1,
> +	RSC_DEVICE	= 2,
> +	RSC_IRQ		= 3,
> +	RSC_TRACE	= 4,
> +	RSC_BOOTADDR	= 5,
> +};
> +
> +/**
> + * struct rproc_mem_entry - memory mapping descriptor
> + * @da:		device address as seen by the remote processor
> + * @pa:		physical address
> + * @size:	size of this memory region
> + *
> + * Board file will use this struct to define the IOMMU configuration
> + * for this remote processor. If the rproc device accesses physical memory
> + * directly (and not through an IOMMU), this is not needed.
> + */
> +struct rproc_mem_entry {
> +	u64 da;
> +	phys_addr_t pa;
> +	u32 size;
> +};
> +
> +struct rproc;
> +
> +/**
> + * struct rproc_ops - platform-specific device handlers
> + * @start:	power on the device and boot it. implementation may require
> + *		specifyng a boot address
> + * @stop:	power off the device
> + */
> +struct rproc_ops {
> +	int (*start)(struct rproc *rproc, u64 bootaddr);
> +	int (*stop)(struct rproc *rproc);
> +};
> +
> +/*
> + * enum rproc_state - remote processor states
> + *
> + * @RPROC_OFFLINE:	device is powered off
> + * @RPROC_SUSPENDED:	device is suspended; needs to be woken up to receive
> + *			a message.
> + * @RPROC_RUNNING:	device is up and running
> + * @RPROC_LOADING:	asynchronous firmware loading has started
> + * @RPROC_CRASHED:	device has crashed; need to start recovery
> + */
> +enum rproc_state {
> +	RPROC_OFFLINE,
> +	RPROC_SUSPENDED,
> +	RPROC_RUNNING,
> +	RPROC_LOADING,
> +	RPROC_CRASHED,
> +};
> +
> +#define RPROC_MAX_NAME	100

I wouldn't even bother with this.  The only place it is used is in one
of the debugfs files, and you can protect against too large a static
buffer by using %100s (or whatever) in the snprintf().

> +
> +/*
> + * struct rproc - represents a physical remote processor device
> + *
> + * @next: next rproc entry in the list
> + * @name: human readable name of the rproc, cannot exceed RPROC_MAX_NAME bytes
> + * @memory_maps: table of da-to-pa memory maps (relevant if device is behind
> + *               an iommu)
> + * @firmware: name of firmware file to be loaded
> + * @owner: reference to the platform-specific rproc module
> + * @priv: private data which belongs to the platform-specific rproc module
> + * @ops: platform-specific start/stop rproc handlers
> + * @dev: underlying device
> + * @count: usage refcount
> + * @state: state of the device
> + * @lock: lock which protects concurrent manipulations of the rproc
> + * @dbg_dir: debugfs directory of this rproc device
> + * @trace_buf0: main trace buffer of the remote processor
> + * @trace_buf1: second, optional, trace buffer of the remote processor
> + * @trace_len0: length of main trace buffer of the remote processor
> + * @trace_len1: length of the second (and optional) trace buffer
> + * @firmware_loading_complete: marks e/o asynchronous firmware loading
> + */
> +struct rproc {
> +	struct list_head next;
> +	const char *name;
> +	const struct rproc_mem_entry *memory_maps;
> +	const char *firmware;
> +	struct module *owner;
> +	void *priv;
> +	const struct rproc_ops *ops;
> +	struct device *dev;
> +	int count;
> +	int state;
> +	struct mutex lock;
> +	struct dentry *dbg_dir;
> +	char *trace_buf0, *trace_buf1;
> +	int trace_len0, trace_len1;
> +	struct completion firmware_loading_complete;
> +};
> +
> +struct rproc *rproc_get(const char *);
> +void rproc_put(struct rproc *);
> +int rproc_register(struct device *, const char *, const struct rproc_ops *,
> +		const char *, const struct rproc_mem_entry *, struct module *);
> +int rproc_unregister(const char *);
> +
> +#endif /* REMOTEPROC_H */
> -- 
> 1.7.1
> 

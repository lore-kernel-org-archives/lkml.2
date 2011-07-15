Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964816Ab1GOCxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 22:53:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64844 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799Ab1GOCxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 22:53:30 -0400
Date: Thu, 14 Jul 2011 20:53:26 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110715025326.GH2927@ponder.secretlab.ca>
References: <20110709044923.GB13074@opensource.wolfsonmicro.com>
 <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310187044-13269-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 09, 2011 at 01:50:41PM +0900, Mark Brown wrote:
> There are many places in the tree where we implement register access for
> devices on non-memory mapped buses, especially I2C and SPI. Since hardware
> designers seem to have settled on a relatively consistent set of register
> interfaces this can be effectively factored out into shared code.  There
> are a standard set of formats for marshalling data for exchange with the
> device, with the actual I/O mechanisms generally being simple byte
> streams.
> 
> We create an abstraction for marshaling data into formats which can be
> sent on the control interfaces, and create a standard method for
> plugging in actual transport underneath that.
> 
> This is mostly a refactoring and renaming of the bottom level of the
> existing code for sharing register I/O which we have in ASoC. A
> subsequent patch in this series converts ASoC to use this.  The main
> difference in interface is that reads return values by writing to a
> location provided by a pointer rather than in the return value, ensuring
> we can use the full range of the type for register data.  We also use
> unsigned types rather than ints for the same reason.
> 
> As some of the devices can have very large register maps the existing
> ASoC code also contains infrastructure for managing register caches.
> This cache work will be moved over in a future stage to allow for
> separate review, the current patch only deals with the physical I/O.
> We also only deal with access to a single register at a time initially
> as this is the most common case.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Liam Girdwood <lrg@ti.com>

Hey Mark.

I've missed most of the discussion on this patch, but I support the
idea.  I've got some concerns about the API and the way it is intended
to be used.  Comments below...

> ---
>  MAINTAINERS                  |    7 +
>  drivers/base/Kconfig         |    2 +
>  drivers/base/Makefile        |    1 +
>  drivers/base/regmap/Kconfig  |    6 +
>  drivers/base/regmap/Makefile |    2 +
>  drivers/base/regmap/regmap.c |  481 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/regmap.h       |   76 +++++++
>  7 files changed, 575 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/base/regmap/Kconfig
>  create mode 100644 drivers/base/regmap/Makefile
>  create mode 100644 drivers/base/regmap/regmap.c
>  create mode 100644 include/linux/regmap.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bf0e348..0cf0f9f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5343,6 +5343,13 @@ L:	reiserfs-devel@vger.kernel.org
>  S:	Supported
>  F:	fs/reiserfs/
>  
> +REGISTER MAP ABSTRACTION
> +M:	Mark Brown <broonie@opensource.wolfsonmicro.com>
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git
> +S:	Supported
> +F:	drivers/base/regmap/
> +F:	include/linux/regmap.h
> +
>  RFKILL
>  M:	Johannes Berg <johannes@sipsolutions.net>
>  L:	linux-wireless@vger.kernel.org
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index fa64fa0..21cf46f 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -172,4 +172,6 @@ config SYS_HYPERVISOR
>  	bool
>  	default n
>  
> +source "drivers/base/regmap/Kconfig"
> +
>  endmenu
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 4c5701c..dd4f9b2 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -18,6 +18,7 @@ ifeq ($(CONFIG_SYSFS),y)
>  obj-$(CONFIG_MODULES)	+= module.o
>  endif
>  obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
> +obj-$(CONFIG_REGMAP)	+= regmap/
>  
>  ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
>  
> diff --git a/drivers/base/regmap/Kconfig b/drivers/base/regmap/Kconfig
> new file mode 100644
> index 0000000..fc0eb1d
> --- /dev/null
> +++ b/drivers/base/regmap/Kconfig
> @@ -0,0 +1,6 @@
> +# Generic register map support.  There are no user servicable options here,
> +# this is an API intended to be used by other kernel subsystems.  These
> +# subsystems should select the appropriate symbols.
> +
> +config REGMAP
> +	bool
> diff --git a/drivers/base/regmap/Makefile b/drivers/base/regmap/Makefile
> new file mode 100644
> index 0000000..1e5037e
> --- /dev/null
> +++ b/drivers/base/regmap/Makefile
> @@ -0,0 +1,2 @@
> +obj-$(CONFIG_REGMAP) += regmap.o
> +
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> new file mode 100644
> index 0000000..f6a83e9
> --- /dev/null
> +++ b/drivers/base/regmap/regmap.c
> @@ -0,0 +1,481 @@
> +/*
> + * Register map access API
> + *
> + * Copyright 2011 Wolfson Microelectronics plc
> + *
> + * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +
> +#include <linux/regmap.h>
> +
> +struct regmap;
> +
> +static DEFINE_MUTEX(regmap_bus_lock);
> +static LIST_HEAD(regmap_bus_list);
> +
> +struct regmap_format {
> +	size_t buf_size;
> +	size_t reg_bytes;
> +	size_t val_bytes;
> +	void (*format_write)(struct regmap *map,
> +			     unsigned int reg, unsigned int val);
> +	void (*format_reg)(void *buf, unsigned int reg);
> +	void (*format_val)(void *buf, unsigned int val);
> +	unsigned int (*parse_val)(void *buf);
> +};
> +
> +struct regmap {
> +	struct mutex lock;
> +
> +	struct device *dev; /* Device we do I/O on */
> +	void *work_buf;     /* Scratch buffer used to format I/O */
> +	struct regmap_format format;  /* Buffer format */
> +	const struct regmap_bus *bus;
> +};

Some /** kerneldoc on these structures would be helpful.

> +
> +static void regmap_format_4_12_write(struct regmap *map,
> +				     unsigned int reg, unsigned int val)
> +{
> +	__be16 *out = map->work_buf;
> +	*out = cpu_to_be16((reg << 12) | val);
> +}
> +
> +static void regmap_format_7_9_write(struct regmap *map,
> +				    unsigned int reg, unsigned int val)
> +{
> +	__be16 *out = map->work_buf;
> +	*out = cpu_to_be16((reg << 9) | val);
> +}
> +
> +static void regmap_format_8(void *buf, unsigned int val)
> +{
> +	u8 *b = buf;
> +
> +	b[0] = val;
> +}
> +
> +static void regmap_format_16(void *buf, unsigned int val)
> +{
> +	__be16 *b = buf;
> +
> +	b[0] = cpu_to_be16(val);
> +}
> +
> +static unsigned int regmap_parse_8(void *buf)
> +{
> +	u8 *b = buf;
> +
> +	return b[0];
> +}
> +
> +static unsigned int regmap_parse_16(void *buf)
> +{
> +	__be16 *b = buf;
> +
> +	b[0] = be16_to_cpu(b[0]);
> +
> +	return b[0];
> +}
> +
> +/**
> + * remap_init: Initialise register map

nit: "remap_init() - Initialise reigster map"

> + *
> + * @dev: Device that will be interacted with
> + * @config: Configuration for register map
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct regmap.
> + */
> +struct regmap *regmap_init(struct device *dev,
> +			   const struct regmap_config *config)
> +{
> +	struct regmap *map;
> +	int ret = -EINVAL;
> +
> +	map = kzalloc(sizeof(*map), GFP_KERNEL);
> +	if (map == NULL) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}

Wouldn't it be appropriate to allow drivers to embed the regmap in a
private data structure?

> +
> +	mutex_init(&map->lock);
> +	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
> +	map->format.reg_bytes = config->reg_bits / 8;
> +	map->format.val_bytes = config->val_bits / 8;
> +	map->dev = dev;
> +
> +	switch (config->reg_bits) {
> +	case 4:
> +		switch (config->val_bits) {
> +		case 12:
> +			map->format.format_write = regmap_format_4_12_write;
> +			break;
> +		default:
> +			goto err_map;
> +		}
> +		break;
> +
> +	case 7:
> +		switch (config->val_bits) {
> +		case 9:
> +			map->format.format_write = regmap_format_7_9_write;
> +			break;
> +		default:
> +			goto err_map;
> +		}
> +		break;
> +
> +	case 8:
> +		map->format.format_reg = regmap_format_8;
> +		break;
> +
> +	case 16:
> +		map->format.format_reg = regmap_format_16;
> +		break;
> +
> +	default:
> +		goto err_map;
> +	}
> +
> +	switch (config->val_bits) {
> +	case 8:
> +		map->format.format_val = regmap_format_8;
> +		map->format.parse_val = regmap_parse_8;
> +		break;
> +	case 16:
> +		map->format.format_val = regmap_format_16;
> +		map->format.parse_val = regmap_parse_16;
> +		break;
> +	}

Rather than a big case statement, could this be cleaner with a lookup
table?

I'm a bit concerned that the overall structure of the init function
will be inflexible in the long run.  Specifically, the way the
instance structure is hidden from the caller, there isn't any way for
a device driver to explicitly override the accessor functions if it
needs to.  One of the things I like about the generic irq_chip work
that tglx did was that it set up a lot of things for the irq
controller, but the controller could still provide its own hooks when
necessary.

> +
> +	if (!map->format.format_write &&
> +	    !(map->format.format_reg && map->format.format_val))
> +		goto err_map;
> +
> +	/* Figure out which bus to use, and also grab a lock on the
> +	 * module supplying it. */
> +	mutex_lock(&regmap_bus_lock);
> +	list_for_each_entry(map->bus, &regmap_bus_list, list)
> +		if (map->bus->type == dev->bus &&
> +		    try_module_get(map->bus->owner))
> +			break;
> +	mutex_unlock(&regmap_bus_lock);

Hmmmm.  Two things here.  First, grabbing a reference to the module
mostly works, but it highlights a deficiency in the driver model.
Really what we want here is a refcount on the /bound/ instance of the
driver+device.  The driver model does actually support unbinding a
device without removing the module.

Second, combining a device reference with the register access library
conflates two things which seem to me to be separate.  Actually, which
it seems odd, it doesn't bother me too much, but it looks completely
wrong for this library to need specific bus-type knowledge.  Why does
the bus type need to be known (other than to choose the appropriate IO
routines)?  If it is only for setting up the io accessors, I'd rather
see the caller use a bus-specific setup funtion and pass the
appropriate {i2c,spi,...}_device which will take care of type
checking.

> +
> +	if (map->bus == NULL) {
> +		ret = -EINVAL;
> +		goto err_map;
> +	}
> +
> +	map->work_buf = kmalloc(map->format.buf_size, GFP_KERNEL);
> +	if (map->work_buf == NULL) {
> +		ret = -ENOMEM;
> +		goto err_bus;
> +	}
> +
> +	return map;
> +
> +err_bus:
> +	module_put(map->bus->owner);
> +err_map:
> +	kfree(map);
> +err:
> +	return ERR_PTR(ret);

Personal soapbox: I'm not at all a fan of the ERR_PTR() pattern
because it provides no clues to the caller (gcc) if a failure is
returned as a NULL or as a 0.  Unless there is a really strong
argument for needing to differentiate between "no data" and "things
went bad", I'd rather see APIs that return NULL on failure.

> +}
> +EXPORT_SYMBOL_GPL(regmap_init);
> +
> +/**
> + * regmap_exit: Free a previously allocated register map
> + */
> +void regmap_exit(struct regmap *map)
> +{
> +	kfree(map->work_buf);
> +	module_put(map->bus->owner);
> +	kfree(map);
> +}
> +EXPORT_SYMBOL_GPL(regmap_exit);
> +
> +static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> +			     const void *val, size_t val_len)
> +{
> +	void *buf;
> +	int ret = -ENOTSUPP;
> +	size_t len;
> +
> +	map->format.format_reg(map->work_buf, reg);
> +
> +	/* Try to do a gather write if we can */
> +	if (map->bus->gather_write)
> +		ret = map->bus->gather_write(map->dev, map->work_buf,
> +					     map->format.reg_bytes,
> +					     val, val_len);
> +
> +	/* Otherwise fall back on linearising by hand. */
> +	if (ret == -ENOTSUPP) {
> +		len = map->format.reg_bytes + val_len;
> +		buf = kmalloc(len, GFP_KERNEL);
> +		if (!buf)
> +			return -ENOMEM;
> +
> +		memcpy(buf, map->work_buf, map->format.reg_bytes);
> +		memcpy(buf + map->format.reg_bytes, val, val_len);
> +		ret = map->bus->write(map->dev, buf, len);
> +
> +		kfree(buf);
> +	}
> +
> +	return ret;
> +}
> +
> +static int _regmap_write(struct regmap *map, unsigned int reg,
> +			 unsigned int val)
> +{
> +	BUG_ON(!map->format.format_write && !map->format.format_val);
> +
> +	if (map->format.format_write) {
> +		map->format.format_write(map, reg, val);
> +
> +		return map->bus->write(map->dev, map->work_buf,
> +				       map->format.buf_size);
> +	} else {
> +		map->format.format_val(map->work_buf + map->format.reg_bytes,
> +				       val);
> +		return _regmap_raw_write(map, reg,
> +					 map->work_buf + map->format.reg_bytes,
> +					 map->format.val_bytes);
> +	}
> +}
> +
> +/**
> + * regmap_write: Write a value to a single register
> + *
> + * @map: Register map to write to
> + * @reg: Register to write to
> + * @val: Value to be written
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
> +{
> +	int ret;
> +
> +	mutex_lock(&map->lock);
> +
> +	ret = _regmap_write(map, reg, val);
> +
> +	mutex_unlock(&map->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regmap_write);
> +
> +/**
> + * regmap_raw_write: Write raw values to one or more registers
> + *
> + * @map: Register map to write to
> + * @reg: Initial register to write to
> + * @val: Block of data to be written, laid out for direct transmission to the
> + *       device
> + * @val_len: Length of data pointed to by val.
> + *
> + * This function is intended to be used for things like firmware
> + * download where a large block of data needs to be transferred to the
> + * device.  No formatting will be done on the data provided.
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +int regmap_raw_write(struct regmap *map, unsigned int reg,
> +		     const void *val, size_t val_len)
> +{
> +	int ret;
> +
> +	mutex_lock(&map->lock);
> +
> +	ret = _regmap_raw_write(map, reg, val, val_len);
> +
> +	mutex_unlock(&map->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regmap_raw_write);
> +
> +static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
> +			    unsigned int val_len)
> +{
> +	u8 *u8 = map->work_buf;
> +	int ret;
> +
> +	map->format.format_reg(map->work_buf, reg);
> +
> +	/*
> +	 * Some buses flag reads by setting the high bits in the
> +	 * register addresss; since it's always the high bits for all
> +	 * current formats we can do this here rather than in
> +	 * formatting.  This may break if we get interesting formats.
> +	 */
> +	if (map->bus->read_flag_mask)
> +		u8[0] |= map->bus->read_flag_mask;
> +
> +	ret = map->bus->read(map->dev, map->work_buf, map->format.reg_bytes,
> +			     val, map->format.val_bytes);
> +	if (ret != 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int _regmap_read(struct regmap *map, unsigned int reg,
> +			unsigned int *val)
> +{
> +	int ret;
> +
> +	if (!map->format.parse_val)
> +		return -EINVAL;
> +
> +	ret = _regmap_raw_read(map, reg, map->work_buf, map->format.val_bytes);
> +	if (ret == 0)
> +		*val = map->format.parse_val(map->work_buf);
> +
> +	return ret;
> +}
> +
> +/**
> + * regmap_read: Read a value from a single register
> + *
> + * @map: Register map to write to
> + * @reg: Register to be read from
> + * @val: Pointer to store read value
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
> +{
> +	int ret;
> +
> +	mutex_lock(&map->lock);
> +
> +	ret = _regmap_read(map, reg, val);
> +
> +	mutex_unlock(&map->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regmap_read);
> +
> +/**
> + * regmap_raw_read: Read raw data from the device
> + *
> + * @map: Register map to write to
> + * @reg: First register to be read from
> + * @val: Pointer to store read value
> + * @val_len: Size of data to read
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
> +		    size_t val_len)
> +{
> +	int ret;
> +
> +	mutex_lock(&map->lock);
> +
> +	ret = _regmap_raw_read(map, reg, val, val_len);
> +
> +	mutex_unlock(&map->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regmap_raw_read);
> +
> +/**
> + * regmap_bulk_read: Read multiple registers from the device
> + *
> + * @map: Register map to write to
> + * @reg: First register to be read from
> + * @val: Pointer to store read value, in native register size for device
> + * @val_count: Number of registers to read
> + *
> + * A value of zero will be returned on success, a negative errno will
> + * be returned in error cases.
> + */
> +int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
> +		     size_t val_count)
> +{
> +	int ret, i;
> +	size_t val_bytes = map->format.val_bytes;
> +
> +	if (!map->format.parse_val)
> +		return -EINVAL;
> +
> +	ret = regmap_raw_read(map, reg, val, val_bytes * val_count);
> +	if (ret != 0)
> +		return ret;
> +
> +	for (i = 0; i < val_count * val_bytes; i += val_bytes)
> +		map->format.parse_val(val + i);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(regmap_bulk_read);
> +
> +/**
> + * remap_update_bits: Perform a read/modify/write cycle on the register map
> + *
> + * @map: Register map to update
> + * @reg: Register to update
> + * @mask: Bitmask to change
> + * @val: New value for bitmask
> + *
> + * Returns zero for success, a negative number on error.
> + */
> +int regmap_update_bits(struct regmap *map, unsigned int reg,
> +		       unsigned int mask, unsigned int val)
> +{
> +	int ret;
> +	unsigned int tmp;
> +
> +	mutex_lock(&map->lock);
> +
> +	ret = _regmap_read(map, reg, &tmp);
> +	if (ret != 0)
> +		goto out;
> +
> +	tmp &= ~mask;
> +	tmp |= val & mask;
> +
> +	ret = _regmap_write(map, reg, tmp);
> +
> +out:
> +	mutex_unlock(&map->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(regmap_update_bits);
> +
> +void regmap_add_bus(struct regmap_bus *bus)
> +{
> +	mutex_lock(&regmap_bus_lock);
> +	list_add(&bus->list, &regmap_bus_list);
> +	mutex_unlock(&regmap_bus_lock);
> +}
> +EXPORT_SYMBOL_GPL(regmap_add_bus);
> +
> +void regmap_del_bus(struct regmap_bus *bus)
> +{
> +	mutex_lock(&regmap_bus_lock);
> +	list_del(&bus->list);
> +	mutex_unlock(&regmap_bus_lock);
> +}
> +EXPORT_SYMBOL_GPL(regmap_del_bus);
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> new file mode 100644
> index 0000000..b033979
> --- /dev/null
> +++ b/include/linux/regmap.h
> @@ -0,0 +1,76 @@
> +#ifndef __LINUX_REGMAP_H
> +#define __LINUX_REGMAP_H
> +
> +/*
> + * Register map access API
> + *
> + * Copyright 2011 Wolfson Microelectronics plc
> + *
> + * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +
> +struct regmap_config {
> +	int reg_bits;
> +	int val_bits;
> +};
> +
> +typedef int (*regmap_hw_write)(struct device *dev, const void *data,
> +			       size_t count);
> +typedef int (*regmap_hw_gather_write)(struct device *dev,
> +				      const void *reg, size_t reg_len,
> +				      const void *val, size_t val_len);
> +typedef int (*regmap_hw_read)(struct device *dev,
> +			      const void *reg_buf, size_t reg_size,
> +			      void *val_buf, size_t val_size);
> +
> +/**
> + * Description of a hardware bus for the register map infrastructure.
> + *
> + * @list: Internal use.
> + * @type: Bus type, used to identify bus to be used for a device.
> + * @write: Write operation.
> + * @gather_write: Write operation with split register/value, return -ENOTSUPP
> + *                if not implemented  on a given device.
> + * @read: Read operation.  Data is returned in the buffer used to transmit
> + *         data.
> + * @owner: Module with the bus implementation, used to pin the implementation
> + *         in memory.
> + * @read_flag_mask: Mask to be set in the top byte of the register when doing
> + *                  a read.
> + */
> +struct regmap_bus {
> +	struct list_head list;
> +	struct bus_type *type;
> +	regmap_hw_write write;
> +	regmap_hw_gather_write gather_write;
> +	regmap_hw_read read;
> +	struct module *owner;
> +	u8 read_flag_mask;
> +};

Further to my comment from earlier, the need for a linked list of bus
types goes away if the driver calls a bus-specific setup routine, and
there doesn't need to be any regmap add/del management.

> +
> +struct regmap *regmap_init(struct device *dev,
> +			   const struct regmap_config *config);
> +void regmap_exit(struct regmap *map);
> +int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
> +int regmap_raw_write(struct regmap *map, unsigned int reg,
> +		     const void *val, size_t val_len);
> +int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
> +int regmap_raw_read(struct regmap *map, unsigned int reg,
> +		    void *val, size_t val_len);
> +int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
> +		     size_t val_count);
> +int regmap_update_bits(struct regmap *map, unsigned int reg,
> +		       unsigned int mask, unsigned int val);
> +
> +void regmap_add_bus(struct regmap_bus *bus);
> +void regmap_del_bus(struct regmap_bus *bus);
> +
> +#endif
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1FTXQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:16:51 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:39723 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756091Ab1FTXQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:16:50 -0400
Message-ID: <4DFFD486.7020901@metafoo.de>
Date: Tue, 21 Jun 2011 01:15:18 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110505 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register access
 API
References: <20110620124608.GB31140@opensource.wolfsonmicro.com> <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very nice!

> [...]
> diff --git a/drivers/regmap/regmap.c b/drivers/regmap/regmap.c
> new file mode 100644
> index 0000000..a8610c7
> --- /dev/null
> +++ b/drivers/regmap/regmap.c
> @@ -0,0 +1,478 @@
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

const void *buf. It probably also makes sense to pass the regmap to all
callbacks, so we can write generic format/parser functions which use
information for example from the regmap_format.

> +};
> +
> +struct regmap {
> +	struct mutex lock;
> +
> +	struct device *dev; /* Device we do I/O on */
> +	void *work_buf;     /* Scratch buffer used to format I/O */
> +	struct regmap_format format;  /* Buffer format */
> +	struct regmap_bus *bus;

const struct regmap_bus

> +};
> +
> +static void regmap_format_4_12_write(struct regmap *map,
> +				     unsigned int reg, unsigned int val)
> +{
> +	u16 *out = map->work_buf;
> +	*out = cpu_to_be16((reg << 12) | val);
> +}
> +
> +static void regmap_format_7_9_write(struct regmap *map,
> +				    unsigned int reg, unsigned int val)
> +{
> +	u16 *out = map->work_buf;
> +	*out = cpu_to_be16((reg << 9) | val);
> +}

It would make sense to keep val_bits around and implement these two generically:
	*out = cpu_to_be16((reg << map->format.val_bits) | val);

> [...]
> +/**
> + * remap_init: Initialise register map
> + *
> + * dev: Device that will be interacted with
> + * config: Configuration for register map
> + *
> + * The return value will be an ERR_PTR() on error or a valid pointer
> + * to a struct regmap.
> + */
> +struct regmap *regmap_init(struct device *dev, struct regmap_config *config)

regmap_alloc would in my opinion be a better name.

> [...]
> +static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
> +			    unsigned int val_len)
> +{
> +	u8 *u8 = map->work_buf;
> +	int ret;
> +
> +	map->format.format_reg(map->work_buf, reg);
> +
> +	/*
> +	 * Some buses flag reads by setting the high bit in the
> +	 * register addresss; since it's always the high bit for all
> +	 * current formats we can do this here rather than in
> +	 * formatting.  This may break if we get interesting formats.
> +	 */
> +	if (map->bus->read_flag_in_reg)
> +		u8[0] |= 0x80;

This is rather specific. Making this a per device mask or bit offset, would
make more sense in my opinion. I have for example one SPI codec device which
uses the 7th bit to indicate a read. And I also have devices on a custom bus,
which needs to set the upper bit to indicate a write, so a mask for both write
and read would be good.

> +
> +	ret = map->bus->read(map->dev, map->work_buf, map->format.reg_bytes,
> +			     val, map->format.val_bytes);
> +	if (ret != 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> [...]
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
> +	ret = regmap_raw_read(map, reg, val, val_bytes);

val_bytes * val_count

> +	if (ret != 0)
> +		return ret;
> +
> +	for (i = 0; i < val_count * val_bytes; i += val_bytes)
> +		map->format.parse_val(val + i);

This doesn't make sense. parse_val returns the parsed value, but doesn't modify
the parsed data. It would make sense to make the interface similar to
regmap_read and make the returned values a unsigned integer array and use a
bounce buffer for reading them from the device.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(regmap_bulk_read);
> +
> [...]
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> new file mode 100644
> index 0000000..0c2e402
> --- /dev/null
> +++ b/include/linux/regmap.h
> @@ -0,0 +1,75 @@
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

#include <linux/module.h>

> +
> +struct regmap_config {
> +	int reg_bits;
> +	int val_bits;

size_t for both?

> +};
> +
> ...
> +
> +struct regmap *regmap_init(struct device *dev, struct regmap_config *config);

const struct regmap_config

> +void regmap_free(struct regmap *map);
> +int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
> +int regmap_raw_write(struct regmap *map, unsigned int reg,
> +		     const void *val, size_t val_len);
> +int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
> +int regmap_raw_read(struct regmap *map, unsigned int reg,
> +		    void *val, size_t val_len);
> +int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
> +		     size_t val_count);

What about bulk_write?

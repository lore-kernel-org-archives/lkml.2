Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0F0XzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 19:55:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:24242 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab0F0XzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 19:55:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,493,1272870000"; 
   d="scan'208";a="812138911"
Date: Mon, 28 Jun 2010 01:55:16 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       linus.walleij@stericsson.com, l.fu@pengutronix.de
Subject: Re: [PATCHv2 1/3] mfd: add STMPE I/O Expander support
Message-ID: <20100627235515.GB9264@sortiz-mobl>
References: <20100621154514.GA416@pengutronix.de>
 <1277214929-32240-1-git-send-email-rabin.vincent@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277214929-32240-1-git-send-email-rabin.vincent@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rabin,

On Tue, Jun 22, 2010 at 07:25:27PM +0530, Rabin Vincent wrote:
> add support for the stmpe family of i/o expanders from
> stmicroelectronics.  these devices include upto 24 gpios and a varying
> selection of blocks, including pwm, keypad, and touchscreen controllers.
> this patch adds the mfd core.

Thanks for re-spinning this patchset. I have some comments though:

> diff --git a/drivers/mfd/kconfig b/drivers/mfd/kconfig
> index 9da0e50..63dce71 100644
> --- a/drivers/mfd/kconfig
> +++ b/drivers/mfd/kconfig
> @@ -177,6 +177,18 @@ config twl4030_codec
>  	select mfd_core
>  	default n
>  
> +config mfd_stmpe
> +	bool "support stmicroelectronics stmpe"
> +	depends on i2c=y && generic_hardirqs
> +	select mfd_core
> +	help
> +	  support for the stmpe family of i/o expanders from
> +	  stmicroelectronics.
Please be more verbose here in saying which chipsets are supported. Also,
describing the kind of sub devices they provide won't hurt.

> diff --git a/drivers/mfd/stmpe-devices.c b/drivers/mfd/stmpe-devices.c
> new file mode 100644
> index 0000000..fa6934d
> --- /dev/null
> +++ b/drivers/mfd/stmpe-devices.c
I like the smtpe_variant design, but I'd rather see those definitions being
part of smtpe.c directly.

> +/**
> + * stmpe_reg_read() - read a single stmpe register
> + * @stmpe:	device to read from
> + * @reg:	register to read
> + */
> +int stmpe_reg_read(struct stmpe *stmpe, u8 reg)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_read_byte_data(stmpe->i2c, reg);
> +	if (ret < 0)
> +		dev_err(stmpe->dev, "failed to read reg %#x: %d\n",
> +			reg, ret);
> +
> +	dev_vdbg(stmpe->dev, "rd: reg %#x => data %#x\n", reg, ret);
> +
> +	return ret;
> +}
> +export_symbol(stmpe_reg_read);
I think your locking is broken here.
If your exporting this routine (and the next ones below), you'd better make
sure you're under stmpe->lock for the stmpe register concurrent access.
What I suggest is that you'd have the exported routines taking your stmpe
lock, and then have an internal version (e.g. named with a __stmpe prefix)
without lock taken for your core code. In your case, you could probably call
the i2c I/O routines directly, that's up to you.

> +/**
> + * stmpe_set_bits() - set the value of a bitfield in a stmpe register
> + * @stmpe:	device to write to
> + * @reg:	register to write
> + * @mask:	mask of bits to set
> + * @val:	value to set
> + */
> +int stmpe_set_bits(struct stmpe *stmpe, u8 reg, u8 mask, u8 val)
> +{
> +	int ret;
> +
> +	mutex_lock(&stmpe->lock);
> +
> +	ret = stmpe_reg_read(stmpe, reg);
That one for example would be __stmpe_read().

> +/**
> + * stmpe_block_write() - write multiple stmpe registers
> + * @stmpe:	device to write to
> + * @reg:	first register
> + * @length:	number of registers
> + * @values:	values to write
> + */
> +int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
> +			const u8 *values)
> +{
> +	int ret;
> +
> +	dev_vdbg(stmpe->dev, "wr: regs %#x (%d)\n", reg, length);
> +#ifdef VERBOSE_DEBUG
> +	print_hex_dump_bytes("stmpe wr: ", dump_prefix_offset, values, length);
> +#endif
I don't really enjoy this part for 2 reasons:
- You should use a less generic ifdef switch, prefixed with STMPE_ for
example.
- I'd rather see a
	#ifdef STMPE_VERBOSE_DEBUG
	#define stmpe_hex_xump() print_hex_dump_bytes() 
	#else
	#define stmpe_hex_xump()
	#endif
defined in your stmpe.h.

The rest looks fine to me.

Cheers,
Samuel.

-- 
intel open source technology centre
http://oss.intel.com/

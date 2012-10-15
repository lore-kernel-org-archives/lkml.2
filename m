Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312Ab2JOFUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:20:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54104 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2JOFUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:20:12 -0400
Message-ID: <507B9D05.1000204@gmail.com>
Date: Mon, 15 Oct 2012 16:20:05 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 1/6 v3] gpio: Add a block GPIO API to gpiolib
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-2-git-send-email-stigge@antcom.de>
In-Reply-To: <1350069085-13283-2-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/10/12 06:11, Roland Stigge wrote:
> The recurring task of providing simultaneous access to GPIO lines (especially
> for bit banging protocols) needs an appropriate API.
> 
> This patch adds a kernel internal "Block GPIO" API that enables simultaneous
> access to several GPIOs. This is done by abstracting GPIOs to an n-bit word:
> Once requested, it provides access to a group of GPIOs which can range over
> multiple GPIO chips.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Hi Roland,

Some comments below.

~Ryan

> ---
> 
>  Documentation/gpio.txt     |   45 +++++++++
>  drivers/gpio/gpiolib.c     |  223 +++++++++++++++++++++++++++++++++++++++++++++
>  include/asm-generic/gpio.h |   14 ++
>  include/linux/gpio.h       |   61 ++++++++++++
>  4 files changed, 343 insertions(+)
> 
> --- linux-2.6.orig/Documentation/gpio.txt
> +++ linux-2.6/Documentation/gpio.txt
> @@ -439,6 +439,51 @@ slower clock delays the rising edge of S
>  signaling rate accordingly.
>  
>  
> +Block GPIO
> +----------
> +
> +The above described interface concentrates on handling single GPIOs.  However,
> +in applications where it is critical to set several GPIOs at once, this
> +interface doesn't work well, e.g. bit-banging protocols via grouped GPIO lines.
> +Consider a GPIO controller that is connected via a slow I2C line. When
> +switching two or more GPIOs one after another, there can be considerable time
> +between those events. This is solved by an interface called Block GPIO:

The emulate behaviour of gpio block switches gpios one after the other.
Is the problem only solved if the block_get/block_set callbacks can be
implemented?

> +struct gpio_block *gpio_block_create(unsigned int *gpios, size_t size);
> +
> +This creates a new block of GPIOs as a list of GPIO numbers with the specified
> +size which are accessible via the returned struct gpio_block and the accessor
> +functions described below. Please note that you need to request the GPIOs
> +separately via gpio_request(). An arbitrary list of globally valid GPIOs can be
> +specified, even ranging over several gpio_chips. Actual handling of I/O
> +operations will be done on a best effort base, i.e. simultaneous I/O only where
> +possible by hardware and implemented in the respective GPIO driver. The number
> +of GPIOs in one block is limited to 32 on a 32 bit system, and 64 on a 64 bit
> +system. However, several blocks can be defined at once.
> +
> +unsigned gpio_block_get(struct gpio_block *block);
> +void gpio_block_set(struct gpio_block *block, unsigned value);
> +
> +With those accessor functions, setting and getting the GPIO values is possible,
> +analogous to gpio_get_value() and gpio_set_value(). Each bit in the return
> +value of gpio_block_get() and in the value argument of gpio_block_set()
> +corresponds to a bit specified on gpio_block_create(). Block operations in
> +hardware are only possible where the respective GPIO driver implements it,
> +falling back to using single GPIO operations where the driver only implements
> +single GPIO access.
> +
> +void gpio_block_free(struct gpio_block *block);
> +
> +After the GPIO block isn't used anymore, it should be free'd via
> +gpio_block_free().
> +
> +int gpio_block_register(struct gpio_block *block);
> +void gpio_block_unregister(struct gpio_block *block);
> +
> +These functions can be used to register a GPIO block. Blocks registered this
> +way will be available via sysfs.
> +
> +
>  What do these conventions omit?
>  ===============================
>  One of the biggest things these conventions omit is pin multiplexing, since
> --- linux-2.6.orig/drivers/gpio/gpiolib.c
> +++ linux-2.6/drivers/gpio/gpiolib.c
> @@ -83,6 +83,10 @@ static inline void desc_set_label(struct
>  #endif
>  }
>  
> +#define NR_GPIO_BLOCKS	16
> +
> +static struct gpio_block *gpio_block[NR_GPIO_BLOCKS];
> +
>  /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
>   * when setting direction, and otherwise illegal.  Until board setup code
>   * and drivers use explicit requests everywhere (which won't happen when
> @@ -1676,6 +1680,225 @@ void __gpio_set_value(unsigned gpio, int
>  }
>  EXPORT_SYMBOL_GPL(__gpio_set_value);
>  
> +static inline

Nitpick - don't need the inline, the compiler will do so for you.

> +int gpio_block_chip_index(struct gpio_block *block, struct gpio_chip *gc)

Should be static?

> +{
> +	int i;
> +
> +	for (i = 0; i < block->nchip; i++) {
> +		if (block->gbc[i].gc == gc)
> +			return i;
> +	}
> +	return -1;
> +}
> +
> +struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
> +				     const char *name)
> +{
> +	struct gpio_block *block;
> +	struct gpio_block_chip *gbc;
> +	struct gpio_remap *remap;
> +	int i;
> +
> +	if (size < 1 || size > sizeof(unsigned) * 8)
> +		return ERR_PTR(-EINVAL);
> +
> +	block = kzalloc(sizeof(struct gpio_block), GFP_KERNEL);
> +	if (!block)
> +		return ERR_PTR(-ENOMEM);
> +
> +	block->name = name;
> +	block->ngpio = size;
> +	block->gpio = kzalloc(sizeof(*block->gpio) * size, GFP_KERNEL);
> +	if (!block->gpio)
> +		goto err1;
> +
> +	memcpy(block->gpio, gpios, sizeof(*block->gpio) * size);
> +
> +	for (i = 0; i < size; i++)
> +		if (!gpio_is_valid(gpios[i]))
> +			goto err2;

This loop should probably go at the start of the function, so you can
avoid doing the kzalloc/memcpy if it fails.

This function doesn't call gpio_request. Either it should, or it should
rely on the caller to have already done so, and call
gpio_ensure_requested here. There is also an implicit rule that any
gpios inside a block must not be freed as long as the block exists. The
code can't easily prevent this since gpios aren't refcounted. The rule
should be documented.

> +
> +	for (i = 0; i < size; i++) {
> +		struct gpio_chip *gc = gpio_to_chip(gpios[i]);
> +		int bit = gpios[i] - gc->base;
> +		int index = gpio_block_chip_index(block, gc);
> +
> +		if (index < 0) {
> +			block->nchip++;
> +			block->gbc = krealloc(block->gbc,
> +					      sizeof(struct gpio_block_chip) *
> +					      block->nchip, GFP_KERNEL);

krealloc is a bit nasty. Can't you add a struct list_head to struct
gpio_block_chip or something?

This also leaks memory if the krealloc fails, since the original pointer
is lost. You need to use a temporary for the re-allocation.

> +			if (!block->gbc)
> +				goto err2;
> +			gbc = &block->gbc[block->nchip - 1];
> +			gbc->gc = gc;
> +			gbc->remap = NULL;
> +			gbc->nremap = 0;
> +			gbc->mask = 0;
> +		} else {
> +			gbc = &block->gbc[index];
> +		}
> +		/* represents the mask necessary on calls to the driver's
> +		 * .get_block() and .set_block()
> +		 */

  /*
   * Nitpick - multi-line comment style looks like this.
   * However, other comments in this file use this style
   * so maybe keep for consistency.
   */

> +		gbc->mask |= BIT(bit);
> +
> +		/* collect gpios that are specified together, represented by
> +		 * neighboring bits
> +		 */
> +		remap = &gbc->remap[gbc->nremap - 1];

This looks broken. If gbc was re-alloced above (index < 0) then
gbc->remap == NULL and this will oops?

> +		if (!gbc->nremap || (bit - i != remap->offset)) {

gbc->nremap would have to be non-zero here, otherwise you have:

  gbc->remap[0 - 1]

above.

> +			gbc->nremap++;
> +			gbc->remap = krealloc(gbc->remap,
> +					      sizeof(struct gpio_remap) *
> +					      gbc->nremap, GFP_KERNEL);

Memory leak on failure. Also, is an alternative to krealloc possible.
Maybe a list?

> +			if (!gbc->remap)
> +				goto err3;
> +			remap = &gbc->remap[gbc->nremap - 1];
> +			remap->offset = bit - i;
> +			remap->mask = 0;
> +		}
> +
> +		/* represents the mask necessary for bit reordering between
> +		 * gpio_block (i.e. as specified on gpio_block_get() and
> +		 * gpio_block_set()) and gpio_chip domain (i.e. as specified on
> +		 * the driver's .set_block() and .get_block())
> +		 */
> +		remap->mask |= BIT(i);
> +	}

The remap functionality isn't very well explained (and looks like it
doesn't work properly anyway). Some comments explaining what the remap
does and how it works would be useful.

> +	return block;
> +err3:
> +	for (i = 0; i < block->nchip - 1; i++)
> +		kfree(block->gbc[i].remap);
> +	kfree(block->gbc);
> +err2:
> +	kfree(block->gpio);
> +err1:
> +	kfree(block);
> +	return ERR_PTR(-ENOMEM);
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_create);
> +
> +void gpio_block_free(struct gpio_block *block)
> +{
> +	int i;
> +
> +	for (i = 0; i < block->nchip; i++)
> +		kfree(block->gbc[i].remap);
> +	kfree(block->gpio);
> +	kfree(block->gbc);
> +	kfree(block);
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_free);
> +
> +unsigned gpio_block_get(const struct gpio_block *block)
> +{
> +	struct gpio_block_chip *gbc;
> +	int i, j;
> +	unsigned values = 0;
> +
> +	for (i = 0; i < block->nchip; i++) {
> +		unsigned remapped = 0;
> +
> +		gbc = &block->gbc[i];
> +
> +		if (gbc->gc->get_block) {
> +			remapped = gbc->gc->get_block(gbc->gc, gbc->mask);
> +		} else { /* emulate */
> +			unsigned bit = 1;
> +
> +			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
> +				if (gbc->mask & bit)

A proper bitmask might be more ideal for this. It would remove the
sizeof(unsigned) restriction and allow you to use for_each_set_bit for
these loops.

> +					remapped |= gbc->gc->get(gbc->gc,
> +							gbc->gc->base + j) << j;
> +			}
> +		}
> +
> +		for (j = 0; j < gbc->nremap; j++) {
> +			struct gpio_remap *gr = &gbc->remap[j];
> +
> +			values |= (remapped >> gr->offset) & gr->mask;
> +		}
> +	}
> +
> +	return values;
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_get);
> +
> +void gpio_block_set(struct gpio_block *block, unsigned values)
> +{
> +	struct gpio_block_chip *gbc;
> +	int i, j;
> +
> +	for (i = 0; i < block->nchip; i++) {
> +		unsigned remapped = 0;
> +
> +		gbc = &block->gbc[i];
> +
> +		for (j = 0; j < gbc->nremap; j++) {
> +			struct gpio_remap *gr = &gbc->remap[j];
> +
> +			remapped |= (values & gr->mask) << gr->offset;
> +		}
> +		if (gbc->gc->set_block) {
> +			gbc->gc->set_block(gbc->gc, gbc->mask, remapped);
> +		} else { /* emulate */

Nitpick - Put the comment on a line by itself.

> +			unsigned bit = 1;
> +
> +			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
> +				if (gbc->mask & bit)
> +					gbc->gc->set(gbc->gc, gbc->gc->base + j,
> +						     (remapped >> j) & 1);
> +			}

This doesn't clear pins which are set to zero? If you are using
gpio_block to bit-bang a bus then you probably want that to happen.
Probably you want three functions, gpio_block_set (set only),
gpio_block_clear (clear only) and gpio_block_drive (set/clear).

> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_set);
> +
> +struct gpio_block *gpio_block_find_by_name(const char *name)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_GPIO_BLOCKS; i++) {

A static limit is lame. Make it a list.

> +		if (gpio_block[i] && !strcmp(gpio_block[i]->name, name))
> +			return gpio_block[i];
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_find_by_name);
> +
> +int gpio_block_register(struct gpio_block *block)
> +{
> +	int i;
> +
> +	if (gpio_block_find_by_name(block->name))
> +		return -EBUSY;
> +
> +	for (i = 0; i < NR_GPIO_BLOCKS; i++) {
> +		if (!gpio_block[i]) {
> +			gpio_block[i] = block;
> +			break;
> +		}
> +	}
> +	return i == NR_GPIO_BLOCKS ? -EBUSY : 0;
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_register);
> +
> +void gpio_block_unregister(struct gpio_block *block)
> +{
> +	int i;
> +
> +	for (i = 0; i < NR_GPIO_BLOCKS; i++) {
> +		if (gpio_block[i] == block) {
> +			gpio_block[i] = NULL;
> +			break;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_unregister);
> +
>  /**
>   * __gpio_cansleep() - report whether gpio value access will sleep
>   * @gpio: gpio in question
> --- linux-2.6.orig/include/asm-generic/gpio.h
> +++ linux-2.6/include/asm-generic/gpio.h
> @@ -43,6 +43,7 @@ static inline bool gpio_is_valid(int num
>  
>  struct device;
>  struct gpio;
> +struct gpio_block;
>  struct seq_file;
>  struct module;
>  struct device_node;
> @@ -105,6 +106,8 @@ struct gpio_chip {
>  						unsigned offset);
>  	int			(*get)(struct gpio_chip *chip,
>  						unsigned offset);
> +	unsigned		(*get_block)(struct gpio_chip *chip,
> +					     unsigned mask);
>  	int			(*direction_output)(struct gpio_chip *chip,
>  						unsigned offset, int value);
>  	int			(*set_debounce)(struct gpio_chip *chip,
> @@ -112,6 +115,8 @@ struct gpio_chip {
>  
>  	void			(*set)(struct gpio_chip *chip,
>  						unsigned offset, int value);
> +	void			(*set_block)(struct gpio_chip *chip,
> +					     unsigned mask, unsigned values);
>  
>  	int			(*to_irq)(struct gpio_chip *chip,
>  						unsigned offset);
> @@ -171,6 +176,15 @@ extern void gpio_set_value_cansleep(unsi
>  extern int __gpio_get_value(unsigned gpio);
>  extern void __gpio_set_value(unsigned gpio, int value);
>  
> +extern struct gpio_block *gpio_block_create(unsigned *gpio, size_t size,
> +					    const char *name);
> +extern void gpio_block_free(struct gpio_block *block);
> +extern unsigned gpio_block_get(const struct gpio_block *block);
> +extern void gpio_block_set(struct gpio_block *block, unsigned values);
> +extern struct gpio_block *gpio_block_find_by_name(const char *name);
> +extern int gpio_block_register(struct gpio_block *block);
> +extern void gpio_block_unregister(struct gpio_block *block);
> +
>  extern int __gpio_cansleep(unsigned gpio);
>  
>  extern int __gpio_to_irq(unsigned gpio);
> --- linux-2.6.orig/include/linux/gpio.h
> +++ linux-2.6/include/linux/gpio.h
> @@ -2,6 +2,7 @@
>  #define __LINUX_GPIO_H
>  
>  #include <linux/errno.h>
> +#include <linux/types.h>
>  
>  /* see Documentation/gpio.txt */
>  
> @@ -39,6 +40,31 @@ struct gpio {
>  	const char	*label;
>  };
>  
> +struct gpio_remap {
> +	int	mask;
> +	int	offset;
> +};
> +
> +struct gpio_block_chip {
> +	struct gpio_chip	*gc;
> +	struct gpio_remap	*remap;
> +	int			nremap;
> +	unsigned		mask;
> +};
> +
> +/**
> + * struct gpio_block - a structure describing a list of GPIOs for simultaneous
> + *                     operations
> + */
> +struct gpio_block {
> +	struct gpio_block_chip	*gbc;
> +	size_t			nchip;
> +	const char		*name;
> +
> +	int			ngpio;
> +	unsigned		*gpio;
> +};
> +
>  #ifdef CONFIG_GENERIC_GPIO
>  
>  #ifdef CONFIG_ARCH_HAVE_CUSTOM_GPIO_H
> @@ -169,6 +195,41 @@ static inline void gpio_set_value(unsign
>  	WARN_ON(1);
>  }
>  
> +static inline
> +struct gpio_block *gpio_block_create(unsigned int *gpios, size_t size,
> +				     const char *name)
> +{
> +	WARN_ON(1);
> +	return NULL;
> +}
> +
> +static inline void gpio_block_free(struct gpio_block *block)
> +{
> +	WARN_ON(1);
> +}
> +
> +static inline unsigned gpio_block_get(const struct gpio_block *block)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}
> +
> +static inline void gpio_block_set(struct gpio_block *block, unsigned value)
> +{
> +	WARN_ON(1);
> +}
> +
> +static inline int gpio_block_register(struct gpio_block *block)
> +{
> +	WARN_ON(1);
> +	return 0;
> +}
> +
> +static inline void gpio_block_unregister(struct gpio_block *block)
> +{
> +	WARN_ON(1);
> +}
> +
>  static inline int gpio_cansleep(unsigned gpio)
>  {
>  	/* GPIO can never have been requested or set as {in,out}put */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


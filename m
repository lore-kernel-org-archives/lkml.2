Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2JORUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 13:20:54 -0400
Received: from antcom.de ([188.40.178.216]:50616 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167Ab2JORUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 13:20:50 -0400
Message-ID: <507C45EF.7080203@antcom.de>
Date: Mon, 15 Oct 2012 19:20:47 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>
CC: grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 1/6 v3] gpio: Add a block GPIO API to gpiolib
References: <1350069085-13283-1-git-send-email-stigge@antcom.de> <1350069085-13283-2-git-send-email-stigge@antcom.de> <507B9D05.1000204@gmail.com>
In-Reply-To: <507B9D05.1000204@gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

thank you for your feedback, I will include it, except for some points
noted below:

On 10/15/2012 07:20 AM, Ryan Mallon wrote:
>> +The above described interface concentrates on handling single GPIOs.  However,
>> +in applications where it is critical to set several GPIOs at once, this
>> +interface doesn't work well, e.g. bit-banging protocols via grouped GPIO lines.
>> +Consider a GPIO controller that is connected via a slow I2C line. When
>> +switching two or more GPIOs one after another, there can be considerable time
>> +between those events. This is solved by an interface called Block GPIO:
> 
> The emulate behaviour of gpio block switches gpios one after the other.
> Is the problem only solved if the block_get/block_set callbacks can be
> implemented?

Right, this is documented some lines away:

>> +struct gpio_block *gpio_block_create(unsigned int *gpios, size_t size);
>> +
>> +This creates a new block of GPIOs as a list of GPIO numbers with the specified
>> +size which are accessible via the returned struct gpio_block and the accessor
>> +functions described below. Please note that you need to request the GPIOs
>> +separately via gpio_request(). An arbitrary list of globally valid GPIOs can be
>> +specified, even ranging over several gpio_chips. Actual handling of I/O
>> +operations will be done on a best effort base, i.e. simultaneous I/O only where
>> +possible by hardware and implemented in the respective GPIO driver. The number
>> +of GPIOs in one block is limited to 32 on a 32 bit system, and 64 on a 64 bit
>> +system. However, several blocks can be defined at once.
>> +
>> +unsigned gpio_block_get(struct gpio_block *block);
>> +void gpio_block_set(struct gpio_block *block, unsigned value);
>> +
>> +With those accessor functions, setting and getting the GPIO values is possible,
>> +analogous to gpio_get_value() and gpio_set_value(). Each bit in the return
>> +value of gpio_block_get() and in the value argument of gpio_block_set()
>> +corresponds to a bit specified on gpio_block_create(). Block operations in
>> +hardware are only possible where the respective GPIO driver implements it,
>> +falling back to using single GPIO operations where the driver only implements
>> +single GPIO access.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
... here.

>> +struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
>> +				     const char *name)
>> +{
>> +	struct gpio_block *block;
>> +	struct gpio_block_chip *gbc;
>> +	struct gpio_remap *remap;
>> +	int i;
>> +
>> +	if (size < 1 || size > sizeof(unsigned) * 8)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	block = kzalloc(sizeof(struct gpio_block), GFP_KERNEL);
>> +	if (!block)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	block->name = name;
>> +	block->ngpio = size;
>> +	block->gpio = kzalloc(sizeof(*block->gpio) * size, GFP_KERNEL);
>> +	if (!block->gpio)
>> +		goto err1;
>> +
>> +	memcpy(block->gpio, gpios, sizeof(*block->gpio) * size);
>> +
>> +	for (i = 0; i < size; i++)
>> +		if (!gpio_is_valid(gpios[i]))
>> +			goto err2;
> 
> This loop should probably go at the start of the function, so you can
> avoid doing the kzalloc/memcpy if it fails.

OK.

> This function doesn't call gpio_request. Either it should, or it should
> rely on the caller to have already done so, and call
> gpio_ensure_requested here. There is also an implicit rule that any
> gpios inside a block must not be freed as long as the block exists.

The idea is analogous to GPIOs itself. Just the existence of it doesn't
require it being requested. This way, it is possible to e.g. instantiate
a block via device tree and let the user itself take care for direction,
requesting and so on. Look at the sysfs binding: Only when someone
exports the actual block values to userspace (write 0/1 to "exported"),
the GPIOs in the block are requested by "sysfs".

Please note that this is already documented above (look for "Please note").

>> +
>> +	for (i = 0; i < size; i++) {
>> +		struct gpio_chip *gc = gpio_to_chip(gpios[i]);
>> +		int bit = gpios[i] - gc->base;
>> +		int index = gpio_block_chip_index(block, gc);
>> +
>> +		if (index < 0) {
>> +			block->nchip++;
>> +			block->gbc = krealloc(block->gbc,
>> +					      sizeof(struct gpio_block_chip) *
>> +					      block->nchip, GFP_KERNEL);
> 
> krealloc is a bit nasty. Can't you add a struct list_head to struct
> gpio_block_chip or something?

I also hesitated. But having it this way provides quite efficient access
later on.

> This also leaks memory if the krealloc fails, since the original pointer
> is lost. You need to use a temporary for the re-allocation.

OK.

>> +		/* represents the mask necessary on calls to the driver's
>> +		 * .get_block() and .set_block()
>> +		 */
> 
>   /*
>    * Nitpick - multi-line comment style looks like this.
>    * However, other comments in this file use this style
>    * so maybe keep for consistency.
>    */

Right, decided for the latter.

>> +		gbc->mask |= BIT(bit);
>> +
>> +		/* collect gpios that are specified together, represented by
>> +		 * neighboring bits
>> +		 */
>> +		remap = &gbc->remap[gbc->nremap - 1];
> 
> This looks broken. If gbc was re-alloced above (index < 0) then
> gbc->remap == NULL and this will oops?

No, because I took care that even though index can be < 0, the resulting
pointer is never dereferenced for -1.

> 
>> +		if (!gbc->nremap || (bit - i != remap->offset)) {
> 
> gbc->nremap would have to be non-zero here, otherwise you have:
> 
>   gbc->remap[0 - 1]
> 
> above.
> 
>> +			gbc->nremap++;
                        ^^^^^^^^^^^^^^
... here it is: in the gbc->nremap == 0 case, it gets incremented
immediately and remap is not dereferenced. Even in the above ( || ), the
right side is only evaluated if gbc->nremap > 0.

>> +			if (!gbc->remap)
>> +				goto err3;
>> +			remap = &gbc->remap[gbc->nremap - 1];
>> +			remap->offset = bit - i;
>> +			remap->mask = 0;
>> +		}
>> +
>> +		/* represents the mask necessary for bit reordering between
>> +		 * gpio_block (i.e. as specified on gpio_block_get() and
>> +		 * gpio_block_set()) and gpio_chip domain (i.e. as specified on
>> +		 * the driver's .set_block() and .get_block())
>> +		 */
>> +		remap->mask |= BIT(i);
>> +	}
> 
> The remap functionality isn't very well explained

Documenting now in gpio.h like this:

/*
 * struct gpio_remap - a structure for describing a bit mapping
 * @mask:       a bit mask
 * @offset:     how many bits to shift to the left (negative: to the
 *              right)
 *
 * When we are mapping bit values from one word to another (here: from
 * GPIO block domain to GPIO driver domain), we first mask them out
 * with mask and shift them as specified with offset. More complicated
 * mappings are done by grouping several of those structs and adding
 * the results together.
 */
struct gpio_remap {
        int     mask;
        int     offset;
};

> (and looks like it doesn't work properly anyway).

If you find an issue, please let me know. Works fine for me. Have you
tried? :-)

>> +unsigned gpio_block_get(const struct gpio_block *block)
>> +{
>> +	struct gpio_block_chip *gbc;
>> +	int i, j;
>> +	unsigned values = 0;
>> +
>> +	for (i = 0; i < block->nchip; i++) {
>> +		unsigned remapped = 0;
>> +
>> +		gbc = &block->gbc[i];
>> +
>> +		if (gbc->gc->get_block) {
>> +			remapped = gbc->gc->get_block(gbc->gc, gbc->mask);
>> +		} else { /* emulate */
>> +			unsigned bit = 1;
>> +
>> +			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
>> +				if (gbc->mask & bit)
> 
> A proper bitmask might be more ideal for this. It would remove the
> sizeof(unsigned) restriction and allow you to use for_each_set_bit for
> these loops.

In a previous version of these patches, I actually had a generic bit
mask which was in turn awkward to handle, especially for the bit
remapping. Stijn brought me to the idea that for pragmatic reasons, 32
bit access is fully sufficient in most cases.

I also needed userland access (via sysfs), so there was no way of
accessing a block except via an int.

When there are GPIO drivers where we seriously need (and can handle
simultaneously) more than 32 bits, we can still extend the API. For now,
the cases where it is used is typically creating 8/16/32 bit busses with
GPIO lines, and on 64bit architectures even 64bit busses.

For this, the current API is working fine, even enabling userland access
via sysfs.

>> +			unsigned bit = 1;
>> +
>> +			for (j = 0; j < sizeof(unsigned) * 8; j++, bit <<= 1) {
>> +				if (gbc->mask & bit)
>> +					gbc->gc->set(gbc->gc, gbc->gc->base + j,
>> +						     (remapped >> j) & 1);
>> +			}
> 
> This doesn't clear pins which are set to zero?

It does. gbc->mask only masks which bits to set and clear. remapped
contains the actual bit values to set. 0 or 1.

Including all the other suggestions in the next update.

Thanks,

Roland

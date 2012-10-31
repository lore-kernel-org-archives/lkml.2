Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628Ab2JaOGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:06:53 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63836 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab2JaOGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:06:51 -0400
MIME-Version: 1.0
In-Reply-To: <1351457210-25222-2-git-send-email-stigge@antcom.de>
References: <1351457210-25222-1-git-send-email-stigge@antcom.de>
	<1351457210-25222-2-git-send-email-stigge@antcom.de>
Date: Wed, 31 Oct 2012 15:06:50 +0100
Message-ID: <CACRpkdbpxR8hQ13R43T1X9be95rJNMdgNPXfT3bQOO_dZU4Fkg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 9:46 PM, Roland Stigge <stigge@antcom.de> wrote:

Just a quick few things I spotted:

> +struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
> +                                    const char *name)
> +{
> +       struct gpio_block *block;
> +       struct gpio_block_chip *gbc;
> +       struct gpio_remap *remap;
> +       void *tmp;
> +       int i;
> +
> +       if (size < 1 || size > sizeof(unsigned long) * 8)
> +               return ERR_PTR(-EINVAL);

If the most GPIOs in a block is BITS_PER_LONG, why is the
latter clause not size > BITS_PER_LONG?

Maybe there was some discussion I missed, anyway it deserves
a comment because this looks completely arbitrary.

> +       for (i = 0; i < size; i++)
> +               if (!gpio_is_valid(gpios[i]))
> +                       return ERR_PTR(-EINVAL);
> +
> +       block = kzalloc(sizeof(struct gpio_block), GFP_KERNEL);
> +       if (!block)
> +               return ERR_PTR(-ENOMEM);

If these were instead glued to a struct device you could do
devm_kzalloc() here and have it garbage collected.

This is why
https://blueprints.launchpad.net/linux-linaro/+spec/gpiochip-to-dev
needs to happen. (Sorry for hyperlinking.)

> +       block->name = name;
> +       block->ngpio = size;
> +       block->gpio = kzalloc(sizeof(*block->gpio) * size, GFP_KERNEL);
> +       if (!block->gpio)
> +               goto err1;
> +
> +       memcpy(block->gpio, gpios, sizeof(*block->gpio) * size);
> +
> +       for (i = 0; i < size; i++) {
> +               struct gpio_chip *gc = gpio_to_chip(gpios[i]);
> +               int bit = gpios[i] - gc->base;
> +               int index = gpio_block_chip_index(block, gc);
> +
> +               if (index < 0) {
> +                       block->nchip++;
> +                       tmp = krealloc(block->gbc,
> +                                      sizeof(struct gpio_block_chip) *
> +                                      block->nchip, GFP_KERNEL);

Don't do this dynamic array business. Use a linked list instead.

> +                       if (!tmp) {
> +                               kfree(block->gbc);
> +                               goto err2;
> +                       }
> +                       block->gbc = tmp;
> +                       gbc = &block->gbc[block->nchip - 1];

So this becomes a list traversal and lookup instead.

> +                       gbc->gc = gc;
> +                       gbc->remap = NULL;
> +                       gbc->nremap = 0;
> +                       gbc->mask = 0;
> +               } else {
> +                       gbc = &block->gbc[index];

So find it in the list instead.

> +               }
> +               /* represents the mask necessary on calls to the driver's
> +                * .get_block() and .set_block()
> +                */
> +               gbc->mask |= BIT(bit);
> +
> +               /* collect gpios that are specified together, represented by
> +                * neighboring bits
> +                *
> +                * Note that even though in setting remap is given a negative
> +                * index, the next lines guard that the potential out-of-bounds
> +                * pointer is not dereferenced when out of bounds.
> +                */


/*
 * Maybe I'm a bit picky on comment style but I prefer
 * that the first line of a multi-line comment is blank.
 * Applies everywhere.
 */

> +               remap = &gbc->remap[gbc->nremap - 1];
> +               if (!gbc->nremap || (bit - i != remap->offset)) {
> +                       gbc->nremap++;
> +                       tmp = krealloc(gbc->remap,
> +                                             sizeof(struct gpio_remap) *
> +                                             gbc->nremap, GFP_KERNEL);

I don't like this dynamic array either.
Basic pattern: wherever there is a krealloc, use a list.

If lists aren't efficient enough, use some other datastructure, rbtree or
whatever.

> +                       if (!tmp) {
> +                               kfree(gbc->remap);
> +                               goto err3;
> +                       }
> +                       gbc->remap = tmp;
> +                       remap = &gbc->remap[gbc->nremap - 1];
> +                       remap->offset = bit - i;
> +                       remap->mask = 0;
> +               }
> +
> +               /* represents the mask necessary for bit reordering between
> +                * gpio_block (i.e. as specified on gpio_block_get() and
> +                * gpio_block_set()) and gpio_chip domain (i.e. as specified on
> +                * the driver's .set_block() and .get_block())
> +                */
> +               remap->mask |= BIT(i);
> +       }
> +
> +       return block;
> +err3:
> +       for (i = 0; i < block->nchip - 1; i++)
> +               kfree(block->gbc[i].remap);
> +       kfree(block->gbc);
> +err2:
> +       kfree(block->gpio);
> +err1:
> +       kfree(block);
> +       return ERR_PTR(-ENOMEM);
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_create);
> +
> +void gpio_block_free(struct gpio_block *block)
> +{
> +       int i;
> +
> +       for (i = 0; i < block->nchip; i++)
> +               kfree(block->gbc[i].remap);
> +       kfree(block->gpio);
> +       kfree(block->gbc);
> +       kfree(block);
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_free);

So if we only had a real struct device  inside the gpiochip all
this boilerplate would go away, as devm_* take care of releasing
the resources.

> +unsigned long gpio_block_get(const struct gpio_block *block)
> +{
> +       struct gpio_block_chip *gbc;
> +       int i, j;
> +       unsigned long values = 0;
> +
> +       for (i = 0; i < block->nchip; i++) {
> +               unsigned long remapped = 0;
> +
> +               gbc = &block->gbc[i];
> +
> +               if (gbc->gc->get_block) {
> +                       remapped = gbc->gc->get_block(gbc->gc, gbc->mask);
> +               } else {
> +                       /* emulate */
> +                       for_each_set_bit(j, &gbc->mask, BITS_PER_LONG)
> +                               remapped |= gbc->gc->get(gbc->gc,
> +                                               gbc->gc->base + j) << j;
> +               }
> +
> +               for (j = 0; j < gbc->nremap; j++) {
> +                       struct gpio_remap *gr = &gbc->remap[j];
> +
> +                       values |= (remapped >> gr->offset) & gr->mask;
> +               }
> +       }
> +
> +       return values;
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_get);
> +
> +void gpio_block_set(struct gpio_block *block, unsigned long values)
> +{
> +       struct gpio_block_chip *gbc;
> +       int i, j;
> +
> +       for (i = 0; i < block->nchip; i++) {
> +               unsigned long remapped = 0;
> +
> +               gbc = &block->gbc[i];
> +
> +               for (j = 0; j < gbc->nremap; j++) {
> +                       struct gpio_remap *gr = &gbc->remap[j];
> +
> +                       remapped |= (values & gr->mask) << gr->offset;
> +               }
> +               if (gbc->gc->set_block) {
> +                       gbc->gc->set_block(gbc->gc, gbc->mask, remapped);
> +               } else {
> +                       /* emulate */
> +                       for_each_set_bit(j, &gbc->mask, BITS_PER_LONG)
> +                               gbc->gc->set(gbc->gc, gbc->gc->base + j,
> +                                            (remapped >> j) & 1);
> +               }
> +       }
> +}
> +EXPORT_SYMBOL_GPL(gpio_block_set);
> +
> +struct gpio_block *gpio_block_find_by_name(const char *name)
> +{
> +       struct gpio_block *i;
> +
> +       list_for_each_entry(i, &gpio_block_list, list)
> +               if (!strcmp(i->name, name))
> +                       return i;

And here is a list anyway, I'm getting confused of this partitioning between
using dynamic arrays and lists. Just use a list please. This part looks
good.

Yours,
Linus Walleij

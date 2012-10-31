Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935838Ab2JaRrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:47:21 -0400
Received: from antcom.de ([188.40.178.216]:34391 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759374Ab2JaRrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:47:17 -0400
Message-ID: <50916422.2060002@antcom.de>
Date: Wed, 31 Oct 2012 18:47:14 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
References: <1351457210-25222-1-git-send-email-stigge@antcom.de> <1351457210-25222-2-git-send-email-stigge@antcom.de> <CACRpkdbpxR8hQ13R43T1X9be95rJNMdgNPXfT3bQOO_dZU4Fkg@mail.gmail.com>
In-Reply-To: <CACRpkdbpxR8hQ13R43T1X9be95rJNMdgNPXfT3bQOO_dZU4Fkg@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

thanks for your notes, comments below:

On 10/31/2012 03:06 PM, Linus Walleij wrote:
>> +struct gpio_block *gpio_block_create(unsigned *gpios, size_t size,
>> +                                    const char *name)
>> +{
>> +       struct gpio_block *block;
>> +       struct gpio_block_chip *gbc;
>> +       struct gpio_remap *remap;
>> +       void *tmp;
>> +       int i;
>> +
>> +       if (size < 1 || size > sizeof(unsigned long) * 8)
>> +               return ERR_PTR(-EINVAL);
> 
> If the most GPIOs in a block is BITS_PER_LONG, why is the
> latter clause not size > BITS_PER_LONG?

Good catch, thanks! :-)

>> +       for (i = 0; i < size; i++)
>> +               if (!gpio_is_valid(gpios[i]))
>> +                       return ERR_PTR(-EINVAL);
>> +
>> +       block = kzalloc(sizeof(struct gpio_block), GFP_KERNEL);
>> +       if (!block)
>> +               return ERR_PTR(-ENOMEM);
> 
> If these were instead glued to a struct device you could do
> devm_kzalloc() here and have it garbage collected.

Good, will do.

> This is why
> https://blueprints.launchpad.net/linux-linaro/+spec/gpiochip-to-dev
> needs to happen. (Sorry for hyperlinking.)
> 
>> +       block->name = name;
>> +       block->ngpio = size;
>> +       block->gpio = kzalloc(sizeof(*block->gpio) * size, GFP_KERNEL);
>> +       if (!block->gpio)
>> +               goto err1;
>> +
>> +       memcpy(block->gpio, gpios, sizeof(*block->gpio) * size);
>> +
>> +       for (i = 0; i < size; i++) {
>> +               struct gpio_chip *gc = gpio_to_chip(gpios[i]);
>> +               int bit = gpios[i] - gc->base;
>> +               int index = gpio_block_chip_index(block, gc);
>> +
>> +               if (index < 0) {
>> +                       block->nchip++;
>> +                       tmp = krealloc(block->gbc,
>> +                                      sizeof(struct gpio_block_chip) *
>> +                                      block->nchip, GFP_KERNEL);
> 
> Don't do this dynamic array business. Use a linked list instead.

OK, I checked the important spots where access to the two lists (gbc and
remap) happen (set and get functions), and the access is always
sequential, monotonic. So will use lists. Thanks.

> [...]
> /*
>  * Maybe I'm a bit picky on comment style but I prefer
>  * that the first line of a multi-line comment is blank.
>  * Applies everywhere.
>  */

As noted earlier in the discussion, current gpiolib.c's convention is
done first-line-not-blank. So I sticked to this (un)convention. But can
change this - you are not the first one pointing this out. :-)

>> +                       if (!tmp) {
>> +                               kfree(gbc->remap);
>> +                               goto err3;
>> +                       }
>> +                       gbc->remap = tmp;
>> +                       remap = &gbc->remap[gbc->nremap - 1];
>> +                       remap->offset = bit - i;
>> +                       remap->mask = 0;
>> +               }
>> +
>> +               /* represents the mask necessary for bit reordering between
>> +                * gpio_block (i.e. as specified on gpio_block_get() and
>> +                * gpio_block_set()) and gpio_chip domain (i.e. as specified on
>> +                * the driver's .set_block() and .get_block())
>> +                */
>> +               remap->mask |= BIT(i);
>> +       }
>> +
>> +       return block;
>> +err3:
>> +       for (i = 0; i < block->nchip - 1; i++)
>> +               kfree(block->gbc[i].remap);
>> +       kfree(block->gbc);
>> +err2:
>> +       kfree(block->gpio);
>> +err1:
>> +       kfree(block);
>> +       return ERR_PTR(-ENOMEM);
>> +}
>> +EXPORT_SYMBOL_GPL(gpio_block_create);
>> +
>> +void gpio_block_free(struct gpio_block *block)
>> +{
>> +       int i;
>> +
>> +       for (i = 0; i < block->nchip; i++)
>> +               kfree(block->gbc[i].remap);
>> +       kfree(block->gpio);
>> +       kfree(block->gbc);
>> +       kfree(block);
>> +}
>> +EXPORT_SYMBOL_GPL(gpio_block_free);
> 
> So if we only had a real struct device  inside the gpiochip all
> this boilerplate would go away, as devm_* take care of releasing
> the resources.

Right. I guess you mean struct gpio_block here which should have a dev?
(Having gpiochip as a dev also would be best, though.) :-)

We need a separate dev for struct gpio_block, since those can be defined
dynamically (i.e. often) during the lifespan of gpio and gpiochip, so
garbage collection would be deferred for too long.

Thanks,

Roland

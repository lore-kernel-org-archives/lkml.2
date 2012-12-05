Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab2LETBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:01:13 -0500
Received: from ngcobalt02.manitu.net ([217.11.48.102]:42873 "EHLO
	ngcobalt02.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806Ab2LETBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:01:12 -0500
X-manitu-Original-Sender-IP: 93.104.11.153
X-manitu-Original-Receiver-Name: ngcobalt02.manitu.net
Message-ID: <50BF99F3.4060207@grandegger.com>
Date: Wed, 05 Dec 2012 20:01:07 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, tru@work-microwave.de, sr@denx.de
Subject: Re: [PATCH 3/6 v9] gpio: Add userland device interface to block GPIO
References: <1354653588-4018-1-git-send-email-stigge@antcom.de> <1354653588-4018-4-git-send-email-stigge@antcom.de>
In-Reply-To: <1354653588-4018-4-git-send-email-stigge@antcom.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2012 09:39 PM, Roland Stigge wrote:
> This patch adds a character device interface to the block GPIO system.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> ---
>  Documentation/ABI/testing/dev-gpioblock |   34 +++++
>  drivers/gpio/gpiolib.c                  |  208 +++++++++++++++++++++++++++++++-
>  include/linux/gpio.h                    |   10 +
>  3 files changed, 251 insertions(+), 1 deletion(-)
> 
> --- /dev/null
> +++ linux-2.6/Documentation/ABI/testing/dev-gpioblock
> @@ -0,0 +1,34 @@
> +What:		/dev/<gpioblock>
> +Date:		Nov 2012
> +KernelVersion:	3.7
> +Contact:	Roland Stigge <stigge@antcom.de>
> +Description:	The /dev/<gpioblock> character device node provides userspace
> +		access to GPIO blocks, named exactly as the block, e.g.
> +		/dev/block0.
> +
> +		Reading:
> +		When reading sizeof(unsigned long) bytes from the device, the
> +		current state of the block, masked by the current mask (see
> +		below) can be obtained as a word. When the device is opened
> +		with O_NONBLOCK, read() always returns with data immediately,
> +		otherwise it blocks until data is available, see IRQ handling
> +		below.
> +
> +		Writing:
> +		By writing sizeof(unsigned long) bytes to the device, the
> +		current state of the block can be set. This operation is
> +		masked by the current mask (see below).
> +
> +		IRQ handling:
> +		When one or more IRQs in the block are IRQ capable, you can
> +		poll() on the device to check/wait for this IRQ. If no IRQ
> +		is available, poll() returns -ENOSYS and userspace needs to
> +		(busy) poll itself if necessary.
> +
> +		Setting the mask (default: all bits set):
> +		By doing an ioctl(fd, 0, &mask) with an unsigned long mask, the
> +		current mask for read and write operations on this gpio block
> +		can be set.
> +
> +		See also Documentation/gpio.txt for an explanation of block
> +		GPIO.
> --- linux-2.6.orig/drivers/gpio/gpiolib.c
> +++ linux-2.6/drivers/gpio/gpiolib.c
> @@ -11,6 +11,8 @@
>  #include <linux/of_gpio.h>
>  #include <linux/idr.h>
>  #include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/poll.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/gpio.h>
> @@ -2122,6 +2124,190 @@ struct gpio_block *gpio_block_find_by_na
>  }
>  EXPORT_SYMBOL_GPL(gpio_block_find_by_name);
>  
> +static struct gpio_block *gpio_block_find_by_minor(int minor)
> +{
> +	struct gpio_block *i;
> +
> +	list_for_each_entry(i, &gpio_block_list, list)
> +		if (i->miscdev.minor == minor)
> +			return i;
> +	return NULL;
> +}
> +
> +static bool gpio_block_is_irq_duplicate(struct gpio_block *block, int index)
> +{
> +	int irq = gpio_to_irq(block->gpio[index]);
> +	int i;
> +
> +	for (i = 0; i < index; i++)
> +		if (gpio_to_irq(block->gpio[i]) == irq)
> +			return true;
> +	return false;
> +}
> +
> +static irqreturn_t gpio_block_irq_handler(int irq, void *dev)
> +{
> +	struct gpio_block *block = dev;
> +
> +	wake_up_interruptible(&block->wait_queue);
> +	block->got_int = true;
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int gpio_block_fop_open(struct inode *in, struct file *f)
> +{
> +	int i;
> +	struct gpio_block *block = gpio_block_find_by_minor(MINOR(in->i_rdev));
> +	int status;
> +	int irq;
> +
> +	if (!block)
> +		return -ENOENT;
> +
> +	block->irq_controlled = false;
> +	block->got_int = false;
> +	init_waitqueue_head(&block->wait_queue);
> +	f->private_data = block;
> +
> +	for (i = 0; i < block->ngpio; i++) {
> +		status = gpio_request(block->gpio[i], "gpioblock dev");

You could use the name of the GPIO block.

> +		if (status)
> +			goto err1;
> +
> +		irq = gpio_to_irq(block->gpio[i]);
> +		if (irq >= 0 &&
> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
> +		    !gpio_block_is_irq_duplicate(block, i)) {
> +			status = request_irq(irq, gpio_block_irq_handler,
> +					     IRQF_TRIGGER_FALLING,
> +					     block->name, block);
> +			if (status)
> +				goto err2;
> +
> +			block->irq_controlled = true;
> +		}
> +	}

There is no need to request IRQs if "O_NONBLOCK" is specified.

> +
> +	return 0;
> +
> +err1:
> +	while (i > 0) {
> +		i--;
> +
> +		irq = gpio_to_irq(block->gpio[i]);
> +		if (irq >= 0 &&
> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
> +		    !gpio_block_is_irq_duplicate(block, i))
> +			free_irq(irq, block);
> +err2:
> +		gpio_free(block->gpio[i]);
> +	}
> +	return status;
> +}
> +
> +static int gpio_block_fop_release(struct inode *in, struct file *f)
> +{
> +	int i;
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +
> +	for (i = 0; i < block->ngpio; i++) {
> +		int irq = gpio_to_irq(block->gpio[i]);
> +
> +		if (irq >= 0 &&
> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
> +		    !gpio_block_is_irq_duplicate(block, i))
> +			free_irq(irq, block);
> +
> +		gpio_free(block->gpio[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static ssize_t gpio_block_fop_read(struct file *f, char __user *buf, size_t n,
> +				   loff_t *offset)
> +{
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +	int err;
> +
> +	if (block->irq_controlled) {
> +		if (!(f->f_flags & O_NONBLOCK))
> +			wait_event_interruptible(block->wait_queue,
> +						 block->got_int);
> +		block->got_int = 0;
> +	}
> +
> +	if (n >= sizeof(unsigned long)) {
> +		unsigned long values = gpio_block_get(block, block->cur_mask);
> +
> +		err = put_user(values, (unsigned long __user *)buf);
> +		if (err)
> +			return err;
> +
> +		return sizeof(unsigned long);
> +	}
> +	return 0;
> +}

I observed that the read returns once immediately (without blocking)
after reboot. I did not look into that yet.

Wolfgang.



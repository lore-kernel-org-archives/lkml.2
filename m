Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab2AEFig (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 00:38:36 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:51113 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab2AEFid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 00:38:33 -0500
Date: Thu, 5 Jan 2012 07:37:55 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Viresh Kumar <viresh.kumar@st.com>,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: pl061: remove combined interrupt
Message-ID: <20120105053755.GB3054@sapphire.tkos.co.il>
References: <1325705506-24230-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325705506-24230-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Wed, Jan 04, 2012 at 01:31:46PM -0600, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Drivers should not have a dependency on NR_IRQS. Doing so may break with
> SPARSE_IRQ enabled. As there are no in kernel users of the pl061 which
> have multiple instances with their interrupts combined to a single parent
> interrupt, remove this functionality. If this capability is needed later,
> it could be supported more cleanly by just using a devicetree property.

Well, I couldn't upstream the platform I was working on. Anyway, if adding 
support for a single interrupt source for multiple instances is as easy as you 
describe I'm fine with this change.

Acked-by: Baruch Siach <baruch@tkos.co.il>

> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Cc: Rajeev Kumar <rajeev-dlh.kumar@st.com>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/gpio/gpio-pl061.c |   44 ++++++++------------------------------------
>  1 files changed, 8 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
> index fe19dec..ee0e4b3 100644
> --- a/drivers/gpio/gpio-pl061.c
> +++ b/drivers/gpio/gpio-pl061.c
> @@ -12,7 +12,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/errno.h>
>  #include <linux/module.h>
> -#include <linux/list.h>
>  #include <linux/io.h>
>  #include <linux/ioport.h>
>  #include <linux/irq.h>
> @@ -37,13 +36,6 @@
>  #define PL061_GPIO_NR	8
>  
>  struct pl061_gpio {
> -	/* We use a list of pl061_gpio structs for each trigger IRQ in the main
> -	 * interrupts controller of the system. We need this to support systems
> -	 * in which more that one PL061s are connected to the same IRQ. The ISR
> -	 * interates through this list to find the source of the interrupt.
> -	 */
> -	struct list_head	list;
> -
>  	/* Each of the two spinlocks protects a different set of hardware
>  	 * regiters and data structurs. This decouples the code of the IRQ from
>  	 * the GPIO code. This also makes the case of a GPIO routine call from
> @@ -209,26 +201,20 @@ static struct irq_chip pl061_irqchip = {
>  
>  static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
>  {
> -	struct list_head *chip_list = irq_get_handler_data(irq);
> -	struct list_head *ptr;
> -	struct pl061_gpio *chip;
> +	unsigned long pending;
> +	int offset;
> +	struct pl061_gpio *chip = irq_desc_get_handler_data(desc);
>  	struct irq_chip *irqchip = irq_desc_get_chip(desc);
>  
>  	chained_irq_enter(irqchip, desc);
> -	list_for_each(ptr, chip_list) {
> -		unsigned long pending;
> -		int offset;
> -
> -		chip = list_entry(ptr, struct pl061_gpio, list);
> -		pending = readb(chip->base + GPIOMIS);
> -		writeb(pending, chip->base + GPIOIC);
> -
> -		if (pending == 0)
> -			continue;
>  
> +	pending = readb(chip->base + GPIOMIS);
> +	writeb(pending, chip->base + GPIOIC);
> +	if (pending) {
>  		for_each_set_bit(offset, &pending, PL061_GPIO_NR)
>  			generic_handle_irq(pl061_to_irq(&chip->gc, offset));
>  	}
> +
>  	chained_irq_exit(irqchip, desc);
>  }
>  
> @@ -236,9 +222,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  {
>  	struct pl061_platform_data *pdata;
>  	struct pl061_gpio *chip;
> -	struct list_head *chip_list;
>  	int ret, irq, i;
> -	static DECLARE_BITMAP(init_irq, NR_IRQS);
>  
>  	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>  	if (chip == NULL)
> @@ -270,7 +254,6 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  
>  	spin_lock_init(&chip->lock);
>  	spin_lock_init(&chip->irq_lock);
> -	INIT_LIST_HEAD(&chip->list);
>  
>  	chip->gc.direction_input = pl061_direction_input;
>  	chip->gc.direction_output = pl061_direction_output;
> @@ -300,18 +283,7 @@ static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
>  		goto iounmap;
>  	}
>  	irq_set_chained_handler(irq, pl061_irq_handler);
> -	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
> -		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
> -		if (chip_list == NULL) {
> -			clear_bit(irq, init_irq);
> -			ret = -ENOMEM;
> -			goto iounmap;
> -		}
> -		INIT_LIST_HEAD(chip_list);
> -		irq_set_handler_data(irq, chip_list);
> -	} else
> -		chip_list = irq_get_handler_data(irq);
> -	list_add(&chip->list, chip_list);
> +	irq_set_handler_data(irq, chip);
>  
>  	for (i = 0; i < PL061_GPIO_NR; i++) {
>  		if (pdata) {
> -- 
> 1.7.5.4
> 

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

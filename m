Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1F3CH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 22:07:28 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:25904 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757887Ab1F3CHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 22:07:21 -0400
Message-ID: <4E0BDA54.2080007@dsn.okisemi.com>
Date: Thu, 30 Jun 2011 11:07:16 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v3] pch_gpio: Support interrupt function
References: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com>
In-Reply-To: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

If you don't have any concern, would you accept this patch ?

Thanks,

(2011/06/21 13:44), Tomoya MORINAGA wrote:
> Support interrupt function using irq_chip_generic
> 
> Signed-off-by: Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>
> ---
>   drivers/gpio/Kconfig    |    1 +
>   drivers/gpio/pch_gpio.c |  173 +++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 174 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 2967002..bd64a55 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -352,6 +352,7 @@ config GPIO_LANGWELL
>   config GPIO_PCH
>   	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
>   	depends on PCI&&  X86
> +	select GENERIC_IRQ_CHIP
>   	help
>   	  This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
>   	  which is an IOH(Input/Output Hub) for x86 embedded processor.
> diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
> index 36919e7..c7fd65d 100644
> --- a/drivers/gpio/pch_gpio.c
> +++ b/drivers/gpio/pch_gpio.c
> @@ -17,10 +17,21 @@
>   #include<linux/kernel.h>
>   #include<linux/pci.h>
>   #include<linux/gpio.h>
> +#include<linux/interrupt.h>
> +#include<linux/irq.h>
> 
>   #define PCH_GPIO_ALL_PINS	0xfff /* Mask for GPIO pins 0 to 11 */
>   #define GPIO_NUM_PINS	12	/* Specifies number of GPIO PINS GPIO0-GPIO11 */
> 
> +#define PCH_EDGE_FALLING	0
> +#define PCH_EDGE_RISING		BIT(0)
> +#define PCH_LEVEL_L		BIT(1)
> +#define PCH_LEVEL_H		(BIT(0) | BIT(1))
> +#define PCH_EDGE_BOTH		BIT(2)
> +#define PCH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))
> +
> +#define PCH_IRQ_BASE		23
> +
>   struct pch_regs {
>   	u32	ien;
>   	u32	istatus;
> @@ -55,6 +66,10 @@ struct pch_gpio_reg_data {
>    * @gpio:			Data for GPIO infrastructure.
>    * @pch_gpio_reg:		Memory mapped Register data is saved here
>    *				when suspend.
> + * @lock:			mutex_lock variable
> + * @irq_base:		Save base of IRQ number for interrupt
> + * @spinlock:		spin_lock variable
> + * @irq_mask:		IRQ mask variable
>    */
>   struct pch_gpio {
>   	void __iomem *base;
> @@ -63,6 +78,9 @@ struct pch_gpio {
>   	struct gpio_chip gpio;
>   	struct pch_gpio_reg_data pch_gpio_reg;
>   	struct mutex lock;
> +	int irq_base;
> +	spinlock_t spinlock;
> +	unsigned int irq_mask;
>   };
> 
>   static void pch_gpio_set(struct gpio_chip *gpio, unsigned nr, int val)
> @@ -146,6 +164,12 @@ static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
>   	iowrite32(chip->pch_gpio_reg.pm_reg,&chip->reg->pm);
>   }
> 
> +static int pch_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
> +{
> +	struct pch_gpio *chip =	container_of(gpio, struct pch_gpio, gpio);
> +	return chip->irq_base + offset;
> +}
> +
>   static void pch_gpio_setup(struct pch_gpio *chip)
>   {
>   	struct gpio_chip *gpio =&chip->gpio;
> @@ -160,6 +184,124 @@ static void pch_gpio_setup(struct pch_gpio *chip)
>   	gpio->base = -1;
>   	gpio->ngpio = GPIO_NUM_PINS;
>   	gpio->can_sleep = 0;
> +	gpio->to_irq = pch_gpio_to_irq;
> +}
> +
> +static int pch_irq_type(struct irq_data *d, unsigned int type)
> +{
> +	u32 im;
> +	u32 *im_reg;
> +	u32 ien;
> +	u32 im_pos;
> +	int ch;
> +	unsigned long flags;
> +	u32 val;
> +	int irq = d->irq;
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct pch_gpio *chip = gc->private;
> +
> +	ch = irq - chip->irq_base;
> +	if (irq<= chip->irq_base + 7) {
> +		im_reg =&chip->reg->im0;
> +		im_pos = ch;
> +	} else {
> +		im_reg =&chip->reg->im1;
> +		im_pos = ch - 8;
> +	}
> +	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d\n",
> +		__func__, irq, type, ch, im_pos);
> +
> +	spin_lock_irqsave(&chip->spinlock, flags);
> +
> +	if (type == IRQ_TYPE_EDGE_RISING)
> +		val = PCH_EDGE_RISING;
> +	else if (type == IRQ_TYPE_EDGE_FALLING)
> +		val = PCH_EDGE_FALLING;
> +	else if (type == IRQ_TYPE_EDGE_BOTH)
> +		val = PCH_EDGE_BOTH;
> +	else if (type == IRQ_TYPE_LEVEL_HIGH)
> +		val = PCH_LEVEL_L;
> +	else if (type == IRQ_TYPE_LEVEL_LOW)
> +		val = PCH_LEVEL_H;
> +	else if (type == IRQ_TYPE_PROBE)
> +		goto end;
> +	else {
> +		dev_warn(chip->dev, "%s: unknown type(%dd)", __func__, type);
> +		goto end;
> +	}
> +
> +	/* Set interrupt mode */
> +	im = ioread32(im_reg)&  ~(PCH_IM_MASK<<  (im_pos * 4));
> +	iowrite32(im | (val<<  (im_pos * 4)), im_reg);
> +
> +	/* iclr */
> +	iowrite32(BIT(ch),&chip->reg->iclr);
> +
> +	/* IMASKCLR */
> +	iowrite32(BIT(ch),&chip->reg->imaskclr);
> +
> +	/* Enable interrupt */
> +	ien = ioread32(&chip->reg->ien);
> +	iowrite32(ien | BIT(ch),&chip->reg->ien);
> +end:
> +	spin_unlock_irqrestore(&chip->spinlock, flags);
> +
> +	return 0;
> +}
> +
> +static void pch_irq_unmask(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct pch_gpio *chip = gc->private;
> +
> +	chip->irq_mask |= 1<<  (d->irq - chip->irq_base);
> +}
> +
> +static void pch_irq_mask(struct irq_data *d)
> +{
> +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> +	struct pch_gpio *chip = gc->private;
> +
> +	chip->irq_mask&= ~(1<<  (d->irq - chip->irq_base));
> +}
> +
> +static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
> +{
> +	struct pch_gpio *chip = dev_id;
> +	u32 reg_val = ioread32(&chip->reg->istatus);
> +	int i;
> +	int ret = IRQ_NONE;
> +
> +	for (i = 0; i<  GPIO_NUM_PINS; i++) {
> +		if (reg_val&  BIT(i)&  chip->irq_mask) {
> +			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
> +				__func__, i, irq, reg_val);
> +			iowrite32(BIT(i),&chip->reg->iclr);
> +			generic_handle_irq(chip->irq_base + i);
> +			ret = IRQ_HANDLED;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static __devinit void
> +pch_gpio_alloc_generic_chip(struct pch_gpio *chip, unsigned int irq_start,
> +			    unsigned int num)
> +{
> +	struct irq_chip_generic *gc;
> +	struct irq_chip_type *ct;
> +
> +	gc = irq_alloc_generic_chip("pch_gpio", 1, irq_start, chip->base,
> +				    handle_simple_irq);
> +	gc->private = chip;
> +	ct = gc->chip_types;
> +
> +	ct->chip.irq_mask = pch_irq_mask;
> +	ct->chip.irq_unmask = pch_irq_unmask;
> +	ct->chip.irq_set_type = pch_irq_type;
> +
> +	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
> +			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
>   }
> 
>   static int __devinit pch_gpio_probe(struct pci_dev *pdev,
> @@ -167,6 +309,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>   {
>   	s32 ret;
>   	struct pch_gpio *chip;
> +	int irq_base;
> 
>   	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>   	if (chip == NULL)
> @@ -202,8 +345,36 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>   		goto err_gpiochip_add;
>   	}
> 
> +	irq_base = irq_alloc_descs(-1, PCH_IRQ_BASE, GPIO_NUM_PINS, GFP_KERNEL);
> +	if (irq_base<  0) {
> +		dev_err(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
> +		goto err_irq_alloc_descs;
> +	}
> +	chip->irq_base = irq_base;
> +
> +	ret = request_irq(pdev->irq, pch_gpio_handler,
> +			     IRQF_SHARED, KBUILD_MODNAME, chip);
> +	if (ret != 0) {
> +		dev_err(&pdev->dev,
> +			"%s request_irq failed\n", __func__);
> +		goto err_request_irq;
> +	}
> +
> +	pch_gpio_alloc_generic_chip(chip, irq_base, GPIO_NUM_PINS);
> +
> +	/* Initialize interrupt ien register */
> +	iowrite32(0,&chip->reg->ien);
> +
>   	return 0;
> 
> +err_request_irq:
> +	irq_free_descs(irq_base, GPIO_NUM_PINS);
> +
> +err_irq_alloc_descs:
> +	ret = gpiochip_remove(&chip->gpio);
> +	if (ret)
> +		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
> +
>   err_gpiochip_add:
>   	pci_iounmap(pdev, chip->base);
> 
> @@ -224,6 +395,8 @@ static void __devexit pch_gpio_remove(struct pci_dev *pdev)
>   	int err;
>   	struct pch_gpio *chip = pci_get_drvdata(pdev);
> 
> +	irq_free_descs(chip->irq_base, GPIO_NUM_PINS);
> +
>   	err = gpiochip_remove(&chip->gpio);
>   	if (err)
>   		dev_err(&pdev->dev, "Failed gpiochip_remove\n");


-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.

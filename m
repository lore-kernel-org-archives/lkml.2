Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab1HSLBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:01:33 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8273 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752802Ab1HSLBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:01:31 -0400
Message-ID: <4E4E4286.8010304@dsn.okisemi.com>
Date: Fri, 19 Aug 2011 20:01:26 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 6/6 v5] pch_gpio: Support interrupt function
References: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com> <1311156662-3044-6-git-send-email-tomoya-linux@dsn.okisemi.com> <4E392792.10206@dsn.okisemi.com>
In-Reply-To: <4E392792.10206@dsn.okisemi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

2 weeks later.
Could you review these patch series ?

Thanks,

(2011/08/03 19:48), Tomoya MORINAGA wrote:
> Hi Grant,
> 
> Could you review these patch series ?
> 
> Thanks in advance.
> -- tomoya OKI SEMICONDUCTOR CO., LTD. (2011/07/20 19:11), Tomoya 
> MORINAGA wrote:
>> >  Signed-off-by: Tomoya MORINAGA<tomoya-linux@dsn.okisemi.com>
>> >  ---
>> >     drivers/gpio/Kconfig    |    1 +
>> >     drivers/gpio/pch_gpio.c |  187 +++++++++++++++++++++++++++++++++++++++++++++++
>> >     2 files changed, 188 insertions(+), 0 deletions(-)
>> >  
>> >  diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> >  index 2967002..bd64a55 100644
>> >  --- a/drivers/gpio/Kconfig
>> >  +++ b/drivers/gpio/Kconfig
>> >  @@ -352,6 +352,7 @@ config GPIO_LANGWELL
>> >     config GPIO_PCH
>> >     	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GPIO"
>> >     	depends on PCI&&   X86
>> >  +	select GENERIC_IRQ_CHIP
>> >     	help
>> >     	This driver is for PCH(Platform controller Hub) GPIO of Intel Topcliff
>> >     	which is an IOH(Input/Output Hub) for x86 embedded processor.
>> >  diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
>> >  index 7f773af..46b5209 100644
>> >  --- a/drivers/gpio/pch_gpio.c
>> >  +++ b/drivers/gpio/pch_gpio.c
>> >  @@ -17,6 +17,17 @@
>> >     #include<linux/kernel.h>
>> >     #include<linux/pci.h>
>> >     #include<linux/gpio.h>
>> >  +#include<linux/interrupt.h>
>> >  +#include<linux/irq.h>
>> >  +
>> >  +#define PCH_EDGE_FALLING	0
>> >  +#define PCH_EDGE_RISING		BIT(0)
>> >  +#define PCH_LEVEL_L		BIT(1)
>> >  +#define PCH_LEVEL_H		(BIT(0) | BIT(1))
>> >  +#define PCH_EDGE_BOTH		BIT(2)
>> >  +#define PCH_IM_MASK		(BIT(0) | BIT(1) | BIT(2))
>> >  +
>> >  +#define PCH_IRQ_BASE		24
>> >  
>> >     struct pch_regs {
>> >     	u32	ien;
>> >  @@ -50,6 +61,8 @@ static int gpio_pins[] = {
>> >  
>> >     /**
>> >      * struct pch_gpio_reg_data - The register store data.
>> >  + * @ien_reg:	To store contents of IEN register.
>> >  + * @imask_reg:	To store contents of IMASK register.
>> >      * @po_reg:	To store contents of PO register.
>> >      * @pm_reg:	To store contents of PM register.
>> >      * @im0_reg:	To store contents of IM0 register.
>> >  @@ -58,6 +71,8 @@ static int gpio_pins[] = {
>> >      *		       (Only ML7223 Bus-n)
>> >      */
>> >     struct pch_gpio_reg_data {
>> >  +	u32 ien_reg;
>> >  +	u32 imask_reg;
>> >     	u32 po_reg;
>> >     	u32 pm_reg;
>> >     	u32 im0_reg;
>> >  @@ -73,6 +88,8 @@ struct pch_gpio_reg_data {
>> >      * @gpio:			Data for GPIO infrastructure.
>> >      * @pch_gpio_reg:		Memory mapped Register data is saved here
>> >      *				when suspend.
>> >  + * @lock:			Used for register access protection
>> >  + * @irq_base:		Save base of IRQ number for interrupt
>> >      * @ioh:		IOH ID
>> >      * @spinlock:		Used for register access protection in
>> >      *				interrupt context pch_irq_mask,
>> >  @@ -85,6 +102,7 @@ struct pch_gpio {
>> >     	struct gpio_chip gpio;
>> >     	struct pch_gpio_reg_data pch_gpio_reg;
>> >     	struct mutex lock;
>> >  +	int irq_base;
>> >     	enum pch_type_t ioh;
>> >     	spinlock_t spinlock;
>> >     };
>> >  @@ -155,6 +173,8 @@ static int pch_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
>> >      */
>> >     static void pch_gpio_save_reg_conf(struct pch_gpio *chip)
>> >     {
>> >  +	chip->pch_gpio_reg.ien_reg = ioread32(&chip->reg->ien);
>> >  +	chip->pch_gpio_reg.imask_reg = ioread32(&chip->reg->imask);
>> >     	chip->pch_gpio_reg.po_reg = ioread32(&chip->reg->po);
>> >     	chip->pch_gpio_reg.pm_reg = ioread32(&chip->reg->pm);
>> >     	chip->pch_gpio_reg.im0_reg = ioread32(&chip->reg->im0);
>> >  @@ -170,6 +190,8 @@ static void pch_gpio_save_reg_conf(struct pch_gpio *chip)
>> >      */
>> >     static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
>> >     {
>> >  +	iowrite32(chip->pch_gpio_reg.ien_reg,&chip->reg->ien);
>> >  +	iowrite32(chip->pch_gpio_reg.imask_reg,&chip->reg->imask);
>> >     	/* to store contents of PO register */
>> >     	iowrite32(chip->pch_gpio_reg.po_reg,&chip->reg->po);
>> >     	/* to store contents of PM register */
>> >  @@ -182,6 +204,12 @@ static void pch_gpio_restore_reg_conf(struct pch_gpio *chip)
>> >     			&chip->reg->gpio_use_sel);
>> >     }
>> >  
>> >  +static int pch_gpio_to_irq(struct gpio_chip *gpio, unsigned offset)
>> >  +{
>> >  +	struct pch_gpio *chip = container_of(gpio, struct pch_gpio, gpio);
>> >  +	return chip->irq_base + offset;
>> >  +}
>> >  +
>> >     static void pch_gpio_setup(struct pch_gpio *chip)
>> >     {
>> >     	struct gpio_chip *gpio =&chip->gpio;
>> >  @@ -196,6 +224,130 @@ static void pch_gpio_setup(struct pch_gpio *chip)
>> >     	gpio->base = -1;
>> >     	gpio->ngpio = gpio_pins[chip->ioh];
>> >     	gpio->can_sleep = 0;
>> >  +	gpio->to_irq = pch_gpio_to_irq;
>> >  +}
>> >  +
>> >  +static int pch_irq_type(struct irq_data *d, unsigned int type)
>> >  +{
>> >  +	u32 im;
>> >  +	u32 *im_reg;
>> >  +	u32 ien;
>> >  +	u32 im_pos;
>> >  +	int ch;
>> >  +	unsigned long flags;
>> >  +	u32 val;
>> >  +	int irq = d->irq;
>> >  +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
>> >  +	struct pch_gpio *chip = gc->private;
>> >  +
>> >  +	ch = irq - chip->irq_base;
>> >  +	if (irq<= chip->irq_base + 7) {
>> >  +		im_reg =&chip->reg->im0;
>> >  +		im_pos = ch;
>> >  +	} else {
>> >  +		im_reg =&chip->reg->im1;
>> >  +		im_pos = ch - 8;
>> >  +	}
>> >  +	dev_dbg(chip->dev, "%s:irq=%d type=%d ch=%d pos=%d\n",
>> >  +		__func__, irq, type, ch, im_pos);
>> >  +
>> >  +	spin_lock_irqsave(&chip->spinlock, flags);
>> >  +
>> >  +	switch (type) {
>> >  +	case IRQ_TYPE_EDGE_RISING:
>> >  +		val = PCH_EDGE_RISING;
>> >  +		break;
>> >  +	case IRQ_TYPE_EDGE_FALLING:
>> >  +		val = PCH_EDGE_FALLING;
>> >  +		break;
>> >  +	case IRQ_TYPE_EDGE_BOTH:
>> >  +		val = PCH_EDGE_BOTH;
>> >  +		break;
>> >  +	case IRQ_TYPE_LEVEL_HIGH:
>> >  +		val = PCH_LEVEL_H;
>> >  +		break;
>> >  +	case IRQ_TYPE_LEVEL_LOW:
>> >  +		val = PCH_LEVEL_L;
>> >  +		break;
>> >  +	case IRQ_TYPE_PROBE:
>> >  +		goto end;
>> >  +	default:
>> >  +		dev_warn(chip->dev, "%s: unknown type(%dd)",
>> >  +			__func__, type);
>> >  +		goto end;
>> >  +	}
>> >  +
>> >  +	/* Set interrupt mode */
>> >  +	im = ioread32(im_reg)&   ~(PCH_IM_MASK<<   (im_pos * 4));
>> >  +	iowrite32(im | (val<<   (im_pos * 4)), im_reg);
>> >  +
>> >  +	/* iclr */
>> >  +	iowrite32(BIT(ch),&chip->reg->iclr);
>> >  +
>> >  +	/* IMASKCLR */
>> >  +	iowrite32(BIT(ch),&chip->reg->imaskclr);
>> >  +
>> >  +	/* Enable interrupt */
>> >  +	ien = ioread32(&chip->reg->ien);
>> >  +	iowrite32(ien | BIT(ch),&chip->reg->ien);
>> >  +end:
>> >  +	spin_unlock_irqrestore(&chip->spinlock, flags);
>> >  +
>> >  +	return 0;
>> >  +}
>> >  +
>> >  +static void pch_irq_unmask(struct irq_data *d)
>> >  +{
>> >  +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
>> >  +	struct pch_gpio *chip = gc->private;
>> >  +
>> >  +	iowrite32(1<<   (d->irq - chip->irq_base),&chip->reg->imaskclr);
>> >  +}
>> >  +
>> >  +static void pch_irq_mask(struct irq_data *d)
>> >  +{
>> >  +	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
>> >  +	struct pch_gpio *chip = gc->private;
>> >  +
>> >  +	iowrite32(1<<   (d->irq - chip->irq_base),&chip->reg->imask);
>> >  +}
>> >  +
>> >  +static irqreturn_t pch_gpio_handler(int irq, void *dev_id)
>> >  +{
>> >  +	struct pch_gpio *chip = dev_id;
>> >  +	u32 reg_val = ioread32(&chip->reg->istatus);
>> >  +	int i;
>> >  +	int ret = IRQ_NONE;
>> >  +
>> >  +	for (i = 0; i<   gpio_pins[chip->ioh]; i++) {
>> >  +		if (reg_val&   BIT(i)) {
>> >  +			dev_dbg(chip->dev, "%s:[%d]:irq=%d  status=0x%x\n",
>> >  +				__func__, i, irq, reg_val);
>> >  +			iowrite32(BIT(i),&chip->reg->iclr);
>> >  +			generic_handle_irq(chip->irq_base + i);
>> >  +			ret = IRQ_HANDLED;
>> >  +		}
>> >  +	}
>> >  +	return ret;
>> >  +}
>> >  +
>> >  +static __devinit void pch_gpio_alloc_generic_chip(struct pch_gpio *chip,
>> >  +				unsigned int irq_start, unsigned int num)
>> >  +{
>> >  +	struct irq_chip_generic *gc;
>> >  +	struct irq_chip_type *ct;
>> >  +
>> >  +	gc = irq_alloc_generic_chip("pch_gpio", 1, irq_start, chip->base,
>> >  +				    handle_simple_irq);
>> >  +	gc->private = chip;
>> >  +	ct = gc->chip_types;
>> >  +
>> >  +	ct->chip.irq_mask = pch_irq_mask;
>> >  +	ct->chip.irq_unmask = pch_irq_unmask;
>> >  +	ct->chip.irq_set_type = pch_irq_type;
>> >  +
>> >  +	irq_setup_generic_chip(gc, IRQ_MSK(num), IRQ_GC_INIT_MASK_CACHE,
>> >  +			       IRQ_NOREQUEST | IRQ_NOPROBE, 0);
>> >     }
>> >  
>> >     static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>> >  @@ -203,6 +355,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>> >     {
>> >     	s32 ret;
>> >     	struct pch_gpio *chip;
>> >  +	int irq_base;
>> >  
>> >     	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>> >     	if (chip == NULL)
>> >  @@ -245,8 +398,36 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
>> >     		goto err_gpiochip_add;
>> >     	}
>> >  
>> >  +	irq_base = irq_alloc_descs(-1, 0, gpio_pins[chip->ioh], GFP_KERNEL);
>> >  +	if (irq_base<   0) {
>> >  +		dev_warn(&pdev->dev, "PCH gpio: Failed to get IRQ base num\n");
>> >  +		chip->irq_base = -1;
>> >  +		goto end;
>> >  +	}
>> >  +	chip->irq_base = irq_base;
>> >  +
>> >  +	ret = request_irq(pdev->irq, pch_gpio_handler,
>> >  +			     IRQF_SHARED, KBUILD_MODNAME, chip);
>> >  +	if (ret != 0) {
>> >  +		dev_err(&pdev->dev,
>> >  +			"%s request_irq failed\n", __func__);
>> >  +		goto err_request_irq;
>> >  +	}
>> >  +
>> >  +	pch_gpio_alloc_generic_chip(chip, irq_base, gpio_pins[chip->ioh]);
>> >  +
>> >  +	/* Initialize interrupt ien register */
>> >  +	iowrite32(0,&chip->reg->ien);
>> >  +end:
>> >     	return 0;
>> >  
>> >  +err_request_irq:
>> >  +	irq_free_descs(irq_base, gpio_pins[chip->ioh]);
>> >  +
>> >  +	ret = gpiochip_remove(&chip->gpio);
>> >  +	if (ret)
>> >  +		dev_err(&pdev->dev, "%s gpiochip_remove failed\n", __func__);
>> >  +
>> >     err_gpiochip_add:
>> >     	pci_iounmap(pdev, chip->base);
>> >  
>> >  @@ -267,6 +448,12 @@ static void __devexit pch_gpio_remove(struct pci_dev *pdev)
>> >     	int err;
>> >     	struct pch_gpio *chip = pci_get_drvdata(pdev);
>> >  
>> >  +	if (chip->irq_base != -1) {
>> >  +		free_irq(pdev->irq, chip);
>> >  +
>> >  +		irq_free_descs(chip->irq_base, gpio_pins[chip->ioh]);
>> >  +	}
>> >  +
>> >     	err = gpiochip_remove(&chip->gpio);
>> >     	if (err)
>> >     		dev_err(&pdev->dev, "Failed gpiochip_remove\n");


-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.

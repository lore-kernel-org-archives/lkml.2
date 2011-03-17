Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab1CQKAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:00:22 -0400
Received: from www.tglx.de ([62.245.132.106]:51868 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab1CQKAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:00:17 -0400
Date: Thu, 17 Mar 2011 10:59:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: davidb@codeaurora.org, dwalker@fifo99.com,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PM8921 MFD V3 2/6] mfd: pm8xxx: Add irq support
In-Reply-To: <1300328641-3855-3-git-send-email-adharmap@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1103171004460.2787@localhost6.localdomain6>
References: <1300328641-3855-1-git-send-email-adharmap@codeaurora.org> <1300328641-3855-3-git-send-email-adharmap@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, adharmap@codeaurora.org wrote:
> +static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct pm_irq_chip *chip = get_irq_data(irq);
> +	struct irq_chip *irq_chip = get_irq_chip(irq);

Sigh. You have a reference to irq_desc, so why want you to get the
data with a sparse lookup ?

     chip = irq_desc_get_handler_data(desc);
     irq_chip = irq_desc_get_chip(desc);

> +	u8	root;
> +	int	i, ret, masters = 0;
> +
> +	ret = pm8xxx_read_root_irq(chip, &root);
> +	if (ret) {
> +		pr_err("Can't read root status ret=%d\n", ret);
> +		return;
> +	}
> +
> +	/* on pm8xxx series masters start from bit 1 of the root */
> +	masters = root >> 1;
> +
> +	/* Read allowed masters for blocks. */
> +	for (i = 0; i < chip->num_masters; i++)
> +		if (masters & (1 << i))
> +			pm8xxx_irq_master_handler(chip, i);
> +
> +	irq_chip->irq_ack(&desc->irq_data);
> +}
> +
> +static void pm8xxx_irq_ack(struct irq_data *d)
> +{
> +	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = d->irq - chip->irq_base;
> +	u8	block, config;
> +
> +	block = pmirq / 8;
> +
> +	config = chip->config[pmirq] | PM_IRQF_CLR;
> +	/* Keep the mask */
> +	if (!(chip->irqs_allowed[block] & (1 << (pmirq % 8))))
> +		config |= PM_IRQF_MASK_ALL;

Why do you insist to keep that state thing around? Implement a
mask_ack() callback and get rid of it.

> +	pm8xxx_config_irq(chip, block, config);
> +}
> +
> +static int pm8xxx_irq_set_wake(struct irq_data *d, unsigned int on)
> +{
> +	struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = d->irq - chip->irq_base;
> +
> +	if (on) {
> +		set_bit(pmirq, chip->wake_enable);
> +		chip->count_wakeable++;
> +	} else {
> +		clear_bit(pmirq, chip->wake_enable);
> +		chip->count_wakeable--;
> +	}

This bitfield and the count are completely useless. Get rid of it.

> +	return 0;
> +}
> +
> +static struct irq_chip pm8xxx_irq_chip = {
> +	.name		= "pm8xxx",
> +	.irq_ack	= pm8xxx_irq_ack,
> +	.irq_mask	= pm8xxx_irq_mask,
> +	.irq_unmask	= pm8xxx_irq_unmask,
> +	.irq_set_type	= pm8xxx_irq_set_type,
> +	.irq_set_wake	= pm8xxx_irq_set_wake,
> +	.flags		= IRQCHIP_MASK_ON_SUSPEND,
> +};
> +
> +/**
> + * pm8xxx_get_irq_stat - get the status of the irq line
> + * @dev: the interrupt device

Please run this through the doc generator. dev is not an argument to
this function.

> + * @irq: the irq number
> + *
> + * The pm8xxx gpio and mpp rely on the interrupt block to read
> + * the values on their pins. This function is to facilitate reading
> + * the status of a gpio or an mpp line. The caller has to convert the
> + * gpio number to irq number.
> + *
> + * RETURNS:
> + * an int indicating the value read on that line
> + */
> +int pm8xxx_get_irq_stat(void *data, int irq)

Why is this void * ?

> +void * __devinit pm8xxx_irq_init(struct device *dev,
> +				const struct pm8xxx_irq_platform_data *pdata)

Please return struct pm_irq_chip *

You don't have to make the struct definition public. All you need in
the shared header file is a forward declaration.

struct pm_irq_chip;

The you can operate with type safe pointers at the callsites, but you
cannot dereference them there.

> +{
> +	struct pm_irq_chip  *chip;
> +	int devirq, rc;
> +	unsigned int pmirq;
> +
> +	if (!pdata) {
> +		pr_err("No platform data\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	devirq = pdata->devirq;
> +	if (devirq < 0) {
> +		pr_err("missing devirq\n");
> +		rc = devirq;
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	chip = kzalloc(sizeof(struct pm_irq_chip), GFP_KERNEL);
> +	if (!chip) {
> +		pr_err("Cannot alloc pm_irq_chip struct\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	chip->dev = dev;
> +	chip->devirq = devirq;
> +	chip->irq_base = pdata->irq_base;
> +	chip->num_irqs = pdata->irq_cdata.nirqs;
> +	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
> +	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
> +	spin_lock_init(&chip->pm_irq_lock);
> +
> +	chip->irqs_allowed = kzalloc(sizeof(u8) * chip->num_blocks, GFP_KERNEL);
> +	if (!chip->irqs_allowed) {
> +		pr_err("Cannot alloc irqs_allowed array\n");
> +		rc = -ENOMEM;
> +		goto free_all;
> +	}
> +
> +	chip->config = kzalloc(sizeof(u8) * chip->num_irqs, GFP_KERNEL);
> +	if (!chip->config) {
> +		pr_err("Cannot alloc config array\n");
> +		rc = -ENOMEM;
> +		goto free_all;
> +	}
> +	chip->wake_enable = kzalloc(sizeof(unsigned long)
> +			* DIV_ROUND_UP(chip->num_irqs, BITS_PER_LONG),
> +			GFP_KERNEL);
> +	if (!chip->wake_enable) {
> +		pr_err("Cannot alloc wake_enable array\n");
> +		rc = -ENOMEM;
> +		goto free_all;
> +	}

If you got rid of all that state crap, then you can do:

struct pm_irq_chip {
       ...
       ...
       u8       config[0];
};

and allocate the whole thing in one go.

    chip = kzalloc(sizeof(struct pm_irq_chip) + sizeof(u8) * num_irqs, GFP_KERNEL);


>  
> +static inline int pm8xxx_read_irq_stat(const struct device *dev, int irq)
> +{
> +	struct pm8xxx_drvdata *dd = dev_get_drvdata(dev);
> +
> +	BUG_ON(!dd);

No need for BUG_ON(). You can handle that gracefully with a proper
return code.

> +	return dd->pmic_read_irq_stat(dev, irq);
> +}

Thanks,

	tglx

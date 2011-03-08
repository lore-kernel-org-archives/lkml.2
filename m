Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab1CHMFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 07:05:55 -0500
Received: from www.tglx.de ([62.245.132.106]:41685 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193Ab1CHMFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 07:05:53 -0500
Date: Tue, 8 Mar 2011 13:04:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
In-Reply-To: <1299564590-30116-3-git-send-email-adharmap@codeaurora.org>
Message-ID: <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011, adharmap@codeaurora.org wrote:
> +static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
> +					   *pdata,
> +					   struct pm8921 *pmic,
> +					   u32 rev)
> +{
> +	int ret = 0;
> +	int irq_base = 0;
> +	void *irq_data;
> +
> +	if (pdata->irq_pdata) {

So if pdata->irq_pdata == NULL you return success. Is that correct ?
Also please return early on (!pdata->irq_pdata) and avoid that extra
indent level for the real code path.

> +		pdata->irq_pdata->irq_cdata.nirqs = PM8921_NR_IRQS;
> +		pdata->irq_pdata->irq_cdata.rev = rev;
> +		irq_base = pdata->irq_pdata->irq_base;
> +		irq_data = pm8xxx_irq_init(pmic->dev, pdata->irq_pdata);
> +
> +		if (IS_ERR(irq_data)) {
> +			pr_err("Failed to init interrupts ret=%ld\n",
> +					PTR_ERR(irq_data));
> +			ret = PTR_ERR(irq_data);
> +			goto bail;

  			return PTR_ERR(irq_data);

And then you have
    	        }
		pmic->irq_data = irq_data;
		return 0;

> +		} else
> +			pmic->irq_data = irq_data;
> +	}
> +
> +bail:
> +	return ret;
> +}

> +struct pm_irq_chip {
> +	struct list_head	link;
> +	struct device		*dev;
> +	spinlock_t		pm_irq_lock;
> +	u8			*irqs_allowed;
> +	u16			*irqs_to_handle;
> +	u8			*config;
> +	unsigned long		*wake_enable;
> +	unsigned int		devirq;
> +	unsigned int		count_wakeable;
> +	unsigned int		irq_base;
> +	unsigned int		num_irqs;
> +	unsigned int		num_blocks;
> +	unsigned int		num_masters;
> +};
> +
> +static LIST_HEAD(pm_irq_chips);
> +
> +/* Helper Functions */
> +static DEFINE_RATELIMIT_STATE(pm8xxx_irq_ratelimit, 60 * HZ, 10);
> +
> +static inline int pm8xxx_can_print(void)
> +{
> +	return __ratelimit(&pm8xxx_irq_ratelimit);
> +}
> +
> +static int
> +pm8xxx_read_root_irq(const struct pm_irq_chip *chip, u8 *rp)
> +{
> +	return pm8xxx_readb(chip->dev, SSBI_REG_ADDR_IRQ_ROOT, rp);
> +}
> +
> +static int
> +pm8xxx_read_master_irq(const struct pm_irq_chip *chip, u8 m, u8 *bp)
> +{
> +	return pm8xxx_readb(chip->dev,
> +			SSBI_REG_ADDR_IRQ_M_STATUS1 + m, bp);
> +}
> +
> +static int
> +pm8xxx_read_block_irq(const struct pm_irq_chip *chip, u8 bp, u8 *ip)
> +{
> +	int	rc;
> +
> +	rc = pm8xxx_writeb(chip->dev,
> +				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
> +	if (rc) {
> +		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
> +		goto bail_out;

These goto's are silly. return rc; is fine here.

> +	}
> +
> +	rc = pm8xxx_readb(chip->dev,
> +			SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
> +	if (rc)
> +		pr_err("Failed Reading Status rc=%d\n", rc);
> +bail_out:
> +	return rc;
> +}
> +
> +static int
> +pm8xxx_config_irq(const struct pm_irq_chip *chip, u8 bp, u8 cp)
> +{
> +	int	rc;
> +
> +	rc = pm8xxx_writeb(chip->dev,
> +				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);

And how are the callers of this function serialized against the other
functions which access SSBI_REG_ADDR_IRQ_BLK_SEL ?

> +	if (rc) {
> +		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
> +		goto bail_out;
> +	}
> +
> +	rc = pm8xxx_writeb(chip->dev,
> +				SSBI_REG_ADDR_IRQ_CONFIG, cp);
> +	if (rc)
> +		pr_err("Failed Configuring IRQ rc=%d\n", rc);
> +bail_out:
> +	return rc;
> +}
> +
> +static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip,
> +				int block, int *handled)
> +{
> +	int ret = 0;
> +	u8 bits;
> +	int pmirq, irq, k;

Can you please collapse all int variables into one line. Also why are
the iterators in your various functions randomly named i, j, k and
whatever? We usually use i for the first iterator and j when we have a
nested section.

> +	spin_lock(&chip->pm_irq_lock);
> +	ret = pm8xxx_read_block_irq(chip, block, &bits);
> +	if (ret) {
> +		if (pm8xxx_can_print())
> +			pr_err("Failed reading %d block ret=%d",
> +				block, ret);
> +		goto out;
> +	}

You can drop chip->pm_irq_lock here and return if (!bits)

> +	if (!bits) {
> +		if (pm8xxx_can_print())
> +			pr_err("block bit set in master but no irqs: %d",
> +				block);
> +		goto out;
> +	}
> +
> +	/* Check IRQ bits */
> +	for (k = 0; k < 8; k++) {
> +		if (bits & (1 << k)) {
> +			pmirq = block * 8 + k;
> +			irq = pmirq + chip->irq_base;
> +			chip->irqs_to_handle[*handled] = irq;
> +			(*handled)++;

Why all this horrible indirection? Why don't you call
generic_handle_irq() right away?

> +		}
> +	}
> +out:
> +	spin_unlock(&chip->pm_irq_lock);
> +	return ret;
> +}
> +
> +static int pm8xxx_irq_master_handler(struct pm_irq_chip *chip,
> +					int master, int *handled)
> +{
> +	int ret = 0;
> +	u8 blockbits;
> +	int block_number, j;
> +
> +	ret = pm8xxx_read_master_irq(chip, master, &blockbits);
> +	if (ret) {
> +		pr_err("Failed to read master %d ret=%d\n", master, ret);
> +		return ret;
> +	}
> +	if (!blockbits) {
> +		if (pm8xxx_can_print())

What's the point of this ratelimit? This should not happen at all and
if it happens often enough that you need a rate limit then you better
figure out why and fix the real problem instead of papering over it.

> +			pr_err("master bit set in root but no blocks: %d",
> +				master);
> +		return 0;
> +	}
> +
> +	for (j = 0; j < 8; j++)
> +		if (blockbits & (1 << j)) {
> +			block_number = master * 8 + j;	/* block # */
> +			ret |= pm8xxx_irq_block_handler(chip, block_number,
> +								handled);
> +		}
> +	return ret;
> +}
> +
> +static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
> +{
> +	struct pm_irq_chip *chip = get_irq_data(irq);
> +	int	i, ret;
> +	u8	root;
> +	int	masters = 0, handled = 0;
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
> +			pm8xxx_irq_master_handler(chip, i, &handled);
> +
> +	for (i = 0; i < handled; i++)
> +		generic_handle_irq(chip->irqs_to_handle[i]);
> +
> +	desc->chip->ack(irq);

  chip->irq_ack()

> +}
> +
> +static void pm8xxx_irq_ack(struct irq_data *d)
> +{
> +	const struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = d->irq - chip->irq_base;
> +	u8	block, config;
> +
> +	block = pmirq / 8;
> +
> +	config = PM_IRQF_WRITE | chip->config[pmirq] | PM_IRQF_CLR;
> +	/* Keep the mask */
> +	if (!(chip->irqs_allowed[block] & (1 << (pmirq % 8))))
> +		config |= PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;

What's the point of this exercise? ack is called before mask and it
should never be called when the interrupt is masked.

> +	pm8xxx_config_irq(chip, block, config);
> +}
> +
> +static void pm8xxx_irq_mask(struct irq_data *d)
> +{
> +	const struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = d->irq - chip->irq_base;
> +	int	master, irq_bit;
> +	u8	block, config;
> +
> +	block = pmirq / 8;
> +	master = block / 8;
> +	irq_bit = pmirq % 8;
> +
> +	chip->irqs_allowed[block] &= ~(1 << irq_bit);
> +
> +	config = PM_IRQF_WRITE | chip->config[pmirq] |
> +		PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;

Why don't you define PM_IRQF_MASK as PM_IRQF_MASK_FE | PM_IRQF_MASK_RE
and use this instead of having those line breaks.

Also every function which calls pm8xxx_config_irq() ORs
PM_IRQF_WRITE. Why can't you do that in pm8xxx_config_irq() and only
OR the real relevant bits in the various callers ?

> +	pm8xxx_config_irq(chip, block, config);
> +}
> +
> +static void pm8xxx_irq_unmask(struct irq_data *d)
> +{
> +	const struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = d->irq - chip->irq_base;
> +	int	master, irq_bit;
> +	u8	block, config, old_irqs_allowed;
> +
> +	block = pmirq / 8;
> +	master = block / 8;
> +	irq_bit = pmirq % 8;
> +
> +	old_irqs_allowed = chip->irqs_allowed[block];

  ???

> +	chip->irqs_allowed[block] |= 1 << irq_bit;
> +
> +	config = PM_IRQF_WRITE | chip->config[pmirq];
> +	pm8xxx_config_irq(chip, block, config);
> +}
> +
> +static int pm8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
> +{
> +	const struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
> +	unsigned int pmirq = d->irq - chip->irq_base;
> +	int master, irq_bit;
> +	u8 block, config;
> +
> +	block = pmirq / 8;
> +	master = block / 8;
> +	irq_bit  = pmirq % 8;
> +
> +	chip->config[pmirq] = (irq_bit << PM_IRQF_BITS_SHIFT) |
> +			PM_IRQF_MASK_RE | PM_IRQF_MASK_FE;
> +	if (flow_type & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) {
> +		if (flow_type & IRQF_TRIGGER_RISING)
> +			chip->config[pmirq] &= ~PM_IRQF_MASK_RE;
> +		if (flow_type & IRQF_TRIGGER_FALLING)
> +			chip->config[pmirq] &= ~PM_IRQF_MASK_FE;
> +	} else {
> +		chip->config[pmirq] |= PM_IRQF_LVL_SEL;
> +
> +		if (flow_type & IRQF_TRIGGER_HIGH)
> +			chip->config[pmirq] &= ~PM_IRQF_MASK_RE;
> +		else
> +			chip->config[pmirq] &= ~PM_IRQF_MASK_FE;
> +	}
> +
> +	config = PM_IRQF_WRITE
> +		| chip->config[pmirq] | PM_IRQF_CLR;

Grrr. These random line breaks all over the place are horrible.

Also please make that:

     cfg = chip->config[pmirq] | PM_IRQF_WRITE | PM_IRQF_CLR;

So all the bits which you OR to the stored config are together.

> +	return pm8xxx_config_irq(chip, block, config);
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
> +
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
> +};
> +
> +int pm8xxx_get_irq_stat(void *data, int irq)
> +{
> +	struct pm_irq_chip *chip = data;
> +	int pmirq;
> +	int     rc;
> +	u8      block, bits, bit;
> +	unsigned long flags;
> +
> +	if (chip == NULL || irq < chip->irq_base ||
> +			irq >= chip->irq_base + chip->num_irqs)
> +		return -EINVAL;
> +
> +	pmirq = irq - chip->irq_base;
> +
> +	block = pmirq / 8;
> +	bit = pmirq % 8;
> +
> +	spin_lock_irqsave(&chip->pm_irq_lock, flags);
> +
> +	rc = pm8xxx_writeb(chip->dev,
> +				SSBI_REG_ADDR_IRQ_BLK_SEL, block);
> +	if (rc) {
> +		pr_err("Failed Selecting block irq=%d pmirq=%d blk=%d rc=%d\n",
> +			irq, pmirq, block, rc);
> +		goto bail_out;
> +	}
> +
> +	rc = pm8xxx_readb(chip->dev,
> +				SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
> +	if (rc) {
> +		pr_err("Failed Configuring irq=%d pmirq=%d blk=%d rc=%d\n",
> +			irq, pmirq, block, rc);
> +		goto bail_out;
> +	}
> +
> +	rc = (bits & (1 << bit)) ? 1 : 0;
> +
> +bail_out:
> +	spin_unlock_irqrestore(&chip->pm_irq_lock, flags);
> +
> +	return rc;
> +}
> +EXPORT_SYMBOL(pm8xxx_get_irq_stat);

EXPORT_SYMBOL_GPL if at all. Why needs this to be exported?

> +
> +#ifdef CONFIG_PM
> +int pm8xxx_suspend_irq(const void *data)
> +{
> +	const struct pm_irq_chip *chip = data;
> +	int pmirq;
> +
> +	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
> +		if (chip->config[i] && !test_bit(i, chip->wake_enable)) {
> +			if (!((chip->config[i] & PM_IRQF_MASK_ALL)
> +			      == PM_IRQF_MASK_ALL)) {
> +				irq = i + chip->irq_base;
> +				pm8xxx_irq_mask(get_irq_data(irq));
> +			}
> +		}
> +	}
> +
> +	if (!chip->count_wakeable)
> +		disable_irq(chip->dev->irq);
> +
> +	return 0;
> +}
> +
> +void pm8xxx_show_resume_irq(void)
> +{
> +	struct pm_irq_chip *chip;
> +	u8 block, bits;
> +	int pmirq;
> +
> +	list_for_each_entry(chip, &pm_irq_chips, link) {
> +		for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
> +			if (test_bit(pmirq, chip->wake_enable)) {
> +				block = pmirq / 8;
> +				if (!pm8xxx_read_block_irq(chip,
> +							&block, &bits)) {
> +					if (bits & (1 << (pmirq & 0x7)))
> +						pr_warning("%d triggered\n",
> +						pmirq + chip->pdata.irq_base);
> +				}
> +			}
> +		}
> +	}
> +}

What's the point of this function?

> +int pm8xxx_resume_irq(const void *data)
> +{
> +	const struct pm_irq_chip *chip = data;
> +	int pmirq;
> +
> +	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
> +		if (chip->config[i] && !test_bit(i, chip->wake_enable)) {
> +			if (!((chip->config[i] & PM_IRQF_MASK_ALL)
> +			      == PM_IRQF_MASK_ALL)) {
> +				irq = i + chip->irq_base;
> +				pm8xxx_irq_unmask(get_irq_data(irq));
> +			}
> +		}
> +	}
> +
> +	if (!chip->count_wakeable)
> +		enable_irq(chip->dev->irq);
> +
> +	return 0;
> +}
> +#else
> +#define	pm8xxx_suspend		NULL
> +#define	pm8xxx_resume		NULL

Where is pm8xxx_suspend/pm8xxx_resume defined for the !PM case and
where are those used at all ?

> +#endif
> +
> +void * __devinit pm8xxx_irq_init(struct device *dev,
> +				const struct pm8xxx_irq_platform_data *pdata)
> +{
> +	struct pm_irq_chip  *chip;
> +	int devirq;
> +	int rc;
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
> +		goto out;
> +	}
> +
> +	chip = kzalloc(sizeof(struct pm_irq_chip), GFP_KERNEL);
> +	if (!chip) {
> +		pr_err("Cannot alloc pm_irq_chip struct\n");
> +		rc = -ENOMEM;
> +		goto out;
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
> +		goto free_pm_irq_chip;
> +	}
> +
> +	chip->irqs_to_handle = kzalloc(sizeof(u16) * chip->num_irqs,
> +								GFP_KERNEL);
> +	if (!chip->irqs_to_handle) {
> +		pr_err("Cannot alloc irqs_to_handle array\n");
> +		rc = -ENOMEM;
> +		goto free_irqs_allowed;
> +	}
> +	chip->config = kzalloc(sizeof(u8) * chip->num_irqs, GFP_KERNEL);
> +	if (!chip->config) {
> +		pr_err("Cannot alloc config array\n");
> +		rc = -ENOMEM;
> +		goto free_irqs_to_handle;
> +	}
> +	chip->wake_enable = kzalloc(sizeof(unsigned long)
> +			* DIV_ROUND_UP(chip->num_irqs, BITS_PER_LONG),
> +			GFP_KERNEL);
> +	if (!chip->wake_enable) {
> +		pr_err("Cannot alloc wake_enable array\n");
> +		rc = -ENOMEM;
> +		goto free_config;
> +	}
> +	list_add(&chip->link, &pm_irq_chips);

What's that list for and how is it protected ?

> +	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
> +		set_irq_chip(chip->irq_base + pmirq, &pm8xxx_irq_chip);
> +		set_irq_chip_data(chip->irq_base + pmirq, chip);
> +		set_irq_handler(chip->irq_base + pmirq, handle_level_irq);
> +#ifdef CONFIG_ARM
> +		set_irq_flags(chip->irq_base + pmirq, IRQF_VALID);
> +#else
> +		set_irq_noprobe(chip->irq_base + pmirq);
> +#endif
> +	}
> +
> +	set_irq_type(devirq, pdata->irq_trigger_flag);
> +	set_irq_data(devirq, chip);
> +	set_irq_chained_handler(devirq, pm8xxx_irq_handler);
> +	set_irq_wake(devirq, 1);
> +
> +	return chip;
> +
> +free_config:
> +	kfree(chip->config);
> +free_irqs_to_handle:
> +	kfree(chip->irqs_to_handle);
> +free_irqs_allowed:
> +	kfree(chip->irqs_allowed);

No need for 3 separate labels. You kzalloc() chip, so you can call
kfree() on chip->xxx unconditionally.

> +free_pm_irq_chip:
> +	kfree(chip);
> +out:
> +	return ERR_PTR(rc);
> +}

> +#ifdef CONFIG_MFD_PM8XXX_IRQ
> +/**
> + * pm8xxx_get_irq_stat - get the status of the irq line
> + * @dev: the interrupt device
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

Please move that comment into the implementation.

> +int pm8xxx_get_irq_stat(void *data, int irq);

Thanks,

	tglx

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1CIFVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 00:21:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63105 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1CIFVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 00:21:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6279"; a="78844154"
Message-ID: <4D770E47.6050402@codeaurora.org>
Date: Tue, 08 Mar 2011 21:21:11 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
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
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 7 Mar 2011, adharmap@codeaurora.org wrote:
>> +static int __devinit pm8921_add_subdevices(const struct pm8921_platform_data
>> +					   *pdata,
>> +					   struct pm8921 *pmic,
>> +					   u32 rev)
>> +{
>> +	int ret = 0;
>> +	int irq_base = 0;
>> +	void *irq_data;
>> +
>> +	if (pdata->irq_pdata) {
> 
> So if pdata->irq_pdata == NULL you return success. Is that correct ?

Yes. The board configuration may choose not to use pmic interrupts.

> Also please return early on (!pdata->irq_pdata) and avoid that extra
> indent level for the real code path.

I did not do that because there are other subdevices that I will be 
adding in the later patches. I cannot return early. well I will change 
it for this patch.

> 
>> +		pdata->irq_pdata->irq_cdata.nirqs = PM8921_NR_IRQS;
>> +		pdata->irq_pdata->irq_cdata.rev = rev;
>> +		irq_base = pdata->irq_pdata->irq_base;
>> +		irq_data = pm8xxx_irq_init(pmic->dev, pdata->irq_pdata);
>> +
>> +		if (IS_ERR(irq_data)) {
>> +			pr_err("Failed to init interrupts ret=%ld\n",
>> +					PTR_ERR(irq_data));
>> +			ret = PTR_ERR(irq_data);
>> +			goto bail;
> 
>   			return PTR_ERR(irq_data);
> 
> And then you have
>     	        }
> 		pmic->irq_data = irq_data;
> 		return 0;
> 
>> +		} else
>> +			pmic->irq_data = irq_data;
>> +	}
>> +
>> +bail:
>> +	return ret;
>> +}
Ok will do it in the next patchset.
> 
>
>> +static int
>> +pm8xxx_read_block_irq(const struct pm_irq_chip *chip, u8 bp, u8 *ip)
>> +{
>> +	int	rc;
>> +
>> +	rc = pm8xxx_writeb(chip->dev,
>> +				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
>> +	if (rc) {
>> +		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
>> +		goto bail_out;
> 
> These goto's are silly. return rc; is fine here.

Sure, now that I realize SSBI_REG_ADDR_IRQ_BLK_SEL would need 
protection. Will add locking
> 

>> +static int
>> +pm8xxx_config_irq(const struct pm_irq_chip *chip, u8 bp, u8 cp)
>> +{
>> +	int	rc;
>> +
>> +	rc = pm8xxx_writeb(chip->dev,
>> +				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
> 
> And how are the callers of this function serialized against the other
> functions which access SSBI_REG_ADDR_IRQ_BLK_SEL ?

Thanks for pointing this out, will add locks around these.
> 
>> +	if (rc) {
>> +		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
>> +		goto bail_out;
>> +	}
>> +
>> +	rc = pm8xxx_writeb(chip->dev,
>> +				SSBI_REG_ADDR_IRQ_CONFIG, cp);
>> +	if (rc)
>> +		pr_err("Failed Configuring IRQ rc=%d\n", rc);
>> +bail_out:
>> +	return rc;
>> +}
>> +
>> +static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip,
>> +				int block, int *handled)
>> +{
>> +	int ret = 0;
>> +	u8 bits;
>> +	int pmirq, irq, k;
> 
> Can you please collapse all int variables into one line. Also why are
> the iterators in your various functions randomly named i, j, k and
> whatever? We usually use i for the first iterator and j when we have a
> nested section.
Ok will clean this up.

> 
>> +	spin_lock(&chip->pm_irq_lock);
>> +	ret = pm8xxx_read_block_irq(chip, block, &bits);
>> +	if (ret) {
>> +		if (pm8xxx_can_print())
>> +			pr_err("Failed reading %d block ret=%d",
>> +				block, ret);
>> +		goto out;
>> +	}
> 
> You can drop chip->pm_irq_lock here and return if (!bits)
> 
>> +	if (!bits) {
>> +		if (pm8xxx_can_print())
>> +			pr_err("block bit set in master but no irqs: %d",
>> +				block);
>> +		goto out;
>> +	}
>> +
>> +	/* Check IRQ bits */
>> +	for (k = 0; k < 8; k++) {
>> +		if (bits & (1 << k)) {
>> +			pmirq = block * 8 + k;
>> +			irq = pmirq + chip->irq_base;
>> +			chip->irqs_to_handle[*handled] = irq;
>> +			(*handled)++;
> 
> Why all this horrible indirection? Why don't you call
> generic_handle_irq() right away?

Will change it to call generic_handle_irq() right here.
> 
>> +		}
>> +	}
>> +out:
>> +	spin_unlock(&chip->pm_irq_lock);
>> +	return ret;
>> +}
>> +
>> +static int pm8xxx_irq_master_handler(struct pm_irq_chip *chip,
>> +					int master, int *handled)
>> +{
>> +	int ret = 0;
>> +	u8 blockbits;
>> +	int block_number, j;
>> +
>> +	ret = pm8xxx_read_master_irq(chip, master, &blockbits);
>> +	if (ret) {
>> +		pr_err("Failed to read master %d ret=%d\n", master, ret);
>> +		return ret;
>> +	}
>> +	if (!blockbits) {
>> +		if (pm8xxx_can_print())
> 
> What's the point of this ratelimit? This should not happen at all and
> if it happens often enough that you need a rate limit then you better
> figure out why and fix the real problem instead of papering over it.

There is no issue, we had one bringup where we got a lot of spurious 
interrupts and these are remains from the debug code we added in. Will 
clean it up.

> 
>> +			pr_err("master bit set in root but no blocks: %d",
>> +				master);
>> +		return 0;
>> +	}
>> +
>> +	for (j = 0; j < 8; j++)
>> +		if (blockbits & (1 << j)) {
>> +			block_number = master * 8 + j;	/* block # */
>> +			ret |= pm8xxx_irq_block_handler(chip, block_number,
>> +								handled);
>> +		}
>> +	return ret;
>> +}
>> +
>> +static void pm8xxx_irq_handler(unsigned int irq, struct irq_desc *desc)
>> +{
>> +	struct pm_irq_chip *chip = get_irq_data(irq);
>> +	int	i, ret;
>> +	u8	root;
>> +	int	masters = 0, handled = 0;
>> +
>> +	ret = pm8xxx_read_root_irq(chip, &root);
>> +	if (ret) {
>> +		pr_err("Can't read root status ret=%d\n", ret);
>> +		return;
>> +	}
>> +
>> +	/* on pm8xxx series masters start from bit 1 of the root */
>> +	masters = root >> 1;
>> +
>> +	/* Read allowed masters for blocks. */
>> +	for (i = 0; i < chip->num_masters; i++)
>> +		if (masters & (1 << i))
>> +			pm8xxx_irq_master_handler(chip, i, &handled);
>> +
>> +	for (i = 0; i < handled; i++)
>> +		generic_handle_irq(chip->irqs_to_handle[i]);
>> +
>> +	desc->chip->ack(irq);
> 
>   chip->irq_ack()

Yes will do.

> 
>> +}
>> +
>> +static void pm8xxx_irq_ack(struct irq_data *d)
>> +{
>> +	const struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
>> +	unsigned int pmirq = d->irq - chip->irq_base;
>> +	u8	block, config;
>> +
>> +	block = pmirq / 8;
>> +
>> +	config = PM_IRQF_WRITE | chip->config[pmirq] | PM_IRQF_CLR;
>> +	/* Keep the mask */
>> +	if (!(chip->irqs_allowed[block] & (1 << (pmirq % 8))))
>> +		config |= PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;
> 
> What's the point of this exercise? ack is called before mask and it

The register design is such that we cannot only clear the interrupt. One 
has to write to the trigger bits while clearing it. Now trigger bits 
define whether the interrupt is masked or unmasked. If unmasked they 
define whether the interrupt rising/falling/level high/level low triggered.
So the code remembers which interrupts are masked and for them it clears 
and rewrite the masked status in trigger bits. For unmasked ones it 
clears and writes to the trigger bits essentially configuring them same 
way as it was before. That is why the if satement to check interrupt was 
masked earlier, chip->irqs_allowed[] maintains which interrupt are unmasked.

 > ack is called before mask and it
 > should never be called when the interrupt is masked.

I didnt quite understand this comment. handle_level_irq calls mask_ack 
which masks the interrupt and then acks it. In this case the ack is 
called after the mask. Moreover, handle_edge_irq calls only ack and the 
interrupt stays unmasked. I dont see ack is always associated with a 
mask or any ordering is enforced between them. Please clarify.


>> +	config = PM_IRQF_WRITE | chip->config[pmirq] |
>> +		PM_IRQF_MASK_FE | PM_IRQF_MASK_RE;
> 
> Why don't you define PM_IRQF_MASK as PM_IRQF_MASK_FE | PM_IRQF_MASK_RE
> and use this instead of having those line breaks.
Ok will do that.
> 
> Also every function which calls pm8xxx_config_irq() ORs
> PM_IRQF_WRITE. Why can't you do that in pm8xxx_config_irq() and only
> OR the real relevant bits in the various callers ?

Ok will do that.

>> +
>> +	old_irqs_allowed = chip->irqs_allowed[block];
> 
>   ???

will remove, some debug code remnants.
> 
>> +	}
>> +
>> +	config = PM_IRQF_WRITE
>> +		| chip->config[pmirq] | PM_IRQF_CLR;
> 
> Grrr. These random line breaks all over the place are horrible.
> 
> Also please make that:
> 
>      cfg = chip->config[pmirq] | PM_IRQF_WRITE | PM_IRQF_CLR;
> 
> So all the bits which you OR to the stored config are together.

Yes I tend to order them the way they show up in the register 
definitions. Agree it is not readable, will fix it.


>> +int pm8xxx_get_irq_stat(void *data, int irq)
>> +{
>> +	struct pm_irq_chip *chip = data;
>> +	int pmirq;
>> +	int     rc;
>> +	u8      block, bits, bit;
>> +	unsigned long flags;
>> +
>> +	if (chip == NULL || irq < chip->irq_base ||
>> +			irq >= chip->irq_base + chip->num_irqs)
>> +		return -EINVAL;
>> +
>> +	pmirq = irq - chip->irq_base;
>> +
>> +	block = pmirq / 8;
>> +	bit = pmirq % 8;
>> +
>> +	spin_lock_irqsave(&chip->pm_irq_lock, flags);
>> +
>> +	rc = pm8xxx_writeb(chip->dev,
>> +				SSBI_REG_ADDR_IRQ_BLK_SEL, block);
>> +	if (rc) {
>> +		pr_err("Failed Selecting block irq=%d pmirq=%d blk=%d rc=%d\n",
>> +			irq, pmirq, block, rc);
>> +		goto bail_out;
>> +	}
>> +
>> +	rc = pm8xxx_readb(chip->dev,
>> +				SSBI_REG_ADDR_IRQ_RT_STATUS, &bits);
>> +	if (rc) {
>> +		pr_err("Failed Configuring irq=%d pmirq=%d blk=%d rc=%d\n",
>> +			irq, pmirq, block, rc);
>> +		goto bail_out;
>> +	}
>> +
>> +	rc = (bits & (1 << bit)) ? 1 : 0;
>> +
>> +bail_out:
>> +	spin_unlock_irqrestore(&chip->pm_irq_lock, flags);
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL(pm8xxx_get_irq_stat);
> 
> EXPORT_SYMBOL_GPL if at all. Why needs this to be exported?

The core driver calls this to read the status on a gpio/mpp line. The 
core driver can be compiled as a module, hence the export. Will use 
EXPORT_SYMBOL_GPL instead. I realize there are few more functions as 
well that need exporting, will export them in the coming patch.
> 
>> +
>> +
>> +void pm8xxx_show_resume_irq(void)
>> +{
>> +	struct pm_irq_chip *chip;
>> +	u8 block, bits;
>> +	int pmirq;
>> +
>> +	list_for_each_entry(chip, &pm_irq_chips, link) {
>> +		for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
>> +			if (test_bit(pmirq, chip->wake_enable)) {
>> +				block = pmirq / 8;
>> +				if (!pm8xxx_read_block_irq(chip,
>> +							&block, &bits)) {
>> +					if (bits & (1 << (pmirq & 0x7)))
>> +						pr_warning("%d triggered\n",
>> +						pmirq + chip->pdata.irq_base);
>> +				}
>> +			}
>> +		}
>> +	}
>> +}
> 
> What's the point of this function?
This function is used by the power management code right before it 
returns from suspend_ops->enter. It helps in debugging what exact 
interrupts triggered the resume.

> 
>> +int pm8xxx_resume_irq(const void *data)
>> +{
>> +	const struct pm_irq_chip *chip = data;
>> +	int pmirq;
>> +
>> +	for (pmirq = 0; pmirq < chip->num_irqs; pmirq++) {
>> +		if (chip->config[i] && !test_bit(i, chip->wake_enable)) {
>> +			if (!((chip->config[i] & PM_IRQF_MASK_ALL)
>> +			      == PM_IRQF_MASK_ALL)) {
>> +				irq = i + chip->irq_base;
>> +				pm8xxx_irq_unmask(get_irq_data(irq));
>> +			}
>> +		}
>> +	}
>> +
>> +	if (!chip->count_wakeable)
>> +		enable_irq(chip->dev->irq);
>> +
>> +	return 0;
>> +}
>> +#else
>> +#define	pm8xxx_suspend		NULL
>> +#define	pm8xxx_resume		NULL
> 
> Where is pm8xxx_suspend/pm8xxx_resume defined for the !PM case and
> where are those used at all ?

The core driver calls them (these need to be export_symbol_gpled as 
well). I should provide empty implementations rather than NULL 
definitions. Will fix them.
> 
>> +#endif
>> +
>> +void * __devinit pm8xxx_irq_init(struct device *dev,
>> +				const struct pm8xxx_irq_platform_data *pdata)
>> +{
>> +	struct pm_irq_chip  *chip;
>> +	int devirq;
>> +	int rc;
>> +	unsigned int pmirq;
>> +
>> +	if (!pdata) {
>> +		pr_err("No platform data\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	devirq = pdata->devirq;
>> +	if (devirq < 0) {
>> +		pr_err("missing devirq\n");
>> +		rc = devirq;
>> +		goto out;
>> +	}
>> +
>> +	chip = kzalloc(sizeof(struct pm_irq_chip), GFP_KERNEL);
>> +	if (!chip) {
>> +		pr_err("Cannot alloc pm_irq_chip struct\n");
>> +		rc = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	chip->dev = dev;
>> +	chip->devirq = devirq;
>> +	chip->irq_base = pdata->irq_base;
>> +	chip->num_irqs = pdata->irq_cdata.nirqs;
>> +	chip->num_blocks = DIV_ROUND_UP(chip->num_irqs, 8);
>> +	chip->num_masters = DIV_ROUND_UP(chip->num_blocks, 8);
>> +	spin_lock_init(&chip->pm_irq_lock);
>> +
>> +	chip->irqs_allowed = kzalloc(sizeof(u8) * chip->num_blocks, GFP_KERNEL);
>> +	if (!chip->irqs_allowed) {
>> +		pr_err("Cannot alloc irqs_allowed array\n");
>> +		rc = -ENOMEM;
>> +		goto free_pm_irq_chip;
>> +	}
>> +
>> +	chip->irqs_to_handle = kzalloc(sizeof(u16) * chip->num_irqs,
>> +								GFP_KERNEL);
>> +	if (!chip->irqs_to_handle) {
>> +		pr_err("Cannot alloc irqs_to_handle array\n");
>> +		rc = -ENOMEM;
>> +		goto free_irqs_allowed;
>> +	}
>> +	chip->config = kzalloc(sizeof(u8) * chip->num_irqs, GFP_KERNEL);
>> +	if (!chip->config) {
>> +		pr_err("Cannot alloc config array\n");
>> +		rc = -ENOMEM;
>> +		goto free_irqs_to_handle;
>> +	}
>> +	chip->wake_enable = kzalloc(sizeof(unsigned long)
>> +			* DIV_ROUND_UP(chip->num_irqs, BITS_PER_LONG),
>> +			GFP_KERNEL);
>> +	if (!chip->wake_enable) {
>> +		pr_err("Cannot alloc wake_enable array\n");
>> +		rc = -ENOMEM;
>> +		goto free_config;
>> +	}
>> +	list_add(&chip->link, &pm_irq_chips);
> 
> What's that list for and how is it protected ?
The list is used in pm8xxx_show_resume_irq function to go over all he 
chips and see what interrupts have triggered.

I think I will clean up the printing of resume interrupts and will 
submit them as a separate patch along with the power management code. 
This list and pm8xxx_show_resume_irq goes.


>> +
>> +free_config:
>> +	kfree(chip->config);
>> +free_irqs_to_handle:
>> +	kfree(chip->irqs_to_handle);
>> +free_irqs_allowed:
>> +	kfree(chip->irqs_allowed);
> 
> No need for 3 separate labels. You kzalloc() chip, so you can call
> kfree() on chip->xxx unconditionally.

ok, will do.

> 
>> +free_pm_irq_chip:
>> +	kfree(chip);
>> +out:
>> +	return ERR_PTR(rc);
>> +}
> 
>> +#ifdef CONFIG_MFD_PM8XXX_IRQ
>> +/**
>> + * pm8xxx_get_irq_stat - get the status of the irq line
>> + * @dev: the interrupt device
>> + * @irq: the irq number
>> + *
>> + * The pm8xxx gpio and mpp rely on the interrupt block to read
>> + * the values on their pins. This function is to facilitate reading
>> + * the status of a gpio or an mpp line. The caller has to convert the
>> + * gpio number to irq number.
>> + *
>> + * RETURNS:
>> + * an int indicating the value read on that line
>> + */
> 
> Please move that comment into the implementation.

Will do.

> 
>> +int pm8xxx_get_irq_stat(void *data, int irq);
> 
> Thanks,
> 
> 	tglx


-- 
--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.

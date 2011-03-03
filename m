Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab1CCEiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 23:38:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52695 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1CCEiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 23:38:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6273"; a="77501641"
Message-ID: <4D6F1B2B.3090706@codeaurora.org>
Date: Wed, 02 Mar 2011 20:38:03 -0800
From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
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
        Linus Walleij <linux.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD 2/6] mfd: pm8xxx: Add irq support
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org> <1299104001-5240-3-git-send-email-adharmap@codeaurora.org> <20110302224616.GB32325@opensource.wolfsonmicro.com>
In-Reply-To: <20110302224616.GB32325@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Wed, Mar 02, 2011 at 02:13:17PM -0800, adharmap@codeaurora.org wrote:
>> Change-Id: Ibb23878cd382af9a750d62ab49482f5dc72e3714
>> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> 
> Remove the change IDs from upstream submissions.  The kernel doesn't use
> gerritt.
> 
>>  struct pm8921 {
>> -	struct device *dev;
>> +	struct device			*dev;
>> +	struct device			*irq_dev;
> 
> Is it really useful to register a struct device purely for the interrupt
> controller?  I'd have expected this to be core functionality of the
> device.  The fact that you need to store the device at all is a bit odd
> too as you're using the MFD API.

This design is slightly different from other MFD drivers.
I separated the interrupt from the core because the interrupt 
implementation for different Qualcomm pmics remains the same. On 8660 
FFA boards for example, we have two pmic chips that have the same 
interrupt subdevice implementation (the number of interrupts managed by 
each is different). I didn't want to duplicate the exact code in the 
core driver - hence a separate interrupt driver.

To answer why we need to keep a reference to irq_dev. This is so because 
the gpio code needs to make calls on the irq driver to read the input 
values. The gpio code calls pm8xxx_read_irq_stat() on the core and 
expects it to read the value. The core then calls an api in the irq 
driver (pm8xxx_get_irq_stat)passing it irq_dev to get the required values.

I could have made the gpio code call the irq code directly, but then 
that would mean the irq driver has to go over all its devices and find 
which device handles this irq number and then read it. That is too much 
code execution as compared to remember the irq_dev for each core and let 
the gpio code call read apis on it.

> 
>>  static struct pm8xxx_drvdata pm8921_drvdata = {
>> -	.pmic_readb	= pm8921_readb,
>> -	.pmic_writeb	= pm8921_writeb,
>> -	.pmic_read_buf	= pm8921_read_buf,
>> -	.pmic_write_buf = pm8921_write_buf,
>> +	.pmic_readb		= pm8921_readb,
>> +	.pmic_writeb		= pm8921_writeb,
>> +	.pmic_read_buf		= pm8921_read_buf,
>> +	.pmic_write_buf		= pm8921_write_buf,
>> +	.pmic_read_irq_stat	= pm8921_read_irq_stat,
>> +};
> 
> It'd seem better to indent things as per the final driver in the first
> patch - this reindentation creates a lot of noise in the diff.
> 
>>  		goto err_read_rev;
>>  	}
>> -	pr_info("PMIC revision:   %02X\n", val);
>> +	pr_info("PMIC revision 1: %02X\n", val);
>> +	rev = val;

Yes will fix them

>>  
> 
> Again, do this in the first patch.
> 
>> +static int
>> +pm8xxx_read_block(const struct pm_irq_chip *chip, u8 bp, u8 *ip)
>> +{
>> +	int	rc;
>> +
>> +	rc = pm8xxx_writeb(chip->dev->parent,
>> +				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
>> +	if (rc) {
>> +		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
>> +		goto bail_out;
>> +	}
>> +
>> +	rc = pm8xxx_readb(chip->dev->parent,
>> +			SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
>> +	if (rc)
>> +		pr_err("Failed Reading Status rc=%d\n", rc);
>> +bail_out:
>> +	return rc;
>> +}
> 
> The namespacing here is odd, this looks like it should be a generic API
> not a block specific one.

It indicates that the code intends to read a block of interrupt 
statuses. The irq h/w is implemented as follows, there are 256 
interrupts. One block manages 8 interrupts, so there are 32 blocks.
One master manages 8 blocks so there are 4 masters.  And finally there 
is one root that manages all the 4 masters.

When an interrupt triggers, the corresponding bit in the block, master 
and root is set. The handler reads the root and figures out which master 
is set. It then reads the master and figures out which block in that 
master is set. It then reads the block to figure out which interrupt in 
that block is set. This hardware design makes the handler find the 
interrupt super quick as opposed to checking 256 bits when an interrupt 
fires.

With that in mind, the driver has following functions
pm8xxxx_read_root
pm8xxxx_read_master
pm8xxxx_read_block

Do you still think I should change the name?

> 
>> +	/* Check IRQ bits */
>> +	for (k = 0; k < 8; k++) {
>> +		if (bits & (1 << k)) {
>> +			pmirq = block * 8 + k;
>> +			irq = pmirq + chip->irq_base;
>> +			/* Check spurious interrupts */
>> +			if (((1 << k) & chip->irqs_allowed[block])) {
>> +				/* Found one */
>> +				chip->irqs_to_handle[*handled] = irq;
>> +				(*handled)++;
>> +			} else { /* Clear and mask wrong one */
>> +				config = PM_IRQF_W_C_M |
>> +					(k << PM_IRQF_BITS_SHIFT);
>> +
>> +				pm8xxx_config_irq(chip,
>> +						  block, config);
>> +
>> +				if (pm8xxx_can_print())
>> +					pr_err("Spurious IRQ: %d "
>> +					       "[block, bit]="
>> +					       "[%d, %d]\n",
>> +					       irq, block, k);
>> +			}
> 
> The generic IRQ code should be able to take care of spurious interrupts
> for you?  It's a bit surprising that there's all this logic - I'd expect
> an IRQ chip to just defer logic about which interrupts are valid and so
> on to the generic IRQ code.

That is correct, the genirq does handle spurious interrupts gracefully. 
Will fix this in the next patch series.

>> +
>> +#define NR_PM8921_IRQS 256
> 
> Traditionally this'd be namespaced like this:
> 
> +#define PM8921_NR_IRQS 256

ok good to know will change that.

--
Sent by an employee of the Qualcomm Innovation Center, Inc. The Qualcomm 
Innovation Center, Inc. is a member of the Code Aurora Forum.

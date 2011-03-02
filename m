Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab1CBWqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:46:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54923 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755955Ab1CBWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:46:18 -0500
Date: Wed, 2 Mar 2011 22:46:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: adharmap@codeaurora.org
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20110302224616.GB32325@opensource.wolfsonmicro.com>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org>
 <1299104001-5240-3-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299104001-5240-3-git-send-email-adharmap@codeaurora.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 02:13:17PM -0800, adharmap@codeaurora.org wrote:
> 
> Change-Id: Ibb23878cd382af9a750d62ab49482f5dc72e3714
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

Remove the change IDs from upstream submissions.  The kernel doesn't use
gerritt.

>  struct pm8921 {
> -	struct device *dev;
> +	struct device			*dev;
> +	struct device			*irq_dev;

Is it really useful to register a struct device purely for the interrupt
controller?  I'd have expected this to be core functionality of the
device.  The fact that you need to store the device at all is a bit odd
too as you're using the MFD API.

>  static struct pm8xxx_drvdata pm8921_drvdata = {
> -	.pmic_readb	= pm8921_readb,
> -	.pmic_writeb	= pm8921_writeb,
> -	.pmic_read_buf	= pm8921_read_buf,
> -	.pmic_write_buf = pm8921_write_buf,
> +	.pmic_readb		= pm8921_readb,
> +	.pmic_writeb		= pm8921_writeb,
> +	.pmic_read_buf		= pm8921_read_buf,
> +	.pmic_write_buf		= pm8921_write_buf,
> +	.pmic_read_irq_stat	= pm8921_read_irq_stat,
> +};

It'd seem better to indent things as per the final driver in the first
patch - this reindentation creates a lot of noise in the diff.

>  		goto err_read_rev;
>  	}
> -	pr_info("PMIC revision:   %02X\n", val);
> +	pr_info("PMIC revision 1: %02X\n", val);
> +	rev = val;
>  

Again, do this in the first patch.

> +static int
> +pm8xxx_read_block(const struct pm_irq_chip *chip, u8 bp, u8 *ip)
> +{
> +	int	rc;
> +
> +	rc = pm8xxx_writeb(chip->dev->parent,
> +				SSBI_REG_ADDR_IRQ_BLK_SEL, bp);
> +	if (rc) {
> +		pr_err("Failed Selecting Block %d rc=%d\n", bp, rc);
> +		goto bail_out;
> +	}
> +
> +	rc = pm8xxx_readb(chip->dev->parent,
> +			SSBI_REG_ADDR_IRQ_IT_STATUS, ip);
> +	if (rc)
> +		pr_err("Failed Reading Status rc=%d\n", rc);
> +bail_out:
> +	return rc;
> +}

The namespacing here is odd, this looks like it should be a generic API
not a block specific one.

> +	/* Check IRQ bits */
> +	for (k = 0; k < 8; k++) {
> +		if (bits & (1 << k)) {
> +			pmirq = block * 8 + k;
> +			irq = pmirq + chip->irq_base;
> +			/* Check spurious interrupts */
> +			if (((1 << k) & chip->irqs_allowed[block])) {
> +				/* Found one */
> +				chip->irqs_to_handle[*handled] = irq;
> +				(*handled)++;
> +			} else { /* Clear and mask wrong one */
> +				config = PM_IRQF_W_C_M |
> +					(k << PM_IRQF_BITS_SHIFT);
> +
> +				pm8xxx_config_irq(chip,
> +						  block, config);
> +
> +				if (pm8xxx_can_print())
> +					pr_err("Spurious IRQ: %d "
> +					       "[block, bit]="
> +					       "[%d, %d]\n",
> +					       irq, block, k);
> +			}

The generic IRQ code should be able to take care of spurious interrupts
for you?  It's a bit surprising that there's all this logic - I'd expect
an IRQ chip to just defer logic about which interrupts are valid and so
on to the generic IRQ code.

>  #include <linux/device.h>
> +#include <linux/mfd/pm8xxx/irq.h>
> +
> +#define NR_PM8921_IRQS 256

Traditionally this'd be namespaced like this:

+#define PM8921_NR_IRQS 256

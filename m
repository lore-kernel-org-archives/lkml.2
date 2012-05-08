Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2EHRoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:44:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50177 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab2EHRoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:44:38 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] gpio: langwell: convert to use irq_domain
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1335946550-3092-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1335946550-3092-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 08 May 2012 11:44:34 -0600
Message-Id: <20120508174434.80D773E05D0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 May 2012 11:15:50 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> irq_domain already provides a facility to translate from hardware IRQ
> numbers to Linux IRQ numbers so use that instead of open-coding the logic
> in the driver.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks.

BTW, I noticed a bug below (unrelated to this patch)...

> ---
>  static int lnw_irq_type(struct irq_data *d, unsigned type)
>  {
>  	struct lnw_gpio *lnw = irq_data_get_irq_chip_data(d);
> -	u32 gpio = d->irq - lnw->irq_base;
> +	u32 gpio = irqd_to_hwirq(d);
>  	unsigned long flags;
>  	u32 value;
>  	void __iomem *grer = gpio_reg(&lnw->chip, gpio, GRER);
> @@ -256,7 +257,8 @@ static void lnw_irq_handler(unsigned irq, struct irq_desc *desc)
>  			pending &= ~mask;
>  			/* Clear before handling so we can't lose an edge */
>  			writel(mask, gedr);
> -			generic_handle_irq(lnw->irq_base + base + gpio);
> +			generic_handle_irq(irq_find_mapping(lnw->domain,
> +							    base + gpio));
>  		}
>  	}

This while loop is actually buggy.  After handling each pending irq
bit the status register should be re-read.  Otherwise if the same irq
gets raised again after it is handled, then this loop will ignore it.

It's not a major issue, but it would mean unnecessary exiting and
reentering the handler function.

g.


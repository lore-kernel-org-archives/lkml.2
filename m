Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab2K2Jeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:34:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54755 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2K2Jee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:34:34 -0500
Date: Thu, 29 Nov 2012 09:34:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org
Subject: Re: [PATCH V4 Resend 2/3] mfd: stmpe: Remove irq_trigger from
 platform data
Message-ID: <20121129093428.GV2013@gmail.com>
References: <d1f012d7bb2835f696fc100073f2eb16d9f6204d.1354128258.git.viresh.kumar@linaro.org>
 <33d71d9d29a3edd2c4a33e0f187cdb89f344af72.1354128258.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33d71d9d29a3edd2c4a33e0f187cdb89f344af72.1354128258.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012, Viresh Kumar wrote:

> STMPE can confige

            configure?

> the way the device emits interrupts and till now this

                                          until?

> information is passed as part of platform data.
> 
> It would actually be good to ask the interrupt controller driver what kind of
> interrupt signal it expects for a given interrupt line. We can get the irq type
> by calling: irqd_get_trigger_type() routine.
> 
> So, now we don't need to pass it via platform data. This is earlier discussed
> here:
> 
> https://lkml.org/lkml/2012/11/26/711
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> 
> @Linus/Shiraz: Can you please test this patch? You don't really need to test 1/3
> and 3/3, but would be good if you do that too..
> 
> This is actually V1 of this patch.
> 
>  arch/arm/mach-ux500/board-mop500-stuib.c | 1 -
>  drivers/mfd/stmpe.c                      | 7 ++++---
>  include/linux/mfd/stmpe.h                | 2 --
>  3 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-ux500/board-mop500-stuib.c b/arch/arm/mach-ux500/board-mop500-stuib.c
> index 564f57d..0efcf97 100644
> --- a/arch/arm/mach-ux500/board-mop500-stuib.c
> +++ b/arch/arm/mach-ux500/board-mop500-stuib.c
> @@ -57,7 +57,6 @@ static struct stmpe_keypad_platform_data stmpe1601_keypad_data = {
>  static struct stmpe_platform_data stmpe1601_data = {
>  	.id		= 1,
>  	.blocks		= STMPE_BLOCK_KEYPAD,
> -	.irq_trigger    = IRQF_TRIGGER_FALLING,
>  	.irq_base       = MOP500_STMPE1601_IRQ(0),
>  	.keypad		= &stmpe1601_keypad_data,
>  	.autosleep      = true,
> diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
> index 34408b4..10819e6 100644
> --- a/drivers/mfd/stmpe.c
> +++ b/drivers/mfd/stmpe.c
> @@ -914,7 +914,6 @@ static int __devinit stmpe_irq_init(struct stmpe *stmpe,
>  
>  static int __devinit stmpe_chip_init(struct stmpe *stmpe)
>  {
> -	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
>  	int autosleep_timeout = stmpe->pdata->autosleep_timeout;
>  	struct stmpe_variant_info *variant = stmpe->variant;
>  	u8 icr = 0;
> @@ -941,6 +940,9 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
>  		return ret;
>  
>  	if (stmpe->irq >= 0) {
> +		unsigned int irq_trigger =
> +			irqd_get_trigger_type(irq_get_irq_data(stmpe->irq));
> +
>  		if (id == STMPE801_ID)
>  			icr = STMPE801_REG_SYS_CTRL_INT_EN;
>  		else
> @@ -1118,8 +1120,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
>  			return ret;
>  
>  		ret = devm_request_threaded_irq(ci->dev, stmpe->irq, NULL,
> -				stmpe_irq, pdata->irq_trigger | IRQF_ONESHOT,
> -				"stmpe", stmpe);
> +				stmpe_irq, IRQF_ONESHOT, "stmpe", stmpe);

Forgive my ignorance, but you're no longer passing irq_trigger.

Is this intentional? If so, why was it needed before and not now?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

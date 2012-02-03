Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab2BCOsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:48:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50499 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2BCOsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:48:35 -0500
Message-ID: <4F2BF3A9.8030200@ti.com>
Date: Fri, 3 Feb 2012 15:48:09 +0100
From: "Cousson, Benoit" <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        <devicetree-discuss@lists.ozlabs.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 13/25] irq_domain: Remove 'new' irq_domain in favour
 of the ppc one
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <1327700179-17454-14-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327700179-17454-14-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

I finally had the time to rebase most of the OMAP3 and OMAP4 DT patches 
on your latest irq_domain series and found a couple of minors 
regressions that breaks OMAP3 boot.

On 1/27/2012 10:36 PM, Grant Likely wrote:

[...]

> diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
> index e04e04dd..aab236f 100644
> --- a/drivers/mfd/twl-core.c
> +++ b/drivers/mfd/twl-core.c
> @@ -263,8 +263,6 @@ struct twl_client {
>
>   static struct twl_client twl_modules[TWL_NUM_SLAVES];
>
> -static struct irq_domain domain;
> -
>   /* mapping the module id to slave id and base address */
>   struct twl_mapping {
>   	unsigned char sid;	/* Slave ID */
> @@ -1225,14 +1223,8 @@ twl_probe(struct i2c_client *client, const struct i2c_device_id *id)
>
>   	pdata->irq_base = status;
>   	pdata->irq_end = pdata->irq_base + nr_irqs;
> -
> -	domain.irq_base = pdata->irq_base;
> -	domain.nr_irq = nr_irqs;
> -#ifdef CONFIG_OF_IRQ
> -	domain.of_node = of_node_get(node);
> -	domain.ops =&irq_domain_simple_ops;
> -#endif
> -	irq_domain_add(&domain);
> +	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
> +			&irq_domain_simple_ops);

This commit cannot build due to the missing last parameter.

And in fact you fixed that in the next commit (#14), but the will break 
git bisect and anyway that fix does not really belong to this commit.

[PATCH v3 14/25] irq_domain: Remove irq_domain_add_simple()

  	irq_domain_add_legacy(node, nr_irqs, pdata->irq_base, 0,
-			      &irq_domain_simple_ops);
+			      &irq_domain_simple_ops, NULL);


Moreover, it looks like this new irq_domain code is checking the number 
of hwirq and is not as lazy as the previous one :-)

Because of that and because of the wrong number of IRQs I put for the 
twl4030 :-(, it does not handle properly the children of the twl4030 now 
and print a big warning at boot time due to the following check.

   WARN_ON(hwirq < first_hwirq || hwirq >= first_hwirq + size)

In fact 8 was just the number for the core functionality, but that chip 
does have some other interrupts for sub function like GPIOs and power 
events.

With the following fix, it works fine.

Regards,
Benoit


---
 From 12781619d2ab8d6d724acabc6873954f0f9f4347 Mon Sep 17 00:00:00 2001
From: Benoit Cousson <b-cousson@ti.com>
Date: Fri, 3 Feb 2012 14:58:17 +0100
Subject: [PATCH] mfd: twl-core.c: Fix the number of interrupts managed 
by twl4030

TWL4030 does handle 3 different interrupts ranges: 8 for the core, 8 for 
the power events and 18 for the GPIOs.

Change the total number of interrupts managed by TWL4030 from 8 to 34.

Signed-off-by: Benoit Cousson <b-cousson@ti.com>
---
  drivers/mfd/twl-core.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index e63b408..66f9bff 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -149,7 +149,7 @@

  #define TWL_MODULE_LAST TWL4030_MODULE_LAST

-#define TWL4030_NR_IRQS    8
+#define TWL4030_NR_IRQS    34 /* core:8, power:8, gpio: 18 */
  #define TWL6030_NR_IRQS    20

  /* Base Address defns for twl4030_map[] */
-- 
1.7.0.4




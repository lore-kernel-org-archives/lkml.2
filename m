Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab2ESGBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:01:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43204 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab2ESGBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:01:30 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v8 2/4] MIPS: Octeon: Setup irq_domains for interrupts.
To: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
In-Reply-To: <1335487678-26223-3-git-send-email-ddaney.cavm@gmail.com>
References: <1335487678-26223-1-git-send-email-ddaney.cavm@gmail.com> <1335487678-26223-3-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 00:01:26 -0600
Message-Id: <20120519060126.30A443E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 17:47:56 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Create two domains.  One for the GPIO lines, and the other for on-chip
> sources.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

but I've got some comments below that should probably be addressed in
follow up patches.

> ---
>  arch/mips/cavium-octeon/octeon-irq.c |  215 ++++++++++++++++++++++++++++++++--
>  1 files changed, 206 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
> index 89b6f27..fc40d0b 100644
> --- a/arch/mips/cavium-octeon/octeon-irq.c
> +++ b/arch/mips/cavium-octeon/octeon-irq.c
> @@ -3,14 +3,17 @@
>   * License.  See the file "COPYING" in the main directory of this archive
>   * for more details.
>   *
> - * Copyright (C) 2004-2008, 2009, 2010, 2011 Cavium Networks
> + * Copyright (C) 2004-2012 Cavium, Inc.
>   */
>  
>  #include <linux/interrupt.h>
> +#include <linux/irqdomain.h>
>  #include <linux/bitops.h>
>  #include <linux/percpu.h>
> +#include <linux/slab.h>
>  #include <linux/irq.h>
>  #include <linux/smp.h>
> +#include <linux/of.h>
>  
>  #include <asm/octeon/octeon.h>
>  
> @@ -42,9 +45,9 @@ struct octeon_core_chip_data {
>  
>  static struct octeon_core_chip_data octeon_irq_core_chip_data[MIPS_CORE_IRQ_LINES];
>  
> -static void __init octeon_irq_set_ciu_mapping(int irq, int line, int bit,
> -					      struct irq_chip *chip,
> -					      irq_flow_handler_t handler)
> +static void octeon_irq_set_ciu_mapping(int irq, int line, int bit,
> +				       struct irq_chip *chip,
> +				       irq_flow_handler_t handler)
>  {
>  	union octeon_ciu_chip_data cd;
>  
> @@ -838,6 +841,178 @@ static struct irq_chip octeon_irq_chip_ciu_wd = {
>  	.irq_mask = octeon_irq_dummy_mask,
>  };
>  
> +static bool octeon_irq_ciu_is_edge(unsigned int line, unsigned int bit)
> +{
> +	bool edge = false;
> +
> +	if (line == 0)
> +		switch (bit) {
> +		case 48 ... 49: /* GMX DRP */
> +		case 50: /* IPD_DRP */
> +		case 52 ... 55: /* Timers */
> +		case 58: /* MPI */
> +			edge = true;
> +			break;
> +		default:
> +			break;
> +		}
> +	else /* line == 1 */
> +		switch (bit) {
> +		case 47: /* PTP */
> +			edge = true;
> +			break;
> +		default:
> +			break;
> +		}

Nit: A bitmap would result in a lot nicer and probably smaller code here..

ie. edge = test_bit(bitmap, (line << 64) & bit);

> +	return edge;
> +}
> +
> +struct octeon_irq_gpio_domain_data {
> +	unsigned int base_hwirq;
> +};
> +
> +static int octeon_irq_gpio_xlat(struct irq_domain *d,
> +				struct device_node *node,
> +				const u32 *intspec,
> +				unsigned int intsize,
> +				unsigned long *out_hwirq,
> +				unsigned int *out_type)
> +{
> +	unsigned int type;
> +	unsigned int pin;
> +	unsigned int trigger;
> +	struct octeon_irq_gpio_domain_data *gpiod;
> +
> +	if (d->of_node != node)
> +		return -EINVAL;
> +
> +	if (intsize < 2)
> +		return -EINVAL;
> +
> +	pin = intspec[0];
> +	if (pin >= 16)
> +		return -EINVAL;
> +
> +	trigger = intspec[1];
> +
> +	switch (trigger) {
> +	case 1:
> +		type = IRQ_TYPE_EDGE_RISING;
> +		break;
> +	case 2:
> +		type = IRQ_TYPE_EDGE_FALLING;
> +		break;
> +	case 4:
> +		type = IRQ_TYPE_LEVEL_HIGH;
> +		break;
> +	case 8:
> +		type = IRQ_TYPE_LEVEL_LOW;
> +		break;
> +	default:
> +		pr_err("Error: (%s) Invalid irq trigger specification: %x\n",
> +		       node->name,
> +		       trigger);
> +		type = IRQ_TYPE_LEVEL_LOW;
> +		break;
> +	}
> +	*out_type = type;
> +	gpiod = d->host_data;
> +	*out_hwirq = gpiod->base_hwirq + pin;
> +
> +	return 0;
> +}
> +
> +static int octeon_irq_ciu_xlat(struct irq_domain *d,
> +			       struct device_node *node,
> +			       const u32 *intspec,
> +			       unsigned int intsize,
> +			       unsigned long *out_hwirq,
> +			       unsigned int *out_type)
> +{
> +	unsigned int ciu, bit;
> +
> +	ciu = intspec[0];
> +	bit = intspec[1];
> +
> +	if (ciu > 1 || bit > 63)
> +		return -EINVAL;
> +
> +	/* These are the GPIO lines */
> +	if (ciu == 0 && bit >= 16 && bit < 32)
> +		return -EINVAL;
> +
> +	*out_hwirq = (ciu << 6) | bit;
> +	*out_type = 0;
> +
> +	return 0;
> +}
> +
> +static struct irq_chip *octeon_irq_ciu_chip;
> +static struct irq_chip *octeon_irq_gpio_chip;
> +
> +static bool octeon_irq_virq_in_range(unsigned int virq)
> +{
> +	/* We cannot let it overflow the mapping array. */
> +	if (virq < (1ul << 8 * sizeof (octeon_irq_ciu_to_irq[0][0])))
> +		return true;
> +
> +	WARN_ONCE(true, "virq out of range %u.\n", virq);
> +	return false;
> +}
> +
> +static int octeon_irq_ciu_map(struct irq_domain *d,
> +			      unsigned int virq, irq_hw_number_t hw)
> +{
> +	unsigned int line = hw >> 6;
> +	unsigned int bit = hw & 63;
> +
> +	if (!octeon_irq_virq_in_range(virq))
> +		return -EINVAL;
> +
> +	if (line > 1 || octeon_irq_ciu_to_irq[line][bit] != 0)
> +		return -EINVAL;
> +
> +	if (octeon_irq_ciu_is_edge(line, bit))
> +		octeon_irq_set_ciu_mapping(virq, line, bit,
> +					   octeon_irq_ciu_chip,
> +					   handle_level_irq);
> +	else
> +		octeon_irq_set_ciu_mapping(virq, line, bit,
> +					   octeon_irq_ciu_chip,
> +					   handle_edge_irq);
> +
> +	return 0;
> +}
> +
> +static int octeon_irq_gpio_map(struct irq_domain *d,
> +			       unsigned int virq, irq_hw_number_t hw)
> +{
> +	unsigned int line = hw >> 6;
> +	unsigned int bit = hw & 63;
> +
> +	if (!octeon_irq_virq_in_range(virq))
> +		return -EINVAL;
> +
> +	if (line > 1 || octeon_irq_ciu_to_irq[line][bit] != 0)
> +		return -EINVAL;
> +
> +	octeon_irq_set_ciu_mapping(virq, line, bit,
> +				   octeon_irq_gpio_chip,
> +				   octeon_irq_handle_gpio);
> +
> +	return 0;
> +}
> +
> +static struct irq_domain_ops octeon_irq_domain_ciu_ops = {
> +	.map = octeon_irq_ciu_map,
> +	.xlate = octeon_irq_ciu_xlat,
> +};
> +
> +static struct irq_domain_ops octeon_irq_domain_gpio_ops = {
> +	.map = octeon_irq_gpio_map,
> +	.xlate = octeon_irq_gpio_xlat,
> +};
> +
>  static void octeon_irq_ip2_v1(void)
>  {
>  	const unsigned long core_id = cvmx_get_core_num();
> @@ -963,7 +1138,8 @@ static void __init octeon_irq_init_ciu(void)
>  	struct irq_chip *chip;
>  	struct irq_chip *chip_mbox;
>  	struct irq_chip *chip_wd;
> -	struct irq_chip *chip_gpio;
> +	struct device_node *gpio_node;
> +	struct device_node *ciu_node;
>  
>  	octeon_irq_init_ciu_percpu();
>  	octeon_irq_setup_secondary = octeon_irq_setup_secondary_ciu;
> @@ -977,15 +1153,16 @@ static void __init octeon_irq_init_ciu(void)
>  		chip = &octeon_irq_chip_ciu_v2;
>  		chip_mbox = &octeon_irq_chip_ciu_mbox_v2;
>  		chip_wd = &octeon_irq_chip_ciu_wd_v2;
> -		chip_gpio = &octeon_irq_chip_ciu_gpio_v2;
> +		octeon_irq_gpio_chip = &octeon_irq_chip_ciu_gpio_v2;
>  	} else {
>  		octeon_irq_ip2 = octeon_irq_ip2_v1;
>  		octeon_irq_ip3 = octeon_irq_ip3_v1;
>  		chip = &octeon_irq_chip_ciu;
>  		chip_mbox = &octeon_irq_chip_ciu_mbox;
>  		chip_wd = &octeon_irq_chip_ciu_wd;
> -		chip_gpio = &octeon_irq_chip_ciu_gpio;
> +		octeon_irq_gpio_chip = &octeon_irq_chip_ciu_gpio;
>  	}
> +	octeon_irq_ciu_chip = chip;
>  	octeon_irq_ip4 = octeon_irq_ip4_mask;
>  
>  	/* Mips internal */
> @@ -994,8 +1171,6 @@ static void __init octeon_irq_init_ciu(void)
>  	/* CIU_0 */
>  	for (i = 0; i < 16; i++)
>  		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_WORKQ0, 0, i + 0, chip, handle_level_irq);
> -	for (i = 0; i < 16; i++)
> -		octeon_irq_set_ciu_mapping(i + OCTEON_IRQ_GPIO0, 0, i + 16, chip_gpio, octeon_irq_handle_gpio);
>  
>  	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX0, 0, 32, chip_mbox, handle_percpu_irq);
>  	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MBOX1, 0, 33, chip_mbox, handle_percpu_irq);
> @@ -1026,6 +1201,28 @@ static void __init octeon_irq_init_ciu(void)
>  	octeon_irq_set_ciu_mapping(OCTEON_IRQ_USB1, 1, 17, chip, handle_level_irq);
>  	octeon_irq_set_ciu_mapping(OCTEON_IRQ_MII1, 1, 18, chip, handle_level_irq);
>  
> +	gpio_node = of_find_compatible_node(NULL, NULL, "cavium,octeon-3860-gpio");
> +	if (gpio_node) {
> +		struct octeon_irq_gpio_domain_data *gpiod;
> +
> +		gpiod = kzalloc(sizeof (*gpiod), GFP_KERNEL);
> +		if (gpiod) {
> +			/* gpio domain host_data is the base hwirq number. */
> +			gpiod->base_hwirq = 16;
> +			irq_domain_add_linear(gpio_node, 16, &octeon_irq_domain_gpio_ops, gpiod);

base_hwirq appears to be a fixed offset.  Is there a reason that it is
parameterized?  The code would be simpler if the size of the linear
domain was bumped to 32 (with the lower 16 never used or allocated) or
modify the driver to start hwirq counting at 0 instead of 16.  Either
way it would be better than hwirq being a parameter than isn't
actually a parameter (assuming I'm reading the code correctly).

g.


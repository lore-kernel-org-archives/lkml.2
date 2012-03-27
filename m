Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2C0SYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:24:53 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1142 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab2C0SYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:24:52 -0400
Message-ID: <4F7205F3.3000108@cavium.com>
Date: Tue, 27 Mar 2012 11:24:51 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 2/4] MIPS: Octeon: Setup irq_domains for interrupts.
References: <1332790281-9648-1-git-send-email-ddaney.cavm@gmail.com> <1332790281-9648-3-git-send-email-ddaney.cavm@gmail.com> <4F711E69.1080302@gmail.com>
In-Reply-To: <4F711E69.1080302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2012 18:24:31.0209 (UTC) FILETIME=[DA39FD90:01CD0C46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 06:56 PM, Rob Herring wrote:
> On 03/26/2012 02:31 PM, David Daney wrote:
>> From: David Daney<david.daney@cavium.com>
[...]
>> +static bool octeon_irq_ciu_is_edge(unsigned int line, unsigned int bit)
>> +{
>> +	bool edge = false;
>> +
>> +	if (line == 0)
>> +		switch (bit) {
>> +		case 48 ... 49: /* GMX DRP */
>> +		case 50: /* IPD_DRP */
>> +		case 52 ... 55: /* Timers */
>> +		case 58: /* MPI */
>> +			edge = true;
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +	else /* line == 1 */
>> +		switch (bit) {
>> +		case 47: /* PTP */
>> +			edge = true;
>> +			break;
>> +		default:
>> +			break;
>> +		}
>> +	return edge;
>
> Moving in the right direction, but I still don't get why this is not in
> the CIU binding as a 3rd cell?

There are a several reasons, in no particular order they are:

o There is no 3rd cell.  The bindings were discussed with Grant here:
   http://www.linux-mips.org/archives/linux-mips/2011-05/msg00355.html

o The edge/level thing cannot be changed, and the irq lines don't leave 
the SOC, so hard coding it is possible.

>
>> +}
>> +
>> +struct octeon_irq_gpio_domain_data {
>> +	unsigned int base_hwirq;
>> +};
>> +
>> +static int octeon_irq_gpio_xlat(struct irq_domain *d,
>> +				struct device_node *node,
>> +				const u32 *intspec,
>> +				unsigned int intsize,
>> +				unsigned long *out_hwirq,
>> +				unsigned int *out_type)
>> +{
>> +	unsigned int type;
>> +	unsigned int pin;
>> +	unsigned int trigger;
>> +	bool set_edge_handler = false;
>> +	struct octeon_irq_gpio_domain_data *gpiod;
>> +
>> +	if (d->of_node != node)
>> +		return -EINVAL;
>> +
>> +	if (intsize<  2)
>> +		return -EINVAL;
>> +
>> +	pin = intspec[0];
>> +	if (pin>= 16)
>> +		return -EINVAL;
>> +
>> +	trigger = intspec[1];
>> +
>> +	switch (trigger) {
>> +	case 1:
>> +		type = IRQ_TYPE_EDGE_RISING;
>> +		set_edge_handler = true;
>
> This is never used.

Right, it was leftover from the previous version.

>
>> +		break;
>> +	case 2:
>> +		type = IRQ_TYPE_EDGE_FALLING;
>> +		set_edge_handler = true;
>> +		break;
>> +	case 4:
>> +		type = IRQ_TYPE_LEVEL_HIGH;
>> +		break;
>> +	case 8:
>> +		type = IRQ_TYPE_LEVEL_LOW;
>> +		break;
>> +	default:
>> +		pr_err("Error: (%s) Invalid irq trigger specification: %x\n",
>> +		       node->name,
>> +		       trigger);
>> +		type = IRQ_TYPE_LEVEL_LOW;
>> +		break;
>> +	}
>> +	*out_type = type;
>
> Can't you get rid of the whole switch statement and just do:
>
> *out_type = intspec[1];

That wouldn't catch erroneous values like 6.

>
[...]
>> +static int octeon_irq_ciu_map(struct irq_domain *d,
>> +			      unsigned int virq, irq_hw_number_t hw)
>> +{
>> +	unsigned int line = hw>>  6;
>> +	unsigned int bit = hw&  63;
>> +
>> +	if (virq>= 256)
>> +		return -EINVAL;
>
> Drop this. You should not care what the virq numbers are.


I care that they don't overflow the width of octeon_irq_ciu_to_irq (a u8).

So really I want to say:

    if (virq >= (1 << sizeof (octeon_irq_ciu_to_irq[0][0]))) {
        WARN(...);
        return -EINVAL;
    }


I need a map external to any one irq_domain.  The irq handling code 
handles sources that come from two separate irq_domains, as well as irqs 
that are not part of any domain.


Thanks for looking at this again,  I will re-spin the patch,
David Daney

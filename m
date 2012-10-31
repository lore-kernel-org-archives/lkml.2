Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070Ab2JaJDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:03:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49170 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044Ab2JaJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:03:05 -0400
Message-ID: <5090E944.4020803@numascale-asia.com>
Date: Wed, 31 Oct 2012 17:03:00 +0800
From: Daniel J Blueman <daniel@numascale-asia.com>
Organization: Numascale Asia
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Joe Perches <joe@perches.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix printing when no interrupt is allocated
References: <1350606821-29813-1-git-send-email-daniel@numascale-asia.com> <1350609711.22385.21.camel@joe-AO722>
In-Reply-To: <1350609711.22385.21.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On 19/10/2012 09:21, Joe Perches wrote:
> On Fri, 2012-10-19 at 08:33 +0800, Daniel J Blueman wrote:
>> Previously a new line is implicitly added in the no GSI case:
>>
>> [    7.185182] pci 0001:00:12.0: can't derive routing for PCI INT A
>> [    7.191352] pci 0001:00:12.0: PCI INT A: no GSI
>> [    7.195956]  - using ISA IRQ 10
>>
>> The code thus prints a blank line where no legacy IRQ is available:
>>
>> [    1.650124] pci 0000:00:14.0: can't derive routing for PCI INT A
>> [    1.650126] pci 0000:00:14.0: PCI INT A: no GSI
>> [    1.650126]
>> [    1.650180] pci 0000:00:14.0: can't derive routing for PCI INT A
>>
>> Fix this by making the newline explicit and removing the superfluous
>> one.
>
> I think this is a better fix:
>
>   drivers/acpi/pci_irq.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index 0eefa12..9b98f9f 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -459,19 +459,20 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>   	 */
>   	if (gsi < 0) {
>   		u32 dev_gsi;
> -		dev_warn(&dev->dev, "PCI INT %c: no GSI", pin_name(pin));
>   		/* Interrupt Line values above 0xF are forbidden */
>   		if (dev->irq > 0 && (dev->irq <= 0xF) &&
>   		    (acpi_isa_irq_to_gsi(dev->irq, &dev_gsi) == 0)) {
> -			printk(" - using ISA IRQ %d\n", dev->irq);
> +			dev_warn(&dev->dev,
> +				 "PCI INT %c: no GSI - using ISA IRQ %d\n",
> +				 pin_name(pin), dev->irq);
>   			acpi_register_gsi(&dev->dev, dev_gsi,
>   					  ACPI_LEVEL_SENSITIVE,
>   					  ACPI_ACTIVE_LOW);
> -			return 0;
>   		} else {
> -			printk("\n");
> -			return 0;
> +			dev_warn(&dev->dev, "PCI INT %c: no GSI\n",
> +				 pin_name(pin));
>   		}
> +		return 0;
>   	}
>
>   	rc = acpi_register_gsi(&dev->dev, gsi, triggering, polarity);

We're still seeing this in 3.7-rc3. Any preference to the approach here?

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale Asia

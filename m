Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2DCCgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:36:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44177 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751826Ab2DCCgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:36:54 -0400
Message-ID: <1333420612.26079.6.camel@joe2Laptop>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Mon, 02 Apr 2012 19:36:52 -0700
In-Reply-To: <1333415903.860.0.camel@mop>
References: <1333415903.860.0.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 03:18 +0200, Kay Sievers wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk(): add KERN_CONT where needed
> 
> A prototype for kmsg records instead of a byte-stream buffer revealed
> a couple of missing printk(KERN_CONT ...) uses. Subsequent calls produce
> one record per printk() call, while all should have ended up in a single
> record.
> 
> Instead of:
>   ACPI: (supports S0 S5)
>   ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
>   hpet0: at MMIO 0xfed00000, IRQs 2 , 8 , 0
> 
> It prints:
>   ACPI: (supports S0
>    S5
>   )
>   ACPI: PCI Interrupt Link [LNKA] (IRQs
>    5
>    *10
>    11
>   )
>   hpet0: at MMIO 0xfed00000, IRQs
>    2
>   , 8
>   , 0


You are going to find many, many _hundreds_ of these.

Maybe it'd be better to aggregate content rather like
printk does.  Aggregate until you get a newline or a
new KERN_<LEVEL>

A couple of other trivial comments:

It's better to try to coalesce multiple printks(KERN_CONT
(perhaps it's better to use pr_cont instead too)

Branches with the same printks should be hoisted where
possible.

> --- a/drivers/acpi/pci_link.c
> @@ -720,21 +720,21 @@ static int acpi_pci_link_add(struct acpi
>  	       acpi_device_bid(device));
>  	for (i = 0; i < link->irq.possible_count; i++) {
>  		if (link->irq.active == link->irq.possible[i]) {
> -			printk(" *%d", link->irq.possible[i]);
> +			printk(KERN_CONT " *%d", link->irq.possible[i]);
>  			found = 1;
>  		} else
> -			printk(" %d", link->irq.possible[i]);
> +			printk(KERN_CONT " %d", link->irq.possible[i]);
>  	}

Hoisting gives:

	for (i = 0; ...) {
		pr_cont(" %d", link->irq.possible[i]);
		if (link->irq.active == link->irq.possible[i])
 			found = 1;
	}

>  	if (!found)
> -		printk(" *%d", link->irq.active);
> +		printk(KERN_CONT " *%d", link->irq.active);
>  
>  	if (!link->device->status.enabled)
> -		printk(", disabled.");
> +		printk(KERN_CONT ", disabled.");
>  
> -	printk("\n");
> +	printk(KERN_CONT "\n");

Coalesced this is:

	if (!found)
		pr_cont(") *%d%s\n",
			link->irq.active,
			!link->device->status.enabled ? ", disabled" : "");
	else
		pr_cont("}%s\n",
			!link->device->status.enabled ? ", disabled" : "")



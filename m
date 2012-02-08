Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab2BHEfe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 23:35:34 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38242 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073Ab2BHEfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 23:35:32 -0500
Date: Wed, 8 Feb 2012 12:35:17 +0800
From: Ram Pai <linuxram@us.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] PCI: Fix cardbus bridge resources as optional size
 handling
Message-ID: <20120208043517.GD8930@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
 <1328424908-6385-5-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328424908-6385-5-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020804-2398-0000-0000-000004086460
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 10:55:03PM -0800, Yinghai Lu wrote:
> We should not set the requested size to -2.
> 
> that will confuse the resource list sorting with align when SIZEALIGN is used.
> 
> Change to STARTALIGN and pass align from start.
> 
> We are safe to do that just as we do that regular pci bridge.
> 
> In the long run, we should just treat cardbus like regular pci bridge.
> 
> Also fix when realloc is not passed, should keep the requested size.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/setup-bus.c |   63 ++++++++++++++++++++++++++--------------------
>  1 files changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index d5897c3..3b3932a 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -898,21 +898,30 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>  {
>  	struct pci_dev *bridge = bus->self;
>  	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
> +	resource_size_t b_res_3_size = pci_cardbus_mem_size * 2;
>  	u16 ctrl;
> 
>  	/*
>  	 * Reserve some resources for CardBus.  We reserve
>  	 * a fixed amount of bus space for CardBus bridges.
>  	 */
> -	b_res[0].start = 0;
> -	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
> -	if (realloc_head)
> -		add_to_list(realloc_head, bridge, b_res, pci_cardbus_io_size, 0 /* dont care */);
> +	b_res[0].start = pci_cardbus_io_size;
> +	b_res[0].end = b_res[0].start + pci_cardbus_io_size - 1;
> +	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
> +	if (realloc_head) {
> +		b_res[0].end -= pci_cardbus_io_size;
> +		add_to_list(realloc_head, bridge, b_res, pci_cardbus_io_size,
> +				pci_cardbus_io_size);
> +	}
> 
> -	b_res[1].start = 0;
> -	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
> -	if (realloc_head)
> -		add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
> +	b_res[1].start = pci_cardbus_io_size;
> +	b_res[1].end = b_res[1].start + pci_cardbus_io_size - 1;
> +	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_STARTALIGN;
> +	if (realloc_head) {
> +		b_res[1].end -= pci_cardbus_io_size;
> +		add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size,
> +				 pci_cardbus_io_size);
> +	}
> 
>  	/* MEM1 must not be pref mmio */
>  	pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
> @@ -939,28 +948,28 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>  	 * twice the size.
>  	 */
>  	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
> -		b_res[2].start = 0;
> -		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
> -		if (realloc_head)
> -			add_to_list(realloc_head, bridge, b_res+2, pci_cardbus_mem_size, 0 /* dont care */);
> +		b_res[2].start = pci_cardbus_mem_size;
> +		b_res[2].end = b_res[2].start + pci_cardbus_mem_size - 1;
> +		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH |
> +				  IORESOURCE_STARTALIGN;
> +		if (realloc_head) {
> +			b_res[2].end -= pci_cardbus_mem_size;
> +			add_to_list(realloc_head, bridge, b_res+2,
> +				 pci_cardbus_mem_size, pci_cardbus_mem_size);
> +		}
> 
> -		b_res[3].start = 0;
> -		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
> -		if (realloc_head)
> -			add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size, 0 /* dont care */);

The b_res_3_size has to be reduced to half here.
Otherwise it will try allocate 2*pci_cardbus_mem_size to the BAR3..

		b_res_3_size = pci_cardbus_mem_size;


> -	} else {
> -		b_res[3].start = 0;
> -		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
> -		if (realloc_head)
> -			add_to_list(realloc_head, bridge, b_res+3, pci_cardbus_mem_size * 2, 0 /* dont care */);
> +		/* reduce that to half */
> +		b_res_3_size = pci_cardbus_mem_size;

b_res3_3_size should not be updated here, since BAR3 has to be allocated 2*pci_cardbus_mem_size
resource.

RP


>  	}
> 
> -	/* set the size of the resource to zero, so that the resource does not
> -	 * get assigned during required-resource allocation cycle but gets assigned
> -	 * during the optional-resource allocation cycle.
> - 	 */
> -	b_res[0].start = b_res[1].start = b_res[2].start = b_res[3].start = 1;
> -	b_res[0].end = b_res[1].end = b_res[2].end = b_res[3].end = 0;
> +	b_res[3].start = pci_cardbus_mem_size;
> +	b_res[3].end = b_res[3].start + b_res_3_size - 1;
> +	b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_STARTALIGN;
> +	if (realloc_head) {
> +		b_res[3].end -= b_res_3_size;
> +		add_to_list(realloc_head, bridge, b_res+3, b_res_3_size,
> +				 pci_cardbus_mem_size);
> +	}
>  }
> 
>  void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> -- 
> 1.7.7


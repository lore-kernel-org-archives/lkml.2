Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab1ELSGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:06:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:38734 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1ELSGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:06:49 -0400
Date: Thu, 12 May 2011 11:06:38 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH -v2] pci: Check bridge resources after resource
 allocation.
Message-ID: <20110512180638.GA5012@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <4DC250A6.9040802@kernel.org>
 <20110506081243.GF16782@ram-laptop>
 <4DC4586C.6020308@kernel.org>
 <20110507015240.GN16782@ram-laptop>
 <4DC4B059.3030502@kernel.org>
 <4DC64C58.70203@kernel.org>
 <20110509142014.617e3100@jbarnes-desktop>
 <BANLkTi=U0LSj45y+5+n+7R=Cj4uRqk-LQw@mail.gmail.com>
 <4DC9E415.5010402@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC9E415.5010402@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 06:19:17PM -0700, Yinghai Lu wrote:
> On 05/09/2011 03:36 PM, Linus Torvalds wrote:
> > On Mon, May 9, 2011 at 2:20 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >>
> >> Linus?  Bjorn?  Ram?
> > 
> > I dunno. The patch really makes me go "that looks *broken*". I really
> > dislike it. But maybe the crappiness of the patch comes from the
> > horror that is the current code.
> 
> please check if this one is ok.

I like this approach than the earlier approach because it
closes the subtle bug _introduced_ by my earlier patch,
	commit c8adf9a3e873eddaaec11ac410a99ef6b9656938

However i think the implementation can be made cleaner. Comments below..


> 
> [PATCH] pci: Clear bridge resource flags if requested size is 0
> 
> During pci remove/rescan testing found:
> 
> [  541.141614] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
> [  541.141965] pci 0000:c0:03.0:   bridge window [io  0x1000-0x0fff]
> [  541.159181] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
> [  541.159540] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
> [  541.179374] pci 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
> [  541.199198] pci 0000:c0:03.0: Error enabling bridge (-22), continuing
> [  541.199202] pci 0000:c0:03.0: enabling bus mastering
> [  541.199209] pci 0000:c0:03.0: setting latency timer to 64
> [  541.199917] pcieport 0000:c0:03.0: device not available (can't reserve [io  0x1000-0x0fff])
> [  541.199963] pcieport: probe of 0000:c0:03.0 failed with error -22
> 
> This bug was cause by commit
> | commit c8adf9a3e873eddaaec11ac410a99ef6b9656938
> | Author: Ram Pai <linuxram@us.ibm.com>
> | Date:   Mon Feb 14 17:43:20 2011 -0800
> |
> |    PCI: pre-allocate additional resources to devices only after successful allocation of essential resources.
> 
> After that commit, pci_hotplug_io_size is changed to additional_io_size from minium size.
> So it will not go through resource_size(res) != 0 path,  and will not be reset there.
> 
> The root cause is: pci_bridge_check_ranges will set RESOURCE_IO flag for pci
> bridge, and later if children do not need IO resource. those bridge
> resources will not need to be allocated. but flags is still there. that will
> confuse the the pci_enable_bridges later.
> 
> related code:
> | static void assign_requested_resources_sorted(struct resource_list *head,
> |                                  struct resource_list_x *fail_head)
> | {
> |         struct resource *res;
> |         struct resource_list *list;
> |         int idx;
> |
> |         for (list = head->next; list; list = list->next) {
> |                 res = list->res;
> |                 idx = res - &list->dev->resource[0];
> |                 if (resource_size(res) && pci_assign_resource(list->dev, idx)) {
> | ...
> |                         reset_resource(res);
> |                 }
> |         }
> | }
> 
> At last, We have to clear the flags in pbus_size_mem/io and etc.
> 
> also need to update adjust_resources_sorted() to handle this special case if
> requested_size is 0, but add_size is not 0.
> 
> after patch, will get right result:
> [  621.206655] pci 0000:c0:03.0: PCI bridge to [bus c4-c9]
> [  621.206912] pci 0000:c0:03.0:   bridge window [io  disabled]
> [  621.226594] pci 0000:c0:03.0:   bridge window [mem 0xf0000000-0xf00fffff]
> [  621.226904] pci 0000:c0:03.0:   bridge window [mem 0xfc180000000-0xfc197ffffff 64bit pref]
> [  621.247012] pci 0000:c0:03.0: enabling bus mastering
> [  621.247275] pci 0000:c0:03.0: setting latency timer to 64
> [  621.267656] pcieport 0000:c0:03.0: setting latency timer to 64
> [  621.268134] pcieport 0000:c0:03.0: irq 160 for MSI/MSI-X
> [  621.286832] pcieport 0000:c0:03.0: Signaling PME through PCIe PME interrupt
> [  621.306360] pci 0000:c4:00.0: Signaling PME through PCIe PME interrupt
> [  621.306684] pcie_pme 0000:c0:03.0:pcie01: service driver pcie_pme loaded
> [  621.326512] aer 0000:c0:03.0:pcie02: service driver aer loaded
> [  621.326911] pciehp 0000:c0:03.0:pcie04: Hotplug Controller:
> 
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/setup-bus.c |   31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -138,9 +138,26 @@ static void adjust_resources_sorted(stru
>  	for (list = add_head->next; list;) {
>  		res = list->res;
>  		/* skip resource that has been reset */
> -		if (!res->flags)
> +		if (!res->flags && !res->start && !res->end)
>  			goto out;
> 
> +		idx = res - &list->dev->resource[0];


> +		add_size = list->add_size;
> +		if (!add_size) {
> +			dev_warn(&list->dev->dev, "idx %d add_size == 0\n",
> +					 idx);
> +			goto out;
> +		}
This code is not needed. Because add_size will alway be greater than 0. The reason
it is in the add_list means that add_size is greater than 0.


> +
> +		if (!resource_size(res)) {

There is assumption made in various sections of the code that 
->start and ->size cannot be relied upon if ->flags is zero.

Though in this case we know that ->start and ->size are valid
even when ->flags is reset, the fact is not easily
recognizable.


> +			/* need to restore the flag */
> +			res->flags = list->flags;
> +			res->end = res->start + add_size - 1;
> +			if (pci_assign_resource(list->dev, idx))
> +				reset_resource(res);
> +			goto out;
> +		}
> +
>  		/* skip this resource if not found in head list */
>  		for (hlist = head->next; hlist && hlist->res != res;
>  				hlist = hlist->next);
> @@ -150,16 +167,8 @@ static void adjust_resources_sorted(stru
>  			continue;
>  		}
> 
> -		idx = res - &list->dev->resource[0];
> -		add_size=list->add_size;
> -		if (!resource_size(res) && add_size) {
> -			 res->end = res->start + add_size - 1;
> -			 if(pci_assign_resource(list->dev, idx))
> -				reset_resource(res);
> -		} else if (add_size) {
> -			adjust_resource(res, res->start,
> +		adjust_resource(res, res->start,
>  				resource_size(res) + add_size);
> -		}
>  out:
>  		tmp = list;
>  		prev->next = list = list->next;
> @@ -596,6 +605,8 @@ static void pbus_size_io(struct pci_bus
>  	b_res->flags |= IORESOURCE_STARTALIGN;
>  	if (size1 > size0 && add_head)
>  		add_to_list(add_head, bus->self, b_res, size1-size0);
> +	if (!size0)
> +		b_res->flags = 0;

There is code above which resets the flag in if (!size && !size0) {.. b_res->flags = 0;}

We need to restructure this code to have a single place that resets the flag.

Also I choose to capture the necessary fields of b_res in the resource_list_x structure
and totally reset b_res.

pbus_size_io() function looks very clumsy to begin with. This patch will make it
even more clumsier unless restructured a litte.

>  }
> 
>  /**
> @@ -693,6 +704,8 @@ static int pbus_size_mem(struct pci_bus
>  	b_res->flags |= IORESOURCE_STARTALIGN | mem64_mask;
>  	if (size1 > size0 && add_head)
>  		add_to_list(add_head, bus->self, b_res, size1-size0);
> +	if (!size0)
> +		b_res->flags = 0;

same here..

>  	return 1;
>  }

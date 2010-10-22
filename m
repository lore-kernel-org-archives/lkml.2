Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0JVWR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 18:17:57 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:11482 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0JVWRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 18:17:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/1] PCI: ignore failure to preallocate minimal resources to hotplug bridges
Date: Fri, 22 Oct 2010 16:16:34 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        peter.henriksson@gmail.com, ebiederm@aristanetworks.com
References: <20101006225834.GE2945@ram-laptop> <20101019112439.53c4901e@jbarnes-desktop> <20101022171640.GE24820@ram-laptop>
In-Reply-To: <20101022171640.GE24820@ram-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221616.35260.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 22, 2010 11:16:40 am Ram Pai wrote:
>         PCI: ignore failure to preallocate minimal resources to 
> 		hotplug bridges
> 
> 	Linux tries to pre-allocate minimal resources to hotplug 
> 	bridges.  This 	works 	fine as long as there are enough 
> 	resources  to  satisfy   all   other   genuine  resource
> 	requirements.  However  if  enough  resources   are  not 
> 	available    to    satisfy    the    pre-allocation, the 
> 	resource-allocator reports errors and returns failure.
> 	
> 	This patch distinguishes between must-need resources and
> 	nice-to-have   resources.   Any   failure   to  allocate 
> 	nice-to-have resources are ignored. 
> 
> 	This  behavior  can  be  particularly  useful to trigger 
> 	automatic  reallocation, if  the  OS  discovers  genuine 
> 	resource  allocation  conflicts  or  genuine unallocated 
> 	BARs  caused  by not-so-smart allocation behavior of the 
> 	native BIOS.
> 
> 	The motivation for this patch is due a issue reported in 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=15960

No need to justify both margins, the left is enough :-)
Doesn't need to be indented either.

> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> 
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 66cb8f4..3bbc427 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -412,14 +412,14 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
>  {
>  	struct pci_dev *dev;
>  	struct resource *b_res = find_free_bus_resource(bus, IORESOURCE_IO);
> -	unsigned long size = 0, size1 = 0, old_size;
> +	unsigned long size = 0, size1 = 0, old_size, dev_present=0;

General rule of thumb: when modifying code always follow the
existing style for spacing, indentation, etc.  In this case
you would need spaces around the "=".  

>  	if (!b_res)
>   		return;
>  
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		int i;
> -
> +		dev_present=1;
>  		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>  			struct resource *r = &dev->resource[i];
>  			unsigned long r_size;
> @@ -460,6 +460,12 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size)
>  	b_res->start = 4096;
>  	b_res->end = b_res->start + size - 1;
>  	b_res->flags |= IORESOURCE_STARTALIGN;
> +
> +	/* if no devices are behind this bus, inform
> +	 * resource-allocater to try hard but not to worry
> +	 * if allocations fail 
> +	 */
> +	b_res->flags |= (!dev_present) ? IORESOURCE_IGNORE_FAIL : 0;
>  }
>  
>  /* Calculate the size of the bus and minimal alignment which
> @@ -470,7 +476,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  	struct pci_dev *dev;
>  	resource_size_t min_align, align, size, old_size;
>  	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
> -	int order, max_order;
> +	int order, max_order, dev_present=0;
>  	struct resource *b_res = find_free_bus_resource(bus, type);
>  	unsigned int mem64_mask = 0;
>  
> @@ -487,6 +493,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  	list_for_each_entry(dev, &bus->devices, bus_list) {
>  		int i;
>  
> +		dev_present=1;
>  		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
>  			struct resource *r = &dev->resource[i];
>  			resource_size_t r_size;
> @@ -550,6 +557,13 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  	b_res->end = size + min_align - 1;
>  	b_res->flags |= IORESOURCE_STARTALIGN;
>  	b_res->flags |= mem64_mask;
> +
> +	/* if no devices are behind this bus, inform
> +	 * resource-allocater to try hard but not to worry
> +	 * if allocations fail 
> +	 */
> +	b_res->flags |= (!dev_present) ? IORESOURCE_IGNORE_FAIL : 0;
> +
>  	return 1;
>  }
>  
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 2aaa131..a8ce953 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -210,7 +210,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	if (!align) {
>  		dev_info(&dev->dev, "BAR %d: can't assign %pR "
>  			 "(bogus alignment)\n", resno, res);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  
>  	bus = dev->bus;
> @@ -225,6 +226,10 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  	}
>  
>  	if (ret) {
> +		if (res->flags & IORESOURCE_IGNORE_FAIL) {

You might be able to do something like this:

		if (dev->subordinate && list_empty(&dev->subordinate->devices))

and avoid the need for a new flag.

I'm not sure this approach is enough, though.  What if we have 4K of
I/O space available, and we have this situation:

	bridge A (disabled)
	bridge B (disabled)
		dev D (needs I/O space)

I think your patch will let us ignore a failure to allocate space for
bridge A.  But the real problem is the order: we have to allocate space
for bridge B *first*.

Bjorn

> +			ret = 0;
> +			goto out;
> +		}
>  		if (res->flags & IORESOURCE_MEM)
>  			if (res->flags & IORESOURCE_PREFETCH)
>  				type = "mem pref";
> @@ -239,6 +244,8 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
>  			 resno, type, (unsigned long long) resource_size(res));
>  	}
>  
> +out:
> +	res->flags &= ~IORESOURCE_IGNORE_FAIL;
>  	return ret;
>  }
>  
> diff --git a/include/linux/ioport.h b/include/linux/ioport.h
> index b227902..941624b 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -49,6 +49,7 @@ struct resource_list {
>  
>  #define IORESOURCE_SIZEALIGN	0x00040000	/* size indicates alignment */
>  #define IORESOURCE_STARTALIGN	0x00080000	/* start field is alignment */
> +#define IORESOURCE_IGNORE_FAIL	0x00800000 	/* IGNORE if allocation fail*/
>  
>  #define IORESOURCE_MEM_64	0x00100000
>  #define IORESOURCE_WINDOW	0x00200000	/* forwarded by bridge */
> 

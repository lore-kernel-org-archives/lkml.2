Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2H3WJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:09:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43505 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab2H3WJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:09:48 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Rob Herring <robherring2@gmail.com>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] of: add devres version of of_iomap
Thread-Topic: [PATCH] of: add devres version of of_iomap
Thread-Index: AQHNht0PFTEfSZn2K0+pq9hvwRnh6pdy5toQ
Date: Thu, 30 Aug 2012 22:09:40 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B7041AD91C@DFLE12.ent.ti.com>
References: <1346340744-22218-1-git-send-email-m-karicheri2@ti.com>
 <503FB074.7080702@gmail.com>
In-Reply-To: <503FB074.7080702@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -----Original Message-----
>> From: Rob Herring [mailto:robherring2@gmail.com]
>> Sent: Thursday, August 30, 2012 2:27 PM
>> To: Karicheri, Muralidharan
>> Cc: grant.likely@secretlab.ca; devicetree-discuss@lists.ozlabs.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] of: add devres version of of_iomap
>> 
>> On 08/30/2012 10:32 AM, Murali Karicheri wrote:
>> > This adds devres version of the of_iomap() to allow resource to be cleaned
>> > through devres.
>> 
>> If you have a struct device, then don't you already have a resource and
>> can just use devm_ioremap in a driver? New drivers should not be using
>> of_iomap.
>> 

That is the point. If you do a grep under driver, there are many drivers using the pattern
like this. This helper function is mean to replace this code.

>From dma/sirf-dma.c

        ret = of_address_to_resource(dn, 0, &res);
        if (ret) {
                dev_err(dev, "Error parsing memory region!\n");
	       goto error;
        }

        regs_start = res.start;
        regs_size = resource_size(&res);

        base = devm_ioremap(dev, regs_start, regs_size);
        if (!base) {
                dev_err(dev, "Error mapping memory region!\n");
	       goto error;
        }

Other instances.

edac/mpc85xx_edac.c
media/video/fsl-viu.c
mtd/nand/mpc5121_nfc.c

Some of these code uses devm_request_mem_region() as well. Isn't a good idea to add this helper
that can be called by new drivers to replace this sequence? I could update the patch to do this call
as well?

>> Rob
>> 
>> >
>> > Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>> > ---
>> >  drivers/of/address.c       |   26 ++++++++++++++++++++++++--
>> >  include/linux/of_address.h |    2 ++
>> >  2 files changed, 26 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/of/address.c b/drivers/of/address.c
>> > index 7e262a6..d3da426 100644
>> > --- a/drivers/of/address.c
>> > +++ b/drivers/of/address.c
>> > @@ -602,10 +602,9 @@ struct device_node
>> *of_find_matching_node_by_address(struct device_node *from,
>> >  	return NULL;
>> >  }
>> >
>> > -
>> >  /**
>> >   * of_iomap - Maps the memory mapped IO for a given device_node
>> > - * @device:	the device whose io range will be mapped
>> > + * @device_node: Ptr to the device node that has the reg property
>> >   * @index:	index of the io range
>> >   *
>> >   * Returns a pointer to the mapped memory
>> > @@ -620,3 +619,26 @@ void __iomem *of_iomap(struct device_node *np, int index)
>> >  	return ioremap(res.start, resource_size(&res));
>> >  }
>> >  EXPORT_SYMBOL(of_iomap);
>> > +
>> > +/**
>> > + * of_devm_iomap - devres version of of_iomap
>> > + * @device:	the device whose io range will be mapped
>> > + * @index:	index of the io range
>> > + *
>> > + * Returns a pointer to the mapped memory
>> > + */
>> > +void __iomem *of_devm_iomap(struct device *dev, int index)
>> > +{
>> > +	struct device_node *np;
>> > +	struct resource res;
>> > +
>> > +	if (!dev)
>> > +		return NULL;
>> > +
>> > +	np = dev->of_node;
>> > +	if (of_address_to_resource(np, index, &res))
>> > +		return NULL;
>> > +
>> > +	return devm_ioremap(dev, res.start, resource_size(&res));
>> > +}
>> > +EXPORT_SYMBOL(of_devm_iomap);
>> > diff --git a/include/linux/of_address.h b/include/linux/of_address.h
>> > index 01b925a..67efa5f 100644
>> > --- a/include/linux/of_address.h
>> > +++ b/include/linux/of_address.h
>> > @@ -3,6 +3,7 @@
>> >  #include <linux/ioport.h>
>> >  #include <linux/errno.h>
>> >  #include <linux/of.h>
>> > +#include <linux/device.h>
>> >
>> >  #ifdef CONFIG_OF_ADDRESS
>> >  extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
>> > @@ -13,6 +14,7 @@ extern struct device_node *of_find_matching_node_by_address(
>> >  					const struct of_device_id *matches,
>> >  					u64 base_address);
>> >  extern void __iomem *of_iomap(struct device_node *device, int index);
>> > +extern void __iomem *of_devm_iomap(struct device *dev, int index);
>> >
>> >  /* Extract an address from a device, returns the region size and
>> >   * the address space flags too. The PCI version uses a BAR number
>> >

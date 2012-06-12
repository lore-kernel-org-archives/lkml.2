Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2FLCQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:16:22 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:35789 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202Ab2FLCQV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:16:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zzbb2dI98dI9371I148cI542M1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
From: Jia Hongtao-B38951 <B38951@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: RE: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Thread-Topic: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Thread-Index: AQHNRV2d07XgG54zbUKKBQTDlvBob5b1mBOAgABd/RA=
Date: Tue, 12 Jun 2012 02:16:18 +0000
Message-ID: <412C8208B4A0464FA894C5F0C278CD5D01A0972B@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1339148585-16947-1-git-send-email-B38951@freescale.com>
 <4FD60FB1.7050106@gmail.com>
In-Reply-To: <4FD60FB1.7050106@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.48]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Monday, June 11, 2012 11:33 PM
> To: Jia Hongtao-B38951
> Cc: devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> Greg KH
> Subject: Re: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
> 
> [adding lkml and Greg KH]
> 
> On 06/08/2012 04:43 AM, Jia Hongtao wrote:
> > We changed the pcie controller driver to platform driver so that the
> PCI
> > of platform devices need to be created earlier in the arch_initcall
> stage
> > according to the original timing of calling fsl_add_bridge(). So we do
> PCI
> > probing separately from other devices. But probing more than once could
> > cause duplication warning. We add check if the devices have already
> probed
> > before probing any devices to avoid duplication warning.
> >
> > Signed-off-by: Jia Hongtao <B38951@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> 
> Where's v1 and v2 history?

Sorry, there is no V1 and V2.
These are a series of patches and only this one related to device-tree operation.
V3 are for other patches.
I will aware of that in the future.
Thanks for mentioning.

> 
> >  drivers/of/platform.c |   18 ++++++++++++------
> >  1 files changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > index a37330e..3aab01f 100644
> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -139,6 +139,18 @@ struct platform_device *of_device_alloc(struct
> device_node *np,
> >  	if (!dev)
> >  		return NULL;
> >
> > +	dev->dev.of_node = of_node_get(np);
> > +	if (bus_id)
> > +		dev_set_name(&dev->dev, "%s", bus_id);
> > +	else
> > +		of_device_make_bus_id(&dev->dev);
> > +
> > +	if (kset_find_obj(dev->dev.kobj.kset, kobject_name(&dev->dev.kobj)))
> {
> 
> Is this a fast operation? I worry that we'd be doing this for every
> device creation. Looking at kobj's seems too low level as well.
>

To us this is also the main concern.

-Jia Hongtao.
 
> Perhaps moving the warning up the call stack and making the relevant
> functions __must_check would work.
> 
> Rob
> 
> > +		kfree(dev);
> > +		of_node_put(np);
> > +		return NULL;
> > +	}
> > +
> >  	/* count the io and irq resources */
> >  	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
> >  		num_reg++;
> > @@ -161,17 +173,11 @@ struct platform_device *of_device_alloc(struct
> device_node *np,
> >  		WARN_ON(of_irq_to_resource_table(np, res, num_irq) !=
> num_irq);
> >  	}
> >
> > -	dev->dev.of_node = of_node_get(np);
> >  #if defined(CONFIG_MICROBLAZE)
> >  	dev->dev.dma_mask = &dev->archdata.dma_mask;
> >  #endif
> >  	dev->dev.parent = parent;
> >
> > -	if (bus_id)
> > -		dev_set_name(&dev->dev, "%s", bus_id);
> > -	else
> > -		of_device_make_bus_id(&dev->dev);
> > -
> >  	return dev;
> >  }
> >  EXPORT_SYMBOL(of_device_alloc);
> 



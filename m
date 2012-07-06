Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2GFE0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 00:26:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43699 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751715Ab2GFE0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 00:26:13 -0400
X-Sasl-enc: P4RU6DmoQ6I19vPkWGS5CMkmkfPESPFqNEVPQhmxlds9 1341548772
Date: Thu, 5 Jul 2012 21:26:11 -0700
From: Greg KH <greg@kroah.com>
To: Jia Hongtao-B38951 <B38951@freescale.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: Re: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Message-ID: <20120706042611.GA1841@kroah.com>
References: <1339148585-16947-1-git-send-email-B38951@freescale.com>
 <4FD60FB1.7050106@gmail.com>
 <412C8208B4A0464FA894C5F0C278CD5D01A16829@039-SN1MPN1-002.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412C8208B4A0464FA894C5F0C278CD5D01A16829@039-SN1MPN1-002.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 02:05:05AM +0000, Jia Hongtao-B38951 wrote:
> Hi Rob and Greg KH,
> 
> Do you have any better idea to avoid duplication probe warning?

I have no idea what the problem is that you are trying to solve.

> > On 06/08/2012 04:43 AM, Jia Hongtao wrote:
> > > We changed the pcie controller driver to platform driver so that the
> > PCI
> > > of platform devices need to be created earlier in the arch_initcall
> > stage
> > > according to the original timing of calling fsl_add_bridge(). So we do
> > PCI
> > > probing separately from other devices. But probing more than once could
> > > cause duplication warning. We add check if the devices have already
> > probed
> > > before probing any devices to avoid duplication warning.

Ick, something else is going wrong here, how could you ever have the
same device probed more than once?

> > > Signed-off-by: Jia Hongtao <B38951@freescale.com>
> > > Signed-off-by: Li Yang <leoli@freescale.com>
> > > ---
> > 
> > Where's v1 and v2 history?
> > 
> > >  drivers/of/platform.c |   18 ++++++++++++------
> > >  1 files changed, 12 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > index a37330e..3aab01f 100644
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -139,6 +139,18 @@ struct platform_device *of_device_alloc(struct
> > device_node *np,
> > >  	if (!dev)
> > >  		return NULL;
> > >
> > > +	dev->dev.of_node = of_node_get(np);
> > > +	if (bus_id)
> > > +		dev_set_name(&dev->dev, "%s", bus_id);
> > > +	else
> > > +		of_device_make_bus_id(&dev->dev);
> > > +
> > > +	if (kset_find_obj(dev->dev.kobj.kset, kobject_name(&dev->dev.kobj)))

Whatever you are trying to do here, odds are, it's wrong :)

What is happening that is causing the problem?  What is causing the
platform core to be calling probe on a device more than once?

greg k-h

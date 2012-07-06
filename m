Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2GFGWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:22:50 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:9169
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932257Ab2GFGWr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:22:47 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2012 02:22:47 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VS-9(zzbb2dI98dI9371I1521I542M1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah107ahbe9i)
From: Jia Hongtao-B38951 <B38951@freescale.com>
To: Greg KH <greg@kroah.com>
CC: Rob Herring <robherring2@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Yang-R58472 <r58472@freescale.com>
Subject: RE: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Thread-Topic: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
Thread-Index: AQHNRV2d07XgG54zbUKKBQTDlvBob5b1mBOAgCYUJaCAAHvPgP//w6JA
Date: Fri, 6 Jul 2012 06:07:43 +0000
Message-ID: <412C8208B4A0464FA894C5F0C278CD5D01A168F2@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1339148585-16947-1-git-send-email-B38951@freescale.com>
 <4FD60FB1.7050106@gmail.com>
 <412C8208B4A0464FA894C5F0C278CD5D01A16829@039-SN1MPN1-002.039d.mgd.msft.net>
 <20120706042611.GA1841@kroah.com>
In-Reply-To: <20120706042611.GA1841@kroah.com>
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
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, July 06, 2012 12:26 PM
> To: Jia Hongtao-B38951
> Cc: Rob Herring; devicetree-discuss@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; Li Yang-R58472
> Subject: Re: [PATCH V3 5/6] Avoid duplicate probe for of platform devices
> 
> On Fri, Jul 06, 2012 at 02:05:05AM +0000, Jia Hongtao-B38951 wrote:
> > Hi Rob and Greg KH,
> >
> > Do you have any better idea to avoid duplication probe warning?
> 
> I have no idea what the problem is that you are trying to solve.
> 
> > > On 06/08/2012 04:43 AM, Jia Hongtao wrote:
> > > > We changed the pcie controller driver to platform driver so that
> the
> > > PCI
> > > > of platform devices need to be created earlier in the arch_initcall
> > > stage
> > > > according to the original timing of calling fsl_add_bridge(). So we
> do
> > > PCI
> > > > probing separately from other devices. But probing more than once
> could
> > > > cause duplication warning. We add check if the devices have already
> > > probed
> > > > before probing any devices to avoid duplication warning.
> 
> Ick, something else is going wrong here, how could you ever have the
> same device probed more than once?
> 
> > > > Signed-off-by: Jia Hongtao <B38951@freescale.com>
> > > > Signed-off-by: Li Yang <leoli@freescale.com>
> > > > ---
> > >
> > > Where's v1 and v2 history?
> > >
> > > >  drivers/of/platform.c |   18 ++++++++++++------
> > > >  1 files changed, 12 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> > > > index a37330e..3aab01f 100644
> > > > --- a/drivers/of/platform.c
> > > > +++ b/drivers/of/platform.c
> > > > @@ -139,6 +139,18 @@ struct platform_device *of_device_alloc(struct
> > > device_node *np,
> > > >  	if (!dev)
> > > >  		return NULL;
> > > >
> > > > +	dev->dev.of_node = of_node_get(np);
> > > > +	if (bus_id)
> > > > +		dev_set_name(&dev->dev, "%s", bus_id);
> > > > +	else
> > > > +		of_device_make_bus_id(&dev->dev);
> > > > +
> > > > +	if (kset_find_obj(dev->dev.kobj.kset, kobject_name(&dev-
> >dev.kobj)))
> 
> Whatever you are trying to do here, odds are, it's wrong :)
> 
> What is happening that is causing the problem?  What is causing the
> platform core to be calling probe on a device more than once?
> 
> greg k-h

This is why in some cases we may probe twice:
Firstly, we need to probe pci controller separately. But in KVM different
topology of device tree is used in which pci nodes are not under root node
but under "simple bus". Unfortunately, of_platform_bus_probe() will probe
all the first level nodes under "simple bus" so pci nodes will probe again.

Two ways to solve this problem:
1. All the nodes that need to be probed should just under root.
2. Avoid duplication probe at runtime like this patch did.

I do like the first one but it's hard to changing the traditional way that
exist for a long time.

Also, I think this patch as a workaround is not a perfect way to solve this
problem. So I wonder if you or others have any better solutions.

Thanks.
-Jia Hongtao. 



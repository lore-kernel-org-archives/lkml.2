Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab1ILMIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:08:46 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53061 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab1ILMIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:08:45 -0400
X-SpamScore: -17
X-BigFish: VS-17(zz9371K542M1432N98dKzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Sethi Varun-B16395 <B16395@freescale.com>
To: Joerg Roedel <joro@8bytes.org>, Greg KH <gregkh@suse.de>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Thread-Topic: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Thread-Index: AQHMbX1KEHbH2ksOTkK6XUaJZsZynZVCliAAgAAIzICABw2cQA==
Date: Mon, 12 Sep 2011 12:08:41 +0000
Message-ID: <F1FD01C1EFCE15408DBF59462450B3BD1C4658@039-SN1MPN1-006.039d.mgd.msft.net>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com>
 <1315410113-26608-3-git-send-email-joerg.roedel@amd.com>
 <20110907184750.GA920@suse.de> <20110907191919.GA31674@8bytes.org>
In-Reply-To: <20110907191919.GA31674@8bytes.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.134.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
> Behalf Of Joerg Roedel
> Sent: Thursday, September 08, 2011 12:49 AM
> To: Greg KH
> Cc: Joerg Roedel; iommu@lists.linux-foundation.org; Alex Williamson; Ohad
> Ben-Cohen; David Woodhouse; David Brown; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
> 
> Hi Greg,
> 
> the bus_set_iommu() function will be called by the IOMMU driver. There
> can be different drivers for the same bus, depending on the hardware. On
> PCI for example, there can be the Intel or the AMD IOMMU driver that
> implement the iommu-api and that register for that bus.
> 
> On Wed, Sep 07, 2011 at 11:47:50AM -0700, Greg KH wrote:
> > > +#ifdef CONFIG_IOMMU_API
> > > +int bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops) {
> > > +	if (bus->iommu_ops != NULL)
> > > +		return -EBUSY;
> >
> > Busy?
> 
> Yes, it signals to the IOMMU driver that another driver has already
> registered for that bus. In the previous register_iommu() interface this
> was just a BUG(), but I think returning an error to the caller is better.
> It can be turned back into a BUG() if it is considered better, though.
> 
> > > +
> > > +	bus->iommu_ops = ops;
> > > +
> > > +	/* Do IOMMU specific setup for this bus-type */
> > > +	iommu_bus_init(bus, ops);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(bus_set_iommu);
> >
> > I don't understand what this function is for, and who would call it.
> 
> It is called by the IOMMU driver.
> 
> > Please provide kerneldoc that explains this.
> 
> Will do.
> 
> > > @@ -67,6 +68,9 @@ extern void bus_remove_file(struct bus_type *,
> struct bus_attribute *);
> > >   * @resume:	Called to bring a device on this bus out of sleep mode.
> > >   * @pm:		Power management operations of this bus, callback
> the specific
> > >   *		device driver's pm-ops.
> > > + * @iommu_ops   IOMMU specific operations for this bus, used to
> attach IOMMU
> > > + *              driver implementations to a bus and allow the driver
> to do
> > > + *              bus-specific setup
> >
> > So why is this just not set by the bus itself, making the above
> > function not needed at all?
> 
> The IOMMUs are usually devices on the bus itself, so they are initialized
> after the bus is set up and the devices on it are populated.  So the
> function can not be called on bus initialization because the IOMMU is not
> ready at this point.
Well, at what point would the add_device_group (referring to patch set posted by Alex) call back be invoked?

-Varun



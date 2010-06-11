Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab0FKWTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:19:18 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:43712 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0FKWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:19:17 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,405,1272844800"; 
   d="scan'208";a="143377172"
From: Tom Lyon <pugs@lyon-about.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH V2] VFIO driver: Non-privileged user level PCI drivers
Date: Fri, 11 Jun 2010 15:15:53 -0700
User-Agent: KMail/1.9.9
Cc: randy.dunlap@oracle.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       chrisw@sous-sol.org, joro@8bytes.org, hjk@linutronix.de, avi@redhat.com,
       gregkh@suse.de, aafabbri@cisco.com, scofeldm@cisco.com
References: <4c0eb470.1HMjondO00NIvFM6%pugs@cisco.com> <201006081654.43967.pugs@lyon-about.com> <20100609054557.GB4940@redhat.com>
In-Reply-To: <20100609054557.GB4940@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006111515.53562.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inline comments are getting pretty hard to wade through, so I'm deleting some
of the lesser stuff - but I am incorporating into the code.

On Tuesday 08 June 2010 10:45:57 pm Michael S. Tsirkin wrote:
> On Tue, Jun 08, 2010 at 04:54:43PM -0700, Tom Lyon wrote:
> > On Tuesday 08 June 2010 03:38:44 pm Michael S. Tsirkin wrote:
> > > On Tue, Jun 08, 2010 at 02:21:52PM -0700, Tom Lyon wrote:
...
> > > > +		/* reset to known state if we can */
> > > > +		(void) pci_reset_function(vdev->pdev);
> > > 
> > > We are opening the device - how can it not be in a known state?
> > If an alternate driver left it in a weird state.
> 
> Don't we care if it fails then? I think we do ...
> > > And we should make sure (at open time) we *can* reset on close, fail binding if we can't.
> > How do you propose?
> 
> Fail open if reset fails on open?
OK, it'll now fail open if reset fails.

[ bunch of stuff about MSI-X checking and IOMMUs and config registers...]

OK, here's the thing.  The IOMMU API today does not do squat about dealing with
interrupts. Interrupts are special because the APIC  addresses are not each in 
their own page.  Yes, the IOMMU hardware supports it (at least Intel), and there's
some Intel intr remapping code (not AMD), but it doesn't look like it is enough.

Therefore, we must not allow the user level driver to diddle the MSI or MSI-X
areas - either in config space or in the device memory space.  If the device
doesn't have its MSI-X registers in nice page aligned areas, then it is not
"well-behaved" and it is S.O.L. The SR-IOV spec recommends that devices be
designed the well-behaved way.

When the code in vfio_pci_config speaks of "virtualization" it means that there
are fake registers which the user driver can read or write, but do not affect the
real registers. BARs are one case, MSI regs another. The PCI vendor and device
ID are virtual because SR-IOV doesn't supply them but I wanted the user driver
to find them in the same old place.

> > > > +	case VFIO_DMA_MASK:	/* set master mode and DMA mask */
> > > > +		if (copy_from_user(&mask, uarg, sizeof mask))
> > > > +			return -EFAULT;
> > > > +		pci_set_master(pdev);
> > > 
> > > This better be done by userspace when it sees fit.
> > > Otherwise device might corrupt userspace memory.
This ioctl is gone now - it was vestigial from the dma_sg_map interface.

[ Re: Hotplug and Suspend/Resume]
There are *plenty* of real drivers - brand new ones - which don't bother
with these today.  Yeah, I can see adding them to the framework someday -
but if there's no urgent need then it is way down the priority list. Meanwhile,
the other uses beckon.  And I never heard the Infiniband users complaining
about not having these things.


> > > > +	pages = kzalloc(npage * sizeof(struct page *), GFP_KERNEL);
> > > 
> > > If you map a 4G region, this will try to allocate 8Mbytes?
> > Yes. Ce la vie.
> 
> First of all, this will fail - and the request is quite real with
> decent sized guests. Second, with appropriately sized allocs before failing
> it will stress the system pretty hard. Split it in chunks of 4K or something.
Changed to use vmalloc/vfree - don't need physical contiguity.
 




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865Ab0FBLZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:25:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0FBLZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:25:51 -0400
Date: Wed, 2 Jun 2010 14:21:00 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602112100.GA29697@redhat.com>
References: <20100531171007.GA6516@redhat.com> <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602111224.GA11033@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 01:12:25PM +0200, Joerg Roedel wrote:
> On Wed, Jun 02, 2010 at 01:38:28PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 02, 2010 at 12:35:16PM +0200, Joerg Roedel wrote:
> 
> > > With the userspace interface a process can create io-page-faults
> > > anyway if it wants. We can't protect us from this.
> > 
> > We could fail all operations until an iommu is bound.  This will help
> > catch bugs with access before setup. We can not do this if a domain is
> > bound by default.
> 
> Even if it is bound to a domain the userspace driver could program the
> device to do dma to unmapped regions causing io-page-faults. The kernel
> can't do anything about it.

It can always corrupt its own memory directly as well :)
But that is not a reason not to detect errors if we can,
and not to make APIs hard to misuse.

> > > The second IOMMU_MAP ioctl is just to show that existing mappings would
> > > be destroyed if the device is assigned to another address space. Not
> > > strictly necessary. So we have two ioctls but save one call to create
> > > the iommu-domain.
> > 
> > With 10 devices you have 10 extra ioctls.
> 
> And this works implicitly with your proposal?

Yes.  so you do:
iommu = open
ioctl(dev1, BIND, iommu)
ioctl(dev2, BIND, iommu)
ioctl(dev3, BIND, iommu)
ioctl(dev4, BIND, iommu)

No need to add a SHARE ioctl.


> Remember that we still
> need to be able to provide seperate mappings for each device to support
> IOMMU emulation for the guest.

Generally not true. E.g. guest can enable iommu passthrough
or have domain per a group of devices.

> I think my proposal does not have any
> extra costs.

with my proposal we have 1 ioctl per device + 1 per domain.
with yours we have 2 ioctls per device is iommu is shared
and 1 if it is not shared.

as current apps share iommu it seems to make sense
to optimize for that.

> > > Because we express here that "dev2 shares the iommu mappings of dev1".
> > > Thats easy to remember.
> > 
> > they both share the mappings. which one gets the iommu
> > destroyed (breaking the device if it is now doing DMA)?
> 
> As I wrote the domain has a reference count and is destroyed only when
> it goes down to zero. This does not happen as long as a device is bound
> to it.
> 
> 	Joerg

We were talking about UNSHARE ioctl:
ioctl(dev1, UNSHARE, dev2)
Does it change the domain for dev1 or dev2?
If you make a mistake you get a hard to debug bug.

-- 
MST

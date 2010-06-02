Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0FBMip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab0FBMin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:38:43 -0400
Date: Wed, 2 Jun 2010 15:34:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602123417.GA29815@redhat.com>
References: <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com> <20100602121927.GA11162@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602121927.GA11162@8bytes.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 02:19:28PM +0200, Joerg Roedel wrote:
> On Wed, Jun 02, 2010 at 02:21:00PM +0300, Michael S. Tsirkin wrote:
> > On Wed, Jun 02, 2010 at 01:12:25PM +0200, Joerg Roedel wrote:
> 
> > > Even if it is bound to a domain the userspace driver could program the
> > > device to do dma to unmapped regions causing io-page-faults. The kernel
> > > can't do anything about it.
> > 
> > It can always corrupt its own memory directly as well :)
> > But that is not a reason not to detect errors if we can,
> > and not to make APIs hard to misuse.
> 
> Changing the domain of a device while dma can happen is the same type of
> bug as unmapping potential dma target addresses. We can't catch this
> kind of misuse.

you normally need device mapped to start DMA.
SHARE makes this bug more likely as you allow
switching domains: mmap could be done before switching.

> > > > With 10 devices you have 10 extra ioctls.
> > > 
> > > And this works implicitly with your proposal?
> > 
> > Yes.  so you do:
> > iommu = open
> > ioctl(dev1, BIND, iommu)
> > ioctl(dev2, BIND, iommu)
> > ioctl(dev3, BIND, iommu)
> > ioctl(dev4, BIND, iommu)
> > 
> > No need to add a SHARE ioctl.
> 
> In my proposal this looks like:
> 
> 
> dev1 = open();
> ioctl(dev2, SHARE, dev1);
> ioctl(dev3, SHARE, dev1);
> ioctl(dev4, SHARE, dev1);
> 
> So we actually save an ioctl.

I thought we had a BIND ioctl?

> > > Remember that we still need to be able to provide seperate mappings
> > > for each device to support IOMMU emulation for the guest.
> > 
> > Generally not true. E.g. guest can enable iommu passthrough
> > or have domain per a group of devices.
> 
> What I meant was that there may me multiple io-addresses spaces
> necessary for one process. I didn't want to say that every device
> _needs_ to have its own address space.
> 
> > > As I wrote the domain has a reference count and is destroyed only when
> > > it goes down to zero. This does not happen as long as a device is bound
> > > to it.
> > > 
> > > 	Joerg
> > 
> > We were talking about UNSHARE ioctl:
> > ioctl(dev1, UNSHARE, dev2)
> > Does it change the domain for dev1 or dev2?
> > If you make a mistake you get a hard to debug bug.
> 
> As I already wrote we would have an UNBIND ioctl which just removes a
> device from its current domain. UNBIND is better than UNSHARE for
> exactly the reason you pointed out above. I thought I stated that
> already.
> 
> 	Joerg

You undo SHARE with UNBIND?


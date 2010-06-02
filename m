Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0FBMTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 08:19:30 -0400
Received: from 8bytes.org ([88.198.83.132]:55041 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab0FBMT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 08:19:29 -0400
Date: Wed, 2 Jun 2010 14:19:28 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Tom Lyon <pugs@cisco.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602121927.GA11162@8bytes.org>
References: <4C04C085.1030107@redhat.com> <20100601095532.GA9178@redhat.com> <20100602094201.GC964@8bytes.org> <20100602095312.GA25335@redhat.com> <20100602101940.GG964@8bytes.org> <20100602102144.GD29023@redhat.com> <20100602103516.GI964@8bytes.org> <20100602103828.GF29023@redhat.com> <20100602111224.GA11033@8bytes.org> <20100602112100.GA29697@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602112100.GA29697@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 02:21:00PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jun 02, 2010 at 01:12:25PM +0200, Joerg Roedel wrote:

> > Even if it is bound to a domain the userspace driver could program the
> > device to do dma to unmapped regions causing io-page-faults. The kernel
> > can't do anything about it.
> 
> It can always corrupt its own memory directly as well :)
> But that is not a reason not to detect errors if we can,
> and not to make APIs hard to misuse.

Changing the domain of a device while dma can happen is the same type of
bug as unmapping potential dma target addresses. We can't catch this
kind of misuse.

> > > With 10 devices you have 10 extra ioctls.
> > 
> > And this works implicitly with your proposal?
> 
> Yes.  so you do:
> iommu = open
> ioctl(dev1, BIND, iommu)
> ioctl(dev2, BIND, iommu)
> ioctl(dev3, BIND, iommu)
> ioctl(dev4, BIND, iommu)
> 
> No need to add a SHARE ioctl.

In my proposal this looks like:


dev1 = open();
ioctl(dev2, SHARE, dev1);
ioctl(dev3, SHARE, dev1);
ioctl(dev4, SHARE, dev1);

So we actually save an ioctl.

> > Remember that we still need to be able to provide seperate mappings
> > for each device to support IOMMU emulation for the guest.
> 
> Generally not true. E.g. guest can enable iommu passthrough
> or have domain per a group of devices.

What I meant was that there may me multiple io-addresses spaces
necessary for one process. I didn't want to say that every device
_needs_ to have its own address space.

> > As I wrote the domain has a reference count and is destroyed only when
> > it goes down to zero. This does not happen as long as a device is bound
> > to it.
> > 
> > 	Joerg
> 
> We were talking about UNSHARE ioctl:
> ioctl(dev1, UNSHARE, dev2)
> Does it change the domain for dev1 or dev2?
> If you make a mistake you get a hard to debug bug.

As I already wrote we would have an UNBIND ioctl which just removes a
device from its current domain. UNBIND is better than UNSHARE for
exactly the reason you pointed out above. I thought I stated that
already.

	Joerg


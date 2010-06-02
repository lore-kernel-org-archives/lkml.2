Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab0FBSMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 14:12:38 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:51529 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932486Ab0FBSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 14:12:37 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,348,1272844800"; 
   d="scan'208";a="538877007"
From: Tom Lyon <pugs@lyon-about.com>
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Date: Wed, 2 Jun 2010 11:09:17 -0700
User-Agent: KMail/1.9.9
Cc: Joerg Roedel <joro@8bytes.org>, "Michael S. Tsirkin" <mst@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
References: <20100601095532.GA9178@redhat.com> <20100602121927.GA11162@8bytes.org> <20100602174615.GV8301@sequoia.sous-sol.org>
In-Reply-To: <20100602174615.GV8301@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006021109.17838.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 June 2010 10:46:15 am Chris Wright wrote:
> * Joerg Roedel (joro@8bytes.org) wrote:
> > On Wed, Jun 02, 2010 at 02:21:00PM +0300, Michael S. Tsirkin wrote:
> > > On Wed, Jun 02, 2010 at 01:12:25PM +0200, Joerg Roedel wrote:
> > 
> > > > Even if it is bound to a domain the userspace driver could program the
> > > > device to do dma to unmapped regions causing io-page-faults. The kernel
> > > > can't do anything about it.
> > > 
> > > It can always corrupt its own memory directly as well :)
> > > But that is not a reason not to detect errors if we can,
> > > and not to make APIs hard to misuse.
> > 
> > Changing the domain of a device while dma can happen is the same type of
> > bug as unmapping potential dma target addresses. We can't catch this
> > kind of misuse.
> > 
> > > > > With 10 devices you have 10 extra ioctls.
> > > > 
> > > > And this works implicitly with your proposal?
> > > 
> > > Yes.  so you do:
> > > iommu = open
> > > ioctl(dev1, BIND, iommu)
> > > ioctl(dev2, BIND, iommu)
> > > ioctl(dev3, BIND, iommu)
> > > ioctl(dev4, BIND, iommu)
> > > 
> > > No need to add a SHARE ioctl.
> > 
> > In my proposal this looks like:
> > 
> > 
> > dev1 = open();
> > ioctl(dev2, SHARE, dev1);
> > ioctl(dev3, SHARE, dev1);
> > ioctl(dev4, SHARE, dev1);
> > 
> > So we actually save an ioctl.
> 
> This is not any hot path, so saving an ioctl shouldn't be a consideration.
> Only important consideration is a good API.  I may have lost context here,
> but the SHARE API is limited to the vfio fd.  The BIND API expects a new
> iommu object.  Are there other uses for this object?  Tom's current vfio
> driver exposes a dma mapping interface, would the iommu object expose
> one as well?  Current interface is device specific DMA interface for
> host device drivers typically mapping in-flight dma buffers, and IOMMU
> specific interface for assigned devices typically mapping entire virtual
> address space.

Actually, it a domain object - which may be usable among iommus (Joerg?).
However, you can't really do the dma mapping with just the domain because
every device supports a different size address space as a master, i.e.,
the dma_mask.

And I don't know how kvm would deal with devices with varying dma mask support,
or why they'd be in the same domain.


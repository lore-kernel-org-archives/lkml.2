Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0FHV1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:27:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab0FHV1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:27:38 -0400
Date: Wed, 9 Jun 2010 00:22:48 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Avi Kivity <avi@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
       Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100608212248.GC21815@redhat.com>
References: <20100601095532.GA9178@redhat.com> <201006031441.38799.pugs@lyon-about.com> <20100606095450.GA26394@redhat.com> <201006071201.04418.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006071201.04418.pugs@lyon-about.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 12:01:04PM -0700, Tom Lyon wrote:
> On Sunday 06 June 2010 02:54:51 am Michael S. Tsirkin wrote:
> > On Thu, Jun 03, 2010 at 02:41:38PM -0700, Tom Lyon wrote:
> > > OK, in the interest of making progress, I am about to embark on the following:
> > > 
> > > 1. Create a user-iommu-domain driver - opening it will give a new empty domain.
> > >     Ultimately this can also populate sysfs with the state of its world, which would
> > >     also be a good addition to the base iommu stuff.
> > >     If someone closes the fd while in use, the domain stays valid anyway until users
> > >     drop off.
> > > 
> > > 2. Add DOMAIN_SET and DOMAIN_UNSET ioctls to the vfio driver.  Require that
> > >    a domain be set before using the VFIO_DMA_MAP_IOVA ioctl
> > 
> > Require domain to be set before you allow any access to the device:
> > mmap, write, read.  IMO this is the only safe way to make sure userspace
> > does not corrupt memory, and this removes the need to special-case
> > MSI memory, play with bus master enable and hope it can be cleared without
> > reset, etc.
> 
> Michael - the light bulb finally lit for me and I now understand what you've been
> saying the past few weeks.  Of course you're right - we need iommu set before any
> register access.  I had thought that was done by default but now I see that the 
> dma_map_sg routine only attaches to the iommu on demand.
> 
> So I will torpedo the MAP_ANYWHERE stuff. I'd like to keep the MAP_IOVA ioctl
> with the vfio fd so that the user can still do everything with one fd. I'm thinking the
> fd opens and iommu bindings could be done in a program before spinning out the
> program with the user driver.

This would kind of break Avi's idea that mappings are programmed
at the domain and shared by multiple devices, won't it?

> > 
> > > (this is the one
> > >    that KVM wants).
> > 
> > Not sure I understand. I think that MAP should be done on the domain,
> > not the device, this handles pinning pages correctly and
> > this way you don't need any special checks.
> > 
> > >    However, the VFIO_DMA_MAP_ANYWHERE ioctl is the one
> > >    which uses the dma_sg interface which has no expicit control of domains. I
> > >    intend to keep it the way it is, but expect only non-hypervisor programs would
> > >    want to use it.
> > 
> > If we support MAP_IOVA, why is MAP_ANYWHERE useful? Can't
> > non-hypervisors just pick an address?
> > 
> > > 3. Clean up the docs and other nits that folks have found.
> > > 
> > > Comments? 
> > 
> 

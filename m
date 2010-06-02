Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0FBFaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:30:10 -0400
Received: from sous-sol.org ([216.99.217.87]:59298 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128Ab0FBFaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:30:08 -0400
Date: Tue, 1 Jun 2010 22:29:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Avi Kivity <avi@redhat.com>
Cc: Tom Lyon <pugs@lyon-about.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, chrisw@sous-sol.org,
       joro@8bytes.org, hjk@linutronix.de, gregkh@suse.de, aafabbri@cisco.com,
       scofeldm@cisco.com, alex.williamson@redhat.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602052907.GT8301@sequoia.sous-sol.org>
References: <20100530124949.GI27611@redhat.com>
 <4C04E0E0.3070006@redhat.com>
 <20100601104651.GA9415@redhat.com>
 <201006011426.53563.pugs@lyon-about.com>
 <4C05C925.6080006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C05C925.6080006@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity (avi@redhat.com) wrote:
> On 06/02/2010 12:26 AM, Tom Lyon wrote:
> >
> >I'm not really opposed to multiple devices per domain, but let me point out how I
> >ended up here.  First, the driver has two ways of mapping pages, one based on the
> >iommu api and one based on the dma_map_sg api.  With the latter, the system
> >already allocates a domain per device and there's no way to control it. This was
> >presumably done to help isolation between drivers.  If there are multiple drivers
> >in the user level, do we not want the same isoation to apply to them?
> 
> In the case of kvm, we don't want isolation between devices, because
> that doesn't happen on real hardware.

Sure it does.  That's exactly what happens when there's an iommu
involved with bare metal.

> So if the guest programs
> devices to dma to each other, we want that to succeed.

And it will as long as ATS is enabled (this is a basic requirement
for PCIe peer-to-peer traffic to succeed with an iommu involved on
bare metal).

That's how things currently are, i.e. we put all devices belonging to a
single guest in the same domain.  However, it can be useful to put each
device belonging to a guest in a unique domain.  Especially as qemu
grows support for iommu emulation, and guest OSes begin to understand
how to use a hw iommu.

> >Also, domains are not a very scarce resource - my little core i5 has 256,
> >and the intel architecture goes to 64K.
> 
> But there is a 0.2% of mapped memory per domain cost for the page
> tables.  For the kvm use case, that could be significant since a
> guest may have large amounts of memory and large numbers of assigned
> devices.
> 
> >And then there's the fact that it is possible to have multiple disjoint iommus on a system,
> >so it may not even be possible to bring 2 devices under one domain.
> 
> That's indeed a deficiency.

Not sure it's a deficiency.  Typically to share page table mappings
across multiple iommu's you just have to do update/invalidate to each
hw iommu that is sharing the mapping.  Alternatively, you can use more
memory and build/maintain identical mappings (as Tom alludes to below).

> >Given all that, I am inclined to leave it alone until someone has a real problem.
> >Note that not sharing iommu domains doesn't mean you can't share device memory,
> >just that you have to do multiple mappings
> 
> I think we do have a real problem (though a mild one).
> 
> The only issue I see with deferring the solution is that the API
> becomes gnarly; both the kernel and userspace will have to support
> both APIs forever.  Perhaps we can implement the new API but defer
> the actual sharing until later, don't know how much work this saves.
> Or Alex/Chris can pitch in and help.

It really shouldn't be that complicated to create the API to allow for
flexible device <-> domain mappings, so I agree, makes sense to do it
right up front.

thanks,
-chris

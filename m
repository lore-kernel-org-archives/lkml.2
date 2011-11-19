Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab1KSTSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 14:18:12 -0500
Received: from sous-sol.org ([216.99.217.87]:55764 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138Ab1KSTSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 14:18:09 -0500
Date: Sat, 19 Nov 2011 11:17:44 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, rajesh.sankaran@intel.com,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chrisw@sous-sol.org, ddutile@redhat.com
Subject: Re: [PATCH] intel-iommu: Manage iommu_coherency globally
Message-ID: <20111119191744.GA3344@sequoia.sous-sol.org>
References: <20111116040752.11878.18642.stgit@bling.home>
 <1321617817.15493.33.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1321617817.15493.33.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> On Tue, 2011-11-15 at 21:11 -0700, Alex Williamson wrote:
> > We currently manage iommu_coherency on a per domain basis,
> > choosing the safest setting across the iommus attached to a
> > particular domain.  This unfortunately has a bug that when
> > no iommus are attached, the domain defaults to coherent.
> > If we fall into this mode, then later add a device behind a
> > non-coherent iommu to that domain, the context entry is
> > updated using the wrong coherency setting, and we get dmar
> > faults.
> > 
> > Since we expect chipsets to be consistent in their coherency
> > setting, we can instead determine the coherency once and use
> > it globally. 
> 
> (Adding Rajesh).
> 
> Hm, it seems I lied to you about this. The non-coherent mode isn't just
> a historical mistake; it's configurable by the BIOS, and we actually
> encourage people to use the non-coherent mode because it makes the
> hardware page-walk faster — so reduces the latency for IOTLB misses.

Interesting because for the workloads I've tested it's the exact opposite.
Tested w/ BIOS enabling and disabling coherency, and w/ non-coherent
access and streaming DMA (i.e. bare metal NIC bw testing)...the IOMMU
added smth like 10% when non-coherent vs. coherent.

> In addition to that, the IOMMU associated with the integrated graphics
> is so "special" that it doesn't support coherent mode either. So it *is*
> quite feasible that we'll see a machine where some IOMMUs support
> coherent mode, and some don't.
> 
> And thus we do need to address the concern that just assuming
> non-coherent mode will cause unnecessary performance issues, for the
> case where a domain *doesn't* happen to include any of the non-coherent
> IOMMUs.
> 
> However... for VM domains I don't think we care. Setting up the page
> tables *isn't* a fast path there (at least not until/unless we support
> exposing an emulated IOMMU to the guest).
> 
> The case we care about is *native* DMA, where this cache flush will be
> happening for example in the fast path of network TX/RX. But in *that*
> case, there is only *one* IOMMU to worry about so it's simple enough to
> do the right thing, surely?

Definitely agreed on the above points, limited page table setup/teardown
to VMs and bare metal case is sensitive to IOMMU overhead of flushing.

thanks,
-chris

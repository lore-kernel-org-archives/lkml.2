Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2G3PUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 11:20:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33574 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2G3PUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 11:20:09 -0400
Date: Mon, 30 Jul 2012 11:10:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/swiotlb: If iommu=soft was not
 passed in on > 4GB, don't turn it on.
Message-ID: <20120730151008.GA4547@phenom.dumpdata.com>
References: <1343335407-5465-1-git-send-email-konrad.wilk@oracle.com>
 <1343335407-5465-2-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1207271204500.26163@kaball.uk.xensource.com>
 <20120727175546.GH17427@andromeda.dapyr.net>
 <alpine.DEB.2.02.1207301551250.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207301551250.4645@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 03:58:02PM +0100, Stefano Stabellini wrote:
> On Fri, 27 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jul 27, 2012 at 12:06:27PM +0100, Stefano Stabellini wrote:
> > > On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > > If we boot a 64-bit guest with more than 4GB memory, the SWIOTLB
> > > > gets turned on:
> > > > PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> > > > software IO TLB [mem 0xfb43d000-0xff43cfff] (64MB) mapped at [ffff8800fb43d000-ffff8800ff43cfff]
> > > > 
> > > > which is OK if we had PCI devices, but not if we did not. In a PV
> > > > guest the SWIOTLB ends up asking the hypervisor for precious lowmem
> > > > memory - and 64MB of it per guest. On a 32GB machine, this limits the
> > > > amount of guests that are 4GB to start due to lowmem exhaustion.
> > > > 
> > > > What we do is detect whether the user supplied e820_hole=1
> > > > parameter, which is used to construct an E820 that is similar to
> > > > the machine  - so that the PCI regions do not overlap with RAM regions.
> > > > We check for that by looking at the E820 and seeing if it diverges
> > > > from the standard - and if so (and if iommu=soft was not turned on),
> > > > we disable the check pci_swiotlb_detect_4gb code.
> > > 
> > > What kind of paramter is it?
> > > Is it a Linux cmdline paramter? Or maybe a Xen toolstack parameter?
> > 
> > Its a guest config option.
> 
> Is this option turned on by default if the VM config file contains one
> or more PCI devices statically assigned to the VM?

I think we debated it at some point but never came to agreement. I did
showed that it would not negativly impact older guests - except that
they would lose some big swaths of memory (they don't do the release
memory pages for E820 I/O regions).
> 
> If this option is not specified, is it going to be impossible to
> dynamically passthrough a PCI devices after the VM is booted?

Well, so I thought about this over the weekend and cooked up some new
patches that turn Xen-SWIOTLB on (if it hasn't been turned on) when
Xen PCI detectes that there are some dvices to be passed in. Testing it now.

> 
> 
> > > Surely there must be a better way to let Linux know if this paramter has
> > > been turned on than looking for ACPI entries in the E820.
> > 
> > I am all open for suggestions. The best way I can think of is to have
> > some early_init variant of XenBus-detect-this-backend-parameter. Can
> > one unhook an "old" XenBus and reset with the full-fledged XenBus
> > init later on?
> 
> Assuming that the xen swiotlb is only useful for PCI passthrough devices
> in PV guests, we could write few wrappers for the current xen_swiotlb
> functions like this:
> 
> xen_swiotlb_alloc_coherent_new(..)
> {
>     if (xen_initial_domain() || (xen_pv_domain() && a_pci_device_is_assigned()))
>         xen_swiotlb_alloc_coherent();
>     else
>         return __get_free_pages();
> }
> 
> do you think it would work?
> This way it would be far more flexible.

So I had a brain-fart when I wrote these patches. When a PV guest is booted
with more than 4GB, the SWIOTLB that gets turned on is the *native* one.
Not the XenSWIOTLB. The impact is that we dont' do any of the swizzle of memory
below 4GB, but instead jus end up wasting 64MB in a PV guest.

The fix for that is actually pretty simple:

>From c5846a207249d7c072dccbec6850e5dbf0971c40 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 27 Jul 2012 20:16:00 -0400
Subject: [PATCH 7/9] xen/swiotlb: With more than 4GB on 64-bit, disable the
 native SWIOTLB.

If a PV guest is booted the native SWIOTLB should not be
turned on. It does not help us (we don't have any PCI devices)
and it eats 64MB of good memory. In the case of PV guests
with PCI devices we need the Xen-SWIOTLB one.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index b6a5340..2f8cc57 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -8,6 +8,11 @@
 #include <xen/xen.h>
 #include <asm/iommu_table.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/iommu.h>
+#include <asm/dma.h>
+#endif
+
 int xen_swiotlb __read_mostly;
 
 static struct dma_map_ops xen_swiotlb_dma_ops = {
@@ -49,6 +54,14 @@ int __init pci_xen_swiotlb_detect(void)
 	 * the 'swiotlb' flag is the only one turning it on. */
 	swiotlb = 0;
 
+#ifdef CONFIG_X86_64
+	/* pci_swiotlb_detect_4gb turns native SWIOTLB if no_iommu == 0
+ 	 * (so no iommu=X command line over-writes). So disable the native
+ 	 * SWIOTLB. */
+	if (max_pfn > MAX_DMA32_PFN)
+		no_iommu = 1;
+#endif
 	return xen_swiotlb;
 }
 
-- 
1.7.7.6


The next part is to deal with the user forgetting to pass in 'iommu=soft'
when doing PCI passthrough for a PV guest. This "forgetting" part is quite
annoying since it seems to happen to me all the time so I think that users
are more likely to forget it too.


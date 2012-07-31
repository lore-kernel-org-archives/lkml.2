Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2GaSlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:41:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:27619 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2GaSlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:41:19 -0400
Date: Tue, 31 Jul 2012 14:25:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 2/5] xen/swiotlb: With more than 4GB on
 64-bit, disable the native SWIOTLB.
Message-ID: <20120731182551.GA1559@phenom.dumpdata.com>
References: <1343743223-30092-1-git-send-email-konrad.wilk@oracle.com>
 <1343743223-30092-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1207311542520.4645@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1207311542520.4645@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:46:04PM +0100, Stefano Stabellini wrote:
> On Tue, 31 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > If a PV guest is booted the native SWIOTLB should not be
> > turned on. It does not help us (we don't have any PCI devices)
> > and it eats 64MB of good memory. In the case of PV guests
> > with PCI devices we need the Xen-SWIOTLB one.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/xen/pci-swiotlb-xen.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> > index b6a5340..0d5a214 100644
> > --- a/arch/x86/xen/pci-swiotlb-xen.c
> > +++ b/arch/x86/xen/pci-swiotlb-xen.c
> > @@ -8,6 +8,11 @@
> >  #include <xen/xen.h>
> >  #include <asm/iommu_table.h>
> >  
> > +#ifdef CONFIG_X86_64
> > +#include <asm/iommu.h>
> > +#include <asm/dma.h>
> > +#endif
> > +
> >  int xen_swiotlb __read_mostly;
> >  
> >  static struct dma_map_ops xen_swiotlb_dma_ops = {
> > @@ -49,6 +54,13 @@ int __init pci_xen_swiotlb_detect(void)
> >  	 * the 'swiotlb' flag is the only one turning it on. */
> >  	swiotlb = 0;
> >  
> > +#ifdef CONFIG_X86_64
> > +	/* pci_swiotlb_detect_4gb turns native SWIOTLB if no_iommu == 0
> > +	 * (so no iommu=X command line over-writes). So disable the native
> > +	 * SWIOTLB. */
> 
> Maybe rewording it would be a good idea:
> 
> /* pci_swiotlb_detect_4gb turns on native SWIOTLB if no_iommu == 0
>  * (so no iommu=X command line over-writes).
>  * Considering that PV guests don't normally have PCI devices it is not
>  * useful to us so we set no_iommu to 1 here */
> 







commit 21ef55f4ab2b6d63eb0ed86abbc959d31377853b
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Jul 27 20:16:00 2012 -0400

    xen/swiotlb: With more than 4GB on 64-bit, disable the native SWIOTLB.
    
    If a PV guest is booted the native SWIOTLB should not be
    turned on. It does not help us (we don't have any PCI devices)
    and it eats 64MB of good memory. In the case of PV guests
    with PCI devices we need the Xen-SWIOTLB one.
   
    [v1: Rewrite comment per Stefano's suggestion] 
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index b6a5340..1c17227 100644
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
@@ -49,6 +54,15 @@ int __init pci_xen_swiotlb_detect(void)
 	 * the 'swiotlb' flag is the only one turning it on. */
 	swiotlb = 0;
 
+#ifdef CONFIG_X86_64
+	/* pci_swiotlb_detect_4gb turns on native SWIOTLB if no_iommu == 0
+	 * (so no iommu=X command line over-writes).
+	 * Considering that PV guests do not want the *native SWIOTLB* but
+	 * only Xen SWIOTLB it is not useful to us so set no_iommu=1 here.
+	 */
+	if (max_pfn > MAX_DMA32_PFN)
+		no_iommu = 1;
+#endif
 	return xen_swiotlb;
 }
 

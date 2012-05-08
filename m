Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2EHSaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:30:23 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:45485 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab2EHSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:30:21 -0400
Date: Tue, 8 May 2012 14:24:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] auto balloon initial domain and fix
 dom0_mem=X inconsistencies (v5).
Message-ID: <20120508182419.GA9888@phenom.dumpdata.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
 <20120501163707.GA8741@phenom.dumpdata.com>
 <4FA27084.4030005@citrix.com>
 <4FA2A11E.1060907@cantab.net>
 <4FA2B1EF.8080900@citrix.com>
 <20120507184808.GA7249@phenom.dumpdata.com>
 <4FA96202.9010503@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA96202.9010503@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 07:12:18PM +0100, David Vrabel wrote:
> On 07/05/12 19:48, Konrad Rzeszutek Wilk wrote:
> > On Thu, May 03, 2012 at 05:27:27PM +0100, David Vrabel wrote:
> >> On 03/05/12 16:15, David Vrabel wrote:
> >>>
> >>> xen: update VA mapping when releasing memory during setup
> >>>
> >>> In xen_memory_setup(), if a page that is being released has a VA
> >>> mapping this must also be updated.  Otherwise, the page will be not
> >>> released completely -- it will still be referenced in Xen and won't be
> >>> freed util the mapping is removed and this prevents it from being
> >>> reallocated at a different PFN.
> >>>
> >>> This was already being done for the ISA memory region in
> >>> xen_ident_map_ISA() but on many systems this was omitting a few pages
> >>> as many systems marked a few pages below the ISA memory region as
> >>> reserved in the e820 map.
> >>>
> >>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> >>> ---
> >> [...]
> >>> --- a/arch/x86/xen/mmu.c
> >>> +++ b/arch/x86/xen/mmu.c
> >>> @@ -1929,29 +1929,6 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
> >>>  #endif
> >>>  }
> >>>  
> >>> -void __init xen_ident_map_ISA(void)
> >>> -{
> >>> -	unsigned long pa;
> >>> -
> >>> -	/*
> >>> -	 * If we're dom0, then linear map the ISA machine addresses into
> >>> -	 * the kernel's address space.
> >>> -	 */
> >>> -	if (!xen_initial_domain())
> >>> -		return;
> >>
> >> It might look like this test has gone, however the new code which
> >> updates the VA mapping uses the e820 map and for a domU its map will not
> >> have a ISA region so there's no mapping to be updated.
> > 
> > What if you use e820_hole=1 and the pci=xx in the guest?
> 
> Are these xl configuration options? I'm not familiar with xl.

Yeah. Just have this in your guest config:

e820_hole=1
pci=["01:00.0"]

(And do the PCI bind/unbind to the xen-pciback module)

but looking at the source there is this comment:
/* Weed out anything under 1MB */

so I think we are fine.

> 
> The PCI memory hole should be above 3 GiB so this hole will be will
> above the memory that will be initially mapped at boot.
> 
> I've not managed to persuade my test box to passthrough a PCI device to
> a guest (using xapi as the toolstack) to confirm, though.  I'll have
> another go tomorrow.
> 
> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel

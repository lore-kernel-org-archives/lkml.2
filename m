Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1EQRs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 13:48:57 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:50769 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab1EQRs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 13:48:56 -0400
X-IronPort-AV: E=Sophos;i="4.65,226,1304294400"; 
   d="scan'208";a="5807625"
Date: Tue, 17 May 2011 18:50:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Xen MMU's requirement to pin pages RO and
 initial_memory_mapping.
In-Reply-To: <20110516154132.GA12486@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1105171745300.12963@kaball-desktop>
References: <20110513153010.GB16519@dumpdata.com> <alpine.DEB.2.00.1105131650550.8972@kaball-desktop> <20110516154132.GA12486@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Konrad Rzeszutek Wilk wrote:
> > They become pagetable pages when:
> > 
> > - they are explicitly pinned by pin_pagetable_pfn
> > 
> > - they are hooked into the current pagetable
> 
> Ok, so could we use those two calls to trigger the pagetable walk
> and mark them RO as appropiate? Which call sites are those? The
> xen_set_pgd/xen_set_pud/xen_set_pmd ?

xen_alloc_pte_init and xen_alloc_pmd_init are the ones that mark the
pagetable pages RO and pin them, calling make_lowmem_page_readonly and
pin_pagetable_pfn.

alloc_pte/pmd are called right before hooking them into the pagetable;
unfortunately that means that they fail at marking the pagetable pages
RO: make_lowmem_page_readonly uses lookup_address to find the pte
corresponding to a page, however at this point the pagetable pages are
not mapped yet (usually they are not hooked but when they are hooked, the
upper level pagetable page is not hooked), so lookup_address fails.

In order to catch these errors Xen has a parachute: xen_set_pte_init,
the function that takes care of writing a pte to memory and that on xen
converts pfns to mfns, also marks pagetable pages RO trying to
understand when that is appropriate.

This is all very ugly and delicate.

I think alloc_pte/pmd were always thought to be used to mark and pin
pagetable pages but they currently fail during the initial pagetable
setup. If we could fix alloc_pte/pmd most of the problems and the hacks
would go away.
Ideally we could remove both mask_rw_pte (currently responsible for
marking pagetable pages RO, called from xen_set_pte_init) and
x86_init.mapping.pagetable_reserve.

More thinking (and caffeine) needed...




> Presumarily we don't have
> to do that for the PTE's that are already mapped (as
> xen_setup_kernel_pagetable, and xen_map_identity_early do this
> already).

No, we don't.
We do need to make sure they stay RO on x86_32 where we write the
pagetable pages in two steps and we switch pagetable to swapper_pg_dir.

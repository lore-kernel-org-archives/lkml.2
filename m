Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2HXR2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:28:10 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:45874 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2HXR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:28:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,304,1344211200"; 
   d="scan'208";a="14173976"
Date: Fri, 24 Aug 2012 18:27:41 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Attilio Rao <attilio.rao@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <alpine.LFD.2.02.1208241719030.2856@ionos>
Message-ID: <alpine.DEB.2.02.1208241653550.15568@kaball.uk.xensource.com>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com> <alpine.LFD.2.02.1208241446090.2856@ionos> <alpine.DEB.2.02.1208241412040.15568@kaball.uk.xensource.com>
 <alpine.LFD.2.02.1208241719030.2856@ionos>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Thomas Gleixner wrote:
> On Fri, 24 Aug 2012, Stefano Stabellini wrote:
> > On Fri, 24 Aug 2012, Thomas Gleixner wrote:
> > > I looked at the whole pgt_buf_* mess and it's amazingly stupid. We
> > > could avoid all that dance and make all of that pgt_buf_* stuff static
> > > and provide proper accessor functions and hand start, end, top to the
> > > reserve function instead of fiddling with global variables all over
> > > the place. That'd be a real cleanup and progress.
> > > 
> > > But we can't do that easily. And why? Because XEN is making magic
> > > decisions based on those globals in mask_rw_pte().
> > > 
> > > 	/*
> > > 	 * If the new pfn is within the range of the newly allocated
> > > 	 * kernel pagetable, and it isn't being mapped into an
> > > 	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> > > 	 * it is RO.
> > > 	 */
> > > 	if (((!is_early_ioremap_ptep(ptep) &&
> > > 			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
> > > 			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
> > > 
> > > This comment along with the implementation is really a master piece of
> > > obfuscation. Let's see what this is doing. RO is enforced when:
> > > 
> > > This is not an early ioreamp AND
> > > 
> > >       pfn >= pgt_buf_start && pfn < pgt_buf_top
> > > 
> > > So why is this checking pgt_buf_top? The early stuff is installed
> > > within pgt_buf_start and pgt_buf_end. Anything which is >=
> > > pgt_buf_end at this point is completely wrong.
> > 
> > Unfortunately pgt_buf_end only marks the current end of the pagetable
> > pages (pgt_buf_end keeps increasing during
> > kernel_physical_mapping_init).  However at some point
> > kernel_physical_mapping_init is going to start mapping the pagetable
> > pages themselves, when that happens some of them are not pagetable pages
> > yet (pgt_buf_end <= page < pgt_buf_top) but they are going to be in the
> > near future.
> 
> And how exactly are they allocated between from pgt_buf w/o increasing
> pgt_buf_end ?

They do increase pgt_buf_end when they are allocated, but the entire
[pgt_buf_start - pgt_buf_top) range might already be mapped at that point
as normal memory that falls in the range of addresses passed to
init_memory_mapping as argument.

This is an extract from the commit message of
279b706bf800b5967037f492dbe4fc5081ad5d0f:

--- 

As a consequence of the commit:

commit 4b239f458c229de044d6905c2b0f9fe16ed9e01e
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Dec 17 16:58:28 2010 -0800

    x86-64, mm: Put early page table high

at some point init_memory_mapping is going to reach the pagetable pages
area and map those pages too (mapping them as normal memory that falls
in the range of addresses passed to init_memory_mapping as argument).
Some of those pages are already pagetable pages (they are in the range
pgt_buf_start-pgt_buf_end) therefore they are going to be mapped RO and
everything is fine.
Some of these pages are not pagetable pages yet (they fall in the range
pgt_buf_end-pgt_buf_top; for example the page at pgt_buf_end) so they
are going to be mapped RW.  When these pages become pagetable pages and
are hooked into the pagetable, xen will find that the guest has already
a RW mapping of them somewhere and fail the operation.
The reason Xen requires pagetables to be RO is that the hypervisor needs
to verify that the pagetables are valid before using them. The validation
operations are called "pinning" (more details in arch/x86/xen/mmu.c).

---

So let's suppose that we change the check in mask_rw_pte to be:

pfn >= pgt_buf_start && pfn < pgt_buf_end

as it was originally. This is what could happen:

1) pgt_buf_start - pgt_buf_end gets mapped RO;
2) pgt_buf_end - pgt_buf_top gets mapped RW;
3) a new pagetable page is allocated, pgt_buf_end is increased;
4) this new pagetable page is hooked into the pagetable;
5) since a mapping of this page already exists (it was done in
   point 2), and this mapping is RW, Linux crashes.


Thanks for taking the time to look into this issue. I know it is
difficult and not very pleasant.

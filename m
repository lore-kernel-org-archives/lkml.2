Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab1ATVIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:08:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37880 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab1ATVIl convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 20 Jan 2011 16:08:41 -0500
Date: Thu, 20 Jan 2011 16:04:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kees Cook <kees.cook@canonical.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "keir.fraser@eu.citrix.com" <keir.fraser@eu.citrix.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "sliakh.lkml@gmail.com" <sliakh.lkml@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "ak@muc.de" <ak@muc.de>, "davej@redhat.com" <davej@redhat.com>,
        "jiang@cs.ncsu.edu" <jiang@cs.ncsu.edu>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110120210436.GA1810@dumpdata.com>
References: <20110111233135.GL4979@outflux.net>
 <20110114201530.GA14339@dumpdata.com>
 <20110119211432.GA20535@dumpdata.com>
 <20110119235957.6ea35dc8@mat-laptop>
 <20110119233824.GA2869@dumpdata.com>
 <1295522306.4d381a02b1e10@imp.free.fr>
 <20110120150618.GC5092@dumpdata.com>
 <1295537856.14780.54.camel@zakaz.uk.xensource.com>
 <20110120190531.GA9687@dumpdata.com>
 <4D3899AB.60207@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D3899AB.60207@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 09:23:07PM +0100, matthieu castet wrote:
> Konrad Rzeszutek Wilk a écrit :
> >On Thu, Jan 20, 2011 at 03:37:36PM +0000, Ian Campbell wrote:
> >>On Thu, 2011-01-20 at 15:06 +0000, Konrad Rzeszutek Wilk wrote:
> >>>On Thu, Jan 20, 2011 at 12:18:26PM +0100, castet.matthieu@free.fr wrote:
> >>>>Quoting Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> >>>>
> >>>>>On Wed, Jan 19, 2011 at 11:59:57PM +0100, matthieu castet wrote:
> >>>>>>Le Wed, 19 Jan 2011 16:14:32 -0500,
> >>>>>>Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> a écrit :
> >>>>>>>>>I was just shown this[1] on Xen from an Ubuntu bug report[2].
> >>>>>>>>>
> >>>>>>>>>[    1.230382] NX-protecting the kernel data: 3884k
> >>>>>>>>>[    1.231002] BUG: unable to handle kernel paging request at
> >>>>>>>>>c1782ae0 ...
> >>>>>>>>>[    1.231145] Call Trace:
> >>>>>>>>>[    1.231152]  [<c0138481>] ? __change_page_attr+0x2c1/0x370
> >>>>>>>>>[    1.231161]  [<c02163a1>] ? __purge_vmap_area_lazy+0xc1/0x180
> >>>>>>>>>[    1.231169]  [<c013857c>] ?
> >>>>>>>>>__change_page_attr_set_clr+0x4c/0xb0 [    1.231176]
> >>>>>>>>>[<c0138838>] ? change_page_attr_set_clr+0x128/0x300
> >>>>>>>>>[    1.231183]  [<c010798e>] ?
> >>>>>>>>>__raw_callee_save_xen_restore_fl+0x6/0x8 [    1.231192]
> >>>>>>>>>[<c0159ca1>] ? vprintk+0x171/0x3f0 [    1.231198]  [<c0138bdf>] ?
> >>>>>>>>>set_memory_nx+0x5f/0x70
> >>>>>>>>If you run it with Xen debugging enabled:
> >>>>>>>>
> >>>>>>>>[    7.753329] NX-protecting the kernel data: 2400k
> >>>>>>>>(XEN) mm.c:2389:d0 Bad type (saw 3c000003 != exp 70000000) for mfn
> >>>>>>this happen if (x & (PGT_type_mask|PGT_pae_xen_l2)) != type)
> >>>>>>
> >>>>>>but
> >>>>>>#define PGT_type_mask       (7U<<29) /* Bits 29-31. */
> >>>>>>#define _PGT_pae_xen_l2     26
> >>>>>>#define PGT_pae_xen_l2      (1U<<_PGT_pae_xen_l2)
> >>>>>>
> >>>>>>but (exp type = 0x70000000) & (PGT_type_mask|PGT_pae_xen_l2) =
> >>>>>>0x60000000
> >>>>>>
> >>>>>>So the exp type look strange.
> >>>>>>#define _PGT_pinned         28
> >>>>>>#define PGT_pinned          (1U<<_PGT_pinned)
> >>>>>>
> >>>>>>>>1355a5 (pfn 15a5) (XEN) mm.c:889:d0 Error getting mfn 1355a5 (pfn
> >>>>>>>>15a5) from L1 entry 80000001355a5063 for l1e_owner=0, pg_owner=0
> >>>>>>>>(XEN) mm.c:4958:d0 ptwr_emulate: could not get_page_from_l1e()
> >>>>>>>>[    7.759087] BUG: unable to handle kernel paging request at
> >>>>>>>>c82a4d28 [    7.759087] IP: [<c100608c>]
> >>>>>>>>xen_set_pte_atomic+0x21/0x2f [    7.759087] *pdpt =
> >>>>>>>>0000000001663001 *pde = 00000000082db067 *pte = 80000000082a4061 ..
> >>>>>>>>and same stack trace.
> >>>>>>>>
> >>>>>>>>>
> >>>>>>>>>Does Xen have different size page table allocations or something
> >>>>>>>>>weird?
> >>>>>>>>The same page size. Not sure actually why it is being triggered.
> >>>>>>>>Let me copy Keir on this. Keir, the region that is being marked as
> >>>>>>>>_NX is .bss one and
> >>>>>>>_past_ the __init_end it dies. Any ideas?
> >>>>>>>
> >>>>>>Does this happen if you add ". = ALIGN(HPAGE_SIZE);" before bss section
> >>>>>>in arch/x86/kernel/vmlinux.lds.S ?
> >>>>>Like this?
> >>>>Yes
> >>>>>yeeeey...That made it boot.
> >>>>>
> >>>>>>What's the output of kernel_page_tables debugfs ?
> >>>>>Shees.. I get
> >>>>>
> >>>>>[   73.723105] BUG: unable to handle kernel paging request at 15555000
> >>>>[...]
> >>>>>with the patch and if I revert 5bd5a452662bc37c54fb6828db1a3faf87e6511c..
> >>>>>
> >>>>>That looks to be another bug to hunt down.
> >>>>>
> >>>>No that the same bug : that the root cause.
> >>>>
> >>>>For some reason with xen, accessing some page tables (bss and after) make the
> >>>>system crash.
> >>>I think I know the failure in the first case - the swapper_pg_dir is marked as _RO
> >>>and you are not suppose to make it _RW (unless you first do a bit of dance and switch
> >>>over to another pagetable). The reason being that Xen has a symbiotic relationship
> >>>with PV domains where pagetables are marked _RO so that any update to
> >>>it will go through Xen so it can validate that we aren't doing anything stupid.
> >>>
> >>>But accessing the page table should be OK, not sure why it crashed - we
> >>>aren't writting anything to it - just reading.
> >>>
> >>>Let me copy Ian on this - he might have better ideas.
> >>It's pretty hard to follow the quoted context above but it certainly
> >>seems plausible that set_memory_nx could inadvertently end up trying to
> >>make a page which Xen made RO into a RW again.
> >>
> >>For example the callchain appear to pass through static_protections()
> >>which explicitly makes .data and .bss writeable, I think these regions
> >>can potentially contain page table pages -- e.g. allocated from BRK
> >>perhaps?
> >
> >They definitly do - it has the level1_ident_pgt, which is definitly used
> >during bootup.
> >
> Ok that make sense
> >Perhaps the fix is when marking NX, just do NX, don't try to set RW if they
> >are RO.
> >
> What do you think of this patch ?
> 
> 
> Matthieu

> >From 928dabe66cc5992587eb70410208ca9885c64a5c Mon Sep 17 00:00:00 2001
> From: Matthieu CASTET <castet.matthieu@free.fr>
> Date: Thu, 20 Jan 2011 21:11:45 +0100
> Subject: [PATCH] NX protection for kernel data : support xen
> 
> Xen want page table pages read only.
> 
> But the initial page table (from head_*.S) live in .data or .bss.
> Don't make static_protections enforce rw for .data/.bss in xen case.
> 
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> ---
>  arch/x86/mm/pageattr.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 8b830ca..8698521 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -283,11 +283,14 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
>  		   __pa((unsigned long)__end_rodata) >> PAGE_SHIFT))
>  		pgprot_val(forbidden) |= _PAGE_RW;
>  	/*
> -	 * .data and .bss should always be writable.
> +	 * .data and .bss should always be writable, but xen won't like
> +	 * if we make page table rw (that live in .data or .bss)
>  	 */
> +#ifndef CONFIG_XEN
>  	if (within(address, (unsigned long)_sdata, (unsigned long)_edata) ||
>  	    within(address, (unsigned long)__bss_start, (unsigned long)__bss_stop))
>  		pgprot_val(required) |= _PAGE_RW;
> +#endif

<shudders>There has to be a better way than this. Keep in mind that this
would mean that any kernel that runs with the pvops turned on (pretty much all distros)
will do this. You don't need anymore to build a kernel that is Xen specific - it is
one kernel that can run on baremetal, Xen, etc.

Is there no way to just say, pass in PAGE_NX and don't unset the other
permissions? Hmm, there is something right below what your patch does:

  if (kernel_set_to_readonly &&
            within(address, (unsigned long)_text,
                   (unsigned long)__end_rodata_hpage_align)) {
                unsigned int level;

...
                 * This also fixes the Linux Xen paravirt guest boot failure
                 * (because of unexpected read-only mappings for kernel identity
                 * mappings). In this paravirt guest case, the kernel text
...


Could we just expand the search criteria to be __end ? 

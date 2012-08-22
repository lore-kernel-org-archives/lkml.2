Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2HVQbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 12:31:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33364 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab2HVQba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 12:31:30 -0400
Date: Wed, 22 Aug 2012 12:21:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Q:pt_base in COMPAT mode offset by two pages. Was:Re:
 [Xen-devel] [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
Message-ID: <20120822162119.GB24203@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com>
 <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com>
 <20120821190317.GA13035@phenom.dumpdata.com>
 <50351DEF020000780009702A@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50351DEF020000780009702A@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:59:11PM +0100, Jan Beulich wrote:
> >>> On 21.08.12 at 21:03, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Tue, Aug 21, 2012 at 01:27:32PM -0400, Konrad Rzeszutek Wilk wrote:
> >> On Mon, Aug 20, 2012 at 10:13:05AM -0400, Konrad Rzeszutek Wilk wrote:
> >> > On Fri, Aug 17, 2012 at 06:35:12PM +0100, Stefano Stabellini wrote:
> >> > > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> >> > > > instead of a big memblock_reserve. This way we can be more
> >> > > > selective in freeing regions (and it also makes it easier
> >> > > > to understand where is what).
> >> > > > 
> >> > > > [v1: Move the auto_translate_physmap to proper line]
> >> > > > [v2: Per Stefano suggestion add more comments]
> >> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> > > 
> >> > > much better now!
> >> > 
> >> > Thought interestingly enough it breaks 32-bit dom0s (and only dom0s).
> >> > Will have a revised patch posted shortly.
> >> 
> >> Jan, I thought something odd. Part of this code replaces this:
> >> 
> >> 	memblock_reserve(__pa(xen_start_info->mfn_list),
> >> 		xen_start_info->pt_base - xen_start_info->mfn_list);
> >> 
> >> with a more region-by-region area. What I found out that if I boot this
> >> as 32-bit guest with a 64-bit hypervisor the xen_start_info->pt_base is
> >> actually wrong.
> >> 
> >> Specifically this is what bootup says:
> >> 
> >> (good working case - 32bit hypervisor with 32-bit dom0):
> >> (XEN)  Loaded kernel: c1000000->c1a23000
> >> (XEN)  Init. ramdisk: c1a23000->cf730e00
> >> (XEN)  Phys-Mach map: cf731000->cf831000
> >> (XEN)  Start info:    cf831000->cf83147c
> >> (XEN)  Page tables:   cf832000->cf8b5000
> >> (XEN)  Boot stack:    cf8b5000->cf8b6000
> >> (XEN)  TOTAL:         c0000000->cfc00000
> >> 
> >> [    0.000000] PT: cf832000 (f832000)
> >> [    0.000000] Reserving PT: f832000->f8b5000
> >> 
> >> And with a 64-bit hypervisor:
> >> 
> >> XEN) VIRTUAL MEMORY ARRANGEMENT:
> >> (XEN)  Loaded kernel: 00000000c1000000->00000000c1a23000
> >> (XEN)  Init. ramdisk: 00000000c1a23000->00000000cf730e00
> >> (XEN)  Phys-Mach map: 00000000cf731000->00000000cf831000
> >> (XEN)  Start info:    00000000cf831000->00000000cf8314b4
> >> (XEN)  Page tables:   00000000cf832000->00000000cf8b6000
> >> (XEN)  Boot stack:    00000000cf8b6000->00000000cf8b7000
> >> (XEN)  TOTAL:         00000000c0000000->00000000cfc00000
> >> (XEN)  ENTRY ADDRESS: 00000000c16bb22c
> >> 
> >> [    0.000000] PT: cf834000 (f834000)
> >> [    0.000000] Reserving PT: f834000->f8b8000
> >> 
> >> So the pt_base is offset by two pages. And looking at c/s 13257
> >> its not clear to me why this two page offset was added?
> 
> Actually, the adjustment turns out to be correct: The page
> tables for a 32-on-64 dom0 get allocated in the order "first L1",
> "first L2", "first L3", so the offset to the page table base is
> indeed 2. When reading xen/include/public/xen.h's comment
> very strictly, this is not a violation (since there nothing is said
> that the first thing in the page table space is pointed to by
> pt_base; I admit that this seems to be implied though, namely
> do I think that it is implied that the page table space is the
> range [pt_base, pt_base + nt_pt_frames), whereas that
> range here indeed is [pt_base - 2, pt_base - 2 + nt_pt_frames),
> which - without a priori knowledge - the kernel would have
> difficulty to figure out).

And only in compat mode. <sigh> Well I am happy that we have found
this so we can document it more throughly but I think I will
step away from those memblock patches for a while as the earlier

 "lets just reserve everything from mfn->list up to the pt_base"

and then in the mmu:
 "reserve everything from pt_base up to nr_pt_frames*PAGE_SIZE"

works.

And document it in the Linux kernel a bit more of why we want to
do that.
> 
> Below is a debugging patch I used to see the full picture, if you
> want to double check.

I trust you and the production of said pages in the L1, L2, L3
is closly related to how the 64-bit does it. Which is L4, L1, L2, L3
and then the L1's follow.

The toolstack does it in L4, L3, L2, L1 order..
> 
> One thing I also noticed is that nr_pt_frames apparently is
> one too high in this case, as the L4 is not really part of the
> page tables from the kernel's perspective (and not represented
> anywhere in the corresponding VA range).
> 
> Jan
> 
> --- a/xen/arch/x86/domain_build.c
> +++ b/xen/arch/x86/domain_build.c
> @@ -940,6 +940,7 @@ int __init construct_dom0(
>      si->flags       |= (xen_processor_pmbits << 8) & SIF_PM_MASK;
>      si->pt_base      = vpt_start + 2 * PAGE_SIZE * !!is_pv_32on64_domain(d);
>      si->nr_pt_frames = nr_pt_pages;
> +printk("PT#%lx\n", si->nr_pt_frames);//temp
>      si->mfn_list     = vphysmap_start;
>      snprintf(si->magic, sizeof(si->magic), "xen-3.0-x86_%d%s",
>               elf_64bit(&elf) ? 64 : 32, parms.pae ? "p" : "");
> @@ -1115,6 +1116,10 @@ int __init construct_dom0(
>                  process_pending_softirqs();
>          }
>      }
> +show_page_walk(vpt_start);//temp
> +show_page_walk(si->pt_base);//temp
> +show_page_walk(v_start);//temp
> +show_page_walk(v_end - 1);//temp
>  
>      if ( initrd_len != 0 )
>      {

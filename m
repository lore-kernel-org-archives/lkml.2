Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab2HVPHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:07:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29509 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab2HVPHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:07:41 -0400
Date: Wed, 22 Aug 2012 10:57:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Q:pt_base in COMPAT mode offset by two pages. Was:Re:
 [Xen-devel] [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
Message-ID: <20120822145730.GI30964@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com>
 <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com>
 <20120821190317.GA13035@phenom.dumpdata.com>
 <503504FE0200007800096F08@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503504FE0200007800096F08@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:12:46PM +0100, Jan Beulich wrote:
> >>> On 21.08.12 at 21:03, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Tue, Aug 21, 2012 at 01:27:32PM -0400, Konrad Rzeszutek Wilk wrote:
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
> Honestly, without looking through this in greater detail I don't
> recall. That'll have to wait possibly until after the summit, though.

I figured it was baked in the API so not really worth persuing
a fix and just leave it as is.

> I can't exclude that this is just a forgotten leftover from an earlier
> version of the patch. I would have thought this was to account
> for the L4 tables that the guest doesn't see, but
> - this should only be a single page
> - this should then also (or rather instead) be subtracted from
>   nr_pt_frames
> so that's likely not it.
> 
> >> The toolstack works fine - so launching 32-bit guests either
> >> under a 32-bit hypervisor or 64-bit works fine:
> >> ] domainbuilder: detail: xc_dom_alloc_segment:   page tables  : 0xcf805000 -> 
> > 0xcf885000  (pfn 0xf805 + 0x80 pages)
> >> [    0.000000] PT: cf805000 (f805000)
> >> 
> > 
> > And this patch on top of the others fixes this..
> 
> I didn't look at this in too close detail, but I started to get
> afraid that you might be making the code dependent on
> many hypervisor implementation details. And should the
> above turn out to be a bug in the hypervisor, I hope your
> kernel side changes won't make it impossible to fix that bug.

Actually they will work OK. I've tested it with and without the
hypervisor bug-fix and it worked nicely.

But this is "make the memblock_reserve" easier to see is getting
out of hands :-(

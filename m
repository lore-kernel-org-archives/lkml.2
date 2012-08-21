Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab2HURhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 13:37:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38091 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab2HURhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 13:37:43 -0400
Date: Tue, 21 Aug 2012 13:27:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>, JBeulich@suse.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Q:pt_base in COMPAT mode offset by two pages. Was:Re: [Xen-devel]
 [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
Message-ID: <20120821172732.GA23715@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com>
 <20120820141305.GA2713@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820141305.GA2713@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:13:05AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 17, 2012 at 06:35:12PM +0100, Stefano Stabellini wrote:
> > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > instead of a big memblock_reserve. This way we can be more
> > > selective in freeing regions (and it also makes it easier
> > > to understand where is what).
> > > 
> > > [v1: Move the auto_translate_physmap to proper line]
> > > [v2: Per Stefano suggestion add more comments]
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > much better now!
> 
> Thought interestingly enough it breaks 32-bit dom0s (and only dom0s).
> Will have a revised patch posted shortly.

Jan, I thought something odd. Part of this code replaces this:

	memblock_reserve(__pa(xen_start_info->mfn_list),
		xen_start_info->pt_base - xen_start_info->mfn_list);

with a more region-by-region area. What I found out that if I boot this
as 32-bit guest with a 64-bit hypervisor the xen_start_info->pt_base is
actually wrong.

Specifically this is what bootup says:

(good working case - 32bit hypervisor with 32-bit dom0):
(XEN)  Loaded kernel: c1000000->c1a23000
(XEN)  Init. ramdisk: c1a23000->cf730e00
(XEN)  Phys-Mach map: cf731000->cf831000
(XEN)  Start info:    cf831000->cf83147c
(XEN)  Page tables:   cf832000->cf8b5000
(XEN)  Boot stack:    cf8b5000->cf8b6000
(XEN)  TOTAL:         c0000000->cfc00000

[    0.000000] PT: cf832000 (f832000)
[    0.000000] Reserving PT: f832000->f8b5000

And with a 64-bit hypervisor:

XEN) VIRTUAL MEMORY ARRANGEMENT:
(XEN)  Loaded kernel: 00000000c1000000->00000000c1a23000
(XEN)  Init. ramdisk: 00000000c1a23000->00000000cf730e00
(XEN)  Phys-Mach map: 00000000cf731000->00000000cf831000
(XEN)  Start info:    00000000cf831000->00000000cf8314b4
(XEN)  Page tables:   00000000cf832000->00000000cf8b6000
(XEN)  Boot stack:    00000000cf8b6000->00000000cf8b7000
(XEN)  TOTAL:         00000000c0000000->00000000cfc00000
(XEN)  ENTRY ADDRESS: 00000000c16bb22c

[    0.000000] PT: cf834000 (f834000)
[    0.000000] Reserving PT: f834000->f8b8000

So the pt_base is offset by two pages. And looking at c/s 13257
its not clear to me why this two page offset was added?

The toolstack works fine - so launching 32-bit guests either
under a 32-bit hypervisor or 64-bit works fine:
] domainbuilder: detail: xc_dom_alloc_segment:   page tables  : 0xcf805000 -> 0xcf885000  (pfn 0xf805 + 0x80 pages)
[    0.000000] PT: cf805000 (f805000)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1ASVSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:18:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:44232 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab1ASVSM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 19 Jan 2011 16:18:12 -0500
Date: Wed, 19 Jan 2011 16:14:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Kees Cook <kees.cook@canonical.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        keir.fraser@eu.citrix.com, castet.matthieu@free.fr
Cc: mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com, jmorris@namei.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, ak@muc.de, davej@redhat.com,
        jiang@cs.ncsu.edu, arjan@infradead.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
Message-ID: <20110119211432.GA20535@dumpdata.com>
References: <4CE2F82E.60601@free.fr>
 <tip-5bd5a452662bc37c54fb6828db1a3faf87e6511c@git.kernel.org>
 <20110111233135.GL4979@outflux.net>
 <20110114201530.GA14339@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110114201530.GA14339@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 03:15:30PM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 11, 2011 at 03:31:35PM -0800, Kees Cook wrote:
> > On Thu, Nov 18, 2010 at 02:08:22PM +0000, tip-bot for Matthieu Castet wrote:
> > > Commit-ID:  5bd5a452662bc37c54fb6828db1a3faf87e6511c
> > > Gitweb:     http://git.kernel.org/tip/5bd5a452662bc37c54fb6828db1a3faf87e6511c
> > > Author:     Matthieu Castet <castet.matthieu@free.fr>
> > > AuthorDate: Tue, 16 Nov 2010 22:31:26 +0100
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Thu, 18 Nov 2010 12:52:04 +0100
> > > 
> > > x86: Add NX protection for kernel data
> > 
> > [I'd sent this in reply to the wrong patch before, resending now...]
> > 
> > Hi,
> > 
> > I was just shown this[1] on Xen from an Ubuntu bug report[2].
> > 
> > [    1.230382] NX-protecting the kernel data: 3884k
> > [    1.231002] BUG: unable to handle kernel paging request at c1782ae0
> > ...
> > [    1.231145] Call Trace:
> > [    1.231152]  [<c0138481>] ? __change_page_attr+0x2c1/0x370
> > [    1.231161]  [<c02163a1>] ? __purge_vmap_area_lazy+0xc1/0x180
> > [    1.231169]  [<c013857c>] ? __change_page_attr_set_clr+0x4c/0xb0
> > [    1.231176]  [<c0138838>] ? change_page_attr_set_clr+0x128/0x300
> > [    1.231183]  [<c010798e>] ? __raw_callee_save_xen_restore_fl+0x6/0x8
> > [    1.231192]  [<c0159ca1>] ? vprintk+0x171/0x3f0
> > [    1.231198]  [<c0138bdf>] ? set_memory_nx+0x5f/0x70
> 
> If you run it with Xen debugging enabled:
> 
> [    7.753329] NX-protecting the kernel data: 2400k
> (XEN) mm.c:2389:d0 Bad type (saw 3c000003 != exp 70000000) for mfn 1355a5 (pfn 15a5)
> (XEN) mm.c:889:d0 Error getting mfn 1355a5 (pfn 15a5) from L1 entry 80000001355a5063 for l1e_owner=0, pg_owner=0
> (XEN) mm.c:4958:d0 ptwr_emulate: could not get_page_from_l1e()
> [    7.759087] BUG: unable to handle kernel paging request at c82a4d28
> [    7.759087] IP: [<c100608c>] xen_set_pte_atomic+0x21/0x2f
> [    7.759087] *pdpt = 0000000001663001 *pde = 00000000082db067 *pte = 80000000082a4061 
> .. and same stack trace.
> 
> > 
> > 
> > Does Xen have different size page table allocations or something weird?
> 
> The same page size. Not sure actually why it is being triggered. Let me copy
> Keir on this. Keir, the region that is being marked as _NX is .bss one and

Um, it actually is from _etext -> __init_end + HPAGE_SIZE.

instrumenting the code a bit shows that setting of RW+NX from _etext throgh
__init_end works just fine. It just when you start at the PFN _past_ the
__init_end it dies. Any ideas? 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1ATLSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:18:41 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:52532 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab1ATLSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:18:39 -0500
Message-ID: <1295522306.4d381a02b1e10@imp.free.fr>
Date: Thu, 20 Jan 2011 12:18:26 +0100
From: castet.matthieu@free.fr
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: matthieu castet <castet.matthieu@free.fr>,
        Kees Cook <kees.cook@canonical.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, keir.fraser@eu.citrix.com,
        mingo@redhat.com, hpa@zytor.com, sliakh.lkml@gmail.com,
        jmorris@namei.org, linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        torvalds@linux-foundation.org, ak@muc.de, davej@redhat.com,
        jiang@cs.ncsu.edu, arjan@infradead.org, tglx@linutronix.de,
        sfr@canb.auug.org.au, mingo@elte.hu,
        Stefan Bader <stefan.bader@canonical.com>
Subject: Re: [tip:x86/security] x86: Add NX protection for kernel data
References: <4CE2F82E.60601@free.fr> <tip-5bd5a452662bc37c54fb6828db1a3faf87e6511c@git.kernel.org> <20110111233135.GL4979@outflux.net> <20110114201530.GA14339@dumpdata.com> <20110119211432.GA20535@dumpdata.com> <20110119235957.6ea35dc8@mat-laptop> <20110119233824.GA2869@dumpdata.com>
In-Reply-To: <20110119233824.GA2869@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 93.1.148.21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:

> On Wed, Jan 19, 2011 at 11:59:57PM +0100, matthieu castet wrote:
> > Le Wed, 19 Jan 2011 16:14:32 -0500,
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> a écrit :
> > > > >
> > > > > I was just shown this[1] on Xen from an Ubuntu bug report[2].
> > > > >
> > > > > [    1.230382] NX-protecting the kernel data: 3884k
> > > > > [    1.231002] BUG: unable to handle kernel paging request at
> > > > > c1782ae0 ...
> > > > > [    1.231145] Call Trace:
> > > > > [    1.231152]  [<c0138481>] ? __change_page_attr+0x2c1/0x370
> > > > > [    1.231161]  [<c02163a1>] ? __purge_vmap_area_lazy+0xc1/0x180
> > > > > [    1.231169]  [<c013857c>] ?
> > > > > __change_page_attr_set_clr+0x4c/0xb0 [    1.231176]
> > > > > [<c0138838>] ? change_page_attr_set_clr+0x128/0x300
> > > > > [    1.231183]  [<c010798e>] ?
> > > > > __raw_callee_save_xen_restore_fl+0x6/0x8 [    1.231192]
> > > > > [<c0159ca1>] ? vprintk+0x171/0x3f0 [    1.231198]  [<c0138bdf>] ?
> > > > > set_memory_nx+0x5f/0x70
> > > >
> > > > If you run it with Xen debugging enabled:
> > > >
> > > > [    7.753329] NX-protecting the kernel data: 2400k
> > > > (XEN) mm.c:2389:d0 Bad type (saw 3c000003 != exp 70000000) for mfn
> > this happen if (x & (PGT_type_mask|PGT_pae_xen_l2)) != type)
> >
> > but
> > #define PGT_type_mask       (7U<<29) /* Bits 29-31. */
> > #define _PGT_pae_xen_l2     26
> > #define PGT_pae_xen_l2      (1U<<_PGT_pae_xen_l2)
> >
> > but (exp type = 0x70000000) & (PGT_type_mask|PGT_pae_xen_l2) =
> > 0x60000000
> >
> > So the exp type look strange.
> > #define _PGT_pinned         28
> > #define PGT_pinned          (1U<<_PGT_pinned)
> >
> > > > 1355a5 (pfn 15a5) (XEN) mm.c:889:d0 Error getting mfn 1355a5 (pfn
> > > > 15a5) from L1 entry 80000001355a5063 for l1e_owner=0, pg_owner=0
> > > > (XEN) mm.c:4958:d0 ptwr_emulate: could not get_page_from_l1e()
> > > > [    7.759087] BUG: unable to handle kernel paging request at
> > > > c82a4d28 [    7.759087] IP: [<c100608c>]
> > > > xen_set_pte_atomic+0x21/0x2f [    7.759087] *pdpt =
> > > > 0000000001663001 *pde = 00000000082db067 *pte = 80000000082a4061 ..
> > > > and same stack trace.
> > > >
> > > > >
> > > > >
> > > > > Does Xen have different size page table allocations or something
> > > > > weird?
> > > >
> > > > The same page size. Not sure actually why it is being triggered.
> > > > Let me copy Keir on this. Keir, the region that is being marked as
> > > > _NX is .bss one and
> > >
>
> > > _past_ the __init_end it dies. Any ideas?
> > >
> > Does this happen if you add ". = ALIGN(HPAGE_SIZE);" before bss section
> > in arch/x86/kernel/vmlinux.lds.S ?
>
> Like this?
Yes
>
> yeeeey...That made it boot.
>
> >
> > What's the output of kernel_page_tables debugfs ?
>
> Shees.. I get
>
> [   73.723105] BUG: unable to handle kernel paging request at 15555000
[...]
> with the patch and if I revert 5bd5a452662bc37c54fb6828db1a3faf87e6511c..
>
> That looks to be another bug to hunt down.
>
No that the same bug : that the root cause.

For some reason with xen, accessing some page tables (bss and after) make the
system crash.

Resolving this one, should resolve the nx case.


Matthieu


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1J1HgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:36:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab1J1HgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:36:07 -0400
Date: Fri, 28 Oct 2011 00:39:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, hpa@zytor.com,
        jeremy.fitzhardinge@citrix.com, mingo@redhat.com, stable@kernel.org,
        tglx@linutronix.de, Stephen Rothwell <sfr@canb.auug.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Not really merged? Re: [merged]
 x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
 removed from -mm tree
Message-Id: <20111028003935.a75d16b6.akpm@linux-foundation.org>
In-Reply-To: <20111028070838.GG12995@elte.hu>
References: <201110141951.p9EJpn3A006989@hpaq5.eem.corp.google.com>
	<20111025182450.GA9843@phenom.dumpdata.com>
	<20111027155329.0adc1358.akpm@linux-foundation.org>
	<20111028070838.GG12995@elte.hu>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011 09:08:39 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 25 Oct 2011 14:24:50 -0400
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > On Fri, Oct 14, 2011 at 12:51:48PM -0700, akpm@google.com wrote:
> > > > 
> > > > The patch titled
> > > >      Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode
> > > > has been removed from the -mm tree.  Its filename was
> > > >      x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode.patch
> > > > 
> > > > This patch was dropped because it was merged into mainline or a subsystem tree
> > > 
> > > Hey Andrew,
> > > 
> > > I am actually not seeing this in mainline? Was it accidently dropped out of your tree?
> > 
> > hm, well spotted.  I'm not sure what happened here - possibly the 
> > patch was merged into an x86 tree (and hence linux-next) but later 
> > got lost. Or possibly not, and I just screwed up.
> 
> No, a patch with the -i 'paravirt.*lazy' pattern never touched -tip, 
> even temporarily.
> 
> Could it be that someone else (say the Xen guys) picked it up, it 
> went into linux-next, you thought it's applied - but then they 
> dropped it?
> 
> Do we have a full log of all linux-next patches?

Don't know.

The patch was present in the linux-next which I pulled on 14 Oct.  It
is no longer in linux-next.

Here's my copy:


From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: x86/paravirt: PTE updates in k(un)map_atomic need to be synchronous, regardless of lazy_mmu mode

Fix an outstanding issue that has been reported since 2.6.37.  Under a
heavy loaded machine processing "fork()" calls could crash with:

BUG: unable to handle kernel paging request at f573fc8c
IP: [<c01abc54>] swap_count_continued+0x104/0x180
*pdpt = 000000002a3b9027 *pde = 0000000001bed067 *pte = 0000000000000000
Oops: 0000 [#1] SMP
Modules linked in:
Pid: 1638, comm: apache2 Not tainted 3.0.4-linode37 #1
EIP: 0061:[<c01abc54>] EFLAGS: 00210246 CPU: 3
EIP is at swap_count_continued+0x104/0x180
.. snip..
Call Trace:
 [<c01ac222>] ? __swap_duplicate+0xc2/0x160
 [<c01040f7>] ? pte_mfn_to_pfn+0x87/0xe0
 [<c01ac2e4>] ? swap_duplicate+0x14/0x40
 [<c01a0a6b>] ? copy_pte_range+0x45b/0x500
 [<c01a0ca5>] ? copy_page_range+0x195/0x200
 [<c01328c6>] ? dup_mmap+0x1c6/0x2c0
 [<c0132cf8>] ? dup_mm+0xa8/0x130
 [<c013376a>] ? copy_process+0x98a/0xb30
 [<c013395f>] ? do_fork+0x4f/0x280
 [<c01573b3>] ? getnstimeofday+0x43/0x100
 [<c010f770>] ? sys_clone+0x30/0x40
 [<c06c048d>] ? ptregs_clone+0x15/0x48
 [<c06bfb71>] ? syscall_call+0x7/0xb

The problem is that in copy_page_range() we turn lazy mode on, and then in
swap_entry_free() we call swap_count_continued() which ends up in:

         map = kmap_atomic(page, KM_USER0) + offset;

and then later we touch *map.

Since we are running in batched mode (lazy) we don't actually set up the
PTE mappings and the kmap_atomic is not done synchronously and ends up
trying to dereference a page that has not been set.

Looking at kmap_atomic_prot_pfn(), it uses 'arch_flush_lazy_mmu_mode' and
doing the same in kmap_atomic_prot() and __kunmap_atomic() makes the problem
go away.

Interestingly, commit b8bcfe997e4615 ("x86/paravirt: remove lazy mode in
interrupts") removed part of this to fix an interrupt issue - but it went
to far and did not consider this scenario.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/highmem_32.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/mm/highmem_32.c~x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode arch/x86/mm/highmem_32.c
--- a/arch/x86/mm/highmem_32.c~x86-paravirt-pte-updates-in-kunmap_atomic-need-to-be-synchronous-regardless-of-lazy_mmu-mode
+++ a/arch/x86/mm/highmem_32.c
@@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
+		arch_flush_lazy_mmu_mode();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {
_


> But IMO it's at least as important to figure out what went wrong. I 
> somehow doubt it that you spuriously dropped it - that someone else 
> messes up has a far higher likelihood.

My drop was legitimate. 

Here's the commit from the Oct 14 linux-next:


commit ab67482036cee590753dd42b7f66aada97e6dcde
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Fri Sep 23 17:02:29 2011 -0400
Commit:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CommitDate: Mon Sep 26 09:12:37 2011 -0400

    x86/paravirt: Partially revert "remove lazy mode in interrupts"
    
    which has git commit b8bcfe997e46150fedcc3f5b26b846400122fdd9.
    
    The unintended consequence of removing the flushing of MMU
    updates when doing kmap_atomic (or kunmap_atomic) is that we can
    hit a dereference bug when processing a "fork()" under a heavy loaded
    machine. Specifically we can hit:
    
    BUG: unable to handle kernel paging request at f573fc8c
    IP: [<c01abc54>] swap_count_continued+0x104/0x180
    *pdpt = 000000002a3b9027 *pde = 0000000001bed067 *pte = 0000000000000000
    Oops: 0000 [#1] SMP
    Modules linked in:
    Pid: 1638, comm: apache2 Not tainted 3.0.4-linode37 #1
    EIP: 0061:[<c01abc54>] EFLAGS: 00210246 CPU: 3
    EIP is at swap_count_continued+0x104/0x180
    .. snip..
    Call Trace:
     [<c01ac222>] ? __swap_duplicate+0xc2/0x160
     [<c01040f7>] ? pte_mfn_to_pfn+0x87/0xe0
     [<c01ac2e4>] ? swap_duplicate+0x14/0x40
     [<c01a0a6b>] ? copy_pte_range+0x45b/0x500
     [<c01a0ca5>] ? copy_page_range+0x195/0x200
     [<c01328c6>] ? dup_mmap+0x1c6/0x2c0
     [<c0132cf8>] ? dup_mm+0xa8/0x130
     [<c013376a>] ? copy_process+0x98a/0xb30
     [<c013395f>] ? do_fork+0x4f/0x280
     [<c01573b3>] ? getnstimeofday+0x43/0x100
     [<c010f770>] ? sys_clone+0x30/0x40
     [<c06c048d>] ? ptregs_clone+0x15/0x48
     [<c06bfb71>] ? syscall_call+0x7/0xb
    
    The problem looks that in copy_page_range we turn lazy mode on, and then
    in swap_entry_free we call swap_count_continued which ends up in:
    
             map = kmap_atomic(page, KM_USER0) + offset;
    
    and then later touches *map.
    
    Since we are running in batched mode (lazy) we don't actually set up the
    PTE mappings and the kmap_atomic is not done synchronously and ends up
    trying to dereference a page that has not been set.
    
    Looking at kmap_atomic_prot_pfn, it uses 'arch_flush_lazy_mmu_mode' and
    sprinkling that in kmap_atomic_prot and __kunmap_atomic makes the problem
    go away.
    
    CC: Thomas Gleixner <tglx@linutronix.de>
    CC: Ingo Molnar <mingo@redhat.com>
    CC: "H. Peter Anvin" <hpa@zytor.com>
    CC: x86@kernel.org
    CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
    CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    CC: stable@kernel.org
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index b499626..f4f29b1 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -45,6 +45,7 @@ void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	BUG_ON(!pte_none(*(kmap_pte-idx)));
 	set_pte(kmap_pte-idx, mk_pte(page, prot));
+	arch_flush_lazy_mmu_mode();
 
 	return (void *)vaddr;
 }
@@ -88,6 +89,7 @@ void __kunmap_atomic(void *kvaddr)
 		 */
 		kpte_clear_flush(kmap_pte-idx, vaddr);
 		kmap_atomic_idx_pop();
+		arch_flush_lazy_mmu_mode();
 	}
 #ifdef CONFIG_DEBUG_HIGHMEM
 	else {


I'm not sure what to make of that.  The signoffs imply that Konrad is
running his own git tree, but I don't think he is.  Or someone (Jeremy
or Rusty I think) merged it but didn't add a signoff.

Note that the patch was merged using its old name "x86/paravirt:
Partially revert "remove lazy mode in interrupts"".  The patch got
renamed to "x86/paravirt: PTE updates in k(un)map_atomic need to be
synchronous, regardless of lazy_mmu mode" and perhaps this prompted
someone to drop the old-named patch then lose the new-named one.



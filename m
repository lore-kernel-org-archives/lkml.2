Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0L2WzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 17:55:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:24369 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0L2WzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 17:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=t/DA+tJ2OzmlyHPJPeDuGX9g8PKrlpylmtzHuWpmdymiO2QNJiXpIpSknrBRqgkARE
         unxitkosnApR97edaZHw==
Date: Wed, 29 Dec 2010 14:54:49 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Ben Herrenschmidt <benh@kernel.crashing.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: PowerPC BUG: using smp_processor_id() in preemptible code
Message-ID: <alpine.LSU.2.00.1012291413360.22939@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent 2.6.37-rc, with CONFIG_PREEMPT=y CONFIG_DEBUG_PREEMPT=y
on the PowerPC G5, I get spammed by BUG warnings each time I swapoff:

BUG: using smp_processor_id() in preemptible [00000000] code: swapoff/3974
caller is .hpte_need_flush+0x4c/0x2e8
Call Trace:
[c0000001b4a3f830] [c00000000000f3cc] .show_stack+0x6c/0x16c (unreliable)
[c0000001b4a3f8e0] [c00000000023eda0] .debug_smp_processor_id+0xe4/0x11c
[c0000001b4a3f970] [c00000000002f2f4] .hpte_need_flush+0x4c/0x2e8
[c0000001b4a3fa30] [c0000000000e7ef8] .vunmap_pud_range+0x148/0x200
[c0000001b4a3fb10] [c0000000000e8058] .vunmap_page_range+0xa8/0xd4
[c0000001b4a3fbb0] [c0000000000e80a4] .free_unmap_vmap_area+0x20/0x38
[c0000001b4a3fc40] [c0000000000e8138] .remove_vm_area+0x7c/0xb4
[c0000001b4a3fcd0] [c0000000000e8308] .__vunmap+0x50/0x104
[c0000001b4a3fd60] [c0000000000ef3fc] .SyS_swapoff+0x59c/0x6a8
[c0000001b4a3fe30] [c0000000000075a8] syscall_exit+0x0/0x40

I notice hpte_need_flush() itself acknowledges
 * Must be called from within some kind of spinlock/non-preempt region...

Though I didn't actually bisect, I believe this is since Jeremy's
64141da587241301ce8638cc945f8b67853156ec "vmalloc: eagerly clear ptes
on vunmap", which moves a call to vunmap_page_range() from one place
(which happened to be inside a spinlock) to another (where it's not).

I guess my warnings would be easily silenced by moving that call to
vunmap_page_range() down just inside the spinlock below it; but I'm
dubious that that's the right fix - it looked as if there are other
paths through vmalloc.c where vunmap_page_range() has been getting
called without preemption disabled, long before Jeremy's change,
just paths that I never happen to go down in my limited testing.

For the moment I'm using the obvious patch below to keep it quiet;
but I doubt that this is the right patch either.  I'm hoping that
ye who understand the importance of hpte_need_flush() will be best
able to judge what to do.  Or might there be other architectures
expecting to be unpreemptible there?

Thanks,
Hugh

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -37,11 +37,13 @@ static void vunmap_pte_range(pmd_t *pmd,
 {
 	pte_t *pte;
 
+	preempt_disable(); /* Stop __vunmap() triggering smp_processor_id() in preemptible from hpte_need_flush() */
 	pte = pte_offset_kernel(pmd, addr);
 	do {
 		pte_t ptent = ptep_get_and_clear(&init_mm, addr, pte);
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 	} while (pte++, addr += PAGE_SIZE, addr != end);
+	preempt_enable();
 }
 
 static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)

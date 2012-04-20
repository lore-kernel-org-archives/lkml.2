Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750752Ab2DTIiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:38:22 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:42860 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2DTIiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:38:13 -0400
Message-ID: <4F911C7B.2030602@linux.vnet.ibm.com>
Date: Fri, 20 Apr 2012 16:21:15 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 9/9] KVM: MMU: document mmu-lock and fast page fault
References: <4F911B74.4040305@linux.vnet.ibm.com>
In-Reply-To: <4F911B74.4040305@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12042008-5816-0000-0000-000002364F60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document fast page fault and mmu-lock in locking.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/locking.txt |  148 ++++++++++++++++++++++++++++++++-
 1 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/Documentation/virtual/kvm/locking.txt b/Documentation/virtual/kvm/locking.txt
index 3b4cd3b..089d462 100644
--- a/Documentation/virtual/kvm/locking.txt
+++ b/Documentation/virtual/kvm/locking.txt
@@ -6,7 +6,147 @@ KVM Lock Overview

 (to be written)

-2. Reference
+3: Exception
+------------
+
+Fast page fault:
+
+Fast page fault is the fast path which fixes the guest page fault out of
+the mmu-lock on x86. Currently, the page fault can be fast only if the
+shadow page table is present and it is caused by write-protect, that means
+we just need change the W bit of the spte.
+
+What we use to avoid all the race is the SPTE_ALLOW_WRITE bit and
+SPTE_WRITE_PROTECT bit on the spte:
+- SPTE_ALLOW_WRITE means the gfn is writable on both guest and host.
+- SPTE_WRITE_PROTECT means the gfn is not write-protected for shadow page
+  write protection.
+
+On fast page fault path, we will use cmpxchg to atomically set the spte W
+bit if spte.SPTE_WRITE_PROTECT = 1 and spte.SPTE_WRITE_PROTECT = 0, this is
+safe because whenever changing these bits can be detected by cmpxchg.
+
+But we need carefully check these cases:
+1): The mapping from gfn to pfn
+
+The mapping from gfn to pfn may be changed since we can only ensure the pfn
+is not changed during cmpxchg. This is a ABA problem, for example, below case
+will happen:
+
+At the beginning:
+gpte = gfn1
+gfn1 is mapped to pfn1 on host
+spte is the shadow page table entry corresponding with gpte and
+spte = pfn1
+
+   VCPU 0                           VCPU0
+on fast page fault path:
+
+   old_spte = *spte;
+                                 pfn1 is swapped out:
+                                    spte = 0;
+
+                                 pfn1 is re-alloced for gfn2.
+
+                                 gpte is changed to point to
+                                 gfn2 by the guest:
+                                    spte = pfn1;
+
+   if (cmpxchg(spte, old_spte, old_spte+W)
+	mark_page_dirty(vcpu->kvm, gfn1)
+             OOPS!!!
+
+We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
+
+For direct sp, we can easily avoid it since the spte of direct sp is fixed
+to gfn. For indirect sp, before we do cmpxchg, we call gfn_to_pfn_atomic()
+to pin gfn to pfn, because after gfn_to_pfn_atomic():
+- We have held the refcount of pfn that means the pfn can not be freed and
+  be reused for another gfn.
+- The pfn is writable that means it can not be shared between different gfns
+  by KSM.
+
+Then, we can ensure the dirty bitmaps is correctly set for a gfn.
+
+2): flush tlbs due to shadow page table write-protected
+
+In rmap_write_protect(), we always need flush tlbs if spte.SPTE_ALLOW_WRITE = 1
+even if the current spte is read-only. The reason is fast page fault path
+will mark the spte to writable and the writable spte will be cached into tlb.
+Like below case:
+
+At the beginning:
+spte.W = 0
+spte.SPTE_WRITE_PROTECT = 0
+spte.SPTE_ALLOW_WRITE = 1
+
+   VCPU 0                          VCPU0
+In rmap_write_protect():
+
+   flush = false;
+
+   if (spte.W == 1)
+      flush = true;
+
+                               On fast page fault path:
+                                  old_spte = *spte
+                                  cmpxchg(spte, old_spte, old_spte + W)
+
+                               the spte is fetched/prefetched into
+                               tlb by CPU
+
+   spte = (spte | SPTE_WRITE_PROTECT) &
+                      ~PT_WRITABLE_MASK;
+
+   if (flush)
+         kvm_flush_remote_tlbs(vcpu->kvm)
+               OOPS!!!
+
+The tlbs are not flushed since the spte is read-only, but invalid writable
+spte has been cached in the tlbs caused by fast page fault.
+
+3): Dirty bit tracking
+In the origin code, the spte can be fast updated (non-atomically) if the
+spte is read-only and the Accessed bit has already been set since the
+Accessed bit and Dirty bit can not be lost.
+
+But it is not true after fast page fault since the spte can be marked
+writable between reading spte and updating spte. Like below case:
+
+At the beginning:
+spte.W = 0
+spte.Accessed = 1
+
+   VCPU 0                                       VCPU0
+In mmu_spte_clear_track_bits():
+
+   old_spte = *spte;
+
+   /* 'if' condition is satisfied. */
+   if (old_spte.Accssed == 1 &&
+        old_spte.W == 0)
+      spte = 0ull;
+                                         on fast page fault path:
+                                             spte.W = 1
+                                         memory write on the spte:
+                                             spte.Dirty = 1
+
+
+   else
+      old_spte = xchg(spte, 0ull)
+
+
+   if (old_spte.Accssed == 1)
+      kvm_set_pfn_accessed(spte.pfn);
+   if (old_spte.Dirty == 1)
+      kvm_set_pfn_dirty(spte.pfn);
+      OOPS!!!
+
+The Dirt bit is lost in this case. We can call the slow path
+(__update_clear_spte_slow()) to update the spte if the spte can be changed
+by fast page fault.
+
+3. Reference
 ------------

 Name:		kvm_lock
@@ -23,3 +163,9 @@ Arch:		x86
 Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
 		- tsc offset in vmcb
 Comment:	'raw' because updating the tsc offsets must not be preempted.
+
+Name:		kvm->mmu_lock
+Type:		spinlock_t
+Arch:		any
+Protects:	-shadow page/shadow tlb entry
+Comment:	it is a spinlock since it will be used in mmu notifier.
-- 
1.7.7.6


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2E2GwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 02:52:24 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40275 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2E2GwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 02:52:22 -0400
Message-ID: <4FC47219.7050506@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 14:52:09 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v6 9/9] KVM: MMU: document mmu-lock and fast page fault
References: <4FC470C7.5040700@linux.vnet.ibm.com>
In-Reply-To: <4FC470C7.5040700@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12052820-1396-0000-0000-0000014FC786
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document fast page fault and mmu-lock in locking.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/locking.txt |  134 ++++++++++++++++++++++++++++++++-
 1 files changed, 133 insertions(+), 1 deletions(-)

diff --git a/Documentation/virtual/kvm/locking.txt b/Documentation/virtual/kvm/locking.txt
index 3b4cd3b..42ba311 100644
--- a/Documentation/virtual/kvm/locking.txt
+++ b/Documentation/virtual/kvm/locking.txt
@@ -6,7 +6,133 @@ KVM Lock Overview

 (to be written)

-2. Reference
+2: Exception
+------------
+
+Fast page fault:
+
+Fast page fault is the fast path which fixes the guest page fault out of
+the mmu-lock on x86. Currently, the page fault can be fast only if the
+shadow page table is present and it is caused by write-protect, that means
+we just need change the W bit of the spte.
+
+What we use to avoid all the race is the SPTE_HOST_WRITEABLE bit and
+SPTE_MMU_WRITEABLE bit on the spte:
+- SPTE_HOST_WRITEABLE means the gfn is writable on host.
+- SPTE_MMU_WRITEABLE means the gfn is writable on mmu. The bit is set when
+  the gfn is writable on guest mmu and it is not write-protected by shadow
+  page write-protection.
+
+On fast page fault path, we will use cmpxchg to atomically set the spte W
+bit if spte.SPTE_HOST_WRITEABLE = 1 and spte.SPTE_WRITE_PROTECT = 1, this
+is safe because whenever changing these bits can be detected by cmpxchg.
+
+But we need carefully check these cases:
+1): The mapping from gfn to pfn
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
+Currently, to simplify the whole things, we disable fast page fault for
+indirect shadow page.
+
+2): Dirty bit tracking
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
+The Dirty bit is lost in this case.
+
+In order to avoid this kind of issue, we always treat the spte is "writable"
+if it can be updated out of mmu-lock, see and spte_can_be_writable() and
+spte_has_volatile_bits().
+
+3): flush tlbs due to spte updated
+If the spte is updated from writable to readonly, we should flush all TLBs,
+otherwise rmap_write_protect will find a read-only spte, even though the
+writable spte might be cached on a CPU's TLB.
+
+As mentioned before, the spte can be updated to writable out of mmu-lock on
+fast page fault path, in order to easily audit the path, we see if TLBs need
+be flushed caused by this reason in mmu_spte_update() since this is a common
+function to update spte (present -> present).
+
+See mmu_spte_update():
+
+|	if (spte_can_be_writable(old_spte) && !is_writable_pte(new_spte))
+|		ret = true;
+
+Whenever we change a spte which is writable or can be updated out of mmu-lock
+to readonly, we will flush the tlb anyway.
+
+3. Reference
 ------------

 Name:		kvm_lock
@@ -23,3 +149,9 @@ Arch:		x86
 Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
 		- tsc offset in vmcb
 Comment:	'raw' because updating the tsc offsets must not be preempted.
+
+Name:		kvm->mmu_lock
+Type:		spinlock_t
+Arch:		any
+Protects:	-shadow page/shadow tlb entry
+Comment:	it is a spinlock since it is used in mmu notifier.
-- 
1.7.7.6


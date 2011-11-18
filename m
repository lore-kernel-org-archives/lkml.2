Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab1KRJTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:19:45 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59879 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1KRJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:19:42 -0500
Message-ID: <4EC62316.2080506@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:19:18 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 4/6] KVM: introduce id_to_memslot function
References: <4EC6226B.3080408@linux.vnet.ibm.com>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-5564-0000-0000-000000285413
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce id_to_memslot to get memslot by slot id

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/ia64/kvm/kvm-ia64.c  |    2 +-
 arch/powerpc/kvm/book3s.c |    2 +-
 arch/x86/kvm/vmx.c        |    6 ++++--
 arch/x86/kvm/x86.c        |    8 +++++---
 include/linux/kvm_host.h  |    6 ++++++
 virt/kvm/kvm_main.c       |   12 ++++++++----
 6 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 7d5bc81..773a984 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1818,7 +1818,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;

-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = id_to_memslot(kvm->memslots, log->slot);
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index f68a34d..c1128d8 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -497,7 +497,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,

 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
-		memslot = &kvm->memslots->memslots[log->slot];
+		memslot = id_to_memslot(kvm->memslots, log->slot)

 		ga = memslot->base_gfn << PAGE_SHIFT;
 		ga_end = ga + (memslot->npages << PAGE_SHIFT);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6e28d58..4a92073 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2716,11 +2716,13 @@ static gva_t rmode_tss_base(struct kvm *kvm)
 {
 	if (!kvm->arch.tss_addr) {
 		struct kvm_memslots *slots;
+		struct kvm_memory_slot *slot;
 		gfn_t base_gfn;

 		slots = kvm_memslots(kvm);
-		base_gfn = slots->memslots[0].base_gfn +
-				 kvm->memslots->memslots[0].npages - 3;
+		slot = id_to_memslot(slots, 0);
+		base_gfn = slot->base_gfn + slot->npages - 3;
+
 		return base_gfn << PAGE_SHIFT;
 	}
 	return kvm->arch.tss_addr;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 56d1a39..315c2ca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3478,7 +3478,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;

-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = id_to_memslot(kvm->memslots, log->slot);
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
@@ -3491,6 +3491,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
 		struct kvm_memslots *slots, *old_slots;
+		struct kvm_memory_slot *slot;
 		unsigned long *dirty_bitmap;

 		dirty_bitmap = memslot->dirty_bitmap_head;
@@ -3503,13 +3504,14 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		if (!slots)
 			goto out;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
+		slot = id_to_memslot(slots, log->slot);
+		slot->dirty_bitmap = dirty_bitmap;
 		update_memslots(slots, NULL);

 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
-		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
+		dirty_bitmap = memslot->dirty_bitmap;
 		kfree(old_slots);

 		spin_lock(&kvm->mmu_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 10524c0..a0e4d63 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -332,6 +332,12 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 			|| lockdep_is_held(&kvm->slots_lock));
 }

+static inline struct kvm_memory_slot *
+id_to_memslot(struct kvm_memslots *slots, int id)
+{
+	return &slots->memslots[id];
+}
+
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec3b03b..09bb794 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -634,8 +634,9 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
 {
 	if (new) {
 		int id = new->id;
+		struct kvm_memory_slot *old = id_to_memslot(slots, id);

-		slots->memslots[id] = *new;
+		*old = *new;
 		if (id >= slots->nmemslots)
 			slots->nmemslots = id + 1;
 	}
@@ -681,7 +682,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;

-	memslot = &kvm->memslots->memslots[mem->slot];
+	memslot = id_to_memslot(kvm->memslots, mem->slot);
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;

@@ -788,12 +789,15 @@ skip_lpage:
 #endif /* not defined CONFIG_S390 */

 	if (!npages) {
+		struct kvm_memory_slot *slot;
+
 		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 		if (!slots)
 			goto out_free;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
+		slot = id_to_memslot(slots, mem->slot);
+		slot->flags |= KVM_MEMSLOT_INVALID;
 		update_memslots(slots, NULL);

 		old_memslots = kvm->memslots;
@@ -897,7 +901,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;

-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = id_to_memslot(kvm->memslots, log->slot);
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
-- 
1.7.7.1


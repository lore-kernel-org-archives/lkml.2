Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab1KXLEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:04:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44700 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1KXLEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:04:42 -0500
Message-ID: <4ECE24C3.7040007@gmail.com>
Date: Thu, 24 Nov 2011 19:04:35 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] KVM: introduce id_to_memslot function
References: <4ECE1037.4060300@gmail.com> <4ECE10F8.9070707@gmail.com> <4ECE1948.2060907@oss.ntt.co.jp> <4ECE1B20.9040304@oss.ntt.co.jp>
In-Reply-To: <4ECE1B20.9040304@oss.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 06:23 PM, Takuya Yoshikawa wrote:

> (2011/11/24 19:15), Takuya Yoshikawa wrote:
>> (2011/11/24 18:40), Xiao Guangrong wrote:
> 
>> You can eliminate this if you use old_slot and new_slot for the two memory slots.
> 
> Or old_bitmap and new_bitmap.  Anyway, calling id_to_memslot() for getting the
> same slot twice is not good, IMO.
> 


Sure. Thanks for your review, Takuya!

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: KVM: introduce id_to_memslot function

Introduce id_to_memslot to get memslot by slot id

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/ia64/kvm/kvm-ia64.c  |    2 +-
 arch/powerpc/kvm/book3s.c |    2 +-
 arch/x86/kvm/vmx.c        |    6 ++++--
 arch/x86/kvm/x86.c        |   18 +++++++++---------
 include/linux/kvm_host.h  |    6 ++++++
 virt/kvm/kvm_main.c       |   13 +++++++++----
 6 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 42ad1f9..92d9f1e 100644
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
index a459479..e41ac6f 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -498,7 +498,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,

 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (is_dirty) {
-		memslot = &kvm->memslots->memslots[log->slot];
+		memslot = id_to_memslot(kvm->memslots, log->slot);

 		ga = memslot->base_gfn << PAGE_SHIFT;
 		ga_end = ga + (memslot->npages << PAGE_SHIFT);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ba24022..8f19d91 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2711,11 +2711,13 @@ static gva_t rmode_tss_base(struct kvm *kvm)
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
index a9e5a59..886296e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3521,7 +3521,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;

-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = id_to_memslot(kvm->memslots, log->slot);
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
@@ -3532,27 +3532,27 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	/* If nothing is dirty, don't bother messing with page tables. */
 	if (nr_dirty_pages) {
 		struct kvm_memslots *slots, *old_slots;
-		unsigned long *dirty_bitmap;
+		unsigned long *dirty_bitmap, *dirty_bitmap_head;

-		dirty_bitmap = memslot->dirty_bitmap_head;
-		if (memslot->dirty_bitmap == dirty_bitmap)
-			dirty_bitmap += n / sizeof(long);
-		memset(dirty_bitmap, 0, n);
+		dirty_bitmap = memslot->dirty_bitmap;
+		dirty_bitmap_head = memslot->dirty_bitmap_head;
+		if (dirty_bitmap == dirty_bitmap_head)
+			dirty_bitmap_head += n / sizeof(long);
+		memset(dirty_bitmap_head, 0, n);

 		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 		if (!slots)
 			goto out;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		memslot = &slots->memslots[log->slot];
-		memslot->dirty_bitmap = dirty_bitmap;
+		memslot = id_to_memslot(slots, log->slot);
 		memslot->nr_dirty_pages = 0;
+		memslot->dirty_bitmap = dirty_bitmap_head;
 		update_memslots(slots, NULL);

 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
 		synchronize_srcu_expedited(&kvm->srcu);
-		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
 		kfree(old_slots);

 		write_protect_slot(kvm, memslot, dirty_bitmap, nr_dirty_pages);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 392af47..123925c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -333,6 +333,12 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
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
index 4c2900c..7b60849 100644
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

@@ -788,12 +789,16 @@ skip_lpage:
 #endif /* not defined CONFIG_S390 */

 	if (!npages) {
+		struct kvm_memory_slot *slot;
+
 		r = -ENOMEM;
 		slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),
 				GFP_KERNEL);
 		if (!slots)
 			goto out_free;
-		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
+		slot = id_to_memslot(slots, mem->slot);
+		slot->flags |= KVM_MEMSLOT_INVALID;
+
 		update_memslots(slots, NULL);

 		old_memslots = kvm->memslots;
@@ -897,7 +902,7 @@ int kvm_get_dirty_log(struct kvm *kvm,
 	if (log->slot >= KVM_MEMORY_SLOTS)
 		goto out;

-	memslot = &kvm->memslots->memslots[log->slot];
+	memslot = id_to_memslot(kvm->memslots, log->slot);
 	r = -ENOENT;
 	if (!memslot->dirty_bitmap)
 		goto out;
-- 
1.7.7.3


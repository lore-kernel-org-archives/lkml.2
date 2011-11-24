Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1KXJh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:37:56 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61044 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1KXJhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:37:54 -0500
Message-ID: <4ECE106C.80106@gmail.com>
Date: Thu, 24 Nov 2011 17:37:48 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 1/6] KVM: introduce KVM_MEM_SLOTS_NUM macro
References: <4ECE1037.4060300@gmail.com>
In-Reply-To: <4ECE1037.4060300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Introduce KVM_MEM_SLOTS_NUM macro to instead of
KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +++-
 arch/x86/kvm/mmu.c              |    2 +-
 include/linux/kvm_host.h        |    7 +++++--
 virt/kvm/kvm_main.c             |    2 +-
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 69b6525..1769f3d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,6 +31,8 @@
 #define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
+#define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+
 #define KVM_MMIO_SIZE 16

 #define KVM_PIO_PAGE_OFFSET 1
@@ -228,7 +230,7 @@ struct kvm_mmu_page {
 	 * One bit set per slot which has memory
 	 * in this shadow page.
 	 */
-	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	DECLARE_BITMAP(slot_bitmap, KVM_MEM_SLOTS_NUM);
 	bool unsync;
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index aecdea2..715dcb4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1349,7 +1349,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 						  PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	bitmap_zero(sp->slot_bitmap, KVM_MEM_SLOTS_NUM);
 	sp->parent_ptes = 0;
 	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7c654aa..924df0d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -227,11 +227,14 @@ struct kvm_irq_routing_table {};

 #endif

+#ifndef KVM_MEM_SLOTS_NUM
+#define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+#endif
+
 struct kvm_memslots {
 	int nmemslots;
 	u64 generation;
-	struct kvm_memory_slot memslots[KVM_MEMORY_SLOTS +
-					KVM_PRIVATE_MEM_SLOTS];
+	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 };

 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index af5c988..9ad94c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -663,7 +663,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			(void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
 		goto out;
-	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+	if (mem->slot >= KVM_MEM_SLOTS_NUM)
 		goto out;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
-- 
1.7.7.3


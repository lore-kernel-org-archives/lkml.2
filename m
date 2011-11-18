Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1KRJRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:17:15 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49362 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1KRJRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:17:13 -0500
Message-ID: <4EC6228E.7090402@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:17:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 1/6] KVM: introduce KVM_MEM_SLOTS_NUM macro
References: <4EC6226B.3080408@linux.vnet.ibm.com>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-8256-0000-0000-000000336B13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 6d83264..b80a310 100644
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
index a9b3a32..e6c2755 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1337,7 +1337,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 						  PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	bitmap_zero(sp->slot_bitmap, KVM_MEM_SLOTS_NUM);
 	sp->parent_ptes = 0;
 	mmu_page_add_parent_pte(vcpu, sp, parent_pte);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c6a2ec9..a42d50b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -226,11 +226,14 @@ struct kvm_irq_routing_table {};

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
index d9cfb78..eb55a11 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -662,7 +662,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			(void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
 		goto out;
-	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+	if (mem->slot >= KVM_MEM_SLOTS_NUM)
 		goto out;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
-- 
1.7.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1BVIJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:09:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54314 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1BVIJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:09:35 -0500
Message-ID: <4D636F71.9000804@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:10:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/7] KVM: introduce KVM_MEM_SLOTS_NUM macro
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:08:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:08:27,
	Serialize complete at 2011-02-22 16:08:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce KVM_MEM_SLOTS_NUM macro to instead of
KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/kvm_host.h |    3 ++-
 arch/x86/kvm/mmu.c              |    2 +-
 include/linux/kvm_host.h        |    7 +++++--
 virt/kvm/kvm_main.c             |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 37bd730..178d658 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -30,6 +30,7 @@
 #define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
+#define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 
 #define KVM_PIO_PAGE_OFFSET 1
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 2
@@ -207,7 +208,7 @@ struct kvm_mmu_page {
 	 * One bit set per slot which has memory
 	 * in this shadow page.
 	 */
-	DECLARE_BITMAP(slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	DECLARE_BITMAP(slot_bitmap, KVM_MEM_SLOTS_NUM);
 	bool multimapped;         /* More than one parent_pte? */
 	bool unsync;
 	int root_count;          /* Currently serving as active root */
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b6a9963..268c891 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1056,7 +1056,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 						  PAGE_SIZE);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
+	bitmap_zero(sp->slot_bitmap, KVM_MEM_SLOTS_NUM);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b1a7430..865486f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -217,11 +217,14 @@ struct kvm_irq_routing_table {};
 
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
index cf90f28..e3e744c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -651,7 +651,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		goto out;
 	if (user_alloc && (mem->userspace_addr & (PAGE_SIZE - 1)))
 		goto out;
-	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
+	if (mem->slot >= KVM_MEM_SLOTS_NUM)
 		goto out;
 	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
 		goto out;
-- 
1.7.4


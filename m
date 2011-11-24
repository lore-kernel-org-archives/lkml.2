Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1KXJlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:41:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:40030 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab1KXJlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:41:02 -0500
Message-ID: <4ECE1129.2060305@gmail.com>
Date: Thu, 24 Nov 2011 17:40:57 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 5/6] KVM: sort memslots by its size and use line search
References: <4ECE1037.4060300@gmail.com>
In-Reply-To: <4ECE1037.4060300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Sort memslots base on its size and use line search to find it, so that the
larger memslots have better fit

The idea is from Avi

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |   18 +++++++++--
 virt/kvm/kvm_main.c      |   79 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 72 insertions(+), 25 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 123925c..9efdf5c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -231,8 +231,12 @@ struct kvm_irq_routing_table {};
 #define KVM_MEM_SLOTS_NUM (KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 #endif

+/*
+ * Note:
+ * memslots are not sorted by id anymore, please use id_to_memslot()
+ * to get the memslot by its id.
+ */
 struct kvm_memslots {
-	int nmemslots;
 	u64 generation;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 };
@@ -310,7 +314,8 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)

 #define kvm_for_each_memslot(memslot, slots)	\
 	for (memslot = &slots->memslots[0];	\
-	      memslot < slots->memslots + (slots)->nmemslots; memslot++)
+	      memslot < slots->memslots + KVM_MEM_SLOTS_NUM && memslot->npages;\
+		memslot++)

 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
@@ -336,7 +341,14 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 static inline struct kvm_memory_slot *
 id_to_memslot(struct kvm_memslots *slots, int id)
 {
-	return &slots->memslots[id];
+	int i;
+
+	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
+		if (slots->memslots[i].id == id)
+			return &slots->memslots[i];
+
+	WARN_ON(1);
+	return NULL;
 }

 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7b60849..6e8eb15 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -440,6 +440,15 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)

 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */

+static void kvm_init_memslots_id(struct kvm *kvm)
+{
+	int i;
+	struct kvm_memslots *slots = kvm->memslots;
+
+	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
+		slots->memslots[i].id = i;
+}
+
 static struct kvm *kvm_create_vm(void)
 {
 	int r, i;
@@ -465,6 +474,7 @@ static struct kvm *kvm_create_vm(void)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_nosrcu;
+	kvm_init_memslots_id(kvm);
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_nosrcu;
 	for (i = 0; i < KVM_NR_BUSES; i++) {
@@ -630,15 +640,54 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 #endif /* !CONFIG_S390 */

+static struct kvm_memory_slot *
+search_memslots(struct kvm_memslots *slots, gfn_t gfn)
+{
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, slots)
+		if (gfn >= memslot->base_gfn &&
+		      gfn < memslot->base_gfn + memslot->npages)
+			return memslot;
+
+	return NULL;
+}
+
+static int cmp_memslot(const void *slot1, const void *slot2)
+{
+	struct kvm_memory_slot *s1, *s2;
+
+	s1 = (struct kvm_memory_slot *)slot1;
+	s2 = (struct kvm_memory_slot *)slot2;
+
+	if (s1->npages < s2->npages)
+		return 1;
+	if (s1->npages > s2->npages)
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Sort the memslots base on its size, so the larger slots
+ * will get better fit.
+ */
+static void sort_memslots(struct kvm_memslots *slots)
+{
+	sort(slots->memslots, KVM_MEM_SLOTS_NUM,
+	      sizeof(struct kvm_memory_slot), cmp_memslot, NULL);
+}
+
 void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
 {
 	if (new) {
 		int id = new->id;
 		struct kvm_memory_slot *old = id_to_memslot(slots, id);
+		unsigned long npages = old->npages;

 		*old = *new;
-		if (id >= slots->nmemslots)
-			slots->nmemslots = id + 1;
+		if (new->npages != npages)
+			sort_memslots(slots);
 	}

 	slots->generation++;
@@ -980,14 +1029,7 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 static struct kvm_memory_slot *__gfn_to_memslot(struct kvm_memslots *slots,
 						gfn_t gfn)
 {
-	struct kvm_memory_slot *memslot;
-
-	kvm_for_each_memslot(memslot, slots)
-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages)
-			return memslot;
-
-	return NULL;
+	return search_memslots(slots, gfn);
 }

 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
@@ -998,20 +1040,13 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);

 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-	int i;
-	struct kvm_memslots *slots = kvm_memslots(kvm);
-
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
+	struct kvm_memory_slot *memslot = gfn_to_memslot(kvm, gfn);

-		if (memslot->flags & KVM_MEMSLOT_INVALID)
-			continue;
+	if (!memslot || memslot->id >= KVM_MEMORY_SLOTS ||
+	      memslot->flags & KVM_MEMSLOT_INVALID)
+		return 0;

-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages)
-			return 1;
-	}
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);

-- 
1.7.7.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1KRJUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:20:04 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52274 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab1KRJUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:20:00 -0500
Message-ID: <4EC62336.7040505@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:19:50 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 5/6] KVM: sort memslots by its size and use line search
References: <4EC6226B.3080408@linux.vnet.ibm.com>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-2674-0000-0000-000001C4C41B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort memslots base on its size and use line search to find it, so the larger
memslots have better fit

The idea is from Avi

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |   22 +++++++++---
 virt/kvm/kvm_main.c      |   82 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 75 insertions(+), 29 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a0e4d63..83b396a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -230,8 +230,12 @@ struct kvm_irq_routing_table {};
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
@@ -307,9 +311,10 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
 	     idx++)

-#define kvm_for_each_memslot(slots, memslot, i)	\
-	for (i = 0; i < (slots)->nmemslots &&	\
-	      ({ memslot = &(slots)->memslots[i]; 1; }); i++)
+#define kvm_for_each_memslot(slots, memslot, i)			\
+	for (i = 0; i < KVM_MEM_SLOTS_NUM &&			\
+	      ({ memslot = &(slots)->memslots[i]; 1; }) &&	\
+	      memslot->npages != 0; i++)

 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
 void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
@@ -335,7 +340,14 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
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
index 09bb794..9425e3a 100644
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
@@ -630,15 +640,55 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 #endif /* !CONFIG_S390 */

+static struct kvm_memory_slot *
+search_memslots(struct kvm_memslots *slots, gfn_t gfn)
+{
+	int i;
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(slots, memslot, i)
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
@@ -979,16 +1029,7 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
 static struct kvm_memory_slot *__gfn_to_memslot(struct kvm_memslots *slots,
 						gfn_t gfn)
 {
-	int i;
-
-	for (i = 0; i < slots->nmemslots; ++i) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
-
-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages)
-			return memslot;
-	}
-	return NULL;
+	return search_memslots(slots, gfn);
 }

 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
@@ -999,20 +1040,13 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);

 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-	int i;
-	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = gfn_to_memslot(kvm, gfn);

-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
-
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
1.7.7.1



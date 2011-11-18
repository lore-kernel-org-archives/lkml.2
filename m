Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1KRJUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:20:49 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60252 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572Ab1KRJUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:20:47 -0500
Message-ID: <4EC6235A.90705@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:20:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 6/6] KVM: introduce a table to map slot id to index in
 memslots arry
References: <4EC6226B.3080408@linux.vnet.ibm.com>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-5564-0000-0000-00000028554F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The operation of getting dirty log is frequency When framebuffer-based
displays are used(for example, Xwindow), so, we introduce a mapping table
to speed up id_to_memslot()

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |   13 +++++++------
 virt/kvm/kvm_main.c      |    7 ++++++-
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 83b396a..fbf66eb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -238,6 +238,8 @@ struct kvm_irq_routing_table {};
 struct kvm_memslots {
 	u64 generation;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
+	/* The mapping table from slot id to the index in memslots[]. */
+	int id_to_index[KVM_MEM_SLOTS_NUM];
 };

 struct kvm {
@@ -340,14 +342,13 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 static inline struct kvm_memory_slot *
 id_to_memslot(struct kvm_memslots *slots, int id)
 {
-	int i;
+	int index = slots->id_to_index[id];
+	struct kvm_memory_slot *slot;

-	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		if (slots->memslots[i].id == id)
-			return &slots->memslots[i];
+	slot = &slots->memslots[index];

-	WARN_ON(1);
-	return NULL;
+	WARN_ON(slot->id != id);
+	return slot;
 }

 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9425e3a..0dad825 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -446,7 +446,7 @@ static void kvm_init_memslots_id(struct kvm *kvm)
 	struct kvm_memslots *slots = kvm->memslots;

 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->memslots[i].id = i;
+		slots->id_to_index[i] = slots->memslots[i].id = i;
 }

 static struct kvm *kvm_create_vm(void)
@@ -675,8 +675,13 @@ static int cmp_memslot(const void *slot1, const void *slot2)
  */
 static void sort_memslots(struct kvm_memslots *slots)
 {
+	int i;
+
 	sort(slots->memslots, KVM_MEM_SLOTS_NUM,
 	      sizeof(struct kvm_memory_slot), cmp_memslot, NULL);
+
+	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
+		slots->id_to_index[slots->memslots[i].id] = i;
 }

 void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
-- 
1.7.7.1


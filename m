Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1KXJmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:42:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65289 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958Ab1KXJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:42:00 -0500
Message-ID: <4ECE1162.9080701@gmail.com>
Date: Thu, 24 Nov 2011 17:41:54 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 6/6] KVM: introduce a table to map slot id to index in
 memslots array
References: <4ECE1037.4060300@gmail.com>
In-Reply-To: <4ECE1037.4060300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

The operation of getting dirty log is frequent when framebuffer-based
displays are used(for example, Xwindow), so, we introduce a mapping table
to speed up id_to_memslot()

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/kvm_host.h |   13 +++++++------
 virt/kvm/kvm_main.c      |    7 ++++++-
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9efdf5c..8c5c303 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -239,6 +239,8 @@ struct kvm_irq_routing_table {};
 struct kvm_memslots {
 	u64 generation;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
+	/* The mapping table from slot id to the index in memslots[]. */
+	int id_to_index[KVM_MEM_SLOTS_NUM];
 };

 struct kvm {
@@ -341,14 +343,13 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
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
index 6e8eb15..e289486 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -446,7 +446,7 @@ static void kvm_init_memslots_id(struct kvm *kvm)
 	struct kvm_memslots *slots = kvm->memslots;

 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->memslots[i].id = i;
+		slots->id_to_index[i] = slots->memslots[i].id = i;
 }

 static struct kvm *kvm_create_vm(void)
@@ -674,8 +674,13 @@ static int cmp_memslot(const void *slot1, const void *slot2)
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
1.7.7.3


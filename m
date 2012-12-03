Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab2LCXj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:39:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab2LCXjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:39:25 -0500
Subject: [RFC PATCH 3/6] kvm: Merge id_to_index into memslots
To: mtosatti@redhat.com, kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 16:39:24 -0700
Message-ID: <20121203233924.3661.81373.stgit@bling.home>
In-Reply-To: <20121203231912.3661.57179.stgit@bling.home>
References: <20121203231912.3661.57179.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to resize this structure and therefore the number of
memslots as part of the RCU update.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/kvm_host.h |    5 ++---
 virt/kvm/kvm_main.c      |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index bf8380f..7b3d5c4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -257,6 +257,7 @@ struct kvm_memory_slot {
 	unsigned long userspace_addr;
 	int user_alloc;
 	int id;
+	int id_to_index;
 };
 
 static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
@@ -314,8 +315,6 @@ struct kvm_irq_routing_table {};
 struct kvm_memslots {
 	u64 generation;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
-	/* The mapping table from slot id to the index in memslots[]. */
-	int id_to_index[KVM_MEM_SLOTS_NUM];
 };
 
 struct kvm {
@@ -425,7 +424,7 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 static inline struct kvm_memory_slot *
 id_to_memslot(struct kvm_memslots *slots, int id)
 {
-	int index = slots->id_to_index[id];
+	int index = slots->memslots[id].id_to_index;
 	struct kvm_memory_slot *slot;
 
 	slot = &slots->memslots[index];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 48d3ede..4f8ae4b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -445,7 +445,7 @@ static void kvm_init_memslots_id(struct kvm *kvm)
 	struct kvm_memslots *slots = kvm->memslots;
 
 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[i] = slots->memslots[i].id = i;
+		slots->memslots[i].id_to_index = slots->memslots[i].id = i;
 }
 
 static struct kvm *kvm_create_vm(unsigned long type)
@@ -662,7 +662,7 @@ static void sort_memslots(struct kvm_memslots *slots)
 	      sizeof(struct kvm_memory_slot), cmp_memslot, NULL);
 
 	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
-		slots->id_to_index[slots->memslots[i].id] = i;
+		slots->memslots[slots->memslots[i].id].id_to_index = i;
 }
 
 void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1BVSzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:55:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113Ab1BVSzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:55:36 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH 3/3] kvm: Use weight-balanced tree for memory slot
	management
To: avi@redhat.com
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com, xiaoguangrong@cn.fujitsu.com
Date: Tue, 22 Feb 2011 11:55:32 -0700
Message-ID: <20110222185527.22026.85401.stgit@s20.home>
In-Reply-To: <20110222183822.22026.62832.stgit@s20.home>
References: <20110222183822.22026.62832.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than search linearly through an unordered slot array, we
can embed a tree node into each element.  We can still do RCU
tree updates by applying the pointer offset to each element
in the new copy of the tree.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/kvm_host.h |    3 +
 virt/kvm/kvm_main.c      |  163 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 135 insertions(+), 31 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7bbb36f..2a43f9b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -18,6 +18,7 @@
 #include <linux/msi.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
+#include <linux/wbtree.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -171,6 +172,7 @@ struct kvm_lpage_info {
 };
 
 struct kvm_memory_slot {
+	struct wb_node wb_node;
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long flags;
@@ -225,6 +227,7 @@ struct kvm_irq_routing_table {};
 struct kvm_memslots {
 	int nmemslots;
 	u64 generation;
+	struct wb_root wb_root;
 	struct kvm_memory_slot memslots[];
 };
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a3a5bda..0a6ef96 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -447,6 +447,7 @@ static struct kvm *kvm_create_vm(void)
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)
 		goto out_err_nosrcu;
+	kvm->memslots->wb_root = WB_ROOT;
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_nosrcu;
 	for (i = 0; i < KVM_NR_BUSES; i++) {
@@ -611,6 +612,119 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 #endif /* !CONFIG_S390 */
 
+static struct kvm_memory_slot *kvm_memslot_search(gfn_t gfn,
+						  struct kvm_memslots *slots)
+{
+	struct wb_node *node = slots->wb_root.wb_node;
+	struct kvm_memory_slot *slot;
+
+	while (node) {
+		slot = wb_entry(node, struct kvm_memory_slot, wb_node);
+
+		if (gfn < slot->base_gfn)
+			node = node->wb_left;
+		else if (gfn >= slot->base_gfn + slot->npages)
+			node = node->wb_right;
+		else
+			return slot;
+	}
+	return NULL;
+}
+
+static void print_tree(struct kvm_memslots *slots)
+{
+	int i;
+
+	printk("digraph wbtree {\nnode [shape = record];\n");
+
+	for (i = 0; i < slots->nmemslots; i++) {
+		struct kvm_memory_slot *s = &slots->memslots[i];
+		struct wb_node *n = &s->wb_node;
+
+		if (!s->npages)
+			continue;
+
+		printk("node%d [label=\"<l> | <n> %lx-%lx\\n(%ld) | <r>\"];\n",
+		       i, (unsigned long)s->base_gfn,
+		       (unsigned long)(s->base_gfn + s->npages), s->npages);
+		if (n->wb_left) {
+			struct kvm_memory_slot *sl;
+			int left;
+			sl = wb_entry(n->wb_left, struct kvm_memory_slot,
+				      wb_node);
+			left = sl - slots->memslots;			
+			printk("\"node%d\":l -> \"node%d\":n;\n", i, left);
+		}
+		if (n->wb_right) {
+			struct kvm_memory_slot *sr;
+			int right;
+			sr = wb_entry(n->wb_right, struct kvm_memory_slot,
+				      wb_node);
+			right = sr - slots->memslots;			
+			printk("\"node%d\":r -> \"node%d\":n;\n", i, right);
+		}
+	}
+	printk("}\n");
+}
+
+static int kvm_memslot_insert(struct kvm_memory_slot *slot,
+			      struct kvm_memslots *slots)
+{
+	struct wb_node **node = &slots->wb_root.wb_node, *parent = NULL;
+	struct kvm_memory_slot *memslot;
+
+	wb_set_weight(&slot->wb_node, slot->npages);
+
+	while (*node) {
+		memslot = wb_entry(*node, struct kvm_memory_slot, wb_node);
+		parent = *node;
+
+		if (slot->base_gfn + slot->npages <= memslot->base_gfn)
+			node = &(*node)->wb_left;
+		else if (slot->base_gfn >= memslot->base_gfn + memslot->npages)
+			node = &(*node)->wb_right;
+		else
+			return -EINVAL;
+	}
+
+	wb_link_node(&slot->wb_node, parent, node);
+	wb_rebalance(&slot->wb_node, &slots->wb_root);
+	print_tree(slots);
+	return 0;
+}
+
+static void kvm_memslot_remove(struct kvm_memory_slot *slot,
+			       struct kvm_memslots *slots)
+{
+	wb_erase(&slot->wb_node, &slots->wb_root);
+	print_tree(slots);
+}
+
+static inline void kvm_memslot_pointer_fix(void *old, void *new, void **ptr)
+{
+	if (*ptr) {
+		if (new > old)
+			*ptr += (new - old);
+		else
+			*ptr -= (old - new);
+	}
+}
+
+static void kvm_memslots_copy_fixup(struct kvm_memslots *old,
+				    struct kvm_memslots *new)
+{
+	int i;
+
+	for (i = 0; i < old->nmemslots; i++) {
+		struct wb_node *node = &new->memslots[i].wb_node;
+		kvm_memslot_pointer_fix(old, new, (void **)&node->wb_left);
+		kvm_memslot_pointer_fix(old, new, (void **)&node->wb_right);
+		kvm_memslot_pointer_fix(old, new, (void **)&node->wb_parent);
+	}
+
+	kvm_memslot_pointer_fix(old, new, (void **)&new->wb_root.wb_node);
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -767,6 +881,8 @@ skip_lpage:
 		memcpy(slots, kvm->memslots,
 		       sizeof(struct kvm_memslots) + kvm->memslots->nmemslots *
 		       sizeof(struct kvm_memory_slot));
+		kvm_memslots_copy_fixup(kvm->memslots, slots);
+		new.wb_node = slots->memslots[mem->slot].wb_node;
 		slots->nmemslots = nmemslots;
 		slots->generation++;
 		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
@@ -823,6 +939,13 @@ skip_lpage:
 	}
 
 	slots->memslots[mem->slot] = new;
+	kvm_memslots_copy_fixup(kvm->memslots, slots);
+
+	if (npages)
+		kvm_memslot_insert(&slots->memslots[mem->slot], slots);
+	else
+		kvm_memslot_remove(&slots->memslots[mem->slot], slots);
+
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
@@ -946,16 +1069,7 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
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
+	return kvm_memslot_search(gfn, slots);
 }
 
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
@@ -966,20 +1080,16 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
 int kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
 {
-	int i;
 	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *slot = kvm_memslot_search(gfn, slots);
 
-	for (i = KVM_PRIVATE_MEM_SLOTS; i < slots->nmemslots; ++i) {
-		struct kvm_memory_slot *memslot = &slots->memslots[i];
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
+		return 0;
 
-		if (memslot->flags & KVM_MEMSLOT_INVALID)
-			continue;
+	if (slot - slots->memslots < KVM_PRIVATE_MEM_SLOTS)
+		return 0;
 
-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages)
-			return 1;
-	}
-	return 0;
+	return 1;
 }
 EXPORT_SYMBOL_GPL(kvm_is_visible_gfn);
 
@@ -1009,19 +1119,10 @@ out:
 
 int memslot_id(struct kvm *kvm, gfn_t gfn)
 {
-	int i;
 	struct kvm_memslots *slots = kvm_memslots(kvm);
-	struct kvm_memory_slot *memslot = NULL;
-
-	for (i = 0; i < slots->nmemslots; ++i) {
-		memslot = &slots->memslots[i];
-
-		if (gfn >= memslot->base_gfn
-		    && gfn < memslot->base_gfn + memslot->npages)
-			break;
-	}
+	struct kvm_memory_slot *slot = kvm_memslot_search(gfn, slots);
 
-	return memslot - slots->memslots;
+	return slot ? slot - slots->memslots : slots->nmemslots;
 }
 
 static unsigned long gfn_to_hva_many(struct kvm_memory_slot *slot, gfn_t gfn,


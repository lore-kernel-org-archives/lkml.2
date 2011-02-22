Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab1BVILb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 03:11:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65120 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab1BVIL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 03:11:29 -0500
Message-ID: <4D636FE8.8000505@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 16:12:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 4/7] KVM: sort memslots and use binary search to search the
 right slot
References: <4D636EF8.60800@cn.fujitsu.com>
In-Reply-To: <4D636EF8.60800@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:10:25,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 16:10:26,
	Serialize complete at 2011-02-22 16:10:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sort memslots then search the slot with binary search to speed up the
slot searching

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 include/linux/kvm_host.h |    2 +
 virt/kvm/kvm_main.c      |   85 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15ff818..f1963a4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -223,8 +223,10 @@ struct kvm_irq_routing_table {};
 
 struct kvm_memslots {
 	int nmemslots;
+	int used_slots;
 	u64 generation;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
+	struct kvm_memory_slot *slots_sort[KVM_MEM_SLOTS_NUM];
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e1c6e24..0795426 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -47,6 +47,7 @@
 #include <linux/srcu.h>
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -623,11 +624,67 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 #endif /* !CONFIG_S390 */
 
+static int cmp_memslot(const void *slot1, const void *slot2)
+{
+	struct kvm_memory_slot *s1, *s2;
+
+	s1 = *(struct kvm_memory_slot **)slot1;
+	s2 = *(struct kvm_memory_slot **)slot2;
+
+	if (s1->base_gfn > s2->base_gfn)
+		return 1;
+	if (s1->base_gfn < s2->base_gfn)
+		return -1;
+
+	return 0;
+}
+
+static struct kvm_memory_slot *search_memslots(struct kvm_memslots *slots,
+					       gfn_t gfn)
+{
+	int start = 0, end = slots->used_slots, idx;
+	struct kvm_memory_slot *memslot;
+
+	while (start < end) {
+		idx = (start + end) / 2;
+		memslot = slots->slots_sort[idx];
+
+		if (gfn >= memslot->base_gfn &&
+		      gfn < memslot->base_gfn + memslot->npages)
+			return memslot;
+
+		if (memslot->base_gfn < gfn)
+			start = idx + 1;
+		else
+			end = idx;
+	}
+
+	return NULL;
+}
+
+static void sort_memslots(struct kvm_memslots *slots)
+{
+	int i, num = 0;
+	struct kvm_memory_slot *memslot;
+
+	for (i = 0; i < slots->nmemslots; i++) {
+		memslot = &slots->memslots[i];
+		if (!memslot->npages)
+			continue;
+
+		slots->slots_sort[num++] = memslot;
+	}
+
+	slots->used_slots = num;
+	sort(slots->slots_sort, num, sizeof(memslot), cmp_memslot, NULL);
+}
+
 void memslots_updated(struct kvm_memslots *slots, int slot_id)
 {
 	if (slot_id >= slots->nmemslots)
 		slots->nmemslots = slot_id + 1;
 	slots->generation++;
+	sort_memslots(slots);
 }
 
 /*
@@ -939,16 +996,7 @@ EXPORT_SYMBOL_GPL(kvm_is_error_hva);
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
@@ -959,20 +1007,13 @@ EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
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
+	if (!memslot || memslot->id > KVM_MEMORY_SLOTS ||
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
1.7.4


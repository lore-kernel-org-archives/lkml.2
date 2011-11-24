Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1KXJic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:38:32 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60201 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab1KXJia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:38:30 -0500
Message-ID: <4ECE1090.2090709@gmail.com>
Date: Thu, 24 Nov 2011 17:38:24 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 2/6] KVM: introduce update_memslots function
References: <4ECE1037.4060300@gmail.com>
In-Reply-To: <4ECE1037.4060300@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

Introduce update_memslots to update slot which will be update to
kvm->memslots

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   22 +++++++++++++++-------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1985ea1..a9e5a59 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3547,7 +3547,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		memslot = &slots->memslots[log->slot];
 		memslot->dirty_bitmap = dirty_bitmap;
 		memslot->nr_dirty_pages = 0;
-		slots->generation++;
+		update_memslots(slots, NULL);

 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 924df0d..23f795c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -320,6 +320,7 @@ void kvm_exit(void);

 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
+void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new);

 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9ad94c9..b5ed777 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -630,6 +630,19 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
 }
 #endif /* !CONFIG_S390 */

+void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
+{
+	if (new) {
+		int id = new->id;
+
+		slots->memslots[id] = *new;
+		if (id >= slots->nmemslots)
+			slots->nmemslots = id + 1;
+	}
+
+	slots->generation++;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -780,10 +793,8 @@ skip_lpage:
 				GFP_KERNEL);
 		if (!slots)
 			goto out_free;
-		if (mem->slot >= slots->nmemslots)
-			slots->nmemslots = mem->slot + 1;
-		slots->generation++;
 		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
+		update_memslots(slots, NULL);

 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
@@ -815,9 +826,6 @@ skip_lpage:
 			GFP_KERNEL);
 	if (!slots)
 		goto out_free;
-	if (mem->slot >= slots->nmemslots)
-		slots->nmemslots = mem->slot + 1;
-	slots->generation++;

 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (!npages) {
@@ -827,7 +835,7 @@ skip_lpage:
 			new.lpage_info[i] = NULL;
 	}

-	slots->memslots[mem->slot] = new;
+	update_memslots(slots, &new);
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
-- 
1.7.7.3


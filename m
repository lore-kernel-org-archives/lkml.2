Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab1KRJRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:17:53 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49506 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1KRJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:17:51 -0500
Message-ID: <4EC622B4.3090802@linux.vnet.ibm.com>
Date: Fri, 18 Nov 2011 17:17:40 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v2 2/6] KVM: introduce update_memslots function
References: <4EC6226B.3080408@linux.vnet.ibm.com>
In-Reply-To: <4EC6226B.3080408@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11111809-8256-0000-0000-000000336B7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce update_memslots to update slot which will be update to
kvm->memslots

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c       |    2 +-
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |   22 +++++++++++++++-------
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9eff4af..56d1a39 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3504,7 +3504,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 			goto out;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
 		slots->memslots[log->slot].dirty_bitmap = dirty_bitmap;
-		slots->generation++;
+		update_memslots(slots, NULL);

 		old_slots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a42d50b..bb8728e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -319,6 +319,7 @@ void kvm_exit(void);

 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
+void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new);

 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index eb55a11..0fb3aeb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -629,6 +629,19 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
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
@@ -779,10 +792,8 @@ skip_lpage:
 		if (!slots)
 			goto out_free;
 		memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-		if (mem->slot >= slots->nmemslots)
-			slots->nmemslots = mem->slot + 1;
-		slots->generation++;
 		slots->memslots[mem->slot].flags |= KVM_MEMSLOT_INVALID;
+		update_memslots(slots, NULL);

 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
@@ -814,9 +825,6 @@ skip_lpage:
 	if (!slots)
 		goto out_free;
 	memcpy(slots, kvm->memslots, sizeof(struct kvm_memslots));
-	if (mem->slot >= slots->nmemslots)
-		slots->nmemslots = mem->slot + 1;
-	slots->generation++;

 	/* actual memory is freed via old in kvm_free_physmem_slot below */
 	if (!npages) {
@@ -826,7 +834,7 @@ skip_lpage:
 			new.lpage_info[i] = NULL;
 	}

-	slots->memslots[mem->slot] = new;
+	update_memslots(slots, &new);
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);
-- 
1.7.7.1


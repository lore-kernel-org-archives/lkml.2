Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2LUPVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:21:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079Ab2LUPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:21:13 -0500
Subject: [PATCH] kvm: Fix memory slot generation updates
To: kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, takuya.yoshikawa@gmail.com
Date: Fri, 21 Dec 2012 08:20:16 -0700
Message-ID: <20121221151959.3641.75215.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch "kvm: Minor memory slot optimization" overlooked the
generation field of the memory slots.  Re-using the original memory
slots left us with with two slightly different memory slots with the
same generation.  To fix this, make update_memslots() take a new
parameter to specify the last generation.  This also makes generation
management more explicit to avoid such problems in the future.

Reported-by: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/kvm_host.h |    3 ++-
 virt/kvm/kvm_main.c      |    9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 32fdc45..cbe0d68 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -428,7 +428,8 @@ void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
-void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new);
+void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
+		     u64 last_generation);
 
 static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
 {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index bd31096..14cbae8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -672,7 +672,8 @@ static void sort_memslots(struct kvm_memslots *slots)
 		slots->id_to_index[slots->memslots[i].id] = i;
 }
 
-void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
+void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new,
+		     u64 last_generation)
 {
 	if (new) {
 		int id = new->id;
@@ -684,7 +685,7 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
 			sort_memslots(slots);
 	}
 
-	slots->generation++;
+	slots->generation = last_generation + 1;
 }
 
 static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
@@ -819,7 +820,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		slot = id_to_memslot(slots, mem->slot);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
-		update_memslots(slots, NULL);
+		update_memslots(slots, NULL, kvm->memslots->generation);
 
 		old_memslots = kvm->memslots;
 		rcu_assign_pointer(kvm->memslots, slots);
@@ -867,7 +868,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(&new.arch, 0, sizeof(new.arch));
 	}
 
-	update_memslots(slots, &new);
+	update_memslots(slots, &new, kvm->memslots->generation);
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
 	synchronize_srcu_expedited(&kvm->srcu);


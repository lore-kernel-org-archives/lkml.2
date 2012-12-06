Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391Ab2LFWVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 17:21:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965375Ab2LFWVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 17:21:21 -0500
Subject: [PATCH 09/10] kvm: struct kvm_memory_slot.id -> short
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Thu, 06 Dec 2012 15:21:20 -0700
Message-ID: <20121206222120.24968.66982.stgit@bling.home>
In-Reply-To: <20121206214722.24968.6043.stgit@bling.home>
References: <20121206214722.24968.6043.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're currently offering a whopping 32 memory slots to user space, an
int is a bit excessive for storing this.  We would like to increase
our memslots, but SHRT_MAX should be more than enough.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 include/linux/kvm_host.h |    4 ++--
 virt/kvm/kvm_main.c      |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 641f5fb..87089dd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -255,7 +255,7 @@ struct kvm_memory_slot {
 	struct kvm_arch_memory_slot arch;
 	unsigned long userspace_addr;
 	u32 flags;
-	int id;
+	short id;
 	bool user_alloc;
 };
 
@@ -315,7 +315,7 @@ struct kvm_memslots {
 	u64 generation;
 	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
 	/* The mapping table from slot id to the index in memslots[]. */
-	int id_to_index[KVM_MEM_SLOTS_NUM];
+	short id_to_index[KVM_MEM_SLOTS_NUM];
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6eeb101..6e4709f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -469,6 +469,8 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
 
+	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
+
 	r = -ENOMEM;
 	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 	if (!kvm->memslots)


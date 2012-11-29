Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2K2VIE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:08:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab2K2VID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:08:03 -0500
Subject: [PATCH v2] kvm: Fix user memslot overlap check
To: mtosatti@redhat.com, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Date: Thu, 29 Nov 2012 14:07:59 -0700
Message-ID: <20121129210725.9364.72668.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to memory slot sorting this loop compared all of the user memory
slots for overlap with new entries.  With memory slot sorting, we're
just checking some number of entries in the array that may or may not
be user slots.  Instead, walk all the slots with kvm_for_each_memslot,
which has the added benefit of terminating early when we hit the first
empty slot, and skip comparison to private slots.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
---

v2: Remove unused variable i

 virt/kvm/kvm_main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index be70035..6e8fa7e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -709,8 +709,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
-	unsigned long i;
-	struct kvm_memory_slot *memslot;
+	struct kvm_memory_slot *memslot, *slot;
 	struct kvm_memory_slot old, new;
 	struct kvm_memslots *slots, *old_memslots;
 
@@ -761,13 +760,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	/* Check for overlaps */
 	r = -EEXIST;
-	for (i = 0; i < KVM_MEMORY_SLOTS; ++i) {
-		struct kvm_memory_slot *s = &kvm->memslots->memslots[i];
-
-		if (s == memslot || !s->npages)
+	kvm_for_each_memslot(slot, kvm->memslots) {
+		if (slot->id >= KVM_MEMORY_SLOTS || slot == memslot)
 			continue;
-		if (!((base_gfn + npages <= s->base_gfn) ||
-		      (base_gfn >= s->base_gfn + s->npages)))
+		if (!((base_gfn + npages <= slot->base_gfn) ||
+		      (base_gfn >= slot->base_gfn + slot->npages)))
 			goto out_free;
 	}
 


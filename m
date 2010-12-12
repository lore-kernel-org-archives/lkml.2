Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0LLXqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36153 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab0LLXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:46 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: mst@redhat.com, avi@redhat.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [104/223] KVM: Write protect memory after slot swap
Message-Id: <20101212234644.B05DAB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Michael S. Tsirkin <mst@redhat.com>

commit edde99ce05290e50ce0b3495d209e54e6349ab47 upstream.

I have observed the following bug trigger:

1. userspace calls GET_DIRTY_LOG
2. kvm_mmu_slot_remove_write_access is called and makes a page ro
3. page fault happens and makes the page writeable
   fault is logged in the bitmap appropriately
4. kvm_vm_ioctl_get_dirty_log swaps slot pointers

a lot of time passes

5. guest writes into the page
6. userspace calls GET_DIRTY_LOG

At point (5), bitmap is clean and page is writeable,
thus, guest modification of memory is not logged
and GET_DIRTY_LOG returns an empty bitmap.

The rule is that all pages are either dirty in the current bitmap,
or write-protected, which is violated here.

It seems that just moving kvm_mmu_slot_remove_write_access down
to after the slot pointer swap should fix this bug.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kvm/x86.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/arch/x86/kvm/x86.c
===================================================================
--- linux.orig/arch/x86/kvm/x86.c
+++ linux/arch/x86/kvm/x86.c
@@ -2825,10 +2825,6 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 	if (is_dirty) {
 		struct kvm_memslots *slots, *old_slots;
 
-		spin_lock(&kvm->mmu_lock);
-		kvm_mmu_slot_remove_write_access(kvm, log->slot);
-		spin_unlock(&kvm->mmu_lock);
-
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 		if (!slots)
 			goto out_free;
@@ -2841,6 +2837,11 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 		synchronize_srcu_expedited(&kvm->srcu);
 		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
 		kfree(old_slots);
+
+		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		spin_unlock(&kvm->mmu_lock);
+
 	}
 
 	r = 0;

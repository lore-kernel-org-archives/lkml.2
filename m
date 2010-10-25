Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0JYB2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab0JYB2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:28:42 -0400
Date: Mon, 25 Oct 2010 03:21:24 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Gleb Natapov <gleb@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Sheng Yang <sheng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] kvm: write protect memory after slot swap
Message-ID: <20101025012124.GA31262@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Warning: completely untested.
Please comment.
Note: fix will be needed for -stable etc.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/x86.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3a09c62..4ca1d7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2912,10 +2912,6 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		struct kvm_memslots *slots, *old_slots;
 		unsigned long *dirty_bitmap;
 
-		spin_lock(&kvm->mmu_lock);
-		kvm_mmu_slot_remove_write_access(kvm, log->slot);
-		spin_unlock(&kvm->mmu_lock);
-
 		r = -ENOMEM;
 		dirty_bitmap = vmalloc(n);
 		if (!dirty_bitmap)
@@ -2937,6 +2933,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
 		kfree(old_slots);
 
+		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		spin_unlock(&kvm->mmu_lock);
+
 		r = -EFAULT;
 		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n)) {
 			vfree(dirty_bitmap);
-- 
1.7.3-rc1

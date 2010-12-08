Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab0LHBBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:48 -0500
Received: from kroah.org ([198.145.64.141]:49069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab0LHBBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:45 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:36 2010
Message-Id: <20101208005736.211061263@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [148/289] KVM: Write protect memory after slot swap
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 arch/x86/kvm/x86.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2912,10 +2912,6 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 		struct kvm_memslots *slots, *old_slots;
 		unsigned long *dirty_bitmap;
 
-		spin_lock(&kvm->mmu_lock);
-		kvm_mmu_slot_remove_write_access(kvm, log->slot);
-		spin_unlock(&kvm->mmu_lock);
-
 		r = -ENOMEM;
 		dirty_bitmap = vmalloc(n);
 		if (!dirty_bitmap)
@@ -2937,6 +2933,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kv
 		dirty_bitmap = old_slots->memslots[log->slot].dirty_bitmap;
 		kfree(old_slots);
 
+		spin_lock(&kvm->mmu_lock);
+		kvm_mmu_slot_remove_write_access(kvm, log->slot);
+		spin_unlock(&kvm->mmu_lock);
+
 		r = -EFAULT;
 		if (copy_to_user(log->dirty_bitmap, dirty_bitmap, n)) {
 			vfree(dirty_bitmap);



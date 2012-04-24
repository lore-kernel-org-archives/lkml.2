Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab2DXWvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:51:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2DXWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:25 -0400
Message-Id: <20120424223246.158425143@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 49/62] KVM: unmap pages from the iommu when slots are removed
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 32f6daad4651a748a58a3ab6da0611862175722f upstream.

We've been adding new mappings, but not destroying old mappings.
This can lead to a page leak as pages are pinned using
get_user_pages, but only unpinned with put_page if they still
exist in the memslots list on vm shutdown.  A memslot that is
destroyed while an iommu domain is enabled for the guest will
therefore result in an elevated page reference count that is
never cleared.

Additionally, without this fix, the iommu is only programmed
with the first translation for a gpa.  This can result in
peer-to-peer errors if a mapping is destroyed and replaced by a
new mapping at the same gpa as the iommu will still be pointing
to the original, pinned memory address.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/iommu.c         |    7 ++++++-
 virt/kvm/kvm_main.c      |    5 +++--
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -593,6 +593,7 @@ void kvm_free_irq_source_id(struct kvm *
 
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
@@ -606,6 +607,11 @@ static inline int kvm_iommu_map_pages(st
 	return 0;
 }
 
+static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
+					 struct kvm_memory_slot *slot)
+{
+}
+
 static inline int kvm_iommu_map_guest(struct kvm *kvm)
 {
 	return -ENODEV;
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -310,6 +310,11 @@ static void kvm_iommu_put_pages(struct k
 	}
 }
 
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	kvm_iommu_put_pages(kvm, slot->base_gfn, slot->npages);
+}
+
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
 	int idx;
@@ -320,7 +325,7 @@ static int kvm_iommu_unmap_memslots(stru
 	slots = kvm_memslots(kvm);
 
 	kvm_for_each_memslot(memslot, slots)
-		kvm_iommu_put_pages(kvm, memslot->base_gfn, memslot->npages);
+		kvm_iommu_unmap_pages(kvm, memslot);
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -873,12 +873,13 @@ skip_lpage:
 	if (r)
 		goto out_free;
 
-	/* map the pages in iommu page table */
+	/* map/unmap the pages in iommu page table */
 	if (npages) {
 		r = kvm_iommu_map_pages(kvm, &new);
 		if (r)
 			goto out_free;
-	}
+	} else
+		kvm_iommu_unmap_pages(kvm, &old);
 
 	r = -ENOMEM;
 	slots = kmemdup(kvm->memslots, sizeof(struct kvm_memslots),



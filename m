Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab2EIG0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:26:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38807 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab2EIFxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:01 -0400
Message-Id: <20120509055035.346281486@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 041/167] KVM: unmap pages from the iommu when slots are removed
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/iommu.c         |   12 ++++++++----
 virt/kvm/kvm_main.c      |    5 +++--
 3 files changed, 17 insertions(+), 6 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -554,6 +554,7 @@ void kvm_free_irq_source_id(struct kvm *
 
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
@@ -567,6 +568,11 @@ static inline int kvm_iommu_map_pages(st
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
@@ -285,6 +285,11 @@ static void kvm_iommu_put_pages(struct k
 	}
 }
 
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
+{
+	kvm_iommu_put_pages(kvm, slot->base_gfn, slot->npages);
+}
+
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 {
 	int i, idx;
@@ -293,10 +298,9 @@ static int kvm_iommu_unmap_memslots(stru
 	idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
 
-	for (i = 0; i < slots->nmemslots; i++) {
-		kvm_iommu_put_pages(kvm, slots->memslots[i].base_gfn,
-				    slots->memslots[i].npages);
-	}
+	for (i = 0; i < slots->nmemslots; i++)
+		kvm_iommu_unmap_pages(kvm, &slots->memslots[i]);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return 0;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -796,12 +796,13 @@ skip_lpage:
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
 	slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);



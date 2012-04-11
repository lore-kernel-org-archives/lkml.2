Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab2DKPvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab2DKPvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:51:52 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 1/2] kvm: unmap pages from the iommu when slots are removed
To: kvm@vger.kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, avi@redhat.com, jan.kiszka@siemens.com,
        mtosatti@redhat.com
Date: Wed, 11 Apr 2012 09:51:49 -0600
Message-ID: <20120411155149.13227.85904.stgit@bling.home>
In-Reply-To: <20120411154536.13227.10413.stgit@bling.home>
References: <20120411154536.13227.10413.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/iommu.c         |    7 ++++++-
 virt/kvm/kvm_main.c      |    5 +++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 665a260..72cbf08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -596,6 +596,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
@@ -609,6 +610,11 @@ static inline int kvm_iommu_map_pages(struct kvm *kvm,
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
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index a457d21..fec1723 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -310,6 +310,11 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
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
@@ -320,7 +325,7 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
 	slots = kvm_memslots(kvm);
 
 	kvm_for_each_memslot(memslot, slots)
-		kvm_iommu_put_pages(kvm, memslot->base_gfn, memslot->npages);
+		kvm_iommu_unmap_pages(kvm, memslot);
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 42b7393..9739b53 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -808,12 +808,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
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


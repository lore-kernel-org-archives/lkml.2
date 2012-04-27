Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab2D0VyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:54:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58121 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2D0VyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:54:13 -0400
Date: Fri, 27 Apr 2012 16:54:08 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [ 49/62] KVM: unmap pages from the iommu when slots are removed
Message-ID: <20120427215408.GD2821@burratino>
References: <20120424223305.GA7748@kroah.com>
 <20120424223246.158425143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424223246.158425143@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Greg KH wrote:

> 3.3-stable review patch.
[...]
> commit 32f6daad4651a748a58a3ab6da0611862175722f upstream.
>
> We've been adding new mappings, but not destroying old mappings.
> This can lead to a page leak

Does 3.0.y need this?  The patch does not apply as is to 3.0.y because
the latter lacks v3.3-rc1~131^2~41 ("KVM: introduce kvm_for_each_memslot
macro"), but a backport is straightforward.

Completely untested.  Test results and other comments welcome.

-- >8 --
From: Alex Williamson <alex.williamson@redhat.com>
Date: Wed, 11 Apr 2012 09:51:49 -0600

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
---
 include/linux/kvm_host.h |    6 ++++++
 virt/kvm/iommu.c         |   12 ++++++++----
 virt/kvm/kvm_main.c      |    5 +++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 31ebb59cbd2f..82d5476e69cc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -554,6 +554,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
 
 #ifdef CONFIG_IOMMU_API
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
 int kvm_iommu_map_guest(struct kvm *kvm);
 int kvm_iommu_unmap_guest(struct kvm *kvm);
 int kvm_assign_device(struct kvm *kvm,
@@ -567,6 +568,11 @@ static inline int kvm_iommu_map_pages(struct kvm *kvm,
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
index 62a9caf0563c..fb0f6e469bb4 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -285,6 +285,11 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
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
@@ -293,10 +298,9 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm)
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 96ebc0679415..6b39ba9540e8 100644
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
-- 
1.7.10


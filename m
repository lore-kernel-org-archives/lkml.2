Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2DRDqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:46:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab2DRDqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:46:47 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: lock slots_lock around device assignment
To: kvm@vger.kernel.org, mtosatti@redhat.com
Cc: alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        jbaron@redhat.com, jan.kiszka@siemens.com
Date: Tue, 17 Apr 2012 21:46:44 -0600
Message-ID: <20120418034537.26262.80743.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by Jason Baron, when assigning a device to a guest
we first set the iommu domain pointer, which enables mapping
and unmapping of memory slots to the iommu.  This leaves a window
where this path is enabled, but we haven't synchronized the iommu
mappings to the existing memory slots.  Thus a slot being removed
at that point could send us down unexpected code paths removing
non-existent pinnings and iommu mappings.  Take the slots_lock
around creating the iommu domain and initial mappings as well as
around iommu teardown to avoid this race.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/iommu.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index fec1723..e9fff98 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -240,9 +240,13 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		return -ENODEV;
 	}
 
+	mutex_lock(&kvm->slots_lock);
+
 	kvm->arch.iommu_domain = iommu_domain_alloc(&pci_bus_type);
-	if (!kvm->arch.iommu_domain)
-		return -ENOMEM;
+	if (!kvm->arch.iommu_domain) {
+		r = -ENOMEM;
+		goto out_unlock;
+	}
 
 	if (!allow_unsafe_assigned_interrupts &&
 	    !iommu_domain_has_cap(kvm->arch.iommu_domain,
@@ -253,17 +257,16 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 		       " module option.\n", __func__);
 		iommu_domain_free(kvm->arch.iommu_domain);
 		kvm->arch.iommu_domain = NULL;
-		return -EPERM;
+		r = -EPERM;
+		goto out_unlock;
 	}
 
 	r = kvm_iommu_map_memslots(kvm);
 	if (r)
-		goto out_unmap;
-
-	return 0;
+		kvm_iommu_unmap_memslots(kvm);
 
-out_unmap:
-	kvm_iommu_unmap_memslots(kvm);
+out_unlock:
+	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
 
@@ -340,7 +343,11 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 	if (!domain)
 		return 0;
 
+	mutex_lock(&kvm->slots_lock);
 	kvm_iommu_unmap_memslots(kvm);
+	kvm->arch.iommu_domain = NULL;
+	mutex_unlock(&kvm->slots_lock);
+
 	iommu_domain_free(domain);
 	return 0;
 }


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2E1D5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:57:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51795 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539Ab2E1D2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:28:55 -0400
Message-Id: <20120528031203.290249940@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 003/117] KVM: lock slots_lock around device assignment
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

From: Alex Williamson <alex.williamson@redhat.com>

(cherry picked from commit 21a1416a1c945c5aeaeaf791b63c64926018eb77)

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
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 virt/kvm/iommu.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index fd817a2..533db33 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -239,9 +239,13 @@ int kvm_iommu_map_guest(struct kvm *kvm)
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
@@ -252,17 +256,16 @@ int kvm_iommu_map_guest(struct kvm *kvm)
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
 
@@ -338,7 +341,11 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
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



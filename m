Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760748Ab2EJRgn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:36:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760618Ab2EJRgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:39 -0400
Message-Id: <20120510173136.725265629@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [ 44/52] KVM: lock slots_lock around device assignment
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


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
---
 virt/kvm/iommu.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

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
 
@@ -340,7 +343,11 @@ int kvm_iommu_unmap_guest(struct kvm *kv
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



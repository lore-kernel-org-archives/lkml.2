Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2APSul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:50:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756732Ab2APSu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:50:29 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:17 2012
Message-Id: <20120116184517.232107006@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [17/48] KVM: Remove ability to assign a device without iommu support
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Williamson <alex.williamson@redhat.com>

(cherry picked from commit 423873736b78f549fbfa2f715f2e4de7e6c5e1e9)

This option has no users and it exposes a security hole that we
can allow devices to be assigned without iommu protection.  Make
KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/virtual/kvm/api.txt |    3 +++
 virt/kvm/assigned-dev.c           |   18 +++++++++---------
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1131,6 +1131,9 @@ following flags are specified:
 /* Depends on KVM_CAP_IOMMU */
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 
+The KVM_DEV_ASSIGN_ENABLE_IOMMU flag is a mandatory option to ensure
+isolation of the device.  Usages not specifying this flag are deprecated.
+
 4.49 KVM_DEASSIGN_PCI_DEVICE
 
 Capability: KVM_CAP_DEVICE_DEASSIGNMENT
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -481,6 +481,9 @@ static int kvm_vm_ioctl_assign_device(st
 	struct kvm_assigned_dev_kernel *match;
 	struct pci_dev *dev;
 
+	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 	idx = srcu_read_lock(&kvm->srcu);
 
@@ -538,16 +541,14 @@ static int kvm_vm_ioctl_assign_device(st
 
 	list_add(&match->list, &kvm->arch.assigned_dev_head);
 
-	if (assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU) {
-		if (!kvm->arch.iommu_domain) {
-			r = kvm_iommu_map_guest(kvm);
-			if (r)
-				goto out_list_del;
-		}
-		r = kvm_assign_device(kvm, match);
+	if (!kvm->arch.iommu_domain) {
+		r = kvm_iommu_map_guest(kvm);
 		if (r)
 			goto out_list_del;
 	}
+	r = kvm_assign_device(kvm, match);
+	if (r)
+		goto out_list_del;
 
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -587,8 +588,7 @@ static int kvm_vm_ioctl_deassign_device(
 		goto out;
 	}
 
-	if (match->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
-		kvm_deassign_device(kvm, match);
+	kvm_deassign_device(kvm, match);
 
 	kvm_free_assigned_device(kvm, match);
 



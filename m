Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1LTDTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 22:19:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab1LTDTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 22:19:50 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/2] kvm: Remove ability to assign a device without iommu
 support
To: avi@redhat.com, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 19 Dec 2011 20:19:47 -0700
Message-ID: <20111220031947.11829.66292.stgit@bling.home>
In-Reply-To: <20111220030826.11829.9141.stgit@bling.home>
References: <20111220030826.11829.9141.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option has no users and it exposes a security hole that we
can allow devices to be assigned without iommu protection.  Make
KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/assigned-dev.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 3ad0925..a251a28 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -487,6 +487,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	struct kvm_assigned_dev_kernel *match;
 	struct pci_dev *dev;
 
+	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 	idx = srcu_read_lock(&kvm->srcu);
 
@@ -544,16 +547,14 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 
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
@@ -593,8 +594,7 @@ static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
 		goto out;
 	}
 
-	if (match->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
-		kvm_deassign_device(kvm, match);
+	kvm_deassign_device(kvm, match);
 
 	kvm_free_assigned_device(kvm, match);
 


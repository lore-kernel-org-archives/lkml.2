Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab2JAW7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 18:59:40 -0400
Received: from 1wt.eu ([62.212.114.60]:34976 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab2JAW7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:32 -0400
Message-Id: <20121001225159.140878047@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 036/180] KVM: Remove ability to assign a device without iommu support
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 423873736b78f549fbfa2f715f2e4de7e6c5e1e9 upstream

This option has no users and it exposes a security hole that we
can allow devices to be assigned without iommu protection.  Make
KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 virt/kvm/kvm_main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4f3434f..77288e2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -582,6 +582,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	struct kvm_assigned_dev_kernel *match;
 	struct pci_dev *dev;
 
+	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
+		return -EINVAL;
+
 	down_read(&kvm->slots_lock);
 	mutex_lock(&kvm->lock);
 
@@ -635,16 +638,14 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 
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
 	mutex_unlock(&kvm->lock);
@@ -683,8 +684,7 @@ static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
 		goto out;
 	}
 
-	if (match->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
-		kvm_deassign_device(kvm, match);
+	kvm_deassign_device(kvm, match);
 
 	kvm_free_assigned_device(kvm, match);
 
-- 
1.7.2.1.45.g54fbc




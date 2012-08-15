Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab2HOUi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:38:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:36358 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab2HOTtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 014/165] KVM: Remove ability to assign a device without iommu support
Date: Wed, 15 Aug 2012 15:45:58 -0400
Message-ID: <1345060109-9187-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 423873736b78f549fbfa2f715f2e4de7e6c5e1e9 upstream.

This option has no users and it exposes a security hole that we
can allow devices to be assigned without iommu protection.  Make
KVM_DEV_ASSIGN_ENABLE_IOMMU a mandatory option.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
[PG: drop Documentation chunk; no api.txt file in .34 baseline]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 virt/kvm/assigned-dev.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 02ff2b1..1f97473 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -509,6 +509,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	struct kvm_assigned_dev_kernel *match;
 	struct pci_dev *dev;
 
+	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU))
+		return -EINVAL;
+
 	mutex_lock(&kvm->lock);
 	idx = srcu_read_lock(&kvm->srcu);
 
@@ -564,16 +567,14 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 
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
@@ -610,8 +611,7 @@ static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
 		goto out;
 	}
 
-	if (match->flags & KVM_DEV_ASSIGN_ENABLE_IOMMU)
-		kvm_deassign_device(kvm, match);
+	kvm_deassign_device(kvm, match);
 
 	kvm_free_assigned_device(kvm, match);
 
-- 
1.7.12.rc2


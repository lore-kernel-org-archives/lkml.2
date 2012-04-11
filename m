Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2DKPwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 11:52:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2DKPv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 11:51:58 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 2/2] kvm: unpin guest and free iommu domain after deassign
 last device
To: kvm@vger.kernel.org
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, avi@redhat.com, jan.kiszka@siemens.com,
        mtosatti@redhat.com
Date: Wed, 11 Apr 2012 09:51:56 -0600
Message-ID: <20120411155156.13227.9696.stgit@bling.home>
In-Reply-To: <20120411154536.13227.10413.stgit@bling.home>
References: <20120411154536.13227.10413.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unpin the guest and free the iommu domain if there are no longer
any devices attached.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/assigned-dev.c |    3 +++
 virt/kvm/iommu.c        |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index 01f572c..01e7c37 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -765,6 +765,9 @@ static int kvm_vm_ioctl_deassign_device(struct kvm *kvm,
 
 	kvm_free_assigned_device(kvm, match);
 
+	if (list_empty(&kvm->arch.assigned_dev_head))
+		kvm_iommu_unmap_guest(kvm);
+
 out:
 	mutex_unlock(&kvm->lock);
 	return r;
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index fec1723..ee4c236 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -342,5 +342,6 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
 
 	kvm_iommu_unmap_memslots(kvm);
 	iommu_domain_free(domain);
+	kvm->arch.iommu_domain = NULL;
 	return 0;
 }


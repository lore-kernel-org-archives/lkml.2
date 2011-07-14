Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1GNT1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:27:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab1GNT1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:27:36 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: Disable device assignment without interrupt remapping
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        chrisw@redhat.com, ddutile@redhat.com,
        iommu@lists.linux-foundation.org
Date: Thu, 14 Jul 2011 13:27:03 -0600
Message-ID: <20110714192500.4065.28234.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IOMMU interrupt remapping support provides a further layer of
isolation for device assignment by preventing arbitrary interrupt
block DMA writes by a malicious guest from reaching the host.  By
default, we should require that the platform provides interrupt
remapping support, with an opt-in mechanism for existing behavior.

Both AMD IOMMU and Intel VT-d2 hardware support interrupt
remapping, however we currently only have software support on
the Intel side.  Users wishing to re-enable device assignment
when interrupt remapping is not supported on the platform can
use the "allow_unsafe_assigned_interrupts=1" module option.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 virt/kvm/iommu.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 62a9caf..243cb81 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -30,6 +30,12 @@
 #include <linux/iommu.h>
 #include <linux/intel-iommu.h>
 
+static int allow_unsafe_assigned_interrupts;
+module_param_named(allow_unsafe_assigned_interrupts,
+		   allow_unsafe_assigned_interrupts, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(allow_unsafe_assigned_interrupts,
+		 "Enable device assignment on platforms without interrupt remapping support.");
+
 static int kvm_iommu_unmap_memslots(struct kvm *kvm);
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
@@ -231,6 +237,15 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 	if (!kvm->arch.iommu_domain)
 		return -ENOMEM;
 
+	if (!allow_unsafe_assigned_interrupts &&
+	    !iommu_domain_has_cap(kvm->arch.iommu_domain,
+				  IOMMU_CAP_INTR_REMAP)) {
+		printk(KERN_WARNING "%s: No interrupt remapping support, disallowing device assignment.  Re-enble with \"allow_unsafe_assigned_interrupts=1\" module option.\n", __func__);
+		iommu_domain_free(kvm->arch.iommu_domain);
+		kvm->arch.iommu_domain = NULL;
+		return -EPERM;
+	}
+
 	r = kvm_iommu_map_memslots(kvm);
 	if (r)
 		goto out_unmap;


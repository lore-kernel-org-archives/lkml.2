Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2EFPVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 11:21:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:60488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab2EFPVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 11:21:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="162604697"
Date: Sun, 6 May 2012 23:24:05 +0800
From: Xudong Hao <xudong.hao@linux.intel.com>
To: avi@redhat.com, mtosatti@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, xiantao.zhang@intel.com,
        xudong.hao@intel.com
Subject: [PATCH] kvm: Enable device LTR/OBFF capibility before doing guest
	device assignment
Message-ID: <20120506152405.GA14009@hp-xd.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable device LTR/OBFF capibility before do device assignment, so that guest can benefit from them.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 virt/kvm/iommu.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index e9fff98..5139f2d 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -166,6 +166,10 @@ int kvm_assign_device(struct kvm *kvm,
    if (pdev == NULL)
        return -ENODEV;

+   /* Enable some device capibility before do device assignment,
+    * so that guest can benefit from them.
+    */
+   kvm_iommu_enable_dev_caps(pdev);
    r = iommu_attach_device(domain, &pdev->dev);
    if (r) {
        printk(KERN_ERR "assign device %x:%x:%x.%x failed",
@@ -228,6 +232,7 @@ int kvm_deassign_device(struct kvm *kvm,
        PCI_SLOT(assigned_dev->host_devfn),
        PCI_FUNC(assigned_dev->host_devfn));

+   kvm_iommu_disable_dev_caps(pdev);
    return 0;
 }

@@ -351,3 +356,30 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
    iommu_domain_free(domain);
    return 0;
 }
+
+static void kvm_iommu_enable_dev_caps(struct pci_dev *pdev)
+{
+   /* set default value */
+   unsigned long type = PCI_EXP_OBFF_SIGNAL_ALWAYS;
+   int snoop_lat_ns = 1024, nosnoop_lat_ns = 1024;
+
+   /* LTR(Latency tolerance reporting) allows devices to send
+    * messages to the root complex indicating their latency
+    * tolerance for snooped & unsnooped memory transactions.
+    */
+   pci_enable_ltr(pdev);
+   pci_set_ltr(pdev, snoop_lat_ns, nosnoop_lat_ns);
+
+   /* OBFF (optimized buffer flush/fill), where supported,
+    * can help improve energy efficiency by giving devices
+    * information about when interrupts and other activity
+    * will have a reduced power impact.
+    */
+   pci_enable_obff(pdev, type);
+}
+
+static void kvm_iommu_disable_dev_caps(struct pci_dev *pdev)
+{
+   pci_disble_obff(pdev);
+   pci_disble_ltr(pdev);
+}
--
1.6.0.rc1


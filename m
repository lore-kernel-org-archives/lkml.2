Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1DSUM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:12:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab1DSUMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:12:20 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v2 2/2] KVM: Use pci_store/load_saved_state() around VM device
	usage
To: linux-pci@vger.kernel.org, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com, avi@redhat.com, jbarnes@virtuousgeek.org
Date: Tue, 19 Apr 2011 14:12:17 -0600
Message-ID: <20110419201217.3739.66570.stgit@s20.home>
In-Reply-To: <20110419200912.3739.22895.stgit@s20.home>
References: <20110419200912.3739.22895.stgit@s20.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the device saved state so that we can reload the device back
to the original state when it's unassigned.  This has the benefit
that the state survives across pci_reset_function() calls via
the PCI sysfs reset interface while the VM is using the device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 include/linux/kvm_host.h |    1 +
 virt/kvm/assigned-dev.c  |    8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab42855..7099b67 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -513,6 +513,7 @@ struct kvm_assigned_dev_kernel {
 	struct kvm *kvm;
 	spinlock_t intx_lock;
 	char irq_name[32];
+	struct pci_state *pci_saved_state;
 };
 
 struct kvm_irq_mask_notifier {
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index ae72ae6..66c6ccd 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -197,7 +197,9 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 {
 	kvm_free_assigned_irq(kvm, assigned_dev);
 
-	__pci_reset_function(assigned_dev->dev);
+	pci_reset_function(assigned_dev->dev);
+	pci_load_and_free_saved_state(assigned_dev->dev,
+				      &assigned_dev->pci_saved_state);
 	pci_restore_state(assigned_dev->dev);
 
 	pci_release_regions(assigned_dev->dev);
@@ -516,7 +518,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 
 	pci_reset_function(dev);
 	pci_save_state(dev);
-
+	match->pci_saved_state = pci_store_saved_state(dev);
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
 	match->host_segnr = assigned_dev->segnr;
 	match->host_busnr = assigned_dev->busnr;
@@ -546,7 +548,7 @@ out:
 	mutex_unlock(&kvm->lock);
 	return r;
 out_list_del:
-	pci_restore_state(dev);
+	pci_load_and_free_saved_state(dev, &match->pci_saved_state);
 	list_del(&match->list);
 	pci_release_regions(dev);
 out_disable:


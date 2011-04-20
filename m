Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1DTUbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192Ab1DTUbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:31:48 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH v3 3/3] KVM: Use pci_store/load_saved_state() around VM device
	usage
To: linux-pci@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Cc: linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        jan.kiszka@siemens.com, jbarnes@virtuousgeek.org
Date: Wed, 20 Apr 2011 14:31:46 -0600
Message-ID: <20110420203146.3189.47203.stgit@s20.home>
In-Reply-To: <20110420202523.3189.31306.stgit@s20.home>
References: <20110420202523.3189.31306.stgit@s20.home>
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
 virt/kvm/assigned-dev.c  |   18 ++++++++++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab42855..9272db0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -513,6 +513,7 @@ struct kvm_assigned_dev_kernel {
 	struct kvm *kvm;
 	spinlock_t intx_lock;
 	char irq_name[32];
+	struct pci_saved_state *pci_saved_state;
 };
 
 struct kvm_irq_mask_notifier {
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index ae72ae6..6cc4b97 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -197,8 +197,13 @@ static void kvm_free_assigned_device(struct kvm *kvm,
 {
 	kvm_free_assigned_irq(kvm, assigned_dev);
 
-	__pci_reset_function(assigned_dev->dev);
-	pci_restore_state(assigned_dev->dev);
+	pci_reset_function(assigned_dev->dev);
+	if (pci_load_and_free_saved_state(assigned_dev->dev,
+					  &assigned_dev->pci_saved_state))
+		printk(KERN_INFO "%s: Couldn't reload %s saved state\n",
+		       __func__, dev_name(&assigned_dev->dev->dev));
+	else
+		pci_restore_state(assigned_dev->dev);
 
 	pci_release_regions(assigned_dev->dev);
 	pci_disable_device(assigned_dev->dev);
@@ -516,7 +521,10 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 
 	pci_reset_function(dev);
 	pci_save_state(dev);
-
+	match->pci_saved_state = pci_store_saved_state(dev);
+	if (!match->pci_saved_state)
+		printk(KERN_DEBUG "%s: Couldn't store %s saved state\n",
+		       __func__, dev_name(&dev->dev));
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
 	match->host_segnr = assigned_dev->segnr;
 	match->host_busnr = assigned_dev->busnr;
@@ -546,7 +554,9 @@ out:
 	mutex_unlock(&kvm->lock);
 	return r;
 out_list_del:
-	pci_restore_state(dev);
+	if (pci_load_and_free_saved_state(dev, &match->pci_saved_state))
+		printk(KERN_INFO "%s: Couldn't reload %s saved state\n",
+		       __func__, dev_name(&dev->dev));
 	list_del(&match->list);
 	pci_release_regions(dev);
 out_disable:


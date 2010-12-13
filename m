Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0LMXA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:00:28 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:38050 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab0LMXAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:00:23 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v3 4/4] KVM: Allow host IRQ sharing for passed-through PCI 2.3 devices
Date: Mon, 13 Dec 2010 23:59:46 +0100
Message-Id: <8a06dc49b728f8934c6726f2072d2e9af65df1da.1292281184.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
References: <cover.1292281184.git.jan.kiszka@web.de>
In-Reply-To: <cover.1292281184.git.jan.kiszka@web.de>
References: <cover.1292281184.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1909ywSYX8t247X2OrMgSq734Y9KwTmqNSwVeMP
	BuHuC2yGTFgrGJx+kvIS/ivkDUv4HuhAzJqEkLBWBxVm8g7V6I
	le1eK+9ZM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

PCI 2.3 allows to generically disable IRQ sources at device level. This
enables us to share IRQs of such devices on the host side when passing
them to a guest.

However, IRQ disabling via the PCI config space is more costly than
masking the line via disable_irq. Therefore we register the IRQ in adaptive
mode and switch between line and device level disabling on demand.

This feature is optional, user space has to request it explicitly as it
also has to inform us about its view of PCI_COMMAND_INTX_DISABLE. That
way, we can avoid unmasking the interrupt and signaling it if the guest
masked it via the PCI config space.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 Documentation/kvm/api.txt |   27 ++++
 arch/x86/kvm/x86.c        |    1 +
 include/linux/kvm.h       |    6 +
 include/linux/kvm_host.h  |   10 ++-
 virt/kvm/assigned-dev.c   |  336 ++++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 346 insertions(+), 34 deletions(-)

diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index e1a9297..1c34e25 100644
--- a/Documentation/kvm/api.txt
+++ b/Documentation/kvm/api.txt
@@ -1112,6 +1112,14 @@ following flags are specified:
 
 /* Depends on KVM_CAP_IOMMU */
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
+/* The following two depend on KVM_CAP_PCI_2_3 */
+#define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
+#define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
+
+If KVM_DEV_ASSIGN_PCI_2_3 is set, the kernel will manage legacy INTx interrupts
+via the PCI-2.3-compliant device-level mask, but only if IRQ sharing with other
+assigned or host devices requires it. KVM_DEV_ASSIGN_MASK_INTX specifies the
+guest's view on the INTx mask, see KVM_ASSIGN_SET_INTX_MASK for details.
 
 4.48 KVM_DEASSIGN_PCI_DEVICE
 
@@ -1263,6 +1271,25 @@ struct kvm_assigned_msix_entry {
 	__u16 padding[3];
 };
 
+4.54 KVM_ASSIGN_SET_INTX_MASK
+
+Capability: KVM_CAP_PCI_2_3
+Architectures: x86
+Type: vm ioctl
+Parameters: struct kvm_assigned_pci_dev (in)
+Returns: 0 on success, -1 on error
+
+Informs the kernel about the guest's view on the INTx mask. As long as the
+guest masks the legacy INTx, the kernel will refrain from unmasking it at
+hardware level and will not assert the guest's IRQ line. User space is still
+responsible for applying this state to the assigned device's real config space.
+To avoid that the kernel overwrites the state user space wants to set,
+KVM_ASSIGN_SET_INTX_MASK has to be called prior to updating the config space.
+
+See KVM_ASSIGN_DEV_IRQ for the data structure. The target device is specified
+by assigned_dev_id. In the flags field, only KVM_DEV_ASSIGN_MASK_INTX is
+evaluated.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed373ba..8775a54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1965,6 +1965,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
 	case KVM_CAP_ASYNC_PF:
+	case KVM_CAP_PCI_2_3:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index ea2dc1a..3cadb42 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -541,6 +541,7 @@ struct kvm_ppc_pvinfo {
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
 #define KVM_CAP_ASYNC_PF 59
+#define KVM_CAP_PCI_2_3 60
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -677,6 +678,9 @@ struct kvm_clock_data {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
+/* Available with KVM_CAP_PCI_2_3 */
+#define KVM_ASSIGN_SET_INTX_MASK  _IOW(KVMIO,  0xa2, \
+				       struct kvm_assigned_pci_dev)
 
 /*
  * ioctls for vcpu fds
@@ -742,6 +746,8 @@ struct kvm_clock_data {
 #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
 
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
+#define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
+#define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
 
 struct kvm_assigned_pci_dev {
 	__u32 assigned_dev_id;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ac4e83a..4f95070 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -477,6 +477,12 @@ struct kvm_irq_ack_notifier {
 	void (*irq_acked)(struct kvm_irq_ack_notifier *kian);
 };
 
+enum kvm_intx_state {
+	KVM_INTX_ENABLED,
+	KVM_INTX_LINE_DISABLED,
+	KVM_INTX_DEVICE_DISABLED,
+};
+
 struct kvm_assigned_dev_kernel {
 	struct kvm_irq_ack_notifier ack_notifier;
 	struct list_head list;
@@ -486,7 +492,7 @@ struct kvm_assigned_dev_kernel {
 	int host_devfn;
 	unsigned int entries_nr;
 	int host_irq;
-	bool host_irq_disabled;
+	unsigned long last_irq_status;
 	struct msix_entry *host_msix_entries;
 	int guest_irq;
 	struct msix_entry *guest_msix_entries;
@@ -496,6 +502,8 @@ struct kvm_assigned_dev_kernel {
 	struct pci_dev *dev;
 	struct kvm *kvm;
 	spinlock_t intx_lock;
+	spinlock_t intx_mask_lock;
+	enum kvm_intx_state intx_state;
 	char irq_name[32];
 };
 
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index c6114d3..b91a2db 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -55,22 +55,141 @@ static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
 	return index;
 }
 
-static irqreturn_t kvm_assigned_dev_thread(int irq, void *dev_id)
+static bool
+pci_2_3_set_irq_mask(struct pci_dev *dev, bool mask, bool check_status)
+{
+	u32 cmd_status_dword;
+	u16 origcmd, newcmd;
+	bool mask_updated = true;
+
+	/*
+	 * We do a single dword read to retrieve both command and status.
+	 * Document assumptions that make this possible.
+	 */
+	BUILD_BUG_ON(PCI_COMMAND % 4);
+	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
+
+	pci_block_user_cfg_access(dev);
+
+	/*
+	 * Read both command and status registers in a single 32-bit operation.
+	 * Note: we could cache the value for command and move the status read
+	 * out of the lock if there was a way to get notified of user changes
+	 * to command register through sysfs. Should be good for shared irqs.
+	 */
+	pci_read_config_dword(dev, PCI_COMMAND, &cmd_status_dword);
+
+	if (check_status) {
+		bool irq_pending =
+			(cmd_status_dword >> 16) & PCI_STATUS_INTERRUPT;
+
+		/*
+		 * Check interrupt status register to see whether our device
+		 * triggered the interrupt (when masking) or the next IRQ is
+		 * already pending (when unmasking).
+		 */
+		if (mask != irq_pending) {
+			mask_updated = false;
+			goto done;
+		}
+	}
+
+	origcmd = cmd_status_dword;
+	newcmd = origcmd & ~PCI_COMMAND_INTX_DISABLE;
+	if (mask)
+		newcmd |= PCI_COMMAND_INTX_DISABLE;
+	if (newcmd != origcmd)
+		pci_write_config_word(dev, PCI_COMMAND, newcmd);
+
+done:
+	pci_unblock_user_cfg_access(dev);
+	return mask_updated;
+}
+
+static void pci_2_3_irq_mask(struct pci_dev *dev)
+{
+	pci_2_3_set_irq_mask(dev, true, false);
+}
+
+static bool pci_2_3_irq_check_and_mask(struct pci_dev *dev)
+{
+	return pci_2_3_set_irq_mask(dev, true, true);
+}
+
+static void pci_2_3_irq_unmask(struct pci_dev *dev)
+{
+	pci_2_3_set_irq_mask(dev, false, false);
+}
+
+static bool pci_2_3_irq_check_and_unmask(struct pci_dev *dev)
+{
+	return pci_2_3_set_irq_mask(dev, false, true);
+}
+
+static irqreturn_t kvm_assigned_dev_intr_intx(int irq, void *dev_id)
+{
+	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
+	unsigned long irq_status = get_irq_status(irq);
+	int ret;
+
+	assigned_dev->last_irq_status = irq_status;
+
+	if (!(irq_status & (IRQS_SHARED | IRQS_MAKE_SHAREABLE)))
+		return IRQ_WAKE_THREAD;
+
+	spin_lock(&assigned_dev->intx_lock);
+
+	if (irq_status & IRQS_MAKE_SHAREABLE) {
+		if (assigned_dev->intx_state == KVM_INTX_LINE_DISABLED) {
+			pci_2_3_irq_mask(assigned_dev->dev);
+			enable_irq(irq);
+			assigned_dev->intx_state = KVM_INTX_DEVICE_DISABLED;
+		}
+		ret = IRQ_HANDLED;
+	} else if (pci_2_3_irq_check_and_mask(assigned_dev->dev)) {
+		assigned_dev->intx_state = KVM_INTX_DEVICE_DISABLED;
+		ret = IRQ_WAKE_THREAD;
+	} else
+		ret = IRQ_NONE;
+
+	spin_unlock(&assigned_dev->intx_lock);
+
+	return ret;
+}
+
+static irqreturn_t kvm_assigned_dev_thread_intx(int irq, void *dev_id)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
 
-	if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_INTX) {
-		spin_lock(&assigned_dev->intx_lock);
-		disable_irq_nosync(irq);
-		assigned_dev->host_irq_disabled = true;
-		spin_unlock(&assigned_dev->intx_lock);
+	if (!(assigned_dev->last_irq_status & IRQS_SHARED)) {
+		spin_lock_irq(&assigned_dev->intx_lock);
+		if (assigned_dev->intx_state == KVM_INTX_ENABLED) {
+			disable_irq_nosync(irq);
+			assigned_dev->intx_state = KVM_INTX_LINE_DISABLED;
+		}
+		spin_unlock_irq(&assigned_dev->intx_lock);
 	}
 
+	spin_lock(&assigned_dev->intx_mask_lock);
+	if (!(assigned_dev->flags & KVM_DEV_ASSIGN_MASK_INTX))
+		kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
+			    assigned_dev->guest_irq, 1);
+	spin_unlock(&assigned_dev->intx_mask_lock);
+
+	return IRQ_HANDLED;
+}
+
+#ifdef __KVM_HAVE_MSI
+static irqreturn_t kvm_assigned_dev_thread_msi(int irq, void *dev_id)
+{
+	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
+
 	kvm_set_irq(assigned_dev->kvm, assigned_dev->irq_source_id,
 		    assigned_dev->guest_irq, 1);
 
 	return IRQ_HANDLED;
 }
+#endif
 
 #ifdef __KVM_HAVE_MSIX
 static irqreturn_t kvm_assigned_dev_thread_msix(int irq, void *dev_id)
@@ -102,15 +221,36 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 
 	kvm_set_irq(dev->kvm, dev->irq_source_id, dev->guest_irq, 0);
 
-	/* The guest irq may be shared so this ack may be
-	 * from another device.
-	 */
-	spin_lock(&dev->intx_lock);
-	if (dev->host_irq_disabled) {
-		enable_irq(dev->host_irq);
-		dev->host_irq_disabled = false;
+	if (likely(!(dev->irq_requested_type & KVM_DEV_IRQ_HOST_INTX)))
+		return;
+
+	spin_lock(&dev->intx_mask_lock);
+
+	if (!(dev->flags & KVM_DEV_ASSIGN_MASK_INTX)) {
+		bool reassert = false;
+
+		spin_lock_irq(&dev->intx_lock);
+		/*
+		 * The guest IRQ may be shared so this ack can come from an
+		 * IRQ for another guest device.
+		 */
+		if (dev->intx_state == KVM_INTX_LINE_DISABLED) {
+			enable_irq(dev->host_irq);
+			dev->intx_state = KVM_INTX_ENABLED;
+		} else if (dev->intx_state == KVM_INTX_DEVICE_DISABLED) {
+			if (pci_2_3_irq_check_and_unmask(dev->dev))
+				dev->intx_state = KVM_INTX_ENABLED;
+			else
+				reassert = true;
+		}
+		spin_unlock_irq(&dev->intx_lock);
+
+		if (reassert)
+			kvm_set_irq(dev->kvm, dev->irq_source_id,
+				    dev->guest_irq, 1);
 	}
-	spin_unlock(&dev->intx_lock);
+
+	spin_unlock(&dev->intx_mask_lock);
 }
 
 static void deassign_guest_irq(struct kvm *kvm,
@@ -155,14 +295,21 @@ static void deassign_host_irq(struct kvm *kvm,
 		kfree(assigned_dev->host_msix_entries);
 		kfree(assigned_dev->guest_msix_entries);
 		pci_disable_msix(assigned_dev->dev);
+	} else if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI) {
+		free_irq(assigned_dev->host_irq, assigned_dev);
+		pci_disable_msi(assigned_dev->dev);
 	} else {
-		/* Deal with MSI and INTx */
-		disable_irq(assigned_dev->host_irq);
+		if (assigned_dev->flags & KVM_DEV_ASSIGN_PCI_2_3) {
+			spin_lock_irq(&assigned_dev->intx_lock);
+			pci_2_3_irq_mask(assigned_dev->dev);
+			/* prevent re-enabling by kvm_assigned_dev_ack_irq */
+			assigned_dev->intx_state = KVM_INTX_ENABLED;
+			spin_unlock_irq(&assigned_dev->intx_lock);
+			synchronize_irq(assigned_dev->host_irq);
+		} else
+			disable_irq(assigned_dev->host_irq);
 
 		free_irq(assigned_dev->host_irq, assigned_dev);
-
-		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI)
-			pci_disable_msi(assigned_dev->dev);
 	}
 
 	assigned_dev->irq_requested_type &= ~(KVM_DEV_IRQ_HOST_MASK);
@@ -231,16 +378,41 @@ void kvm_free_all_assigned_devices(struct kvm *kvm)
 static int assigned_device_enable_host_intx(struct kvm *kvm,
 					    struct kvm_assigned_dev_kernel *dev)
 {
+	irq_handler_t handler;
+	unsigned long flags;
+	int err;
+
 	dev->host_irq = dev->dev->irq;
-	/* Even though this is PCI, we don't want to use shared
-	 * interrupts. Sharing host devices with guest-assigned devices
-	 * on the same interrupt line is not a happy situation: there
-	 * are going to be long delays in accepting, acking, etc.
+	dev->intx_state = KVM_INTX_ENABLED;
+	dev->last_irq_status = 0;
+
+	/*
+	 * We can only share the IRQ line with other host devices if we are
+	 * able to disable the IRQ source at device-level - independently of
+	 * the guest driver. Otherwise host devices may suffer from unbounded
+	 * IRQ latencies when the guest keeps the line asserted.
+	 * If PCI 2.3 support is available, we can instal a sharing notifier
+	 * and apply the required disabling pattern on demand.
 	 */
-	if (request_threaded_irq(dev->host_irq, NULL, kvm_assigned_dev_thread,
-				 IRQF_ONESHOT, dev->irq_name, dev))
-		return -EIO;
-	return 0;
+	if (dev->flags & KVM_DEV_ASSIGN_PCI_2_3) {
+		handler = kvm_assigned_dev_intr_intx;
+		flags = IRQF_SHARED | IRQF_ADAPTIVE | IRQF_COND_ONESHOT;
+	} else {
+		handler = NULL;
+		flags = IRQF_ONESHOT;
+	}
+
+	err = request_threaded_irq(dev->host_irq, handler,
+				   kvm_assigned_dev_thread_intx, flags,
+				   dev->irq_name, dev);
+
+	if (!err && dev->flags & KVM_DEV_ASSIGN_PCI_2_3) {
+		spin_lock_irq(&dev->intx_lock);
+		pci_2_3_irq_unmask(dev->dev);
+		spin_unlock_irq(&dev->intx_lock);
+	}
+
+	return err;
 }
 
 #ifdef __KVM_HAVE_MSI
@@ -256,8 +428,9 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
 	}
 
 	dev->host_irq = dev->dev->irq;
-	if (request_threaded_irq(dev->host_irq, NULL, kvm_assigned_dev_thread,
-				 0, dev->irq_name, dev)) {
+	if (request_threaded_irq(dev->host_irq, NULL,
+				 kvm_assigned_dev_thread_msi, 0,
+				 dev->irq_name, dev)) {
 		pci_disable_msi(dev->dev);
 		return -EIO;
 	}
@@ -296,7 +469,6 @@ err:
 	pci_disable_msix(dev->dev);
 	return r;
 }
-
 #endif
 
 static int assigned_device_enable_guest_intx(struct kvm *kvm,
@@ -315,7 +487,6 @@ static int assigned_device_enable_guest_msi(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
-	dev->host_irq_disabled = false;
 	return 0;
 }
 #endif
@@ -327,7 +498,6 @@ static int assigned_device_enable_guest_msix(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
-	dev->host_irq_disabled = false;
 	return 0;
 }
 #endif
@@ -461,6 +631,7 @@ static int kvm_vm_ioctl_deassign_dev_irq(struct kvm *kvm,
 {
 	int r = -ENODEV;
 	struct kvm_assigned_dev_kernel *match;
+	unsigned long irq_type;
 
 	mutex_lock(&kvm->lock);
 
@@ -469,12 +640,51 @@ static int kvm_vm_ioctl_deassign_dev_irq(struct kvm *kvm,
 	if (!match)
 		goto out;
 
-	r = kvm_deassign_irq(kvm, match, assigned_irq->flags);
+	irq_type = assigned_irq->flags & (KVM_DEV_IRQ_HOST_MASK |
+					  KVM_DEV_IRQ_GUEST_MASK);
+	r = kvm_deassign_irq(kvm, match, irq_type);
 out:
 	mutex_unlock(&kvm->lock);
 	return r;
 }
 
+/*
+ * Verify that the device supports Interrupt Disable bit in command register,
+ * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
+ * in PCI 2.2.
+ */
+static bool pci_2_3_supported(struct pci_dev *pdev)
+{
+	u16 orig, new;
+
+	pci_block_user_cfg_access(pdev);
+
+	pci_read_config_word(pdev, PCI_COMMAND, &orig);
+	pci_write_config_word(pdev, PCI_COMMAND,
+			      orig ^ PCI_COMMAND_INTX_DISABLE);
+	pci_read_config_word(pdev, PCI_COMMAND, &new);
+	pci_write_config_word(pdev, PCI_COMMAND, orig);
+
+	pci_unblock_user_cfg_access(pdev);
+
+	/*
+	 * There's no way to protect against
+	 * hardware bugs or detect them reliably, but as long as we know
+	 * what the value should be, let's go ahead and check it.
+	 */
+	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
+		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
+			"driver or HW bug?\n", orig, new);
+		return false;
+	}
+	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
+		dev_warn(&pdev->dev, "Device does not support disabling "
+			 "interrupts, IRQ sharing impossible.\n");
+		return false;
+	}
+	return true;
+}
+
 static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 				      struct kvm_assigned_pci_dev *assigned_dev)
 {
@@ -523,6 +733,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	pci_reset_function(dev);
 	pci_save_state(dev);
 
+	if (!pci_2_3_supported(dev))
+		assigned_dev->flags &= ~KVM_DEV_ASSIGN_PCI_2_3;
+
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
 	match->host_segnr = assigned_dev->segnr;
 	match->host_busnr = assigned_dev->busnr;
@@ -530,6 +743,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	match->flags = assigned_dev->flags;
 	match->dev = dev;
 	spin_lock_init(&match->intx_lock);
+	spin_lock_init(&match->intx_mask_lock);
 	match->irq_source_id = -1;
 	match->kvm = kvm;
 	match->ack_notifier.irq_acked = kvm_assigned_dev_ack_irq;
@@ -676,6 +890,53 @@ msix_entry_out:
 }
 #endif
 
+static int kvm_vm_ioctl_set_pci_irq_mask(struct kvm *kvm,
+		struct kvm_assigned_pci_dev *assigned_dev)
+{
+	int r = 0;
+	struct kvm_assigned_dev_kernel *match;
+
+	mutex_lock(&kvm->lock);
+
+	match = kvm_find_assigned_dev(&kvm->arch.assigned_dev_head,
+				      assigned_dev->assigned_dev_id);
+	if (!match) {
+		r = -ENODEV;
+		goto out;
+	}
+
+	spin_lock(&match->intx_mask_lock);
+
+	match->flags &= ~KVM_DEV_ASSIGN_MASK_INTX;
+	match->flags |= assigned_dev->flags & KVM_DEV_ASSIGN_MASK_INTX;
+
+	if (assigned_dev->flags & KVM_DEV_ASSIGN_MASK_INTX) {
+		kvm_set_irq(match->kvm, match->irq_source_id,
+			    match->guest_irq, 0);
+		/*
+		 * Masking at hardware-level is performed on demand, i.e. when
+		 * an IRQ actually arrives at the host.
+		 */
+	} else {
+		/*
+		 * Unmask the IRQ line. It may have been masked meanwhile if
+		 * we aren't using PCI 2.3 INTx masking on the host side.
+		 */
+		spin_lock_irq(&match->intx_lock);
+		if (match->intx_state == KVM_INTX_LINE_DISABLED) {
+			enable_irq(match->host_irq);
+			match->intx_state = KVM_INTX_ENABLED;
+		}
+		spin_unlock_irq(&match->intx_lock);
+	}
+
+	spin_unlock(&match->intx_mask_lock);
+
+out:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
 				  unsigned long arg)
 {
@@ -783,6 +1044,15 @@ long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
 		break;
 	}
 #endif
+	case KVM_ASSIGN_SET_INTX_MASK: {
+		struct kvm_assigned_pci_dev assigned_dev;
+
+		r = -EFAULT;
+		if (copy_from_user(&assigned_dev, argp, sizeof assigned_dev))
+			goto out;
+		r = kvm_vm_ioctl_set_pci_irq_mask(kvm, &assigned_dev);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 		break;
-- 
1.7.1


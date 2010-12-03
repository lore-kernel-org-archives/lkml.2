Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0LCXht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:37:49 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:44078 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0LCXhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:37:39 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Thomas Gleixner <tglx@linutronix.de>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 5/5] KVM: Allow host IRQ sharing for passed-through PCI 2.3 devices
Date: Sat,  4 Dec 2010 00:37:31 +0100
Message-Id: <10b9265d513950f2574edf4e79be3b808e741a78.1291419444.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
In-Reply-To: <cover.1291419444.git.jan.kiszka@web.de>
References: <cover.1291419444.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX19/fiXYm7TtuxC0iAqI0YWNefc3FrFiT3R0VGQJ
	k41zfqw8UHpkxp5rzsFxBbWzV8hPPtWozwEsp6LMJ7fFoWSNos
	Qku7+6tD0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

PCI 2.3 allows to generically disable IRQ sources at device level. This
enables us to share IRQs of such devices on the host side when passing
them to a guest.

However, IRQ disabling via the PCI config space is more costly than
masking the line via disable_irq. Therefore we register an IRQ sharing
notifier and switch between line and device level disabling on demand.

This feature is optional, user space has to request it explicitly as it
also has to inform us about its view of PCI_COMMAND_INTX_DISABLE. That
way, we can avoid unmasking the interrupt and signaling it if the guest
masked it via the PCI config space.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 Documentation/kvm/api.txt |   25 +++
 arch/x86/kvm/x86.c        |    1 +
 include/linux/kvm.h       |    6 +
 include/linux/kvm_host.h  |    4 +
 virt/kvm/assigned-dev.c   |  382 +++++++++++++++++++++++++++++++++++++++++----
 5 files changed, 385 insertions(+), 33 deletions(-)

diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index e1a9297..5e164db 100644
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
 
@@ -1263,6 +1271,23 @@ struct kvm_assigned_msix_entry {
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
+
+See KVM_ASSIGN_DEV_IRQ for the data structure. The target device is specified
+by assigned_dev_id. In the flags field, only KVM_DEV_ASSIGN_MASK_INTX is
+evaluated.
+
 5. The kvm_run structure
 
 Application code obtains a pointer to the kvm_run structure by
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 410d2d1..c77c129 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1969,6 +1969,7 @@ int kvm_dev_ioctl_check_extension(long ext)
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
index da0794f..6849568 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -18,6 +18,7 @@
 #include <linux/msi.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
+#include <linux/notifier.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
@@ -485,6 +486,7 @@ struct kvm_assigned_dev_kernel {
 	unsigned int entries_nr;
 	int host_irq;
 	bool host_irq_disabled;
+	bool pci_2_3_masking;
 	struct msix_entry *host_msix_entries;
 	int guest_irq;
 	struct msix_entry *guest_msix_entries;
@@ -494,7 +496,9 @@ struct kvm_assigned_dev_kernel {
 	struct pci_dev *dev;
 	struct kvm *kvm;
 	spinlock_t intx_lock;
+	spinlock_t intx_mask_lock;
 	char irq_name[32];
+	struct notifier_block sh_notifier;
 };
 
 struct kvm_irq_mask_notifier {
diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index c6114d3..633bab3 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -55,22 +55,124 @@ static int find_index_from_host_irq(struct kvm_assigned_dev_kernel
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
+	int ret;
+
+	spin_lock(&assigned_dev->intx_lock);
+	if (pci_2_3_irq_check_and_mask(assigned_dev->dev)) {
+		assigned_dev->host_irq_disabled = true;
+		ret = IRQ_WAKE_THREAD;
+	} else
+		ret =IRQ_NONE;
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
+	if (!assigned_dev->pci_2_3_masking) {
+		spin_lock_irq(&assigned_dev->intx_lock);
 		disable_irq_nosync(irq);
 		assigned_dev->host_irq_disabled = true;
-		spin_unlock(&assigned_dev->intx_lock);
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
@@ -102,15 +204,114 @@ static void kvm_assigned_dev_ack_irq(struct kvm_irq_ack_notifier *kian)
 
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
+		if (dev->host_irq_disabled) {
+			if (!dev->pci_2_3_masking)
+				enable_irq(dev->host_irq);
+			else if (!pci_2_3_irq_check_and_unmask(dev->dev))
+				reassert = true;
+			dev->host_irq_disabled = reassert;
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
+}
+
+static int notify_host_irq(struct notifier_block *nb, unsigned long event,
+			   void *perror)
+{
+	struct kvm_assigned_dev_kernel *assigned_dev =
+		container_of(nb, struct kvm_assigned_dev_kernel, sh_notifier);
+	int *perr = perror;
+
+	switch (event) {
+	case IRQN_SHARED:
+		/* will be reenabled by request_threaded_irq */
+		disable_irq(assigned_dev->host_irq);
+
+		/* synchronize with kvm_assigned_dev_ack_irq */
+		spin_lock_irq(&assigned_dev->intx_lock);
+		if (assigned_dev->host_irq_disabled) {
+			/* reduce disabling depth here as we switch the type */
+			enable_irq(assigned_dev->host_irq);
+			assigned_dev->host_irq_disabled = false;
+		}
+		spin_unlock_irq(&assigned_dev->intx_lock);
+
+		free_irq(assigned_dev->host_irq, assigned_dev);
+		/* fall through */
+	case IRQN_SETUP_USED:
+		assigned_dev->pci_2_3_masking = true;
+		*perr = request_threaded_irq(assigned_dev->host_irq,
+					     kvm_assigned_dev_intr_intx,
+					     kvm_assigned_dev_thread_intx,
+					     IRQF_SHARED,
+					     assigned_dev->irq_name,
+					     assigned_dev);
+		if (*perr)
+			return NOTIFY_BAD;
+
+		spin_lock_irq(&assigned_dev->intx_lock);
+		pci_2_3_irq_unmask(assigned_dev->dev);
+		spin_unlock_irq(&assigned_dev->intx_lock);
+		break;
+	case IRQN_EXCLUSIVE:
+		/* will be reenabled by request_threaded_irq */
+		disable_irq(assigned_dev->host_irq);
+
+		/* synchronize with kvm_assigned_dev_ack_irq */
+		spin_lock_irq(&assigned_dev->intx_lock);
+		if (assigned_dev->host_irq_disabled) {
+			/* re-enable at PCI level as we switch the type */
+			pci_2_3_irq_unmask(assigned_dev->dev);
+			assigned_dev->host_irq_disabled = false;
+		}
+		spin_unlock_irq(&assigned_dev->intx_lock);
+
+		free_irq(assigned_dev->host_irq, assigned_dev);
+		/* fall through */
+	case IRQN_SETUP_UNUSED:
+		assigned_dev->pci_2_3_masking = false;
+		*perr = request_threaded_irq(assigned_dev->host_irq, NULL,
+					     kvm_assigned_dev_thread_intx,
+					     IRQF_ONESHOT,
+					     assigned_dev->irq_name,
+					     assigned_dev);
+		if (*perr)
+			return NOTIFY_BAD;
+		break;
+	case IRQN_SHUTDOWN:
+		if (assigned_dev->pci_2_3_masking) {
+			spin_lock_irq(&assigned_dev->intx_lock);
+			pci_2_3_irq_mask(assigned_dev->dev);
+			/* prevent re-enabling by kvm_assigned_dev_ack_irq */
+			assigned_dev->host_irq_disabled = false;
+			spin_unlock_irq(&assigned_dev->intx_lock);
+			synchronize_irq(assigned_dev->host_irq);
+		} else
+			disable_irq(assigned_dev->host_irq);
+
+		free_irq(assigned_dev->host_irq, assigned_dev);
+		break;
+	}
+	return NOTIFY_OK;
 }
 
 static void deassign_guest_irq(struct kvm *kvm,
@@ -132,6 +333,8 @@ static void deassign_guest_irq(struct kvm *kvm,
 static void deassign_host_irq(struct kvm *kvm,
 			      struct kvm_assigned_dev_kernel *assigned_dev)
 {
+	int unused;
+
 	/*
 	 * We disable irq here to prevent further events.
 	 *
@@ -155,15 +358,16 @@ static void deassign_host_irq(struct kvm *kvm,
 		kfree(assigned_dev->host_msix_entries);
 		kfree(assigned_dev->guest_msix_entries);
 		pci_disable_msix(assigned_dev->dev);
-	} else {
-		/* Deal with MSI and INTx */
-		disable_irq(assigned_dev->host_irq);
-
+	} else if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI) {
 		free_irq(assigned_dev->host_irq, assigned_dev);
-
-		if (assigned_dev->irq_requested_type & KVM_DEV_IRQ_HOST_MSI)
-			pci_disable_msi(assigned_dev->dev);
-	}
+		pci_disable_msi(assigned_dev->dev);
+	} else if (assigned_dev->flags & KVM_DEV_ASSIGN_PCI_2_3)
+		unregister_irq_sharing_notifier(assigned_dev->host_irq,
+						&assigned_dev->sh_notifier);
+	else
+		/* We have no notifier registered, so fire manually. */
+		notify_host_irq(&assigned_dev->sh_notifier, IRQN_SHUTDOWN,
+				&unused);
 
 	assigned_dev->irq_requested_type &= ~(KVM_DEV_IRQ_HOST_MASK);
 }
@@ -231,15 +435,28 @@ void kvm_free_all_assigned_devices(struct kvm *kvm)
 static int assigned_device_enable_host_intx(struct kvm *kvm,
 					    struct kvm_assigned_dev_kernel *dev)
 {
+	int unused;
+
 	dev->host_irq = dev->dev->irq;
-	/* Even though this is PCI, we don't want to use shared
-	 * interrupts. Sharing host devices with guest-assigned devices
-	 * on the same interrupt line is not a happy situation: there
-	 * are going to be long delays in accepting, acking, etc.
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
+	if (dev->flags & KVM_DEV_ASSIGN_PCI_2_3) {
+		dev->sh_notifier.notifier_call = notify_host_irq;
+		if (register_irq_sharing_notifier(dev->host_irq,
+						  &dev->sh_notifier))
+			return -EIO;
+	} else
+		/* Fire the notify manually for exclusive use. */
+		if (notify_host_irq(&dev->sh_notifier, IRQN_SETUP_UNUSED,
+				    &unused) != NOTIFY_OK)
+			return -EIO;
 	return 0;
 }
 
@@ -256,8 +473,9 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
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
@@ -296,7 +514,6 @@ err:
 	pci_disable_msix(dev->dev);
 	return r;
 }
-
 #endif
 
 static int assigned_device_enable_guest_intx(struct kvm *kvm,
@@ -315,7 +532,6 @@ static int assigned_device_enable_guest_msi(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
-	dev->host_irq_disabled = false;
 	return 0;
 }
 #endif
@@ -327,7 +543,6 @@ static int assigned_device_enable_guest_msix(struct kvm *kvm,
 {
 	dev->guest_irq = irq->guest_irq;
 	dev->ack_notifier.gsi = -1;
-	dev->host_irq_disabled = false;
 	return 0;
 }
 #endif
@@ -361,6 +576,7 @@ static int assign_host_irq(struct kvm *kvm,
 	default:
 		r = -EINVAL;
 	}
+	dev->host_irq_disabled = false;
 
 	if (!r)
 		dev->irq_requested_type |= host_irq_type;
@@ -461,6 +677,7 @@ static int kvm_vm_ioctl_deassign_dev_irq(struct kvm *kvm,
 {
 	int r = -ENODEV;
 	struct kvm_assigned_dev_kernel *match;
+	unsigned long irq_type;
 
 	mutex_lock(&kvm->lock);
 
@@ -469,12 +686,51 @@ static int kvm_vm_ioctl_deassign_dev_irq(struct kvm *kvm,
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
@@ -523,6 +779,9 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	pci_reset_function(dev);
 	pci_save_state(dev);
 
+	if (!pci_2_3_supported(dev))
+		assigned_dev->flags &= ~KVM_DEV_ASSIGN_PCI_2_3;
+
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
 	match->host_segnr = assigned_dev->segnr;
 	match->host_busnr = assigned_dev->busnr;
@@ -530,6 +789,7 @@ static int kvm_vm_ioctl_assign_device(struct kvm *kvm,
 	match->flags = assigned_dev->flags;
 	match->dev = dev;
 	spin_lock_init(&match->intx_lock);
+	spin_lock_init(&match->intx_mask_lock);
 	match->irq_source_id = -1;
 	match->kvm = kvm;
 	match->ack_notifier.irq_acked = kvm_assigned_dev_ack_irq;
@@ -676,6 +936,53 @@ msix_entry_out:
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
+		if (match->host_irq_disabled) {
+			enable_irq(match->host_irq);
+			match->host_irq_disabled = false;
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
@@ -783,6 +1090,15 @@ long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
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


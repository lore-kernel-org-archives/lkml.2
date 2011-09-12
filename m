Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab1ILQyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:54:25 -0400
Received: from thoth.sbs.de ([192.35.17.2]:27823 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab1ILQyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:54:21 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] pci: Rework config space blocking services
Date: Mon, 12 Sep 2011 18:54:02 +0200
Message-Id: <33234f96f761babf0e61dfe2cb5fe87cadc98d60.1315846441.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1315846441.git.jan.kiszka@siemens.com>
References: <cover.1315846441.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1315846441.git.jan.kiszka@siemens.com>
References: <cover.1315846441.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_block_user_cfg_access was designed for the use case that a single
context, the IPR driver, temporarily delays user space accesses to the
config space via sysfs. This assumption became invalid by the time
pci_dev_reset was added as locking instance. Today, if you run two loops
in parallel that reset the same device via sysfs, you end up with a
kernel BUG as pci_block_user_cfg_access detect the broken assumption.

This reworks the pci_block_user_cfg_access to a sleeping service
pci_cfg_access_lock and an atomic-compatible variant called
pci_cfg_access_trylock. The former not only blocks user space access as
before but also waits if access was already locked. The latter service
just returns false in this case, allowing the caller to resolve the
conflict instead of raising a BUG.

Adaptions of the ipr driver were originally written by Brian King.

CC: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/pci/access.c          |   74 ++++++++++++++++++++++++++--------------
 drivers/pci/iov.c             |   12 +++---
 drivers/pci/pci.c             |    4 +-
 drivers/scsi/ipr.c            |   66 ++++++++++++++++++++++++++++++++----
 drivers/scsi/ipr.h            |    1 +
 drivers/uio/uio_pci_generic.c |   10 +++--
 include/linux/pci.h           |   14 +++++---
 7 files changed, 131 insertions(+), 50 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index fdaa42a..0c4c717 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -127,20 +127,20 @@ EXPORT_SYMBOL(pci_write_vpd);
  * We have a bit per device to indicate it's blocked and a global wait queue
  * for callers to sleep on until devices are unblocked.
  */
-static DECLARE_WAIT_QUEUE_HEAD(pci_ucfg_wait);
+static DECLARE_WAIT_QUEUE_HEAD(pci_cfg_wait);
 
-static noinline void pci_wait_ucfg(struct pci_dev *dev)
+static noinline void pci_wait_cfg(struct pci_dev *dev)
 {
 	DECLARE_WAITQUEUE(wait, current);
 
-	__add_wait_queue(&pci_ucfg_wait, &wait);
+	__add_wait_queue(&pci_cfg_wait, &wait);
 	do {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		raw_spin_unlock_irq(&pci_lock);
 		schedule();
 		raw_spin_lock_irq(&pci_lock);
-	} while (dev->block_ucfg_access);
-	__remove_wait_queue(&pci_ucfg_wait, &wait);
+	} while (dev->block_cfg_access);
+	__remove_wait_queue(&pci_cfg_wait, &wait);
 }
 
 /* Returns 0 on success, negative values indicate error. */
@@ -153,7 +153,8 @@ int pci_user_read_config_##size						\
 	if (PCI_##size##_BAD)						\
 		return -EINVAL;						\
 	raw_spin_lock_irq(&pci_lock);				\
-	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
+	if (unlikely(dev->block_cfg_access))				\
+		pci_wait_cfg(dev);					\
 	ret = dev->bus->ops->read(dev->bus, dev->devfn,			\
 					pos, sizeof(type), &data);	\
 	raw_spin_unlock_irq(&pci_lock);				\
@@ -172,7 +173,8 @@ int pci_user_write_config_##size					\
 	if (PCI_##size##_BAD)						\
 		return -EINVAL;						\
 	raw_spin_lock_irq(&pci_lock);				\
-	if (unlikely(dev->block_ucfg_access)) pci_wait_ucfg(dev);	\
+	if (unlikely(dev->block_cfg_access))				\
+		pci_wait_cfg(dev);					\
 	ret = dev->bus->ops->write(dev->bus, dev->devfn,		\
 					pos, sizeof(type), val);	\
 	raw_spin_unlock_irq(&pci_lock);				\
@@ -401,36 +403,56 @@ int pci_vpd_truncate(struct pci_dev *dev, size_t size)
 EXPORT_SYMBOL(pci_vpd_truncate);
 
 /**
- * pci_block_user_cfg_access - Block userspace PCI config reads/writes
+ * pci_cfg_access_lock - Lock PCI config reads/writes
  * @dev:	pci device struct
  *
- * When user access is blocked, any reads or writes to config space will
- * sleep until access is unblocked again.  We don't allow nesting of
- * block/unblock calls.
+ * When access is locked, any userspace reads or writes to config
+ * space and concurrent lock requests will sleep until access is
+ * allowed via pci_cfg_access_unlocked again.
  */
-void pci_block_user_cfg_access(struct pci_dev *dev)
+void pci_cfg_access_lock(struct pci_dev *dev)
+{
+	might_sleep();
+
+	raw_spin_lock_irq(&pci_lock);
+	if (dev->block_cfg_access)
+		pci_wait_cfg(dev);
+	dev->block_cfg_access = 1;
+	raw_spin_unlock_irq(&pci_lock);
+}
+EXPORT_SYMBOL_GPL(pci_cfg_access_lock);
+
+/**
+ * pci_cfg_access_trylock - try to lock PCI config reads/writes
+ * @dev:	pci device struct
+ *
+ * Same as pci_cfg_access_lock, but will return 0 if access is
+ * already locked, 1 otherwise. This function can be used from
+ * atomic contexts.
+ */
+bool pci_cfg_access_trylock(struct pci_dev *dev)
 {
 	unsigned long flags;
-	int was_blocked;
+	bool locked = true;
 
 	raw_spin_lock_irqsave(&pci_lock, flags);
-	was_blocked = dev->block_ucfg_access;
-	dev->block_ucfg_access = 1;
+	if (dev->block_cfg_access)
+		locked = false;
+	else
+		dev->block_cfg_access = 1;
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 
-	/* If we BUG() inside the pci_lock, we're guaranteed to hose
-	 * the machine */
-	BUG_ON(was_blocked);
+	return locked;
 }
-EXPORT_SYMBOL_GPL(pci_block_user_cfg_access);
+EXPORT_SYMBOL_GPL(pci_cfg_access_trylock);
 
 /**
- * pci_unblock_user_cfg_access - Unblock userspace PCI config reads/writes
+ * pci_cfg_access_unlock - Unlock PCI config reads/writes
  * @dev:	pci device struct
  *
- * This function allows userspace PCI config accesses to resume.
+ * This function allows PCI config accesses to resume.
  */
-void pci_unblock_user_cfg_access(struct pci_dev *dev)
+void pci_cfg_access_unlock(struct pci_dev *dev)
 {
 	unsigned long flags;
 
@@ -438,10 +460,10 @@ void pci_unblock_user_cfg_access(struct pci_dev *dev)
 
 	/* This indicates a problem in the caller, but we don't need
 	 * to kill them, unlike a double-block above. */
-	WARN_ON(!dev->block_ucfg_access);
+	WARN_ON(!dev->block_cfg_access);
 
-	dev->block_ucfg_access = 0;
-	wake_up_all(&pci_ucfg_wait);
+	dev->block_cfg_access = 0;
+	wake_up_all(&pci_cfg_wait);
 	raw_spin_unlock_irqrestore(&pci_lock, flags);
 }
-EXPORT_SYMBOL_GPL(pci_unblock_user_cfg_access);
+EXPORT_SYMBOL_GPL(pci_cfg_access_unlock);
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 42fae47..e737b91 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -340,10 +340,10 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 	}
 
 	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
-	pci_block_user_cfg_access(dev);
+	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	msleep(100);
-	pci_unblock_user_cfg_access(dev);
+	pci_cfg_access_unlock(dev);
 
 	iov->initial = initial;
 	if (nr_virtfn < initial)
@@ -371,10 +371,10 @@ failed:
 		virtfn_remove(dev, j, 0);
 
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
-	pci_block_user_cfg_access(dev);
+	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	ssleep(1);
-	pci_unblock_user_cfg_access(dev);
+	pci_cfg_access_unlock(dev);
 
 	if (iov->link != dev->devfn)
 		sysfs_remove_link(&dev->dev.kobj, "dep_link");
@@ -397,10 +397,10 @@ static void sriov_disable(struct pci_dev *dev)
 		virtfn_remove(dev, i, 0);
 
 	iov->ctrl &= ~(PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE);
-	pci_block_user_cfg_access(dev);
+	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
 	ssleep(1);
-	pci_unblock_user_cfg_access(dev);
+	pci_cfg_access_unlock(dev);
 
 	if (iov->link != dev->devfn)
 		sysfs_remove_link(&dev->dev.kobj, "dep_link");
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0ce6742..208fe21 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2959,7 +2959,7 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
 	might_sleep();
 
 	if (!probe) {
-		pci_block_user_cfg_access(dev);
+		pci_cfg_access_lock(dev);
 		/* block PM suspend, driver probe, etc. */
 		device_lock(&dev->dev);
 	}
@@ -2984,7 +2984,7 @@ static int pci_dev_reset(struct pci_dev *dev, int probe)
 done:
 	if (!probe) {
 		device_unlock(&dev->dev);
-		pci_unblock_user_cfg_access(dev);
+		pci_cfg_access_unlock(dev);
 	}
 
 	return rc;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 8d63630..167c3dd 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7639,8 +7639,12 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmnd *ipr_cmd)
  **/
 static int ipr_reset_bist_done(struct ipr_cmnd *ipr_cmd)
 {
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+
 	ENTER;
-	pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
+	if (ioa_cfg->cfg_locked)
+		pci_cfg_access_unlock(ioa_cfg->pdev);
+	ioa_cfg->cfg_locked = 0;
 	ipr_cmd->job_step = ipr_reset_restore_cfg_space;
 	LEAVE;
 	return IPR_RC_JOB_CONTINUE;
@@ -7661,8 +7665,6 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 	int rc = PCIBIOS_SUCCESSFUL;
 
 	ENTER;
-	pci_block_user_cfg_access(ioa_cfg->pdev);
-
 	if (ioa_cfg->ipr_chip->bist_method == IPR_MMIO)
 		writel(IPR_UPROCI_SIS64_START_BIST,
 		       ioa_cfg->regs.set_uproc_interrupt_reg32);
@@ -7674,7 +7676,9 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_cmd)
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc = IPR_RC_JOB_RETURN;
 	} else {
-		pci_unblock_user_cfg_access(ipr_cmd->ioa_cfg->pdev);
+		if (ioa_cfg->cfg_locked)
+			pci_cfg_access_unlock(ipr_cmd->ioa_cfg->pdev);
+		ioa_cfg->cfg_locked = 0;
 		ipr_cmd->s.ioasa.hdr.ioasc = cpu_to_be32(IPR_IOASC_PCI_ACCESS_ERROR);
 		rc = IPR_RC_JOB_CONTINUE;
 	}
@@ -7717,7 +7721,6 @@ static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
 	struct pci_dev *pdev = ioa_cfg->pdev;
 
 	ENTER;
-	pci_block_user_cfg_access(pdev);
 	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
 	ipr_cmd->job_step = ipr_reset_slot_reset_done;
 	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
@@ -7726,6 +7729,55 @@ static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
 }
 
 /**
+ * ipr_reset_block_config_access_wait - Wait for permission to block config access
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This attempts to block config access to the IOA.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE / IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_block_config_access_wait(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	int rc = IPR_RC_JOB_CONTINUE;
+
+	if (pci_cfg_access_trylock(ioa_cfg->pdev)) {
+		ioa_cfg->cfg_locked = 1;
+		ipr_cmd->job_step = ioa_cfg->reset;
+	} else {
+		if (ipr_cmd->u.time_left) {
+			rc = IPR_RC_JOB_RETURN;
+			ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
+			ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
+		} else {
+			ipr_cmd->job_step = ioa_cfg->reset;
+			dev_err(&ioa_cfg->pdev->dev,
+				"Timed out waiting to lock config access. Resetting anyway.\n");
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * ipr_reset_block_config_access - Block config access to the IOA
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This attempts to block config access to the IOA
+ *
+ * Return value:
+ * 	IPR_RC_JOB_CONTINUE
+ **/
+static int ipr_reset_block_config_access(struct ipr_cmnd *ipr_cmd)
+{
+	ipr_cmd->ioa_cfg->cfg_locked = 0;
+	ipr_cmd->job_step = ipr_reset_block_config_access_wait;
+	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
+	return IPR_RC_JOB_CONTINUE;
+}
+
+/**
  * ipr_reset_allowed - Query whether or not IOA can be reset
  * @ioa_cfg:	ioa config struct
  *
@@ -7764,7 +7816,7 @@ static int ipr_reset_wait_to_start_bist(struct ipr_cmnd *ipr_cmd)
 		ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
 		ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
 	} else {
-		ipr_cmd->job_step = ioa_cfg->reset;
+		ipr_cmd->job_step = ipr_reset_block_config_access;
 		rc = IPR_RC_JOB_CONTINUE;
 	}
 
@@ -7797,7 +7849,7 @@ static int ipr_reset_alert(struct ipr_cmnd *ipr_cmd)
 		writel(IPR_UPROCI_RESET_ALERT, ioa_cfg->regs.set_uproc_interrupt_reg32);
 		ipr_cmd->job_step = ipr_reset_wait_to_start_bist;
 	} else {
-		ipr_cmd->job_step = ioa_cfg->reset;
+		ipr_cmd->job_step = ipr_reset_block_config_access;
 	}
 
 	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index f93f863..dbb40c0 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1384,6 +1384,7 @@ struct ipr_ioa_cfg {
 	u8 needs_warm_reset:1;
 	u8 msi_received:1;
 	u8 sis64:1;
+	u8 cfg_locked:1;
 
 	u8 revid;
 
diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index fc22e1e..67535f9 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -58,7 +58,8 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
 	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
 
 	spin_lock_irq(&gdev->lock);
-	pci_block_user_cfg_access(pdev);
+	if (!pci_cfg_access_trylock(pdev))
+		goto error;
 
 	/* Read both command and status registers in a single 32-bit operation.
 	 * Note: we could cache the value for command and move the status read
@@ -82,7 +83,8 @@ static irqreturn_t irqhandler(int irq, struct uio_info *info)
 	ret = IRQ_HANDLED;
 done:
 
-	pci_unblock_user_cfg_access(pdev);
+	pci_cfg_access_lock(pdev);
+error:
 	spin_unlock_irq(&gdev->lock);
 	return ret;
 }
@@ -95,7 +97,7 @@ static int __devinit verify_pci_2_3(struct pci_dev *pdev)
 	u16 orig, new;
 	int err = 0;
 
-	pci_block_user_cfg_access(pdev);
+	pci_cfg_access_lock(pdev);
 	pci_read_config_word(pdev, PCI_COMMAND, &orig);
 	pci_write_config_word(pdev, PCI_COMMAND,
 			      orig ^ PCI_COMMAND_INTX_DISABLE);
@@ -118,7 +120,7 @@ static int __devinit verify_pci_2_3(struct pci_dev *pdev)
 	/* Now restore the original value. */
 	pci_write_config_word(pdev, PCI_COMMAND, orig);
 err:
-	pci_unblock_user_cfg_access(pdev);
+	pci_cfg_access_unlock(pdev);
 	return err;
 }
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 8c230cb..0e84de6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -305,7 +305,7 @@ struct pci_dev {
 	unsigned int	is_added:1;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
-	unsigned int	block_ucfg_access:1;	/* userspace config space access is blocked */
+	unsigned int	block_cfg_access:1;	/* config space access is blocked */
 	unsigned int	broken_parity_status:1;	/* Device generates false positive parity */
 	unsigned int	irq_reroute_variant:2;	/* device needs IRQ rerouting variant */
 	unsigned int 	msi_enabled:1;
@@ -1079,8 +1079,9 @@ int  ht_create_irq(struct pci_dev *dev, int idx);
 void ht_destroy_irq(unsigned int irq);
 #endif /* CONFIG_HT_IRQ */
 
-extern void pci_block_user_cfg_access(struct pci_dev *dev);
-extern void pci_unblock_user_cfg_access(struct pci_dev *dev);
+extern void pci_cfg_access_lock(struct pci_dev *dev);
+extern bool pci_cfg_access_trylock(struct pci_dev *dev);
+extern void pci_cfg_access_unlock(struct pci_dev *dev);
 
 /*
  * PCI domain support.  Sometimes called PCI segment (eg by ACPI),
@@ -1277,10 +1278,13 @@ static inline void pci_release_regions(struct pci_dev *dev)
 
 #define pci_dma_burst_advice(pdev, strat, strategy_parameter) do { } while (0)
 
-static inline void pci_block_user_cfg_access(struct pci_dev *dev)
+static inline void pci_block_cfg_access(struct pci_dev *dev)
 { }
 
-static inline void pci_unblock_user_cfg_access(struct pci_dev *dev)
+static inline int pci_block_cfg_access_in_atomic(struct pci_dev *dev)
+{ return 0; }
+
+static inline void pci_unblock_cfg_access(struct pci_dev *dev)
 { }
 
 static inline struct pci_bus *pci_find_next_bus(const struct pci_bus *from)
-- 
1.7.3.4


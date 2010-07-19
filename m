Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966382Ab0GSSlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 14:41:03 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:15072 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966360Ab0GSSkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 14:40:53 -0400
Subject: [PATCH 20/26] cciss: fix hard reset code.
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Mon, 19 Jul 2010 13:46:22 -0500
Message-ID: <20100719184622.7908.84986.stgit@beardog.cce.hp.com>
In-Reply-To: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
References: <20100719184141.7908.26971.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Fix hard reset code.
Smart Array controllers newer than the P600 do not honor the
PCI power state method of resetting the controllers.  Instead,
in these cases we can get them to reset via the "doorbell" register.

This escaped notice until we began using "performant" mode because
the fact that the controllers did not reset did not normally
impede subsequent operation, and so things generally appeared to
"work".  Once the performant mode code was added, if the controller
does not reset, it remains in performant mode.  The code immediately
after the reset presumes the controller is in "simple" mode
(which previously, it had remained in simple mode the whole time).
If the controller remains in performant mode any code which presumes
it is in simple mode will not work.  So the reset needs to be fixed.

Unfortunately there are some controllers which cannot be reset by
either method. (eg. p800).  We detect these cases by noticing that
the controller seems to remain in performant mode even after a
reset has been attempted.  In those cases we ignore the controller,
as any commands outstanding on it will result in stale completions.
To sum up, we try to do a better job of resetting the controller if
"reset_devices" is set, and if it doesn't work, we ignore that
controller.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c     |  200 +++++++++++++++++++++++++++++++++------------
 drivers/block/cciss_cmd.h |    4 +
 2 files changed, 152 insertions(+), 52 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index f49dcd7..b3060ec 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -216,6 +216,12 @@ static void cciss_device_release(struct device *dev);
 static void cciss_free_gendisk(ctlr_info_t *h, int drv_index);
 static void cciss_free_drive_info(ctlr_info_t *h, int drv_index);
 static inline u32 next_command(ctlr_info_t *h);
+static int __devinit cciss_find_cfg_addrs(struct pci_dev *pdev,
+	void __iomem *vaddr, u32 *cfg_base_addr, u64 *cfg_base_addr_index,
+	u64 *cfg_offset);
+static int __devinit cciss_pci_find_memory_BAR(struct pci_dev *pdev,
+	unsigned long *memory_bar);
+
 
 /* performant mode helper functions */
 static void  calc_bucket_map(int *bucket, int num_buckets, int nsgs,
@@ -4413,68 +4419,130 @@ static __devinit int cciss_reset_msi(struct pci_dev *pdev)
 	return 0;
 }
 
-/* This does a hard reset of the controller using PCI power management
- * states. */
-static __devinit int cciss_hard_reset_controller(struct pci_dev *pdev)
+static int cciss_controller_hard_reset(struct pci_dev *pdev,
+	void * __iomem vaddr, bool use_doorbell)
 {
-	u16 pmcsr, saved_config_space[32];
-	int i, pos;
+	u16 pmcsr;
+	int pos;
 
-	printk(KERN_INFO "cciss: using PCI PM to reset controller\n");
+	if (use_doorbell) {
+		/* For everything after the P600, the PCI power state method
+		 * of resetting the controller doesn't work, so we have this
+		 * other way using the doorbell register.
+		 */
+		dev_info(&pdev->dev, "using doorbell to reset controller\n");
+		writel(DOORBELL_CTLR_RESET, vaddr + SA5_DOORBELL);
+		msleep(1000);
+	} else { /* Try to do it the PCI power state way */
+
+		/* Quoting from the Open CISS Specification: "The Power
+		 * Management Control/Status Register (CSR) controls the power
+		 * state of the device.  The normal operating state is D0,
+		 * CSR=00h.  The software off state is D3, CSR=03h.  To reset
+		 * the controller, place the interface device in D3 then to D0,
+		 * this causes a secondary PCI reset which will reset the
+		 * controller." */
+
+		pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
+		if (pos == 0) {
+			dev_err(&pdev->dev,
+				"cciss_controller_hard_reset: "
+				"PCI PM not supported\n");
+			return -ENODEV;
+		}
+		dev_info(&pdev->dev, "using PCI PM to reset controller\n");
+		/* enter the D3hot power management state */
+		pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
+		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+		pmcsr |= PCI_D3hot;
+		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
-	/* This is very nearly the same thing as
+		msleep(500);
 
-	   pci_save_state(pci_dev);
-	   pci_set_power_state(pci_dev, PCI_D3hot);
-	   pci_set_power_state(pci_dev, PCI_D0);
-	   pci_restore_state(pci_dev);
+		/* enter the D0 power management state */
+		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
+		pmcsr |= PCI_D0;
+		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
 
-	   but we can't use these nice canned kernel routines on
-	   kexec, because they also check the MSI/MSI-X state in PCI
-	   configuration space and do the wrong thing when it is
-	   set/cleared.  Also, the pci_save/restore_state functions
-	   violate the ordering requirements for restoring the
-	   configuration space from the CCISS document (see the
-	   comment below).  So we roll our own .... */
+		msleep(500);
+	}
+	return 0;
+}
+
+/* This does a hard reset of the controller using PCI power management
+ * states or using the doorbell register. */
+static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
+{
+	u16 saved_config_space[32];
+	u64 cfg_offset;
+	u32 cfg_base_addr;
+	u64 cfg_base_addr_index;
+	void __iomem *vaddr;
+	unsigned long paddr;
+	u32 misc_fw_support, active_transport;
+	int rc, i;
+	CfgTable_struct __iomem *cfgtable;
+	bool use_doorbell;
+
+	/* For controllers as old a the p600, this is very nearly
+	 * the same thing as
+	 *
+	 * pci_save_state(pci_dev);
+	 * pci_set_power_state(pci_dev, PCI_D3hot);
+	 * pci_set_power_state(pci_dev, PCI_D0);
+	 * pci_restore_state(pci_dev);
+	 *
+	 * but we can't use these nice canned kernel routines on
+	 * kexec, because they also check the MSI/MSI-X state in PCI
+	 * configuration space and do the wrong thing when it is
+	 * set/cleared.  Also, the pci_save/restore_state functions
+	 * violate the ordering requirements for restoring the
+	 * configuration space from the CCISS document (see the
+	 * comment below).  So we roll our own ....
+	 *
+	 * For controllers newer than the P600, the pci power state
+	 * method of resetting doesn't work so we have another way
+	 * using the doorbell register.
+	 */
 
 	for (i = 0; i < 32; i++)
 		pci_read_config_word(pdev, 2*i, &saved_config_space[i]);
 
-	pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
-	if (pos == 0) {
-		printk(KERN_ERR "cciss_reset_controller: PCI PM not supported\n");
-		return -ENODEV;
-	}
-
-	/* Quoting from the Open CISS Specification: "The Power
-	 * Management Control/Status Register (CSR) controls the power
-	 * state of the device.  The normal operating state is D0,
-	 * CSR=00h.  The software off state is D3, CSR=03h.  To reset
-	 * the controller, place the interface device in D3 then to
-	 * D0, this causes a secondary PCI reset which will reset the
-	 * controller." */
-
-	/* enter the D3hot power management state */
-	pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
-	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-	pmcsr |= PCI_D3hot;
-	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+	/* find the first memory BAR, so we can find the cfg table */
+	rc = cciss_pci_find_memory_BAR(pdev, &paddr);
+	if (rc)
+		return rc;
+	vaddr = remap_pci_mem(paddr, 0x250);
+	if (!vaddr)
+		return -ENOMEM;
 
-	schedule_timeout_uninterruptible(HZ >> 1);
+	/* find cfgtable in order to check if reset via doorbell is supported */
+	rc = cciss_find_cfg_addrs(pdev, vaddr, &cfg_base_addr,
+					&cfg_base_addr_index, &cfg_offset);
+	if (rc)
+		goto unmap_vaddr;
+	cfgtable = remap_pci_mem(pci_resource_start(pdev,
+		       cfg_base_addr_index) + cfg_offset, sizeof(*cfgtable));
+	if (!cfgtable) {
+		rc = -ENOMEM;
+		goto unmap_vaddr;
+	}
 
-	/* enter the D0 power management state */
-	pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-	pmcsr |= PCI_D0;
-	pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+	/* If reset via doorbell register is supported, use that. */
+	misc_fw_support = readl(&cfgtable->misc_fw_support);
+	use_doorbell = misc_fw_support & MISC_FW_DOORBELL_RESET;
 
-	schedule_timeout_uninterruptible(HZ >> 1);
+	rc = cciss_controller_hard_reset(pdev, vaddr, use_doorbell);
+	if (rc)
+		goto unmap_cfgtable;
 
 	/* Restore the PCI configuration space.  The Open CISS
 	 * Specification says, "Restore the PCI Configuration
 	 * Registers, offsets 00h through 60h. It is important to
 	 * restore the command register, 16-bits at offset 04h,
 	 * last. Do not restore the configuration status register,
-	 * 16-bits at offset 06h."  Note that the offset is 2*i. */
+	 * 16-bits at offset 06h."  Note that the offset is 2*i.
+	 */
 	for (i = 0; i < 32; i++) {
 		if (i == 2 || i == 3)
 			continue;
@@ -4483,23 +4551,51 @@ static __devinit int cciss_hard_reset_controller(struct pci_dev *pdev)
 	wmb();
 	pci_write_config_word(pdev, 4, saved_config_space[2]);
 
-	return 0;
+	/* Some devices (notably the HP Smart Array 5i Controller)
+	   need a little pause here */
+	msleep(CCISS_POST_RESET_PAUSE_MSECS);
+
+	/* Controller should be in simple mode at this point.  If it's not,
+	 * It means we're on one of those controllers which doesn't support
+	 * the doorbell reset method and on which the PCI power management reset
+	 * method doesn't work (P800, for example.)
+	 * In those cases, don't try to proceed, as it generally doesn't work.
+	 */
+	active_transport = readl(&cfgtable->TransportActive);
+	if (active_transport & PERFORMANT_MODE) {
+		dev_warn(&pdev->dev, "Unable to successfully reset controller,"
+			" Ignoring controller.\n");
+		rc = -ENODEV;
+	}
+
+unmap_cfgtable:
+	iounmap(cfgtable);
+
+unmap_vaddr:
+	iounmap(vaddr);
+	return rc;
 }
 
 static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 {
-	int i;
+	int rc, i;
 
 	if (!reset_devices)
 		return 0;
 
-	/* Reset the controller with a PCI power-cycle */
-	if (cciss_hard_reset_controller(pdev) || cciss_reset_msi(pdev))
-		return -ENODEV;
+	/* Reset the controller with a PCI power-cycle or via doorbell */
+	rc = cciss_kdump_hard_reset_controller(pdev);
 
-	/* Some devices (notably the HP Smart Array 5i Controller)
-	   need a little pause here */
-	msleep(CCISS_POST_RESET_PAUSE_MSECS);
+	/* -ENOTSUPP here means we cannot reset the controller
+	 * but it's already (and still) up and running in
+	 * "performant mode".
+	 */
+	if (rc == -ENOTSUPP)
+		return 0; /* just try to do the kdump anyhow. */
+	if (rc)
+		return -ENODEV;
+	if (cciss_reset_msi(pdev))
+		return -ENODEV;
 
 	/* Now try to get the controller to respond to a no-op */
 	for (i = 0; i < CCISS_POST_RESET_NOOP_RETRIES; i++) {
diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index 936b966..eb060f1 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -52,6 +52,7 @@
 /* Configuration Table */
 #define CFGTBL_ChangeReq        0x00000001l
 #define CFGTBL_AccCmds          0x00000001l
+#define DOORBELL_CTLR_RESET     0x00000004l
 
 #define CFGTBL_Trans_Simple     0x00000002l
 #define CFGTBL_Trans_Performant 0x00000004l
@@ -230,6 +231,9 @@ typedef struct _CfgTable_struct {
   DWORD            MaxPhysicalDrives;
   DWORD            MaxPhysicalDrivesPerLogicalUnit;
   DWORD            MaxPerformantModeCommands;
+  u8		   reserved[0x78 - 0x58];
+  u32		   misc_fw_support; /* offset 0x78 */
+#define MISC_FW_DOORBELL_RESET (0x02)
 } CfgTable_struct;
 
 struct TransTable_struct {


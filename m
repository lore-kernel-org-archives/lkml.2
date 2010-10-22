Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0JVTVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:21:15 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:45672 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848Ab0JVTVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:21:13 -0400
Subject: [PATCH 3/5] cciss: Use kernel provided PCI state save and restore
	functions
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, smcameron@yahoo.com,
        linux-kernel@vger.kernel.org, mike.miller@hp.com, thenzl@redhat.com
Date: Fri, 22 Oct 2010 14:21:12 -0500
Message-ID: <20101022192112.25567.24572.stgit@beardog.cce.hp.com>
In-Reply-To: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
References: <20101022191738.25567.43468.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

and use the doorbell reset method if available (which doesn't
lock up the controller if you properly save and restore all
the PCI registers that you're supposed to.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   73 ++++++++++---------------------------------------
 1 files changed, 15 insertions(+), 58 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index a9e9db4..03afef8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4321,36 +4321,6 @@ static __devinit int cciss_message(struct pci_dev *pdev, unsigned char opcode, u
 #define cciss_soft_reset_controller(p) cciss_message(p, 1, 0)
 #define cciss_noop(p) cciss_message(p, 3, 0)
 
-static __devinit int cciss_reset_msi(struct pci_dev *pdev)
-{
-/* the #defines are stolen from drivers/pci/msi.h. */
-#define msi_control_reg(base)		(base + PCI_MSI_FLAGS)
-#define PCI_MSIX_FLAGS_ENABLE		(1 << 15)
-
-	int pos;
-	u16 control = 0;
-
-	pos = pci_find_capability(pdev, PCI_CAP_ID_MSI);
-	if (pos) {
-		pci_read_config_word(pdev, msi_control_reg(pos), &control);
-		if (control & PCI_MSI_FLAGS_ENABLE) {
-			dev_info(&pdev->dev, "resetting MSI\n");
-			pci_write_config_word(pdev, msi_control_reg(pos), control & ~PCI_MSI_FLAGS_ENABLE);
-		}
-	}
-
-	pos = pci_find_capability(pdev, PCI_CAP_ID_MSIX);
-	if (pos) {
-		pci_read_config_word(pdev, msi_control_reg(pos), &control);
-		if (control & PCI_MSIX_FLAGS_ENABLE) {
-			dev_info(&pdev->dev, "resetting MSI-X\n");
-			pci_write_config_word(pdev, msi_control_reg(pos), control & ~PCI_MSIX_FLAGS_ENABLE);
-		}
-	}
-
-	return 0;
-}
-
 static int cciss_controller_hard_reset(struct pci_dev *pdev,
 	void * __iomem vaddr, bool use_doorbell)
 {
@@ -4405,17 +4375,17 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
  * states or using the doorbell register. */
 static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 {
-	u16 saved_config_space[32];
 	u64 cfg_offset;
 	u32 cfg_base_addr;
 	u64 cfg_base_addr_index;
 	void __iomem *vaddr;
 	unsigned long paddr;
 	u32 misc_fw_support, active_transport;
-	int rc, i;
+	int rc;
 	CfgTable_struct __iomem *cfgtable;
 	bool use_doorbell;
 	u32 board_id;
+	u16 command_register;
 
 	/* For controllers as old a the p600, this is very nearly
 	 * the same thing as
@@ -4425,14 +4395,6 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * pci_set_power_state(pci_dev, PCI_D0);
 	 * pci_restore_state(pci_dev);
 	 *
-	 * but we can't use these nice canned kernel routines on
-	 * kexec, because they also check the MSI/MSI-X state in PCI
-	 * configuration space and do the wrong thing when it is
-	 * set/cleared.  Also, the pci_save/restore_state functions
-	 * violate the ordering requirements for restoring the
-	 * configuration space from the CCISS document (see the
-	 * comment below).  So we roll our own ....
-	 *
 	 * For controllers newer than the P600, the pci power state
 	 * method of resetting doesn't work so we have another way
 	 * using the doorbell register.
@@ -4451,8 +4413,13 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < 32; i++)
-		pci_read_config_word(pdev, 2*i, &saved_config_space[i]);
+	/* Save the PCI command register */
+	pci_read_config_word(pdev, 4, &command_register);
+	/* Turn the board off.  This is so that later pci_restore_state()
+	 * won't turn the board on before the rest of config space is ready.
+	 */
+	pci_disable_device(pdev);
+	pci_save_state(pdev);
 
 	/* find the first memory BAR, so we can find the cfg table */
 	rc = cciss_pci_find_memory_BAR(pdev, &paddr);
@@ -4481,21 +4448,13 @@ static __devinit int cciss_kdump_hard_reset_controller(struct pci_dev *pdev)
 	rc = cciss_controller_hard_reset(pdev, vaddr, use_doorbell);
 	if (rc)
 		goto unmap_cfgtable;
-
-	/* Restore the PCI configuration space.  The Open CISS
-	 * Specification says, "Restore the PCI Configuration
-	 * Registers, offsets 00h through 60h. It is important to
-	 * restore the command register, 16-bits at offset 04h,
-	 * last. Do not restore the configuration status register,
-	 * 16-bits at offset 06h."  Note that the offset is 2*i.
-	 */
-	for (i = 0; i < 32; i++) {
-		if (i == 2 || i == 3)
-			continue;
-		pci_write_config_word(pdev, 2*i, saved_config_space[i]);
+	pci_restore_state(pdev);
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_warn(&pdev->dev, "failed to enable device.\n");
+		goto unmap_cfgtable;
 	}
-	wmb();
-	pci_write_config_word(pdev, 4, saved_config_space[2]);
+	pci_write_config_word(pdev, 4, command_register);
 
 	/* Some devices (notably the HP Smart Array 5i Controller)
 	   need a little pause here */
@@ -4555,8 +4514,6 @@ static __devinit int cciss_init_reset_devices(struct pci_dev *pdev)
 		return 0; /* just try to do the kdump anyhow. */
 	if (rc)
 		return -ENODEV;
-	if (cciss_reset_msi(pdev))
-		return -ENODEV;
 
 	/* Now try to get the controller to respond to a no-op */
 	for (i = 0; i < CCISS_POST_RESET_NOOP_RETRIES; i++) {


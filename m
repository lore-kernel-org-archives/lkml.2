Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab1KDIrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 04:47:07 -0400
Received: from goliath.siemens.de ([192.35.17.28]:16681 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1KDIqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 04:46:15 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 3/3] uio: Convert uio_generic_pci to new intx masking API
Date: Fri,  4 Nov 2011 09:46:01 +0100
Message-Id: <42ec400c740f784d21eb63da8d5d8083be6f6933.1320396359.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1320396359.git.jan.kiszka@siemens.com>
References: <cover.1320396359.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1320396359.git.jan.kiszka@siemens.com>
References: <cover.1320396359.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new PCI API provides both generic probing for 2.3 masking support
and check&mask in the interrupt handler.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/uio/uio_pci_generic.c |   77 +++-------------------------------------
 1 files changed, 6 insertions(+), 71 deletions(-)

diff --git a/drivers/uio/uio_pci_generic.c b/drivers/uio/uio_pci_generic.c
index 56d00c62..0bd08ef 100644
--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -45,78 +45,12 @@ to_uio_pci_generic_dev(struct uio_info *info)
 static irqreturn_t irqhandler(int irq, struct uio_info *info)
 {
 	struct uio_pci_generic_dev *gdev = to_uio_pci_generic_dev(info);
-	struct pci_dev *pdev = gdev->pdev;
-	irqreturn_t ret = IRQ_NONE;
-	u32 cmd_status_dword;
-	u16 origcmd, newcmd, status;
-
-	/* We do a single dword read to retrieve both command and status.
-	 * Document assumptions that make this possible. */
-	BUILD_BUG_ON(PCI_COMMAND % 4);
-	BUILD_BUG_ON(PCI_COMMAND + 2 != PCI_STATUS);
-
-	if (!pci_cfg_access_trylock(pdev))
-		goto error;
-
-	/* Read both command and status registers in a single 32-bit operation.
-	 * Note: we could cache the value for command and move the status read
-	 * out of the lock if there was a way to get notified of user changes
-	 * to command register through sysfs. Should be good for shared irqs. */
-	pci_read_config_dword(pdev, PCI_COMMAND, &cmd_status_dword);
-	origcmd = cmd_status_dword;
-	status = cmd_status_dword >> 16;
-
-	/* Check interrupt status register to see whether our device
-	 * triggered the interrupt. */
-	if (!(status & PCI_STATUS_INTERRUPT))
-		goto done;
-
-	/* We triggered the interrupt, disable it. */
-	newcmd = origcmd | PCI_COMMAND_INTX_DISABLE;
-	if (newcmd != origcmd)
-		pci_write_config_word(pdev, PCI_COMMAND, newcmd);
 
-	/* UIO core will signal the user process. */
-	ret = IRQ_HANDLED;
-done:
-
-	pci_cfg_access_lock(pdev);
-	return ret;
-}
+	if (!pci_check_and_mask_intx(gdev->pdev))
+		return IRQ_NONE;
 
-/* Verify that the device supports Interrupt Disable bit in command register,
- * per PCI 2.3, by flipping this bit and reading it back: this bit was readonly
- * in PCI 2.2. */
-static int __devinit verify_pci_2_3(struct pci_dev *pdev)
-{
-	u16 orig, new;
-	int err = 0;
-
-	pci_cfg_access_lock(pdev);
-	pci_read_config_word(pdev, PCI_COMMAND, &orig);
-	pci_write_config_word(pdev, PCI_COMMAND,
-			      orig ^ PCI_COMMAND_INTX_DISABLE);
-	pci_read_config_word(pdev, PCI_COMMAND, &new);
-	/* There's no way to protect against
-	 * hardware bugs or detect them reliably, but as long as we know
-	 * what the value should be, let's go ahead and check it. */
-	if ((new ^ orig) & ~PCI_COMMAND_INTX_DISABLE) {
-		err = -EBUSY;
-		dev_err(&pdev->dev, "Command changed from 0x%x to 0x%x: "
-			"driver or HW bug?\n", orig, new);
-		goto err;
-	}
-	if (!((new ^ orig) & PCI_COMMAND_INTX_DISABLE)) {
-		dev_warn(&pdev->dev, "Device does not support "
-			 "disabling interrupts: unable to bind.\n");
-		err = -ENODEV;
-		goto err;
-	}
-	/* Now restore the original value. */
-	pci_write_config_word(pdev, PCI_COMMAND, orig);
-err:
-	pci_cfg_access_unlock(pdev);
-	return err;
+	/* UIO core will signal the user process. */
+	return IRQ_HANDLED;
 }
 
 static int __devinit probe(struct pci_dev *pdev,
@@ -139,9 +73,10 @@ static int __devinit probe(struct pci_dev *pdev,
 		return -ENODEV;
 	}
 
-	err = verify_pci_2_3(pdev);
-	if (err)
+	if (!pci_intx_mask_supported(pdev)) {
+		err = -ENODEV;
 		goto err_verify;
+	}
 
 	gdev = kzalloc(sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
 	if (!gdev) {
-- 
1.7.3.4


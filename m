Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab2EIJBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:01:51 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40575 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab2EIJBs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 9 May 2012 05:01:48 -0400
Message-Id: <4FAA4B1F0200007800082708@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 09:46:55 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <sarah.a.sharp@linux.intel.com>, <gregkh@linuxfoundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH 3/5, resend] USB: adjust PCI quirk handler section
 annotations
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation to adjust modpost to check section mismatches
on most of the .pci_fixup* sections:

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM.

Handler (and eventual static data) section annotations need to/can be
changed accordingly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/usb/host/pci-quirks.c     |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- 3.4-rc6/drivers/usb/host/pci-quirks.c
+++ 3.4-rc6-pci-fixup-sections/drivers/usb/host/pci-quirks.c
@@ -431,7 +431,7 @@ reset_needed:
 }
 EXPORT_SYMBOL_GPL(uhci_check_and_reset_hc);
 
-static inline int io_type_enabled(struct pci_dev *pdev, unsigned int mask)
+static int __init io_type_enabled(struct pci_dev *pdev, unsigned int mask)
 {
 	u16 cmd;
 	return !pci_read_config_word(pdev, PCI_COMMAND, &cmd) && (cmd & mask);
@@ -440,7 +440,7 @@ static inline int io_type_enabled(struct
 #define pio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_IO)
 #define mmio_enabled(dev) io_type_enabled(dev, PCI_COMMAND_MEMORY)
 
-static void __devinit quirk_usb_handoff_uhci(struct pci_dev *pdev)
+static void __init quirk_usb_handoff_uhci(struct pci_dev *pdev)
 {
 	unsigned long base = 0;
 	int i;
@@ -458,12 +458,12 @@ static void __devinit quirk_usb_handoff_
 		uhci_check_and_reset_hc(pdev, base);
 }
 
-static int __devinit mmio_resource_enabled(struct pci_dev *pdev, int idx)
+static int __init mmio_resource_enabled(struct pci_dev *pdev, int idx)
 {
 	return pci_resource_start(pdev, idx) && mmio_enabled(pdev);
 }
 
-static void __devinit quirk_usb_handoff_ohci(struct pci_dev *pdev)
+static void __init quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
 	u32 control;
@@ -530,7 +530,7 @@ static void __devinit quirk_usb_handoff_
 	iounmap(base);
 }
 
-static const struct dmi_system_id __devinitconst ehci_dmi_nohandoff_table[] = {
+static const struct dmi_system_id __initconst ehci_dmi_nohandoff_table[] = {
 	{
 		/*  Pegatron Lucid (ExoPC) */
 		.matches = {
@@ -548,9 +548,9 @@ static const struct dmi_system_id __devi
 	{ }
 };
 
-static void __devinit ehci_bios_handoff(struct pci_dev *pdev,
-					void __iomem *op_reg_base,
-					u32 cap, u8 offset)
+static void __init ehci_bios_handoff(struct pci_dev *pdev,
+				     void __iomem *op_reg_base,
+				     u32 cap, u8 offset)
 {
 	int try_handoff = 1, tried_handoff = 0;
 
@@ -616,7 +616,7 @@ static void __devinit ehci_bios_handoff(
 		writel(0, op_reg_base + EHCI_CONFIGFLAG);
 }
 
-static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
+static void __init quirk_usb_disable_ehci(struct pci_dev *pdev)
 {
 	void __iomem *base, *op_reg_base;
 	u32	hcc_params, cap, val;
@@ -696,8 +696,8 @@ static void __devinit quirk_usb_disable_
  * Returns -ETIMEDOUT if this condition is not true after
  * wait_usec microseconds have passed.
  */
-static int handshake(void __iomem *ptr, u32 mask, u32 done,
-		int wait_usec, int delay_usec)
+static int __init handshake(void __iomem *ptr, u32 mask, u32 done,
+			    int wait_usec, int delay_usec)
 {
 	u32	result;
 
@@ -778,7 +778,7 @@ EXPORT_SYMBOL_GPL(usb_enable_xhci_ports)
  * and then waits 5 seconds for the BIOS to hand over control.
  * If we timeout, assume the BIOS is broken and take control anyway.
  */
-static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
+static void __init quirk_usb_handoff_xhci(struct pci_dev *pdev)
 {
 	void __iomem *base;
 	int ext_cap_offset;
@@ -869,7 +869,7 @@ hc_init:
 	iounmap(base);
 }
 
-static void __devinit quirk_usb_early_handoff(struct pci_dev *pdev)
+static void __init quirk_usb_early_handoff(struct pci_dev *pdev)
 {
 	/* Skip Netlogic mips SoC's internal PCI USB controller.
 	 * This device does not need/support EHCI/OHCI handoff




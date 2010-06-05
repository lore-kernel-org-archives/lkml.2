Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0FEKdv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 06:33:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:52502 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab0FEKdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 06:33:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 5 Jun 2010 12:31:25 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: ohci: add MSI support
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4BD5667B.1030900@ladisch.de>
Message-ID: <tkrat.d549e28752108628@s5r6.in-berlin.de>
References: <4BD5667B.1030900@ladisch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clemens Ladisch <clemens@ladisch.de>

This patch adds support for message-signaled interrupts.

Any native PCI-Express OHCI controller should support MSI, but most are
just PCI cores behind a PCI-E/PCI bridge.  The only chips that are known
to claim to support MSI are the Lucent/Agere/LSI FW643 and the VIA
VT6315, none of which I have been able to test.

Due to the high level of trust I have in the competence of these and any
future chip makers, I thought it a good idea to add a disable-MSI quirk.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Tested Agere FW643 rev 07 [11c1:5901] and JMicron JMB381 [197b:2380].
Added a quirks list entry for the one of them which kept its count of
MSI events consistently at zero.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/ohci.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: b/drivers/firewire/ohci.c
===================================================================
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -231,12 +231,14 @@ static inline struct fw_ohci *fw_ohci(st
 
 static char ohci_driver_name[] = KBUILD_MODNAME;
 
+#define PCI_DEVICE_ID_JMICRON_JMB38X_FW	0x2380
 #define PCI_DEVICE_ID_TI_TSB12LV22	0x8009
 
 #define QUIRK_CYCLE_TIMER		1
 #define QUIRK_RESET_PACKET		2
 #define QUIRK_BE_HEADERS		4
 #define QUIRK_NO_1394A			8
+#define QUIRK_NO_MSI			16
 
 /* In case of multiple matches in ohci_quirks[], only the first one is used. */
 static const struct {
@@ -247,6 +249,7 @@ static const struct {
 							    QUIRK_NO_1394A},
 	{PCI_VENDOR_ID_TI,	PCI_ANY_ID,	QUIRK_RESET_PACKET},
 	{PCI_VENDOR_ID_AL,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
+	{PCI_VENDOR_ID_JMICRON,	PCI_DEVICE_ID_JMICRON_JMB38X_FW, QUIRK_NO_MSI},
 	{PCI_VENDOR_ID_NEC,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_VIA,	PCI_ANY_ID,	QUIRK_CYCLE_TIMER},
 	{PCI_VENDOR_ID_APPLE,	PCI_DEVICE_ID_APPLE_UNI_N_FW, QUIRK_BE_HEADERS},
@@ -260,6 +263,7 @@ MODULE_PARM_DESC(quirks, "Chip quirks (d
 	", reset packet generation = "	__stringify(QUIRK_RESET_PACKET)
 	", AR/selfID endianess = "	__stringify(QUIRK_BE_HEADERS)
 	", no 1394a enhancements = "	__stringify(QUIRK_NO_1394A)
+	", disable MSI = "		__stringify(QUIRK_NO_MSI)
 	")");
 
 #define OHCI_PARAM_DEBUG_AT_AR		1
@@ -1709,10 +1713,13 @@ static int ohci_enable(struct fw_card *c
 
 	reg_write(ohci, OHCI1394_AsReqFilterHiSet, 0x80000000);
 
+	if (!(ohci->quirks & QUIRK_NO_MSI))
+		pci_enable_msi(dev);
 	if (request_irq(dev->irq, irq_handler,
-			IRQF_SHARED, ohci_driver_name, ohci)) {
-		fw_error("Failed to allocate shared interrupt %d.\n",
-			 dev->irq);
+			pci_dev_msi_enabled(dev) ? 0 : IRQF_SHARED,
+			ohci_driver_name, ohci)) {
+		fw_error("Failed to allocate interrupt %d.\n", dev->irq);
+		pci_disable_msi(dev);
 		dma_free_coherent(ohci->card.device, CONFIG_ROM_SIZE,
 				  ohci->config_rom, ohci->config_rom_bus);
 		return -EIO;
@@ -2627,6 +2634,7 @@ static void pci_remove(struct pci_dev *d
 	context_release(&ohci->at_response_ctx);
 	kfree(ohci->it_context_list);
 	kfree(ohci->ir_context_list);
+	pci_disable_msi(dev);
 	pci_iounmap(dev, ohci->registers);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
@@ -2644,6 +2652,7 @@ static int pci_suspend(struct pci_dev *d
 
 	software_reset(ohci);
 	free_irq(dev->irq, ohci);
+	pci_disable_msi(dev);
 	err = pci_save_state(dev);
 	if (err) {
 		fw_error("pci_save_state failed\n");

-- 
Stefan Richter
-=====-==-=- -==- --=-=
http://arcgraph.de/sr/


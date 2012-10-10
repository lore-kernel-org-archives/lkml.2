Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab2JJWxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:53:47 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58570 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414Ab2JJWxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:53:41 -0400
X-Sasl-enc: 29yKiIiDsZ0RE4TmRpK3hE+CSEH6pzViyKDSM3DwLy6D 1349909620
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 018/133] powerpc/eeh: Fix crash on converting OF node to edev
Date: Thu, 11 Oct 2012 07:50:44 +0900
Message-Id: <20121010224857.729632794@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit 1e38b7140185e384da216aff66a711df09b5afc9 upstream.

The kernel crash was reported by Alexy. He was testing some feature
with private kernel, in which Alexy added some code in pci_pm_reset()
to read the CSR after writting it. The bug could be reproduced on
Fiber Channel card (Fibre Channel: Emulex Corporation Saturn-X:
LightPulse Fibre Channel Host Adapter (rev 03)) by the following
commands.

	# echo 1 > /sys/devices/pci0004:01/0004:01:00.0/reset
	# rmmod lpfc
	# modprobe lpfc

The history behind the test case is that those additional config
space reading operations in pci_pm_reset() would cause EEH error,
but we didn't detect EEH error until "modprobe lpfc". For the case,
all the PCI devices on PCI bus (0004:01) were removed and added after
PE reset. Then the EEH devices would be figured out again based on
the OF nodes. Unfortunately, there were some child OF nodes under
PCI device (0004:01:00.0), but they didn't have attached PCI_DN since
they're invisible from PCI domain. However, we were still trying to
convert OF node to EEH device without checking on the attached PCI_DN.
Eventually, it caused the kernel crash as follows:

Unable to handle kernel paging request for data at address 0x00000030
Faulting instruction address: 0xc00000000004d888
cpu 0x0: Vector: 300 (Data Access) at [c000000fc797b950]
    pc: c00000000004d888: .eeh_add_device_tree_early+0x78/0x140
    lr: c00000000004d880: .eeh_add_device_tree_early+0x70/0x140
    sp: c000000fc797bbd0
   msr: 8000000000009032
   dar: 30
 dsisr: 40000000
  current = 0xc000000fc78d9f70
  paca    = 0xc00000000edb0000   softe: 0        irq_happened: 0x00
    pid   = 2951, comm = eehd
enter ? for help
[c000000fc797bc50] c00000000004d848 .eeh_add_device_tree_early+0x38/0x140
[c000000fc797bcd0] c00000000004d848 .eeh_add_device_tree_early+0x38/0x140
[c000000fc797bd50] c000000000051b54 .pcibios_add_pci_devices+0x34/0x190
[c000000fc797bde0] c00000000004fb10 .eeh_reset_device+0x100/0x160
[c000000fc797be70] c0000000000502dc .eeh_handle_event+0x19c/0x300
[c000000fc797bf00] c000000000050570 .eeh_event_handler+0x130/0x1a0
[c000000fc797bf90] c000000000020138 .kernel_thread+0x54/0x70

The patch changes of_node_to_eeh_dev() and just returns NULL if the
passed OF node doesn't have attached PCI_DN.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/pci-bridge.h |    8 ++++++++
 arch/powerpc/platforms/pseries/eeh.c  |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -181,6 +181,14 @@ static inline int pci_device_from_OF_nod
 #if defined(CONFIG_EEH)
 static inline struct eeh_dev *of_node_to_eeh_dev(struct device_node *dn)
 {
+	/*
+	 * For those OF nodes whose parent isn't PCI bridge, they
+	 * don't have PCI_DN actually. So we have to skip them for
+	 * any EEH operations.
+	 */
+	if (!dn || !PCI_DN(dn))
+		return NULL;
+
 	return PCI_DN(dn)->edev;
 }
 #endif
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -1029,7 +1029,7 @@ static void eeh_add_device_early(struct
 {
 	struct pci_controller *phb;
 
-	if (!dn || !of_node_to_eeh_dev(dn))
+	if (!of_node_to_eeh_dev(dn))
 		return;
 	phb = of_node_to_eeh_dev(dn)->phb;
 



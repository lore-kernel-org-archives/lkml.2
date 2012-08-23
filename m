Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751063Ab2HWQhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:37:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab2HWQhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:37:23 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, linux-efi@vger.kernel.org, mfleming@intel.com,
        dwmw2@infradead.org, bhelgaas@google.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V3 4/4] X86: Use PCI setup data
Date: Thu, 23 Aug 2012 12:36:43 -0400
Message-Id: <1345739803-21017-5-git-send-email-mjg@redhat.com>
In-Reply-To: <1345739803-21017-1-git-send-email-mjg@redhat.com>
References: <1345739803-21017-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI can provide PCI ROMs out of band via boot services, which may not be
available after boot. Add support for using the data handed off to us by
the boot stub or bootloader.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 arch/x86/pci/common.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 720e973f..3d2752f 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -17,6 +17,7 @@
 #include <asm/io.h>
 #include <asm/smp.h>
 #include <asm/pci_x86.h>
+#include <asm/setup.h>
 
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
@@ -608,6 +609,38 @@ unsigned int pcibios_assign_all_busses(void)
 	return (pci_probe & PCI_ASSIGN_ALL_BUSSES) ? 1 : 0;
 }
 
+int pcibios_add_device(struct pci_dev *dev)
+{
+	struct setup_data *data;
+	struct pci_setup_rom *rom;
+	u64 pa_data;
+
+	if (boot_params.hdr.version < 0x0209)
+		return 0;
+
+	pa_data = boot_params.hdr.setup_data;
+	while (pa_data) {
+		data = phys_to_virt(pa_data);
+
+		if (data->type == SETUP_PCI) {
+			rom = (struct pci_setup_rom *)data;
+
+			if ((pci_domain_nr(dev->bus) == rom->segment) &&
+			    (dev->bus->number == rom->bus) &&
+			    (PCI_SLOT(dev->devfn) == rom->device) &&
+			    (PCI_FUNC(dev->devfn) == rom->function) &&
+			    (dev->vendor == rom->vendor) &&
+			    (dev->device == rom->devid)) {
+				dev->rom = (void *)(pa_data +
+				      offsetof(struct pci_setup_rom, romdata));
+				dev->romlen = rom->pcilen;
+			}
+		}
+		pa_data = data->next;
+	}
+	return 0;
+}
+
 int pcibios_enable_device(struct pci_dev *dev, int mask)
 {
 	int err;
-- 
1.7.11.2


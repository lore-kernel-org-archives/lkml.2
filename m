Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1JMJEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 05:04:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:1217 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295Ab1JMJEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 05:04:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,339,1315206000"; 
   d="scan'208";a="73125782"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, alan@linux.intel.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@zytor.com, torvalds@linux-foundation.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>, stable@kernel.org
Subject: [PATCH RESEND] x86, mrst: use a temporary variable for SFI irq
Date: Thu, 13 Oct 2011 12:04:20 +0300
Message-Id: <1318496660-23722-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SFI tables reside in RAM and should not be modified once they are written.
Current code went to set pentry->irq to zero which causes subsequent reads
to fail with invalid SFI table checksum. This will break kexec as the
second kernel fails to validate SFI tables.

To fix this we use temporary variable for irq number.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@kernel.org
---
 arch/x86/platform/mrst/mrst.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 58425ad..fe73276 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -678,38 +678,40 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 	pentry = (struct sfi_device_table_entry *)sb->pentry;
 
 	for (i = 0; i < num; i++, pentry++) {
-		if (pentry->irq != (u8)0xff) { /* native RTE case */
+		int irq = pentry->irq;
+
+		if (irq != (u8)0xff) { /* native RTE case */
 			/* these SPI2 devices are not exposed to system as PCI
 			 * devices, but they have separate RTE entry in IOAPIC
 			 * so we have to enable them one by one here
 			 */
-			ioapic = mp_find_ioapic(pentry->irq);
+			ioapic = mp_find_ioapic(irq);
 			irq_attr.ioapic = ioapic;
-			irq_attr.ioapic_pin = pentry->irq;
+			irq_attr.ioapic_pin = irq;
 			irq_attr.trigger = 1;
 			irq_attr.polarity = 1;
-			io_apic_set_pci_routing(NULL, pentry->irq, &irq_attr);
+			io_apic_set_pci_routing(NULL, irq, &irq_attr);
 		} else
-			pentry->irq = 0; /* No irq */
+			irq = 0; /* No irq */
 
 		switch (pentry->type) {
 		case SFI_DEV_TYPE_IPC:
 			/* ID as IRQ is a hack that will go away */
-			pdev = platform_device_alloc(pentry->name, pentry->irq);
+			pdev = platform_device_alloc(pentry->name, irq);
 			if (pdev == NULL) {
 				pr_err("out of memory for SFI platform device '%s'.\n",
 							pentry->name);
 				continue;
 			}
-			install_irq_resource(pdev, pentry->irq);
+			install_irq_resource(pdev, irq);
 			pr_debug("info[%2d]: IPC bus, name = %16.16s, "
-				"irq = 0x%2x\n", i, pentry->name, pentry->irq);
+				"irq = 0x%2x\n", i, pentry->name, irq);
 			sfi_handle_ipc_dev(pdev);
 			break;
 		case SFI_DEV_TYPE_SPI:
 			memset(&spi_info, 0, sizeof(spi_info));
 			strncpy(spi_info.modalias, pentry->name, SFI_NAME_LEN);
-			spi_info.irq = pentry->irq;
+			spi_info.irq = irq;
 			spi_info.bus_num = pentry->host_num;
 			spi_info.chip_select = pentry->addr;
 			spi_info.max_speed_hz = pentry->max_freq;
@@ -726,7 +728,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 			memset(&i2c_info, 0, sizeof(i2c_info));
 			bus = pentry->host_num;
 			strncpy(i2c_info.type, pentry->name, SFI_NAME_LEN);
-			i2c_info.irq = pentry->irq;
+			i2c_info.irq = irq;
 			i2c_info.addr = pentry->addr;
 			pr_debug("info[%2d]: I2C bus = %d, name = %16.16s, "
 				"irq = 0x%2x, addr = 0x%x\n", i, bus,
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0FUSij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 14:38:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:47889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab0FUSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 14:38:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,454,1272870000"; 
   d="scan'208";a="810022884"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Alan Cox <alan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Moblin Kernel <moblin-kernel@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst/pci: avoid enabling intx for msi capable devices
Date: Mon, 21 Jun 2010 11:30:55 -0700
Message-Id: <1277145055-20566-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Moorestown platform, true PCI devices with MSI capabilities do not support
INTx mode. IRQ line# for those devices are zeros in the PCI shim, an attempt
to enable INTx on these MSI capable devices will cause conflict in the system
such as IRQ0 for the system timers.
If the device driver probes/enables MSI before pci_enable_device(), the conflict
is not shown since INTx will be disabled. But if the driver tries to enable INTx
before MSI, the conflict will cause system timer IRQ0 to break.

This patch will ensure the ordering of INTx and MSI setup by the driver is
not relavent to INTx conflict. We will always skip INTx setup for MSI capable
devices on Moorestown.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/pci/mrst.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index d5c7aef..ba3f08b 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -203,6 +203,9 @@ static int mrst_pci_irq_enable(struct pci_dev *dev)
 	u8 pin;
 	struct io_apic_irq_attr irq_attr;
 
+	if (pci_find_capability(dev, PCI_CAP_ID_MSI))
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 
 	/* MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
-- 
1.6.3.3


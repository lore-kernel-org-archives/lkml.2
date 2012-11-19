Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2KSPB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:01:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab2KSPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:01:24 -0500
Date: Mon, 19 Nov 2012 16:00:51 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 -tip 0/3] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <cover.1353324359.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I am resending this series with changes based on Ingo's review of v3.

Patch #3 has a single change in functionality compared to the previous
version you acked before - that is a fix of invalid index spotted by Ingo
(below is the interdiff's hunk). Could you please review the patch again
and ack or comment?

@@ -1129,8 +1131,8 @@
 out_free_all_irqs:
 	i = host->n_ports;
 out_free_irqs:
-	for (; i; i--)
-		devm_free_irq(host->dev, irq + i - 1, host->ports[i]);
+	for (i--; i >= 0; i--)
+		devm_free_irq(host->dev, irq + i, host->ports[i]);
 
 	return rc;
 }

Whole series compared to v3:

	I have not noticed that v3 2/5 patch "x86, MSI: Allocate as many
	multiple IRQs as requested" is redundant, since the AHCI code
	tries to allocate maximum possible number of MSIs. As there are
	no other users of this functionality, I removed v3 2/5 patch for now;

	v3 patch 3/5 "x86, MSI: Minor readability fixes" merged into
  	v4 patch 1/3 "x86, MSI: Support multiple MSIs in presense of IRQ
	remapping";

	1/3:	- racy can_create_irqs() check removed;
		- multi-line comments fixed;
		- loops 'for (; i; i--)' changed to 'for (i--; i >= 0; i--)';

		v1 conditionally acked by Suresh
		v2 concerned Yinghai's comments

	2/3:	v2 acked by Bjorn, no changes since

	3/3:	- ahci_host_activate() failure path fixed and tested;
		- ahci_port_priv::lock field commented;
		- multi-line comments fixed;

		v3 acked by Jeff

Alexander Gordeev (3):
  x86, MSI: Support multiple MSIs in presense of IRQ remapping
  PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
  AHCI: Support multiple MSIs

 Documentation/PCI/MSI-HOWTO.txt |   37 ++++++++-
 arch/x86/kernel/apic/io_apic.c  |  165 +++++++++++++++++++++++++++++++--------
 drivers/ata/ahci.c              |   93 +++++++++++++++++++++-
 drivers/ata/ahci.h              |    6 ++
 drivers/ata/libahci.c           |  118 ++++++++++++++++++++++++++--
 drivers/pci/msi.c               |   26 ++++++
 include/linux/irq.h             |    5 +
 include/linux/pci.h             |    7 ++
 kernel/irq/chip.c               |   30 +++++--
 9 files changed, 432 insertions(+), 55 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab2JAII1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2JAIIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:08:24 -0400
Date: Mon, 1 Oct 2012 10:08:09 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        Matthew Wilcox <willy@linux.intel.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH v3 -tip 0/5] x86, MSI, AHCI: Support multiple MSIs
Message-ID: <cover.1349074231.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently multiple MSI mode is limited to a single vector per device (at
least on x86 and PPC). This series breathes life into pci_enable_msi_block()
and makes it possible to set interrupt affinity for multiple IRQs, similarly
to MSI-X. Yet, only for x86 and only when IOMMUs are present.

Although IRQ and PCI subsystems are modified, the current behaviour left
intact. The drivers could just start using multiple MSIs just by following
the existing documentation.

The AHCI device driver makes use of the new mode and a new function -
pci_enable_msi_block_auto() - patches 4,5.

The series is adapted to Ingo's -tip repository.


Compared to v2:

	1/5:	v1 is conditionally acked by Suresh

		Based on Yinghai's comment:
		- create_irqs() is updated to be __create_irqs(, count, );
		- create_irq_nr() done as __create_irqs(, 1, ) call;

	2,3/5:	No changes since v1, conditionally acked by Suresh

	4/5:	No changes, v2 acked by Bjorn

	5/5:	"Shared Last Message" mode leftovers removed;

		Based on Jeff's comments:

		- PCI-specific code moved from libahci.c to ahci.c -
		  ahci_host_activate() lost scsi_host_template* parameter
		  as result;

		- spinlock initialization moved to ahci_port_start() -
		  AHCI_HFLAG_MULTI_MSI flag introduced for that;


Alexander Gordeev (5):
  1/5 x86, MSI: Support multiple MSIs in presense of IRQ remapping
  2/5 x86, MSI: Allocate as many multiple IRQs as requested
  3/5 x86, MSI: Minor readability fixes
  4/5 PCI, MSI: Enable multiple MSIs with pci_enable_msi_block_auto()
  5/5 AHCI: Support multiple MSIs

 Documentation/PCI/MSI-HOWTO.txt |   37 +++++++-
 arch/x86/kernel/apic/io_apic.c  |  178 ++++++++++++++++++++++++++++++++-------
 drivers/ata/ahci.c              |   91 +++++++++++++++++++-
 drivers/ata/ahci.h              |    6 ++
 drivers/ata/libahci.c           |  118 ++++++++++++++++++++++++--
 drivers/pci/msi.c               |   36 ++++++++-
 include/linux/irq.h             |    6 ++
 include/linux/msi.h             |    1 +
 include/linux/pci.h             |    7 ++
 kernel/irq/chip.c               |   30 +++++--
 kernel/irq/irqdesc.c            |   31 +++++++
 11 files changed, 486 insertions(+), 55 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com

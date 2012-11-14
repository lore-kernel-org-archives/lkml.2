Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027Ab2KNJs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 04:48:56 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:38061 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab2KNJsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 04:48:52 -0500
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, Jan Glauber <jang@linux.vnet.ibm.com>
Subject: [RFC PATCH 00/10] s390/pci: PCI support on System z
Date: Wed, 14 Nov 2012 10:41:32 +0100
Message-Id: <cover.1352719877.git.jang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.12.4
x-cbid: 12111409-1948-0000-0000-000003822B1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patchset based on 3.7-rc4 aims at adding PCI(e) support to the
System z (s390) architecture. PCI is currently not available on s390,
so this is early prototype code.

I'm posting in the hope to get some feedback and direction on the more humble
aspects of it.

Patches 01-05 are only split to ease the review, they belong functional
together and don't make much sense without each other.

PCI on the mainframe differs in some aspects from PCI on other platforms. 

The most notable difference is the use of instructions for memory
mapped IO. So on s390 the BAR spaces cannot be mapped to memory. To access 
the BAR spaces privileged instructions must be used (how that will be
addressed for user-space is not part of this patchset). See patch 01 for how
the read/write pci primitives are mapped to the s390 instructions.

Another difference is that the addresses of BARs from two different PCI
functions may be identical. That means we can't distinguish from an iomem
address which PCI device the address belongs to. Therefore s390 needs a
custom implementation of pci_iomap to remap iomem addresses using the bar
and device information provided by pci_iomap.

Device naming - the topology on System z is that every PCI function is attached
directly to a PCI root complex. Therefore we decided to use a domain number per
function and leave the bus, slot and function 0.

Next one - IRQs. s390 will use its existing adapter interrupt infrastructure
to deliver MSI/MSI-X interrupts. Legacy INTs are _not_ supported at all. 
The only thing that s390 needs is to close the gap between adapter interrupts
and MSI, in other words to locate a struct msi_desc from an IRQ number.
For that I've implemented a simple hash, see patch 04.

Then there is Kconfig, see patch 09, which gives s390 a bunch of options that
we would rather avoid. Like VGA support, sound subsystem, etc. I do not have a
solution how to disable these subsystems. We would like to limit the subsystems
that become available on s390 because the usable PCI hardware will be limited
to a small number of hand-picked and supported PCI cards.

There are several options I can imagine:

a) Don't disable anything - that would result in lots of drivers builtable on
   s390 that are not supported and weird error reports

b) Introduce negative options for whole subsystems like we have already with
   NO_IOPORT, so maybe NO_USB, NO_SOUND, ...

c) Introduce a special CONFIG_PCI_S390 and add that explicitely to all
   subsystems that we want to enable on s390

None of the above looks like the obvious winner to me.


Hope to get some feedback,
TIA, Jan

Jan Glauber (10):
  s390/pci: base support
  s390/pci: CLP interface
  s390/bitops: find leftmost bit instruction support
  s390/pci: PCI adapter interrupts for MSI/MSI-X
  s390/pci: DMA support
  s390/pci: CHSC PCI support for error and availability events
  s390/pci: PCI hotplug support via SCLP
  s390/pci: s390 specific PCI sysfs attributes
  s390/pci: add PCI Kconfig options
  vga: compile fix, disable vga for s390

 arch/s390/Kbuild                    |    1 +
 arch/s390/Kconfig                   |   56 +-
 arch/s390/include/asm/bitops.h      |   81 +++
 arch/s390/include/asm/clp.h         |   28 +
 arch/s390/include/asm/dma-mapping.h |   76 +++
 arch/s390/include/asm/dma.h         |   19 +-
 arch/s390/include/asm/hw_irq.h      |   22 +
 arch/s390/include/asm/io.h          |   55 +-
 arch/s390/include/asm/irq.h         |   12 +
 arch/s390/include/asm/isc.h         |    1 +
 arch/s390/include/asm/pci.h         |  156 ++++-
 arch/s390/include/asm/pci_clp.h     |  182 ++++++
 arch/s390/include/asm/pci_dma.h     |  196 +++++++
 arch/s390/include/asm/pci_insn.h    |  280 +++++++++
 arch/s390/include/asm/pci_io.h      |  194 +++++++
 arch/s390/include/asm/sclp.h        |    2 +
 arch/s390/kernel/dis.c              |   15 +
 arch/s390/kernel/irq.c              |    2 +
 arch/s390/pci/Makefile              |    6 +
 arch/s390/pci/pci.c                 | 1098 +++++++++++++++++++++++++++++++++++
 arch/s390/pci/pci_clp.c             |  324 +++++++++++
 arch/s390/pci/pci_dma.c             |  505 ++++++++++++++++
 arch/s390/pci/pci_event.c           |   93 +++
 arch/s390/pci/pci_msi.c             |  141 +++++
 arch/s390/pci/pci_sysfs.c           |   86 +++
 drivers/gpu/vga/Kconfig             |    2 +-
 drivers/pci/hotplug/Kconfig         |   11 +
 drivers/pci/hotplug/Makefile        |    1 +
 drivers/pci/hotplug/s390_pci_hpc.c  |  252 ++++++++
 drivers/pci/msi.c                   |   10 +-
 drivers/s390/char/sclp.h            |    3 +-
 drivers/s390/char/sclp_cmd.c        |   64 +-
 drivers/s390/cio/chsc.c             |  156 +++--
 include/asm-generic/io.h            |   21 +-
 include/linux/irq.h                 |   10 +-
 include/video/vga.h                 |    2 +
 36 files changed, 4084 insertions(+), 79 deletions(-)
 create mode 100644 arch/s390/include/asm/clp.h
 create mode 100644 arch/s390/include/asm/dma-mapping.h
 create mode 100644 arch/s390/include/asm/hw_irq.h
 create mode 100644 arch/s390/include/asm/pci_clp.h
 create mode 100644 arch/s390/include/asm/pci_dma.h
 create mode 100644 arch/s390/include/asm/pci_insn.h
 create mode 100644 arch/s390/include/asm/pci_io.h
 create mode 100644 arch/s390/pci/Makefile
 create mode 100644 arch/s390/pci/pci.c
 create mode 100644 arch/s390/pci/pci_clp.c
 create mode 100644 arch/s390/pci/pci_dma.c
 create mode 100644 arch/s390/pci/pci_event.c
 create mode 100644 arch/s390/pci/pci_msi.c
 create mode 100644 arch/s390/pci/pci_sysfs.c
 create mode 100644 drivers/pci/hotplug/s390_pci_hpc.c

-- 
1.7.12.4


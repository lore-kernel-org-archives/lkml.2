Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab0JLPrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:47:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29166 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab0JLPrS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:47:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v8] Xen PCI + Xen PCI frontend driver.
Date: Tue, 12 Oct 2010 11:44:08 -0400
Message-Id: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains the supporting patches and the driver itself for
Xen Paravirtualized (PV) domains to use PCI pass-through devices (the git tree
is git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pcifront-0.8).
This patch-set is also utilized in Stefano's PV on HVM MSI/MSI-X patchset [1].

Changelog since v7 [http://lwn.net/Articles/408418/] posting:
 - Added Reviewed-by/Acked-by on some of the patches.
 - Fleshed out comments.
 - Ditched the io_apic.c idea and used Thomas Gleixner idea.

The Xen PCI frontend driver can be used by PV guests on IOMMU hardware
(or IOMMU-less). Without the hardware IOMMU you have a potential security
hole wherein a guest domain can use the hardware to map pages outside its
memory range and slurp pages up. As such, this is more restricted to a
Privileged PV domain, aka - device driver domain (similar to Qubes but a
poor-man mechanism [2]).

The first set of patches are specific to the Xen subsystem, where
we introduce an IRQ chip for Physical IRQs, along with the supporting
harness code:
 xen: Don't disable the I/O space
 xen: define BIOVEC_PHYS_MERGEABLE()
 xen: implement pirq type event channels
 xen: identity map gsi->irqs
 xen: dynamically allocate irq & event structures
 xen: set pirq name to something useful.
 xen: statically initialize cpu_evtchn_mask_p
 xen: Find an unbound irq number in reverse order (high to low).
 xen: Provide a variant of xen_poll_irq with timeout.
 xen: fix shared irq device passthrough

The next set of patches expose functionality for module drivers to be able to
enumerate and iomap (using the _PAGE_IOMAP flag) PCI devices.

 x86/io_apic: add get_nr_irqs_gsi()
 x86/PCI: Clean up pci_cache_line_size
 x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
 x86/PCI: Export pci_walk_bus function.

The next two patches abstract the MSI/MSI-X architecture calls so that the
default native one (used on bare-metal) can be overwritten when running
in virtualized mode (right now on Xen). The implementation is a simple
function pointer structure.

 msi: Introduce default_[teardown|setup]_msi_irqs with fallback.
 x86: Introduce x86_msi_ops

Next, the Xen PCI stub driver. I've put it in the same location
where other sub-platform PCI drivers are. It hooks up to the
PCI legacy IRQ setup ('pcibios_enable_irq'), and MSI/MSI-X
allocation/de-allocation (via the x86_msi_ops introduced in earlier patches).

 xen/x86/PCI: Add support for the Xen PCI subsystem

Lastly, the Xen PCI front-end driver which is responsible for hooking up
to the PCI configuration read/write methods via the 'pci_scan_bus_parented' call.
In essence all pci_conf_read/write in the guest will be tunneled via
pcifront_bus_[read|write] methods. The MSI/MSI-X calls will be handled
by the Xen-PCI front-end driver as well. We also need to add a new
state so updating the XenBus:

 xenbus: Xen paravirtualised PCI hotplug support.
 xenbus: prevent warnings on unhandled enumeration values
 xen-pcifront: Xen PCI frontend driver.

The last three are two bug fixes and updating the MAINTAINERs file
with my name:

 xen/pci: Request ACS when Xen-SWIOTLB is activated.
 MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
 swiotlb-xen: On x86-32 builts, select SWIOTLB instead of depending on it.

The shortlog and the diffstat:

Alex Nixon (3):
      xen: Don't disable the I/O space
      x86/PCI: Clean up pci_cache_line_size
      xen/x86/PCI: Add support for the Xen PCI subsystem

Gerd Hoffmann (1):
      xen: set pirq name to something useful.

Jeremy Fitzhardinge (7):
      xen: define BIOVEC_PHYS_MERGEABLE()
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen: identity map gsi->irqs
      xen: dynamically allocate irq & event structures
      xen: statically initialize cpu_evtchn_mask_p
      x86/PCI: make sure _PAGE_IOMAP it set on pci mappings

Konrad Rzeszutek Wilk (7):
      xen: Find an unbound irq number in reverse order (high to low).
      xen: Provide a variant of xen_poll_irq with timeout.
      xen: fix shared irq device passthrough
      x86/PCI: Export pci_walk_bus function.
      xen/pci: Request ACS when Xen-SWIOTLB is activated.
      MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
      swiotlb-xen: On x86-32 builts, select SWIOTLB instead of depending on it.

Noboru Iwamatsu (1):
      xenbus: prevent warnings on unhandled enumeration values

Ryan Wilson (1):
      xen-pcifront: Xen PCI frontend driver.

Stefano Stabellini (1):
      x86: Introduce x86_msi_ops

Thomas Gleixner (1):
      msi: Introduce default_[teardown|setup]_msi_irqs with fallback.

Yosuke Iwamatsu (1):
      xenbus: Xen paravirtualised PCI hotplug support.


 MAINTAINERS                        |   14 +
 arch/x86/Kconfig                   |    5 +
 arch/x86/include/asm/io.h          |   13 +
 arch/x86/include/asm/io_apic.h     |    1 +
 arch/x86/include/asm/pci.h         |   33 +-
 arch/x86/include/asm/pci_x86.h     |    1 +
 arch/x86/include/asm/x86_init.h    |    9 +
 arch/x86/include/asm/xen/pci.h     |   53 ++
 arch/x86/kernel/apic/io_apic.c     |    9 +-
 arch/x86/kernel/x86_init.c         |    7 +
 arch/x86/pci/Makefile              |    1 +
 arch/x86/pci/common.c              |   17 +-
 arch/x86/pci/i386.c                |    2 +
 arch/x86/pci/xen.c                 |  147 +++++
 arch/x86/xen/enlighten.c           |    3 +
 arch/x86/xen/pci-swiotlb-xen.c     |    4 +
 arch/x86/xen/setup.c               |    2 -
 drivers/block/xen-blkfront.c       |    2 +
 drivers/input/xen-kbdfront.c       |    2 +
 drivers/net/xen-netfront.c         |    2 +
 drivers/pci/Kconfig                |   15 +
 drivers/pci/Makefile               |    2 +
 drivers/pci/bus.c                  |    1 +
 drivers/pci/msi.c                  |   14 +-
 drivers/pci/xen-pcifront.c         | 1157 ++++++++++++++++++++++++++++++++++++
 drivers/video/xen-fbfront.c        |    2 +
 drivers/xen/Kconfig                |    3 +-
 drivers/xen/Makefile               |    2 +-
 drivers/xen/biomerge.c             |   13 +
 drivers/xen/events.c               |  345 ++++++++++-
 drivers/xen/xenbus/xenbus_client.c |    2 +
 include/xen/events.h               |   18 +
 include/xen/interface/io/pciif.h   |  112 ++++
 include/xen/interface/io/xenbus.h  |    8 +-
 34 files changed, 1987 insertions(+), 34 deletions(-)

P.S.
[1]. git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc1-pvhvm-pirq-v3

[2]: http://qubes-os.org/ which utilizes hardware IOMMU to run seperate domains wherein
each has specific access to hardware.

[3] Some of the authors of the patches have moved on, so their e-mails
are bouncing. I am purposly making the 'From' a valid email so that the patches
do show up on LKML. The git tree contains their proper old email addresses.


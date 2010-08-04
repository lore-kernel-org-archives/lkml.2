Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab0HDS0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:26:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab0HDS0N (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:26:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com
Subject: [RFC PATCH] Xen PCI frontend driver (v0.5)
Date: Wed,  4 Aug 2010 14:18:55 -0400
Message-Id: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C59B0B6.018D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains the groundwork and the driver itself for
Xen Paravirtualized (PV) domains to use PCI pass-through devices.

These patches utilize the Xen-SWIOTLB library
(http://lkml.org/lkml/2010/7/27/246) and I don't expect them to
get in the 2.6.36 merge window.

Some of these groundwork patches had been posted in the past, and
gotten some review (and some Acks). Since then work has been done to
expand them, fix bugs, squish them, etc, so that they are feature complete.
I was not sure if I should carry the Ack/Reviewed-by flags, so I've just
reset them to Cc.

Also some of the authors of these patches have moved on, and their e-mails
are bouncing. Any thoughts of what to do about that? I've squished some of
my patches in their work as I want to have the least amount of patches, and
I am de facto the maintainer at this point.

First of Xen PCI frontend driver can be used by PV guests on hardware
that with or without hardware IOMMU. Without an hardware IOMMU you have a
potential security hole wherein a guest domain can use the hardware to map
pages outside its memory range and slurp pages up. As such, this is more
restricted to a Privileged PV domain, aka - device driver domain
(similar to Qubes but a poor-man mechanism [1]).

I am not sure how many folks are actually interested in the internal workings
of the Xen PCI frontend, so I've skipped on that and concentrated on the
other patches (X86 related) which would be more interesting to folks I think.

The first four expose functionality for module drivers to be able to
enumerate and also have the appropriate flag set on PCI devices (_PAGE_IOMAP):

 [PATCH 04/20] x86/io_apic: add get_nr_irqs_gsi()
 [PATCH 12/20] x86/PCI: Clean up pci_cache_line_size
 [PATCH 13/20] x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
 [PATCH 14/20] x86/PCI: Export pci_walk_bus function.

The MSI/MSI-X ones are a mechanism for the MSI/MSI-X framework 'arch_*'
to call into a function pointer structure and call from there the
appropriate sub-platform MSI implementation. On bare-metal this 
is still the old code, except that first part of the name has changed
from 'arch' to 'native':

 [PATCH 15/20] x86: Copy-n-paste arch_teardown_msi_irqs from msi.c to io_apic.c.
 [PATCH 16/20] x86: Introduce x86_msi_ops

And lastly, the Xen PCI stub driver. I've put it in the same location
where other sub-platform PCI drivers are (say, OLPC). It hooks up to the
PCI legacy IRQ setup ('pcibios_enable_irq'), and MSI/MSI-X
allocation/de-allocation (via the x86_msi_ops).

 [PATCH 17/20] xen/x86/PCI: Add support for the Xen PCI subsystem

The Xen PCI driver by itself is responsible for hooking up to the PCI
configuration read/write methods via the 'pci_scan_bus_parented' call.
In essence all pci_conf_read/write would be tunneled via
pcifront_bus_[read|write] methods:

 [PATCH 20/20] xen-pcifront: Xen PCI frontend driver.

The rest of the patches are related to the Xen framework and
tweaking it to properly work. Those patches have/are in Jeremy's
tree too since 2.6.31, but it made more sense to have them
logically separated in this patch-set since they are utilized by this
driver.

And here is the full list of patches and the diffstat:
Alex Nixon (3):
      xen: Don't disable the I/O space
      x86/PCI: Clean up pci_cache_line_size
      xen/x86/PCI: Add support for the Xen PCI subsystem

Gerd Hoffmann (2):
      xen: implement pirq type event channels
      xen: set pirq name to something useful.

Jeremy Fitzhardinge (5):
      xen: define BIOVEC_PHYS_MERGEABLE()
      x86/io_apic: add get_nr_irqs_gsi()
      xen: identity map gsi->irqs
      xen: statically initialize cpu_evtchn_mask_p
      x86/PCI: make sure _PAGE_IOMAP it set on pci mappings

Konrad Rzeszutek Wilk (5):
      xen: dynamically allocate irq & event structures
      xen: Find an unbound irq number in reverse order (high to low).
      xen: Provide a variant of xen_poll_irq with timeout.
      x86/PCI: Export pci_walk_bus function.
      x86: Copy-n-paste arch_teardown_msi_irqs from msi.c to io_apic.c.

Noboru Iwamatsu (1):
      xenbus: prevent warnings on unhandled enumeration values

Ryan Wilson (1):
      xen-pcifront: Xen PCI frontend driver.

Stefano Stabellini (1):
      x86: Introduce x86_msi_ops

Weidong Han (1):
      xen: fix shared irq device passthrough

Yosuke Iwamatsu (1):
      xenbus: Xen paravirtualised PCI hotplug support.

 arch/x86/Kconfig                   |    5 +
 arch/x86/include/asm/io.h          |   13 +
 arch/x86/include/asm/io_apic.h     |    1 +
 arch/x86/include/asm/pci.h         |   25 +-
 arch/x86/include/asm/pci_x86.h     |    1 +
 arch/x86/include/asm/x86_init.h    |    9 +
 arch/x86/include/asm/xen/pci.h     |   53 ++
 arch/x86/kernel/apic/io_apic.c     |   23 +-
 arch/x86/kernel/x86_init.c         |    6 +
 arch/x86/pci/Makefile              |    1 +
 arch/x86/pci/common.c              |   17 +-
 arch/x86/pci/i386.c                |    2 +
 arch/x86/pci/xen.c                 |  147 +++++
 arch/x86/xen/enlighten.c           |    3 +
 arch/x86/xen/setup.c               |    2 -
 drivers/block/xen-blkfront.c       |    2 +
 drivers/input/xen-kbdfront.c       |    2 +
 drivers/net/xen-netfront.c         |    2 +
 drivers/pci/Kconfig                |   16 +
 drivers/pci/Makefile               |    2 +
 drivers/pci/bus.c                  |    1 +
 drivers/pci/xen-pcifront.c         | 1157 ++++++++++++++++++++++++++++++++++++
 drivers/video/xen-fbfront.c        |    2 +
 drivers/xen/Makefile               |    2 +-
 drivers/xen/biomerge.c             |   13 +
 drivers/xen/events.c               |  338 ++++++++++-
 drivers/xen/xenbus/xenbus_client.c |    2 +
 include/xen/events.h               |   18 +
 include/xen/interface/io/pciif.h   |  122 ++++
 include/xen/interface/io/xenbus.h  |    8 +-
 30 files changed, 1964 insertions(+), 31 deletions(-)


P.S.
[1]. In case you prefer to look at git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pcifront-0.5

To get it working, you would need to checkout first:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git devel/linux-next
and then merge the above mentioned branch in it.

[2]: http://qubes-os.org/ which utilizes hardware IOMMU to run seperate domains wherein
each has specific access to hardware.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280Ab1JNE1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 00:27:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:49632 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1JNE1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 00:27:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=D+EcH161cGYj+gkdaFrmjKxADZfijgZ0oGW+9FnEBmU4bSZJiAqAO/o4493yJ2Mb7
	fE4SmKvJohdwqF6JJyp/w==
Subject: [PATCH v2 00/29] Create PCI root buses with correct resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Oct 2011 22:27:06 -0600
Message-ID: <20111014042142.23504.70417.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The most generic way to create a PCI root bus is with pci_scan_bus(), but
that doesn't allow you to specify what resources are available on the bus,
i.e., what the host bridge apertures are.

That means that pci_create_bus() has to fill in some incorrect defaults
(ioport_resource and iomem_resource), and the architecture has to fix
them later in pcibios_fixup_bus().  Between creation and fixup, we
run quirks, and they see the wrong bus resources:

  pci_scan_bus or pci_scan_bus_parented
    pci_create_bus                     <-- A create with default resources
    pci_scan_child_bus
      pci_scan_slot
        pci_scan_single_device
          pci_scan_device
            pci_setup_device
              pci_fixup_device(early)  <-- B
          pci_device_add
            pci_fixup_device(header)   <-- C
      pcibios_fixup_bus                <-- D fill in correct resources

Early and header quirks at B and C use the default (incorrect) root
bus resources rather than those filled in at D.  If they request any
regions, they get the wrong parent.  quirk_piix4_acpi() tripped over
this on MIPS and caused a driver to fail with unexpected conflicts
(http://www.spinics.net/lists/mips/msg41654.html).

A few architectures avoid this problem by using pci_create_bus()
directly and fixing the root bus resources before scanning the bus.
But that's ugly and is normally done because the arch needs a different
bus scanner, such as pci_of_scan_bus().

This series fixes the problem by adding new interfaces that take a list
of bus resources:

    pci_scan_root_bus()
    pci_create_root_bus()

To reduce backporting issues and remove cross-arch dependencies, I retained the
following interfaces unchanged, but marked them "deprecated."  

    pci_scan_bus()
    pci_scan_bus_parented() (replace with pci_scan_root_bus/pci_scan_child_bus)
    pci_create_bus()

I'm open to suggestions for improving pci_scan_root_bus().  For instance,
I wonder whether it should take a domain argument, so we could move some
of the PCI domain support into the core.

Changes since V1:
    - left existing interfaces unchanged, but deprecated
    - added pci_create_root_bus() and pci_scan_root_bus()
    - fixed many more architectures

---

Bjorn Helgaas (29):
      PCI: add helpers for building PCI bus resource lists
      PCI: add pci_create_root_bus(), deprecate pci_create_bus()
      PCI: add pci_scan_root_bus(), deprecate pci_scan_bus() and pci_scan_bus_parented()
      MIPS: PCI: convert to pci_scan_root_bus() for correct root bus resources
      x86/PCI: use pci_scan_bus() instead of pci_scan_bus_parented()
      x86/PCI: convert to pci_create_root_bus() and pci_scan_root_bus()
      powerpc/PCI: make pcibios_setup_phb_resources() static
      powerpc/PCI: split PHB part out of pcibios_map_io_space()
      powerpc/PCI: convert to pci_create_root_bus() for correct root bus resources
      microblaze/PCI: fix pci_bus_for_each_resource() usage
      microblaze/PCI: make pcibios_setup_phb_resources() static
      microblaze/PCI: convert to pci_create_root_bus() for correct root bus resources
      microblaze/PCI: use pci_scan_root_bus()
      sparc/PCI: convert to pci_create_root_bus() for correct root bus resources
      sparc32,leon/PCI: convert to pci_scan_root_bus() for correct root bus resources
      ia64/PCI: use pci_create_bus() instead of pci_scan_bus_parented()
      ia64/PCI: convert to pci_create_root_bus() for correct root bus resources
      parisc/PCI: use pci_create_root_bus() instead of pci_scan_bus_parented()
      parisc/PCI: supply root bus resources to pci_create_root_bus()
      parisc/PCI: deal with LMMIO/PAT overlaps before creating PCI root bus
      parisc/PCI: use pci_create_root_bus() instead of pci_scan_bus_parented()
      parisc/PCI: supply root bus resources to pci_create_root_bus()
      xen/PCI: use pci_create_root_bus() instead of pci_scan_bus_parented()
      alpha/PCI: convert to pci_scan_root_bus() for correct root bus resources
      arm/PCI: convert to pci_scan_root_bus() for correct root bus resources
      frv/PCI: convert to pci_scan_root_bus() for correct root bus resources
      mn10300/PCI: convert to pci_scan_root_bus() for correct root bus resources
      sh/PCI: convert to pci_scan_root_bus() for correct root bus resources
      xtensa/PCI: convert to pci_scan_root_bus() for correct root bus resources


 arch/alpha/kernel/pci.c                  |   37 +++++++------
 arch/arm/common/it8152.c                 |    6 +-
 arch/arm/common/via82c505.c              |    3 +
 arch/arm/include/asm/mach/pci.h          |    2 -
 arch/arm/kernel/bios32.c                 |   27 +++-------
 arch/arm/mach-cns3xxx/pcie.c             |    8 +--
 arch/arm/mach-dove/pcie.c                |    9 +--
 arch/arm/mach-footbridge/dc21285.c       |    8 +--
 arch/arm/mach-integrator/pci_v3.c        |   19 ++++---
 arch/arm/mach-iop13xx/pci.c              |   17 +++---
 arch/arm/mach-ixp2000/enp2611.c          |    3 +
 arch/arm/mach-ixp2000/pci.c              |    8 +--
 arch/arm/mach-ixp23xx/pci.c              |    8 +--
 arch/arm/mach-ixp4xx/common-pci.c        |    8 +--
 arch/arm/mach-kirkwood/pcie.c            |    8 +--
 arch/arm/mach-ks8695/pci.c               |    8 +--
 arch/arm/mach-mv78xx0/pcie.c             |    8 +--
 arch/arm/mach-orion5x/pci.c              |   16 +++---
 arch/arm/mach-sa1100/pci-nanoengine.c    |    9 ++-
 arch/arm/mach-tegra/pcie.c               |    9 ++-
 arch/arm/mach-versatile/pci.c            |   19 ++++---
 arch/arm/plat-iop/pci.c                  |    8 +--
 arch/frv/mb93090-mb00/pci-vdk.c          |   26 +++++++--
 arch/ia64/pci/pci.c                      |   40 ++++++--------
 arch/microblaze/include/asm/pci-bridge.h |    1 
 arch/microblaze/pci/pci-common.c         |   39 ++++++--------
 arch/mips/pci/pci.c                      |   18 ++++--
 arch/mn10300/unit-asb2305/pci.c          |   14 +++--
 arch/powerpc/include/asm/pci-bridge.h    |    1 
 arch/powerpc/kernel/pci-common.c         |   27 ++++++----
 arch/powerpc/kernel/pci_64.c             |   40 +++++++-------
 arch/sh/drivers/pci/pci.c                |   19 ++++---
 arch/sparc/kernel/leon_pci.c             |   26 +++------
 arch/sparc/kernel/pci.c                  |   18 ++----
 arch/x86/include/asm/topology.h          |    2 -
 arch/x86/pci/acpi.c                      |   31 ++++++-----
 arch/x86/pci/bus_numa.c                  |   31 ++++++-----
 arch/x86/pci/common.c                    |   21 +++++--
 arch/x86/pci/legacy.c                    |    3 -
 arch/x86/pci/numaq_32.c                  |    2 -
 arch/xtensa/kernel/pci.c                 |   85 +++++++++++++++---------------
 drivers/parisc/dino.c                    |   48 ++++++++---------
 drivers/parisc/lba_pci.c                 |   73 ++++++++++++++------------
 drivers/pci/bus.c                        |   30 +++++++++--
 drivers/pci/probe.c                      |   75 ++++++++++++++++++++++++--
 drivers/pci/xen-pcifront.c               |    7 +-
 include/linux/pci.h                      |   24 +++++---
 47 files changed, 522 insertions(+), 427 deletions(-)

-- 
Bjorn

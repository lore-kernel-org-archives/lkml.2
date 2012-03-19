Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161046Ab2CSFrZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:47:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30456 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030903Ab2CSFrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:47:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 00/47] PCI, x86: pci root bus hotplug support
Date: Sun, 18 Mar 2012 22:45:49 -0700
Message-Id: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F66C867.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will add pci_stop_and_remove_bus() to support remove bus in
/sys/devices/pci.../pci_bus/...

To rescan root, need to
echo 1 > /sys/bus/pci/rescan_root

It supports acpi path root bus and legacy root bus.

This patcheset include some IOMM and dmar and pnpacpi fix with device refcount leaking.
        also include some bus remove/rescan cleanup.

The patches need to apply to pci/for-linus and pci/linux-next
	[PATCH -v3] PCI: pci_host_bridge related cleanup
	[PATCH -v11] PCI: allocate pci bus num range for unassigned bridge busn

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug

-v2: Address most of Bjorn's review, except still keeping .../pci_bus/.../remove
     Separate pci root hot add support from acpiphp to pci_root_hp
     add hot removal to pci_root_hp
-v3: Reordering the patches about /sys changes at last that Bjorn objects.
     Claim hw/fw allocated bus after root bus hot add.
     add two patches for Jiang Liu about removal.

Ashok Raj (1):
  ACPI: Enable SCI_EMULATE to manually simulate physical hotplug
    testing.

Jiang Liu (2):
  Correctly clean up pci root buses in function pci_remove_bus()
  Fix an access-after-free issue in function pci_stop_and_remove_bus()

Yinghai Lu (44):
  IOMMU: Update dmar units devices list during hotplug
  PNPACPI: Fix device ref leaking in acpi_pnp_match
  IOMMU: Fix tboot force iommu logic
  x86, PCI: Fix non acpi path pci_sysdata leaking with release_fn
  PCI: Separate out pci_assign_unassigned_bus_resources()
  PCI: Move back pci_rescan_bus()
  PCI: pci_bus_size_bridges() should not size own bridge
  PCI: Use __pci_bus_size_bridges() directly in pci_assign_unassigned_bus_resources()
  PCI, sysfs: Use device_type and attr_groups with pci dev
  PCI, sysfs: create rescan_bridge under /sys/.../pci/devices/... for pci bridges
  PCI: Add pci_bus_add_single_device()
  PCI: Make pci_rescan_bus_bridge_resize() use pci_scan_bridge instead
  PCI: Clean up rescan_bus_bridge_resize()
  PCI: Rescan bus or bridge using callback method too
  PCI, sysfs: Clean up rescan/remove with scheule_callback
  x86, PCI: Separate pcibios_allocate_bridge_resources()
  x86, PCI: Separate pcibios_allocate_dev_resources()
  x86, PCI: Let pcibios_allocate_bus_resources() take bus instead
  PCI: Claim hw/fw allocated resources in hot add path.
  PCI: Move pci_stop_and_remove_behind_bridge() down
  PCI: Add __pci_remove_bus_devices()
  PCI: Use list_for_each_entry_safe instead of list_for_each_safe
  PCI: Add pci_stop_and_remove_bus()
  PCI, ACPI: Make acpi_pci_root_remove remove pci root bus too
  PCI, acpiphp: Separate out hot-add support of pci host bridge
  PCI, ACPI: Add pci_root_hp hot removal notification support.
  PCI, ACPI: Add alloc_acpi_hp_work()
  PCI, acpiphp: Use acpi_hp_work
  PCI, pci_root_hp: Use acpi_hp_work
  PCI, ACPI: Make kacpi_hotplug_wq static
  PCI: Add debug print out for pci related dev release
  PCI, pciehp: Separate pci_hp_add_bridge()
  PCI, cphi_hotplug: Simplify configure_slot
  PCI, shpchp: Simplify configure_device
  PCI: Kill pci_is_reassignedev()
  PCI, sysfs: Prepare to kill pci device rescan
  PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
  PCI, ACPI: Add acpi_pci_root_rescan()
  PCI: Add __pci_scan_root_bus() that can skip bus_add
  x86, PCI: add __pci_scan_root_bus_on_node() that can skip bus_add
  x86, PCI: add __pcibios_scan_specific_bus that can skip bus_add
  x86, PCI: Add pcibios_root_rescan()
  x86, PCI: Add arch version pci_root_rescan()
  PCI: Add /sys/bus/pci/rescan_root

 Documentation/ABI/testing/sysfs-bus-pci    |   27 +++
 Documentation/feature-removal-schedule.txt |    9 +
 arch/x86/include/asm/pci.h                 |    4 +
 arch/x86/pci/common.c                      |   35 +++-
 arch/x86/pci/i386.c                        |  122 ++++++++-----
 arch/x86/pci/legacy.c                      |   45 ++++-
 drivers/acpi/Kconfig                       |   10 +
 drivers/acpi/Makefile                      |    2 +
 drivers/acpi/bus.c                         |    2 +
 drivers/acpi/internal.h                    |    6 +
 drivers/acpi/osl.c                         |   24 ++-
 drivers/acpi/pci_root.c                    |   14 ++
 drivers/acpi/pci_root_hp.c                 |  288 ++++++++++++++++++++++++++++
 drivers/acpi/sci_emu.c                     |  141 ++++++++++++++
 drivers/iommu/intel-iommu.c                |  194 +++++++++++++++++--
 drivers/pci/bus.c                          |   41 ++++
 drivers/pci/hotplug-pci.c                  |   13 ++
 drivers/pci/hotplug/acpiphp.h              |    9 +-
 drivers/pci/hotplug/acpiphp_glue.c         |  149 +++------------
 drivers/pci/hotplug/cpci_hotplug_pci.c     |   35 +---
 drivers/pci/hotplug/pciehp_pci.c           |   18 +--
 drivers/pci/hotplug/shpchp_pci.c           |   45 ++---
 drivers/pci/pci-sysfs.c                    |  153 +++++++++++++--
 drivers/pci/pci.c                          |   17 +--
 drivers/pci/pci.h                          |    2 +
 drivers/pci/probe.c                        |   46 ++++-
 drivers/pci/remove.c                       |   96 ++++++----
 drivers/pci/setup-bus.c                    |   50 ++----
 drivers/pnp/pnpacpi/core.c                 |    7 +-
 include/acpi/acpiosxf.h                    |    9 +-
 include/linux/dmar.h                       |    4 +
 include/linux/pci-acpi.h                   |    7 +
 include/linux/pci.h                        |    8 +
 33 files changed, 1245 insertions(+), 387 deletions(-)
 create mode 100644 drivers/acpi/pci_root_hp.c
 create mode 100644 drivers/acpi/sci_emu.c

-- 
1.7.7


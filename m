Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab2CJHBQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:01:16 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:39096 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2CJHBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:01:12 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 00/37] PCI, x86: pci root bus hotplug support
Date: Fri,  9 Mar 2012 23:00:00 -0800
Message-Id: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090204.4F5AFC33.0024,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

will add pci_stop_and_remove_bus() to support remove bus in
/sys/devices/pci.../pci_bus/...

To rescan root, need to
echo 1 > /sys/bus/pci/rescan

It supports acpi path root bus and legacy root bus.

This patcheset include some IOMM and dmar and pnpacpi fix with device refcount leaking.
	also include some bus remove/rescan cleanup.

The patches need to apply to pci/for-linus and pci/linux-next
and [PATCH 00/36] PCI: pci_host_bridge related cleanup and busn_alloc

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-root-bus-hotplug

-v2: Address most of Bjorn's review, except still keeping .../pci_bus/.../remove
     Separate pci root hot add support from acpiphp to pci_root_hp
     add hot removal to pci_root_hp

Thanks

Yinghai

Ashok Raj (1):
  ACPI: Enable SCI_EMULATE to manually simulate physical hotplug testing.

Yinghai Lu (36):
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
  PCI: Move pci_stop_and_remove_behind_bridge() down
  PCI: Add __pci_remove_bus_devices()
  PCI: Use list_for_each_entry_safe instead of list_for_each_safe
  PCI: Add pci_stop_and_remove_bus()
  PCI: Add pci bus removal through /sys/.../pci_bus/.../remove
  PCI, ACPI: Make acpi_pci_root_remove remove pci root bus too
  PCI, acpiphp: remove hot-add support of pci host bridge
  PCI, ACPI: Add pci_root_hp hot add hotplug notification
  PCI, ACPI: Add pci_root_hp hot removal notification support.
  PCI, ACPI: Add alloc_acpi_hp_work()
  PCI, acpiphp: Use acpi_hp_work
  PCI, pci_root_hp: Use acpi_hp_work
  PCI, ACPI: Make kacpi_hotplug_wq static
  PCI, ACPI: Add acpi_pci_root_rescan()
  PCI: Add __pci_scan_root_bus() that can skip bus_add
  x86, PCI: add __pci_scan_root_bus_on_node() that can skip bus_add
  x86, PCI: add __pcibios_scan_specific_bus that can skip bus_add
  x86, PCI: Add pcibios_root_rescan()
  x86, PCI: Add arch version pci_root_rescan()
  PCI: Make /sys/bus/pci/rescan rescan root
  PCI, sysfs: Prepare to kill pci device rescan

 Documentation/ABI/testing/sysfs-bus-pci    |   18 ++
 Documentation/feature-removal-schedule.txt |    9 +
 arch/x86/include/asm/pci.h                 |    4 +
 arch/x86/pci/common.c                      |   35 +++-
 arch/x86/pci/legacy.c                      |   44 ++++-
 drivers/acpi/Kconfig                       |   10 +
 drivers/acpi/Makefile                      |    2 +
 drivers/acpi/bus.c                         |    2 +
 drivers/acpi/internal.h                    |    6 +
 drivers/acpi/osl.c                         |   24 ++-
 drivers/acpi/pci_root.c                    |   14 ++
 drivers/acpi/pci_root_hp.c                 |  287 ++++++++++++++++++++++++++++
 drivers/acpi/sci_emu.c                     |  141 ++++++++++++++
 drivers/iommu/intel-iommu.c                |  194 +++++++++++++++++--
 drivers/pci/bus.c                          |   39 ++++
 drivers/pci/hotplug/acpiphp.h              |    9 +-
 drivers/pci/hotplug/acpiphp_glue.c         |  148 +++------------
 drivers/pci/hotplug/cpci_hotplug_pci.c     |    2 +-
 drivers/pci/hotplug/shpchp_pci.c           |    2 +-
 drivers/pci/pci-sysfs.c                    |  136 ++++++++++++--
 drivers/pci/pci.h                          |    1 +
 drivers/pci/probe.c                        |   43 ++++-
 drivers/pci/remove.c                       |   84 ++++++---
 drivers/pci/setup-bus.c                    |   50 ++----
 drivers/pnp/pnpacpi/core.c                 |    7 +-
 include/acpi/acpiosxf.h                    |    9 +-
 include/linux/dmar.h                       |    4 +
 include/linux/pci-acpi.h                   |    7 +
 include/linux/pci.h                        |    7 +
 29 files changed, 1089 insertions(+), 249 deletions(-)
 create mode 100644 drivers/acpi/pci_root_hp.c
 create mode 100644 drivers/acpi/sci_emu.c

-- 
1.7.7


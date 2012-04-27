Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760459Ab2D0PT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:19:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760189Ab2D0PT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:19:56 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Jiang Liu <liuj97@gmail.com>, Keping Chen <chenkeping@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 00/19] Introduce a global lock to serialize all PCI hotplug
Date: Fri, 27 Apr 2012 23:16:41 +0800
Message-Id: <1335539820-11232-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

There are multiple methods to trigger PCI hotplug requests/operations
concurrently, such as:
1. Sysfs interfaces exported by the PCI core subsystem
	/sys/devices/pcissss:bb/ssss:bb:dd.f/.../remove
	/sys/devices/pcissss:bb/ssss:bb:dd.f/.../rescan
	/sys/devices/pcissss:bb/ssss:bb:dd.f/.../pci_bus/ssss:bb/rescan
	/sys/bus/pci/rescan
2. Sysfs interfaces exported by the PCI hotplug subsystem
	/sys/bus/pci/slots/xx/power
3. PCI hotplug events triggered by PCI Hotplug Controllers
4. ACPI hotplug events for PCI host bridges
5. Driver binding/unbinding events
	binding/unbinding pci drivers with SR-IOV support

With current implementation, the PCI core subsystem doesn't support
concurrent hotplug operations yet. The existing pci_bus_sem lock only
protects several lists in struct pci_bus, such as children list,
devices list, but it doesn't protect the pci_bus or pci_dev structure
themselves.

Let's take pci_remove_bus_device() as an example, which are used by
PCI hotplug drivers to hot-remove PCI devices.  Currently all these
are free running without any protection, so it can't support reentrance.
pci_remove_bus_device()
    ->pci_stop_bus_device()
        ->pci_stop_bus_device()
            ->pci_stop_bus_devices()
        ->pci_stop_dev()
                ->pci_proc_detach_device()
                ->pci_remove_sysfs_dev_files()
            ->device_unregister()
                ->pcie_aspm_exit_link_state()
    ->__pci_remove_bus_device()
        ->__pci_remove_behind_bridge()
        ->pci_remove_bus()
            ->device_unregister()
        ->pci_destroy_dev()
            ->pci_free_resources()
            ->pci_dev_put()

There are similar issues on hot-adding side.  It may also cause trouble
if pci_remove_bus_device() and pci_rescan_bus() are called concurrently.

So this patchset introduces a recursive rwsem to globally serialize all
PCI hotplug operations. It also fixes some minor bugs in current code.
Following PCI hotplug drivers/interfaces have been enhanced with this
new lock.
1. Sysfs interfaces exported by the PCI core subsystem
2. Sysfs interfaces exported by the PCI hotplug subsystem
3. pciehp
4. shpchp
5. cpcihp_generic and cpcihp_zt5550
6. fakephp

We have tested pciehp and fakephp, but lack of hardware platforms to test
other affected hotplug drivers.

There are still several tasks on the TODO list:
1) all other PCI hotplug driver in drivers/pci/hotplug directory
2) SR-IOV
3) acpiphp (plan to do this based on Yinghai's PCI root bus hotplug gate)
4) pci_root (plan to do this based on Yinghai's PCI root bus hotplug gate)

V2: refine commit messages and hide sys interface 'remove' and 'rescan' of
    SR-IOV virtural devices

Jiang Liu (18):
  PCI: introduce pci_bus_get()/pci_bus_put() to hide PCI implementation
    details
  PCI: introduce recursive rwsem to serialize PCI hotplug operations
  PCI: replace pci_remove_rescan_mutex with the PCI hotplug lock
  PCI: serialize hotplug operations triggered by PCI hotplug sysfs
    interfaces
  PCI: correctly flush workqueue when destroy pcie hotplug controller
  PCI: prepare for serializing hotplug operations triggered by pciehp
    driver
  PCI: serialize hotplug operaitons triggered by the pciehp driver
  PCI: fix two race windows when probing/removing SHPC controller
  PCI: correctly flush workqueues and timer when destroy SHPC
    controller
  PCI: serialize hotplug operaitons triggered by the shpchp driver
  PCI: release IO resource in error handling path in
    cpcihp_generic_init()
  PCI: clean up all resources in error handling path in
    zt5550_hc_init_one()
  PCI: trivial code clean up in cpci_hotplug_core.c
  PCI: fix race windows when shutting down cpcihp controller
  PCI: hold a reference count to the PCI bus used by cpcihp drivers
  PCI: serialize PCI hotplug operations triggered by cpcihp drivers
  PCI: serialize PCI hotplug operations triggered by fakephp drivers
  PCI: hide sys interface 'remove' and 'rescan' for SR-IOV virtual
    devices

Yinghai Lu (1):
  PCI, sysfs: Use device_type and attr_groups with pci dev

 drivers/pci/bus.c                       |   15 +++
 drivers/pci/hotplug.c                   |   55 ++++++++++
 drivers/pci/hotplug/cpci_hotplug_core.c |   53 ++++++-----
 drivers/pci/hotplug/cpcihp_generic.c    |   30 ++++--
 drivers/pci/hotplug/cpcihp_zt5550.c     |   21 +++-
 drivers/pci/hotplug/fakephp.c           |   38 ++++++-
 drivers/pci/hotplug/pci_hotplug_core.c  |   26 ++++-
 drivers/pci/hotplug/pciehp.h            |    5 +-
 drivers/pci/hotplug/pciehp_core.c       |   25 ++++-
 drivers/pci/hotplug/pciehp_ctrl.c       |   56 ++++++++++-
 drivers/pci/hotplug/pciehp_hpc.c        |   18 +++-
 drivers/pci/hotplug/shpchp.h            |    3 +
 drivers/pci/hotplug/shpchp_core.c       |   11 +-
 drivers/pci/hotplug/shpchp_ctrl.c       |   32 ++++++
 drivers/pci/hotplug/shpchp_hpc.c        |   36 ++++---
 drivers/pci/pci-sysfs.c                 |  164 ++++++++++++++++++++++---------
 drivers/pci/pci.h                       |    1 +
 drivers/pci/probe.c                     |    1 +
 drivers/pci/remove.c                    |    1 +
 include/linux/pci.h                     |   20 ++++-
 20 files changed, 480 insertions(+), 131 deletions(-)

-- 
1.7.5.4


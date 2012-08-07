Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab2HGQSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:18:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35590 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab2HGQSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:18:36 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH v1 00/22] introduce PCI bus lock to serialize PCI hotplug operations
Date: Wed,  8 Aug 2012 00:10:40 +0800
Message-Id: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

This is the second take to resolve race conditions when hot-plugging PCI
devices/host bridges. Instead of using a globla lock to serialize all hotplug
operations as in previous version, now we introduce a state machine and bit
lock mechanism for PCI buses to serialize hotplug operations. For discussions
related to previous version, please refer to:
http://comments.gmane.org/gmane.linux.kernel.pci/15007

This patch-set is still in early stages, so sending it out just requesting
for comments. Any comments are welcomed, especially about whether it's the
right/suitable way to solve these race condition issues.

patch 1-5:
	Preparing for coming PCI bus lock
patch 6-7: 
	Core of the new PCI bus lock mechanism.
patch 8-13:
	Enhance PCI core to support PCI bus lock mechanism.
patch 14-18:
	Enhance several PCI hotplug drivers to use PCI bus lock to serialize
	hotplug operations.
patch 19-20:
	Enable PCI bus lock mechanism for x86 and IA64, still need to enable
	PCI bus lock for other archs.
patch 21-22:
	Cleanups for unsed code.

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

Jiang Liu (22):
  PCI: use pci_get_domain_bus_and_slot() to avoid race conditions
  PCI: trivial cleanups for drivers/pci/remove.c
  PCI: change PCI device management code to better follow device model
  PCI: split PCI bus device registration into two stages
  PCI: introduce pci_bus_{get|put}() to manage PCI bus reference count
  PCI: use a global lock to serialize PCI root bridge hotplug
    operations
  PCI: introduce PCI bus lock to serialize PCI hotplug operations
  PCI: introduce hotplug safe search interfaces for PCI bus/device
  PCI: enhance PCI probe logic to support PCI bus lock mechanism
  PCI: enhance PCI bus specific logic to support PCI bus lock mechanism
  PCI: enhance PCI resource assignment logic to support PCI bus lock
    mechanism
  PCI: enhance PCI remove logic to support PCI bus lock mechanism
  PCI: make each PCI device hold a reference to its parent PCI bus
  PCI/sysfs: use PCI bus lock to avoid race conditions
  PCI/eeepc: use PCI bus lock to avoid race conditions
  PCI/asus-wmi: use PCI bus lock to avoid race conditions
  PCI/pciehp: use PCI bus lock to avoid race conditions
  PCI/acpiphp: use PCI bus lock to avoid race conditions
  PCI/x86: enable PCI bus lock mechanism for x86 platforms
  PCI/IA64: enable PCI bus lock mechanism for IA64 platforms
  PCI: cleanups for PCI bus lock implementation
  PCI: unexport pci_root_buses

 arch/ia64/pci/pci.c                  |    2 +
 arch/ia64/sn/kernel/io_common.c      |    4 +-
 arch/ia64/sn/kernel/io_init.c        |    1 +
 arch/ia64/sn/pci/tioca_provider.c    |    4 +-
 arch/x86/pci/acpi.c                  |    6 +-
 arch/x86/pci/common.c                |   12 +++
 drivers/acpi/pci_root.c              |    8 +-
 drivers/edac/i7core_edac.c           |   16 ++-
 drivers/gpu/drm/drm_fops.c           |    6 +-
 drivers/gpu/vga/vgaarb.c             |   15 +--
 drivers/pci/bus.c                    |  188 +++++++++++++++++++++++++++++-----
 drivers/pci/host-bridge.c            |   19 ++++
 drivers/pci/hotplug/acpiphp_glue.c   |   13 ++-
 drivers/pci/hotplug/cpcihp_generic.c |    8 +-
 drivers/pci/hotplug/pciehp_pci.c     |   15 +++
 drivers/pci/hotplug/sgi_hotplug.c    |    2 +
 drivers/pci/iov.c                    |   11 +-
 drivers/pci/pci-sysfs.c              |   37 ++++---
 drivers/pci/probe.c                  |   83 +++++++++++----
 drivers/pci/remove.c                 |  176 +++++++++++++++++--------------
 drivers/pci/search.c                 |   53 ++++++++--
 drivers/pci/setup-bus.c              |   65 +++++++++---
 drivers/pci/xen-pcifront.c           |   10 +-
 drivers/platform/x86/asus-wmi.c      |   23 ++++-
 drivers/platform/x86/eeepc-laptop.c  |   20 ++--
 include/linux/pci.h                  |   56 +++++++++-
 26 files changed, 629 insertions(+), 224 deletions(-)

-- 
1.7.9.5


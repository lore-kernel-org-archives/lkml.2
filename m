Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab2G1Loh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 07:44:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38228 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2G1Loe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 07:44:34 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Len Brown <lenb@kernel.org>, Tony Luck <tony.luch@intel.com>,
        Bob Moore <robert.moore@intel.com>, Huang Ying <ying.huang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Hanjun Guo <guohanjun@huawei.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [RFC PATCH 0/3] ACPI based system device hotplug framework
Date: Sat, 28 Jul 2012 19:42:49 +0800
Message-Id: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <liuj97@gmail.com>

The patchset is based on v3.5-rc6 and you may pull them from:
git://github.com/jiangliu/linux.git acpihp

Modern high-end server may support advanced hotplug features for system
devices, including physical processor, memory board, IO extension board
and/or computer node. The ACPI specifications have provided standard
interfaces between firmware and OS to support device hotplug at runtime.
This patch series provide an ACPI based hotplug framework to support system
device hotplug at runtime, which will replace current existing ACPI device
driver based CPU/memory/CONTAINER hotplug mechanism.

The new ACPI based hotplug framework is modelled after PCI hotplug
architecture and target to achieve following goals:
1) Provide a mechanism to detect hotplug slots by checking ACPI _EJ0 method,
ACPI PRCT (platform RAS capabilities table) and other platform specific
mechanisms.

2) Unify the way to enumerate ACPI based hotplug slots. All hotplug slots
will be enumerated by the enumeration driver, instead of by ACPI device
drivers.

3) Dynamically create/destroy ACPI hotplug slots. For example, new ACPI
hotplug slots may be created when hot-adding a computer node if the node
contains some memory hotplug slots.

4) Unify the way to handle ACPI hotplug events. All ACPI hotplug events
for system devices will be handled by a generic ACPI hotplug driver,
instead of handled by ACPI device drivers.

5) Solve dependencies among hotplug slots. You need first to remove the
memory device before removing a physical processor if a hotpluggable memory
device is connected to a hotpluggable physical processor.

6) Provide better error handling and recover.

7) Provide interface to cancel ongoing hotplug operations. It may take a
very long time to remove a memory device, so provide interface to cancel
the operation.

8) Support new RAS features, such as socket/memory migration.

9) Provide better user interfaces to the hotplug functionalities.

The new hotplug framework includes four logical components.

The first is an ACPI hotplug slot enumerator, which enumerates ACPI hotplug
slots on load and provides callbacks to manage those hotplug slots. An ACPI
hotplug slot is an abstraction of receptacles, where a group of system
devices could be connected to.

The second is a device class for ACPI hotplug slots, named acpihp_slot_class.
All ACPI hotplug slot devices will be associated with acpihp_slot_class.

The third is a platform independent class driver for ACPI hotplug slots,
which registers itself onto acpihp_slot_class and manages all ACPI hotplug
slots in system. This hotplug driver handles ACPI hotplug events, processes
user requests and manages slot state machine accoring to user requests.

The fourth is a series of ACPI device drivers, for CPU, memory, PCI host
bridge, IOAPIC and ACPI CONTAINER. These ACPI device drivers provide device
specific callbacks for the hotplug driver to add/remove system devices at
runtime.

This patch set implements the first and second parts, which enumerates
hotplug slots and creates sysfs entries for each slot as below.

linux-drf:/sys/devices/LNXSYSTM:00/acpihp # ll
drwxr-xr-x 4 root root 0 Jul 28 16:00 NODE00
drwxr-xr-x 3 root root 0 Jul 28 16:00 NODE01
drwxr-xr-x 3 root root 0 Jul 28 16:00 NODE02

linux-drf:/sys/devices/LNXSYSTM:00/acpihp/NODE00 # ll
drwxr-xr-x 3 root root     0 Jul 28 16:00 IOX01
-r--r--r-- 1 root root 65536 Jul 28 16:01 capabilities
lrwxrwxrwx 1 root root     0 Jul 28 16:00 device -> ../../../LNXSYSTM:00
-r--r--r-- 1 root root 65536 Jul 28 16:01 object
drwxr-xr-x 2 root root     0 Jul 28 16:01 power
-r--r--r-- 1 root root 65536 Jul 28 16:01 state
-r--r--r-- 1 root root 65536 Jul 28 16:01 status
lrwxrwxrwx 1 root root     0 Jul 28 16:00 subsystem -> ../../../../class/acpihp
-r--r--r-- 1 root root 65536 Jul 28 16:01 type
-rw-r--r-- 1 root root 65536 Jul 28 16:01 uevent

linux-drf:/sys/bus/acpi/acpihp # ls
NODE00  NODE00.IOX01  NODE01  NODE02

linux-drf:/sys/bus/acpi/acpihp # ll
lrwxrwxrwx 1 root root 0 Jul 28 16:03 NODE00 ->
		../../../devices/LNXSYSTM:00/acpihp/NODE00
lrwxrwxrwx 1 root root 0 Jul 28 16:03 NODE00.IOX01 ->
		../../../devices/LNXSYSTM:00/acpihp/NODE00/IOX01
lrwxrwxrwx 1 root root 0 Jul 28 16:03 NODE01 ->
		../../../devices/LNXSYSTM:00/acpihp/NODE01
lrwxrwxrwx 1 root root 0 Jul 28 16:03 NODE02 ->
		../../../devices/LNXSYSTM:00/acpihp/NODE02

Jiang Liu (3):
  ACPIHP: introduce a framework for ACPI based system device hotplug
  ACPIHP: ACPI system device hotplug slot enumerator
  ACPIHP: detect ACPI hotplug slots by checking ACPI _EJ0 method

 drivers/acpi/Kconfig                 |   33 ++
 drivers/acpi/Makefile                |    2 +
 drivers/acpi/hotplug/Makefile        |   10 +
 drivers/acpi/hotplug/core.c          |  590 ++++++++++++++++++++++++++++++++++
 drivers/acpi/hotplug/slot_enum.c     |  469 +++++++++++++++++++++++++++
 drivers/acpi/hotplug/slot_enum_ej0.c |  113 +++++++
 include/acpi/acpi_hotplug.h          |  191 +++++++++++
 7 files changed, 1408 insertions(+)
 create mode 100644 drivers/acpi/hotplug/Makefile
 create mode 100644 drivers/acpi/hotplug/core.c
 create mode 100644 drivers/acpi/hotplug/slot_enum.c
 create mode 100644 drivers/acpi/hotplug/slot_enum_ej0.c
 create mode 100644 include/acpi/acpi_hotplug.h

-- 
1.7.9.5


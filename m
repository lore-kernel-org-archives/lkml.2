Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2JGVnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:43:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab2JGVnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:43:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/28] ACPI based system device hotplug framework
Date: Sun, 07 Oct 2012 23:47:12 +0200
Message-ID: <4290643.jEcV9mqAac@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 06 of October 2012 23:27:08 Jiang Liu wrote:
> The patchset is based on "5f3d2f2e1a63679cf1c4a4210f2f1cc2f335bef6"
> from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> And you pull the changeset from git://github.com/jiangliu/linux.git acpihp
> 
> Modern high-end server may support advanced hotplug features for system
> devices, including physical processor, memory board, IO extension board
> and/or computer node. The ACPI specifications have provided standard
> interfaces between firmware and OS to support device hotplug at runtime.
> This patch series provide an ACPI based hotplug framework to support system
> device hotplug at runtime, which will replace current existing ACPI device
> driver based CPU/memory/CONTAINER hotplug mechanism.
> 
> The new ACPI system device hotplug framework has following design goals:
> 1) Provide a mechanism to detect hotplug slots by checking ACPI _EJ0 method,
> ACPI PRCT (platform RAS capabilities table) and other platform specific
> mechanisms.

Which of the patches does that?

> 2) Unify the way to enumerate ACPI based hotplug slots. All hotplug slots
> will be enumerated by the enumeration driver

What is the enumeration driver?

> , instead of by ACPI device drivers.
> 3) Unify the way to handle ACPI hotplug events. All ACPI hotplug events
> for system devices will be handled by a generic ACPI hotplug driver,
> instead of handled by ACPI device drivers.

What are "system devices"

> 4) Solve dependencies among hotplug slots. You need first to remove the
> memory device before removing a physical processor if a hotpluggable memory
> device is connected to a hotpluggable physical processor.
> 5) Provide better error handling and recover.
> 6) Provide interface to cancel ongoing hotplug operations. It may take a
> very long time to remove a memory device, so provide interface to cancel
> the operation. This is important especially for memory hot-removal.
> 7) Support new RAS features, such as socket/memory migration.
> 8) Provide better user interfaces to the hotplug functionalities.
> 9) Trigger hotplug events/operations by software. This feature is useful
>    for hardware fault management and power saving.

Well, this may or may not be OK.  I'm going to review the patches, but I can't
really say when it's going to happen (not really soon for sure).

> The new ACPI based hotplug framework is modelled after PCI hotplug
> architecture, which uses a hotplug driver to manage hotplug operations
> and different device drivers to manage individual devices.
> 
> The new framework contains three main components as follow:
> 1) ACPI system device hotplug slot enumerator, which enumerates all ACPI
>    hotplug slots according to platform specific knowledges. And it also
>    provides callbacks to control each slot, such as poweron, poweroff,
>    get_status etc. Currently there are two built-in methods to detect
>    hotplug slots.
> 1.a) Detecting hotplug slot by checking _EJ0 method.
> 1.b) Faking hotplug slot. Use "modprobe acpihp_slot fake_slot=0xnn",
>      0x1 for CONTAINER, 0x2 for memory device, 0x4 for CPU and 0x8 PCI host
>      bridge. The fake slot enumerator will treat each assigned ACPI device
>      as a hotplug slot, so it could be used for testing on hardware platforms
>      without hardware hotplug capabilities.
> 2) ACPI system device hotplug driver, which implements a platform indenpendent
>    state machine for hotplug slots and also provides sysfs based user
>    interfaces.
> 3) Enhanced ACPI device drivers for CONTAINER, CPU, Memroy and PCI host bridge.
>    All logic to handle hotplug events has been moved from these ACPI device
>    driver into the hotplug driver. Now these ACPI device dirvers only take
>    resposibilities configure/unconfigure corresponding system devices when
>    hotplug happens.
> 
> Now 1), 2) and part of 2) are ready, we still need to enhance mem_hotplug
> and pci_root drivers to support new hotplug framework.
> 
> On my laptop with fake slot enumerator, we got:
> root@cat:/sys/devices/LNXSYSTM:00/acpihp# ls
> CPU00  CPU01  CPU02  CPU03  CPU04  CPU05  CPU06  CPU07  IOX00
> root@cat:/sys/devices/LNXSYSTM:00/acpihp# cd CPU07/
> root@cat:/sys/devices/LNXSYSTM:00/acpihp/CPU07# ls
> capabilities  connect     device  object  state   subsystem  uevent
> configure     dependency  enable  power   status  type
> 
> /* Hot-remove CPU07 */
> root@cat:/sys/devices/LNXSYSTM:00/acpihp/CPU07# echo 0 > enable
> /* Hot-add CPU07 */
> root@cat:/sys/devices/LNXSYSTM:00/acpihp/CPU07# echo 1 > configure
> 
> V2->V3 changes:
> 1) Fix minor bugs and refine code
> 2) Implement fake slot enumerator for testing
> 3) Enhance ACPI container driver to support new hotplug framework
> 4) Enhance ACPI processor driver to support new hotplug framework
> 5) Resolve dependencies among slots by evaluating _EDL method.
> TODO:
> 1) Enhance ACPI mem_hotplug driver to support new hotplug framework
> 2) Enhance ACPI pci_root driver to support new PCI host bridge hotplug
>    based on Yinghai's work
> 
> V1->V2 changes:
> 1) implement the ACPI hotplug driver
> 2) enhance ACPI container driver to support new hotplug framework
> TODO:
> 1) handle ACPI hotplug events in ACPI hotplug driver
> 2) handle dependencies among slots by evaluating ACPI _EDL
> 3) enhance ACPI processor, memory and PCI root drivers to support new
>    hotplug framework
> 4) develop an ACPI driver for IOAPIC
> 5) thorough tests:)
> 
> Jiang Liu (28):
>   ACPIHP: introduce a framework for ACPI based system device hotplug
>   ACPIHP: ACPI system device hotplug slot enumerator driver
>   ACPIHP: detect ACPI hotplug slots by checking ACPI _EJ0 method
>   ACPIHP: implement a fake ACPI system device hotplug slot enumerator
>   ACPI: introduce interfaces to manage ACPI device reference count
>   ACPIHP: introduce interfaces to scan and walk ACPI devices connecting
>     to a slot
>   ACPIHP: use klist to manage ACPI devices connecting to a slot
>   ACPIHP: add callbacks into acpi_device_ops to support new hotplug
>     framework
>   ACPIHP: provide interfaces to associate driver specific data with
>     slots
>   ACPIHP: implement utility functions to support system device hotplug
>   ACPIHP: implement skeleton of ACPI system device hotplug driver
>   ACPIHP: analyse dependencies among ACPI hotplug slots
>   ACPIHP: provide interface to cancel inprogress hotplug operations
>   ACPIHP: configure/unconfigure system devices connecting to a hotplug
>     slot
>   ACPIHP: implement the state machine for ACPI hotplug slots
>   ACPIHP: implement sysfs interfaces for ACPI system device hotplug
>   ACPIHP: block ACPI device driver unloading when executing hotplug
>     operations
>   ACPIHP/container: change ACPI container driver to support new hotplug
>     framework
>   ACPIHP/container: move container.c into drivers/acpi/hotplug
>   ACPI/processor: remove dead code from processor_driver.c
>   ACPIHP/processor: reorganize ACPI processor driver for new hotplug
>     framework
>   ACPIHP/processor: protect accesses to device->driver_data
>   ACPIHP/processor: enhance processor driver to support new hotplug
>     framework
>   CPU: introduce busy flag to temporarily disable CPU online sysfs
>     interface
>   ACPIHP/processor: reject online/offline requests when doing processor
>     hotplug
>   ACPI/processor: save parsed APIC ID in processor driver data
>     structure
>   x86: simplify _acpi_map_lsapic()
>   ACPI/processor: serialize call to acpi_map/unmap_lsapic
> 
>  arch/ia64/include/asm/cpu.h            |    2 +-
>  arch/ia64/kernel/acpi.c                |   38 +-
>  arch/ia64/kernel/topology.c            |   15 +-
>  arch/x86/include/asm/cpu.h             |    2 +-
>  arch/x86/include/asm/mpspec.h          |    2 +-
>  arch/x86/kernel/acpi/boot.c            |   82 +---
>  arch/x86/kernel/apic/apic.c            |    8 +-
>  arch/x86/kernel/topology.c             |   10 +-
>  drivers/acpi/Kconfig                   |   69 ++-
>  drivers/acpi/Makefile                  |    3 +-
>  drivers/acpi/bus.c                     |   22 +-
>  drivers/acpi/container.c               |  296 -----------
>  drivers/acpi/hotplug/Makefile          |   21 +
>  drivers/acpi/hotplug/acpihp.h          |   37 ++
>  drivers/acpi/hotplug/acpihp_drv.h      |  107 ++++
>  drivers/acpi/hotplug/cancel.c          |  174 +++++++
>  drivers/acpi/hotplug/configure.c       |  354 ++++++++++++++
>  drivers/acpi/hotplug/container.c       |  135 +++++
>  drivers/acpi/hotplug/core.c            |  842 ++++++++++++++++++++++++++++++++
>  drivers/acpi/hotplug/dependency.c      |  249 ++++++++++
>  drivers/acpi/hotplug/device.c          |  208 ++++++++
>  drivers/acpi/hotplug/drv_main.c        |  351 +++++++++++++
>  drivers/acpi/hotplug/slot.c            |  421 ++++++++++++++++
>  drivers/acpi/hotplug/slot_ej0.c        |  153 ++++++
>  drivers/acpi/hotplug/slot_fake.c       |  177 +++++++
>  drivers/acpi/hotplug/state_machine.c   |  631 ++++++++++++++++++++++++
>  drivers/acpi/hotplug/sysfs.c           |  245 ++++++++++
>  drivers/acpi/internal.h                |    7 +
>  drivers/acpi/processor_core.c          |   26 +-
>  drivers/acpi/processor_driver.c        |  557 ++++++++++-----------
>  drivers/acpi/scan.c                    |   17 +-
>  drivers/base/cpu.c                     |   22 +
>  drivers/gpu/drm/i915/intel_opregion.c  |    2 +
>  drivers/gpu/drm/nouveau/nouveau_acpi.c |    1 +
>  drivers/pci/hotplug/acpiphp_glue.c     |    9 +-
>  drivers/pci/hotplug/acpiphp_ibm.c      |    5 +-
>  drivers/pci/hotplug/sgi_hotplug.c      |    6 +-
>  drivers/platform/x86/thinkpad_acpi.c   |    2 +
>  drivers/pnp/pnpacpi/core.c             |   23 +-
>  drivers/xen/cpu_hotplug.c              |    2 +-
>  include/acpi/acpi_bus.h                |   21 +-
>  include/acpi/acpi_hotplug.h            |  323 ++++++++++++
>  include/acpi/container.h               |   12 -
>  include/acpi/processor.h               |    3 +
>  include/linux/acpi.h                   |    2 +-
>  include/linux/cpu.h                    |    2 +
>  46 files changed, 4923 insertions(+), 773 deletions(-)
>  delete mode 100644 drivers/acpi/container.c
>  create mode 100644 drivers/acpi/hotplug/Makefile
>  create mode 100644 drivers/acpi/hotplug/acpihp.h
>  create mode 100644 drivers/acpi/hotplug/acpihp_drv.h
>  create mode 100644 drivers/acpi/hotplug/cancel.c
>  create mode 100644 drivers/acpi/hotplug/configure.c
>  create mode 100644 drivers/acpi/hotplug/container.c
>  create mode 100644 drivers/acpi/hotplug/core.c
>  create mode 100644 drivers/acpi/hotplug/dependency.c
>  create mode 100644 drivers/acpi/hotplug/device.c
>  create mode 100644 drivers/acpi/hotplug/drv_main.c
>  create mode 100644 drivers/acpi/hotplug/slot.c
>  create mode 100644 drivers/acpi/hotplug/slot_ej0.c
>  create mode 100644 drivers/acpi/hotplug/slot_fake.c
>  create mode 100644 drivers/acpi/hotplug/state_machine.c
>  create mode 100644 drivers/acpi/hotplug/sysfs.c
>  create mode 100644 include/acpi/acpi_hotplug.h
>  delete mode 100644 include/acpi/container.h

And I seriously think this is too much material for a single patchset.

Please consider splitting it into smaller and well-documented series of
patches, so that the reviewers can understand things more easily.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

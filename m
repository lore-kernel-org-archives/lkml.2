Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2CADBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:01:14 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:31641 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab2CADBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:01:11 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2 00/36] PCI: pci_host_bridge related cleanup and busn_alloc
Date: Wed, 29 Feb 2012 19:00:01 -0800
Message-Id: <1330570837-26638-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F4EE66D.0091,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first 13 patches are hostbridge clean up.
will add struct device dev into host_bridge struct.
also will add release support to make sure allocated resource get
freed during root bus removal including hostbridge and pci_sysdata.

others 23 patches are busn_alloc related.
Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree
Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

The patches need to apply to pci/for-linus and pci/linux-next
because one patch that is needed only is only in pci/for-linus

could get from
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-next

please put them into pci/linux-next branch for more testing.

-v2: dropped the patch that is with x86 pcibios_bus_to_resource that Bjorn objected.
     reorder the patchesset to mold one appended patch into previous patch.

Thanks

Yinghai

Yinghai Lu (36):
  PCI: Separate host_bridge code out from probe.c
  x86, PCI: Fix memleak with get_current_resources
  PCI: rename pci_host_bridge() to find_pci_root_bridge()
  PCI: add generic device into pci_host_bridge struct
  PCI: add host bridge release support
  x86, PCI: break down get_current_resource()
  x86, PCI: add host bridge resource release for using _CRS
  x86, PCI: embed name acpi version pci_root_info struct
  x86, PCI: embed pci_sysdata into pci_root_info on acpi path
  x86, PCI: Allocating pci_root_info for not using _CRS path
  x86, PCI: Merge root info printing for nocrs path
  x86, PCI: add print all root info for nocrs path
  x86, PCI: allocate temp range array in amd_bus pci_root_info probing
  x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
  PCI: Add busn_res into struct pci_bus.
  PCI: Add busn_res operation functions
  PCI: release busn when removing bus
  PCI: insert busn_res in pci_create_root_bus
  PCI: checking busn_res in pci_scan_root_bus
  PCI: default busn_resource
  PCI: add default res for pci_scan_bus
  x86, PCI: add busn into resources list for acpi path
  x86, PCI: put busn resource in pci_root_info for no_crs path
  PCI, ia64: Register busn_res for root buses
  PCI, sparc: Register busn_res for root buses
  PCI, powerpc: Register busn_res for root buses
  PCI, parisc: Register busn_res for root buses
  PCI: Add pci_bus_extend/shrink_top()
  PCI: Probe safe range that we can use for unassigned bridge.
  PCI: Strict checking of valid range for bridge
  PCI: Allocate bus range instead of use max blindly
  PCI: kill pci_fixup_parent_subordinate_busnr()
  PCI: Seperate child bus scanning to two passes overall
  pcmcia: remove workaround for fixing pci parent bus subordinate
  PCI: Double checking setting for bus register and bus struct.
  PCI, pciehp: Remove not needed bus number range checking

 arch/ia64/pci/pci.c                   |    2 +
 arch/powerpc/include/asm/pci-bridge.h |    1 +
 arch/powerpc/kernel/pci-common.c      |   10 +-
 arch/sparc/kernel/pci.c               |    4 +
 arch/sparc/kernel/pci_impl.h          |    1 +
 arch/x86/pci/acpi.c                   |  121 ++++---
 arch/x86/pci/amd_bus.c                |   88 ++----
 arch/x86/pci/broadcom_bus.c           |   17 +-
 arch/x86/pci/bus_numa.c               |  100 +++++--
 arch/x86/pci/bus_numa.h               |   23 +-
 arch/x86/pci/common.c                 |   27 +--
 drivers/parisc/dino.c                 |    5 +
 drivers/parisc/lba_pci.c              |    3 +
 drivers/pci/Makefile                  |    2 +-
 drivers/pci/host-bridge.c             |   96 ++++++
 drivers/pci/hotplug/pciehp_pci.c      |   12 +-
 drivers/pci/probe.c                   |  601 ++++++++++++++++++++++-----------
 drivers/pci/remove.c                  |    1 +
 drivers/pcmcia/yenta_socket.c         |   75 ----
 include/linux/pci.h                   |   15 +-
 20 files changed, 752 insertions(+), 452 deletions(-)
 create mode 100644 drivers/pci/host-bridge.c

-- 
1.7.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab2CSFnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:43:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27583 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab2CSFnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:43:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v11 00/30] PCI: allocate pci bus num range for unassigned bridge busn
Date: Sun, 18 Mar 2012 22:42:31 -0700
Message-Id: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090206.4F66C78E.0027,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

The patches need to apply to linux v3.3 + pci-next and
        [PATCH -v3] PCI: pci_host_bridge related cleanup

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

-v2: according to Jesse, split to more small patches.
-v3: address some request from Bjorn. like make use %pR for busn_res debug print
        out, and move the comment change with code change.
-v4: fixes the problem about rescan that Bjorn found.
-v5: add /proc/iobusn that is requested by Bjorn.
     remove old workaround from pciehp.
     add rescan_bridge for pci bridge in /sys
-v6: remove global iobusn_resource, and every root bus's busn_res will be root
     of children buses' busn_res.
     pc cardbus change is tested by pcmcia maintainter.
-v7: remove pci_scan_root_bus_max requested by Bjorn and Jesse.
-v8: rebase on top other patches with arch/x86/pci/bus_numa.c changes
     also only include busn_res related changes.
-v9: Add busn into pci_root_info, and add it to resources list and pass it
     to pci_create_root_bus.
-v11: convert busn_res probe to generic probe_resource with resource lock holding
     add more strict checking about not scaned peer bridges.

Yinghai Lu (30):
  x86, PCI: Add print all root info for not using _CRS path
  x86, PCI: Allocate temp range array in amd_bus pci_root_info probing
  x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
  PCI: Add busn_res into struct pci_bus.
  PCI: Add busn_res operation functions
  PCI: Release busn_res when removing bus
  PCI: Insert busn_res in pci_create_root_bus()
  PCI: Checking busn_res in pci_scan_root_bus()
  PCI: Add default busn_resource
  PCI: Add default busn_res for pci_scan_bus()
  x86, PCI: Add busn_res into resources list for acpi path
  x86, PCI: Put busn resource in pci_root_info for not using _CRS path
  PCI, ia64: Register busn_res for root buses
  PCI, sparc: Register busn_res for root buses
  PCI, powerpc: Register busn_res for root buses
  PCI, parisc: Register busn_res for root buses
  resources: Add probe_resource()
  resources: Replace registered resource in tree.
  PCI: Add pci_bus_extend/shrink_top()
  PCI: Probe safe range that we can use for unassigned bridge.
  PCI: Add pci_bus_replace_busn_res()
  PCI: Allocate bus range instead of use max blindly
  PCI: Strict checking of valid range for bridge
  PCI: Kill pci_fixup_parent_subordinate_busnr()
  PCI: Seperate child bus scanning to two passes overall
  pcmcia: Remove workaround for fixing pci parent bus subordinate
  PCI: Double checking setting for bus register and bus struct.
  PCI, pciehp: Remove not needed bus number range checking
  PCI: More strict checking of valid range for bridge
  PCI: Don't shrink too much for hotplug bridge

 arch/ia64/pci/pci.c                   |    2 +
 arch/powerpc/include/asm/pci-bridge.h |    1 +
 arch/powerpc/kernel/pci-common.c      |   10 +-
 arch/sparc/kernel/pci.c               |    4 +
 arch/sparc/kernel/pci_impl.h          |    1 +
 arch/x86/pci/acpi.c                   |   11 +-
 arch/x86/pci/amd_bus.c                |   14 +-
 arch/x86/pci/bus_numa.c               |   30 ++-
 arch/x86/pci/bus_numa.h               |    4 +-
 arch/x86/pci/common.c                 |   27 +--
 drivers/parisc/dino.c                 |    5 +
 drivers/parisc/lba_pci.c              |    3 +
 drivers/pci/hotplug/pciehp_pci.c      |   12 +-
 drivers/pci/probe.c                   |  439 +++++++++++++++++++++++++++------
 drivers/pci/remove.c                  |    1 +
 drivers/pcmcia/yenta_socket.c         |   75 ------
 include/linux/ioport.h                |    8 +
 include/linux/pci.h                   |    6 +
 kernel/resource.c                     |  175 +++++++++++++-
 19 files changed, 613 insertions(+), 215 deletions(-)

-- 
1.7.7


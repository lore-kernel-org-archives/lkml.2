Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030204Ab2B1W3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:29:00 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:38199 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242Ab2B1W26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:28:58 -0500
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
Subject: [PATCH -v9 00/24] PCI: allocate pci bus num range for unassigned bridge busn
Date: Tue, 28 Feb 2012 14:07:19 -0800
Message-Id: <1330466863-28469-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F4D504E.0056,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

could be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc

need to apply to top of pci/for-linus plus pci/linux-next plus
        [PATCH -v2] PCI: pci_host_bridge related cleanup

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

Thanks

Yinghai

Yinghai Lu (24):
  x86, PCI: add print all root info for nocrs path
  x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node
  PCI: Add busn_res into struct pci_bus.
  PCI: Add busn_res operation functions
  PCI: release busn when removing bus
  PCI: insert busn_res in pci_create_root_bus
  PCI: checking busn_res in pci_scan_root_bus
  PCI: default busn_resource
  PCI: add default res for pci_scan_bus
  x86, PCI: put busn resource in pci_root_info for acpi path
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

 arch/ia64/include/asm/pci.h           |    1 +
 arch/ia64/pci/pci.c                   |    5 +
 arch/powerpc/include/asm/pci-bridge.h |    1 +
 arch/powerpc/kernel/pci-common.c      |   10 +-
 arch/sparc/kernel/pci.c               |    4 +
 arch/sparc/kernel/pci_impl.h          |    1 +
 arch/x86/pci/acpi.c                   |   17 +-
 arch/x86/pci/amd_bus.c                |    2 +-
 arch/x86/pci/broadcom_bus.c           |    4 +-
 arch/x86/pci/bus_numa.c               |   27 ++-
 arch/x86/pci/bus_numa.h               |    4 +-
 arch/x86/pci/common.c                 |   27 +--
 drivers/parisc/dino.c                 |    5 +
 drivers/parisc/lba_pci.c              |    3 +
 drivers/pci/hotplug/pciehp_pci.c      |   12 +-
 drivers/pci/probe.c                   |  458 +++++++++++++++++++++++++++------
 drivers/pci/remove.c                  |    1 +
 drivers/pcmcia/yenta_socket.c         |   75 ------
 include/linux/pci.h                   |    6 +
 19 files changed, 454 insertions(+), 209 deletions(-)

-- 
1.7.7


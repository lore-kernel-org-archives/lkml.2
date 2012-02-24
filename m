Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2BXKVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:21:22 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:31655 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab2BXKUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:20:43 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v7 0/23] PCI: allocate pci bus num range for unassigned bridge busn + pci rescan cleanup
Date: Fri, 24 Feb 2012 02:18:48 -0800
Message-Id: <1330078751-7299-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F476437.0074,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8a2fc18: PCI: clean up rescan_bus_bridge_resize
bf71259: PCI: make pci_rescan_bus_bridge_resize use pci_scan_bridge instead
e920668: PCI: Add pci_bus_add_single_device()
c61820d: PCI, sysfs: create rescan_bridge under /sys/.../pci/devices/... for pci bridges
52b414e: PCI, sys: Use device_type and attr_groups with pci dev
1dd3a1e: PCI, pciehp: Remove not needed bus number range checking
4ecfb5b: PCI: Double checking setting for bus register and bus struct.
938bc68: pcmcia: remove workaround for fixing pci parent bus subordinate
206c646: PCI: Seperate child bus scanning to two passes overall
883167f: PCI: kill pci_fixup_parent_subordinate_busnr()
a4c590e: PCI: Allocate bus range instead of use max blindly
13e322a: PCI: Strict checking of valid range for bridge
8a6af68: PCI: Probe safe range that we can use for unassigned bridge.
85f1fdd: PCI: Add pci_bus_extend/shrink_top()
d4c8a5e: PCI, parisc: Register busn_res for root buses
821fbcf: PCI, powerpc: Register busn_res for root buses
8b257c9: PCI, sparc: Register busn_res for root buses
8be529a: PCI, ia64: Register busn_res for root buses
136c1d8: PCI, x86: Register busn_res for root buses
fb89a01f: PCI: Add busn_res tracking in core
d919f95: PCI: Add busn_res operation functions
7bb98d3: PCI: Add busn_res into struct pci_bus.
8958703: x86, PCI: Merge pcibios_scan_root and pci_scan_bus_on_node

Set up iobusn_resource tree, and register bus number range to it.
Later when need to find bus range, will try to allocate from the tree

Need to test on arches other than x86. esp for ia64 and powerpc that support
  more than on peer root buses.

last five patches are rescan cleanup that make use busn alloc.

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

Thanks

Yinghai

 Documentation/ABI/testing/sysfs-bus-pci |   10 +
 arch/ia64/pci/pci.c                     |    2 +
 arch/powerpc/kernel/pci-common.c        |    7 +-
 arch/sparc/kernel/pci.c                 |    1 +
 arch/x86/include/asm/topology.h         |    3 +-
 arch/x86/pci/acpi.c                     |    8 +-
 arch/x86/pci/bus_numa.c                 |    8 +-
 arch/x86/pci/common.c                   |   37 +--
 drivers/parisc/dino.c                   |    2 +
 drivers/parisc/lba_pci.c                |    3 +
 drivers/pci/bus.c                       |   40 +++
 drivers/pci/hotplug/pciehp_pci.c        |   12 +-
 drivers/pci/pci-sysfs.c                 |   59 ++++-
 drivers/pci/pci.h                       |    1 +
 drivers/pci/probe.c                     |  441 +++++++++++++++++++++++++------
 drivers/pci/remove.c                    |    1 +
 drivers/pcmcia/yenta_socket.c           |   75 ------
 include/linux/pci.h                     |    5 +
 18 files changed, 509 insertions(+), 206 deletions(-)


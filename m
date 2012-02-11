Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2BKEHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 23:07:04 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26900 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab2BKEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 23:06:58 -0500
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
Subject: [PATCH -v6 0/22] PCI: allocate pci bus num range for unassigned bridge busn + pci rescan cleanup
Date: Fri, 10 Feb 2012 20:06:03 -0800
Message-Id: <1328933185-15154-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090207.4F35E959.00A0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c363f32: PCI: clean up rescan_bus_bridge_resize
6aa2709: PCI: make pci_rescan_bus_bridge_resize use pci_scan_bridge instead
37cde7d: PCI: Add pci_bus_add_single_device()
2491eb4: PCI, sysfs: create rescan_bridge under /sys/.../pci/devices/... for pci bridges
2e8ccf8: PCI, sys: Use device_type and attr_groups with pci dev
523106b: PCI, pciehp: Remove not needed bus number range checking
b93a078: PCI: Double checking setting for bus register and bus struct.
d7f3672: pcmcia: remove workaround for fixing pci parent bus subordinate
7fc60fb: PCI: Seperate child bus scanning to two passes overall
c180042: PCI: kill pci_fixup_parent_subordinate_busnr()
e6832b3: PCI: Allocate bus range instead of use max blindly
f4c45ff: PCI: Strict checking of valid range for bridge
d933847: PCI: Probe safe range that we can use for unassigned bridge.
00ca3b1: PCI: Add pci_bus_extend/shrink_top()
81f70bb: PCI, parisc: Register busn_res for root buses
a1e4606: PCI, powerpc: Register busn_res for root buses
c3fbb20: PCI, sparc: Register busn_res for root buses
56f1bb0: PCI, ia64: Register busn_res for root buses
25502fb: PCI, x86: Register busn_res for root buses
311e8e2: PCI: Add busn_res tracking in core
48bf7b6: PCI: Add busn_res operation functions
1431674: PCI: Add busn_res into struct pci_bus.

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

Thanks

Yinghai

 Documentation/ABI/testing/sysfs-bus-pci |   10 +
 arch/ia64/pci/pci.c                     |    2 +
 arch/powerpc/kernel/pci-common.c        |    7 +-
 arch/sparc/kernel/pci.c                 |    1 +
 arch/x86/include/asm/topology.h         |    3 +-
 arch/x86/pci/acpi.c                     |    8 +-
 arch/x86/pci/bus_numa.c                 |    8 +-
 arch/x86/pci/common.c                   |   11 +-
 drivers/parisc/dino.c                   |    2 +
 drivers/parisc/lba_pci.c                |    3 +
 drivers/pci/bus.c                       |   40 +++
 drivers/pci/hotplug/pciehp_pci.c        |   12 +-
 drivers/pci/pci-sysfs.c                 |   59 ++++-
 drivers/pci/pci.h                       |    1 +
 drivers/pci/probe.c                     |  460 +++++++++++++++++++++++++------
 drivers/pci/remove.c                    |    1 +
 drivers/pcmcia/yenta_socket.c           |   75 -----
 include/linux/pci.h                     |    9 +
 18 files changed, 525 insertions(+), 187 deletions(-)


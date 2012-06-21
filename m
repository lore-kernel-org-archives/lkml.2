Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2FUUYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183Ab2FUUYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:24:40 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 0/9] PCI: Add 'pci_fixup_final' quirks into hot-plug paths
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:24:15 -0600
Message-ID: <20120621202415.16865.6226.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI's final quirks (pci_fixup_final) are currently invoked by
pci_apply_final_quirk() which traverses the platform's list of PCI
devices.  The calling mechanism, and to some point the use of the device
list, limits the quirk invocations to a single instance during boot.  As
such, hot-plugable devices do not have their associated final quirks
called upon hot-plug events.

This series implements a interim solution to integrate pci_fixup_final
quirks into the various hot-plug event paths[1].

The series basis is
git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next


[1] I intended to come up with a single, uniform, solution that would
satisfy both the boot path and the various hot-plug event paths with
respect to final quirks.  From an architectural perspective, the proper
placement for the final quirks is somewhere just prior to when drivers can
probe and attach which would be the device_add path: pci_bus_add_devices
or pci_bus_add device.

I originally started with that approach but eventually realized that there
are issues with moving the quirks into the device_add path with respect to
booting.  Using the 'initcall_debug' boot command instrumentation, one
can see that moving the final quirks into the device_add path would cause
the quirks to be called substantially earlier during boot.  While there
may be additional issues, two that were especially concerning were that
the final quirks would be called *before* both 'pci_subsys_init' and
'pcibios_assign_resources'.

Calling the quirks prior to resource assignment seems fraught with
potential issues so I started looking into the various hot-plug paths and
quickly noticed asymmetry with respect to PCI device setup between the
boot path and the hot-plug paths.

Currently, the boot path scans the PCI devices, adds the devices, assigns
resources, and then call the final quirks whereas the hot-plug paths scan,
assign resources, and then add the devices which is better sequencing with
respect to the assignment of resources and the addition of devices (i.e.
resource assignment occurs *before* a driver can probe and attach).

All of this suggests that we should change PCI device setup in the boot
path to be more like hot-plug: scan, assign resources, (final fixups,)
then add.  While I think that is the correct approach, and something that
we should be addressing, it will require a lot of work.  So until that
occurs, this series should serve as a stop-gap solution for the interim.

When the boot path's PCI device setup is addressed we should end up with a
single, uniform, device_add based solution for applying final quirks
after:
  o  removing 'fs_initcall_sync(pci_apply_final_quirks);',
  o  removing the global variable 'pci_fixup_final_inited' and all
     of its usages,
  o  renaming, and moving, the 'pci_cache_line_size' related code
     currently embedded in 'pci_apply_final_quirks()'.
---

Myron Stowe (9):
      PCI: integrate 'pci_fixup_final' quirks into hot-plug paths
      PCI: move final fixup quirks from __init to __devinit
      x86/PCI: move final fixup quirks from __init to __devinit
      powerpc/PCI: move final fixup quirks from __init to __devinit
      parisc/PCI: move final fixup quirks from __init to __devinit
      MIPS/PCI: move final fixup quirks from __init to __devinit
      arm/PCI: move final fixup quirks from __init to __devinit
      PCI: release temporary reference in __nv_msi_ht_cap_quirk()
      PCI: Remove redundant debug output in pci_do_fixups


 arch/arm/mach-iop32x/n2100.c          |    2 +
 arch/mips/txx9/generic/pci.c          |    6 ++-
 arch/powerpc/platforms/powermac/pci.c |    2 +
 arch/x86/pci/fixup.c                  |    2 +
 drivers/parisc/superio.c              |    3 +-
 drivers/pci/bus.c                     |    4 ++
 drivers/pci/quirks.c                  |   61 +++++++++++++++++++++++----------
 7 files changed, 53 insertions(+), 27 deletions(-)

-- 

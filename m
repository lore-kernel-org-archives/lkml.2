Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab0LPRiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:38:21 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:15685 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab0LPRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:38:19 -0500
Subject: [PATCH 0/9] PCI: revert to allocating bottom-up, avoid E820 areas
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Thu, 16 Dec 2010 10:38:15 -0700
Message-ID: <20101216173614.8185.19462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is 2.6.37 material]

In 2.6.34 and later, we automatically use "pci=use_crs" on recent (2008 or
newer) machines, which means we assign PCI resources from the host bridge
windows described by ACPI _CRS.

In many cases, _CRS claims the windows are bigger than they really are, e.g.,
they may overlap system memory, ROM, or other ACPI devices.  

Linux allocates PCI memory bottom-up, ignores most ACPI devices, and does an
incomplete job of avoiding E820 reserved areas, which caused problems like
https://bugzilla.kernel.org/show_bug.cgi?id=16228 .

As far as I can tell, Windows deals with this situation by removing all ACPI
resources and allocating the remaining space top-down.

I tried to make Linux allocate top-down as well, but since we don't have a good
mechanism for avoiding the ACPI devices that clutter the top of memory, we
tripped over several of those, which resulted in these regressions:

    https://bugzilla.kernel.org/show_bug.cgi?id=23132 (Dell 1545)
    https://bugzilla.kernel.org/show_bug.cgi?id=23332 (HP nx6325)
    https://bugzilla.kernel.org/show_bug.cgi?id=23542 (HP 2530p)
    https://bugzilla.kernel.org/show_bug.cgi?id=23802 (PCI / TPM conflict)

So I think the best band-aid for now is to revert to bottom-up allocation
and do a better job of avoiding E820 reserved areas.  Obviously, it's not
complete because we could still trip over ACPI devices (as in 23802), but
that's a problem we've always had and it's not as likely if we go bottom-up.

Patches 1-5 of this series are straight reverts ("git revert -n") of these
patches which were merged in 2.6.37-rc1:

  82e3e76 PCI: fix pci_bus_alloc_resource() hang, prefer positive decode
  1af3c2e x86: allocate space within a region top-down
  dc9887d x86/PCI: allocate space from the end of a region, not the beginning
  b126b47 PCI: allocate bus resources from the top down
  e7f8567 resources: support allocating space within a region from the top down

Patches 6-9 add the ability to avoid E820 regions and the top 2MB below 4GB.
The last patch (avoid top 2MB) is not strictly necessary in that it doesn't
fix any current issues I'm aware of.

Bjorn
---

Bjorn Helgaas (9):
      Revert "PCI: fix pci_bus_alloc_resource() hang, prefer positive decode"
      Revert "x86: allocate space within a region top-down"
      Revert "x86/PCI: allocate space from the end of a region, not the beginning"
      Revert "PCI: allocate bus resources from the top down"
      Revert "resources: support allocating space within a region from the top down"
      resources: add arch hook for preventing allocation in reserved areas
      x86: avoid low BIOS area when allocating address space
      x86: avoid E820 regions when allocating address space
      x86: avoid high BIOS area when allocating address space


 Documentation/kernel-parameters.txt |    5 --
 arch/x86/include/asm/e820.h         |    3 +
 arch/x86/kernel/Makefile            |    1 
 arch/x86/kernel/resource.c          |   48 ++++++++++++++++
 arch/x86/kernel/setup.c             |    1 
 arch/x86/pci/i386.c                 |   18 ++----
 drivers/pci/bus.c                   |   81 ++-------------------------
 include/linux/ioport.h              |    2 -
 kernel/resource.c                   |  104 +++--------------------------------
 9 files changed, 73 insertions(+), 190 deletions(-)
 create mode 100644 arch/x86/kernel/resource.c

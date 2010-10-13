Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab0JMQPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:15:12 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24433 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0JMQPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:15:10 -0400
Subject: [PATCH v3 0/6] PCI: allocate space top-down, not bottom-up
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Oct 2010 10:15:05 -0600
Message-ID: <20101013161359.28476.6050.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This revision is to address two problems found by Horst H. von Brand while
    testing the v2 patches in Fedora:
      https://bugzilla.redhat.com/show_bug.cgi?id=637647 .
    On his machine, we don't use _CRS by default, and the BIOS left some bridge
    windows disabled.

    Problem 1: When we assigned space for the windows, we started at the top
    and allocated [mem 0xffffffffffe00000-0xffffffffffffffff], which is
    obviously useless because the CPU doesn't support physical addresses that
    large.

    Problem 2: Subsequent allocations failed because I made an error in
    find_resource().  We look for available space from [child->end + 1 to
    root->end], and if the last child ends exactly at 0xffffffffffffffff, we
    wrap around and start from zero.

    I made the top-down allocation conditional on ARCH_HAS_TOP_DOWN_ALLOC
    because problem #1 requires per-arch changes to fix.


When we move PCI devices, we currently allocate space bottom-up, i.e., we look
at PCI bus resources in the order we found them, we look at gaps between child
resources bottom-up, and we align the new space at the bottom of an available
region.

On x86, we move PCI devices more than we used to because we now pay attention
to the PCI host bridge windows from ACPI.  For example, when we find a device
that's outside all the known host bridge windows, we try to move it into a
window, and we look for space starting at the bottom.

Windows does similar device moves, but it looks for space top-down rather than
bottom-up.  Since most machines are better-tested with Windows than Linux, this
difference means that Linux is more likely to trip over BIOS bugs in the PCI
host bridge window descriptions than Windows is.

We've had several reports of Dell machines where the BIOS leaves the AHCI
controller outside the host bridge windows (BIOS bug #1), *and* the lowest
host bridge window includes an area that doesn't actually reach PCI (BIOS
bug #2).  The result is that Windows (which moves AHCI to the top of a window)
works fine, while Linux (which moves AHCI to the bottom, buggy, area) doesn't
work.

These patches change Linux to allocate space more like Windows does:

    1) The x86 pcibios_align_resource() will choose space from the
       end of an available area, not the beginning.

    2) In the generic allocate_resource() path, we'll look for space
       between existing children from the top, not from the bottom.

    3) When pci_bus_alloc_resource() looks for available space, it
       will start from the highest window, not the first one we found.

This series fixes a 2.6.34 regression that prevents many Dell Precision
workstations from booting:

    https://bugzilla.kernel.org/show_bug.cgi?id=16228

Changes from v2 to v3:
    - Updated iomem_resource.end to reflect the end of usable physical address
      space.  Otherwise, we might allocate right up to 0xffffffff_ffffffff,
      which isn't usable.
    - Make allocate_resource() change conditional on ARCH_HAS_TOP_DOWN_ALLOC.
      Without arch-specific changes like the above, it's too dangerous to
      make this change for everybody at once.
    - Fix 64-bit wraparound in find_resource().  If the last child happened
      to end at ~0, we computed the highest available space as [child->end + 1,
      root->end], which makes us think the available space started at 0,
      which makes us return space that may already be allocated.

Changes from v1 to v2:
    - Moved check for allocating before the available area from
      pcibios_align_resource() to find_resource().  Better to do it
      after the alignment callback is done, and make it generic.
    - Fixed pcibios_align_resource() alignment.  If we start from the
      end of the available area, we must align *downward*, not upward.
    - Fixed pcibios_align_resource() ISA alias avoidance.  Again, since
      the starting point is the end of the area, we must align downward
      when we avoid aliased areas.

---

Bjorn Helgaas (6):
      resources: ensure alignment callback doesn't allocate below available start
      resources: allocate space within a region from the top down
      PCI: allocate bus resources from the top down
      x86/PCI: allocate space from the end of a region, not the beginning
      x86: update iomem_resource end based on CPU physical address capabilities
      x86: allocate space within a region top-down


 arch/x86/include/asm/io.h |    1 +
 arch/x86/kernel/setup.c   |    1 +
 arch/x86/pci/i386.c       |   18 +++++++---
 drivers/pci/bus.c         |   53 +++++++++++++++++++++++++++---
 kernel/resource.c         |   80 ++++++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 140 insertions(+), 13 deletions(-)

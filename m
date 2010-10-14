Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0JNXS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:18:26 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16684 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0JNXSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:18:25 -0400
Subject: [PATCH v4 0/6] PCI: allocate space top-down, not bottom-up
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 14 Oct 2010 17:18:21 -0600
Message-ID: <20101014231804.536.62138.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    This revision is to address two problems found by Horst H. von Brand while
    testing the v2 patches in Fedora:
      https://bugzilla.redhat.com/show_bug.cgi?id=637647
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

    I made the top-down allocation conditional: an arch can select it at
    boot-time, and there's a kernel command line option to change it for
    debugging.


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

Changes from v3 to v4:
    - Use round_down() rather than adding ALIGN_DOWN().
    - Replace ARCH_HAS_TOP_DOWN_ALLOC #define with a boot-time architecture
      choice and add a "resource_alloc_from_bottom" command line option to
      revert to the old behavior (NOTE: this only affects allocate_resource(),
      not pcibios_align_resource() or pci_bus_alloc_resource()).
    - Fixed find_resource_from_top() again; it still didn't handle a child
      that ended at the parent's end correctly.

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
      resources: support allocating space within a region from the top down
      PCI: allocate bus resources from the top down
      x86/PCI: allocate space from the end of a region, not the beginning
      x86: update iomem_resource end based on CPU physical address capabilities
      x86: allocate space within a region top-down


 Documentation/kernel-parameters.txt |    5 ++
 arch/x86/kernel/setup.c             |    2 +
 arch/x86/pci/i386.c                 |   17 ++++--
 drivers/pci/bus.c                   |   53 +++++++++++++++++--
 include/linux/ioport.h              |    1 
 kernel/resource.c                   |   99 ++++++++++++++++++++++++++++++++++-
 6 files changed, 163 insertions(+), 14 deletions(-)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab1J1Vs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:48:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423Ab1J1VsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:48:23 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH -v2 00/16] PCI: Re-factor PCI's 'latency timer' setup
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Oct 2011 15:47:26 -0600
Message-ID: <20111028214726.20088.30551.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'latency timer' of PCI devices, both Type 0 and Type 1,
is setup in architecture-specific code [see: pcibios_set_master()].
There are two approaches being taken by all the architectures - check
if the 'latency timer' is currently set between 16 and 255 and if not
bring it within bounds, or, do nothing (and then there is the
gratuitously different parisc implementation).

There is nothing architecture-specific about PCI's 'latency timer' so
this patch pulls the setup functionality up into the PCI core by
creating a generic 'pcibios_set_master()' function using the '__weak'
attribute which can be used by all architectures as a default which,
if necessary, can then be over-ridden by architecture-specific code.


The series starts out by converting architecture-specific inlined
versions of 'pcibios_set_master()' - all of which are no-ops - into
non-inlined equivalents.  This is necessary to allow a subsequent
patch to create a generic version using the '__weak' attribute and is
done for the following architectures: arm, blackfin*, h8300*, ia64,
microblaze, powerpc, sparc, tile, unicore32, and xtensa.

Without the conversions, the compiler sees the architecture-
specific version, defined as a static inline function typically in
<asm/pci.h>, and will have no knowledge about the __weak version
once it is introduced, which leads to compile failures as in:
  drivers/pci/pci.c: 2605: error: redefinition of 'pcibios_set_master'
  arch/powerpc/include/asm/pci.h: 49: note: previous definition of
    'pcibios_set_master' was here

Next the generic 'pcibios_set_master()' function is introduced in
PCI's core.  With the generic 'pcibios_set_master()' function in place
the series removes the now redundant function from the following
architectures: frv, mips, mn10300, sh, and x86.

It would be nice to have all architectures follow suit and end up
using only the single, generic, 'pcibios_set_master()' function.

-v2:
 - In the original series I tried to not touch any of the architectures
   that were not going to end up using the generic 'pcibios_set_master()'
   function but this just created compile problems for those so I had to
   generate a number of pre-cursor patches to the series as noted above.
 - * blackfin and h8300 architectures do not seem to support PCI (no
   root bus scanning etc. exists within them) but they do have PCI header
   files.  I removed the inline definitions for each of these within
   the patch that introduces the generic 'pcibios_set_master()' function
   so that the __weak version would satisfy any necessary references.

I have only tested x86 although I was able to compile test powerpc in
addition this time.
---

Myron Stowe (16):
      PCI: latency timer doesn't apply to PCIe
      PCI: x86: use generic pcibios_set_master()
      PCI: sh: use generic pcibios_set_master()
      PCI: mn10300: use generic pcibios_set_master()
      PCI: MIPS: use generic pcibios_set_master()
      PCI: frv: use generic pcibios_set_master()
      PCI: Pull PCI 'latency timer' setup up into the core
      PCI: Xtensa: convert pcibios_set_master() to a non-inlined function
      PCI: UniCore: convert pcibios_set_master() to a non-inlined function
      PCI: TILE: convert pcibios_set_master() to a non-inlined function
      PCI: SPARC: convert pcibios_set_master() to a non-inlined function
      PCI: PowerPC: convert pcibios_set_master() to a non-inlined function
      PCI: MicroBlaze: convert pcibios_set_master() to a non-inlined function
      PCI: IA64: convert pcibios_set_master() to a non-inlined function
      PCI: ARM: convert pcibios_set_master() to a non-inlined function
      PCI: add declaration for pcibios_set_master() to pci core


 arch/arm/common/it8152.c                |    3 +++
 arch/arm/include/asm/pci.h              |   12 -----------
 arch/arm/kernel/bios32.c                |    7 +++++++
 arch/blackfin/include/asm/pci.h         |    4 ----
 arch/frv/mb93090-mb00/pci-frv.c         |   20 -------------------
 arch/frv/mb93090-mb00/pci-frv.h         |    2 --
 arch/h8300/include/asm/pci.h            |    5 -----
 arch/ia64/include/asm/pci.h             |    6 ------
 arch/ia64/pci/pci.c                     |    5 +++++
 arch/microblaze/include/asm/pci.h       |    5 -----
 arch/microblaze/pci/pci-common.c        |    5 +++++
 arch/mips/pci/pci.c                     |   21 --------------------
 arch/mn10300/unit-asb2305/pci-asb2305.c |   22 ---------------------
 arch/mn10300/unit-asb2305/pci-asb2305.h |    2 --
 arch/powerpc/include/asm/pci.h          |    5 -----
 arch/powerpc/kernel/pci-common.c        |    5 +++++
 arch/sh/drivers/pci/pci.c               |   21 --------------------
 arch/sparc/include/asm/pci_32.h         |    5 -----
 arch/sparc/include/asm/pci_64.h         |    5 -----
 arch/sparc/kernel/pci.c                 |    5 +++++
 arch/tile/include/asm/pci.h             |    7 -------
 arch/tile/kernel/pci.c                  |    5 +++++
 arch/unicore32/include/asm/pci.h        |    5 -----
 arch/unicore32/kernel/pci.c             |    5 +++++
 arch/x86/include/asm/pci_x86.h          |    2 --
 arch/x86/pci/i386.c                     |   20 -------------------
 arch/xtensa/include/asm/pci.h           |    5 -----
 arch/xtensa/kernel/pci.c                |    5 +++++
 drivers/pci/pci.c                       |   33 +++++++++++++++++++++++++++++++
 include/linux/pci.h                     |    5 +++++
 30 files changed, 83 insertions(+), 174 deletions(-)

-- 

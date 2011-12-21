Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1LUQ1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 11:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab1LUQ1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 11:27:07 -0500
Date: Wed, 21 Dec 2011 18:29:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 RFC (repost) 00/16] pci: use generic pci_iomap on all
 architectures
Message-ID: <cover.1324484752.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reposting combines the latest version of the patches.
As this is just a repost, separate versions was already sent to
maintainers, I cut down the To list to just lkml and linux-arch.

This patchset has been on linux-next for several weeks now.
I intend to send pull request to Linus come 3.3 merge window:
They touch a lot of arches and have interdependencies, so merging
separately seems to make sense.

As Jesse Barnes noted: the PCI changes look nice (pulling
all that duplicated code out looks good), though it would be good to
get a few more arch maintainer acks/tested-bys for this.

The patchset is available from my tree:
git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git linux-next
or from linux-next.

Many architectures don't want to pull in iomap.c,
so they ended up duplicating pci_iomap from that file.
That function isn't trivial, and we are going to modify it
https://lkml.org/lkml/2011/11/14/183
so the duplication hurts.

This reduces the scope of the problem significantly,
by moving pci_iomap to a separate file and
referencing that from all architectures.

Tested on x86, build tested on alpha, mips64 and powerpc64.

-- 
1.7.5.53.gc233e


Michael S. Tsirkin (16):
  lib: move GENERIC_IOMAP to lib/Kconfig
  lib: add GENERIC_PCI_IOMAP
  alpha: switch to GENERIC_PCI_IOMAP
  arm: switch to GENERIC_PCI_IOMAP
  microblaze: switch to GENERIC_PCI_IOMAP
  mips: switch to GENERIC_PCI_IOMAP
  parisc: switch to GENERIC_PCI_IOMAP
  powerpc: switch to GENERIC_PCI_IOMAP
  sh: switch to GENERIC_PCI_IOMAP
  sparc: switch to GENERIC_PCI_IOMAP
  tile: don't panic on iomap
  tile: switch to GENERIC_PCI_IOMAP
  frv: switch to GENERIC_PCI_IOMAP
  mn10300: add missing __iomap markers
  mn10300: switch to GENERIC_PCI_IOMAP
  alpha: drop pci_iomap/pci_iounmap from pci-noop.c

 arch/alpha/Kconfig                    |    5 +---
 arch/alpha/kernel/pci-noop.c          |   12 --------
 arch/alpha/kernel/pci.c               |   26 +-----------------
 arch/arm/Kconfig                      |    1 +
 arch/arm/include/asm/io.h             |    2 +-
 arch/arm/mm/iomap.c                   |   21 --------------
 arch/cris/Kconfig                     |    5 +---
 arch/frv/Kconfig                      |    1 +
 arch/frv/include/asm/io.h             |    2 +-
 arch/frv/mb93090-mb00/Makefile        |    2 +-
 arch/frv/mb93090-mb00/pci-iomap.c     |   29 --------------------
 arch/hexagon/Kconfig                  |    4 +--
 arch/ia64/Kconfig                     |    5 +---
 arch/m68k/Kconfig                     |    4 +--
 arch/microblaze/Kconfig               |    1 +
 arch/microblaze/pci/iomap.c           |   19 -------------
 arch/mips/Kconfig                     |    1 +
 arch/mips/lib/iomap-pci.c             |   26 ------------------
 arch/mn10300/Kconfig                  |    1 +
 arch/mn10300/include/asm/io.h         |   17 +++++------
 arch/mn10300/unit-asb2305/Makefile    |    2 +-
 arch/mn10300/unit-asb2305/pci-iomap.c |   31 ---------------------
 arch/openrisc/Kconfig                 |    3 --
 arch/parisc/Kconfig                   |    1 +
 arch/parisc/lib/iomap.c               |   23 ---------------
 arch/powerpc/Kconfig                  |    1 +
 arch/powerpc/kernel/iomap.c           |   19 -------------
 arch/powerpc/platforms/Kconfig        |    3 --
 arch/score/Kconfig                    |    4 +--
 arch/sh/Kconfig                       |    4 +--
 arch/sh/drivers/pci/pci.c             |   23 ---------------
 arch/sparc/Kconfig                    |    1 +
 arch/sparc/include/asm/io_32.h        |    2 +-
 arch/sparc/include/asm/io_64.h        |    2 +-
 arch/sparc/lib/iomap.c                |   23 ---------------
 arch/tile/Kconfig                     |    1 +
 arch/tile/include/asm/io.h            |    3 +-
 arch/tile/include/asm/pci.h           |    2 +-
 arch/tile/kernel/pci.c                |   21 --------------
 arch/unicore32/Kconfig                |    4 +--
 arch/x86/Kconfig                      |    4 +--
 include/asm-generic/io.h              |    4 +-
 include/asm-generic/iomap.h           |    9 ++----
 include/asm-generic/pci_iomap.h       |   25 +++++++++++++++++
 lib/Kconfig                           |    7 +++++
 lib/Makefile                          |    1 +
 lib/iomap.c                           |   38 +------------------------
 lib/pci_iomap.c                       |   48 +++++++++++++++++++++++++++++++++
 48 files changed, 124 insertions(+), 369 deletions(-)
 delete mode 100644 arch/frv/mb93090-mb00/pci-iomap.c
 delete mode 100644 arch/mn10300/unit-asb2305/pci-iomap.c
 create mode 100644 include/asm-generic/pci_iomap.h
 create mode 100644 lib/pci_iomap.c

-- 
1.7.8.382.g3daff

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1AVNNV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 08:13:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52422 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab1AVNNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 08:13:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=gWFXuIVu/lInEoNIgKxIbhWJTyNt4tb7j0/dYglcVgC0LfBhtOL/ZWeWSU0YdRNhfe
         Wo5W/N4K6LFW25t4cINPULV6XkNVXfFOl53iTNLodMkS8Jpa0roWM6VMzB9ac/IzUZ1V
         Glbr5SBEPOilJL2sFfUZI7cKmORVpbXcTyQwE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v5 00/27] Introduce little-endian bitops
Date: Sat, 22 Jan 2011 22:13:32 +0900
Message-Id: <1295702039-23186-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:

 * v5
 - change the prototypes and casts in the macro to take any pointer types
 - remove casts to "unsigned long *" due to le-bitops prototype change
 - fix a bisection hole for kvm and rds on some architectures
 - drop Acked-by lines from some patches that got enough changes

 * v4
 - change to the post-fix notation as suggested by Linus
   (e.g. s/test_le_bit/test_bit_le/)
 - introduce CONFIG_GENERIC_FIND_BIT_LE
 - fix m68knommu build
 - fix inefficienct find_first_zero_le_bit()

 * v3
 - add Acked-by: lines

 * v2
(cover letter for v2 was not delivered to any mailing lists I've CCed may be
due to Too many recipients to the message)
 - fix argument of test_and_{set,clear}_le_bit() for s390, arm, m68k
 - move ext2 bitops to fs/ext2/ext2.h, not include/linux/ext2_fs.h
 - fix m68k minix bitops incorrect conversion noticed by Andreas Schwab
 - rewrite minix bitops removal patch based on the suggestion by Arnd

This patch series introduces little-endian bit operations in asm/bitops.h
for all architectures and converts all ext2 non-atomic and minix bit
operations to use little-endian bit operations.  It enables us to remove
ext2 non-atomic and minix bit operations from asm/bitops.h.  The reason
they should be removed from asm/bitops.h is as follows:

For ext2 non-atomic bit operations, they are used for little-endian byte
order bitmap access by some filesystems and modules.  But using ext2_*()
functions on a module other than ext2 filesystem makes some feel strange.

For minix bit operations, they are only used by minix filesystem and are
useless by other modules.  Because byte order of inode and block bitmap is
different on each architecture.

The little-endian bitops patch series for this version is available in
the git branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v5

Akinobu Mita (27):
  kvm: stop including asm-generic/bitops/le.h directly
  rds: stop including asm-generic/bitops/le.h directly
  bitops: merge little and big endian definisions in
    asm-generic/bitops/le.h
  asm-generic: rename generic little-endian bitops functions
  asm-generic: change little-endian bitops to take any pointer types
  powerpc: introduce little-endian bitops
  s390: introduce little-endian bitops
  arm: introduce little-endian bitops
  m68k: introduce little-endian bitops
  bitops: introduce CONFIG_GENERIC_FIND_BIT_LE
  m68knommu: introduce little-endian bitops
  bitops: introduce little-endian bitops for most architectures
  asm-generic: use little-endian bitops
  kvm: use little-endian bitops
  rds: use little-endian bitops
  ext3: use little-endian bitops
  ext4: use little-endian bitops
  ocfs2: use little-endian bitops
  nilfs2: use little-endian bitops
  reiserfs: use little-endian bitops
  udf: use little-endian bitops
  ufs: use little-endian bitops
  md: use little-endian bitops
  dm: use little-endian bitops
  bitops: remove ext2 non-atomic bitops from asm/bitops.h
  m68k: remove inline asm from minix_find_first_zero_bit
  bitops: remove minix bitops from asm/bitops.h

 arch/alpha/include/asm/bitops.h              |    4 +-
 arch/arm/include/asm/bitops.h                |   52 +++++-------
 arch/avr32/include/asm/bitops.h              |    3 +-
 arch/avr32/kernel/avr32_ksyms.c              |    4 +-
 arch/avr32/lib/findbit.S                     |    4 +-
 arch/blackfin/include/asm/bitops.h           |    3 +-
 arch/cris/include/asm/bitops.h               |    3 +-
 arch/frv/Kconfig                             |    4 +
 arch/frv/include/asm/bitops.h                |    4 +-
 arch/h8300/Kconfig                           |    4 +
 arch/h8300/include/asm/bitops.h              |    3 +-
 arch/ia64/include/asm/bitops.h               |    3 +-
 arch/m32r/Kconfig                            |    4 +
 arch/m32r/include/asm/bitops.h               |    3 +-
 arch/m68k/include/asm/bitops_mm.h            |  107 +++++++++++---------------
 arch/m68k/include/asm/bitops_no.h            |   28 ++++---
 arch/microblaze/Kconfig                      |    3 +
 arch/mips/Kconfig                            |    4 +
 arch/mips/include/asm/bitops.h               |    3 +-
 arch/mn10300/include/asm/bitops.h            |    3 +-
 arch/parisc/Kconfig                          |    4 +
 arch/parisc/include/asm/bitops.h             |    4 +-
 arch/powerpc/Kconfig                         |    4 +
 arch/powerpc/include/asm/bitops.h            |   67 +++++-----------
 arch/s390/include/asm/bitops.h               |   45 ++++++-----
 arch/sh/Kconfig                              |    3 +
 arch/sh/include/asm/bitops.h                 |    3 +-
 arch/sparc/Kconfig                           |    4 +
 arch/sparc/include/asm/bitops_32.h           |    3 +-
 arch/sparc/include/asm/bitops_64.h           |    4 +-
 arch/tile/include/asm/bitops.h               |    3 +-
 arch/x86/include/asm/bitops.h                |    4 +-
 arch/xtensa/Kconfig                          |    3 +
 arch/xtensa/include/asm/bitops.h             |    3 +-
 drivers/md/bitmap.c                          |    6 +-
 drivers/md/dm-log.c                          |    8 +-
 fs/ext2/ext2.h                               |    6 ++
 fs/ext4/ext4.h                               |   12 ++--
 fs/minix/Kconfig                             |    8 ++
 fs/minix/minix.h                             |   74 ++++++++++++++++++
 fs/nilfs2/alloc.h                            |    2 +-
 fs/ocfs2/ocfs2.h                             |   10 +-
 fs/udf/balloc.c                              |    9 +-
 fs/ufs/util.h                                |    2 +-
 include/asm-generic/bitops.h                 |    3 +-
 include/asm-generic/bitops/ext2-atomic.h     |    4 +-
 include/asm-generic/bitops/ext2-non-atomic.h |   20 -----
 include/asm-generic/bitops/le.h              |   64 +++++++---------
 include/asm-generic/bitops/minix-le.h        |   17 ----
 include/asm-generic/bitops/minix.h           |   15 ----
 include/linux/ext3_fs.h                      |   10 +-
 include/linux/reiserfs_fs.h                  |   27 +++----
 lib/Kconfig                                  |    3 +
 lib/Makefile                                 |    1 +
 lib/find_next_bit.c                          |   18 +++--
 net/rds/cong.c                               |    9 +-
 virt/kvm/kvm_main.c                          |    3 +-
 57 files changed, 369 insertions(+), 362 deletions(-)
 delete mode 100644 include/asm-generic/bitops/ext2-non-atomic.h
 delete mode 100644 include/asm-generic/bitops/minix-le.h
 delete mode 100644 include/asm-generic/bitops/minix.h

-- 
1.7.3.4


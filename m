Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1APNIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 08:08:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48314 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1APNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 08:08:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EdpJWN48N6M2WqwfjOWgBsCP/g4GlJFQMPQ7Rk6hcO4R+mz55mHNDJLW1imhq5PtNQ
         JcKWZWopDdLURJo9+H3zFdiLEznfoMODELjsHmkXMb6ePnigBvlOCGle8vbuAUZPb6YP
         kQ5Jd2T30UOuHGZs6Cz+otRgs1mjWO6znJr2o=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 00/24] Introduce little endian bitops
Date: Sun, 16 Jan 2011 22:08:29 +0900
Message-Id: <1295183333-13802-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The little-endian bitops patch series version 4 is available in the git
repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/mita/linux-2.6.git le-bitops-v4

Linus found the little-endian bitops patch series annoying for two reasons:

> - The naming.
>
>   Hiding that "little-endian" part in the middle of the name is just odd. 

This problem is fixed by changing to the post-fix notation
(e.g. s/test_le_bit/test_bit_le/)

>  - The change of prototype. This is replacing a function that just took a 
>    "void *" or something like that, but it replaces it with something that 
>    takes a "unsigned long *". Resulting in a patch like this:
> 
> > --- a/include/linux/ext3_fs.h~ext3-use-little-endian-bitops
> > +++ a/include/linux/ext3_fs.h
> > @@ -418,13 +418,18 @@ struct ext3_inode {
> >  #define EXT2_MOUNT_DATA_FLAGS		EXT3_MOUNT_DATA_FLAGS
> >  #endif
> >  
> > -#define ext3_set_bit			ext2_set_bit
> > +#define ext3_set_bit(nr, addr)	\
> > +	__test_and_set_le_bit((nr), (unsigned long *)(addr))
> 
> Where for the life of me I can't say that I think the new code is better 
> than the old code. Quite the reverse.

This problem is not touched.

ext2_set_bit and other ext2_*_bit functions took a "void *", but
they implicitly need a long aligned address.
Because almost all architectures defined them as

#define ext2_set_bit(nr, addr) \
       __test_and_set_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)

The little-endian bitops takes a "unsigned long *" because
it can ensure the correct result only for a long aligned address.
It is better than ext2 bitops which takes a "void *" but it can't
ensure the correct result for an unaligned address.

So the explicit cast is better than no cast that implicitly needs
aligned address.

Adding new bitops like *_bit_le_unaligned(int nr, void *addr) may be
usefull.  But using such bitops here introduces unwanted overhead.

Changelog:

 * v4
 - change to the post-fix notation e.g. s/test_le_bit/test_bit_le/
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
The other problem is that they take a "void *" but implicitly need a long
aligned address.

For minix bit operations, they are only used by minix filesystem and are
useless by other modules.  Because byte order of inode and block bitmap is
different on each architecture.

Akinobu Mita (24):
  bitops: merge little and big endian definisions in
    asm-generic/bitops/le.h
  asm-generic: rename generic little-endian bitops functions
  powerpc: introduce little-endian bitops
  s390: introduce little-endian bitops
  arm: introduce little-endian bitops
  m68k: introduce little-endian bitops
  bitops: introduce CONFIG_GENERIC_FIND_BIT_LE
  m68knommu: introduce little-endian bitops
  bitops: introduce little-endian bitops for most architectures
  rds: stop including asm-generic/bitops/le.h
  kvm: stop including asm-generic/bitops/le.h
  asm-generic: use little-endian bitops
  ext3: use little-endian bitops
  ext4: use little-endian bitops
  ocfs2: use little-endian bitops
  nilfs2: use little-endian bitops
  reiserfs: use little-endian bitops
  udf: use little-endian bitops
  ufs: use little-endian bitops
  md: use little-endian bit operations
  dm: use little-endian bit operations
  bitops: remove ext2 non-atomic bitops from asm/bitops.h
  m68k: remove inline asm from minix_find_first_zero_bit
  bitops: remove minix bitops from asm/bitops.h

 arch/alpha/include/asm/bitops.h              |    4 +-
 arch/arm/include/asm/bitops.h                |   50 ++++++--------
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
 arch/m68k/include/asm/bitops_mm.h            |   89 ++++++++++----------------
 arch/m68k/include/asm/bitops_no.h            |   28 +++++----
 arch/microblaze/Kconfig                      |    3 +
 arch/mips/Kconfig                            |    4 +
 arch/mips/include/asm/bitops.h               |    3 +-
 arch/mn10300/include/asm/bitops.h            |    3 +-
 arch/parisc/Kconfig                          |    4 +
 arch/parisc/include/asm/bitops.h             |    4 +-
 arch/powerpc/Kconfig                         |    4 +
 arch/powerpc/include/asm/bitops.h            |   53 ++++------------
 arch/s390/include/asm/bitops.h               |   45 ++++++++------
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
 fs/ext2/ext2.h                               |   11 +++
 fs/ext4/ext4.h                               |   18 ++++--
 fs/minix/Kconfig                             |    8 ++
 fs/minix/minix.h                             |   79 +++++++++++++++++++++++
 fs/nilfs2/alloc.h                            |    3 +-
 fs/ocfs2/ocfs2.h                             |   13 ++--
 fs/udf/balloc.c                              |   11 ++-
 fs/ufs/util.h                                |    2 +-
 include/asm-generic/bitops.h                 |    3 +-
 include/asm-generic/bitops/ext2-atomic.h     |    4 +-
 include/asm-generic/bitops/ext2-non-atomic.h |   20 ------
 include/asm-generic/bitops/le.h              |   60 ++++++++----------
 include/asm-generic/bitops/minix-le.h        |   17 -----
 include/asm-generic/bitops/minix.h           |   15 ----
 include/linux/ext3_fs.h                      |   15 +++--
 include/linux/reiserfs_fs.h                  |   34 ++++++----
 lib/Kconfig                                  |    3 +
 lib/Makefile                                 |    1 +
 lib/find_next_bit.c                          |   12 ++--
 net/rds/cong.c                               |    8 +--
 virt/kvm/kvm_main.c                          |    3 +-
 57 files changed, 378 insertions(+), 342 deletions(-)
 delete mode 100644 include/asm-generic/bitops/ext2-non-atomic.h
 delete mode 100644 include/asm-generic/bitops/minix-le.h
 delete mode 100644 include/asm-generic/bitops/minix.h

-- 
1.7.3.4


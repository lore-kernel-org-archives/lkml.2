Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0KWNig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:38:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39323 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0KWNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:38:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aTYvVIxHAlQdGy3LRhYetmVyaC7wwz97PUJ5COniyxo/FRvyaS/6i1VDlVB1+USDCf
         kuwmmYAK8SqhX07RbcKWOvQfn6MC2FOEP/H7vCanX8on1Xiu3KvC94w9imFC4lwOQjua
         4el+ra2xX0oiaoiVYp+/qJ38xbCQQFp79NPso=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 00/22] Introduce little endian bitops
Date: Tue, 23 Nov 2010 22:38:02 +0900
Message-Id: <1290519504-3958-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please consider to include this patch series into -mm.

Changelog:

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
for all architectures and converts all ext2 non-atomic and minix bit operations
to use little-endian bit operations. it enables to remove ext2 non-atomic and
minix bit operations from asm/bitops.h. The reason they should be removed
from asm/bitops.h is as follows:

For ext2 non-atomic bit operations, they are used for little-endian byte order
bitmap access by some filesystems and modules. But using ext2_*() functions on
a module other than ext2 filesystem makes someone feel strange.

For minix bit operations, they are only used by minix filesystem and useless
by other modules. Because byte order of inode and block bitmap is defferent
on each architecture.


Akinobu Mita (22):
  bitops: merge little and big endian definisions in
    asm-generic/bitops/le.h
  bitops: rename generic little-endian bitops functions
  s390: introduce little-endian bitops
  arm: introduce little-endian bitops
  m68k: introduce little-endian bitops
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
 arch/frv/include/asm/bitops.h                |    4 +-
 arch/h8300/include/asm/bitops.h              |    3 +-
 arch/ia64/include/asm/bitops.h               |    3 +-
 arch/m32r/include/asm/bitops.h               |    3 +-
 arch/m68k/include/asm/bitops_mm.h            |   89 ++++++++++----------------
 arch/m68k/include/asm/bitops_no.h            |   28 +++++----
 arch/mips/include/asm/bitops.h               |    3 +-
 arch/mn10300/include/asm/bitops.h            |    3 +-
 arch/parisc/include/asm/bitops.h             |    4 +-
 arch/powerpc/include/asm/bitops.h            |   35 +---------
 arch/s390/include/asm/bitops.h               |   45 ++++++++------
 arch/sh/include/asm/bitops.h                 |    3 +-
 arch/sparc/include/asm/bitops_32.h           |    3 +-
 arch/sparc/include/asm/bitops_64.h           |    4 +-
 arch/tile/include/asm/bitops.h               |    3 +-
 arch/x86/include/asm/bitops.h                |    4 +-
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
 include/asm-generic/bitops/le.h              |   56 +++++++---------
 include/asm-generic/bitops/minix-le.h        |   17 -----
 include/asm-generic/bitops/minix.h           |   15 ----
 include/linux/ext3_fs.h                      |   15 +++--
 include/linux/reiserfs_fs.h                  |   34 ++++++----
 lib/find_next_bit.c                          |    9 +--
 net/rds/cong.c                               |    8 +--
 virt/kvm/kvm_main.c                          |    3 +-
 45 files changed, 322 insertions(+), 332 deletions(-)
 delete mode 100644 include/asm-generic/bitops/ext2-non-atomic.h
 delete mode 100644 include/asm-generic/bitops/minix-le.h
 delete mode 100644 include/asm-generic/bitops/minix.h

-- 
1.7.3.2


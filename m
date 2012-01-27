Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2A0CpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:45:08 -0500
Received: from mail.windriver.com ([147.11.1.11]:53771 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab2A0CpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:45:02 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [RFC - PATCH 0/7] consolidation of BUG support code.
Date: Thu, 26 Jan 2012 21:44:25 -0500
Message-Id: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changes shown here are to unify linux's BUG support under
the one <linux/bug.h> file.  Due to historical reasons, we have
some BUG code in bug.h and some in kernel.h -- i.e. the support for
BUILD_BUG in linux/kernel.h predates the addition of linux/bug.h,
but old code in kernel.h wasn't moved to bug.h at that time.  As
a band-aid, kernel.h was including <asm/bug.h> to pseudo link them.

This has caused confusion[1] and general yuck/WTF[2] reactions.
Here is an example that violates the principle of least surprise:

      CC      lib/string.o
      lib/string.c: In function 'strlcat':
      lib/string.c:225:2: error: implicit declaration of function 'BUILD_BUG_ON'
      make[2]: *** [lib/string.o] Error 1
      $
      $ grep linux/bug.h lib/string.c
      #include <linux/bug.h>
      $

We've included <linux/bug.h> for the BUG infrastructure and yet we
still get a compile fail!  [We've not kernel.h for BUILD_BUG_ON.]
Ugh - very confusing for someone who is new to kernel development.

With the above in mind, the goals of this changeset are:

1) find and fix any include/*.h files that were relying on the
   implicit presence of BUG code.
2) find and fix any C files that were consuming kernel.h and
   hence relying on implicitly getting some/all BUG code.
3) Move the BUG related code living in kernel.h to <linux/bug.h>
4) remove the asm/bug.h from kernel.h to finally break the chain.

During development, the order was more like 3-4, build-test, 1-2.
But to ensure that git history for bisect doesn't get needless
build failures introduced, the commits have been reorderd to fix
the problem areas in advance.

With respect to #1 -- I was wanting to avoid putting bug.h into
high usage header files.  So you will see processor.h and the
spinlock.h getting special treatment.  Others who might(?) be
considered high usage and hence maybe needing special treatment
are called out via a cmdline filter in the commit message.

Unlike the module.h cleanup[3], I've made no attempt to separate
the changes along maintainer/arch lines -- I'm assuming that if
this seems OK to folks, then it will be pulled all at once.  The
separation I did for module.h was costly and not really required.

Testing so far has been on i386, x86-64, mips, arm, powerpc,
alpha, sparc, ...    If nobody has any fundamental problems
with the underlying concept here, I'd like to put it into the
linux-next pool for 3.4 sometime soon.

Thanks,
Paul

[1] https://lkml.org/lkml/2012/1/3/90
[2] https://lkml.org/lkml/2012/1/17/414
[3] http://lwn.net/Articles/453517/

---

Paul Gortmaker (7):
  x86: relocate get/set debugreg fcns to include/asm/debugreg.
  spinlock: macroize assert_spin_locked to avoid bug.h dependency
  lib: fix implicit users of kernel.h for TAINT_WARN
  bug.h: add include of it to various implicit C users
  BUG: headers with BUG/BUG_ON etc. need linux/bug.h
  bug: consolidate BUILD_BUG_ON with other bug code
  kernel.h: doesn't explicitly use bug.h, so don't include it.

 arch/arm/mach-ux500/board-mop500-pins.c         |    1 +
 arch/mips/fw/arc/cmdline.c                      |    1 +
 arch/mips/fw/arc/identify.c                     |    1 +
 arch/powerpc/kernel/pmc.c                       |    1 +
 arch/powerpc/xmon/ppc-opc.c                     |    1 +
 arch/powerpc/xmon/spu-opc.c                     |    1 +
 arch/x86/include/asm/debugreg.h                 |   67 +++++++++++++++++++++++
 arch/x86/include/asm/paravirt.h                 |    1 +
 arch/x86/include/asm/processor.h                |   63 ---------------------
 arch/x86/kernel/cpu/common.c                    |    1 +
 arch/x86/kernel/paravirt.c                      |    1 +
 arch/x86/mm/kmemcheck/selftest.c                |    1 +
 drivers/gpu/drm/radeon/cayman_blit_shaders.c    |    1 +
 drivers/gpu/drm/radeon/evergreen_blit_shaders.c |    1 +
 drivers/gpu/drm/radeon/r600_blit_shaders.c      |    1 +
 include/asm-generic/dma-mapping-common.h        |    1 +
 include/asm-generic/pgtable.h                   |    1 +
 include/asm-generic/tlbflush.h                  |    2 +
 include/drm/ttm/ttm_memory.h                    |    1 +
 include/linux/atmdev.h                          |    1 +
 include/linux/bio.h                             |    1 +
 include/linux/bit_spinlock.h                    |    1 +
 include/linux/bug.h                             |   61 +++++++++++++++++++++
 include/linux/ceph/decode.h                     |    3 +-
 include/linux/ceph/libceph.h                    |    1 +
 include/linux/ceph/mdsmap.h                     |    1 +
 include/linux/cpumask.h                         |    1 +
 include/linux/crypto.h                          |    1 +
 include/linux/debug_locks.h                     |    1 +
 include/linux/dmaengine.h                       |    1 +
 include/linux/elfcore.h                         |    1 +
 include/linux/ext3_fs.h                         |    1 +
 include/linux/fs.h                              |    1 +
 include/linux/fsnotify.h                        |    1 +
 include/linux/gpio.h                            |    1 +
 include/linux/highmem.h                         |    1 +
 include/linux/i2o.h                             |    1 +
 include/linux/if_vlan.h                         |    1 +
 include/linux/io-mapping.h                      |    1 +
 include/linux/kernel.h                          |   62 ---------------------
 include/linux/kprobes.h                         |    1 +
 include/linux/kvm_host.h                        |    1 +
 include/linux/memory_hotplug.h                  |    1 +
 include/linux/mm.h                              |    1 +
 include/linux/mtd/cfi.h                         |    1 +
 include/linux/netdevice.h                       |    1 +
 include/linux/nilfs2_fs.h                       |    1 +
 include/linux/page-flags.h                      |    1 +
 include/linux/pid_namespace.h                   |    1 +
 include/linux/posix_acl.h                       |    1 +
 include/linux/ptrace.h                          |    1 +
 include/linux/radix-tree.h                      |    1 +
 include/linux/rcupdate.h                        |    1 +
 include/linux/regset.h                          |    1 +
 include/linux/reiserfs_fs.h                     |    1 +
 include/linux/relay.h                           |    1 +
 include/linux/scatterlist.h                     |    6 ++-
 include/linux/seq_file.h                        |    1 +
 include/linux/skbuff.h                          |    1 +
 include/linux/slub_def.h                        |    1 +
 include/linux/spinlock.h                        |    5 +--
 include/linux/ssb/ssb_driver_gige.h             |    1 +
 include/linux/swapops.h                         |    1 +
 include/linux/syscalls.h                        |    1 +
 include/linux/transport_class.h                 |    1 +
 include/linux/virtio_config.h                   |    1 +
 include/net/cfg80211.h                          |    1 +
 include/net/dst.h                               |    1 +
 include/net/ip_vs.h                             |    1 +
 include/net/mac80211.h                          |    1 +
 include/net/netns/generic.h                     |    1 +
 include/net/red.h                               |    1 +
 include/net/tcp.h                               |    1 +
 include/net/timewait_sock.h                     |    1 +
 include/net/udp.h                               |    1 +
 include/net/wpan-phy.h                          |    1 +
 include/scsi/osd_ore.h                          |    1 +
 include/scsi/scsi_transport.h                   |    1 +
 lib/average.c                                   |    1 +
 lib/bitmap.c                                    |    1 +
 lib/iommu-helper.c                              |    1 +
 lib/list_debug.c                                |    2 +
 lib/plist.c                                     |    1 +
 lib/string.c                                    |    1 +
 lib/timerqueue.c                                |    1 +
 85 files changed, 215 insertions(+), 132 deletions(-)

-- 
1.7.7.2


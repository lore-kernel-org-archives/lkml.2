Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2CXQgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:36:06 -0400
Received: from mail1.windriver.com ([147.11.146.13]:43097 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2CXQgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:36:04 -0400
Date: Sat, 24 Mar 2012 12:35:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL #1] bug.h code relocation out of kernel.h
Message-ID: <20120324163557.GA5573@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the 1st of three cleanups I have for 3.4 content.
For all three, I've put the text describing the change in
the signed tag, so it is shown in the pull request.

All three have been tested extensively with a wide variety
of arch and config selections.  Builds were done on both their
original baseline and in linux-next.

None of them are anywhere nearly as large as export.h change
was, so I didn't see any value in waiting to the very end of
the merge window before sending them along.

Not that I expect you'll have a need for it, but I did a test merge
of my cleanup trees on yesterday's top of tree so I could do one
last allmodconfig sanity build test.

http://git.kernel.org/?p=linux/kernel/git/paulg/linux.git;a=shortlog;h=refs/heads/paulg-merge-test

For this 1st of 3, I know you will get one conflict with Al's vfs tree:

    commit f466c6fdb3b1f043ff1977a8d2a1d0cd4dc164fa
    "move private bits of reiserfs_fs.h to fs/reiserfs/reiserfs.h"
    
For that, we just left include/linux/reiserfs_fs.h as is, but
we added bug.h to the new file reiserfs.h in the merge fixup
that was in linux-next.
    
There is also a silent conflict:

    commit 48c0c902e2e6ca07b8c7ae1da48a7bb59eb88de9
    "drm/radeon/kms: add support for CP setup on SI"
    
The above new file caused a linux-next build failure, since it assumes
that bug.h contents still live in the kernel.h file.  So Stephen was
adding bug.h to that file in his linux-next merge fixup as well.

The fixups are at the bottom of this mail, if that makes it easier.

Thanks,
Paul.
--

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git tags/bug-for-3.4

for you to fetch changes up to 6c03438edeb5c359af35f060ea016ca65671c269:

  kernel.h: doesn't explicitly use bug.h, so don't include it. (2012-03-04 17:54:36 -0500)

----------------------------------------------------------------
The following text was taken from the original review request:

	"[RFC - PATCH 0/7] consolidation of BUG support code."
		https://lkml.org/lkml/2012/1/26/525
--

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

[1]  https://lkml.org/lkml/2012/1/3/90
[2]  https://lkml.org/lkml/2012/1/17/414

----------------------------------------------------------------
Paul Gortmaker (7):
      x86: relocate get/set debugreg fcns to include/asm/debugreg.
      spinlock: macroize assert_spin_locked to avoid bug.h dependency
      lib: fix implicit users of kernel.h for TAINT_WARN
      bug.h: add include of it to various implicit C users
      BUG: headers with BUG/BUG_ON etc. need linux/bug.h
      bug: consolidate BUILD_BUG_ON with other bug code
      kernel.h: doesn't explicitly use bug.h, so don't include it.

 arch/arm/mach-imx/cpu_op-mx51.c                 |    1 +
 arch/arm/mach-ux500/board-mop500-pins.c         |    1 +
 arch/avr32/include/asm/io.h                     |    1 +
 arch/m68k/include/asm/system.h                  |    1 +
 arch/mips/fw/arc/cmdline.c                      |    1 +
 arch/mips/fw/arc/identify.c                     |    1 +
 arch/parisc/math-emu/fpudispatch.c              |    1 +
 arch/powerpc/kernel/pmc.c                       |    1 +
 arch/powerpc/xmon/ppc-opc.c                     |    1 +
 arch/powerpc/xmon/spu-opc.c                     |    1 +
 arch/sparc/include/asm/vga.h                    |    1 +
 arch/x86/include/asm/debugreg.h                 |   67 +++++++++++++++++++++++
 arch/x86/include/asm/paravirt.h                 |    1 +
 arch/x86/include/asm/processor.h                |   63 ---------------------
 arch/x86/kernel/cpu/common.c                    |    1 +
 arch/x86/kernel/paravirt.c                      |    1 +
 arch/x86/mm/kmemcheck/selftest.c                |    1 +
 drivers/gpu/drm/radeon/cayman_blit_shaders.c    |    1 +
 drivers/gpu/drm/radeon/evergreen_blit_shaders.c |    1 +
 drivers/gpu/drm/radeon/r600_blit_shaders.c      |    1 +
 drivers/staging/wlags49_h2/hcf.c                |    1 +
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
 include/linux/scatterlist.h                     |    6 +-
 include/linux/seq_file.h                        |    1 +
 include/linux/skbuff.h                          |    1 +
 include/linux/slub_def.h                        |    1 +
 include/linux/spinlock.h                        |    5 +-
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
 lib/atomic64_test.c                             |    1 +
 lib/average.c                                   |    1 +
 lib/bitmap.c                                    |    1 +
 lib/iommu-helper.c                              |    1 +
 lib/list_debug.c                                |    2 +
 lib/plist.c                                     |    1 +
 lib/string.c                                    |    1 +
 lib/timerqueue.c                                |    1 +
 92 files changed, 222 insertions(+), 132 deletions(-)
    

diff --git a/drivers/gpu/drm/radeon/si_blit_shaders.c b/drivers/gpu/drm/radeon/si_blit_shaders.c
index a7124b4..ec415e7 100644
--- a/drivers/gpu/drm/radeon/si_blit_shaders.c
+++ b/drivers/gpu/drm/radeon/si_blit_shaders.c
@@ -25,6 +25,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/kernel.h>
 
 const u32 si_default_state[] =
diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
index 445d768..a59d271 100644
--- a/fs/reiserfs/reiserfs.h
+++ b/fs/reiserfs/reiserfs.h
@@ -7,6 +7,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
 #include <linux/workqueue.h>
 #include <asm/unaligned.h>
 #include <linux/bitops.h>

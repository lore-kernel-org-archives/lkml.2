Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2A0CrE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:47:04 -0500
Received: from mail.windriver.com ([147.11.1.11]:53757 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2A0Co7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:44:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 5/7] BUG: headers with BUG/BUG_ON etc. need linux/bug.h
Date: Thu, 26 Jan 2012 21:44:30 -0500
Message-Id: <1327632272-12928-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a header file is making use of BUG, BUG_ON, BUILD_BUG_ON, or any
other BUG variant in a static inline (i.e. not in a #define) then
that header really should be including <linux/bug.h> and not just
expecting it to be implicitly present.

We can make this change risk-free, since if the files using these
headers didn't have exposure to linux/bug.h already, they would have
been causing compile failures/warnings.

We might want to revisit some of these "high use" files and see
if we can avoid the bug.h include in a "clean" way, via a simple
define instead of an inline if possible.

Top ten "high use" candidates at the moment are as follows:

$ for i in `git diff --name-only ^HEAD~ HEAD|sed 's,include/,,'`; do echo $i ; C=`git grep -l $i include|wc -l` ; echo $C $i ; done |sort -n -k1 -r|head
72 linux/skbuff.h
59 linux/fs.h
50 linux/netdevice.h
40 linux/rcupdate.h
33 linux/mm.h
24 linux/scatterlist.h
20 linux/cpumask.h
15 linux/seq_file.h
14 linux/crypto.h
12 linux/dmaengine.h
$

Note that the above stats can be misleading, in that it doesn't
factor in whether one of the "includers" itself is high use.
For example, if foo.h is only used once, but the user is kernel.h,
then foo.h will be largely everywhere.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/include/asm/paravirt.h          |    1 +
 include/asm-generic/dma-mapping-common.h |    1 +
 include/asm-generic/pgtable.h            |    1 +
 include/asm-generic/tlbflush.h           |    2 ++
 include/drm/ttm/ttm_memory.h             |    1 +
 include/linux/atmdev.h                   |    1 +
 include/linux/bio.h                      |    1 +
 include/linux/bit_spinlock.h             |    1 +
 include/linux/ceph/decode.h              |    3 ++-
 include/linux/ceph/libceph.h             |    1 +
 include/linux/ceph/mdsmap.h              |    1 +
 include/linux/cpumask.h                  |    1 +
 include/linux/crypto.h                   |    1 +
 include/linux/debug_locks.h              |    1 +
 include/linux/dmaengine.h                |    1 +
 include/linux/elfcore.h                  |    1 +
 include/linux/ext3_fs.h                  |    1 +
 include/linux/fs.h                       |    1 +
 include/linux/fsnotify.h                 |    1 +
 include/linux/gpio.h                     |    1 +
 include/linux/highmem.h                  |    1 +
 include/linux/i2o.h                      |    1 +
 include/linux/if_vlan.h                  |    1 +
 include/linux/io-mapping.h               |    1 +
 include/linux/kprobes.h                  |    1 +
 include/linux/kvm_host.h                 |    1 +
 include/linux/memory_hotplug.h           |    1 +
 include/linux/mm.h                       |    1 +
 include/linux/mtd/cfi.h                  |    1 +
 include/linux/netdevice.h                |    1 +
 include/linux/nilfs2_fs.h                |    1 +
 include/linux/page-flags.h               |    1 +
 include/linux/pid_namespace.h            |    1 +
 include/linux/posix_acl.h                |    1 +
 include/linux/ptrace.h                   |    1 +
 include/linux/radix-tree.h               |    1 +
 include/linux/rcupdate.h                 |    1 +
 include/linux/regset.h                   |    1 +
 include/linux/reiserfs_fs.h              |    1 +
 include/linux/relay.h                    |    1 +
 include/linux/scatterlist.h              |    6 ++++--
 include/linux/seq_file.h                 |    1 +
 include/linux/skbuff.h                   |    1 +
 include/linux/slub_def.h                 |    1 +
 include/linux/ssb/ssb_driver_gige.h      |    1 +
 include/linux/swapops.h                  |    1 +
 include/linux/syscalls.h                 |    1 +
 include/linux/transport_class.h          |    1 +
 include/linux/virtio_config.h            |    1 +
 include/net/cfg80211.h                   |    1 +
 include/net/dst.h                        |    1 +
 include/net/ip_vs.h                      |    1 +
 include/net/mac80211.h                   |    1 +
 include/net/netns/generic.h              |    1 +
 include/net/red.h                        |    1 +
 include/net/tcp.h                        |    1 +
 include/net/timewait_sock.h              |    1 +
 include/net/udp.h                        |    1 +
 include/net/wpan-phy.h                   |    1 +
 include/scsi/osd_ore.h                   |    1 +
 include/scsi/scsi_transport.h            |    1 +
 61 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index a7d2db9..923b070 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -10,6 +10,7 @@
 #include <asm/paravirt_types.h>
 
 #ifndef __ASSEMBLY__
+#include <linux/bug.h>
 #include <linux/types.h>
 #include <linux/cpumask.h>
 
diff --git a/include/asm-generic/dma-mapping-common.h b/include/asm-generic/dma-mapping-common.h
index 9fa3f96..2e248d8 100644
--- a/include/asm-generic/dma-mapping-common.h
+++ b/include/asm-generic/dma-mapping-common.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_DMA_MAPPING_H
 
 #include <linux/kmemcheck.h>
+#include <linux/bug.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
 #include <linux/dma-attrs.h>
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index 76bff2b..236b105 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -5,6 +5,7 @@
 #ifdef CONFIG_MMU
 
 #include <linux/mm_types.h>
+#include <linux/bug.h>
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 extern int ptep_set_access_flags(struct vm_area_struct *vma,
diff --git a/include/asm-generic/tlbflush.h b/include/asm-generic/tlbflush.h
index c7af037..d6d0a88 100644
--- a/include/asm-generic/tlbflush.h
+++ b/include/asm-generic/tlbflush.h
@@ -9,6 +9,8 @@
 #error need to implement an architecture specific asm/tlbflush.h
 #endif
 
+#include <linux/bug.h>
+
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
 	BUG();
diff --git a/include/drm/ttm/ttm_memory.h b/include/drm/ttm/ttm_memory.h
index 26c1f78..d6d1da4 100644
--- a/include/drm/ttm/ttm_memory.h
+++ b/include/drm/ttm/ttm_memory.h
@@ -30,6 +30,7 @@
 
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/bug.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index f4ff882..42c471a 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -217,6 +217,7 @@ struct atm_cirange {
 #include <linux/wait.h> /* wait_queue_head_t */
 #include <linux/time.h> /* struct timeval */
 #include <linux/net.h>
+#include <linux/bug.h>
 #include <linux/skbuff.h> /* struct sk_buff */
 #include <linux/uio.h>
 #include <net/sock.h>
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 129a9c0..f54db08 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -23,6 +23,7 @@
 #include <linux/highmem.h>
 #include <linux/mempool.h>
 #include <linux/ioprio.h>
+#include <linux/bug.h>
 
 #ifdef CONFIG_BLOCK
 
diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index ac4d9f8..3b5bafc 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/preempt.h>
 #include <linux/atomic.h>
+#include <linux/bug.h>
 
 /*
  *  bit-based spin_lock()
diff --git a/include/linux/ceph/decode.h b/include/linux/ceph/decode.h
index c5b6939..220ae21 100644
--- a/include/linux/ceph/decode.h
+++ b/include/linux/ceph/decode.h
@@ -1,8 +1,9 @@
 #ifndef __CEPH_DECODE_H
 #define __CEPH_DECODE_H
 
-#include <asm/unaligned.h>
+#include <linux/bug.h>
 #include <linux/time.h>
+#include <asm/unaligned.h>
 
 #include "types.h"
 
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 95bd850..e8cf0cc 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -7,6 +7,7 @@
 #include <linux/backing-dev.h>
 #include <linux/completion.h>
 #include <linux/exportfs.h>
+#include <linux/bug.h>
 #include <linux/fs.h>
 #include <linux/mempool.h>
 #include <linux/pagemap.h>
diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
index 4c5cb08..9935fac 100644
--- a/include/linux/ceph/mdsmap.h
+++ b/include/linux/ceph/mdsmap.h
@@ -1,6 +1,7 @@
 #ifndef _FS_CEPH_MDSMAP_H
 #define _FS_CEPH_MDSMAP_H
 
+#include <linux/bug.h>
 #include "types.h"
 
 /*
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 4f7a632..7b9b75a 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/threads.h>
 #include <linux/bitmap.h>
+#include <linux/bug.h>
 
 typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 8a94217..d870bae 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -20,6 +20,7 @@
 #include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/uaccess.h>
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 5033fb8..94f20c1 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/atomic.h>
+#include <linux/bug.h>
 #include <asm/system.h>
 
 struct task_struct;
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 679b349..a5966f6 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -23,6 +23,7 @@
 
 #include <linux/device.h>
 #include <linux/uio.h>
+#include <linux/bug.h>
 #include <linux/scatterlist.h>
 #include <linux/bitmap.h>
 #include <asm/page.h>
diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 394a3e0..0698c79 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -6,6 +6,7 @@
 #include <linux/time.h>
 #ifdef __KERNEL__
 #include <linux/user.h>
+#include <linux/bug.h>
 #endif
 #include <linux/ptrace.h>
 #include <linux/elf.h>
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index f957085..f5a84eef 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/bug.h>
 
 /*
  * The second extended filesystem constants/structures
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0244082..3b94bc6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -389,6 +389,7 @@ struct inodes_stat_t {
 #include <linux/prio_tree.h>
 #include <linux/init.h>
 #include <linux/pid.h>
+#include <linux/bug.h>
 #include <linux/mutex.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 2a53f10..a6dfe69 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -14,6 +14,7 @@
 #include <linux/fsnotify_backend.h>
 #include <linux/audit.h>
 #include <linux/slab.h>
+#include <linux/bug.h>
 
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 38ac48b..ed5a467 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -34,6 +34,7 @@ struct gpio {
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/bug.h>
 
 struct device;
 struct gpio_chip;
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 3a93f73..6ede661 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index a6deef4..d23c3c2 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -24,6 +24,7 @@
 #define I2O_MAX_DRIVERS		8
 
 #include <linux/pci.h>
+#include <linux/bug.h>
 #include <linux/dma-mapping.h>
 #include <linux/string.h>
 #include <linux/slab.h>
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 13aff1e..82097f3 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -17,6 +17,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/bug.h>
 
 #define VLAN_HLEN	4		/* The additional bytes (on top of the Ethernet header)
 					 * that VLAN requires.
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index e44e84f..657fab4 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/slab.h>
+#include <linux/bug.h>
 #include <asm/io.h>
 #include <asm/page.h>
 
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index dce6e4d..b6e1f8c 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -33,6 +33,7 @@
 #include <linux/list.h>
 #include <linux/notifier.h>
 #include <linux/smp.h>
+#include <linux/bug.h>
 #include <linux/percpu.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 900c763..ca1b153 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/mmu_notifier.h>
 #include <linux/preempt.h>
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 0b8e2a7..910550f 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -4,6 +4,7 @@
 #include <linux/mmzone.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
+#include <linux/bug.h>
 
 struct page;
 struct zone;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 17b27cd..b7fac5b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -6,6 +6,7 @@
 #ifdef __KERNEL__
 
 #include <linux/gfp.h>
+#include <linux/bug.h>
 #include <linux/list.h>
 #include <linux/mmzone.h>
 #include <linux/rbtree.h>
diff --git a/include/linux/mtd/cfi.h b/include/linux/mtd/cfi.h
index d5d2ec6..37ef6b1 100644
--- a/include/linux/mtd/cfi.h
+++ b/include/linux/mtd/cfi.h
@@ -22,6 +22,7 @@
 
 #include <linux/delay.h>
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/interrupt.h>
 #include <linux/mtd/flashchip.h>
 #include <linux/mtd/map.h>
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0eac07c..5820638 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -33,6 +33,7 @@
 #ifdef __KERNEL__
 #include <linux/pm_qos.h>
 #include <linux/timer.h>
+#include <linux/bug.h>
 #include <linux/delay.h>
 #include <linux/atomic.h>
 #include <asm/cache.h>
diff --git a/include/linux/nilfs2_fs.h b/include/linux/nilfs2_fs.h
index 7454ad7..89bd4a4 100644
--- a/include/linux/nilfs2_fs.h
+++ b/include/linux/nilfs2_fs.h
@@ -41,6 +41,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/magic.h>
+#include <linux/bug.h>
 
 
 #define NILFS_INODE_BMAP_SIZE	7
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e90a673..3cfa3ad 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -6,6 +6,7 @@
 #define PAGE_FLAGS_H
 
 #include <linux/types.h>
+#include <linux/bug.h>
 #ifndef __GENERATING_BOUNDS_H
 #include <linux/mm_types.h>
 #include <generated/bounds.h>
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index e7cf666..f5bd679 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -2,6 +2,7 @@
 #define _LINUX_PID_NS_H
 
 #include <linux/sched.h>
+#include <linux/bug.h>
 #include <linux/mm.h>
 #include <linux/threads.h>
 #include <linux/nsproxy.h>
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index b768110..11bad91 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -8,6 +8,7 @@
 #ifndef __LINUX_POSIX_ACL_H
 #define __LINUX_POSIX_ACL_H
 
+#include <linux/bug.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index c2f1f6a..753ee8b 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -113,6 +113,7 @@
 #include <linux/compiler.h>		/* For unlikely.  */
 #include <linux/sched.h>		/* For struct task_struct.  */
 #include <linux/err.h>			/* for IS_ERR_VALUE */
+#include <linux/bug.h>			/* For BUG_ON.  */
 
 
 extern long arch_ptrace(struct task_struct *child, long request,
diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 07e360b..e9a4823 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -22,6 +22,7 @@
 
 #include <linux/preempt.h>
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/rcupdate.h>
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 81c04f4..3b657f2 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -42,6 +42,7 @@
 #include <linux/lockdep.h>
 #include <linux/completion.h>
 #include <linux/debugobjects.h>
+#include <linux/bug.h>
 #include <linux/compiler.h>
 
 #ifdef CONFIG_RCU_TORTURE_TEST
diff --git a/include/linux/regset.h b/include/linux/regset.h
index 8abee65..6325e09 100644
--- a/include/linux/regset.h
+++ b/include/linux/regset.h
@@ -15,6 +15,7 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <linux/uaccess.h>
 struct task_struct;
 struct user_regset;
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index 2213ddc..6643fb0 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -18,6 +18,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
 #include <linux/workqueue.h>
 #include <asm/unaligned.h>
 #include <linux/bitops.h>
diff --git a/include/linux/relay.h b/include/linux/relay.h
index a822fd7..91cacc3 100644
--- a/include/linux/relay.h
+++ b/include/linux/relay.h
@@ -15,6 +15,7 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/kref.h>
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9aaf5bf..ac9586d 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -1,10 +1,12 @@
 #ifndef _LINUX_SCATTERLIST_H
 #define _LINUX_SCATTERLIST_H
 
+#include <linux/string.h>
+#include <linux/bug.h>
+#include <linux/mm.h>
+
 #include <asm/types.h>
 #include <asm/scatterlist.h>
-#include <linux/mm.h>
-#include <linux/string.h>
 #include <asm/io.h>
 
 struct sg_table {
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 44f1514..5ff2df6 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/bug.h>
 #include <linux/mutex.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 50db9b0..773ae98 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -18,6 +18,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/compiler.h>
 #include <linux/time.h>
+#include <linux/bug.h>
 #include <linux/cache.h>
 
 #include <linux/atomic.h>
diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index a32bcfd..ca122b3 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -8,6 +8,7 @@
  */
 #include <linux/types.h>
 #include <linux/gfp.h>
+#include <linux/bug.h>
 #include <linux/workqueue.h>
 #include <linux/kobject.h>
 
diff --git a/include/linux/ssb/ssb_driver_gige.h b/include/linux/ssb/ssb_driver_gige.h
index eba52a1..6b05dcd 100644
--- a/include/linux/ssb/ssb_driver_gige.h
+++ b/include/linux/ssb/ssb_driver_gige.h
@@ -2,6 +2,7 @@
 #define LINUX_SSB_DRIVER_GIGE_H_
 
 #include <linux/ssb/ssb.h>
+#include <linux/bug.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 2189d3f..792d16d 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -2,6 +2,7 @@
 #define _LINUX_SWAPOPS_H
 
 #include <linux/radix-tree.h>
+#include <linux/bug.h>
 
 /*
  * swapcache pages are stored in the swapper_space radix tree.  We want to
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 515669f..61b3e08 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -68,6 +68,7 @@ struct file_handle;
 #include <linux/aio_abi.h>
 #include <linux/capability.h>
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <linux/sem.h>
 #include <asm/siginfo.h>
 #include <asm/signal.h>
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 9ae8da3..11087cd 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -10,6 +10,7 @@
 #define _TRANSPORT_CLASS_H_
 
 #include <linux/device.h>
+#include <linux/bug.h>
 #include <linux/attribute_container.h>
 
 struct transport_container;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 5206d65..7323a33 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -53,6 +53,7 @@
 
 #ifdef __KERNEL__
 #include <linux/err.h>
+#include <linux/bug.h>
 #include <linux/virtio.h>
 
 /**
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15f4be7..57fc879 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include <linux/debugfs.h>
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <linux/netlink.h>
 #include <linux/skbuff.h>
 #include <linux/nl80211.h>
diff --git a/include/net/dst.h b/include/net/dst.h
index 344c8dd..59c5d18 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -12,6 +12,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/rcupdate.h>
+#include <linux/bug.h>
 #include <linux/jiffies.h>
 #include <net/neighbour.h>
 #include <asm/processor.h>
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ebe517f..2bdee51 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -16,6 +16,7 @@
 #include <linux/atomic.h>                 /* for struct atomic_t */
 #include <linux/compiler.h>
 #include <linux/timer.h>
+#include <linux/bug.h>
 
 #include <net/checksum.h>
 #include <linux/netfilter.h>		/* for union nf_inet_addr */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d49928b..09b5ce6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -17,6 +17,7 @@
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
 #include <linux/device.h>
+#include <linux/bug.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>
diff --git a/include/net/netns/generic.h b/include/net/netns/generic.h
index 3419bf5..f92bb69 100644
--- a/include/net/netns/generic.h
+++ b/include/net/netns/generic.h
@@ -5,6 +5,7 @@
 #ifndef __NET_GENERIC_H__
 #define __NET_GENERIC_H__
 
+#include <linux/bug.h>
 #include <linux/rcupdate.h>
 
 /*
diff --git a/include/net/red.h b/include/net/red.h
index 28068ec..77d4c37 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -2,6 +2,7 @@
 #define __NET_SCHED_RED_H
 
 #include <linux/types.h>
+#include <linux/bug.h>
 #include <net/pkt_sched.h>
 #include <net/inet_ecn.h>
 #include <net/dsfield.h>
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 0118ea9..251eb81 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -22,6 +22,7 @@
 
 #include <linux/list.h>
 #include <linux/tcp.h>
+#include <linux/bug.h>
 #include <linux/slab.h>
 #include <linux/cache.h>
 #include <linux/percpu.h>
diff --git a/include/net/timewait_sock.h b/include/net/timewait_sock.h
index 053b3cf..8d6689c 100644
--- a/include/net/timewait_sock.h
+++ b/include/net/timewait_sock.h
@@ -12,6 +12,7 @@
 #define _TIMEWAIT_SOCK_H
 
 #include <linux/slab.h>
+#include <linux/bug.h>
 #include <net/sock.h>
 
 struct timewait_sock_ops {
diff --git a/include/net/udp.h b/include/net/udp.h
index e39592f..5d606d9 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -23,6 +23,7 @@
 #define _UDP_H
 
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <net/inet_sock.h>
 #include <net/sock.h>
 #include <net/snmp.h>
diff --git a/include/net/wpan-phy.h b/include/net/wpan-phy.h
index d86fffd..ff27f1b 100644
--- a/include/net/wpan-phy.h
+++ b/include/net/wpan-phy.h
@@ -23,6 +23,7 @@
 
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
+#include <linux/bug.h>
 
 struct wpan_phy {
 	struct mutex pib_lock;
diff --git a/include/scsi/osd_ore.h b/include/scsi/osd_ore.h
index f05fa82..a5f9b96 100644
--- a/include/scsi/osd_ore.h
+++ b/include/scsi/osd_ore.h
@@ -26,6 +26,7 @@
 #include <scsi/osd_attributes.h>
 #include <scsi/osd_sec.h>
 #include <linux/pnfs_osd_xdr.h>
+#include <linux/bug.h>
 
 struct ore_comp {
 	struct osd_obj_id	obj;
diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
index 0de32cd..af244f4 100644
--- a/include/scsi/scsi_transport.h
+++ b/include/scsi/scsi_transport.h
@@ -22,6 +22,7 @@
 
 #include <linux/transport_class.h>
 #include <linux/blkdev.h>
+#include <linux/bug.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
 
-- 
1.7.7.2


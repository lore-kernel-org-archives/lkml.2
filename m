Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965843Ab0CPGSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:18:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965792Ab0CPGSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:18:00 -0400
Date: Tue, 16 Mar 2010 07:17:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
Message-ID: <20100316061718.GA22651@elte.hu>
References: <4B990496.4020002@kernel.org>
 <4B9F08AC.9030904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F08AC.9030904@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo <tj@kernel.org> wrote:

> On 03/11/2010 11:56 PM, Tejun Heo wrote:
> > So, what do you guys think?  Probably-the-right-thing-to-do >544 file
> > patch or somewhat-ugly-but-let's-worry-about-it-tommorrow two file
> > patch?
> 
> Ping, any opinions?

( /me mumbles something about not having a patch in the email to review and
  pulling the tree. 200k patch is just fine for lkml - i've attached it below
  for easier review. percpu.h and percpu.c has the meat of the changes. )

i like the dependency reduction. Noticed one small detail:

this new 2000-lines #ifdef block percpu.c:

 +#ifdef CONFIG_SMP
 +#else  /* CONFIG_SMP */
 +#endif /* CONFIG_SMP */

feels a bit lame. A separate percpu_up.c file would be nicer i suppose?

Also, why should we make this opt-in and expose a wide range of configs to 
build breakages? A more gradual approach would be to write a simple script 
that adds a slab.h include to all .c's that include percpu.h, directly or 
indirectly.

You can map the pattern experimentally: the insertion pattern could be built 
from the x86 allmodconfig build you did [i.e. extend the pattern until you 
make it build on allmodconfig] - that would cover most cases in practice (not 
just allmodconfig) - and would cover most architectures as well.

	Ingo

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 74c3543..626be15 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -40,6 +40,7 @@
 #include <linux/ptrace.h>
 #include <linux/highuid.h>
 #include <linux/sysctl.h>
+#include <linux/slab.h>
 #include <asm/mman.h>
 #include <asm/types.h>
 #include <asm/uaccess.h>
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3a4bf35..1a160d5 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
 #include <linux/stop_machine.h>
+#include <linux/slab.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 8aa65ad..5191860 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -26,6 +26,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/kdebug.h>
 #include <linux/smp.h>
+#include <linux/slab.h>
 
 #include <asm/i8259.h>
 #include <asm/io_apic.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3ab9c88..774b7ec 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -29,6 +29,7 @@
 #include <linux/init.h>
 #include <linux/kmod.h>
 #include <linux/poll.h>
+#include <linux/slab.h>
 #include <linux/nmi.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index cda932c..7d03dad 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -22,6 +22,7 @@
 #include <linux/sched.h>
 #include <linux/sysfs.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/smp.h>
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 42aafd1..da9f650 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -24,6 +24,7 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/slab.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index ee4fa1b..fca4b83 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -6,6 +6,7 @@
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/pm.h>
 #include <linux/io.h>
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index c01a2b8..54c31c2 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/regset.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <asm/sigcontext.h>
 #include <asm/processor.h>
diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index e444357..3c19929 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -10,6 +10,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/stat.h>
 #include <linux/io.h>
 #include <linux/mm.h>
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index ece73d8..77002e1 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/rbtree.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
 
 #include <asm/apic.h>
 #include <asm/uv/uv_irq.h>
diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 2b75ef6..56e421b 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -19,6 +19,7 @@
  *  Copyright (c) Dimitri Sivanich
  */
 #include <linux/clockchips.h>
+#include <linux/slab.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 536fb68..5d0e67f 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -21,6 +21,7 @@
 #include <linux/kdebug.h>
 #include <linux/mutex.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <linux/errno.h>
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 34a3291..2d03cb4 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 #include <linux/version.h>
 #include <linux/kallsyms.h>
+#include <linux/slab.h>
 #include <asm/pgtable.h>
 #include <linux/mmiotrace.h>
 #include <asm/e820.h> /* for ISA_START_ADDRESS */
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ae9648e..a75376c 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/rbtree.h>
+#include <linux/slab.h>
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 21e1aeb..67a23a4 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/random.h>
 #include <linux/elf.h>
+#include <linux/slab.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
index e133ce2..a49969c 100644
--- a/arch/x86/xen/debugfs.c
+++ b/arch/x86/xen/debugfs.c
@@ -1,6 +1,7 @@
 #include <linux/init.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "debugfs.h"
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index deafb65..8eb428f 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/err.h>
 #include <linux/smp.h>
+#include <linux/slab.h>
 
 #include <asm/paravirt.h>
 #include <asm/desc.h>
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4b686ad..5fe03de 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -15,6 +15,7 @@
 #include <linux/kdev_t.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include "blk-cgroup.h"
 
 static DEFINE_SPINLOCK(blkio_list_lock);
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 96e83c2..edce1ef 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -24,6 +24,7 @@
 #include <linux/mempool.h>
 #include <linux/bio.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include "blk.h"
 
diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index 3f65c8a..d22c4c5 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -7,6 +7,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/bootmem.h>	/* for max_pfn/max_low_pfn */
+#include <linux/slab.h>
 
 #include "blk.h"
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 2ae2cb3..7f08727 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -6,6 +6,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/blktrace_api.h>
+#include <linux/slab.h>
 
 #include "blk.h"
 
diff --git a/block/blk-tag.c b/block/blk-tag.c
index 6b0f52c..ece65fc 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/slab.h>
 
 #include "blk.h"
 
diff --git a/block/bsg.c b/block/bsg.c
index 46597a6..82d5882 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -21,6 +21,7 @@
 #include <linux/idr.h>
 #include <linux/bsg.h>
 #include <linux/smp_lock.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dee9d93..101de5a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -13,6 +13,7 @@
 #include <linux/rbtree.h>
 #include <linux/ioprio.h>
 #include <linux/blktrace_api.h>
+#include <linux/slab.h>
 #include "blk-cgroup.h"
 
 /*
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 4eb8e9e..716a29a 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -10,6 +10,7 @@
 #include <linux/smp_lock.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 static int compat_put_ushort(unsigned long arg, unsigned short val)
 {
diff --git a/block/noop-iosched.c b/block/noop-iosched.c
index 3a0d369..a8d98f8 100644
--- a/block/noop-iosched.c
+++ b/block/noop-iosched.c
@@ -6,6 +6,7 @@
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 
 struct noop_data {
 	struct list_head queue;
diff --git a/drivers/auxdisplay/cfag12864b.c b/drivers/auxdisplay/cfag12864b.c
index eacb175..ff2ab86 100644
--- a/drivers/auxdisplay/cfag12864b.c
+++ b/drivers/auxdisplay/cfag12864b.c
@@ -37,6 +37,7 @@
 #include <linux/workqueue.h>
 #include <linux/ks0108.h>
 #include <linux/cfag12864b.h>
+#include <linux/slab.h>
 
 
 #define CFAG12864B_NAME "cfag12864b"
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 71f6af5..e8d3f4d 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include "base.h"
 #include "power/power.h"
 
diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 05dd307..cf7a0c7 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -9,6 +9,7 @@
 
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "base.h"
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 90c9fff..fd3ca8d 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include "base.h"
 
 static struct device *next_device(struct klist_iter *i)
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d0dc26a..7708333 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/timer.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 2f86915..eab356d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/stat.h>
+#include <linux/slab.h>
 
 #include <asm/atomic.h>
 #include <asm/uaccess.h>
diff --git a/drivers/base/module.c b/drivers/base/module.c
index 103be9c..f1fcd61 100644
--- a/drivers/base/module.c
+++ b/drivers/base/module.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include "base.h"
 
 static char *make_driver_name(struct device_driver *drv)
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c6ddeac..9e33ba8 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -18,6 +18,7 @@
 #include <linux/gfp.h>
 #include <linux/radix-tree.h>
 #include <linux/buffer_head.h> /* invalidate_bh_lrus() */
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
index eb2091a..6cd8b70 100644
--- a/drivers/block/osdblk.c
+++ b/drivers/block/osdblk.c
@@ -63,6 +63,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_attributes.h>
 #include <scsi/osd_sec.h>
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 2e88983..0536b5b 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -27,6 +27,7 @@
 #include <linux/blkdev.h>
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 
 #define DRV_NAME "ub"
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 3c64af0..a925412 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -5,6 +5,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #define PART_BITS 4
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9c09694..d25e745 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -41,6 +41,7 @@
 #include <linux/cdrom.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index 465185f..115b91e 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -38,6 +38,7 @@
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/freezer.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 5ee4248..d83a431 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -29,6 +29,7 @@
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/devpts_fs.h>
+#include <linux/slab.h>
 
 #include <asm/system.h>
 
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index f06bb37..0c2d4c9 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -26,6 +26,7 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 
 #include "tpm.h"
 
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 70efba2..a605cb7 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include "tpm.h"
 
 /* National definitions */
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2405f17..ae1d464 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -24,6 +24,7 @@
 #include <linux/pnp.h>
 #include <linux/interrupt.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 #include "tpm.h"
 
 #define TPM_HEADER_SIZE 10
diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 283a15b..33a1e4d 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -9,6 +9,7 @@
  * Authors: Miloslav Trmac <mitr@redhat.com>
  */
 
+#include <linux/slab.h>
 #include <linux/audit.h>
 #include <linux/tty.h>
 
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index f404ccf..1895a4f 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_console.h>
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 5a62d67..51e478a 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -19,6 +19,7 @@
 #include <linux/kobject.h>
 #include <linux/spinlock.h>
 #include <linux/notifier.h>
+#include <linux/slab.h>
 #include <asm/cputime.h>
 
 static spinlock_t cpufreq_stats_lock;
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 8719b36..7b30e60 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/cpuidle.h>
 #include <linux/sysfs.h>
 #include <linux/cpu.h>
+#include <linux/slab.h>
 
 #include "cpuidle.h"
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 87399ca..d18b5d0 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -58,6 +58,7 @@
 #include <linux/jiffies.h>
 #include <linux/rculist.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 
 static DEFINE_MUTEX(dma_list_mutex);
 static LIST_HEAD(dma_device_list);
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 6fa55fe..b128f00 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -15,6 +15,7 @@
 #include <linux/moduleparam.h>
 #include <linux/random.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 
 static unsigned int test_buf_size = 16384;
 module_param(test_buf_size, uint, S_IRUGO);
diff --git a/drivers/firmware/dell_rbu.c b/drivers/firmware/dell_rbu.c
index b3a0cf5..d3b988b 100644
--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -44,6 +44,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 
 MODULE_AUTHOR("Abhay Salunke <abhay_salunke@dell.com>");
 MODULE_DESCRIPTION("Driver for updating BIOS image on DELL systems");
diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index dbdf6fa..a777a35 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/dmi.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 
 struct dmi_device_attribute{
 	struct device_attribute dev_attr;
diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index d59f7ca..adc0710 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 
 /*
  * Data types ------------------------------------------------------------------
diff --git a/drivers/gpio/adp5588-gpio.c b/drivers/gpio/adp5588-gpio.c
index afc097a..e22c083 100644
--- a/drivers/gpio/adp5588-gpio.c
+++ b/drivers/gpio/adp5588-gpio.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 
 #include <linux/i2c/adp5588.h>
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 6d1b866..76be229 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 
 
 /* Optional implementation infrastructure for GPIO interfaces.
diff --git a/drivers/gpio/max7300.c b/drivers/gpio/max7300.c
index 9d74eef..f5cec39 100644
--- a/drivers/gpio/max7300.c
+++ b/drivers/gpio/max7300.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/spi/max7301.h>
 
 static int max7300_i2c_write(struct device *dev, unsigned int reg,
diff --git a/drivers/gpio/max730x.c b/drivers/gpio/max730x.c
index c9bced5..b44931d 100644
--- a/drivers/gpio/max730x.c
+++ b/drivers/gpio/max730x.c
@@ -38,6 +38,7 @@
 #include <linux/mutex.h>
 #include <linux/spi/max7301.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 
 /*
  * Pin configurations, see MAX7301 datasheet page 6
diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index ab5daab..f18d348 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -16,6 +16,7 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/i2c/pca953x.h>
 #ifdef CONFIG_OF_GPIO
diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index d4295fa..ac4d0f0 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -27,6 +27,7 @@
 #include <linux/io.h>
 #include <linux/timb_gpio.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 
 #define DRIVER_NAME "timb-gpio"
 
diff --git a/drivers/gpio/wm8994-gpio.c b/drivers/gpio/wm8994-gpio.c
index de28b4a..e7c876d 100644
--- a/drivers/gpio/wm8994-gpio.c
+++ b/drivers/gpio/wm8994-gpio.c
@@ -18,6 +18,7 @@
 #include <linux/mfd/core.h>
 #include <linux/platform_device.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/wm8994/core.h>
 #include <linux/mfd/wm8994/pdata.h>
diff --git a/drivers/gpu/drm/ttm/ttm_agp_backend.c b/drivers/gpu/drm/ttm/ttm_agp_backend.c
index 4648ed2..67426ca 100644
--- a/drivers/gpu/drm/ttm/ttm_agp_backend.c
+++ b/drivers/gpu/drm/ttm/ttm_agp_backend.c
@@ -36,6 +36,7 @@
 #include <linux/agp_backend.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <asm/agp.h>
 
 struct ttm_agp_backend {
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 5ca37a5..f462f17 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -35,6 +35,7 @@
 #include <linux/wait.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 void ttm_bo_free_old_node(struct ttm_buffer_object *bo)
 {
diff --git a/drivers/gpu/drm/ttm/ttm_memory.c b/drivers/gpu/drm/ttm/ttm_memory.c
index eb143e0..e055a3a 100644
--- a/drivers/gpu/drm/ttm/ttm_memory.c
+++ b/drivers/gpu/drm/ttm/ttm_memory.c
@@ -32,6 +32,7 @@
 #include <linux/wait.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #define TTM_MEMORY_ALLOC_RETRIES 4
 
diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index a759170..0ef7f73 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/swap.h>
+#include <linux/slab.h>
 #include "drm_cache.h"
 #include "ttm/ttm_module.h"
 #include "ttm/ttm_bo_driver.h"
diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index bfda8c8..1e4c21f 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -27,6 +27,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/slab.h>
 
 
 /* AD7414 registers */
diff --git a/drivers/hwmon/ad7418.c b/drivers/hwmon/ad7418.c
index f97b5b3..ffc781f 100644
--- a/drivers/hwmon/ad7418.c
+++ b/drivers/hwmon/ad7418.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #include "lm75.h"
 
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index 3471884..8a37981 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/jiffies.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index b8156b4..2af0c7b 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -28,6 +28,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/slab.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x58, 0x5C, I2C_CLIENT_END };
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 3445ce1..9e77571 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/log2.h>
 #include <linux/kthread.h>
+#include <linux/slab.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x2C, 0x2E, 0x2F, I2C_CLIENT_END };
diff --git a/drivers/hwmon/atxp1.c b/drivers/hwmon/atxp1.c
index 94cadc1..33cc143 100644
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -28,6 +28,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/slab.h>
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("System voltages control via Attansic ATXP1");
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 277398f..4c9ec42 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -34,6 +34,7 @@
 #include <linux/i2c.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/f75375s.h>
 
 /* Addresses to scan */
diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
index 883fa81..1c2d415 100644
--- a/drivers/hwmon/mc13783-adc.c
+++ b/drivers/hwmon/mc13783-adc.c
@@ -26,6 +26,7 @@
 #include <linux/hwmon.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #define MC13783_ADC_NAME	"mc13783-adc"
 
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 864a371..b5c8261 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/jiffies.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/sht15.h>
 #include <linux/regulator/consumer.h>
 #include <asm/atomic.h>
diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
index 32104ea..2662373 100644
--- a/drivers/i2c/busses/i2c-gpio.c
+++ b/drivers/i2c/busses/i2c-gpio.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <asm/gpio.h>
 
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 0dabe64..b4ed4ca 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/wait.h>
 #include <linux/i2c-ocores.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 
 struct ocores_i2c {
diff --git a/drivers/i2c/busses/i2c-simtec.c b/drivers/i2c/busses/i2c-simtec.c
index 6407f47..78b0610 100644
--- a/drivers/i2c/busses/i2c-simtec.c
+++ b/drivers/i2c/busses/i2c-simtec.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
diff --git a/drivers/i2c/busses/i2c-tiny-usb.c b/drivers/i2c/busses/i2c-tiny-usb.c
index b5b1bbf..9caf5b9 100644
--- a/drivers/i2c/busses/i2c-tiny-usb.c
+++ b/drivers/i2c/busses/i2c-tiny-usb.c
@@ -14,6 +14,7 @@
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 
 /* include interfaces to usb layer */
 #include <linux/usb.h>
diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index f0ef8da..a9c419e 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -39,6 +39,7 @@
 #include <linux/wait.h>
 #include <linux/i2c-xiic.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #define DRIVER_NAME "xiic-i2c"
 
diff --git a/drivers/i2c/i2c-boardinfo.c b/drivers/i2c/i2c-boardinfo.c
index a26a34a..e635b71 100644
--- a/drivers/i2c/i2c-boardinfo.c
+++ b/drivers/i2c/i2c-boardinfo.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/i2c.h>
 #include <linux/rwsem.h>
+#include <linux/slab.h>
 
 #include "i2c-core.h"
 
diff --git a/drivers/i2c/i2c-smbus.c b/drivers/i2c/i2c-smbus.c
index 7a8201e..2c42620 100644
--- a/drivers/i2c/i2c-smbus.c
+++ b/drivers/i2c/i2c-smbus.c
@@ -24,6 +24,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/i2c-smbus.h>
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 764787e..2c2cf12 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -45,6 +45,7 @@
 #include <linux/sysfs.h>
 #include <linux/workqueue.h>
 #include <linux/kdev_t.h>
+#include <linux/slab.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_cm.h>
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index e351b15..1df1194 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -34,6 +34,7 @@
  *
  */
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 #include <rdma/ib_cache.h>
 
 #include "mad_priv.h"
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 9430ab4..201eb52 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -39,6 +39,7 @@
 #include <linux/completion.h>
 #include <linux/err.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
 
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 8d82ba1..18fb434 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -36,6 +36,7 @@
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 
 #include <rdma/ib_cache.h>
 #include "sa.h"
diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 017d6e2..512b1c4 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -44,6 +44,7 @@
 #include <linux/cdev.h>
 #include <linux/idr.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 04b585e..e7db054 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -46,6 +46,7 @@
 #include <linux/compat.h>
 #include <linux/sched.h>
 #include <linux/semaphore.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f71cf13..6fcfbeb 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -35,6 +35,7 @@
 
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index d805cf3..fb35262 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -44,6 +44,7 @@
 #include <linux/file.h>
 #include <linux/cdev.h>
 #include <linux/anon_inodes.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index b2f07aa..03078c0 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 /*
  * Check that the effect_id is a valid effect and whether the user
diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index f967008..7b7775e 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -30,6 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
+#include <linux/slab.h>
 
 #include "fixp-arith.h"
 
diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 291d939..698a5d1 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -11,6 +11,7 @@
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
 #include <linux/input-polldev.h>
+#include <linux/slab.h>
 
 MODULE_AUTHOR("Dmitry Torokhov <dtor@mail.ru>");
 MODULE_DESCRIPTION("Generic implementation of a polled input device");
diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index b5142d2..4771ab1 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/input.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include <linux/i2c/adp5588.h>
 
diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index 574eda2..9002b4e 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -30,6 +30,7 @@
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include <linux/i2c/lm8323.h>
 
 /* Commands to send to the chip. */
diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index d3c8b61..910ecfa 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -21,6 +21,7 @@
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <linux/input/matrix_keypad.h>
 
 struct matrix_keypad {
diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index 3b5b948..69fee58 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
 
diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
index 78cccdd..1f1a556 100644
--- a/drivers/input/keyboard/opencores-kbd.c
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 struct opencores_kbd {
 	struct input_dev *input;
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 15be543..aacec72 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -9,6 +9,7 @@
  * as published by the Free Software Foundation.
  */
 
+#include <linux/slab.h>
 #include <linux/usb/input.h>
 
 #define DRIVER_DESC    "ATI/Philips USB RF remote driver"
diff --git a/drivers/input/misc/pcap_keys.c b/drivers/input/misc/pcap_keys.c
index 7ea9693..b270aa1 100644
--- a/drivers/input/misc/pcap_keys.c
+++ b/drivers/input/misc/pcap_keys.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/mfd/ezx-pcap.h>
 
diff --git a/drivers/input/misc/pcf50633-input.c b/drivers/input/misc/pcf50633-input.c
index 008de0c..53718ec 100644
--- a/drivers/input/misc/pcf50633-input.c
+++ b/drivers/input/misc/pcf50633-input.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 
 #include <linux/mfd/pcf50633/core.h>
diff --git a/drivers/input/misc/rotary_encoder.c b/drivers/input/misc/rotary_encoder.c
index 4ae0793..b40bbab 100644
--- a/drivers/input/misc/rotary_encoder.c
+++ b/drivers/input/misc/rotary_encoder.c
@@ -21,6 +21,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <linux/rotary_encoder.h>
 
 #define DRV_NAME "rotary-encoder"
diff --git a/drivers/input/misc/winbond-cir.c b/drivers/input/misc/winbond-cir.c
index 9c155a4..64f1de7 100644
--- a/drivers/input/misc/winbond-cir.c
+++ b/drivers/input/misc/winbond-cir.c
@@ -56,6 +56,7 @@
 #include <linux/io.h>
 #include <linux/bitrev.h>
 #include <linux/bitops.h>
+#include <linux/slab.h>
 
 #define DRVNAME "winbond-cir"
 
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 7490f1d..5490ba0 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
+#include <linux/slab.h>
 
 #include "psmouse.h"
 #include "alps.h"
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index b27684f..2a346fa 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -15,6 +15,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
+#include <linux/slab.h>
 #include "psmouse.h"
 #include "elantech.h"
 
diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
index 7c1d7d4..c31ad11 100644
--- a/drivers/input/mouse/lifebook.c
+++ b/drivers/input/mouse/lifebook.c
@@ -16,6 +16,7 @@
 #include <linux/serio.h>
 #include <linux/libps2.h>
 #include <linux/dmi.h>
+#include <linux/slab.h>
 
 #include "psmouse.h"
 #include "lifebook.h"
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 81a6b81..1242775 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -26,6 +26,7 @@
 #include <linux/libps2.h>
 #include <linux/serio.h>
 #include <linux/jiffies.h>
+#include <linux/slab.h>
 
 #include "psmouse.h"
 #include "sentelic.h"
diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d3f5243..026df60 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -28,6 +28,7 @@
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
+#include <linux/slab.h>
 #include "psmouse.h"
 #include "synaptics.h"
 
diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index 9867dfe..8291e73 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -17,6 +17,7 @@
 #include <linux/input.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 #define DRIVER_NAME		"synaptics_i2c"
 /* maximum product id is 15 characters */
diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
index 320b7ca..7998560 100644
--- a/drivers/input/serio/altera_ps2.c
+++ b/drivers/input/serio/altera_ps2.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #define DRV_NAME "altera_ps2"
 
diff --git a/drivers/input/serio/ct82c710.c b/drivers/input/serio/ct82c710.c
index d1380fc..4a30846 100644
--- a/drivers/input/serio/ct82c710.c
+++ b/drivers/input/serio/ct82c710.c
@@ -35,6 +35,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 9302ba0..577688b 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/platform_device.h>
 #include <linux/i8042.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/input/sparse-keymap.c b/drivers/input/sparse-keymap.c
index e6bde55..f694a43 100644
--- a/drivers/input/sparse-keymap.c
+++ b/drivers/input/sparse-keymap.c
@@ -13,6 +13,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 
diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 9029bd3..639fb74 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -32,6 +32,7 @@
 #include <linux/i2c.h>
 #include <linux/timer.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <linux/input/eeti_ts.h>
 
 static int flip_x;
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index be54fd6..5b91378 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/sched.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 
 #define MC13783_TS_NAME	"mc13783-ts"
 
diff --git a/drivers/input/touchscreen/mcs5000_ts.c b/drivers/input/touchscreen/mcs5000_ts.c
index 4c28b89..ce8ab02 100644
--- a/drivers/input/touchscreen/mcs5000_ts.c
+++ b/drivers/input/touchscreen/mcs5000_ts.c
@@ -20,6 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/input.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
 
 /* Registers */
 #define MCS5000_TS_STATUS		0x00
diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscreen/pcap_ts.c
index b79097e..62557cb 100644
--- a/drivers/input/touchscreen/pcap_ts.c
+++ b/drivers/input/touchscreen/pcap_ts.c
@@ -19,6 +19,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <linux/mfd/ezx-pcap.h>
 
 struct pcap_ts {
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index d30436f..91784c5 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 
 #include <asm/xen/hypervisor.h>
diff --git a/drivers/isdn/capi/capifs.c b/drivers/isdn/capi/capifs.c
index 8596bd1..378917a 100644
--- a/drivers/isdn/capi/capifs.c
+++ b/drivers/isdn/capi/capifs.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>	/* current */
+#include <linux/slab.h>
 
 #include "capifs.h"
 
diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 26626ee..b86121e 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/isdn/capiutil.h>
 
 /* from CAPI2.0 DDK AVM Berlin GmbH */
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 70e6b0e..160abb4 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -47,6 +47,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/mISDNhw.h>
 
 #include "hfc_pci.h"
diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index d8ddd9e..f1c00db 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -21,6 +21,7 @@
 #include <linux/timer.h>
 #include <linux/rwsem.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 #include "leds.h"
 
 /*
diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 779d7f2..786504f 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -16,6 +16,7 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include <linux/leds-bd2802.h>
 
diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index e5225d2..d4687fe 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -15,6 +15,7 @@
 #include <linux/platform_device.h>
 #include <linux/leds.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 #include <asm/gpio.h>
 
diff --git a/drivers/leds/leds-lp3944.c b/drivers/leds/leds-lp3944.c
index 5946208..f565869 100644
--- a/drivers/leds/leds-lp3944.c
+++ b/drivers/leds/leds-lp3944.c
@@ -31,6 +31,7 @@
 #include <linux/leds.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/leds-lp3944.h>
 
 /* Read Only Registers */
diff --git a/drivers/leds/leds-lt3593.c b/drivers/leds/leds-lt3593.c
index fee40a8..2579678 100644
--- a/drivers/leds/leds-lt3593.c
+++ b/drivers/leds/leds-lt3593.c
@@ -23,6 +23,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 
 struct lt3593_led_data {
 	struct led_classdev cdev;
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index adc561e..efcadd0 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -16,7 +16,9 @@
 #include <linux/leds.h>
 #include <linux/input.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/leds-pca9532.h>
 
 #define PCA9532_REG_PSC(i) (0x2+(i)*2)
diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 4e2d1a4..8ff50f2 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -48,6 +48,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 /* LED select registers determine the source that drives LED outputs */
 #define PCA955X_LS_LED_ON	0x0	/* Output LOW */
diff --git a/drivers/leds/leds-regulator.c b/drivers/leds/leds-regulator.c
index 7f00de3..94c7bcc 100644
--- a/drivers/leds/leds-regulator.c
+++ b/drivers/leds/leds-regulator.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include <linux/leds-regulator.h>
 #include <linux/platform_device.h>
diff --git a/drivers/leds/ledtrig-backlight.c b/drivers/leds/ledtrig-backlight.c
index d3dfcfb..677f50d 100644
--- a/drivers/leds/ledtrig-backlight.c
+++ b/drivers/leds/ledtrig-backlight.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/leds.h>
 #include "leds.h"
diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index f591337..5372735 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -15,6 +15,7 @@
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include "leds.h"
 
diff --git a/drivers/leds/ledtrig-heartbeat.c b/drivers/leds/ledtrig-heartbeat.c
index c1c1ea6..3297131 100644
--- a/drivers/leds/ledtrig-heartbeat.c
+++ b/drivers/leds/ledtrig-heartbeat.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include "leds.h"
 
diff --git a/drivers/leds/ledtrig-timer.c b/drivers/leds/ledtrig-timer.c
index 38b3378..b845cfc 100644
--- a/drivers/leds/ledtrig-timer.c
+++ b/drivers/leds/ledtrig-timer.c
@@ -21,6 +21,7 @@
 #include <linux/sysdev.h>
 #include <linux/timer.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/leds.h>
 #include "leds.h"
 
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 7ac2c14..1ed0094 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/bio.h>
+#include <linux/slab.h>
 #include <linux/dm-dirty-log.h>
 #include <linux/device-mapper.h>
 #include <linux/dm-log-userspace.h>
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index bad1724..67519c7 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -15,6 +15,7 @@
 #include <linux/list.h>
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
+#include <linux/slab.h>
 
 /*
  * Suspend feature flags
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8e4c75c..095b38f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 0a3b4ed..5f16817 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -13,6 +13,7 @@
  */
 
 
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <media/ir-common.h>
 
diff --git a/drivers/media/IR/ir-sysfs.c b/drivers/media/IR/ir-sysfs.c
index bf5fbcd..0940ad0 100644
--- a/drivers/media/IR/ir-sysfs.c
+++ b/drivers/media/IR/ir-sysfs.c
@@ -14,6 +14,7 @@
 
 #include <linux/input.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <media/ir-core.h>
 
 #define IRRCV_NUM_DEVICES	256
diff --git a/drivers/media/common/tuners/mc44s803.c b/drivers/media/common/tuners/mc44s803.c
index 20c4485..fe5c4b8 100644
--- a/drivers/media/common/tuners/mc44s803.c
+++ b/drivers/media/common/tuners/mc44s803.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/common/tuners/mt2060.c b/drivers/media/common/tuners/mt2060.c
index c7abe3d..0cf1920 100644
--- a/drivers/media/common/tuners/mt2060.c
+++ b/drivers/media/common/tuners/mt2060.c
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff --git a/drivers/media/common/tuners/mt20xx.c b/drivers/media/common/tuners/mt20xx.c
index 44608ad..9607ce7 100644
--- a/drivers/media/common/tuners/mt20xx.c
+++ b/drivers/media/common/tuners/mt20xx.c
@@ -5,6 +5,7 @@
  * This "mt20xx" module was split apart from the original "tuner" module.
  */
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include "tuner-i2c.h"
diff --git a/drivers/media/common/tuners/mt2131.c b/drivers/media/common/tuners/mt2131.c
index e8d3c48..b7b58e6 100644
--- a/drivers/media/common/tuners/mt2131.c
+++ b/drivers/media/common/tuners/mt2131.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff --git a/drivers/media/common/tuners/mt2266.c b/drivers/media/common/tuners/mt2266.c
index 54b18f9..57041c7 100644
--- a/drivers/media/common/tuners/mt2266.c
+++ b/drivers/media/common/tuners/mt2266.c
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff --git a/drivers/media/common/tuners/qt1010.c b/drivers/media/common/tuners/qt1010.c
index 9f5dba2..1f7558d 100644
--- a/drivers/media/common/tuners/qt1010.c
+++ b/drivers/media/common/tuners/qt1010.c
@@ -18,6 +18,8 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#include <linux/slab.h>
+
 #include "qt1010.h"
 #include "qt1010_priv.h"
 
diff --git a/drivers/media/common/tuners/tda827x.c b/drivers/media/common/tuners/tda827x.c
index 36a7bc7..b21b6ea 100644
--- a/drivers/media/common/tuners/tda827x.c
+++ b/drivers/media/common/tuners/tda827x.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <asm/types.h>
 #include <linux/dvb/frontend.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
index 2833137..df4519d 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -22,6 +22,7 @@
 
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include "tuner-i2c.h"
 #include "tda8290.h"
diff --git a/drivers/media/common/tuners/tea5761.c b/drivers/media/common/tuners/tea5761.c
index 60ed872..d283eb1 100644
--- a/drivers/media/common/tuners/tea5761.c
+++ b/drivers/media/common/tuners/tea5761.c
@@ -9,6 +9,7 @@
 
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
 #include "tuner-i2c.h"
diff --git a/drivers/media/common/tuners/tea5767.c b/drivers/media/common/tuners/tea5767.c
index 223a226..36e85d8 100644
--- a/drivers/media/common/tuners/tea5767.c
+++ b/drivers/media/common/tuners/tea5767.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/videodev2.h>
 #include "tuner-i2c.h"
diff --git a/drivers/media/common/tuners/tuner-i2c.h b/drivers/media/common/tuners/tuner-i2c.h
index cb1c714..5ac9b4a 100644
--- a/drivers/media/common/tuners/tuner-i2c.h
+++ b/drivers/media/common/tuners/tuner-i2c.h
@@ -21,6 +21,7 @@
 #ifndef __TUNER_I2C_H__
 #define __TUNER_I2C_H__
 
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 struct tuner_i2c_props {
diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index 8abbcc5..79cf1fb 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -5,6 +5,7 @@
  * This "tuner-simple" module was split apart from the original "tuner" module.
  */
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
index be51c29..96d6170 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <media/tuner.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 #include "tuner-i2c.h"
 #include "tuner-xc2028.h"
diff --git a/drivers/media/dvb/frontends/atbm8830.c b/drivers/media/dvb/frontends/atbm8830.c
index 43aac2f..9b0c645 100644
--- a/drivers/media/dvb/frontends/atbm8830.c
+++ b/drivers/media/dvb/frontends/atbm8830.c
@@ -19,6 +19,7 @@
  *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <asm/div64.h>
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb/frontends/dib0070.c b/drivers/media/dvb/frontends/dib0070.c
index 0d12763..1de4ffd 100644
--- a/drivers/media/dvb/frontends/dib0070.c
+++ b/drivers/media/dvb/frontends/dib0070.c
@@ -26,6 +26,7 @@
 
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb/frontends/dib0090.c b/drivers/media/dvb/frontends/dib0090.c
index 7eac178..9181542 100644
--- a/drivers/media/dvb/frontends/dib0090.c
+++ b/drivers/media/dvb/frontends/dib0090.c
@@ -26,6 +26,7 @@
 
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb/frontends/dib3000mc.c b/drivers/media/dvb/frontends/dib3000mc.c
index fa85160..2c609c5 100644
--- a/drivers/media/dvb/frontends/dib3000mc.c
+++ b/drivers/media/dvb/frontends/dib3000mc.c
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb/frontends/dib7000m.c b/drivers/media/dvb/frontends/dib7000m.c
index 0109720..ac20c84 100644
--- a/drivers/media/dvb/frontends/dib7000m.c
+++ b/drivers/media/dvb/frontends/dib7000m.c
@@ -10,6 +10,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb/frontends/dib7000p.c b/drivers/media/dvb/frontends/dib7000p.c
index 750ae61..866ee81 100644
--- a/drivers/media/dvb/frontends/dib7000p.c
+++ b/drivers/media/dvb/frontends/dib7000p.c
@@ -9,6 +9,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 
 #include "dvb_math.h"
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index 2aa97dd..735dec4 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -9,6 +9,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include "dvb_math.h"
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index 868b78b..f74cca6 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 6d865d6..a4e0532 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 
diff --git a/drivers/media/dvb/frontends/ec100.c b/drivers/media/dvb/frontends/ec100.c
index 2414dc6..8df6010 100644
--- a/drivers/media/dvb/frontends/ec100.c
+++ b/drivers/media/dvb/frontends/ec100.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "ec100_priv.h"
 #include "ec100.h"
diff --git a/drivers/media/dvb/frontends/itd1000.c b/drivers/media/dvb/frontends/itd1000.c
index 600dad6..a8357a1 100644
--- a/drivers/media/dvb/frontends/itd1000.c
+++ b/drivers/media/dvb/frontends/itd1000.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
diff --git a/drivers/media/dvb/frontends/lgdt3304.c b/drivers/media/dvb/frontends/lgdt3304.c
index e334b5d..5025ee1 100644
--- a/drivers/media/dvb/frontends/lgdt3304.c
+++ b/drivers/media/dvb/frontends/lgdt3304.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "lgdt3304.h"
 
diff --git a/drivers/media/dvb/frontends/lgdt3305.c b/drivers/media/dvb/frontends/lgdt3305.c
index fde8c59..d6afd6f 100644
--- a/drivers/media/dvb/frontends/lgdt3305.c
+++ b/drivers/media/dvb/frontends/lgdt3305.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <asm/div64.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index dee5396..324446e 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/frontends/mb86a16.c b/drivers/media/dvb/frontends/mb86a16.c
index d05f750..599d1aa 100644
--- a/drivers/media/dvb/frontends/mb86a16.c
+++ b/drivers/media/dvb/frontends/mb86a16.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "mb86a16.h"
diff --git a/drivers/media/dvb/frontends/s921_module.c b/drivers/media/dvb/frontends/s921_module.c
index 3156b64..375d7ac 100644
--- a/drivers/media/dvb/frontends/s921_module.c
+++ b/drivers/media/dvb/frontends/s921_module.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "s921_module.h"
 #include "s921_core.h"
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/frontends/stb0899_drv.c
index 1570669..8e38fce 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 
 #include <linux/dvb/frontend.h>
diff --git a/drivers/media/dvb/frontends/stb6000.c b/drivers/media/dvb/frontends/stb6000.c
index 0e2cb0d..b349824 100644
--- a/drivers/media/dvb/frontends/stb6000.c
+++ b/drivers/media/dvb/frontends/stb6000.c
@@ -21,6 +21,7 @@
   */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 
diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb/frontends/stb6100.c
index 60ee18a..a494cd5 100644
--- a/drivers/media/dvb/frontends/stb6100.c
+++ b/drivers/media/dvb/frontends/stb6100.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "stb6100.h"
diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index c52c335..e28dd4c 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
diff --git a/drivers/media/dvb/frontends/stv6110.c b/drivers/media/dvb/frontends/stv6110.c
index bef0cc8..6bd4b77 100644
--- a/drivers/media/dvb/frontends/stv6110.c
+++ b/drivers/media/dvb/frontends/stv6110.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 
 #include <linux/types.h>
diff --git a/drivers/media/dvb/frontends/stv6110x.c b/drivers/media/dvb/frontends/stv6110x.c
index f931ed0..bed1ce7 100644
--- a/drivers/media/dvb/frontends/stv6110x.c
+++ b/drivers/media/dvb/frontends/stv6110x.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 
diff --git a/drivers/media/dvb/frontends/tda665x.c b/drivers/media/dvb/frontends/tda665x.c
index c44fefe..2c1c759 100644
--- a/drivers/media/dvb/frontends/tda665x.c
+++ b/drivers/media/dvb/frontends/tda665x.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "tda665x.h"
diff --git a/drivers/media/dvb/frontends/tda8261.c b/drivers/media/dvb/frontends/tda8261.c
index 614afce..1742056 100644
--- a/drivers/media/dvb/frontends/tda8261.c
+++ b/drivers/media/dvb/frontends/tda8261.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "tda8261.h"
diff --git a/drivers/media/dvb/frontends/tda826x.c b/drivers/media/dvb/frontends/tda826x.c
index a051554..80e6f76 100644
--- a/drivers/media/dvb/frontends/tda826x.c
+++ b/drivers/media/dvb/frontends/tda826x.c
@@ -21,6 +21,7 @@
   */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 
diff --git a/drivers/media/dvb/frontends/tua6100.c b/drivers/media/dvb/frontends/tua6100.c
index 1790bae..0483204 100644
--- a/drivers/media/dvb/frontends/tua6100.c
+++ b/drivers/media/dvb/frontends/tua6100.c
@@ -29,6 +29,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 
diff --git a/drivers/media/dvb/frontends/zl10036.c b/drivers/media/dvb/frontends/zl10036.c
index 34c5de4..27925fc 100644
--- a/drivers/media/dvb/frontends/zl10036.c
+++ b/drivers/media/dvb/frontends/zl10036.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/dvb/frontend.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 
 #include "zl10036.h"
 
diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 4bfd345..0c87a3c 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -28,6 +28,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 
 #include <linux/firmware.h>
 #include <linux/wait.h>
diff --git a/drivers/media/dvb/siano/smsdvb.c b/drivers/media/dvb/siano/smsdvb.c
index 5f39398..4022b4c 100644
--- a/drivers/media/dvb/siano/smsdvb.c
+++ b/drivers/media/dvb/siano/smsdvb.c
@@ -21,6 +21,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 
 #include "dmxdev.h"
 #include "dvbdev.h"
diff --git a/drivers/media/dvb/siano/smssdio.c b/drivers/media/dvb/siano/smssdio.c
index 195244a..0aa77ec 100644
--- a/drivers/media/dvb/siano/smssdio.c
+++ b/drivers/media/dvb/siano/smssdio.c
@@ -35,6 +35,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index 5eac272..a9c27fb 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -23,6 +23,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 
 #include "smscoreapi.h"
 #include "sms-cards.h"
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index 21260aa..867aa2e 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -19,6 +19,8 @@
  *
  */
 
+#include <linux/slab.h>
+
 #include "dvb_frontend.h"
 #include "ttusbdecfe.h"
 
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 170bbe5..52c2768 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 8e718bf..46aa601 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -36,6 +36,7 @@
 #include <linux/init.h>			/* Initdata			*/
 #include <linux/videodev2.h>		/* kernel radio structs		*/
 #include <linux/i2c.h>			/* I2C				*/
+#include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <linux/version.h>      	/* for KERNEL_VERSION MACRO     */
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 0de457f..ea951ae 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/timb_radio.h>
 
 #define DRIVER_NAME "timb-radio"
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index 5db5528..585680f 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 6a0028e..725770e 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -25,6 +25,7 @@
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 6e607ff..ff67d72 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -21,6 +21,7 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/video/adv7170.c b/drivers/media/video/adv7170.c
index 97b0034..ad84d5e 100644
--- a/drivers/media/video/adv7170.c
+++ b/drivers/media/video/adv7170.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
index cf8c06c..be1c155 100644
--- a/drivers/media/video/adv7175.c
+++ b/drivers/media/video/adv7175.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/bt819.c b/drivers/media/video/bt819.c
index 547e1a9..e037dea 100644
--- a/drivers/media/video/bt819.c
+++ b/drivers/media/video/bt819.c
@@ -32,6 +32,7 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/video/bt856.c b/drivers/media/video/bt856.c
index d0b4d49..d766247 100644
--- a/drivers/media/video/bt856.c
+++ b/drivers/media/video/bt856.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/bt866.c b/drivers/media/video/bt866.c
index af7e3a5..0677169 100644
--- a/drivers/media/video/bt866.c
+++ b/drivers/media/video/bt866.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index 57dc170..cffd0a5 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -20,6 +20,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index 80bca8d..3cc3825 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/video/gspca/gspca.h
index 02c696a..8bb242f 100644
--- a/drivers/media/video/gspca/gspca.h
+++ b/drivers/media/video/gspca/gspca.h
@@ -7,6 +7,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 /* compilation option */
 #define GSPCA_DEBUG 1
diff --git a/drivers/media/video/ks0127.c b/drivers/media/video/ks0127.c
index fab8e02..0a6cb50 100644
--- a/drivers/media/video/ks0127.c
+++ b/drivers/media/video/ks0127.c
@@ -38,6 +38,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/m52790.c b/drivers/media/video/m52790.c
index d7317e7..8ac0510 100644
--- a/drivers/media/video/m52790.c
+++ b/drivers/media/video/m52790.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/mt9v011.c b/drivers/media/video/mt9v011.c
index cc85f77..b17fdf2 100644
--- a/drivers/media/video/mt9v011.c
+++ b/drivers/media/video/mt9v011.c
@@ -8,6 +8,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/div64.h>
 #include <media/v4l2-device.h>
 #include "mt9v011.h"
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 0e2184e..19d110a 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index cc8ddb2..953aa00 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -21,6 +21,7 @@
 
 #include <linux/kernel.h>
 #include <linux/version.h>
+#include <linux/slab.h>
 #include "pvrusb2-context.h"
 #include "pvrusb2-hdw.h"
 #include "pvrusb2.h"
diff --git a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/video/pwc/pwc-ctrl.c
index f7f7e04..1ec3a99 100644
--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -38,6 +38,7 @@
 /* Control functions for the cam; brightness, contrast, video mode, etc. */
 
 #ifdef __KERNEL__
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #endif
 #include <asm/errno.h>
diff --git a/drivers/media/video/pwc/pwc-dec1.c b/drivers/media/video/pwc/pwc-dec1.c
index c29593f..bfb7691 100644
--- a/drivers/media/video/pwc/pwc-dec1.c
+++ b/drivers/media/video/pwc/pwc-dec1.c
@@ -24,7 +24,7 @@
 */
 
 
-
+#include <linux/slab.h>
 #include "pwc-dec1.h"
 
 
diff --git a/drivers/media/video/pwc/pwc-dec23.c b/drivers/media/video/pwc/pwc-dec23.c
index 9e2d91f..0c801b8 100644
--- a/drivers/media/video/pwc/pwc-dec23.c
+++ b/drivers/media/video/pwc/pwc-dec23.c
@@ -30,6 +30,7 @@
 #include <media/pwc-ioctl.h>
 
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /*
  * USE_LOOKUP_TABLE_TO_CLAMP
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index fb742f1..ca05dc1 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -49,6 +49,7 @@
 #include <linux/version.h>
 #include <linux/mm.h>
 #include <linux/smp_lock.h>
+#include <linux/slab.h>
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index 5ab6a0f..2b2991d 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index 12835fb..ffdf073 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -48,6 +48,7 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/videotext.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/saa717x.c b/drivers/media/video/saa717x.c
index 6818df5..b91ed03 100644
--- a/drivers/media/video/saa717x.c
+++ b/drivers/media/video/saa717x.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
diff --git a/drivers/media/video/saa7185.c b/drivers/media/video/saa7185.c
index 212baa1..b2f6592 100644
--- a/drivers/media/video/saa7185.c
+++ b/drivers/media/video/saa7185.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 80f6bfa..a24174d 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -24,6 +24,7 @@
 #include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #include <media/soc_camera.h>
diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index d381fce..e50d743 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 1585839..4224f71 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index 6bf6bc7..6bea87f 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/v4l2-i2c-drv.h>
diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index becfba6..cf8f18c 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -4,6 +4,7 @@
 #include <linux/usb.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 2d38e25..25d3157 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -8,6 +8,7 @@
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
 #include <media/v4l2-i2c-drv.h>
diff --git a/drivers/media/video/upd64031a.c b/drivers/media/video/upd64031a.c
index a07a3fb..a7495a2 100644
--- a/drivers/media/video/upd64031a.c
+++ b/drivers/media/video/upd64031a.c
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
index 6eb0e5b..530f9e6 100644
--- a/drivers/media/video/upd64083.c
+++ b/drivers/media/video/upd64083.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index c4d1b96..223b0a0 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <linux/usb/input.h>
 
 #include "usbvideo.h"
diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
index 3b2e780..9f80bd5 100644
--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -19,6 +19,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 
 #include "uvcvideo.h"
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index a814820..c07d28e 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -30,6 +30,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/video/uvc/uvc_status.c
index 1ca6dff..5fb2938 100644
--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 43152aa..fa741f1 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 
 #include <media/v4l2-common.h>
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 6b0666b..aa1ea7e 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -18,6 +18,7 @@
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 4b11257..7e9a509 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 #define __OLD_VIDIOC_ /* To allow fixing old calls */
 #include <linux/videodev.h>
diff --git a/drivers/media/video/vp27smpx.c b/drivers/media/video/vp27smpx.c
index 38e53b3..82ee324 100644
--- a/drivers/media/video/vp27smpx.c
+++ b/drivers/media/video/vp27smpx.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index 33205d7..77ebcea 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
diff --git a/drivers/media/video/wm8739.c b/drivers/media/video/wm8739.c
index b572ce2..2ae565f 100644
--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index f1f261a..3a956ce 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
index b3bf1c4..c00fe82 100644
--- a/drivers/memstick/core/memstick.c
+++ b/drivers/memstick/core/memstick.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 #define DRIVER_NAME "memstick"
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 972b870..8327e24 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -17,6 +17,7 @@
 #include <linux/hdreg.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index cb73051..262b7b9 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/ds1wm.h>
 #include <linux/mfd/htc-pasic3.h>
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 6d2e846..eb7163a 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/completion.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/pcf50633/core.h>
 #include <linux/mfd/pcf50633/adc.h>
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 03dcc92..63a614d 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/pcf50633/core.h>
 
diff --git a/drivers/mfd/ucb1400_core.c b/drivers/mfd/ucb1400_core.c
index 85fd942..dbe2801 100644
--- a/drivers/mfd/ucb1400_core.c
+++ b/drivers/mfd/ucb1400_core.c
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/ucb1400.h>
 
 unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index ecfc8bb..3100f84 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -15,6 +15,7 @@
 #include <linux/bug.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/wm8400-private.h>
 #include <linux/mfd/wm8400-audio.h>
diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 844e1c1..0a30a52 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/mfd/core.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/machine.h>
diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index b5346b4..97e92b8 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -20,6 +20,7 @@
 #include <linux/delay.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <linux/c2port.h>
 
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 1eac626..48c84a5 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 static LIST_HEAD(container_list);
 static DEFINE_MUTEX(container_list_lock);
diff --git a/drivers/misc/ics932s401.c b/drivers/misc/ics932s401.c
index 395a4ea..152e9d9 100644
--- a/drivers/misc/ics932s401.c
+++ b/drivers/misc/ics932s401.c
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/log2.h>
+#include <linux/slab.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = { 0x69, I2C_CLIENT_END };
diff --git a/drivers/misc/iwmc3200top/debugfs.c b/drivers/misc/iwmc3200top/debugfs.c
index 0c8ea0a..0561079 100644
--- a/drivers/misc/iwmc3200top/debugfs.c
+++ b/drivers/misc/iwmc3200top/debugfs.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio.h>
 #include <linux/debugfs.h>
diff --git a/drivers/misc/iwmc3200top/fw-download.c b/drivers/misc/iwmc3200top/fw-download.c
index 9dbaeb5..0606813 100644
--- a/drivers/misc/iwmc3200top/fw-download.c
+++ b/drivers/misc/iwmc3200top/fw-download.c
@@ -24,6 +24,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <linux/firmware.h>
 #include <linux/mmc/sdio_func.h>
 #include <asm/unaligned.h>
diff --git a/drivers/misc/iwmc3200top/log.c b/drivers/misc/iwmc3200top/log.c
index d569279..692cb1e 100644
--- a/drivers/misc/iwmc3200top/log.c
+++ b/drivers/misc/iwmc3200top/log.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include "fw-msg.h"
 #include "iwmc3200top.h"
 #include "log.h"
diff --git a/drivers/misc/iwmc3200top/main.c b/drivers/misc/iwmc3200top/main.c
index 3b7292a..e8fb655 100644
--- a/drivers/misc/iwmc3200top/main.c
+++ b/drivers/misc/iwmc3200top/main.c
@@ -28,6 +28,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio.h>
diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 4a06483..31a9911 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
+#include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/debugfs.h>
 
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 832ed4c..ba82c4f 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -50,6 +50,7 @@
 #include <linux/reboot.h>
 #include <linux/kdebug.h>
 #include <linux/kthread.h>
+#include <linux/slab.h>
 #include "xpc.h"
 
 /* define two XPC debug device structures to be used with dev_dbg() et al */
diff --git a/drivers/misc/sgi-xp/xpc_partition.c b/drivers/misc/sgi-xp/xpc_partition.c
index 9a6268c..d551f09 100644
--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
@@ -17,6 +17,7 @@
 
 #include <linux/device.h>
 #include <linux/hardirq.h>
+#include <linux/slab.h>
 #include "xpc.h"
 #include <asm/uv/uv_hub.h>
 
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index 8725d5e..1f59ee2 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <asm/uv/uv_hub.h>
 #if defined CONFIG_X86_64
 #include <asm/uv/bios.h>
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1f552c6..f1f4251 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -30,6 +30,7 @@
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
index e7f8027..4b6b5c9 100644
--- a/drivers/mmc/card/mmc_test.c
+++ b/drivers/mmc/card/mmc_test.c
@@ -15,6 +15,7 @@
 #include <linux/mmc/mmc.h>
 
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #define RESULT_OK		0
 #define RESULT_FAIL		1
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 381fe03..d094399 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -14,6 +14,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 723e508..21b0f30 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -33,6 +33,7 @@
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/serial_reg.h>
+#include <linux/slab.h>
 #include <linux/circ_buf.h>
 #include <linux/gfp.h>
 #include <linux/tty.h>
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index bdb165f..49d9dca 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff --git a/drivers/mmc/core/debugfs.c b/drivers/mmc/core/debugfs.c
index 96d10f4..99220e9 100644
--- a/drivers/mmc/core/debugfs.c
+++ b/drivers/mmc/core/debugfs.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/stat.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index a268d12..4735390 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -16,6 +16,7 @@
 #include <linux/idr.h>
 #include <linux/pagemap.h>
 #include <linux/leds.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/host.h>
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 0eac6c8..e15feed 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index d2cb5c6..693f038 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index fdd414e..5eac21d 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 9e060c8..4a890dc 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 9538389..541bdb8 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d6ab62d..f618845 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include <linux/leds.h>
 
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 89bf8cd..69efe01 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -34,6 +34,7 @@
 #include <linux/highmem.h>
 #include <linux/mmc/host.h>
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 8c295f4..ce64240 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -17,6 +17,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mutex.h>
 #include <linux/mount.h>
+#include <linux/slab.h>
 
 #define ERROR(fmt, args...) printk(KERN_ERR "block2mtd: " fmt "\n" , ## args)
 #define INFO(fmt, args...) printk(KERN_INFO "block2mtd: " fmt "\n" , ## args)
diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index e22ca49..19a4660 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -24,6 +24,7 @@
  * Implement XIP support
  * Implement OTP support
  */
+#include <linux/slab.h>
 #include <linux/mtd/pfow.h>
 #include <linux/mtd/qinfo.h>
 
diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index 1ad5caf..a1c34a4 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index b126cf8..47067bc 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/rslib.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 
 #include <linux/mtd/mtd.h>
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index f63b1db..3888806 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
+#include <linux/slab.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/onenand.h>
 #include <linux/mtd/partitions.h>
diff --git a/drivers/mtd/onenand/onenand_sim.c b/drivers/mtd/onenand/onenand_sim.c
index f6e3c8a..b455b6b 100644
--- a/drivers/mtd/onenand/onenand_sim.c
+++ b/drivers/mtd/onenand/onenand_sim.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
diff --git a/drivers/mtd/tests/mtd_oobtest.c b/drivers/mtd/tests/mtd_oobtest.c
index 5813920..ecbb5a6 100644
--- a/drivers/mtd/tests/mtd_oobtest.c
+++ b/drivers/mtd/tests/mtd_oobtest.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #define PRINT_PREF KERN_INFO "mtd_oobtest: "
 
diff --git a/drivers/mtd/tests/mtd_pagetest.c b/drivers/mtd/tests/mtd_pagetest.c
index ce17cbe..4df4c82 100644
--- a/drivers/mtd/tests/mtd_pagetest.c
+++ b/drivers/mtd/tests/mtd_pagetest.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #define PRINT_PREF KERN_INFO "mtd_pagetest: "
 
diff --git a/drivers/mtd/tests/mtd_readtest.c b/drivers/mtd/tests/mtd_readtest.c
index 25c5dd0..81d1197 100644
--- a/drivers/mtd/tests/mtd_readtest.c
+++ b/drivers/mtd/tests/mtd_readtest.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #define PRINT_PREF KERN_INFO "mtd_readtest: "
 
diff --git a/drivers/mtd/tests/mtd_speedtest.c b/drivers/mtd/tests/mtd_speedtest.c
index 7fbb51d..2300b41 100644
--- a/drivers/mtd/tests/mtd_speedtest.c
+++ b/drivers/mtd/tests/mtd_speedtest.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #define PRINT_PREF KERN_INFO "mtd_speedtest: "
 
diff --git a/drivers/mtd/tests/mtd_stresstest.c b/drivers/mtd/tests/mtd_stresstest.c
index a99d3cd..624bcea 100644
--- a/drivers/mtd/tests/mtd_stresstest.c
+++ b/drivers/mtd/tests/mtd_stresstest.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 
 #define PRINT_PREF KERN_INFO "mtd_stresstest: "
diff --git a/drivers/mtd/tests/mtd_subpagetest.c b/drivers/mtd/tests/mtd_subpagetest.c
index 5b88972..795e2a1 100644
--- a/drivers/mtd/tests/mtd_subpagetest.c
+++ b/drivers/mtd/tests/mtd_subpagetest.c
@@ -25,6 +25,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #define PRINT_PREF KERN_INFO "mtd_subpagetest: "
 
diff --git a/drivers/mtd/tests/mtd_torturetest.c b/drivers/mtd/tests/mtd_torturetest.c
index 631a0ab..262762c 100644
--- a/drivers/mtd/tests/mtd_torturetest.c
+++ b/drivers/mtd/tests/mtd_torturetest.c
@@ -29,6 +29,7 @@
 #include <linux/err.h>
 #include <linux/mtd/mtd.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #define PRINT_PREF KERN_INFO "mtd_torturetest: "
 #define RETRIES 3
diff --git a/drivers/mtd/ubi/gluebi.c b/drivers/mtd/ubi/gluebi.c
index b5e478f..99a221a 100644
--- a/drivers/mtd/ubi/gluebi.c
+++ b/drivers/mtd/ubi/gluebi.c
@@ -35,6 +35,7 @@
 #include <linux/math64.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/mtd/ubi.h>
 #include <linux/mtd/mtd.h>
 #include "ubi-media.h"
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 1af0817..659c4c2 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -35,6 +35,7 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/notifier.h>
 #include <linux/mtd/mtd.h>
diff --git a/drivers/net/phy/fixed.c b/drivers/net/phy/fixed.c
index e707051..1fa4d73 100644
--- a/drivers/net/phy/fixed.c
+++ b/drivers/net/phy/fixed.c
@@ -20,6 +20,7 @@
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #define MII_REGS_NUM 29
 
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index bece33e..f75415a 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -23,6 +23,7 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 6f1dba5..609465c 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -23,6 +23,7 @@
 #include <linux/param.h>
 #include <linux/jiffies.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index da14f37..d67ac69 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -18,6 +18,7 @@
 #include <linux/swab.h>
 #include <linux/i2c.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <linux/power_supply.h>
 
 #define DS2782_REG_RARC		0x06	/* Remaining active relative capacity */
diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 87b98bf..8fe4b52 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -17,6 +17,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/power_supply.h>
 #include <linux/max17040_battery.h>
 
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index ea3fdfa..d28fba8 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -20,6 +20,7 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/sysfs.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 2dece40..fd5d111 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/power_supply.h>
 
 #include "power_supply.h"
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index ff05e61..5b6e352 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -13,6 +13,7 @@
 
 #include <linux/ctype.h>
 #include <linux/power_supply.h>
+#include <linux/slab.h>
 
 #include "power_supply.h"
 
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 2d414e2..1aa02db 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -29,6 +29,7 @@
 #include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
+#include <linux/slab.h>
 
 /*
  * Global variables
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c7bbe30..0976147 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -20,6 +20,7 @@
 #include <linux/mutex.h>
 #include <linux/suspend.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index d11f762..2fe9d99 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -25,6 +25,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 struct fixed_voltage_data {
 	struct regulator_desc desc;
diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index f5532ed..cbe34bb 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/lp3971.h>
 
diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index a49fc95..aad5bae 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -19,6 +19,7 @@
  */
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 3ebdf69..6fe3a9e 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
diff --git a/drivers/regulator/max8660.c b/drivers/regulator/max8660.c
index f12f1bb..95f40c6 100644
--- a/drivers/regulator/max8660.c
+++ b/drivers/regulator/max8660.c
@@ -39,6 +39,7 @@
 
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index f7b8184..2feb4ca 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #define MC13783_REG_SWITCHERS5			29
 #define MC13783_REG_SWITCHERS5_SW3EN			(1 << 20)
diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 1f18354..8e2f209 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -24,6 +24,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 /* Register definitions */
 #define	TPS65023_REG_VERSION		0
diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index c2a9539..74841ab 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -24,6 +24,7 @@
 #include <linux/regulator/machine.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 /* Register definitions */
 #define	TPS6507X_REG_PPATH1				0X01
diff --git a/drivers/regulator/userspace-consumer.c b/drivers/regulator/userspace-consumer.c
index 44917da..558e8a5 100644
--- a/drivers/regulator/userspace-consumer.c
+++ b/drivers/regulator/userspace-consumer.c
@@ -18,6 +18,7 @@
 
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/userspace-consumer.h>
diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index d96ceca..f6b42ec 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -13,6 +13,7 @@
 
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 95454a4..4b0dcf7 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/gpio.h>
diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 40845c7..565562b 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -15,6 +15,7 @@
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 
 #include "rtc-core.h"
 
diff --git a/drivers/rtc/rtc-bq4802.c b/drivers/rtc/rtc-bq4802.c
index 280fe48..d1d6ffe 100644
--- a/drivers/rtc/rtc-bq4802.c
+++ b/drivers/rtc/rtc-bq4802.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 4fcb16b..7059fd7 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 5317bbc..6194573 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -24,6 +24,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 #define DS1374_REG_TOD0		0x00 /* Time of Day */
 #define DS1374_REG_TOD1		0x01
diff --git a/drivers/rtc/rtc-fm3130.c b/drivers/rtc/rtc-fm3130.c
index 812c667..1f25211 100644
--- a/drivers/rtc/rtc-fm3130.c
+++ b/drivers/rtc/rtc-fm3130.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-m48t35.c b/drivers/rtc/rtc-m48t35.c
index 8cb5b89..440091d 100644
--- a/drivers/rtc/rtc-m48t35.c
+++ b/drivers/rtc/rtc-m48t35.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index ede43b8..82a2f4b 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
diff --git a/drivers/rtc/rtc-mc13783.c b/drivers/rtc/rtc-mc13783.c
index d60c81b..4d687eb 100644
--- a/drivers/rtc/rtc-mc13783.c
+++ b/drivers/rtc/rtc-mc13783.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/rtc.h>
 
 #define DRIVER_NAME "mc13783-rtc"
diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index 5f5968a..04de7f4 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index a99c289..be9e362 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -15,6 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/mfd/ezx-pcap.h>
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index 854c3cb..240733a 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -22,6 +22,7 @@
 #include <linux/rtc.h>
 #include <linux/bcd.h>
 #include <linux/err.h>
+#include <linux/slab.h>
 
 #include <linux/mfd/pcf50633/core.h>
 
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 65f346b..9dc97d9 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -14,6 +14,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/bcd.h>
 #include <linux/rtc.h>
diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index e1313fe..945c98c 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -10,6 +10,7 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/rtc.h>
 
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 2f2c68d..4ad2b96 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index b1a29bc..55d85a3 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/bcd.h>
 #include <linux/i2c.h>
 #include <linux/list.h>
diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index bed4cab..f71c3ce 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -28,6 +28,7 @@
 #include <linux/rtc-v3020.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 
 #include <linux/io.h>
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index fe11c1d..4799d43 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/smp_lock.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index e19a1a5..6fae3d2 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -21,6 +21,7 @@
  *               Mike Anderson <andmike@linux.vnet.ibm.com>
  */
 
+#include <linux/slab.h>
 #include <scsi/scsi_dh.h>
 #include "../scsi_priv.h"
 
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index bc9e94f..1a970a7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -19,6 +19,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6196675..9d5db8b 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -20,6 +20,7 @@
  * along with this program; see the file COPYING.  If not, write to
  * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 857fdd6..e391664 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -21,6 +21,7 @@
  * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 1a66019..5b683e4 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -23,6 +23,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 #define RDAC_NAME "rdac"
 #define RDAC_RETRY_COUNT 5
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 09dbcb8..b4eda28 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -31,6 +31,7 @@
 #include <linux/completion.h>
 #include <linux/transport_class.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 2277516..3141094 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -22,6 +22,7 @@
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2359d0b..6185fc4 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -23,6 +23,7 @@
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2422347..da94743 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -39,6 +39,7 @@
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
+#include <linux/slab.h>
 #include <scsi/osd_initiator.h>
 #include <scsi/osd_sec.h>
 #include <scsi/osd_attributes.h>
diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index 0a90702..ffdd9fd 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -50,6 +50,7 @@
 #include <linux/idr.h>
 #include <linux/major.h>
 #include <linux/file.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_driver.h>
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4bc8b77..38518b0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -33,6 +33,7 @@
 #include <linux/kthread.h>
 #include <linux/spinlock.h>
 #include <linux/async.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 19ec9e2..c40743c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 1030327..66241dd 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -23,6 +23,7 @@
 #include <linux/hash.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c25bd9a..8a172d4 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -25,6 +25,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/slab.h>
 #include <scsi/scsi.h>
 #include "scsi_priv.h"
 #include <scsi/scsi_device.h>
diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index 3f21bc6..721e7f3 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 
 #include <scsi/scsicam.h>
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 83881df..87f2dca 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -49,6 +49,7 @@
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <linux/async.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0d9d6f7..f014483 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/enclosure.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d6f340f..0a90abc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 291236e..cbb38c5 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -7,6 +7,7 @@
 #include <linux/blkpg.h>
 #include <linux/cdrom.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/scsi/sr_vendor.c b/drivers/scsi/sr_vendor.c
index 4ad3e01..92cc2ef 100644
--- a/drivers/scsi/sr_vendor.c
+++ b/drivers/scsi/sr_vendor.c
@@ -39,6 +39,7 @@
 #include <linux/string.h>
 #include <linux/bcd.h>
 #include <linux/blkdev.h>
+#include <linux/slab.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f67d1a1..83a66ec 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -39,6 +39,7 @@ static const char *verstr = "20081215";
 #include <linux/delay.h>
 #include <linux/mutex.h>
 #include <linux/smp_lock.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c3db16b..2b1ea3d 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -38,6 +38,7 @@
 #include <linux/serial_8250.h>
 #include <linux/nmi.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5066de5..4d22bc8 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -31,6 +31,7 @@
 #include <linux/thermal.h>
 #include <linux/spinlock.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 
 MODULE_AUTHOR("Zhang Rui");
 MODULE_DESCRIPTION("Generic thermal management sysfs support");
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 4de382a..e550e88 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -22,6 +22,7 @@
 #include <linux/sched.h>
 #include <linux/string.h>
 #include <linux/kobject.h>
+#include <linux/slab.h>
 #include <linux/uio_driver.h>
 
 #define UIO_MAX_DEVICES 255
diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index d494ce9..7d3e469 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/uio_driver.h>
 #include <linux/stringify.h>
+#include <linux/slab.h>
 
 #define DRIVER_NAME "uio_pdrv"
 
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 1ef3b8f..61e569d 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/stringify.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #define DRIVER_NAME "uio_pdrv_genirq"
 
diff --git a/drivers/usb/c67x00/c67x00-drv.c b/drivers/usb/c67x00/c67x00-drv.c
index 029ee4a..b6d4923 100644
--- a/drivers/usb/c67x00/c67x00-drv.c
+++ b/drivers/usb/c67x00/c67x00-drv.c
@@ -37,6 +37,7 @@
 #include <linux/device.h>
 #include <linux/io.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/c67x00.h>
 
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index 85dfe29..f6b3c25 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/kthread.h>
+#include <linux/slab.h>
 
 #include "c67x00.h"
 #include "c67x00-hcd.h"
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 8588c09..484eec8 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -26,6 +26,7 @@
 #include <linux/uaccess.h>
 #include <linux/kref.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/tmc.h>
 
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index f3c2338..14bc4fe 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -26,6 +26,7 @@
 #include <linux/usb.h>
 #include <linux/usb/quirks.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 #include "hcd.h"
 #include "usb.h"
 
diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index d26b9ea..0629820 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -13,6 +13,7 @@
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include "usb.h"
 
 struct ep_device {
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index c3536f1..1648f43 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -20,6 +20,7 @@
 #include <linux/rwsem.h>
 #include <linux/smp_lock.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 
 #include "usb.h"
 
diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index a62af7b..cf34d9e 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -12,6 +12,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/utsname.h>
 
 #include "u_audio.h"
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index a2b3054..92de71d 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -62,6 +62,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/isp116x.h>
 #include <linux/platform_device.h>
diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index bee558a..cdc8c0b 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -37,6 +37,7 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/irq.h>
+#include <linux/slab.h>
 #include <asm/cacheflush.h>
 
 #include "../core/hcd.h"
diff --git a/drivers/usb/host/xhci-hcd.c b/drivers/usb/host/xhci-hcd.c
index 4cb69e0..5d3f47e 100644
--- a/drivers/usb/host/xhci-hcd.c
+++ b/drivers/usb/host/xhci-hcd.c
@@ -23,6 +23,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 
 #include "xhci.h"
 
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 6ba841b..85d7e8f 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -65,6 +65,7 @@
  */
 
 #include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include "xhci.h"
 
 /*
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 4d2952f..eba0088 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -28,6 +28,7 @@
 #include <linux/backlight.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 
 #define APPLE_VENDOR_ID		0x05AC
diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 1547d8c..2f43c57 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -32,6 +32,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 #define DRIVER_AUTHOR		"Oliver Bock (bock@tfh-berlin.de)"
diff --git a/drivers/usb/misc/cytherm.c b/drivers/usb/misc/cytherm.c
index b9cbbbd..cccefe1 100644
--- a/drivers/usb/misc/cytherm.c
+++ b/drivers/usb/misc/cytherm.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 #define DRIVER_VERSION "v1.0"
diff --git a/drivers/usb/misc/isight_firmware.c b/drivers/usb/misc/isight_firmware.c
index 06e990a..fe1d443 100644
--- a/drivers/usb/misc/isight_firmware.c
+++ b/drivers/usb/misc/isight_firmware.c
@@ -25,6 +25,7 @@
 #include <linux/firmware.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(0x05ac, 0x8300)},
diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
index 5da28ea..6e7b0ea 100644
--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -23,6 +23,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 /* Version Information */
diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index af456b4..f3778fb 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -27,6 +27,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/usb/otg.h>
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 365db10..2a633a5 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -42,6 +42,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/circ_buf.h>
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index 547c944..fc37607 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -28,6 +28,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/serial.h>
diff --git a/drivers/usb/serial/bus.c b/drivers/usb/serial/bus.c
index ba555c5..50bc4c9 100644
--- a/drivers/usb/serial/bus.c
+++ b/drivers/usb/serial/bus.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/tty.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 9f4fed1..7e8e398 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/tty.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/serial.h>
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index 701452a..188c3c7 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -19,6 +19,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 static int debug;
 
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 847b805..a36d2de 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -39,6 +39,7 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index 34e6f89..42bca40 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -28,6 +28,7 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
diff --git a/drivers/usb/serial/symbolserial.c b/drivers/usb/serial/symbolserial.c
index ee190cc..d1f6957 100644
--- a/drivers/usb/serial/symbolserial.c
+++ b/drivers/usb/serial/symbolserial.c
@@ -15,6 +15,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/uaccess.h>
diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
index 6971713..c3fd712 100644
--- a/drivers/usb/storage/usb.h
+++ b/drivers/usb/storage/usb.h
@@ -47,6 +47,7 @@
 #include <linux/blkdev.h>
 #include <linux/completion.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <scsi/scsi_host.h>
 
 struct us_data;
diff --git a/drivers/usb/wusbcore/cbaf.c b/drivers/usb/wusbcore/cbaf.c
index 51a8e0d..c6f6907 100644
--- a/drivers/usb/wusbcore/cbaf.c
+++ b/drivers/usb/wusbcore/cbaf.c
@@ -93,6 +93,7 @@
 #include <linux/delay.h>
 #include <linux/random.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/uwb.h>
 #include <linux/usb/wusb.h>
 #include <linux/usb/association.h>
diff --git a/drivers/usb/wusbcore/wusbhc.h b/drivers/usb/wusbcore/wusbhc.h
index 759cda5..55685a8 100644
--- a/drivers/usb/wusbcore/wusbhc.h
+++ b/drivers/usb/wusbcore/wusbhc.h
@@ -58,6 +58,7 @@
 #include <linux/mutex.h>
 #include <linux/kref.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 /* FIXME: Yes, I know: BAD--it's not my fault the USB HC iface is not
  *        public */
 #include <linux/../../drivers/usb/core/hcd.h>
diff --git a/drivers/uwb/allocator.c b/drivers/uwb/allocator.c
index c13cec7..436e4f7 100644
--- a/drivers/uwb/allocator.c
+++ b/drivers/uwb/allocator.c
@@ -16,6 +16,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/uwb.h>
 
 #include "uwb-internal.h"
diff --git a/drivers/uwb/beacon.c b/drivers/uwb/beacon.c
index 36bc315..dcdd59b 100644
--- a/drivers/uwb/beacon.c
+++ b/drivers/uwb/beacon.c
@@ -28,6 +28,7 @@
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/kdev_t.h>
+#include <linux/slab.h>
 
 #include "uwb-internal.h"
 
diff --git a/drivers/uwb/drp-ie.c b/drivers/uwb/drp-ie.c
index 2840d7b..5206731 100644
--- a/drivers/uwb/drp-ie.c
+++ b/drivers/uwb/drp-ie.c
@@ -18,6 +18,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/random.h>
+#include <linux/slab.h>
 #include <linux/uwb.h>
 
 #include "uwb-internal.h"
diff --git a/drivers/uwb/drp.c b/drivers/uwb/drp.c
index 4f5ca99..ef8aeaa 100644
--- a/drivers/uwb/drp.c
+++ b/drivers/uwb/drp.c
@@ -21,6 +21,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include "uwb-internal.h"
 
 
diff --git a/drivers/uwb/est.c b/drivers/uwb/est.c
index 328fcc2..a2eaa3c 100644
--- a/drivers/uwb/est.c
+++ b/drivers/uwb/est.c
@@ -40,6 +40,7 @@
  *   uwb_est_get_size()
  */
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 
 #include "uwb-internal.h"
 
diff --git a/drivers/uwb/i1480/dfu/mac.c b/drivers/uwb/i1480/dfu/mac.c
index 694d0da..bf2366c 100644
--- a/drivers/uwb/i1480/dfu/mac.c
+++ b/drivers/uwb/i1480/dfu/mac.c
@@ -27,6 +27,7 @@
  * function pointers to push the firmware to the device.
  */
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/firmware.h>
 #include <linux/uwb.h>
 #include "i1480-dfu.h"
diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index 0bb665a..004fa6a 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -38,6 +38,7 @@
 #include <linux/usb.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/uwb.h>
 #include <linux/usb/wusb.h>
 #include <linux/usb/wusb-wa.h>
diff --git a/drivers/uwb/uwb-internal.h b/drivers/uwb/uwb-internal.h
index 157485c..aa766df 100644
--- a/drivers/uwb/uwb-internal.h
+++ b/drivers/uwb/uwb-internal.h
@@ -33,6 +33,7 @@
 #include <linux/device.h>
 #include <linux/uwb.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 struct uwb_beca_e;
 
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 18829cf..d70a4f0 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/fb.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 #include <asm/backlight.h>
diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 9b3be74..71a11ca 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -13,6 +13,7 @@
 #include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/fb.h>
+#include <linux/slab.h>
 
 #if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
 			   defined(CONFIG_LCD_CLASS_DEVICE_MODULE))
diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 738694d..9509adb 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -12,6 +12,7 @@
 */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 6b7c8fb..03d3259 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -15,6 +15,7 @@
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
+#include <linux/slab.h>
 #include <asm/types.h>
 #include "fbcon.h"
 
diff --git a/drivers/video/console/fbcon_ccw.c b/drivers/video/console/fbcon_ccw.c
index bdf913e..cf4018a 100644
--- a/drivers/video/console/fbcon_ccw.c
+++ b/drivers/video/console/fbcon_ccw.c
@@ -10,6 +10,7 @@
 
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
diff --git a/drivers/video/console/fbcon_cw.c b/drivers/video/console/fbcon_cw.c
index a6819b9..041f2ca 100644
--- a/drivers/video/console/fbcon_cw.c
+++ b/drivers/video/console/fbcon_cw.c
@@ -10,6 +10,7 @@
 
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
diff --git a/drivers/video/console/fbcon_rotate.c b/drivers/video/console/fbcon_rotate.c
index 00884e0..61486f1 100644
--- a/drivers/video/console/fbcon_rotate.c
+++ b/drivers/video/console/fbcon_rotate.c
@@ -10,6 +10,7 @@
 
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
diff --git a/drivers/video/console/fbcon_ud.c b/drivers/video/console/fbcon_ud.c
index d9b5d6e..14ca71a 100644
--- a/drivers/video/console/fbcon_ud.c
+++ b/drivers/video/console/fbcon_ud.c
@@ -10,6 +10,7 @@
 
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/vt_kern.h>
 #include <linux/console.h>
diff --git a/drivers/video/display/display-sysfs.c b/drivers/video/display/display-sysfs.c
index 80abbf3..f6a09ab 100644
--- a/drivers/video/display/display-sysfs.c
+++ b/drivers/video/display/display-sysfs.c
@@ -27,6 +27,7 @@
 #include <linux/idr.h>
 #include <linux/err.h>
 #include <linux/kdev_t.h>
+#include <linux/slab.h>
 
 static ssize_t display_show_name(struct device *dev,
 				struct device_attribute *attr, char *buf)
diff --git a/drivers/video/fb_ddc.c b/drivers/video/fb_ddc.c
index 0cf96eb..840314a 100644
--- a/drivers/video/fb_ddc.c
+++ b/drivers/video/fb_ddc.c
@@ -8,6 +8,7 @@
  * for more details.
  */
 
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/fb.h>
diff --git a/drivers/video/fbcvt.c b/drivers/video/fbcvt.c
index 0847c5e..7293eac 100644
--- a/drivers/video/fbcvt.c
+++ b/drivers/video/fbcvt.c
@@ -13,6 +13,7 @@
  *
  */
 #include <linux/fb.h>
+#include <linux/slab.h>
 
 #define FB_CVT_CELLSIZE               8
 #define FB_CVT_GTF_C                 40
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index d4a2c11..ea5f0a5 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -19,6 +19,7 @@
 #include <linux/fb.h>
 #include <linux/console.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #define FB_SYSFS_FLAG_ATTR 1
 
diff --git a/drivers/video/modedb.c b/drivers/video/modedb.c
index b895aae..eb4dd41 100644
--- a/drivers/video/modedb.c
+++ b/drivers/video/modedb.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/fb.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 
 #undef DEBUG
 
diff --git a/drivers/video/output.c b/drivers/video/output.c
index 5137aa0..639c7e4 100644
--- a/drivers/video/output.c
+++ b/drivers/video/output.c
@@ -25,6 +25,7 @@
 #include <linux/video_output.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
+#include <linux/slab.h>
 
 
 MODULE_DESCRIPTION("Display Output Switcher Lowlevel Control Abstraction");
diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index 7b63429..a6247fc 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -31,6 +31,7 @@
 #include <linux/fb.h>
 #include <linux/spinlock_types.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 
 #include <asm/io.h>
 
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 603598f..0d139bd 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 
 #include <asm/xen/hypervisor.h>
 
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 369f2ee..3aed388 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -24,6 +24,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 
 struct virtio_balloon
 {
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 0db906b..0f90634 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -20,6 +20,7 @@
 #include <linux/virtio_ring.h>
 #include <linux/virtio_config.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 
 /* virtio guest is communicating with a virtual "device" that actually runs on
  * a host processor.  Memory barriers are used to control SMP effects. */
diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 59ad6e9..6700902 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/mod_devicetable.h>
 #include <linux/usb.h>
 
diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 6f8866d..340d86d 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -10,6 +10,7 @@
 
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/w1-gpio.h>
 
diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 1394471..d2bf321 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -13,6 +13,7 @@
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #ifdef CONFIG_W1_SLAVE_DS2433_CRC
 #include <linux/crc16.h>
 
diff --git a/drivers/watchdog/max63xx_wdt.c b/drivers/watchdog/max63xx_wdt.c
index 6eb91d7..75f3a83 100644
--- a/drivers/watchdog/max63xx_wdt.c
+++ b/drivers/watchdog/max63xx_wdt.c
@@ -28,6 +28,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 
 #define DEFAULT_HEARTBEAT 60
 #define MAX_HEARTBEAT     60
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 2f84137..db8f506 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -27,6 +27,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq.h>
diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 4c6c0bd..f66db3b 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -34,6 +34,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 5d42d55..e3f45f0 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -7,6 +7,7 @@
 #include <linux/sysrq.h>
 #include <linux/stop_machine.h>
 #include <linux/freezer.h>
+#include <linux/slab.h>
 
 #include <xen/xenbus.h>
 #include <xen/grant_table.h>
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index bb71ab2..3b9a72d 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kobject.h>
+#include <linux/slab.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 92a1ef8..cb78baf 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <asm/xen/hypervisor.h>
 #include <xen/interface/xen.h>
diff --git a/drivers/xen/xenfs/xenbus.c b/drivers/xen/xenfs/xenbus.c
index 6c4269b..f28ece3 100644
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenfs/xenbus.c
@@ -51,6 +51,7 @@
 #include <linux/init.h>
 #include <linux/namei.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 #include "xenfs.h"
 #include "../xenbus/xenbus_comms.h"
diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index e777961..9af0af1 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -25,6 +25,7 @@
 #include <linux/stat.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 
 #include "v9fs.h"
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 08b2eb1..1197704 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 6c7f6a2..cb57d33 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -29,6 +29,7 @@
 #include <linux/sched.h>
 #include <linux/parser.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include <net/9p/transport.h>
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index d743252..cbf4e50 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -34,6 +34,7 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index d8a3afe..909711f 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/inet.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 5fe45d6..63c2b5a 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -34,6 +34,7 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 69357c0..a271549 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -37,6 +37,7 @@
 #include <linux/mount.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 
diff --git a/fs/adfs/super.c b/fs/adfs/super.c
index 6910a98..4a3af70 100644
--- a/fs/adfs/super.c
+++ b/fs/adfs/super.c
@@ -13,6 +13,7 @@
 #include <linux/parser.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/statfs.h>
 #include "adfs.h"
diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index 861dae6..7482fbb 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -4,6 +4,7 @@
 #include <linux/amigaffs.h>
 #include <linux/mutex.h>
 
+
 /* AmigaOS allows file names with up to 30 characters length.
  * Names longer than that will be silently truncated. If you
  * want to disallow this, comment out the following #define.
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index 8306d53..3e26271 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -7,6 +7,7 @@
  *  block allocation, deallocation, calculation of free space.
  */
 
+#include <linux/slab.h>
 #include "affs.h"
 
 /* This is, of course, shamelessly stolen from fs/minix */
diff --git a/fs/affs/super.c b/fs/affs/super.c
index d41e967..16a3e47 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -17,6 +17,7 @@
 #include <linux/magic.h>
 #include <linux/sched.h>
 #include <linux/smp_lock.h>
+#include <linux/slab.h>
 #include "affs.h"
 
 extern struct timezone sys_tz;
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index a16f29e..612a5c3 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -24,6 +24,7 @@
 #include <linux/mempool.h>
 #include <linux/bio.h>
 #include <linux/workqueue.h>
+#include <linux/slab.h>
 
 struct integrity_slab {
 	struct kmem_cache *slab;
diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c0861e7..c01c527 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/freezer.h>
+#include <linux/slab.h>
 #include "async-thread.h"
 
 #define WORK_QUEUED_BIT 0
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8b5cfdd..7881b72 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -26,6 +26,7 @@
 #include <linux/completion.h>
 #include <linux/backing-dev.h>
 #include <linux/wait.h>
+#include <linux/slab.h>
 #include <asm/kmap_types.h>
 #include "extent_io.h"
 #include "extent_map.h"
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index f8b4521..aebdca2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -38,6 +38,7 @@
 #include <linux/namei.h>
 #include <linux/miscdevice.h>
 #include <linux/magic.h>
+#include <linux/slab.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
diff --git a/fs/ecryptfs/dentry.c b/fs/ecryptfs/dentry.c
index 8f006a0..906e803 100644
--- a/fs/ecryptfs/dentry.c
+++ b/fs/ecryptfs/dentry.c
@@ -26,6 +26,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/fs_stack.h>
+#include <linux/slab.h>
 #include "ecryptfs_kernel.h"
 
 /**
diff --git a/fs/ecryptfs/kthread.c b/fs/ecryptfs/kthread.c
index e14cf7e..3f4b764 100644
--- a/fs/ecryptfs/kthread.c
+++ b/fs/ecryptfs/kthread.c
@@ -24,6 +24,7 @@
 #include <linux/freezer.h>
 #include <linux/wait.h>
 #include <linux/mount.h>
+#include <linux/slab.h>
 #include "ecryptfs_kernel.h"
 
 struct kmem_cache *ecryptfs_open_req_cache;
diff --git a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
index f1c17e8..a5f43e0 100644
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -22,6 +22,7 @@
 #include <linux/sched.h>
 #include <linux/user_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/slab.h>
 #include "ecryptfs_kernel.h"
 
 static LIST_HEAD(ecryptfs_msg_ctx_free_list);
diff --git a/fs/ecryptfs/miscdev.c b/fs/ecryptfs/miscdev.c
index 4ec8f61..afa95ca 100644
--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -26,6 +26,7 @@
 #include <linux/poll.h>
 #include <linux/wait.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "ecryptfs_kernel.h"
 
 static atomic_t ecryptfs_num_miscdev_opens;
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 7758cc3..2a4760d 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -17,6 +17,7 @@
 #include <linux/syscalls.h>
 #include <linux/module.h>
 #include <linux/kref.h>
+#include <linux/slab.h>
 #include <linux/eventfd.h>
 
 struct eventfd_ctx {
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index a17e4b7..6b37f39 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -33,6 +33,7 @@
 
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include <scsi/scsi_device.h>
 
 #include "exofs.h"
diff --git a/fs/exofs/ios.c b/fs/exofs/ios.c
index 5293bc4..4337cad 100644
--- a/fs/exofs/ios.c
+++ b/fs/exofs/ios.c
@@ -22,6 +22,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/slab.h>
 #include <scsi/scsi_device.h>
 #include <asm/div64.h>
 
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 6cf5e4e..18e57ea 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -37,6 +37,7 @@
 #include <linux/vfs.h>
 #include <linux/random.h>
 #include <linux/exportfs.h>
+#include <linux/slab.h>
 
 #include "exofs.h"
 
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 1d081f0..653771c 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/buffer_head.h>
 #include <linux/capability.h>
+#include <linux/slab.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 923990e..2bfafce 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -10,6 +10,7 @@
 
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include "fat.h"
 
 /* this must be > 0. */
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index e6efdfa..696186a 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -6,6 +6,7 @@
 #include <linux/nls.h>
 #include <linux/fs.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/msdos_fs.h>
 
 /*
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 76fc4d5..77ef7c0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -25,6 +25,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 #define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
diff --git a/fs/fscache/object-list.c b/fs/fscache/object-list.c
index 3221a0c..eac6f88 100644
--- a/fs/fscache/object-list.c
+++ b/fs/fscache/object-list.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/key.h>
+#include <linux/slab.h>
 #include <keys/user-type.h>
 #include "internal.h"
 
diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
index 313e79a..261cec3 100644
--- a/fs/fscache/operation.c
+++ b/fs/fscache/operation.c
@@ -14,6 +14,7 @@
 #define FSCACHE_DEBUG_LEVEL OPERATION
 #include <linux/module.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 atomic_t fscache_op_debug_id;
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index c598ea4..4f6ed50 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -14,6 +14,7 @@
 #include <linux/fscache-cache.h>
 #include <linux/buffer_head.h>
 #include <linux/pagevec.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 /*
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index de792dc..e1f8171 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -44,6 +44,7 @@
 #include <linux/magic.h>
 #include <linux/miscdevice.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 569b462..7810810 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -11,6 +11,7 @@
 #include <linux/dlm.h>
 #include <linux/types.h>
 #include <linux/gfs2_ondisk.h>
+#include <linux/slab.h>
 
 #include "incore.h"
 #include "glock.h"
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 3fcbb0e..572628b 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -15,6 +15,7 @@
 #include <linux/nls.h>
 #include <linux/mount.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 #include "hfsplus_fs.h"
 
 enum {
diff --git a/fs/libfs.c b/fs/libfs.c
index 9e50bcf..17b4579 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -11,6 +11,7 @@
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 
diff --git a/fs/logfs/logfs.h b/fs/logfs/logfs.h
index 1297794..76f5fd2 100644
--- a/fs/logfs/logfs.h
+++ b/fs/logfs/logfs.h
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/mempool.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 #include <linux/mtd/mtd.h>
 #include "logfs_abi.h"
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index e9795f1..1ab9745 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -29,6 +29,7 @@
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/slab.h>
 #include "sb.h"
 
 /* the_nilfs struct */
diff --git a/fs/ntfs/ntfs.h b/fs/ntfs/ntfs.h
index d6a340b..4e623eb 100644
--- a/fs/ntfs/ntfs.h
+++ b/fs/ntfs/ntfs.h
@@ -32,6 +32,7 @@
 #include <linux/nls.h>
 #include <linux/smp.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 
 #include "types.h"
 #include "volume.h"
diff --git a/fs/ocfs2/stack_o2cb.c b/fs/ocfs2/stack_o2cb.c
index 7020e12..2f93fb9 100644
--- a/fs/ocfs2/stack_o2cb.c
+++ b/fs/ocfs2/stack_o2cb.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/crc32.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 /* Needed for AOP_TRUNCATED_PAGE in mlog_errno() */
 #include <linux/fs.h>
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 5ae8812..cda3264 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/smp_lock.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 
 #include "stackglue.h"
diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 75d9b5b..e2951a0 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/vfs.h>
 #include <linux/parser.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/writeback.h>
 #include <linux/crc-itu-t.h>
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a6090aa..c948534 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -35,6 +35,7 @@
 #include <linux/sched.h>
 #include <linux/parser.h>
 #include <linux/magic.h>
+#include <linux/slab.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 1dabe4e..8244713 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -28,6 +28,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/signalfd.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 
 struct signalfd_ctx {
 	sigset_t sigmask;
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index 4dd70e0..49feaa1 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -25,6 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/zlib.h>
+#include <linux/slab.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
diff --git a/fs/sync.c b/fs/sync.c
index f557d71..5419f9b 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -13,6 +13,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
+#include <linux/slab.h>
 #include "internal.h"
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 082daae..8ec3f48 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
+#include <linux/slab.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 0cb1088..7761378 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/magic.h>
+#include <linux/slab.h>
 
 #include "sysfs.h"
 
diff --git a/fs/timerfd.c b/fs/timerfd.c
index 1bfc95a..ef946ad 100644
--- a/fs/timerfd.c
+++ b/fs/timerfd.c
@@ -21,6 +21,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/timerfd.h>
 #include <linux/syscalls.h>
+#include <linux/slab.h>
 
 struct timerfd_ctx {
 	struct hrtimer tmr;
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index b2d9763..9526434 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -35,6 +35,7 @@
 #include <linux/mtd/ubi.h>
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
+#include <linux/slab.h>
 #include "ubifs-media.h"
 
 /* Version of this UBIFS implementation */
diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
index cefa8c8..d03a90b 100644
--- a/fs/udf/unicode.c
+++ b/fs/udf/unicode.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>	/* for memset */
 #include <linux/nls.h>
 #include <linux/crc-itu-t.h>
+#include <linux/slab.h>
 
 #include "udf_sb.h"
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index df8fd9a..0175590 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -15,6 +15,7 @@
 #include <linux/inotify.h>
 #include <linux/fsnotify_backend.h>
 #include <linux/audit.h>
+#include <linux/slab.h>
 
 /*
  * fsnotify_d_instantiate - instantiate a dentry for inode
diff --git a/include/linux/gameport.h b/include/linux/gameport.h
index 48e68da..361d1cc 100644
--- a/include/linux/gameport.h
+++ b/include/linux/gameport.h
@@ -16,6 +16,7 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/timer.h>
+#include <linux/slab.h>
 
 struct gameport {
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index f3aa59c..516a2a2 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/lockdep.h>
+#include <linux/slab.h>
 
 #define journal_oom_retry 1
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 1ec8763..a4d2e9f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -30,6 +30,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
+#include <linux/slab.h>
 #endif
 
 #define journal_oom_retry 1
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a3fd0f9..c206a96 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/preempt.h>
 #include <linux/msi.h>
+#include <linux/slab.h>
 #include <asm/signal.h>
 
 #include <linux/kvm.h>
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index a93e5bf..cf1db53 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -2,7 +2,6 @@
 #define __LINUX_PERCPU_H
 
 #include <linux/preempt.h>
-#include <linux/slab.h> /* For kmalloc() */
 #include <linux/smp.h>
 #include <linux/cpumask.h>
 #include <linux/pfn.h>
@@ -135,8 +134,6 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
 
 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
-extern void __percpu *__alloc_percpu(size_t size, size_t align);
-extern void free_percpu(void __percpu *__pdata);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 
 #ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
@@ -147,22 +144,6 @@ extern void __init setup_per_cpu_areas(void);
 
 #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); (ptr); })
 
-static inline void __percpu *__alloc_percpu(size_t size, size_t align)
-{
-	/*
-	 * Can't easily make larger alignment work with kmalloc.  WARN
-	 * on it.  Larger alignment should only be used for module
-	 * percpu sections on SMP for which this path isn't used.
-	 */
-	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return kzalloc(size, GFP_KERNEL);
-}
-
-static inline void free_percpu(void __percpu *p)
-{
-	kfree(p);
-}
-
 static inline phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
 	return __pa(addr);
@@ -177,6 +158,9 @@ static inline void *pcpu_lpage_remapped(void *kaddr)
 
 #endif /* CONFIG_SMP */
 
+extern void __percpu *__alloc_percpu(size_t size, size_t align);
+extern void free_percpu(void __percpu *__pdata);
+
 #define alloc_percpu(type)	\
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type), __alignof__(type))
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 233d20b..fefdcc3 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -34,6 +34,7 @@
 #include <linux/key.h>
 #include <linux/xfrm.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 97b60b3..af56071 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -21,6 +21,7 @@
 
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/slab.h>
 
 /*
  * INTERFACES between SPI master-side drivers and SPI infrastructure.
diff --git a/include/linux/taskstats_kern.h b/include/linux/taskstats_kern.h
index b6523c1..58de6ed 100644
--- a/include/linux/taskstats_kern.h
+++ b/include/linux/taskstats_kern.h
@@ -9,6 +9,7 @@
 
 #include <linux/taskstats.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #ifdef CONFIG_TASKSTATS
 extern struct kmem_cache *taskstats_cache;
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index bbf45d5..f4b7ca5 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -15,6 +15,8 @@
 #ifndef __LINUX_USB_GADGET_H
 #define __LINUX_USB_GADGET_H
 
+#include <linux/slab.h>
+
 struct usb_ep;
 
 /**
diff --git a/kernel/async.c b/kernel/async.c
index 27235f5..15319d6 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -56,6 +56,7 @@ asynchronous and synchronous parts of the kernel.
 #include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <asm/atomic.h>
 
 static async_cookie_t next_cookie = 1;
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 59e9ef6..32c97d8 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -20,6 +20,7 @@
 #include <linux/uaccess.h>
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 
 enum freezer_state {
 	CGROUP_THAWED = 0,
diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 963559d..65d3845 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/irq.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/interrupt.h>
diff --git a/kernel/padata.c b/kernel/padata.c
index 93caf65..19210f7 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/rcupdate.h>
+#include <linux/slab.h>
 
 #define MAX_SEQ_NR INT_MAX - NR_CPUS
 #define MAX_OBJ_NUM 10000 * NR_CPUS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 4393b9e..cf04571 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <linux/file.h>
 #include <linux/poll.h>
+#include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/dcache.h>
 #include <linux/percpu.h>
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 79aac93..a5aff94 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -13,6 +13,7 @@
 #include <linux/syscalls.h>
 #include <linux/err.h>
 #include <linux/acct.h>
+#include <linux/slab.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
diff --git a/kernel/power/hibernate_nvs.c b/kernel/power/hibernate_nvs.c
index 39ac698..fdcad9e 100644
--- a/kernel/power/hibernate_nvs.c
+++ b/kernel/power/hibernate_nvs.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/suspend.h>
 
 /*
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 830cade..be861c2 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -26,6 +26,7 @@
 #include <linux/console.h>
 #include <linux/highmem.h>
 #include <linux/list.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 1d57573..66824d7 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -23,6 +23,7 @@
 #include <linux/swap.h>
 #include <linux/swapops.h>
 #include <linux/pm.h>
+#include <linux/slab.h>
 
 #include "power.h"
 
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index fccf9fb..e6871cb 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -27,6 +27,7 @@
  *  of the License.
  */
 
+#include <linux/gfp.h>
 #include "sched_cpupri.h"
 
 /* Convert between a 140 based task->prio, and our 102 based cpupri */
diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
index 12f5c55..bb0e4ec 100644
--- a/kernel/time/timecompare.c
+++ b/kernel/time/timecompare.c
@@ -20,6 +20,7 @@
 #include <linux/timecompare.h>
 #include <linux/module.h>
 #include <linux/math64.h>
+#include <linux/slab.h>
 
 /*
  * fixed point arithmetic scale factor for skew
diff --git a/kernel/timer.c b/kernel/timer.c
index c61a794..7287997 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -39,6 +39,7 @@
 #include <linux/kallsyms.h>
 #include <linux/perf_event.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2825ef2..a33fd83 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -12,6 +12,7 @@
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
 #include <linux/hw_breakpoint.h>
+#include <linux/slab.h>
 
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
diff --git a/lib/cpumask.c b/lib/cpumask.c
index 7bb4142..f8e2f13 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -3,6 +3,7 @@
 #include <linux/cpumask.h>
 #include <linux/module.h>
 #include <linux/bootmem.h>
+#include <linux/slab.h>
 
 int __first_cpu(const cpumask_t *srcp)
 {
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index a9a8996..ddf490f 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/hash.h>
+#include <linux/slab.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
diff --git a/lib/genalloc.c b/lib/genalloc.c
index e67f974..afbca48 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/bitmap.h>
+#include <linux/slab.h>
 #include <linux/genalloc.h>
 
 
diff --git a/lib/kasprintf.c b/lib/kasprintf.c
index c5ff1fd..638c809 100644
--- a/lib/kasprintf.c
+++ b/lib/kasprintf.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 /* Simplified asprintf. */
 char *kvasprintf(gfp_t gfp, const char *fmt, va_list ap)
diff --git a/lib/kref.c b/lib/kref.c
index 9ecd6e8..6d19f69 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -13,6 +13,7 @@
 
 #include <linux/kref.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 /**
  * kref_set - initialize object and set refcount to requested number.
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 0d475d8..840e3c1 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/highmem.h>
+#include <linux/slab.h>
 
 /**
  * sg_next - return the next scatterlist entry in a list
diff --git a/mm/Makefile b/mm/Makefile
index 7a68d2a..e149afa 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o mmu_context.o \
+			   page_isolation.o mm_init.o mmu_context.o percpu.o \
 			   $(mmu-y)
 obj-y += init-mm.o
 
@@ -33,7 +33,6 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-obj-$(CONFIG_SMP) += percpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
diff --git a/mm/bootmem.c b/mm/bootmem.c
index d7c791e..5cc2cac 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kmemleak.h>
 #include <linux/range.h>
+#include <linux/slab.h>
 
 #include <asm/bug.h>
 #include <asm/io.h>
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 7e33f2c..438951d 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 
 /*
  * This function can't run concurrently against mmu_notifier_register
diff --git a/mm/percpu.c b/mm/percpu.c
index 768419d..9114099 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -54,6 +54,11 @@
  *   setup the first chunk containing the kernel static percpu area
  */
 
+#include <linux/percpu.h>
+#include <linux/slab.h>
+
+#ifdef CONFIG_SMP
+
 #include <linux/bitmap.h>
 #include <linux/bootmem.h>
 #include <linux/err.h>
@@ -62,7 +67,6 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
-#include <linux/percpu.h>
 #include <linux/pfn.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -2132,3 +2136,25 @@ void __init setup_per_cpu_areas(void)
 		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
 }
 #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
+
+#else  /* CONFIG_SMP */
+
+void __percpu *__alloc_percpu(size_t size, size_t align)
+{
+	/*
+	 * Can't easily make larger alignment work with kmalloc.  WARN
+	 * on it.  Larger alignment should only be used for module
+	 * percpu sections on SMP for which this path isn't used.
+	 */
+	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
+	return kzalloc(size, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(__alloc_percpu);
+
+void free_percpu(void __percpu *p)
+{
+	kfree(p);
+}
+EXPORT_SYMBOL_GPL(free_percpu);
+
+#endif /* CONFIG_SMP */
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 392b9bb..6deb37c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -23,6 +23,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
 #include <asm/dma.h>
diff --git a/mm/sparse.c b/mm/sparse.c
index 22896d5..685d6d3 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -7,6 +7,7 @@
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include "internal.h"
 #include <asm/dma.h>
diff --git a/net/9p/client.c b/net/9p/client.c
index e3e5bf4..4e36335 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <linux/parser.h>
 #include <net/9p/client.h>
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 94f5a8f..7049581 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/sched.h>
 #include <linux/types.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 #include <net/9p/client.h>
 #include "protocol.h"
diff --git a/net/9p/util.c b/net/9p/util.c
index dc4ec05..e048701 100644
--- a/net/9p/util.c
+++ b/net/9p/util.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/parser.h>
 #include <linux/idr.h>
+#include <linux/slab.h>
 #include <net/9p/9p.h>
 
 /**
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index c218e07..a9fa86f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -33,6 +33,7 @@
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
+#include <linux/slab.h>
 
 #include "rfkill.h"
 
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 8bd690c..1f29e3d 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/sunrpc/xdr.h>
 #include <linux/sunrpc/msg_prot.h>
 
diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index 3b126d1..0392ea0 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -12,6 +12,7 @@
 #include <linux/sysfs.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 
 /*
  * This module shows how to create a kset in sysfs called
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 6cf8fd2..1cac7fa 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -12,6 +12,7 @@
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2
diff --git a/security/tomoyo/common.h b/security/tomoyo/common.h
index 67bd22d..31a69ee 100644
--- a/security/tomoyo/common.h
+++ b/security/tomoyo/common.h
@@ -20,6 +20,7 @@
 #include <linux/mount.h>
 #include <linux/list.h>
 #include <linux/cred.h>
+#include <linux/slab.h>
 struct linux_binprm;
 
 /********** Constants definitions. **********/
diff --git a/sound/core/hrtimer.c b/sound/core/hrtimer.c
index 7f4d744..41fff15 100644
--- a/sound/core/hrtimer.c
+++ b/sound/core/hrtimer.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/hrtimer.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/timer.h>
 
diff --git a/sound/core/jack.c b/sound/core/jack.c
index f705eec..14b8a4e 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <sound/jack.h>
 #include <sound/core.h>
 
diff --git a/sound/core/misc.c b/sound/core/misc.c
index 3da4f92..5b89574 100644
--- a/sound/core/misc.c
+++ b/sound/core/misc.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/ioport.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 
 #ifdef CONFIG_SND_DEBUG
diff --git a/sound/core/pcm_memory.c b/sound/core/pcm_memory.c
index d6d49d6..af2ad16 100644
--- a/sound/core/pcm_memory.c
+++ b/sound/core/pcm_memory.c
@@ -23,6 +23,7 @@
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/core/seq/seq_system.c b/sound/core/seq/seq_system.c
index 77884e6..c38b90c 100644
--- a/sound/core/seq/seq_system.c
+++ b/sound/core/seq/seq_system.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include "seq_system.h"
 #include "seq_timer.h"
diff --git a/sound/drivers/opl3/opl3_synth.c b/sound/drivers/opl3/opl3_synth.c
index 6d57b64..301acb6 100644
--- a/sound/drivers/opl3/opl3_synth.c
+++ b/sound/drivers/opl3/opl3_synth.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <sound/opl3.h>
 #include <sound/asound_fm.h>
 
diff --git a/sound/drivers/serial-u16550.c b/sound/drivers/serial-u16550.c
index a25fb7b..af72a55 100644
--- a/sound/drivers/serial-u16550.c
+++ b/sound/drivers/serial-u16550.c
@@ -37,6 +37,7 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/rawmidi.h>
 #include <sound/initval.h>
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index c4c6ef7..9b6fa56 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -25,6 +25,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/version.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/tea575x-tuner.h>
 
diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index 49d572a..156cb9b 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index 91d7036..6ed880d 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/pci/hda/hda_eld.c b/sound/pci/hda/hda_eld.c
index dcd2244..7444bfb 100644
--- a/sound/pci/hda/hda_eld.c
+++ b/sound/pci/hda/hda_eld.c
@@ -23,6 +23,7 @@
 
 #include <linux/init.h>
 #include <sound/core.h>
+#include <linux/slab.h>
 #include <asm/unaligned.h>
 #include "hda_codec.h"
 #include "hda_local.h"
diff --git a/sound/pci/ice1712/ak4xxx.c b/sound/pci/ice1712/ak4xxx.c
index 03391da..ae98407 100644
--- a/sound/pci/ice1712/ak4xxx.c
+++ b/sound/pci/ice1712/ak4xxx.c
@@ -25,6 +25,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include "ice1712.h"
diff --git a/sound/soc/codecs/ad73311.c b/sound/soc/codecs/ad73311.c
index d2fcc60..c9e579c 100644
--- a/sound/soc/codecs/ad73311.c
+++ b/sound/soc/codecs/ad73311.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/ac97_codec.h>
diff --git a/sound/soc/codecs/ads117x.c b/sound/soc/codecs/ads117x.c
index cc96411..a2c4ce1 100644
--- a/sound/soc/codecs/ads117x.c
+++ b/sound/soc/codecs/ads117x.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index ff96656..352d1d0 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -19,6 +19,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 3ef16bb..729859c 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -29,6 +29,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index 82fca28..926797a 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
 #include <sound/initval.h>
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index dfbeb2d..81a62d1 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/soc.h>
 #include <sound/initval.h>
diff --git a/sound/soc/codecs/da7210.c b/sound/soc/codecs/da7210.c
index cf2975a..366daf1 100644
--- a/sound/soc/codecs/da7210.c
+++ b/sound/soc/codecs/da7210.c
@@ -23,6 +23,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/pcm3008.c b/sound/soc/codecs/pcm3008.c
index 2afcd0a..5a5f187 100644
--- a/sound/soc/codecs/pcm3008.c
+++ b/sound/soc/codecs/pcm3008.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index d2ff1cd..29d0906 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -33,6 +33,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index da589d8..776b79c 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -25,6 +25,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index e4b946a..4a6d56c 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -39,6 +39,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index f9f367d..072d8f3 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -30,6 +30,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/tpa6130a2.c b/sound/soc/codecs/tpa6130a2.c
index 958d49c..db9c3ad 100644
--- a/sound/soc/codecs/tpa6130a2.c
+++ b/sound/soc/codecs/tpa6130a2.c
@@ -25,6 +25,7 @@
 #include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/gpio.h>
+#include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <sound/tpa6130a2-plat.h>
 #include <sound/soc.h>
diff --git a/sound/soc/codecs/uda134x.c b/sound/soc/codecs/uda134x.c
index 3e99fe5..a8dcd5a 100644
--- a/sound/soc/codecs/uda134x.c
+++ b/sound/soc/codecs/uda134x.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
diff --git a/sound/soc/codecs/wm2000.c b/sound/soc/codecs/wm2000.c
index 217b026..a34cbcf 100644
--- a/sound/soc/codecs/wm2000.c
+++ b/sound/soc/codecs/wm2000.c
@@ -32,6 +32,7 @@
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index b432f4d..b0b7423 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <linux/mfd/wm8400-audio.h>
 #include <linux/mfd/wm8400-private.h>
diff --git a/sound/soc/codecs/wm8523.c b/sound/soc/codecs/wm8523.c
index d3a61d7..9aebf19 100644
--- a/sound/soc/codecs/wm8523.c
+++ b/sound/soc/codecs/wm8523.c
@@ -15,6 +15,7 @@
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index d077df6..6174858 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
diff --git a/sound/soc/codecs/wm8727.c b/sound/soc/codecs/wm8727.c
index 63a254e..3710791 100644
--- a/sound/soc/codecs/wm8727.c
+++ b/sound/soc/codecs/wm8727.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/ac97_codec.h>
diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index dbc368c..b7fd96a 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -24,6 +24,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 3595bd5..3ede27c 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 593e47d..feab2ce 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -18,6 +18,7 @@
 #include <linux/pm.h>
 #include <linux/i2c.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8955.c b/sound/soc/codecs/wm8955.c
index 615dab2..593201d 100644
--- a/sound/soc/codecs/wm8955.c
+++ b/sound/soc/codecs/wm8955.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <sound/core.h>
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index d07bcc1..36152b9 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index d2342c5..b7d71b1 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8971.c b/sound/soc/codecs/wm8971.c
index d9540d5..1338265 100644
--- a/sound/soc/codecs/wm8971.c
+++ b/sound/soc/codecs/wm8971.c
@@ -19,6 +19,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index ee637af..9165a25 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index 28bb59e..5a1877e 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 056b787..295c7e4 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 29f3771..efbb206 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <sound/core.h>
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index c468497..ea06a10 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/pm.h>
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index c8b0556..2320153 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -28,6 +28,7 @@
 #include <linux/bitops.h>
 #include <linux/debugfs.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <sound/ac97_codec.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 6c33510..7c28f40 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -38,6 +38,7 @@
 #include <linux/platform_device.h>
 #include <linux/jiffies.h>
 #include <linux/debugfs.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
diff --git a/sound/usb/caiaq/audio.c b/sound/usb/caiaq/audio.c
index 86b2c3b..11963fa 100644
--- a/sound/usb/caiaq/audio.c
+++ b/sound/usb/caiaq/audio.c
@@ -19,6 +19,7 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 
diff --git a/sound/usb/usx2y/us122l.c b/sound/usb/usx2y/us122l.c
index 44deb21..e801d44 100644
--- a/sound/usb/usx2y/us122l.c
+++ b/sound/usb/usx2y/us122l.c
@@ -18,6 +18,7 @@
 
 #include <linux/usb.h>
 #include <linux/usb/audio.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/hwdep.h>
 #include <sound/pcm.h>
diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index 1879b72..e5c9568 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -22,6 +22,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/memalloc.h>
 #include <sound/pcm.h>
diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index c42350e..acf1daa 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -135,6 +135,7 @@
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/initval.h>
 #include <sound/pcm.h>
diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index 74a67a8..bbd9b44 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -33,6 +33,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/pcm.h>


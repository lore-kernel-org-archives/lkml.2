Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab0FSSYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 14:24:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60641 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab0FSSYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 14:24:22 -0400
Date: Sat, 19 Jun 2010 20:24:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [RFC] use kexec_kernel.h for the kernel-only stuff [Was: [PATCH]
	Export kexec.h]
Message-ID: <20100619182419.GA22079@merkur.ravnborg.org>
References: <20100619132235.GA24200@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619132235.GA24200@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 03:22:35PM +0200, Andi Kleen wrote:
> Export kexec.h
>     
> kexec_load is a system call and it needs a header
> file with its input arguments.
> 
> Export the parts of kexec.h needed for this.

Rather than introducing yet another file where
only a fraction is exported how about a split
where we put the kernel specific definitions in kexec_kernel.h.
And kexec.h is the userspace interface (which is included
by kexec_kernel.h).

We did it like this for pps some time ago.

Patch is trivial - appended below.

	Sam

>From 2a560e5dbf4774a97db671f2d2813e02fb007ad8 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 19 Jun 2010 20:11:59 +0200
Subject: [PATCH] kexec: export kexec.h to userspace

kexec_load is a system call and it needs a header
file with its input arguments.

Split kexec.h in two parts:
kexec.h - the userspace visible definitions
kexec_kernel.h - the kernel definitions

Fix up all files that include kexec.h to include kexec_kernel.h
In a few cases an unused include was dropped.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Biederman <ebiederm@xmission.com>
---
 MAINTAINERS                                   |    1 +
 arch/arm/kernel/machine_kexec.c               |    2 +-
 arch/arm/kernel/traps.c                       |    2 +-
 arch/ia64/kernel/crash.c                      |    2 +-
 arch/ia64/kernel/efi.c                        |    2 +-
 arch/ia64/kernel/machine_kexec.c              |    2 +-
 arch/ia64/kernel/setup.c                      |    2 +-
 arch/ia64/kernel/smp.c                        |    2 +-
 arch/ia64/mm/init.c                           |    2 +-
 arch/microblaze/kernel/prom.c                 |    2 +-
 arch/mips/kernel/machine_kexec.c              |    2 +-
 arch/powerpc/kernel/crash.c                   |    2 +-
 arch/powerpc/kernel/machine_kexec.c           |    2 +-
 arch/powerpc/kernel/machine_kexec_32.c        |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c        |    2 +-
 arch/powerpc/kernel/prom.c                    |    2 +-
 arch/powerpc/kernel/traps.c                   |    2 +-
 arch/powerpc/platforms/cell/ras.c             |    2 +-
 arch/powerpc/platforms/embedded6xx/gamecube.c |    2 +-
 arch/powerpc/platforms/embedded6xx/wii.c      |    2 +-
 arch/powerpc/platforms/iseries/setup.c        |    2 +-
 arch/s390/kernel/crash.c                      |    2 +-
 arch/s390/kernel/machine_kexec.c              |    2 +-
 arch/sh/kernel/machine_kexec.c                |    2 +-
 arch/sh/kernel/reboot.c                       |    2 +-
 arch/sh/kernel/setup.c                        |    2 +-
 arch/sh/kernel/traps_32.c                     |    2 +-
 arch/x86/kernel/crash.c                       |    2 +-
 arch/x86/kernel/dumpstack.c                   |    2 +-
 arch/x86/kernel/dumpstack_32.c                |    1 -
 arch/x86/kernel/dumpstack_64.c                |    1 -
 arch/x86/kernel/machine_kexec_32.c            |    2 +-
 arch/x86/kernel/machine_kexec_64.c            |    2 +-
 arch/x86/kernel/setup.c                       |    2 +-
 arch/x86/kernel/setup_percpu.c                |    1 -
 arch/x86/kernel/traps.c                       |    1 -
 arch/x86/mm/numa_32.c                         |    1 -
 drivers/base/cpu.c                            |    2 +-
 include/linux/Kbuild                          |    1 +
 include/linux/crash_dump.h                    |    1 -
 include/linux/kexec.h                         |  200 ++-----------------------
 include/linux/kexec_kernel.h                  |  193 ++++++++++++++++++++++++
 init/initramfs.c                              |    2 +-
 kernel/kexec.c                                |    2 +-
 kernel/ksysfs.c                               |    2 +-
 kernel/panic.c                                |    2 +-
 kernel/printk.c                               |    2 +-
 kernel/sys.c                                  |    2 +-
 48 files changed, 243 insertions(+), 234 deletions(-)
 create mode 100644 include/linux/kexec_kernel.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 6d119c9..d14fb89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3326,6 +3326,7 @@ W:	http://ftp.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
+F:	include/linux/kexec_kernel.h
 F:	kernel/kexec.c
 
 KEYS/KEYRINGS:
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 598ca61..c5ac5b3 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -3,7 +3,7 @@
  */
 
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/io.h>
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 1621e53..b01edc8 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -20,7 +20,7 @@
 #include <linux/hardirq.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 
diff --git a/arch/ia64/kernel/crash.c b/arch/ia64/kernel/crash.c
index b942f40..0566d49 100644
--- a/arch/ia64/kernel/crash.c
+++ b/arch/ia64/kernel/crash.c
@@ -12,7 +12,7 @@
 #include <linux/delay.h>
 #include <linux/crash_dump.h>
 #include <linux/bootmem.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/elfcore.h>
 #include <linux/sysctl.h>
 #include <linux/init.h>
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index a0f0019..c74e94a 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include <linux/time.h>
 #include <linux/efi.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/mm.h>
 
 #include <asm/io.h>
diff --git a/arch/ia64/kernel/machine_kexec.c b/arch/ia64/kernel/machine_kexec.c
index 3d3aeef..5ac58da 100644
--- a/arch/ia64/kernel/machine_kexec.c
+++ b/arch/ia64/kernel/machine_kexec.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/cpu.h>
 #include <linux/irq.h>
 #include <linux/efi.h>
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 41ae6a5..f37a646 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -43,7 +43,7 @@
 #include <linux/initrd.h>
 #include <linux/pm.h>
 #include <linux/cpufreq.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/crash_dump.h>
 
 #include <asm/machvec.h>
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index dabeefe..248a43c 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -30,7 +30,7 @@
 #include <linux/delay.h>
 #include <linux/efi.h>
 #include <linux/bitops.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 
 #include <asm/atomic.h>
 #include <asm/current.h>
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index ed41759..b478826 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -19,7 +19,7 @@
 #include <linux/swap.h>
 #include <linux/proc_fs.h>
 #include <linux/bitops.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 
 #include <asm/dma.h>
 #include <asm/io.h>
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index a15ef6d..31ea314 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -26,7 +26,7 @@
 #include <linux/initrd.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/lmb.h>
diff --git a/arch/mips/kernel/machine_kexec.c b/arch/mips/kernel/machine_kexec.c
index 85beb9b..973739d 100644
--- a/arch/mips/kernel/machine_kexec.c
+++ b/arch/mips/kernel/machine_kexec.c
@@ -6,7 +6,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/mm.h>
 #include <linux/delay.h>
 
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index b46f2e0..a3010bc 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -15,7 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/reboot.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/bootmem.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
index bb3d893..801e964 100644
--- a/arch/powerpc/kernel/machine_kexec.c
+++ b/arch/powerpc/kernel/machine_kexec.c
@@ -9,7 +9,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/reboot.h>
 #include <linux/threads.h>
 #include <linux/lmb.h>
diff --git a/arch/powerpc/kernel/machine_kexec_32.c b/arch/powerpc/kernel/machine_kexec_32.c
index ae63a96..95085a1 100644
--- a/arch/powerpc/kernel/machine_kexec_32.c
+++ b/arch/powerpc/kernel/machine_kexec_32.c
@@ -9,7 +9,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <asm/cacheflush.h>
diff --git a/arch/powerpc/kernel/machine_kexec_64.c b/arch/powerpc/kernel/machine_kexec_64.c
index 26f9900..038b871 100644
--- a/arch/powerpc/kernel/machine_kexec_64.c
+++ b/arch/powerpc/kernel/machine_kexec_64.c
@@ -10,7 +10,7 @@
  */
 
 
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/smp.h>
 #include <linux/thread_info.h>
 #include <linux/init_task.h>
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 05131d6..8dec91d 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -28,7 +28,7 @@
 #include <linux/initrd.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/debugfs.h>
 #include <linux/irq.h>
 #include <linux/lmb.h>
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 25fc339..e82321d 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -29,7 +29,7 @@
 #include <linux/prctl.h>
 #include <linux/delay.h>
 #include <linux/kprobes.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/backlight.h>
 #include <linux/bug.h>
 #include <linux/kdebug.h>
diff --git a/arch/powerpc/platforms/cell/ras.c b/arch/powerpc/platforms/cell/ras.c
index 1d3c4ef..2839cbd 100644
--- a/arch/powerpc/platforms/cell/ras.c
+++ b/arch/powerpc/platforms/cell/ras.c
@@ -14,7 +14,7 @@
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/reboot.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/crash_dump.h>
 
 #include <asm/kexec.h>
diff --git a/arch/powerpc/platforms/embedded6xx/gamecube.c b/arch/powerpc/platforms/embedded6xx/gamecube.c
index 1106fd9..6b51478 100644
--- a/arch/powerpc/platforms/embedded6xx/gamecube.c
+++ b/arch/powerpc/platforms/embedded6xx/gamecube.c
@@ -15,7 +15,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/irq.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
diff --git a/arch/powerpc/platforms/embedded6xx/wii.c b/arch/powerpc/platforms/embedded6xx/wii.c
index 174a04a..8a46583 100644
--- a/arch/powerpc/platforms/embedded6xx/wii.c
+++ b/arch/powerpc/platforms/embedded6xx/wii.c
@@ -18,7 +18,7 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/seq_file.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/of_platform.h>
 #include <linux/lmb.h>
 #include <mm/mmu_decl.h>
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index b086341..370891a 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -23,7 +23,7 @@
 #include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/kdev_t.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/major.h>
 #include <linux/root_dev.h>
 #include <linux/kernel.h>
diff --git a/arch/s390/kernel/crash.c b/arch/s390/kernel/crash.c
index 8cc7c9f..6bd969a 100644
--- a/arch/s390/kernel/crash.c
+++ b/arch/s390/kernel/crash.c
@@ -8,7 +8,7 @@
  */
 
 #include <linux/threads.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/reboot.h>
 
 void machine_crash_shutdown(struct pt_regs *regs)
diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index a922d51..ebfbc82 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -9,7 +9,7 @@
 
 #include <linux/device.h>
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <asm/cio.h>
diff --git a/arch/sh/kernel/machine_kexec.c b/arch/sh/kernel/machine_kexec.c
index 5a559e6..18ba90d 100644
--- a/arch/sh/kernel/machine_kexec.c
+++ b/arch/sh/kernel/machine_kexec.c
@@ -9,7 +9,7 @@
  * Version 2.  See the file COPYING for more details.
  */
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/numa.h>
diff --git a/arch/sh/kernel/reboot.c b/arch/sh/kernel/reboot.c
index b1fca66..b53bc7a 100644
--- a/arch/sh/kernel/reboot.c
+++ b/arch/sh/kernel/reboot.c
@@ -1,5 +1,5 @@
 #include <linux/pm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/kernel.h>
 #include <linux/reboot.h>
 #include <linux/module.h>
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 2727346..a2edc3e 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -20,7 +20,7 @@
 #include <linux/pfn.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/module.h>
 #include <linux/smp.h>
 #include <linux/err.h>
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index c3d86fa..7c9b26b 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -22,7 +22,7 @@
 #include <linux/bug.h>
 #include <linux/debug_locks.h>
 #include <linux/kdebug.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/limits.h>
 #include <linux/sysfs.h>
 #include <linux/uaccess.h>
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index ebd4c51..fac1068 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -12,7 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/smp.h>
 #include <linux/reboot.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/delay.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c89a386..3988f4f 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -2,6 +2,7 @@
  *  Copyright (C) 1991, 1992  Linus Torvalds
  *  Copyright (C) 2000, 2001, 2002 Andi Kleen, SuSE Labs
  */
+#include <linux/kexec_kernel.h>
 #include <linux/kallsyms.h>
 #include <linux/kprobes.h>
 #include <linux/uaccess.h>
@@ -11,7 +12,6 @@
 #include <linux/module.h>
 #include <linux/ptrace.h>
 #include <linux/ftrace.h>
-#include <linux/kexec.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
 #include <linux/sysfs.h>
diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 11540a1..624ccc5 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -9,7 +9,6 @@
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
-#include <linux/kexec.h>
 #include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 272c9f1..5fa1079 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -9,7 +9,6 @@
 #include <linux/kdebug.h>
 #include <linux/module.h>
 #include <linux/ptrace.h>
-#include <linux/kexec.h>
 #include <linux/sysfs.h>
 #include <linux/bug.h>
 #include <linux/nmi.h>
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index a3fa43b..11d6464 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -7,7 +7,7 @@
  */
 
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/numa.h>
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 035c8c5..faa23cd 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -7,7 +7,7 @@
  */
 
 #include <linux/mm.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/string.h>
 #include <linux/gfp.h>
 #include <linux/reboot.h>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b4ae4ac..202c206 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -42,7 +42,7 @@
 #include <linux/edd.h>
 #include <linux/iscsi_ibft.h>
 #include <linux/nodemask.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/dmi.h>
 #include <linux/pfn.h>
 #include <linux/pci.h>
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index de3b63a..2204da2 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -5,7 +5,6 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/percpu.h>
-#include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/smp.h>
 #include <linux/topology.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 142d70c..22d9552 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -22,7 +22,6 @@
 #include <linux/string.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
-#include <linux/kexec.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/init.h>
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 809baaa..66bf642 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -29,7 +29,6 @@
 #include <linux/initrd.h>
 #include <linux/nodemask.h>
 #include <linux/module.h>
-#include <linux/kexec.h>
 #include <linux/pfn.h>
 #include <linux/swap.h>
 #include <linux/acpi.h>
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 251acea..f67a55a 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -107,7 +107,7 @@ static inline void register_cpu_control(struct cpu *cpu)
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #ifdef CONFIG_KEXEC
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 
 static ssize_t show_crash_notes(struct sys_device *dev, struct sysdev_attribute *attr,
 				char *buf)
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 2fc8e14..f58f3db 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -106,6 +106,7 @@ header-y += irda.h
 header-y += iso_fs.h
 header-y += ixjuser.h
 header-y += jffs2.h
+header-y += kexec.h
 header-y += keyctl.h
 header-y += limits.h
 header-y += magic.h
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 0026f26..e76e88e 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -2,7 +2,6 @@
 #define LINUX_CRASH_DUMP_H
 
 #ifdef CONFIG_CRASH_DUMP
-#include <linux/kexec.h>
 #include <linux/device.h>
 #include <linux/proc_fs.h>
 
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 03e8e8d..7d3da01 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -1,168 +1,9 @@
 #ifndef LINUX_KEXEC_H
 #define LINUX_KEXEC_H
 
-#ifdef CONFIG_KEXEC
-#include <linux/types.h>
-#include <linux/list.h>
-#include <linux/linkage.h>
-#include <linux/compat.h>
-#include <linux/ioport.h>
-#include <linux/elfcore.h>
-#include <linux/elf.h>
-#include <asm/kexec.h>
-
-/* Verify architecture specific macros are defined */
-
-#ifndef KEXEC_SOURCE_MEMORY_LIMIT
-#error KEXEC_SOURCE_MEMORY_LIMIT not defined
-#endif
-
-#ifndef KEXEC_DESTINATION_MEMORY_LIMIT
-#error KEXEC_DESTINATION_MEMORY_LIMIT not defined
-#endif
-
-#ifndef KEXEC_CONTROL_MEMORY_LIMIT
-#error KEXEC_CONTROL_MEMORY_LIMIT not defined
-#endif
-
-#ifndef KEXEC_CONTROL_PAGE_SIZE
-#error KEXEC_CONTROL_PAGE_SIZE not defined
-#endif
-
-#ifndef KEXEC_ARCH
-#error KEXEC_ARCH not defined
-#endif
-
-#define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
-#define KEXEC_CORE_NOTE_NAME "CORE"
-#define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
-#define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
-/*
- * The per-cpu notes area is a list of notes terminated by a "NULL"
- * note header.  For kdump, the code in vmcore.c runs in the context
- * of the second kernel to combine them into one note.
- */
-#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
-			    KEXEC_CORE_NOTE_NAME_BYTES +		\
-			    KEXEC_CORE_NOTE_DESC_BYTES )
-
 /*
- * This structure is used to hold the arguments that are used when loading
- * kernel binaries.
+ * Kexec: one kernel loading another
  */
-
-typedef unsigned long kimage_entry_t;
-#define IND_DESTINATION  0x1
-#define IND_INDIRECTION  0x2
-#define IND_DONE         0x4
-#define IND_SOURCE       0x8
-
-#define KEXEC_SEGMENT_MAX 16
-struct kexec_segment {
-	void __user *buf;
-	size_t bufsz;
-	unsigned long mem;	/* User space sees this as a (void *) ... */
-	size_t memsz;
-};
-
-#ifdef CONFIG_COMPAT
-struct compat_kexec_segment {
-	compat_uptr_t buf;
-	compat_size_t bufsz;
-	compat_ulong_t mem;	/* User space sees this as a (void *) ... */
-	compat_size_t memsz;
-};
-#endif
-
-struct kimage {
-	kimage_entry_t head;
-	kimage_entry_t *entry;
-	kimage_entry_t *last_entry;
-
-	unsigned long destination;
-
-	unsigned long start;
-	struct page *control_code_page;
-	struct page *swap_page;
-
-	unsigned long nr_segments;
-	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
-
-	struct list_head control_pages;
-	struct list_head dest_pages;
-	struct list_head unuseable_pages;
-
-	/* Address of next control page to allocate for crash kernels. */
-	unsigned long control_page;
-
-	/* Flags to indicate special processing */
-	unsigned int type : 1;
-#define KEXEC_TYPE_DEFAULT 0
-#define KEXEC_TYPE_CRASH   1
-	unsigned int preserve_context : 1;
-
-#ifdef ARCH_HAS_KIMAGE_ARCH
-	struct kimage_arch arch;
-#endif
-};
-
-
-
-/* kexec interface functions */
-extern void machine_kexec(struct kimage *image);
-extern int machine_kexec_prepare(struct kimage *image);
-extern void machine_kexec_cleanup(struct kimage *image);
-extern asmlinkage long sys_kexec_load(unsigned long entry,
-					unsigned long nr_segments,
-					struct kexec_segment __user *segments,
-					unsigned long flags);
-extern int kernel_kexec(void);
-#ifdef CONFIG_COMPAT
-extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
-				unsigned long nr_segments,
-				struct compat_kexec_segment __user *segments,
-				unsigned long flags);
-#endif
-extern struct page *kimage_alloc_control_pages(struct kimage *image,
-						unsigned int order);
-extern void crash_kexec(struct pt_regs *);
-int kexec_should_crash(struct task_struct *);
-void crash_save_cpu(struct pt_regs *regs, int cpu);
-void crash_save_vmcoreinfo(void);
-void arch_crash_save_vmcoreinfo(void);
-void vmcoreinfo_append_str(const char *fmt, ...)
-	__attribute__ ((format (printf, 1, 2)));
-unsigned long paddr_vmcoreinfo_note(void);
-
-#define VMCOREINFO_OSRELEASE(value) \
-	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
-#define VMCOREINFO_PAGESIZE(value) \
-	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
-#define VMCOREINFO_SYMBOL(name) \
-	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
-#define VMCOREINFO_SIZE(name) \
-	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
-			      (unsigned long)sizeof(name))
-#define VMCOREINFO_STRUCT_SIZE(name) \
-	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
-			      (unsigned long)sizeof(struct name))
-#define VMCOREINFO_OFFSET(name, field) \
-	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
-			      (unsigned long)offsetof(struct name, field))
-#define VMCOREINFO_LENGTH(name, value) \
-	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
-#define VMCOREINFO_NUMBER(name) \
-	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
-#define VMCOREINFO_CONFIG(name) \
-	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
-
-extern struct kimage *kexec_image;
-extern struct kimage *kexec_crash_image;
-
-#ifndef kexec_flush_icache_page
-#define kexec_flush_icache_page(page)
-#endif
-
 #define KEXEC_ON_CRASH		0x00000001
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
 #define KEXEC_ARCH_MASK		0xffff0000
@@ -182,37 +23,16 @@ extern struct kimage *kexec_crash_image;
 #define KEXEC_ARCH_MIPS_LE (10 << 16)
 #define KEXEC_ARCH_MIPS    ( 8 << 16)
 
-/* List of defined/legal kexec flags */
-#ifndef CONFIG_KEXEC_JUMP
-#define KEXEC_FLAGS    KEXEC_ON_CRASH
+#define KEXEC_SEGMENT_MAX 16
+struct kexec_segment {
+	void __user *buf;
+	size_t bufsz;
+#ifdef __KERNEL__
+	unsigned long mem;	/* User space sees this as a (void *) ... */
 #else
-#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
+	void *mem;
 #endif
+	size_t memsz;
+};
 
-#define VMCOREINFO_BYTES           (4096)
-#define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
-#define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
-#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
-				    + VMCOREINFO_NOTE_NAME_BYTES)
-
-/* Location of a reserved region to hold the crash kernel.
- */
-extern struct resource crashk_res;
-typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
-extern note_buf_t __percpu *crash_notes;
-extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
-extern size_t vmcoreinfo_size;
-extern size_t vmcoreinfo_max_size;
-
-int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
-		unsigned long long *crash_size, unsigned long long *crash_base);
-int crash_shrink_memory(unsigned long new_size);
-size_t crash_get_memory_size(void);
-
-#else /* !CONFIG_KEXEC */
-struct pt_regs;
-struct task_struct;
-static inline void crash_kexec(struct pt_regs *regs) { }
-static inline int kexec_should_crash(struct task_struct *p) { return 0; }
-#endif /* CONFIG_KEXEC */
 #endif /* LINUX_KEXEC_H */
diff --git a/include/linux/kexec_kernel.h b/include/linux/kexec_kernel.h
new file mode 100644
index 0000000..5d98b9b
--- /dev/null
+++ b/include/linux/kexec_kernel.h
@@ -0,0 +1,193 @@
+#ifndef LINUX_KEXEC_KERNEL_H
+#define LINUX_KEXEC_KERNEL_H
+
+#ifdef CONFIG_KEXEC
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/linkage.h>
+#include <linux/compat.h>
+#include <linux/ioport.h>
+#include <linux/elfcore.h>
+#include <linux/elf.h>
+#include <asm/kexec.h>
+
+#include <linux/kexec.h>
+
+/* Verify architecture specific macros are defined */
+
+#ifndef KEXEC_SOURCE_MEMORY_LIMIT
+#error KEXEC_SOURCE_MEMORY_LIMIT not defined
+#endif
+
+#ifndef KEXEC_DESTINATION_MEMORY_LIMIT
+#error KEXEC_DESTINATION_MEMORY_LIMIT not defined
+#endif
+
+#ifndef KEXEC_CONTROL_MEMORY_LIMIT
+#error KEXEC_CONTROL_MEMORY_LIMIT not defined
+#endif
+
+#ifndef KEXEC_CONTROL_PAGE_SIZE
+#error KEXEC_CONTROL_PAGE_SIZE not defined
+#endif
+
+#ifndef KEXEC_ARCH
+#error KEXEC_ARCH not defined
+#endif
+
+#define KEXEC_NOTE_HEAD_BYTES ALIGN(sizeof(struct elf_note), 4)
+#define KEXEC_CORE_NOTE_NAME "CORE"
+#define KEXEC_CORE_NOTE_NAME_BYTES ALIGN(sizeof(KEXEC_CORE_NOTE_NAME), 4)
+#define KEXEC_CORE_NOTE_DESC_BYTES ALIGN(sizeof(struct elf_prstatus), 4)
+/*
+ * The per-cpu notes area is a list of notes terminated by a "NULL"
+ * note header.  For kdump, the code in vmcore.c runs in the context
+ * of the second kernel to combine them into one note.
+ */
+#define KEXEC_NOTE_BYTES ( (KEXEC_NOTE_HEAD_BYTES * 2) +		\
+			    KEXEC_CORE_NOTE_NAME_BYTES +		\
+			    KEXEC_CORE_NOTE_DESC_BYTES )
+
+/*
+ * This structure is used to hold the arguments that are used when loading
+ * kernel binaries.
+ */
+
+typedef unsigned long kimage_entry_t;
+#define IND_DESTINATION  0x1
+#define IND_INDIRECTION  0x2
+#define IND_DONE         0x4
+#define IND_SOURCE       0x8
+
+#ifdef CONFIG_COMPAT
+struct compat_kexec_segment {
+	compat_uptr_t buf;
+	compat_size_t bufsz;
+	compat_ulong_t mem;	/* User space sees this as a (void *) ... */
+	compat_size_t memsz;
+};
+#endif
+
+struct kimage {
+	kimage_entry_t head;
+	kimage_entry_t *entry;
+	kimage_entry_t *last_entry;
+
+	unsigned long destination;
+
+	unsigned long start;
+	struct page *control_code_page;
+	struct page *swap_page;
+
+	unsigned long nr_segments;
+	struct kexec_segment segment[KEXEC_SEGMENT_MAX];
+
+	struct list_head control_pages;
+	struct list_head dest_pages;
+	struct list_head unuseable_pages;
+
+	/* Address of next control page to allocate for crash kernels. */
+	unsigned long control_page;
+
+	/* Flags to indicate special processing */
+	unsigned int type : 1;
+#define KEXEC_TYPE_DEFAULT 0
+#define KEXEC_TYPE_CRASH   1
+	unsigned int preserve_context : 1;
+
+#ifdef ARCH_HAS_KIMAGE_ARCH
+	struct kimage_arch arch;
+#endif
+};
+
+
+
+/* kexec interface functions */
+extern void machine_kexec(struct kimage *image);
+extern int machine_kexec_prepare(struct kimage *image);
+extern void machine_kexec_cleanup(struct kimage *image);
+extern asmlinkage long sys_kexec_load(unsigned long entry,
+					unsigned long nr_segments,
+					struct kexec_segment __user *segments,
+					unsigned long flags);
+extern int kernel_kexec(void);
+#ifdef CONFIG_COMPAT
+extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
+				unsigned long nr_segments,
+				struct compat_kexec_segment __user *segments,
+				unsigned long flags);
+#endif
+extern struct page *kimage_alloc_control_pages(struct kimage *image,
+						unsigned int order);
+extern void crash_kexec(struct pt_regs *);
+int kexec_should_crash(struct task_struct *);
+void crash_save_cpu(struct pt_regs *regs, int cpu);
+void crash_save_vmcoreinfo(void);
+void arch_crash_save_vmcoreinfo(void);
+void vmcoreinfo_append_str(const char *fmt, ...)
+	__attribute__ ((format (printf, 1, 2)));
+unsigned long paddr_vmcoreinfo_note(void);
+
+#define VMCOREINFO_OSRELEASE(value) \
+	vmcoreinfo_append_str("OSRELEASE=%s\n", value)
+#define VMCOREINFO_PAGESIZE(value) \
+	vmcoreinfo_append_str("PAGESIZE=%ld\n", value)
+#define VMCOREINFO_SYMBOL(name) \
+	vmcoreinfo_append_str("SYMBOL(%s)=%lx\n", #name, (unsigned long)&name)
+#define VMCOREINFO_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(name))
+#define VMCOREINFO_STRUCT_SIZE(name) \
+	vmcoreinfo_append_str("SIZE(%s)=%lu\n", #name, \
+			      (unsigned long)sizeof(struct name))
+#define VMCOREINFO_OFFSET(name, field) \
+	vmcoreinfo_append_str("OFFSET(%s.%s)=%lu\n", #name, #field, \
+			      (unsigned long)offsetof(struct name, field))
+#define VMCOREINFO_LENGTH(name, value) \
+	vmcoreinfo_append_str("LENGTH(%s)=%lu\n", #name, (unsigned long)value)
+#define VMCOREINFO_NUMBER(name) \
+	vmcoreinfo_append_str("NUMBER(%s)=%ld\n", #name, (long)name)
+#define VMCOREINFO_CONFIG(name) \
+	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
+
+extern struct kimage *kexec_image;
+extern struct kimage *kexec_crash_image;
+
+#ifndef kexec_flush_icache_page
+#define kexec_flush_icache_page(page)
+#endif
+
+/* List of defined/legal kexec flags */
+#ifndef CONFIG_KEXEC_JUMP
+#define KEXEC_FLAGS    KEXEC_ON_CRASH
+#else
+#define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
+#endif
+
+#define VMCOREINFO_BYTES           (4096)
+#define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
+#define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
+#define VMCOREINFO_NOTE_SIZE       (KEXEC_NOTE_HEAD_BYTES*2 + VMCOREINFO_BYTES \
+				    + VMCOREINFO_NOTE_NAME_BYTES)
+
+/* Location of a reserved region to hold the crash kernel.
+ */
+extern struct resource crashk_res;
+typedef u32 note_buf_t[KEXEC_NOTE_BYTES/4];
+extern note_buf_t __percpu *crash_notes;
+extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
+extern size_t vmcoreinfo_size;
+extern size_t vmcoreinfo_max_size;
+
+int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
+		unsigned long long *crash_size, unsigned long long *crash_base);
+int crash_shrink_memory(unsigned long new_size);
+size_t crash_get_memory_size(void);
+
+#else /* !CONFIG_KEXEC */
+struct pt_regs;
+struct task_struct;
+static inline void crash_kexec(struct pt_regs *regs) { }
+static inline int kexec_should_crash(struct task_struct *p) { return 0; }
+#endif /* CONFIG_KEXEC */
+#endif /* LINUX_KEXEC_KERNEL_H */
diff --git a/init/initramfs.c b/init/initramfs.c
index 4b9c202..fdd68ea 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -485,7 +485,7 @@ __setup("retain_initrd", retain_initrd_param);
 
 extern char __initramfs_start[], __initramfs_end[];
 #include <linux/initrd.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 
 static void __init free_initrd(void)
 {
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 474a847..7068e40 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -11,7 +11,7 @@
 #include <linux/file.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 0b624e7..9fe1a34 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -13,7 +13,7 @@
 #include <linux/sysfs.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 3b16cd9..af6323f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -8,6 +8,7 @@
  * This function is used through-out the kernel (including mm and fs)
  * to indicate a major problem.
  */
+#include <linux/kexec_kernel.h>
 #include <linux/debug_locks.h>
 #include <linux/interrupt.h>
 #include <linux/kmsg_dump.h>
@@ -17,7 +18,6 @@
 #include <linux/random.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
-#include <linux/kexec.h>
 #include <linux/sched.h>
 #include <linux/sysrq.h>
 #include <linux/init.h>
diff --git a/kernel/printk.c b/kernel/printk.c
index 444b770..a50ceb2 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -32,7 +32,7 @@
 #include <linux/security.h>
 #include <linux/bootmem.h>
 #include <linux/syscalls.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/kdb.h>
 #include <linux/ratelimit.h>
 #include <linux/kmsg_dump.h>
diff --git a/kernel/sys.c b/kernel/sys.c
index e83ddbb..6559f9b 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -16,7 +16,7 @@
 #include <linux/perf_event.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
-#include <linux/kexec.h>
+#include <linux/kexec_kernel.h>
 #include <linux/workqueue.h>
 #include <linux/capability.h>
 #include <linux/device.h>
-- 
1.6.0.6


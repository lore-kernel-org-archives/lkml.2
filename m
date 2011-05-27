Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1E0LfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 07:35:16 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:41067 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1E0LfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 07:35:13 -0400
Date: Fri, 27 May 2011 13:35:10 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.40
Message-ID: <20110527113510.GA2541@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (9):
      [S390] pfault: always enable service signal interrupt
      [S390] irq: fix service signal external interrupt handling
      [S390] irq: merge irq.c and s390_ext.c
      [S390] uaccess: turn __access_ok() into a define
      [S390] topology,sched: fix cpu_coregroup_mask/cpu_book_mask definitions
      [S390] delay: implement ndelay
      [S390] mm: handle kernel caused page fault oom situations
      [S390] mm: add page fault retry handling
      [S390] mm: add ZONE_DMA to 31-bit config again

Martin Schwidefsky (1):
      [S390] hwsampler: allow cpu hotplug

 arch/s390/Kconfig                 |    2 +-
 arch/s390/appldata/appldata_mem.c |    2 -
 arch/s390/include/asm/delay.h     |    8 ++-
 arch/s390/include/asm/irq.h       |    8 ++
 arch/s390/include/asm/s390_ext.h  |   17 -----
 arch/s390/include/asm/topology.h  |    4 +-
 arch/s390/include/asm/uaccess.h   |   11 ++--
 arch/s390/kernel/Makefile         |    8 +-
 arch/s390/kernel/dis.c            |    2 +-
 arch/s390/kernel/irq.c            |  137 ++++++++++++++++++++++++++++++++++--
 arch/s390/kernel/s390_ext.c       |  108 -----------------------------
 arch/s390/kernel/smp.c            |    1 -
 arch/s390/kernel/time.c           |    1 -
 arch/s390/kernel/topology.c       |    1 -
 arch/s390/kernel/traps.c          |    1 -
 arch/s390/kernel/vtime.c          |    2 +-
 arch/s390/lib/delay.c             |   15 ++++
 arch/s390/mm/fault.c              |   62 +++++++++++------
 arch/s390/mm/init.c               |    2 -
 arch/s390/oprofile/hwsampler.c    |    4 +-
 drivers/s390/block/dasd_diag.c    |    6 +-
 drivers/s390/char/sclp.c          |    7 +-
 drivers/s390/kvm/kvm_virtio.c     |    3 +-
 net/iucv/iucv.c                   |    2 +-
 24 files changed, 221 insertions(+), 193 deletions(-)
 delete mode 100644 arch/s390/include/asm/s390_ext.h
 delete mode 100644 arch/s390/kernel/s390_ext.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ff2d237..9fab2aa 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -2,7 +2,7 @@ config MMU
 	def_bool y
 
 config ZONE_DMA
-	def_bool y if 64BIT
+	def_bool y
 
 config LOCKDEP_SUPPORT
 	def_bool y
diff --git a/arch/s390/appldata/appldata_mem.c b/arch/s390/appldata/appldata_mem.c
index e43fe75..f7d3dc5 100644
--- a/arch/s390/appldata/appldata_mem.c
+++ b/arch/s390/appldata/appldata_mem.c
@@ -92,9 +92,7 @@ static void appldata_get_mem_data(void *data)
 	mem_data->pswpin     = ev[PSWPIN];
 	mem_data->pswpout    = ev[PSWPOUT];
 	mem_data->pgalloc    = ev[PGALLOC_NORMAL];
-#ifdef CONFIG_ZONE_DMA
 	mem_data->pgalloc    += ev[PGALLOC_DMA];
-#endif
 	mem_data->pgfault    = ev[PGFAULT];
 	mem_data->pgmajfault = ev[PGMAJFAULT];
 
diff --git a/arch/s390/include/asm/delay.h b/arch/s390/include/asm/delay.h
index 8a096b8..0e3b35f 100644
--- a/arch/s390/include/asm/delay.h
+++ b/arch/s390/include/asm/delay.h
@@ -14,10 +14,12 @@
 #ifndef _S390_DELAY_H
 #define _S390_DELAY_H
 
-extern void __udelay(unsigned long long usecs);
-extern void udelay_simple(unsigned long long usecs);
-extern void __delay(unsigned long loops);
+void __ndelay(unsigned long long nsecs);
+void __udelay(unsigned long long usecs);
+void udelay_simple(unsigned long long usecs);
+void __delay(unsigned long loops);
 
+#define ndelay(n) __ndelay((unsigned long long) (n))
 #define udelay(n) __udelay((unsigned long long) (n))
 #define mdelay(n) __udelay((unsigned long long) (n) * 1000)
 
diff --git a/arch/s390/include/asm/irq.h b/arch/s390/include/asm/irq.h
index 1544b90..ba7b01c 100644
--- a/arch/s390/include/asm/irq.h
+++ b/arch/s390/include/asm/irq.h
@@ -2,6 +2,7 @@
 #define _ASM_IRQ_H
 
 #include <linux/hardirq.h>
+#include <linux/types.h>
 
 enum interruption_class {
 	EXTERNAL_INTERRUPT,
@@ -31,4 +32,11 @@ enum interruption_class {
 	NR_IRQS,
 };
 
+typedef void (*ext_int_handler_t)(unsigned int, unsigned int, unsigned long);
+
+int register_external_interrupt(u16 code, ext_int_handler_t handler);
+int unregister_external_interrupt(u16 code, ext_int_handler_t handler);
+void service_subclass_irq_register(void);
+void service_subclass_irq_unregister(void);
+
 #endif /* _ASM_IRQ_H */
diff --git a/arch/s390/include/asm/s390_ext.h b/arch/s390/include/asm/s390_ext.h
deleted file mode 100644
index 080876d..0000000
--- a/arch/s390/include/asm/s390_ext.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- *    Copyright IBM Corp. 1999,2010
- *    Author(s): Holger Smolinski <Holger.Smolinski@de.ibm.com>,
- *		 Martin Schwidefsky <schwidefsky@de.ibm.com>,
- */
-
-#ifndef _S390_EXTINT_H
-#define _S390_EXTINT_H
-
-#include <linux/types.h>
-
-typedef void (*ext_int_handler_t)(unsigned int, unsigned int, unsigned long);
-
-int register_external_interrupt(__u16 code, ext_int_handler_t handler);
-int unregister_external_interrupt(__u16 code, ext_int_handler_t handler);
-
-#endif /* _S390_EXTINT_H */
diff --git a/arch/s390/include/asm/topology.h b/arch/s390/include/asm/topology.h
index c533883..005d77d 100644
--- a/arch/s390/include/asm/topology.h
+++ b/arch/s390/include/asm/topology.h
@@ -7,7 +7,7 @@
 extern unsigned char cpu_core_id[NR_CPUS];
 extern cpumask_t cpu_core_map[NR_CPUS];
 
-static inline const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
+static inline const struct cpumask *cpu_coregroup_mask(int cpu)
 {
 	return &cpu_core_map[cpu];
 }
@@ -21,7 +21,7 @@ static inline const struct cpumask *cpu_coregroup_mask(unsigned int cpu)
 extern unsigned char cpu_book_id[NR_CPUS];
 extern cpumask_t cpu_book_map[NR_CPUS];
 
-static inline const struct cpumask *cpu_book_mask(unsigned int cpu)
+static inline const struct cpumask *cpu_book_mask(int cpu)
 {
 	return &cpu_book_map[cpu];
 }
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 2d9ea11f..2b23885 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -49,12 +49,13 @@
 
 #define segment_eq(a,b) ((a).ar4 == (b).ar4)
 
+#define __access_ok(addr, size)	\
+({				\
+	__chk_user_ptr(addr);	\
+	1;			\
+})
 
-static inline int __access_ok(const void __user *addr, unsigned long size)
-{
-	return 1;
-}
-#define access_ok(type,addr,size) __access_ok(addr,size)
+#define access_ok(type, addr, size) __access_ok(addr, size)
 
 /*
  * The exception table consists of pairs of addresses: the first is the
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index 5ff15da..df37322 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -20,10 +20,10 @@ CFLAGS_ptrace.o		+= -DUTS_MACHINE='"$(UTS_MACHINE)"'
 
 CFLAGS_sysinfo.o += -Iinclude/math-emu -Iarch/s390/math-emu -w
 
-obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o \
-	    processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
-	    s390_ext.o debug.o irq.o ipl.o dis.o diag.o mem_detect.o \
-	    vdso.o vtime.o sysinfo.o nmi.o sclp.o jump_label.o
+obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o setup.o vtime.o \
+	    processor.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o nmi.o \
+	    debug.o irq.o ipl.o dis.o diag.o mem_detect.o sclp.o vdso.o \
+	    sysinfo.o jump_label.o
 
 obj-y	+= $(if $(CONFIG_64BIT),entry64.o,entry.o)
 obj-y	+= $(if $(CONFIG_64BIT),reipl64.o,reipl.o)
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index 3d4a78f..1ca3d1d 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -30,9 +30,9 @@
 #include <asm/atomic.h>
 #include <asm/mathemu.h>
 #include <asm/cpcmd.h>
-#include <asm/s390_ext.h>
 #include <asm/lowcore.h>
 #include <asm/debug.h>
+#include <asm/irq.h>
 
 #ifndef CONFIG_64BIT
 #define ONELONG "%08lx: "
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index e204f95..e3264f6 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -1,19 +1,28 @@
 /*
- *    Copyright IBM Corp. 2004,2010
- *    Author(s): Martin Schwidefsky (schwidefsky@de.ibm.com),
- *		 Thomas Spatzier (tspat@de.ibm.com)
+ *    Copyright IBM Corp. 2004,2011
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>,
+ *		 Holger Smolinski <Holger.Smolinski@de.ibm.com>,
+ *		 Thomas Spatzier <tspat@de.ibm.com>,
  *
  * This file contains interrupt related functions.
  */
 
-#include <linux/module.h>
-#include <linux/kernel.h>
 #include <linux/kernel_stat.h>
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
-#include <linux/cpu.h>
 #include <linux/proc_fs.h>
 #include <linux/profile.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/ftrace.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/cpu.h>
+#include <asm/irq_regs.h>
+#include <asm/cputime.h>
+#include <asm/lowcore.h>
+#include <asm/irq.h>
+#include "entry.h"
 
 struct irq_class {
 	char *name;
@@ -82,8 +91,7 @@ int show_interrupts(struct seq_file *p, void *v)
  * For compatibilty only. S/390 specific setup of interrupts et al. is done
  * much later in init_channel_subsystem().
  */
-void __init
-init_IRQ(void)
+void __init init_IRQ(void)
 {
 	/* nothing... */
 }
@@ -134,3 +142,116 @@ void init_irq_proc(void)
 	create_prof_cpu_mask(root_irq_dir);
 }
 #endif
+
+/*
+ * ext_int_hash[index] is the start of the list for all external interrupts
+ * that hash to this index. With the current set of external interrupts
+ * (0x1202 external call, 0x1004 cpu timer, 0x2401 hwc console, 0x4000
+ * iucv and 0x2603 pfault) this is always the first element.
+ */
+
+struct ext_int_info {
+	struct ext_int_info *next;
+	ext_int_handler_t handler;
+	u16 code;
+};
+
+static struct ext_int_info *ext_int_hash[256];
+
+static inline int ext_hash(u16 code)
+{
+	return (code + (code >> 9)) & 0xff;
+}
+
+int register_external_interrupt(u16 code, ext_int_handler_t handler)
+{
+	struct ext_int_info *p;
+	int index;
+
+	p = kmalloc(sizeof(*p), GFP_ATOMIC);
+	if (!p)
+		return -ENOMEM;
+	p->code = code;
+	p->handler = handler;
+	index = ext_hash(code);
+	p->next = ext_int_hash[index];
+	ext_int_hash[index] = p;
+	return 0;
+}
+EXPORT_SYMBOL(register_external_interrupt);
+
+int unregister_external_interrupt(u16 code, ext_int_handler_t handler)
+{
+	struct ext_int_info *p, *q;
+	int index;
+
+	index = ext_hash(code);
+	q = NULL;
+	p = ext_int_hash[index];
+	while (p) {
+		if (p->code == code && p->handler == handler)
+			break;
+		q = p;
+		p = p->next;
+	}
+	if (!p)
+		return -ENOENT;
+	if (q)
+		q->next = p->next;
+	else
+		ext_int_hash[index] = p->next;
+	kfree(p);
+	return 0;
+}
+EXPORT_SYMBOL(unregister_external_interrupt);
+
+void __irq_entry do_extint(struct pt_regs *regs, unsigned int ext_int_code,
+			   unsigned int param32, unsigned long param64)
+{
+	struct pt_regs *old_regs;
+	unsigned short code;
+	struct ext_int_info *p;
+	int index;
+
+	code = (unsigned short) ext_int_code;
+	old_regs = set_irq_regs(regs);
+	s390_idle_check(regs, S390_lowcore.int_clock,
+			S390_lowcore.async_enter_timer);
+	irq_enter();
+	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
+		/* Serve timer interrupts first. */
+		clock_comparator_work();
+	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
+	if (code != 0x1004)
+		__get_cpu_var(s390_idle).nohz_delay = 1;
+	index = ext_hash(code);
+	for (p = ext_int_hash[index]; p; p = p->next) {
+		if (likely(p->code == code))
+			p->handler(ext_int_code, param32, param64);
+	}
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+static DEFINE_SPINLOCK(sc_irq_lock);
+static int sc_irq_refcount;
+
+void service_subclass_irq_register(void)
+{
+	spin_lock(&sc_irq_lock);
+	if (!sc_irq_refcount)
+		ctl_set_bit(0, 9);
+	sc_irq_refcount++;
+	spin_unlock(&sc_irq_lock);
+}
+EXPORT_SYMBOL(service_subclass_irq_register);
+
+void service_subclass_irq_unregister(void)
+{
+	spin_lock(&sc_irq_lock);
+	sc_irq_refcount--;
+	if (!sc_irq_refcount)
+		ctl_clear_bit(0, 9);
+	spin_unlock(&sc_irq_lock);
+}
+EXPORT_SYMBOL(service_subclass_irq_unregister);
diff --git a/arch/s390/kernel/s390_ext.c b/arch/s390/kernel/s390_ext.c
deleted file mode 100644
index 1850299..0000000
--- a/arch/s390/kernel/s390_ext.c
+++ /dev/null
@@ -1,108 +0,0 @@
-/*
- *    Copyright IBM Corp. 1999,2010
- *    Author(s): Holger Smolinski <Holger.Smolinski@de.ibm.com>,
- *		 Martin Schwidefsky <schwidefsky@de.ibm.com>,
- */
-
-#include <linux/kernel_stat.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/ftrace.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <asm/s390_ext.h>
-#include <asm/irq_regs.h>
-#include <asm/cputime.h>
-#include <asm/lowcore.h>
-#include <asm/irq.h>
-#include "entry.h"
-
-struct ext_int_info {
-	struct ext_int_info *next;
-	ext_int_handler_t handler;
-	__u16 code;
-};
-
-/*
- * ext_int_hash[index] is the start of the list for all external interrupts
- * that hash to this index. With the current set of external interrupts 
- * (0x1202 external call, 0x1004 cpu timer, 0x2401 hwc console, 0x4000
- * iucv and 0x2603 pfault) this is always the first element. 
- */
-static struct ext_int_info *ext_int_hash[256];
-
-static inline int ext_hash(__u16 code)
-{
-	return (code + (code >> 9)) & 0xff;
-}
-
-int register_external_interrupt(__u16 code, ext_int_handler_t handler)
-{
-	struct ext_int_info *p;
-	int index;
-
-	p = kmalloc(sizeof(*p), GFP_ATOMIC);
-	if (!p)
-		return -ENOMEM;
-	p->code = code;
-	p->handler = handler;
-	index = ext_hash(code);
-	p->next = ext_int_hash[index];
-	ext_int_hash[index] = p;
-	return 0;
-}
-EXPORT_SYMBOL(register_external_interrupt);
-
-int unregister_external_interrupt(__u16 code, ext_int_handler_t handler)
-{
-	struct ext_int_info *p, *q;
-	int index;
-
-	index = ext_hash(code);
-	q = NULL;
-	p = ext_int_hash[index];
-	while (p) {
-		if (p->code == code && p->handler == handler)
-			break;
-		q = p;
-		p = p->next;
-	}
-	if (!p)
-		return -ENOENT;
-	if (q)
-		q->next = p->next;
-	else
-		ext_int_hash[index] = p->next;
-	kfree(p);
-	return 0;
-}
-EXPORT_SYMBOL(unregister_external_interrupt);
-
-void __irq_entry do_extint(struct pt_regs *regs, unsigned int ext_int_code,
-			   unsigned int param32, unsigned long param64)
-{
-	struct pt_regs *old_regs;
-	unsigned short code;
-	struct ext_int_info *p;
-	int index;
-
-	code = (unsigned short) ext_int_code;
-	old_regs = set_irq_regs(regs);
-	s390_idle_check(regs, S390_lowcore.int_clock,
-			S390_lowcore.async_enter_timer);
-	irq_enter();
-	if (S390_lowcore.int_clock >= S390_lowcore.clock_comparator)
-		/* Serve timer interrupts first. */
-		clock_comparator_work();
-	kstat_cpu(smp_processor_id()).irqs[EXTERNAL_INTERRUPT]++;
-	if (code != 0x1004)
-		__get_cpu_var(s390_idle).nohz_delay = 1;
-	index = ext_hash(code);
-	for (p = ext_int_hash[index]; p; p = p->next) {
-		if (likely(p->code == code))
-			p->handler(ext_int_code, param32, param64);
-	}
-	irq_exit();
-	set_irq_regs(old_regs);
-}
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index f8e85ec..52420d2 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -44,7 +44,6 @@
 #include <asm/sigp.h>
 #include <asm/pgalloc.h>
 #include <asm/irq.h>
-#include <asm/s390_ext.h>
 #include <asm/cpcmd.h>
 #include <asm/tlbflush.h>
 #include <asm/timer.h>
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a59557f..dff9330 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -41,7 +41,6 @@
 #include <linux/kprobes.h>
 #include <asm/uaccess.h>
 #include <asm/delay.h>
-#include <asm/s390_ext.h>
 #include <asm/div64.h>
 #include <asm/vdso.h>
 #include <asm/irq.h>
diff --git a/arch/s390/kernel/topology.c b/arch/s390/kernel/topology.c
index 2eafb8c..0cd340b7 100644
--- a/arch/s390/kernel/topology.c
+++ b/arch/s390/kernel/topology.c
@@ -17,7 +17,6 @@
 #include <linux/smp.h>
 #include <linux/cpuset.h>
 #include <asm/delay.h>
-#include <asm/s390_ext.h>
 
 #define PTF_HORIZONTAL	(0UL)
 #define PTF_VERTICAL	(1UL)
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index b5a4a73..a65d2e8 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -39,7 +39,6 @@
 #include <asm/atomic.h>
 #include <asm/mathemu.h>
 #include <asm/cpcmd.h>
-#include <asm/s390_ext.h>
 #include <asm/lowcore.h>
 #include <asm/debug.h>
 #include "entry.h"
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 5e8ead4..2d6228f 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -22,10 +22,10 @@
 #include <linux/cpu.h>
 #include <linux/kprobes.h>
 
-#include <asm/s390_ext.h>
 #include <asm/timer.h>
 #include <asm/irq_regs.h>
 #include <asm/cputime.h>
+#include <asm/irq.h>
 
 static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
 
diff --git a/arch/s390/lib/delay.c b/arch/s390/lib/delay.c
index 0f53110..a65229d 100644
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/irqflags.h>
 #include <linux/interrupt.h>
+#include <asm/div64.h>
 
 void __delay(unsigned long loops)
 {
@@ -116,3 +117,17 @@ void udelay_simple(unsigned long long usecs)
 	while (get_clock() < end)
 		cpu_relax();
 }
+
+void __ndelay(unsigned long long nsecs)
+{
+	u64 end;
+
+	nsecs <<= 9;
+	do_div(nsecs, 125);
+	end = get_clock() + nsecs;
+	if (nsecs & ~0xfffUL)
+		__udelay(nsecs >> 12);
+	while (get_clock() < end)
+		barrier();
+}
+EXPORT_SYMBOL(__ndelay);
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index a0f9e73..fe103e8 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -34,7 +34,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
-#include <asm/s390_ext.h>
+#include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/compat.h>
 #include "../kernel/entry.h"
@@ -245,9 +245,12 @@ static noinline void do_fault_error(struct pt_regs *regs, long int_code,
 		do_no_context(regs, int_code, trans_exc_code);
 		break;
 	default: /* fault & VM_FAULT_ERROR */
-		if (fault & VM_FAULT_OOM)
-			pagefault_out_of_memory();
-		else if (fault & VM_FAULT_SIGBUS) {
+		if (fault & VM_FAULT_OOM) {
+			if (!(regs->psw.mask & PSW_MASK_PSTATE))
+				do_no_context(regs, int_code, trans_exc_code);
+			else
+				pagefault_out_of_memory();
+		} else if (fault & VM_FAULT_SIGBUS) {
 			/* Kernel mode? Handle exceptions or die */
 			if (!(regs->psw.mask & PSW_MASK_PSTATE))
 				do_no_context(regs, int_code, trans_exc_code);
@@ -277,7 +280,8 @@ static inline int do_exception(struct pt_regs *regs, int access,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned long address;
-	int fault, write;
+	unsigned int flags;
+	int fault;
 
 	if (notify_page_fault(regs))
 		return 0;
@@ -296,6 +300,10 @@ static inline int do_exception(struct pt_regs *regs, int access,
 
 	address = trans_exc_code & __FAIL_ADDR_MASK;
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, 0, regs, address);
+	flags = FAULT_FLAG_ALLOW_RETRY;
+	if (access == VM_WRITE || (trans_exc_code & store_indication) == 0x400)
+		flags |= FAULT_FLAG_WRITE;
+retry:
 	down_read(&mm->mmap_sem);
 
 	fault = VM_FAULT_BADMAP;
@@ -325,21 +333,31 @@ static inline int do_exception(struct pt_regs *regs, int access,
 	 * make sure we exit gracefully rather than endlessly redo
 	 * the fault.
 	 */
-	write = (access == VM_WRITE ||
-		 (trans_exc_code & store_indication) == 0x400) ?
-		FAULT_FLAG_WRITE : 0;
-	fault = handle_mm_fault(mm, vma, address, write);
+	fault = handle_mm_fault(mm, vma, address, flags);
 	if (unlikely(fault & VM_FAULT_ERROR))
 		goto out_up;
 
-	if (fault & VM_FAULT_MAJOR) {
-		tsk->maj_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
-				     regs, address);
-	} else {
-		tsk->min_flt++;
-		perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
-				     regs, address);
+	/*
+	 * Major/minor page fault accounting is only done on the
+	 * initial attempt. If we go through a retry, it is extremely
+	 * likely that the page will be found in page cache at that point.
+	 */
+	if (flags & FAULT_FLAG_ALLOW_RETRY) {
+		if (fault & VM_FAULT_MAJOR) {
+			tsk->maj_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
+				      regs, address);
+		} else {
+			tsk->min_flt++;
+			perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
+				      regs, address);
+		}
+		if (fault & VM_FAULT_RETRY) {
+			/* Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk
+			 * of starvation. */
+			flags &= ~FAULT_FLAG_ALLOW_RETRY;
+			goto retry;
+		}
 	}
 	/*
 	 * The instruction that caused the program check will
@@ -429,10 +447,9 @@ int __handle_fault(unsigned long uaddr, unsigned long pgm_int_code, int write)
 	access = write ? VM_WRITE : VM_READ;
 	fault = do_exception(&regs, access, uaddr | 2);
 	if (unlikely(fault)) {
-		if (fault & VM_FAULT_OOM) {
-			pagefault_out_of_memory();
-			fault = 0;
-		} else if (fault & VM_FAULT_SIGBUS)
+		if (fault & VM_FAULT_OOM)
+			return -EFAULT;
+		else if (fault & VM_FAULT_SIGBUS)
 			do_sigbus(&regs, pgm_int_code, uaddr);
 	}
 	return fault ? -EFAULT : 0;
@@ -485,7 +502,6 @@ int pfault_init(void)
 		"2:\n"
 		EX_TABLE(0b,1b)
 		: "=d" (rc) : "a" (&refbk), "m" (refbk) : "cc");
-        __ctl_set_bit(0, 9);
         return rc;
 }
 
@@ -500,7 +516,6 @@ void pfault_fini(void)
 
 	if (!MACHINE_IS_VM || pfault_disable)
 		return;
-	__ctl_clear_bit(0,9);
 	asm volatile(
 		"	diag	%0,0,0x258\n"
 		"0:\n"
@@ -615,6 +630,7 @@ static int __init pfault_irq_init(void)
 	rc = pfault_init() == 0 ? 0 : -EOPNOTSUPP;
 	if (rc)
 		goto out_pfault;
+	service_subclass_irq_register();
 	hotcpu_notifier(pfault_cpu_notify, 0);
 	return 0;
 
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index dfefc21..59b6631 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -119,9 +119,7 @@ void __init paging_init(void)
 	sparse_memory_present_with_active_regions(MAX_NUMNODES);
 	sparse_init();
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
-#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 	free_area_init_nodes(max_zone_pfns);
 	fault_init();
diff --git a/arch/s390/oprofile/hwsampler.c b/arch/s390/oprofile/hwsampler.c
index 053caa0..4552ce4 100644
--- a/arch/s390/oprofile/hwsampler.c
+++ b/arch/s390/oprofile/hwsampler.c
@@ -19,7 +19,7 @@
 #include <linux/oprofile.h>
 
 #include <asm/lowcore.h>
-#include <asm/s390_ext.h>
+#include <asm/irq.h>
 
 #include "hwsampler.h"
 
@@ -580,7 +580,7 @@ static int hws_cpu_callback(struct notifier_block *nfb,
 {
 	/* We do not have sampler space available for all possible CPUs.
 	   All CPUs should be online when hw sampling is activated. */
-	return NOTIFY_BAD;
+	return (hws_state <= HWS_DEALLOCATED) ? NOTIFY_OK : NOTIFY_BAD;
 }
 
 static struct notifier_block hws_cpu_notifier = {
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 85dddb1..46784b8 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -24,7 +24,7 @@
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
 #include <asm/io.h>
-#include <asm/s390_ext.h>
+#include <asm/irq.h>
 #include <asm/vtoc.h>
 #include <asm/diag.h>
 
@@ -642,7 +642,7 @@ dasd_diag_init(void)
 	}
 	ASCEBC(dasd_diag_discipline.ebcname, 4);
 
-	ctl_set_bit(0, 9);
+	service_subclass_irq_register();
 	register_external_interrupt(0x2603, dasd_ext_handler);
 	dasd_diag_discipline_pointer = &dasd_diag_discipline;
 	return 0;
@@ -652,7 +652,7 @@ static void __exit
 dasd_diag_cleanup(void)
 {
 	unregister_external_interrupt(0x2603, dasd_ext_handler);
-	ctl_clear_bit(0, 9);
+	service_subclass_irq_unregister();
 	dasd_diag_discipline_pointer = NULL;
 }
 
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index b76c61f..eaa7e78 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -19,7 +19,6 @@
 #include <linux/suspend.h>
 #include <linux/completion.h>
 #include <linux/platform_device.h>
-#include <asm/s390_ext.h>
 #include <asm/types.h>
 #include <asm/irq.h>
 
@@ -885,12 +884,12 @@ sclp_check_interface(void)
 		spin_unlock_irqrestore(&sclp_lock, flags);
 		/* Enable service-signal interruption - needs to happen
 		 * with IRQs enabled. */
-		ctl_set_bit(0, 9);
+		service_subclass_irq_register();
 		/* Wait for signal from interrupt or timeout */
 		sclp_sync_wait();
 		/* Disable service-signal interruption - needs to happen
 		 * with IRQs enabled. */
-		ctl_clear_bit(0,9);
+		service_subclass_irq_unregister();
 		spin_lock_irqsave(&sclp_lock, flags);
 		del_timer(&sclp_request_timer);
 		if (sclp_init_req.status == SCLP_REQ_DONE &&
@@ -1070,7 +1069,7 @@ sclp_init(void)
 	spin_unlock_irqrestore(&sclp_lock, flags);
 	/* Enable service-signal external interruption - needs to happen with
 	 * IRQs enabled. */
-	ctl_set_bit(0, 9);
+	service_subclass_irq_register();
 	sclp_init_mask(1);
 	return 0;
 
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 607998f..aec60d5 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -25,7 +25,6 @@
 #include <asm/kvm_para.h>
 #include <asm/kvm_virtio.h>
 #include <asm/setup.h>
-#include <asm/s390_ext.h>
 #include <asm/irq.h>
 
 #define VIRTIO_SUBCODE_64 0x0D00
@@ -441,7 +440,7 @@ static int __init kvm_devices_init(void)
 
 	INIT_WORK(&hotplug_work, hotplug_devices);
 
-	ctl_set_bit(0, 9);
+	service_subclass_irq_register();
 	register_external_interrupt(0x2603, kvm_extint_handler);
 
 	scan_devices();
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index a15c015..7f91249 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -54,7 +54,7 @@
 #include <asm/atomic.h>
 #include <asm/ebcdic.h>
 #include <asm/io.h>
-#include <asm/s390_ext.h>
+#include <asm/irq.h>
 #include <asm/smp.h>
 
 /*

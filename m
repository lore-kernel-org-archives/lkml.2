Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1AYNxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:53:37 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56177 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab1AYNxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:53:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ThtyHYMIB0sJZOEnM+iipxvPT0KbBeWfAN12ipu12xoBtiATXQUa3ydk7jnL4DnVIi
         +eehFRNbG/MLzyC26zbkBq9UB7qNtnixXGH/M8oC0ffP3WMCvkZZhV56rqXIDEl4P7N5
         GVIeFGpp+YqXYFM8riZ30SBkHjmFKH4/2GTdA=
Date: Tue, 25 Jan 2011 15:53:26 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next 2/2][RFC] x86: Saveoops: Reserve low memory and
	register code
Message-ID: <20110125135326.GC10051@laptop>
References: <20110125134748.GA10051@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110125134748.GA10051@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Using the x86 memblock interface, reserve below 1-Mbyte low memory areas
for the Saveoops LongMode -> RealMode switch code, ring buffer, and stack.
All the low memory areas are dynamically allocated and reserved, giving
memblock enough flexibility to choose the best available areas possible.

To trigger Saveoops on panic(), it's registered using the kmsg_dump hooks.
That interface is quite racy for our goals, but it's quickly used now to
prototype the code (check the XXX mark for details.)

Once Saveoops code is triggered, it identity maps the first 2 MBytes (the
switch code disables paging), copy the log buffer to its reserved 8086-
accessible area, and jumps to the switch code (PATCH #1.)

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

 arch/x86/kernel/saveoops.c      |  219 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c         |    9 ++
 arch/x86/include/asm/saveoops.h |   15 +++
 arch/x86/kernel/Makefile        |    3 +
 lib/Kconfig.debug               |   15 +++
 5 files changed, 261 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/saveoops.c b/arch/x86/kernel/saveoops.c
new file mode 100644
index 0000000..f48fc0a
--- /dev/null
+++ b/arch/x86/kernel/saveoops.c
@@ -0,0 +1,219 @@
+/* PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE */
+
+/*
+ * SAVEOOPS -- Save kernel log buffer to disk upon panic()
+ *
+ * To safely access disk in situations like very early boot or where the
+ * disk access code itself is buggy, we use BIOS INT13h extended services.
+ * To access such services, switch to 8086 real-mode first.
+ */
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <linux/log2.h>
+#include <linux/time.h>
+#include <linux/kmsg_dump.h>
+#include <linux/memblock.h>
+#include <linux/sched.h>
+
+#include <asm/page.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/saveoops.h>
+
+/*
+ * We can only access the first MByte in real mode, thus allocate
+ * low-memory areas for the ring buffer, and rmode code and stack.
+ */
+static phys_addr_t ring_buf;
+static phys_addr_t code_buf;
+static phys_addr_t rmode_stack;
+
+/*
+ * Below 1-Mbyte pointer to lmode->rmode switch code.
+ */
+static void (* __noreturn rmode_switch)(phys_addr_t code_buf,
+					phys_addr_t ring_buf,
+					phys_addr_t rmode_stack,
+					uint64_t disk_lba,
+					uint64_t ring_buf_len);
+
+/*
+ * Absolute LBA address where the log will be saved on disk.
+ */
+static uint64_t disk_lba = CONFIG_SAVEOOPS_DISK_LBA;
+
+/*
+ * Extended BIOS services write to disk in units of 512-byte sectors.
+ * Thus, always align the ring buffer size on a 512-byte boundary.
+ */
+#define RMODE_SEGMENT_LIMIT	0x10000UL
+#define RING_SIZE		(60UL * 1024)
+#define SAVEOOPS_HEADER		"*SAVEOOPS-WRITTEN KERNEL LOG*"
+
+/*
+ * Page tables to identity map the first 2 Mbytes.
+ */
+static __aligned(PAGE_SIZE) pud_t ident_level3[PTRS_PER_PUD];
+static __aligned(PAGE_SIZE) pmd_t ident_level2[PTRS_PER_PMD];
+
+/*
+ * The lmode->rmode switching code needs to run from an identity page
+ * since it disables paging.
+ */
+static void build_identity_mappings(void)
+{
+	pgd_t *pgde;
+	pud_t *pude;
+	pmd_t *pmde;
+
+	pmde = ident_level2;
+	set_pmd(pmde, __pmd(0 + __PAGE_KERNEL_IDENT_LARGE_EXEC));
+
+	pude = ident_level3;
+	set_pud(pude, __pud(__pa(ident_level2) + _KERNPG_TABLE));
+
+	pgde = init_level4_pgt;
+	set_pgd(pgde, __pgd(__pa(ident_level3) + _KERNPG_TABLE));
+
+	__flush_tlb_all();
+}
+
+/*
+ * XXX: Our use of kmsg_dump interface is invalid. We completely halt the
+ *	machine when getting called; this means:
+ *	- other registered loggers won't have a chance to read the ring
+ *	- other CPU cores might also be accessing the disk, racing with
+ *	  BIOS code that will do the same.
+ *
+ *	Such interface is now used to get things going. A new interface
+ *	satisfying our special requirements needs to be created. A
+ *	solution is to do an rmode->lmode switch after writing to disk.
+ */
+static void saveoops_do_dump(struct kmsg_dumper *dumper,
+			     enum kmsg_dump_reason reason,
+			     const char *s1, unsigned long l1,
+			     const char *s2, unsigned long l2)
+{
+	unsigned long l1_cpy, l2_cpy, s1_start, s2_start;
+	struct timeval timestamp;
+	char *buf, *buf_orig;
+	int hdr_size;
+
+	if (reason != KMSG_DUMP_PANIC)
+		return;
+
+	do_gettimeofday(&timestamp);
+
+	buf = __va(ring_buf);
+	buf_orig = buf;
+	memset(buf, '\0', RING_SIZE);
+	buf += sprintf(buf, "%s\n", SAVEOOPS_HEADER);
+	buf += sprintf(buf, "%lu.%lu\n", timestamp.tv_sec, timestamp.tv_usec);
+
+	hdr_size = buf - buf_orig;
+	l2_cpy = min(l2, RING_SIZE - hdr_size);
+	l1_cpy = min(l1, RING_SIZE - hdr_size - l2_cpy);
+
+	s2_start = l2 - l2_cpy;
+	s1_start = l1 - l1_cpy;
+	memcpy(buf, s1 + s1_start, l1_cpy);
+	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
+
+	printk(KERN_EMERG "Saveoops: Saving kernel log to boot disk LBA "
+	       "address %llu\n", disk_lba);
+
+	local_irq_disable();
+	build_identity_mappings();
+	rmode_switch(code_buf, ring_buf, rmode_stack, disk_lba, RING_SIZE >> 9);
+}
+
+static struct kmsg_dumper saveoops_dumper = {
+	.dump = saveoops_do_dump,
+};
+
+/*
+ * Real-mode switch code start and end markers.
+ * @pmode16: 16-bit protected mode entry point; 8086-segments base.
+ */
+extern const char saveoops_start[];
+extern const char saveoops_end[];
+extern const char pmode16[];
+
+/*
+ * Simplify real mode segmented-addressing calculations
+ */
+#define RMODE_DATA_ALIGN	16
+
+void __init saveoops_init(void)
+{
+	unsigned int code_size, code_align;
+	int res;
+
+	if (disk_lba == -1) {
+		printk(KERN_INFO "Saveoops: No disk LBA given; will not save "
+		       "kernel log to disk upon panic.\n");
+		return;
+	}
+
+	BUILD_BUG_ON(!IS_ALIGNED(RING_SIZE, 512));
+	BUILD_BUG_ON(RING_SIZE > RMODE_SEGMENT_LIMIT);
+	BUILD_BUG_ON(RMODE_STACK_LEN > RMODE_SEGMENT_LIMIT);
+	BUG_ON((saveoops_end - pmode16) > RMODE_SEGMENT_LIMIT);
+
+	ring_buf = memblock_find_in_range(0, 1<<20, RING_SIZE, RMODE_DATA_ALIGN);
+	if (ring_buf == MEMBLOCK_ERROR) {
+		printk(KERN_ERR "Saveoops: requesting a low-memory region "
+		       "for ring buffer failed\n");
+		return;
+	}
+	memblock_x86_reserve_range(ring_buf, ring_buf + RING_SIZE,
+				   "SAVEOOPS ringbuf");
+	printk(KERN_INFO "Saveoops: Acquired [0x%llx-0x%llx] for the ring "
+	       "buffer\n", ring_buf, ring_buf + RING_SIZE);
+
+	/* The pmode->rmode switch code “MUST” be in a single page */
+	code_size = saveoops_end - saveoops_start;
+	code_align = roundup_pow_of_two(code_size);
+	code_buf = memblock_find_in_range(0, 1<<20, code_size, code_align);
+	if (code_buf == MEMBLOCK_ERROR) {
+		printk(KERN_ERR "Saveoops: requesting a low-memory region "
+		       "for mode-switching code failed\n");
+		goto fail3;
+	}
+	memblock_x86_reserve_range(code_buf, code_buf + code_size,
+				   "SAVEOOPS codebuf");
+	printk(KERN_INFO "Saveoops: Acquired [0x%llx-0x%llx] for rmode-switch "
+	       "code\n", code_buf, code_buf + code_size);
+
+	rmode_stack = memblock_find_in_range(0, 1<<20, RMODE_STACK_LEN,
+					     RMODE_DATA_ALIGN);
+	if (rmode_stack == MEMBLOCK_ERROR) {
+		printk(KERN_ERR "Saveoops: requesting a low-memory region "
+		       "for real-mode stack failed\n");
+		goto fail2;
+	}
+	memblock_x86_reserve_range(rmode_stack, rmode_stack + RMODE_STACK_LEN,
+				   "SAVEOOPS r-stack");
+	printk(KERN_INFO "Saveoops: Acquired [0x%llx-0x%llx] for rmode stack\n",
+	       rmode_stack, rmode_stack + RMODE_STACK_LEN);
+
+	res = kmsg_dump_register(&saveoops_dumper);
+	if (res) {
+		printk(KERN_ERR "Saveoops: registering kmsg dumper failed");
+		goto fail1;
+	}
+
+	memcpy(__va(code_buf), saveoops_start, code_size);
+	rmode_switch = (void *)code_buf;
+	return;
+
+fail1:
+	memblock_x86_free_range(rmode_stack, rmode_stack + RMODE_STACK_LEN);
+fail2:
+	memblock_x86_free_range(code_buf, code_buf + code_size);
+fail3:
+	memblock_x86_free_range(ring_buf, ring_buf + RING_SIZE);
+}
+
+/* PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE - PROTOTYPE */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d3cfe26..3686df8 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -50,6 +50,9 @@
 #include <asm/pci-direct.h>
 #include <linux/init_ohci1394_dma.h>
 #include <linux/kvm_para.h>
+#ifdef CONFIG_SAVEOOPS
+#include <asm/saveoops.h>
+#endif
 
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -925,6 +928,12 @@ void __init setup_arch(char **cmdline_p)
 	memblock.current_limit = get_max_mapped();
 	memblock_x86_fill();
 
+#ifdef CONFIG_SAVEOOPS
+	/* Initialize Saveoops at the earliest point possible: memblock
+	 * find_in_range is used here to reserve low-memory areas */
+	saveoops_init();
+#endif
+
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();

diff --git a/arch/x86/include/asm/saveoops.h b/arch/x86/include/asm/saveoops.h
new file mode 100644
index 0000000..d81e840
--- /dev/null
+++ b/arch/x86/include/asm/saveoops.h
@@ -0,0 +1,15 @@
+#ifndef _SAVEOOPS_H
+#define _SAVEOOPS_H
+
+/*
+ * Definitions shared between Saveoops C and assembly code.
+ */
+
+#define RMODE_STACK_LEN		0x1000	/* Arbitrary */
+
+#ifndef __ASSEMBLY__
+
+void __init saveoops_init(void);
+
+#endif /* !__ASSEMBLY__ */
+#endif /* _SAVEOOPS_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 34244b2..9a097f2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -121,4 +121,7 @@ ifeq ($(CONFIG_X86_64),y)
 
 	obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 	obj-y				+= vsmp_64.o
+
+	obj-$(CONFIG_SAVEOOPS)		+= saveoops.o
+	obj-$(CONFIG_SAVEOOPS)		+= saveoops-rmode.o
 endif
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4a78f8c..b994791 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -231,6 +231,21 @@ config BOOTPARAM_HUNG_TASK_PANIC
 
 	  Say N if unsure.
 
+config SAVEOOPS
+	bool "Save kernel panics to disk using BIOS"
+	depends on X86_64
+	---help---
+	  <TO-BE-ADDED>
+
+config SAVEOOPS_DISK_LBA
+       int "Boot disk LBA offset to save panic to"
+       default -1
+       depends on SAVEOOPS
+       ---help---
+	 Use this boot disk LBA address to save the kernel log.
+	 To find a partition LBA address use: $fdisk -ul
+	 [VERY DANGEROUS] <FURTHER-INFO-TO-BE-ADDED>
+
 config BOOTPARAM_HUNG_TASK_PANIC_VALUE
 	int
 	depends on DETECT_HUNG_TASK

--
Darwish
http://darwish.07.googlepages.com

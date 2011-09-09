Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab1IIBLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:11:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65123 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823Ab1IIBLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116679206"
Message-Id: <20110909010916.235688102@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:03 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 16/36] Hexagon: Add startup code
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=startup.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/kernel/head.S  |  162 ++++++++++++++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/reset.c |   38 ++++++++++
 arch/hexagon/kernel/setup.c |  145 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 345 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/kernel/head.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/head.S	2011-09-07 13:00:31.040646956 -0500
@@ -0,0 +1,162 @@
+/*
+ * Early kernel startup code for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/asm-offsets.h>
+#include <asm/mem-layout.h>
+#include <asm/vm_mmu.h>
+#include <asm/page.h>
+
+       	__INIT
+ENTRY(stext)
+	/*
+	 * VMM will already have set up true vector page, MMU, etc.
+	 * To set up initial kernel identity map, we have to pass
+	 * the VMM a pointer to some canonical page tables. In
+	 * this implementation, we're assuming that we've got
+	 * them precompiled. Generate value in R24, as we'll need
+	 * it again shortly.
+	 */
+	r24.L = #LO(swapper_pg_dir)
+	r24.H = #HI(swapper_pg_dir)
+
+	/*
+	 * Symbol is kernel segment address, but we need
+	 * the logical/physical address.
+	 */
+	r24 = asl(r24, #2)
+	r24 = lsr(r24, #2)
+
+	r0 = r24
+
+	/*
+	 * Initialize a 16MB PTE to make the virtual and physical
+	 * addresses where the kernel was loaded be identical.
+	 */
+#define PTE_BITS ( __HVM_PTE_R | __HVM_PTE_W | __HVM_PTE_X	\
+		  | __HEXAGON_C_WB_L2 << 6			\
+		  | __HVM_PDE_S_4MB)
+
+	r1 = pc
+	r2.H = #0xffc0
+	r2.L = #0x0000
+	r1 = and(r1,r2)		/* round PC to 4MB boundary	*/
+	r2 = lsr(r1, #22)	/* 4MB page number		*/
+	r2 = asl(r2, #2)	/* times sizeof(PTE) (4bytes)	*/
+	r0 = add(r0,r2)		/* r0 = address of correct PTE	*/
+	r2 = #PTE_BITS
+	r1 = add(r1,r2)		/* r1 = 4MB PTE for the first entry	*/
+	r2.h = #0x0040
+	r2.l = #0x0000		/* 4MB	*/
+	memw(r0 ++ #4) = r1
+	r1 = add(r1, r2)
+	memw(r0 ++ #4) = r1
+
+	r0 = r24
+
+	/*
+	 * The subroutine wrapper around the virtual instruction touches
+	 * no memory, so we should be able to use it even here.
+	 */
+	call	__vmnewmap;
+
+	/*  Jump into virtual address range.  */
+
+	r31.h = #hi(__head_s_vaddr_target)
+	r31.l = #lo(__head_s_vaddr_target)
+	jumpr r31
+
+	/*  Insert trippy space effects.  */
+
+__head_s_vaddr_target:
+	/*
+	 * Tear down VA=PA translation now that we are running
+	 * in the desgnated kernel segments.
+	 */
+	r0 = #__HVM_PDE_S_INVALID
+	r1 = r24
+	loop0(1f,#0x100)
+1:
+	{
+		memw(R1 ++ #4) = R0
+	}:endloop0
+
+	r0 = r24
+	call __vmnewmap
+
+	/*  Go ahead and install the trap0 return so angel calls work  */
+	r0.h = #hi(_K_provisional_vec)
+	r0.l = #lo(_K_provisional_vec)
+	call __vmsetvec
+
+	/*
+	 * OK, at this point we should start to be much more careful,
+	 * we're going to enter C code and start touching memory
+	 * in all sorts of places.
+	 * This means:
+	 *      SGP needs to be OK
+	 *	Need to lock shared resources
+	 *	A bunch of other things that will cause
+	 * 	all kinds of painful bugs
+	 */
+
+	/*
+	 * Stack pointer should be pointed at the init task's
+	 * thread stack, which should have been declared in arch/init_task.c.
+	 * So uhhhhh...
+	 * It's accessible via the init_thread_union, which is a union
+	 * of a thread_info struct and a stack; of course, the top
+	 * of the stack is not for you.  The end of the stack
+	 * is simply init_thread_union + THREAD_SIZE.
+	 */
+
+	{r29.H = #HI(init_thread_union); r0.H = #HI(_THREAD_SIZE); }
+	{r29.L = #LO(init_thread_union); r0.L = #LO(_THREAD_SIZE); }
+
+	/*  initialize the register used to point to current_thread_info */
+	/*  Fixme:  THREADINFO_REG can't be R2 because of that memset thing. */
+	{r29 = add(r29,r0); THREADINFO_REG = r29; }
+
+	/*  Hack:  zero bss; */
+	{ r0.L = #LO(__bss_start);  r1 = #0; r2.l = #LO(__bss_stop); }
+	{ r0.H = #HI(__bss_start);           r2.h = #HI(__bss_stop); }
+
+	r2 = sub(r2,r0);
+	call memset;
+
+	/* Time to make the doughnuts.   */
+	call start_kernel
+
+	/*
+	 * Should not reach here.
+	 */
+1:
+	jump 1b
+
+.p2align PAGE_SHIFT
+ENTRY(external_cmdline_buffer)
+        .fill _PAGE_SIZE,1,0
+
+.data
+.p2align PAGE_SHIFT
+ENTRY(empty_zero_page)
+        .fill _PAGE_SIZE,1,0
Index: linux-hexagon-kernel/arch/hexagon/kernel/reset.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/reset.c	2011-09-03 20:14:59.644981167 -0500
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/smp.h>
+#include <asm/hexagon_vm.h>
+
+void machine_power_off(void)
+{
+	smp_send_stop();
+	__vmstop();
+}
+
+void machine_halt(void)
+{
+}
+
+void machine_restart(char *cmd)
+{
+}
+
+void pm_power_off(void)
+{
+}
Index: linux-hexagon-kernel/arch/hexagon/kernel/setup.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/setup.c	2011-09-07 13:00:31.120647076 -0500
@@ -0,0 +1,145 @@
+/*
+ * Arch related setup for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/mmzone.h>
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+#include <linux/console.h>
+#include <linux/of_fdt.h>
+#include <asm/io.h>
+#include <asm/sections.h>
+#include <asm/setup.h>
+#include <asm/processor.h>
+#include <asm/hexagon_vm.h>
+#include <asm/vm_mmu.h>
+#include <asm/time.h>
+#ifdef CONFIG_OF
+#include <asm/prom.h>
+#endif
+
+char cmd_line[COMMAND_LINE_SIZE];
+static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
+
+int on_simulator;
+
+void __cpuinit calibrate_delay(void)
+{
+	loops_per_jiffy = thread_freq_mhz * 1000000 / HZ;
+}
+
+/*
+ * setup_arch -  high level architectural setup routine
+ * @cmdline_p: pointer to pointer to command-line arguments
+ */
+
+void __init setup_arch(char **cmdline_p)
+{
+	char *p = &external_cmdline_buffer;
+
+	/*
+	 * These will eventually be pulled in via either some hypervisor
+	 * or devicetree description.  Hardwiring for now.
+	 */
+	pcycle_freq_mhz = 600;
+	thread_freq_mhz = 100;
+	sleep_clk_freq = 32000;
+
+	/*
+	 * Set up event bindings to handle exceptions and interrupts.
+	 */
+	__vmsetvec(_K_VM_event_vector);
+
+	/*
+	 * Simulator has a few differences from the hardware.
+	 * For now, check uninitialized-but-mapped memory
+	 * prior to invoking setup_arch_memory().
+	 */
+	if (*(int *)((unsigned long)_end + 8) == 0x1f1f1f1f)
+		on_simulator = 1;
+	else
+		on_simulator = 0;
+
+	if (p[0] != '\0')
+		strlcpy(boot_command_line, p, COMMAND_LINE_SIZE);
+	else
+		strlcpy(boot_command_line, default_command_line,
+			COMMAND_LINE_SIZE);
+
+	/*
+	 * boot_command_line and the value set up by setup_arch
+	 * are both picked up by the init code. If no reason to
+	 * make them different, pass the same pointer back.
+	 */
+	strlcpy(cmd_line, boot_command_line, COMMAND_LINE_SIZE);
+	*cmdline_p = cmd_line;
+
+	parse_early_param();
+
+	setup_arch_memory();
+
+#ifdef CONFIG_SMP
+	smp_start_cpus();
+#endif
+}
+
+/*
+ * Functions for dumping CPU info via /proc
+ * Probably should move to kernel/proc.c or something.
+ */
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	return *pos < nr_cpu_ids ? (void *)((unsigned long) *pos + 1) : NULL;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	++*pos;
+	return c_start(m, pos);
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+}
+
+/*
+ * Eventually this will dump information about
+ * CPU properties like ISA level, TLB size, etc.
+ */
+static int show_cpuinfo(struct seq_file *m, void *v)
+{
+	int cpu = (unsigned long) v - 1;
+
+	seq_printf(m, "processor\t: %d\n", cpu);
+	seq_printf(m, "model name\t: Hexagon Virtual Machine\n");
+	seq_printf(m, "BogoMips\t: %lu.%02lu\n",
+		(loops_per_jiffy * HZ) / 500000,
+		((loops_per_jiffy * HZ) / 5000) % 100);
+	seq_printf(m, "\n");
+	return 0;
+}
+
+const struct seq_operations cpuinfo_op = {
+	.start  = &c_start,
+	.next   = &c_next,
+	.stop   = &c_stop,
+	.show   = &show_cpuinfo,
+};

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


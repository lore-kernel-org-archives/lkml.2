Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840Ab1C3Qxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:53:44 -0400
Received: from mxgmail1.tau.ac.il ([132.66.7.201]:43711 "EHLO
	mxgmail1.tau.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab1C3Qxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:53:42 -0400
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Mar 2011 12:53:40 EDT
Date: Wed, 30 Mar 2011 18:42:58 +0200
From: oded@comay.net
Message-Id: <201103301642.p2UGgwm1017183@pod.tau.ac.il>
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.4(!) support for new CPU APIC ID numbering scheme
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (pod.tau.ac.il [127.0.0.1]); Wed, 30 Mar 2011 18:43:03 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a bit off topic, so I apologies for the interruption. For reasons
beyond the scope of this thread, we are required to make a kernel 2.4 
based system work with newer Intel hardware. We would like to share a 
patch to kernel 2.4, and ask for opinions as to its appropriateness.

As it turns out, kernel 2.4 does work with newer CPUs and chipsets, but
not all cores are always detected. Further examination shows that cores   
are numbered in a non-consecutive manner (for example, an Intel 5520      
chipset based system with a single quad core CPU has the cores numbered 0,
2, 18, 20). The GET_APIC_ID macro is defined using a 0x0F mask, which
fails to retrieve correctly IDs above 15. In another configuration, when
two quad core CPUs are installed, some cores get IDs above 31.

The patch below involves two changes. One is to extend the mask used by
GET_APIC_ID macro to 0xFF when appropriate. The other change is to the 
phys_id_present_map bitmap, which stores the physical CPU APIC IDs. In 2.4
it is implemented as a long, capable of holding IDs up to 31. It is
extended to multiple longs based on Russ Weight's cpumap_t (an early
incarnation of cpumask_t). Other CPU maps structures (e.g. cpu_online_map,
cpu_present_map, etc.) are not changed, as they appear to use sequential  
numbering starting at 0.

We have tested the patched kernel with several hardware configurations
(including the mentioned above Intel 5520 chipset with up to 8 cores) and
it appears to work fine.

Opinions are appreciated.

Thanks,
Oded.
---
diff -ruNp linux-2.4.37.11.orig/arch/i386/kernel/apic.c linux-2.4.37.11/arch/i386/kernel/apic.c
--- linux-2.4.37.11.orig/arch/i386/kernel/apic.c	Sat Dec 18 17:29:59 2010
+++ linux-2.4.37.11/arch/i386/kernel/apic.c	Sun Mar 27 19:36:19 2011
@@ -303,7 +303,7 @@ void __init setup_local_APIC (void)
  	 * This is meaningless in clustered apic mode, so we skip it.
  	 */
  	if (!clustered_apic_mode && 
-	    !test_bit(GET_APIC_ID(apic_read(APIC_ID)), &phys_cpu_present_map))
+	    !cpumap_test_bit(GET_APIC_ID(apic_read(APIC_ID)), phys_cpu_present_map))
  		BUG();

  	/*
@@ -1210,7 +1210,7 @@ int __init APIC_init_uniprocessor (void)

  	connect_bsp_APIC();

-	phys_cpu_present_map = 1 << boot_cpu_physical_apicid;
+	cpumap_set_mask(boot_cpu_physical_apicid, phys_cpu_present_map);

  	apic_pm_init2();

diff -ruNp linux-2.4.37.11.orig/arch/i386/kernel/io_apic.c linux-2.4.37.11/arch/i386/kernel/io_apic.c
--- linux-2.4.37.11.orig/arch/i386/kernel/io_apic.c	Sat Dec 18 17:29:59 2010
+++ linux-2.4.37.11/arch/i386/kernel/io_apic.c	Sun Mar 27 19:44:12 2011
@@ -1082,15 +1082,23 @@ void disable_IO_APIC(void)
  static void __init setup_ioapic_ids_from_mpc (void)
  {
  	struct IO_APIC_reg_00 reg_00;
-	unsigned long phys_id_present_map = phys_cpu_present_map;
+	cpumap_t phys_id_present_map;
  	int apic;
  	int i;
  	unsigned char old_id;
  	unsigned long flags;

-	if (clustered_apic_mode)
+
+	if (clustered_apic_mode) {
  		/* We don't have a good way to do this yet - hack */
-		phys_id_present_map = (u_long) 0xf;
+		cpumap_set_mask(0, phys_id_present_map);
+		cpumap_set_bit(1, phys_id_present_map);
+		cpumap_set_bit(2, phys_id_present_map);
+		cpumap_set_bit(3, phys_id_present_map);
+	} 
+	else
+		cpumap_copy_mask(phys_cpu_present_map, phys_id_present_map);
+
  	/*
  	 * Set the IOAPIC ID to the value stored in the MPC table.
  	 */
@@ -1118,21 +1126,21 @@ static void __init setup_ioapic_ids_from
  		 * I/O APIC IDs no longer have any meaning for xAPICs and SAPICs.
  		 */
  		if ((clustered_apic_mode != CLUSTERED_APIC_XAPIC) &&
-		    (phys_id_present_map & (1 << mp_ioapics[apic].mpc_apicid))) {
+		     cpumap_test_bit(mp_ioapics[apic].mpc_apicid, phys_id_present_map)) {
  			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
  				apic, mp_ioapics[apic].mpc_apicid);
  			for (i = 0; i < 0xf; i++)
-				if (!(phys_id_present_map & (1 << i)))
+				if (!cpumap_test_bit(i, phys_id_present_map))
  					break;
  			if (i >= apic_broadcast_id)
  				panic("Max APIC ID exceeded!\n");
  			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
  				i);
-			phys_id_present_map |= 1 << i;
+			cpumap_set_bit(i, phys_id_present_map);
  			mp_ioapics[apic].mpc_apicid = i;
  		} else {
  			printk("Setting %d in the phys_id_present_map\n", mp_ioapics[apic].mpc_apicid);
-			phys_id_present_map |= 1 << mp_ioapics[apic].mpc_apicid;
+			cpumap_set_bit(mp_ioapics[apic].mpc_apicid, phys_id_present_map);
  		}


@@ -1734,7 +1742,8 @@ void __init setup_IO_APIC(void)
  int __init io_apic_get_unique_id (int ioapic, int apic_id)
  {
  	struct IO_APIC_reg_00 reg_00;
-	static unsigned long apic_id_map = 0;
+	static cpumap_t apic_id_map;
+	static int apic_id_map_copied = 0;
  	unsigned long flags;
  	int i = 0;

@@ -1747,8 +1756,10 @@ int __init io_apic_get_unique_id (int io
  	 *      advantage of new APIC bus architecture.
  	 */

-	if (!apic_id_map)
-		apic_id_map = phys_cpu_present_map;
+	if (!apic_id_map_copied) {
+		cpumap_copy_mask(phys_cpu_present_map, apic_id_map);
+		apic_id_map_copied=1;
+	}

  	spin_lock_irqsave(&ioapic_lock, flags);
  	*(int *)&reg_00 = io_apic_read(ioapic, 0);
@@ -1771,10 +1782,10 @@ int __init io_apic_get_unique_id (int io
  	 * Every APIC in a system must have a unique ID or we get lots of nice
  	 * 'stuck on smp_invalidate_needed IPI wait' messages.
  	 */
-	if (apic_id_map & (1 << apic_id)) {
+	if (cpumap_test_bit(apic_id, apic_id_map)) {

  		for (i = 0; i < IO_APIC_MAX_ID; i++) {
-			if (!(apic_id_map & (1 << i)))
+			if (!cpumap_test_bit(i, apic_id_map))
  				break;
  		}

@@ -1787,7 +1798,7 @@ int __init io_apic_get_unique_id (int io
  		apic_id = i;
  	}

-	apic_id_map |= (1 << apic_id);
+	cpumap_set_bit(apic_id, apic_id_map);

  	if (reg_00.ID != apic_id) {
  		reg_00.ID = apic_id;
diff -ruNp linux-2.4.37.11.orig/arch/i386/kernel/mpparse.c linux-2.4.37.11/arch/i386/kernel/mpparse.c
--- linux-2.4.37.11.orig/arch/i386/kernel/mpparse.c	Sat Dec 18 17:29:59 2010
+++ linux-2.4.37.11/arch/i386/kernel/mpparse.c	Sun Mar 27 19:33:34 2011
@@ -73,7 +73,7 @@ unsigned int boot_cpu_logical_apicid = -
  static unsigned int num_processors;

  /* Bitmask of physically existing CPUs */
-unsigned long phys_cpu_present_map;
+cpumap_t phys_cpu_present_map;
  unsigned long logical_cpu_present_map;

  #ifdef CONFIG_X86_CLUSTERED_APIC
@@ -256,7 +256,7 @@ void __init MP_processor_info (struct mp
  	ver = m->mpc_apicver;

  	logical_cpu_present_map |= 1 << (num_processors-1);
- 	phys_cpu_present_map |= apicid_to_phys_cpu_present(m->mpc_apicid);
+ 	cpumap_set_bit(m->mpc_apicid, phys_cpu_present_map);

  	/*
  	 * Validate version
@@ -945,7 +945,7 @@ void __init find_visws_smp(void)
  {
  	smp_found_config = 1;

-	phys_cpu_present_map |= 2; /* or in id 1 */
+	cpumap_set_bit(1, phys_cpu_present_map);
  	apic_version[1] |= 0x10; /* integrated APIC */
  	apic_version[0] |= 0x10;

diff -ruNp linux-2.4.37.11.orig/arch/i386/kernel/process.c linux-2.4.37.11/arch/i386/kernel/process.c
--- linux-2.4.37.11.orig/arch/i386/kernel/process.c	Sat Dec 18 17:29:59 2010
+++ linux-2.4.37.11/arch/i386/kernel/process.c	Sun Mar 27 19:33:34 2011
@@ -378,7 +378,7 @@ void machine_restart(char * __unused)
  		   if its not, default to the BSP */
  		if ((reboot_cpu == -1) ||
  		      (reboot_cpu > (NR_CPUS -1))  || 
-		      !(phys_cpu_present_map & apicid_to_phys_cpu_present(cpuid)))
+		       !cpumap_test_bit(cpuid, phys_cpu_present_map))
  			reboot_cpu = boot_cpu_physical_apicid;

  		reboot_smp = 0;  /* use this as a flag to only go through this once*/
diff -ruNp linux-2.4.37.11.orig/arch/i386/kernel/smpboot.c linux-2.4.37.11/arch/i386/kernel/smpboot.c
--- linux-2.4.37.11.orig/arch/i386/kernel/smpboot.c	Sat Dec 18 17:29:59 2010
+++ linux-2.4.37.11/arch/i386/kernel/smpboot.c	Sun Mar 27 19:33:34 2011
@@ -1027,7 +1027,8 @@ void __init smp_boot_cpus(void)
  #ifndef CONFIG_VISWS
  		io_apic_irqs = 0;
  #endif
-		cpu_online_map = phys_cpu_present_map = 1;
+		cpu_online_map = 1;
+		cpumap_set_mask(0, phys_cpu_present_map);
  		smp_num_cpus = 1;
  		if (APIC_init_uniprocessor())
  			printk(KERN_NOTICE "Local APIC not detected."
@@ -1041,10 +1042,10 @@ void __init smp_boot_cpus(void)
  	 * Makes no sense to do this check in clustered apic mode, so skip it
  	 */
  	if (!clustered_apic_mode && 
-	    !test_bit(boot_cpu_physical_apicid, &phys_cpu_present_map)) {
+	    !cpumap_test_bit(boot_cpu_physical_apicid, phys_cpu_present_map)) {
  		printk("weird, boot CPU (#%d) not listed by the BIOS.\n",
  							boot_cpu_physical_apicid);
-		phys_cpu_present_map |= (1 << hard_smp_processor_id());
+		cpumap_set_bit(hard_smp_processor_id(), phys_cpu_present_map);
  	}

  	/*
@@ -1058,7 +1059,8 @@ void __init smp_boot_cpus(void)
  #ifndef CONFIG_VISWS
  		io_apic_irqs = 0;
  #endif
-		cpu_online_map = phys_cpu_present_map = 1;
+		cpu_online_map = 1;
+		cpumap_set_mask(0, phys_cpu_present_map);
  		smp_num_cpus = 1;
  		goto smp_done;
  	}
@@ -1074,7 +1076,8 @@ void __init smp_boot_cpus(void)
  #ifndef CONFIG_VISWS
  		io_apic_irqs = 0;
  #endif
-		cpu_online_map = phys_cpu_present_map = 1;
+		cpu_online_map = 1;
+		cpumap_set_mask(0, phys_cpu_present_map);
  		smp_num_cpus = 1;
  		goto smp_done;
  	}
@@ -1092,9 +1095,9 @@ void __init smp_boot_cpus(void)
  	 * bits 0-3 are quad0, 4-7 are quad1, etc. A perverse twist on the
  	 * clustered apic ID.
  	 */
-	Dprintk("CPU present map: %lx\n", phys_cpu_present_map);
+	cpumap_printk("CPU present map: ", phys_cpu_present_map);

-	for (bit = 0; bit < BITS_PER_LONG; bit++) {
+	for (bit = 0; bit < CPUMAP_NR_CPUS; bit++) {
  		apicid = cpu_present_to_apicid(bit);

  		/* don't try to boot BAD_APICID */
@@ -1106,7 +1109,7 @@ void __init smp_boot_cpus(void)
  		if (apicid == boot_cpu_apicid)
  			continue;

-		if (!(phys_cpu_present_map & apicid_to_phys_cpu_present(apicid)))
+		if (!cpumap_test_bit(apicid, phys_cpu_present_map))
  			continue;

  		do_boot_cpu(apicid);
@@ -1115,8 +1118,7 @@ void __init smp_boot_cpus(void)
  		 * Make sure we unmap all failed CPUs
  		 */
  		if ((boot_apicid_to_cpu(apicid) == -1) &&
-			(phys_cpu_present_map & 
-				apicid_to_phys_cpu_present(apicid)))
+			cpumap_test_bit(apicid, phys_cpu_present_map))
  			printk("CPU #%d/0x%02x not responding - cannot use it.\n",
  								bit, apicid);
  	}
diff -ruNp linux-2.4.37.11.orig/include/asm/apicdef.h linux-2.4.37.11/include/asm/apicdef.h
--- linux-2.4.37.11.orig/include/asm/apicdef.h	Sun Feb  6 18:52:14 2011
+++ linux-2.4.37.11/include/asm/apicdef.h	Sun Mar 27 20:08:34 2011
@@ -12,13 +12,22 @@

  #define		APIC_ID		0x20
  #define			APIC_ID_MASK		(0x0F<<24)
-#define			GET_APIC_ID(x)		(((x)>>24)&0x0F)
  #define		APIC_LVR	0x30
  #define			APIC_LVR_MASK		0xFF00FF
  #define			GET_APIC_VERSION(x)	((x)&0xFF)
  #define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
  #define			APIC_INTEGRATED(x)	((x)&0xF0)
  #define			APIC_XAPIC_SUPPORT(x)	((x)>=0x14)
+static __inline unsigned long apic_read(unsigned long reg);
+static inline unsigned get_apic_id(unsigned long x)
+{
+	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+	if (APIC_XAPIC_SUPPORT(ver))
+		return (((x)>>24)&0xFF);
+	else
+		return (((x)>>24)&0xF);
+}
+#define         GET_APIC_ID(x) get_apic_id(x)
  #define		APIC_TASKPRI	0x80
  #define			APIC_TPRI_MASK		0xFF
  #define		APIC_ARBPRI	0x90
diff -ruNp linux-2.4.37.11.orig/include/asm/mpspec.h linux-2.4.37.11/include/asm/mpspec.h
--- linux-2.4.37.11.orig/include/asm/mpspec.h	Sun Feb  6 18:52:14 2011
+++ linux-2.4.37.11/include/asm/mpspec.h	Sun Mar 27 19:33:34 2011
@@ -1,5 +1,6 @@
  #ifndef __ASM_MPSPEC_H
  #define __ASM_MPSPEC_H
+#include <linux/cpumap.h>

  /*
   * Structure definitions for SMP machines following the
@@ -205,7 +206,7 @@ extern int *mp_bus_id_to_pci_bus;
  extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];

  extern unsigned int boot_cpu_physical_apicid;
-extern unsigned long phys_cpu_present_map;
+extern cpumap_t phys_cpu_present_map;
  extern int smp_found_config;
  extern void find_smp_config (void);
  extern void get_smp_config (void);
diff -ruNp linux-2.4.37.11.orig/include/asm/smp.h linux-2.4.37.11/include/asm/smp.h
--- linux-2.4.37.11.orig/include/asm/smp.h	Sun Feb  6 19:27:37 2011
+++ linux-2.4.37.11/include/asm/smp.h	Sun Mar 27 19:33:34 2011
@@ -8,6 +8,7 @@
  #include <linux/config.h>
  #include <linux/threads.h>
  #include <linux/ptrace.h>
+#include <linux/cpumap.h>
  #endif

  #ifdef CONFIG_X86_LOCAL_APIC
@@ -30,7 +31,7 @@
   */

  extern void smp_alloc_memory(void);
-extern unsigned long phys_cpu_present_map;
+extern cpumap_t phys_cpu_present_map;
  extern unsigned long cpu_online_map;
  extern volatile unsigned long smp_invalidate_needed;
  extern int pic_mode;
diff -ruNp linux-2.4.37.11.orig/include/asm-i386/apicdef.h linux-2.4.37.11/include/asm-i386/apicdef.h
--- linux-2.4.37.11.orig/include/asm-i386/apicdef.h	Sun Feb  6 18:52:14 2011
+++ linux-2.4.37.11/include/asm-i386/apicdef.h	Sun Mar 27 20:08:34 2011
@@ -12,13 +12,22 @@

  #define		APIC_ID		0x20
  #define			APIC_ID_MASK		(0x0F<<24)
-#define			GET_APIC_ID(x)		(((x)>>24)&0x0F)
  #define		APIC_LVR	0x30
  #define			APIC_LVR_MASK		0xFF00FF
  #define			GET_APIC_VERSION(x)	((x)&0xFF)
  #define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFF)
  #define			APIC_INTEGRATED(x)	((x)&0xF0)
  #define			APIC_XAPIC_SUPPORT(x)	((x)>=0x14)
+static __inline unsigned long apic_read(unsigned long reg);
+static inline unsigned get_apic_id(unsigned long x)
+{
+	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+	if (APIC_XAPIC_SUPPORT(ver))
+		return (((x)>>24)&0xFF);
+	else
+		return (((x)>>24)&0xF);
+}
+#define         GET_APIC_ID(x) get_apic_id(x)
  #define		APIC_TASKPRI	0x80
  #define			APIC_TPRI_MASK		0xFF
  #define		APIC_ARBPRI	0x90
diff -ruNp linux-2.4.37.11.orig/include/asm-i386/mpspec.h linux-2.4.37.11/include/asm-i386/mpspec.h
--- linux-2.4.37.11.orig/include/asm-i386/mpspec.h	Sun Feb  6 18:52:14 2011
+++ linux-2.4.37.11/include/asm-i386/mpspec.h	Sun Mar 27 19:33:34 2011
@@ -1,5 +1,6 @@
  #ifndef __ASM_MPSPEC_H
  #define __ASM_MPSPEC_H
+#include <linux/cpumap.h>

  /*
   * Structure definitions for SMP machines following the
@@ -205,7 +206,7 @@ extern int *mp_bus_id_to_pci_bus;
  extern int quad_local_to_mp_bus_id [NR_CPUS/4][4];

  extern unsigned int boot_cpu_physical_apicid;
-extern unsigned long phys_cpu_present_map;
+extern cpumap_t phys_cpu_present_map;
  extern int smp_found_config;
  extern void find_smp_config (void);
  extern void get_smp_config (void);
diff -ruNp linux-2.4.37.11.orig/include/asm-i386/smp.h linux-2.4.37.11/include/asm-i386/smp.h
--- linux-2.4.37.11.orig/include/asm-i386/smp.h	Sun Feb  6 19:27:37 2011
+++ linux-2.4.37.11/include/asm-i386/smp.h	Sun Mar 27 19:33:34 2011
@@ -8,6 +8,7 @@
  #include <linux/config.h>
  #include <linux/threads.h>
  #include <linux/ptrace.h>
+#include <linux/cpumap.h>
  #endif

  #ifdef CONFIG_X86_LOCAL_APIC
@@ -30,7 +31,7 @@
   */

  extern void smp_alloc_memory(void);
-extern unsigned long phys_cpu_present_map;
+extern cpumap_t phys_cpu_present_map;
  extern unsigned long cpu_online_map;
  extern volatile unsigned long smp_invalidate_needed;
  extern int pic_mode;
diff -ruNp linux-2.4.37.11.orig/include/linux/cpumap.h linux-2.4.37.11/include/linux/cpumap.h
--- linux-2.4.37.11.orig/include/linux/cpumap.h	Thu Jan  1 02:00:00 1970
+++ linux-2.4.37.11/include/linux/cpumap.h	Sun Mar 27 19:33:34 2011
@@ -0,0 +1,134 @@
+/*
+ * cpumap_t data type and supporting functions
+ *
+ * Copyright (c) 2002 IBM Corp.
+ *
+ *	01/25/02 Initial Version 	Russ Weight <rweight@us.ibm.com>
+ *	03/20/02 Move larger functions to cpumap.c	Russ Weight
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#ifndef __LINUX_CPUMAP_H
+#define __LINUX_CPUMAP_H
+
+#include <linux/config.h>
+#include <linux/threads.h>
+#include <asm/types.h>
+
+#define CPUMAP_NR_CPUS 64
+#define CPUMAP_SIZE       ((CPUMAP_NR_CPUS + BITS_PER_LONG - 1) / BITS_PER_LONG)
+
+#ifndef __ASSEMBLY__
+#include <linux/bitops.h>
+typedef unsigned long cpumap_t[CPUMAP_SIZE];
+
+/*
+ * The following interfaces are the same regardless of CPUMAP_SIZE
+ */
+#define cpumap_clear_bit	clear_bit
+#define cpumap_set_bit		set_bit
+#define cpumap_test_and_set_bit	test_and_set_bit
+#define cpumap_test_bit		test_bit
+
+#define cpumap_bits(map)	(map)
+
+#if (CPUMAP_NR_CPUS % BITS_PER_LONG)
+#define CPUMAP_FILLMASK	((1UL << (CPUMAP_NR_CPUS % BITS_PER_LONG)) -1)
+#else
+#define CPUMAP_FILLMASK	(~0UL)
+#endif
+
+#if CPUMAP_NR_CPUS <= BITS_PER_LONG
+#define CPU_BITS_ALL						\
+{								\
+	[BITS_TO_LONGS(CPUMAP_NR_CPUS)-1] = CPUMAP_FILLMASK		\
+}
+
+#else /* CPUMAP_NR_CPUS > BITS_PER_LONG */
+
+#define CPU_BITS_ALL						\
+{								\
+        [0 ... BITS_TO_LONGS(CPUMAP_NR_CPUS)-2] = ~0UL,		\
+        [BITS_TO_LONGS(CPUMAP_NR_CPUS)-1] = CPUMAP_FILLMASK		\
+}
+#endif /* CPUMAP_NR_CPUS > BITS_PER_LONG */
+
+/*
+ * The following macros and prototype are used to format
+ * a cpumap_t object for display. This function knows the 
+ * minimum size required, which is provided as CPUMAP_BUFSIZE.
+ *
+ * The CPUMAP_BUFSIZE is an exact calcuation of the byte count
+ * required to display a cpumap_t object.
+ */
+
+#define CPUMAP_BUFSIZE (((sizeof(long) * 2) + 1) * CPUMAP_SIZE + 2)
+
+#if BITS_PER_LONG > 32
+#define CPUMAP_FORMAT_STR	"%016lx"
+#else
+#define CPUMAP_FORMAT_STR	"%08lx"
+#endif
+extern char *cpumap_format(cpumap_t map, char *buf, int size);
+
+#if CPUMAP_SIZE == 1
+/*
+ * The following interfaces are optimized for the case where
+ * CPUMAP_SIZE==1 (i.e. a single unsigned long). The single
+ * CPU case falls into the CPUMAP_SIZE==1 case.
+ */
+#define cpumap_to_ulong(cpumap)			(cpumap[0])
+#define cpumap_ulong_to_cpumap(bitmap, cpumap)	(cpumap[0] = bitmap)
+#define cpumap_is_empty(cpumap) 		(cpumap[0] == 0)
+#define cpumap_is_full(cpumap) 			(cpumap[0] == ~0UL)
+#define cpumap_equal_mask(map1, map2)		(map1[0] ==  map2[0])
+#define cpumap_clear_mask(cpumap)		(cpumap[0] = 0)
+#define cpumap_fill(cpumap)			(cpumap[0] = CPUMAP_FILLMASK)
+#define cpumap_copy_mask(srcmap, destmap) 	(destmap[0] = srcmap[0])
+#define cpumap_and_mask(map1, map2, result)	(result[0] = map1[0] & map2[0])
+#define cpumap_intersect(map1, map2)		(map1[0] & map2[0])
+
+#else
+
+/*
+ * The cpumap_to_ulong() and cpumap_ulong_to_cpumap() functions
+ * are provided to facilitate migration to the cpumap_t datatype.
+ * As currently defined, they are only valid for CPUMAP_SIZE==1.
+ * If they are referenced when CPUMAP_SIZE > 1, then we call a
+ * bogus function name in order to trigger a link-time error.
+ */
+extern unsigned long __bad_cpumap_to_ulong(void);
+extern void __bad_cpumap_ulong_to_cpumap(void);
+#define cpumap_to_ulong(cpumap)			__bad_cpumap_to_ulong()
+#define cpumap_ulong_to_cpumap(bitmap, cpumap)	__bad_cpumap_ulong_to_cpumap()
+
+extern int cpumap_is_empty(cpumap_t map);
+extern int cpumap_is_full(cpumap_t map);
+extern int cpumap_equal_mask(cpumap_t map1, cpumap_t map2);
+extern void cpumap_clear_mask(cpumap_t cpumap);
+extern void cpumap_fill(cpumap_t cpumap);
+extern void cpumap_copy_mask(cpumap_t srcmap, cpumap_t destmap);
+extern void cpumap_and_mask(cpumap_t map1, cpumap_t map2, cpumap_t result);
+extern int  cpumap_intersect(cpumap_t map1, cpumap_t map2);
+
+#endif
+#define cpumap_set_mask(bit, map) (cpumap_clear_mask(map), cpumap_set_bit(bit, map))
+#define cpumap_printk(title, map) do { char __buf[CPUMAP_BUFSIZE]; printk(title "%s\n", cpumap_format(map, __buf, CPUMAP_BUFSIZE)); } while (0);
+#endif
+#endif
diff -ruNp linux-2.4.37.11.orig/lib/Makefile linux-2.4.37.11/lib/Makefile
--- linux-2.4.37.11.orig/lib/Makefile	Sat Dec 18 17:29:59 2010
+++ linux-2.4.37.11/lib/Makefile	Sun Mar 27 19:33:34 2011
@@ -9,10 +9,10 @@
  L_TARGET := lib.a

  export-objs := cmdline.o dec_and_lock.o rwsem-spinlock.o rwsem.o \
-	       rbtree.o crc32.o firmware_class.o
+	       rbtree.o crc32.o firmware_class.o cpumap.o

  obj-y := errno.o ctype.o string.o vsprintf.o brlock.o cmdline.o \
-	 bust_spinlocks.o rbtree.o dump_stack.o
+	 bust_spinlocks.o rbtree.o dump_stack.o cpumap.o

  obj-$(CONFIG_FW_LOADER) += firmware_class.o
  obj-$(CONFIG_RWSEM_GENERIC_SPINLOCK) += rwsem-spinlock.o
diff -ruNp linux-2.4.37.11.orig/lib/cpumap.c linux-2.4.37.11/lib/cpumap.c
--- linux-2.4.37.11.orig/lib/cpumap.c	Thu Jan  1 02:00:00 1970
+++ linux-2.4.37.11/lib/cpumap.c	Sun Mar 27 19:33:34 2011
@@ -0,0 +1,148 @@
+/*
+ * Supporting functions for cpumap_t data type
+ *
+ * Copyright (c) 2002 IBM Corp.
+ *
+ *	03/20/02 Initial Version 	Russ Weight <rweight@us.ibm.com>
+ *
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or (at
+ * your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/cpumap.h>
+#include <asm/string.h>
+
+/* Not all architectures define BUG() */
+#ifndef BUG
+  #define BUG() do { \
+	printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); \
+	* ((char *) 0) = 0; \
+  } while (0)
+#endif /* BUG */
+
+/*
+ * The cpumap_format() function is used to format a cpumap_t
+ * object for display. This function knows the minimum size
+ * required, which is provided as CPUMAP_BUFSIZE.
+ */
+char *cpumap_format(cpumap_t map, char *buf, int size)
+{
+	if (size < CPUMAP_BUFSIZE) {
+		BUG();
+	}
+
+#if CPUMAP_SIZE > 1
+	sprintf(buf, "0x" CPUMAP_FORMAT_STR, map[CPUMAP_SIZE-1]);
+	{
+		int i;
+		char *p = buf + strlen(buf);
+		for (i = CPUMAP_SIZE-2; i >= 0; i--, p += (sizeof(long) + 1)) {
+			sprintf(p, " " CPUMAP_FORMAT_STR, map[i]);
+		}
+	}
+#else
+	sprintf(buf, "0x" CPUMAP_FORMAT_STR, map[0]);
+#endif
+	return(buf);
+}
+
+#if CPUMAP_SIZE > 1
+/*
+ * The following interfaces are provided for (CPUMAP_SIZE > 1).
+ * For the case of (CPUMAP_SIZE==1) (i.e. a single unsigned long),
+ * the same interfaces are provided as inline functions in cpumap.h.
+ */
+int cpumap_is_empty(cpumap_t cpumap)
+{
+	int i;
+	for (i = 0; i < CPUMAP_SIZE; i++) {
+		if (cpumap[i] !=  0) {
+			return 0;
+		}
+	}
+	return 1;
+}
+int cpumap_is_full(cpumap_t cpumap)
+{
+	int i;
+	for (i = 0; i < CPUMAP_SIZE; i++) {
+		if (cpumap[i] !=  ~0UL) {
+			return 0;
+		}
+	}
+	return 1;
+}
+
+/*
+ * Return 1 (non-zero) if they are equal, 0 if not equal
+ */
+int cpumap_equal_mask(cpumap_t map1, cpumap_t map2)
+{
+	int i;
+	for (i = 0; i < CPUMAP_SIZE; i++) {
+		if (map1[i] !=  map2[i]) {
+			return 0;
+		}
+	}
+	return 1;
+}
+
+void cpumap_clear_mask(cpumap_t cpumap)
+{
+	int i;
+	for (i = 0; i < CPUMAP_SIZE; i++) {
+		cpumap[i] = 0UL;
+	}
+}
+
+void cpumap_fill(cpumap_t cpumap)
+{
+	int i;
+	for (i = 0; i < (CPUMAP_SIZE - 1); i++) {
+		cpumap[i] = ~0UL;
+	}
+	cpumap[CPUMAP_SIZE - 1] = CPUMAP_FILLMASK;
+}
+
+/*
+ * The following interfaces are optimized for the case where
+ * CPUMAP_SIZE==1 (i.e. a single unsigned long).
+ */
+void cpumap_copy_mask(cpumap_t srcmap, cpumap_t destmap)
+{
+	int i;
+	for (i = 0; i < CPUMAP_SIZE; i++) {
+		destmap[i] = srcmap[i];
+	}
+}
+
+void cpumap_and_mask(cpumap_t map1, cpumap_t map2, cpumap_t result)
+{
+	int i;
+	for (i = 0; i < CPUMAP_SIZE; i++) {
+		result[i] = map1[i] & map2[i];
+	}
+}
+
+int cpumap_intersect(cpumap_t map1, cpumap_t map2)
+{
+	cpumap_t temp;
+	cpumap_and_mask(map1, map2, temp);
+	return !cpumap_is_empty(temp);
+}
+#endif



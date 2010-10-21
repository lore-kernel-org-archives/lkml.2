Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab0JUOLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:11:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab0JUOLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:11:09 -0400
Date: Thu, 21 Oct 2010 16:10:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/vmware for v2.6.37
Message-ID: <20101021141051.GA9465@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-vmware-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-vmware-for-linus

 Thanks,

	Ingo

------------------>
Alok Kataria (2):
      x86, vmware: Remove deprecated VMI kernel support
      x86, paravirt: Remove alloc_pmd_clone hook, only used by VMI


 Documentation/feature-removal-schedule.txt |   28 -
 Documentation/kernel-parameters.txt        |    2 +-
 arch/x86/Kconfig                           |   19 -
 arch/x86/include/asm/paravirt.h            |    5 -
 arch/x86/include/asm/paravirt_types.h      |    1 -
 arch/x86/include/asm/vmi.h                 |  269 ---------
 arch/x86/include/asm/vmi_time.h            |   98 ---
 arch/x86/kernel/Makefile                   |    1 -
 arch/x86/kernel/paravirt.c                 |    1 -
 arch/x86/kernel/setup.c                    |   12 +-
 arch/x86/kernel/smpboot.c                  |    2 -
 arch/x86/kernel/vmi_32.c                   |  893 ----------------------------
 arch/x86/kernel/vmiclock_32.c              |  317 ----------
 arch/x86/mm/pgtable.c                      |    4 -
 arch/x86/xen/mmu.c                         |    1 -
 15 files changed, 5 insertions(+), 1648 deletions(-)
 delete mode 100644 arch/x86/include/asm/vmi.h
 delete mode 100644 arch/x86/include/asm/vmi_time.h
 delete mode 100644 arch/x86/kernel/vmi_32.c
 delete mode 100644 arch/x86/kernel/vmiclock_32.c

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 842aa9d..5e2bc4a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -386,34 +386,6 @@ Who:	Tejun Heo <tj@kernel.org>
 
 ----------------------------
 
-What:	Support for VMware's guest paravirtuliazation technique [VMI] will be
-	dropped.
-When:	2.6.37 or earlier.
-Why:	With the recent innovations in CPU hardware acceleration technologies
-	from Intel and AMD, VMware ran a few experiments to compare these
-	techniques to guest paravirtualization technique on VMware's platform.
-	These hardware assisted virtualization techniques have outperformed the
-	performance benefits provided by VMI in most of the workloads. VMware
-	expects that these hardware features will be ubiquitous in a couple of
-	years, as a result, VMware has started a phased retirement of this
-	feature from the hypervisor. We will be removing this feature from the
-	Kernel too. Right now we are targeting 2.6.37 but can retire earlier if
-	technical reasons (read opportunity to remove major chunk of pvops)
-	arise.
-
-	Please note that VMI has always been an optimization and non-VMI kernels
-	still work fine on VMware's platform.
-	Latest versions of VMware's product which support VMI are,
-	Workstation 7.0 and VSphere 4.0 on ESX side, future maintainence
-	releases for these products will continue supporting VMI.
-
-	For more details about VMI retirement take a look at this,
-	http://blogs.vmware.com/guestosguide/2009/09/vmi-retirement.html
-
-Who:	Alok N Kataria <akataria@vmware.com>
-
-----------------------------
-
 What:	Support for lcd_switch and display_get in asus-laptop driver
 When:	March 2010
 Why:	These two features use non-standard interfaces. There are the
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 2c85c06..5824098 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -455,7 +455,7 @@ and is between 256 and 4096 characters. It is defined in the file
 			[ARM] imx_timer1,OSTS,netx_timer,mpu_timer2,
 				pxa_timer,timer3,32k_counter,timer0_1
 			[AVR32] avr32
-			[X86-32] pit,hpet,tsc,vmi-timer;
+			[X86-32] pit,hpet,tsc;
 				scx200_hrt on Geode; cyclone on IBM x440
 			[MIPS] MIPS
 			[PARISC] cr16
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..f0ee331 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -517,25 +517,6 @@ if PARAVIRT_GUEST
 
 source "arch/x86/xen/Kconfig"
 
-config VMI
-	bool "VMI Guest support (DEPRECATED)"
-	select PARAVIRT
-	depends on X86_32
-	---help---
-	  VMI provides a paravirtualized interface to the VMware ESX server
-	  (it could be used by other hypervisors in theory too, but is not
-	  at the moment), by linking the kernel to a GPL-ed ROM module
-	  provided by the hypervisor.
-
-	  As of September 2009, VMware has started a phased retirement
-	  of this feature from VMware's products. Please see
-	  feature-removal-schedule.txt for details.  If you are
-	  planning to enable this option, please note that you cannot
-	  live migrate a VMI enabled VM to a future VMware product,
-	  which doesn't support VMI. So if you expect your kernel to
-	  seamlessly migrate to newer VMware products, keep this
-	  disabled.
-
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5653f43..edecb4e 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -416,11 +416,6 @@ static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)
 	PVOP_VCALL2(pv_mmu_ops.alloc_pmd, mm, pfn);
 }
 
-static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,
-					    unsigned long start, unsigned long count)
-{
-	PVOP_VCALL4(pv_mmu_ops.alloc_pmd_clone, pfn, clonepfn, start, count);
-}
 static inline void paravirt_release_pmd(unsigned long pfn)
 {
 	PVOP_VCALL1(pv_mmu_ops.release_pmd, pfn);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index db9ef55..b82bac9 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -255,7 +255,6 @@ struct pv_mmu_ops {
 	 */
 	void (*alloc_pte)(struct mm_struct *mm, unsigned long pfn);
 	void (*alloc_pmd)(struct mm_struct *mm, unsigned long pfn);
-	void (*alloc_pmd_clone)(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count);
 	void (*alloc_pud)(struct mm_struct *mm, unsigned long pfn);
 	void (*release_pte)(unsigned long pfn);
 	void (*release_pmd)(unsigned long pfn);
diff --git a/arch/x86/include/asm/vmi.h b/arch/x86/include/asm/vmi.h
deleted file mode 100644
index 61e08c0..0000000
--- a/arch/x86/include/asm/vmi.h
+++ /dev/null
@@ -1,269 +0,0 @@
-/*
- * VMI interface definition
- *
- * Copyright (C) 2005, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Maintained by: Zachary Amsden zach@vmware.com
- *
- */
-#include <linux/types.h>
-
-/*
- *---------------------------------------------------------------------
- *
- *  VMI Option ROM API
- *
- *---------------------------------------------------------------------
- */
-#define VMI_SIGNATURE 0x696d5663   /* "cVmi" */
-
-#define PCI_VENDOR_ID_VMWARE            0x15AD
-#define PCI_DEVICE_ID_VMWARE_VMI        0x0801
-
-/*
- * We use two version numbers for compatibility, with the major
- * number signifying interface breakages, and the minor number
- * interface extensions.
- */
-#define VMI_API_REV_MAJOR       3
-#define VMI_API_REV_MINOR       0
-
-#define VMI_CALL_CPUID			0
-#define VMI_CALL_WRMSR			1
-#define VMI_CALL_RDMSR			2
-#define VMI_CALL_SetGDT			3
-#define VMI_CALL_SetLDT			4
-#define VMI_CALL_SetIDT			5
-#define VMI_CALL_SetTR			6
-#define VMI_CALL_GetGDT			7
-#define VMI_CALL_GetLDT			8
-#define VMI_CALL_GetIDT			9
-#define VMI_CALL_GetTR			10
-#define VMI_CALL_WriteGDTEntry		11
-#define VMI_CALL_WriteLDTEntry		12
-#define VMI_CALL_WriteIDTEntry		13
-#define VMI_CALL_UpdateKernelStack	14
-#define VMI_CALL_SetCR0			15
-#define VMI_CALL_SetCR2			16
-#define VMI_CALL_SetCR3			17
-#define VMI_CALL_SetCR4			18
-#define VMI_CALL_GetCR0			19
-#define VMI_CALL_GetCR2			20
-#define VMI_CALL_GetCR3			21
-#define VMI_CALL_GetCR4			22
-#define VMI_CALL_WBINVD			23
-#define VMI_CALL_SetDR			24
-#define VMI_CALL_GetDR			25
-#define VMI_CALL_RDPMC			26
-#define VMI_CALL_RDTSC			27
-#define VMI_CALL_CLTS			28
-#define VMI_CALL_EnableInterrupts	29
-#define VMI_CALL_DisableInterrupts	30
-#define VMI_CALL_GetInterruptMask	31
-#define VMI_CALL_SetInterruptMask	32
-#define VMI_CALL_IRET			33
-#define VMI_CALL_SYSEXIT		34
-#define VMI_CALL_Halt			35
-#define VMI_CALL_Reboot			36
-#define VMI_CALL_Shutdown		37
-#define VMI_CALL_SetPxE			38
-#define VMI_CALL_SetPxELong		39
-#define VMI_CALL_UpdatePxE		40
-#define VMI_CALL_UpdatePxELong		41
-#define VMI_CALL_MachineToPhysical	42
-#define VMI_CALL_PhysicalToMachine	43
-#define VMI_CALL_AllocatePage		44
-#define VMI_CALL_ReleasePage		45
-#define VMI_CALL_InvalPage		46
-#define VMI_CALL_FlushTLB		47
-#define VMI_CALL_SetLinearMapping	48
-
-#define VMI_CALL_SetIOPLMask		61
-#define VMI_CALL_SetInitialAPState	62
-#define VMI_CALL_APICWrite		63
-#define VMI_CALL_APICRead		64
-#define VMI_CALL_IODelay		65
-#define VMI_CALL_SetLazyMode		73
-
-/*
- *---------------------------------------------------------------------
- *
- * MMU operation flags
- *
- *---------------------------------------------------------------------
- */
-
-/* Flags used by VMI_{Allocate|Release}Page call */
-#define VMI_PAGE_PAE             0x10  /* Allocate PAE shadow */
-#define VMI_PAGE_CLONE           0x20  /* Clone from another shadow */
-#define VMI_PAGE_ZEROED          0x40  /* Page is pre-zeroed */
-
-
-/* Flags shared by Allocate|Release Page and PTE updates */
-#define VMI_PAGE_PT              0x01
-#define VMI_PAGE_PD              0x02
-#define VMI_PAGE_PDP             0x04
-#define VMI_PAGE_PML4            0x08
-
-#define VMI_PAGE_NORMAL          0x00 /* for debugging */
-
-/* Flags used by PTE updates */
-#define VMI_PAGE_CURRENT_AS      0x10 /* implies VMI_PAGE_VA_MASK is valid */
-#define VMI_PAGE_DEFER           0x20 /* may queue update until TLB inval */
-#define VMI_PAGE_VA_MASK         0xfffff000
-
-#ifdef CONFIG_X86_PAE
-#define VMI_PAGE_L1		(VMI_PAGE_PT | VMI_PAGE_PAE | VMI_PAGE_ZEROED)
-#define VMI_PAGE_L2		(VMI_PAGE_PD | VMI_PAGE_PAE | VMI_PAGE_ZEROED)
-#else
-#define VMI_PAGE_L1		(VMI_PAGE_PT | VMI_PAGE_ZEROED)
-#define VMI_PAGE_L2		(VMI_PAGE_PD | VMI_PAGE_ZEROED)
-#endif
-
-/* Flags used by VMI_FlushTLB call */
-#define VMI_FLUSH_TLB            0x01
-#define VMI_FLUSH_GLOBAL         0x02
-
-/*
- *---------------------------------------------------------------------
- *
- *  VMI relocation definitions for ROM call get_reloc
- *
- *---------------------------------------------------------------------
- */
-
-/* VMI Relocation types */
-#define VMI_RELOCATION_NONE     0
-#define VMI_RELOCATION_CALL_REL 1
-#define VMI_RELOCATION_JUMP_REL 2
-#define VMI_RELOCATION_NOP	3
-
-#ifndef __ASSEMBLY__
-struct vmi_relocation_info {
-	unsigned char           *eip;
-	unsigned char           type;
-	unsigned char           reserved[3];
-};
-#endif
-
-
-/*
- *---------------------------------------------------------------------
- *
- *  Generic ROM structures and definitions
- *
- *---------------------------------------------------------------------
- */
-
-#ifndef __ASSEMBLY__
-
-struct vrom_header {
-	u16     rom_signature;  /* option ROM signature */
-	u8      rom_length;     /* ROM length in 512 byte chunks */
-	u8      rom_entry[4];   /* 16-bit code entry point */
-	u8      rom_pad0;       /* 4-byte align pad */
-	u32     vrom_signature; /* VROM identification signature */
-	u8      api_version_min;/* Minor version of API */
-	u8      api_version_maj;/* Major version of API */
-	u8      jump_slots;     /* Number of jump slots */
-	u8      reserved1;      /* Reserved for expansion */
-	u32     virtual_top;    /* Hypervisor virtual address start */
-	u16     reserved2;      /* Reserved for expansion */
-	u16	license_offs;	/* Offset to License string */
-	u16     pci_header_offs;/* Offset to PCI OPROM header */
-	u16     pnp_header_offs;/* Offset to PnP OPROM header */
-	u32     rom_pad3;       /* PnP reserverd / VMI reserved */
-	u8      reserved[96];   /* Reserved for headers */
-	char    vmi_init[8];    /* VMI_Init jump point */
-	char    get_reloc[8];   /* VMI_GetRelocationInfo jump point */
-} __attribute__((packed));
-
-struct pnp_header {
-	char sig[4];
-	char rev;
-	char size;
-	short next;
-	short res;
-	long devID;
-	unsigned short manufacturer_offset;
-	unsigned short product_offset;
-} __attribute__((packed));
-
-struct pci_header {
-	char sig[4];
-	short vendorID;
-	short deviceID;
-	short vpdData;
-	short size;
-	char rev;
-	char class;
-	char subclass;
-	char interface;
-	short chunks;
-	char rom_version_min;
-	char rom_version_maj;
-	char codetype;
-	char lastRom;
-	short reserved;
-} __attribute__((packed));
-
-/* Function prototypes for bootstrapping */
-#ifdef CONFIG_VMI
-extern void vmi_init(void);
-extern void vmi_activate(void);
-extern void vmi_bringup(void);
-#else
-static inline void vmi_init(void) {}
-static inline void vmi_activate(void) {}
-static inline void vmi_bringup(void) {}
-#endif
-
-/* State needed to start an application processor in an SMP system. */
-struct vmi_ap_state {
-	u32 cr0;
-	u32 cr2;
-	u32 cr3;
-	u32 cr4;
-
-	u64 efer;
-
-	u32 eip;
-	u32 eflags;
-	u32 eax;
-	u32 ebx;
-	u32 ecx;
-	u32 edx;
-	u32 esp;
-	u32 ebp;
-	u32 esi;
-	u32 edi;
-	u16 cs;
-	u16 ss;
-	u16 ds;
-	u16 es;
-	u16 fs;
-	u16 gs;
-	u16 ldtr;
-
-	u16 gdtr_limit;
-	u32 gdtr_base;
-	u32 idtr_base;
-	u16 idtr_limit;
-};
-
-#endif
diff --git a/arch/x86/include/asm/vmi_time.h b/arch/x86/include/asm/vmi_time.h
deleted file mode 100644
index c6e0bee..0000000
--- a/arch/x86/include/asm/vmi_time.h
+++ /dev/null
@@ -1,98 +0,0 @@
-/*
- * VMI Time wrappers
- *
- * Copyright (C) 2006, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Send feedback to dhecht@vmware.com
- *
- */
-
-#ifndef _ASM_X86_VMI_TIME_H
-#define _ASM_X86_VMI_TIME_H
-
-/*
- * Raw VMI call indices for timer functions
- */
-#define VMI_CALL_GetCycleFrequency	66
-#define VMI_CALL_GetCycleCounter	67
-#define VMI_CALL_SetAlarm		68
-#define VMI_CALL_CancelAlarm		69
-#define VMI_CALL_GetWallclockTime	70
-#define VMI_CALL_WallclockUpdated	71
-
-/* Cached VMI timer operations */
-extern struct vmi_timer_ops {
-	u64 (*get_cycle_frequency)(void);
-	u64 (*get_cycle_counter)(int);
-	u64 (*get_wallclock)(void);
-	int (*wallclock_updated)(void);
-	void (*set_alarm)(u32 flags, u64 expiry, u64 period);
-	void (*cancel_alarm)(u32 flags);
-} vmi_timer_ops;
-
-/* Prototypes */
-extern void __init vmi_time_init(void);
-extern unsigned long vmi_get_wallclock(void);
-extern int vmi_set_wallclock(unsigned long now);
-extern unsigned long long vmi_sched_clock(void);
-extern unsigned long vmi_tsc_khz(void);
-
-#ifdef CONFIG_X86_LOCAL_APIC
-extern void __devinit vmi_time_bsp_init(void);
-extern void __devinit vmi_time_ap_init(void);
-#endif
-
-/*
- * When run under a hypervisor, a vcpu is always in one of three states:
- * running, halted, or ready.  The vcpu is in the 'running' state if it
- * is executing.  When the vcpu executes the halt interface, the vcpu
- * enters the 'halted' state and remains halted until there is some work
- * pending for the vcpu (e.g. an alarm expires, host I/O completes on
- * behalf of virtual I/O).  At this point, the vcpu enters the 'ready'
- * state (waiting for the hypervisor to reschedule it).  Finally, at any
- * time when the vcpu is not in the 'running' state nor the 'halted'
- * state, it is in the 'ready' state.
- *
- * Real time is advances while the vcpu is 'running', 'ready', or
- * 'halted'.  Stolen time is the time in which the vcpu is in the
- * 'ready' state.  Available time is the remaining time -- the vcpu is
- * either 'running' or 'halted'.
- *
- * All three views of time are accessible through the VMI cycle
- * counters.
- */
-
-/* The cycle counters. */
-#define VMI_CYCLES_REAL         0
-#define VMI_CYCLES_AVAILABLE    1
-#define VMI_CYCLES_STOLEN       2
-
-/* The alarm interface 'flags' bits */
-#define VMI_ALARM_COUNTERS      2
-
-#define VMI_ALARM_COUNTER_MASK  0x000000ff
-
-#define VMI_ALARM_WIRED_IRQ0    0x00000000
-#define VMI_ALARM_WIRED_LVTT    0x00010000
-
-#define VMI_ALARM_IS_ONESHOT    0x00000000
-#define VMI_ALARM_IS_PERIODIC   0x00000100
-
-#define CONFIG_VMI_ALARM_HZ	100
-
-#endif /* _ASM_X86_VMI_TIME_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..801127c 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -91,7 +91,6 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
-obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_KVM_GUEST)		+= kvm.o
 obj-$(CONFIG_KVM_CLOCK)		+= kvmclock.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1db183e..c5b2500 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -413,7 +413,6 @@ struct pv_mmu_ops pv_mmu_ops = {
 
 	.alloc_pte = paravirt_nop,
 	.alloc_pmd = paravirt_nop,
-	.alloc_pmd_clone = paravirt_nop,
 	.alloc_pud = paravirt_nop,
 	.release_pte = paravirt_nop,
 	.release_pmd = paravirt_nop,
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c3a4fbb..feb4c21 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -83,7 +83,6 @@
 #include <asm/dmi.h>
 #include <asm/io_apic.h>
 #include <asm/ist.h>
-#include <asm/vmi.h>
 #include <asm/setup_arch.h>
 #include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
@@ -734,10 +733,10 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
-	/* VMI may relocate the fixmap; do this before touching ioremap area */
-	vmi_init();
-
-	/* OFW also may relocate the fixmap */
+	/*
+	 * If we have OLPC OFW, we might end up relocating the fixmap due to
+	 * reserve_top(), so do this before touching the ioremap area.
+	 */
 	olpc_ofw_detect();
 
 	early_trap_init();
@@ -838,9 +837,6 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_report_nx();
 
-	/* Must be before kernel pagetables are setup */
-	vmi_activate();
-
 	/* after early param, so could get panic from serial */
 	reserve_early_setup_data();
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..63a1a55 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -62,7 +62,6 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
-#include <asm/vmi.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
@@ -311,7 +310,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 	__flush_tlb_all();
 #endif
 
-	vmi_bringup();
 	cpu_init();
 	preempt_disable();
 	smp_callin();
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
deleted file mode 100644
index ce9fbac..0000000
--- a/arch/x86/kernel/vmi_32.c
+++ /dev/null
@@ -1,893 +0,0 @@
-/*
- * VMI specific paravirt-ops implementation
- *
- * Copyright (C) 2005, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- * Send feedback to zach@vmware.com
- *
- */
-
-#include <linux/module.h>
-#include <linux/cpu.h>
-#include <linux/bootmem.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/sched.h>
-#include <linux/gfp.h>
-#include <asm/vmi.h>
-#include <asm/io.h>
-#include <asm/fixmap.h>
-#include <asm/apicdef.h>
-#include <asm/apic.h>
-#include <asm/pgalloc.h>
-#include <asm/processor.h>
-#include <asm/timer.h>
-#include <asm/vmi_time.h>
-#include <asm/kmap_types.h>
-#include <asm/setup.h>
-
-/* Convenient for calling VMI functions indirectly in the ROM */
-typedef u32 __attribute__((regparm(1))) (VROMFUNC)(void);
-typedef u64 __attribute__((regparm(2))) (VROMLONGFUNC)(int);
-
-#define call_vrom_func(rom,func) \
-   (((VROMFUNC *)(rom->func))())
-
-#define call_vrom_long_func(rom,func,arg) \
-   (((VROMLONGFUNC *)(rom->func)) (arg))
-
-static struct vrom_header *vmi_rom;
-static int disable_pge;
-static int disable_pse;
-static int disable_sep;
-static int disable_tsc;
-static int disable_mtrr;
-static int disable_noidle;
-static int disable_vmi_timer;
-
-/* Cached VMI operations */
-static struct {
-	void (*cpuid)(void /* non-c */);
-	void (*_set_ldt)(u32 selector);
-	void (*set_tr)(u32 selector);
-	void (*write_idt_entry)(struct desc_struct *, int, u32, u32);
-	void (*write_gdt_entry)(struct desc_struct *, int, u32, u32);
-	void (*write_ldt_entry)(struct desc_struct *, int, u32, u32);
-	void (*set_kernel_stack)(u32 selector, u32 sp0);
-	void (*allocate_page)(u32, u32, u32, u32, u32);
-	void (*release_page)(u32, u32);
-	void (*set_pte)(pte_t, pte_t *, unsigned);
-	void (*update_pte)(pte_t *, unsigned);
-	void (*set_linear_mapping)(int, void *, u32, u32);
-	void (*_flush_tlb)(int);
-	void (*set_initial_ap_state)(int, int);
-	void (*halt)(void);
-  	void (*set_lazy_mode)(int mode);
-} vmi_ops;
-
-/* Cached VMI operations */
-struct vmi_timer_ops vmi_timer_ops;
-
-/*
- * VMI patching routines.
- */
-#define MNEM_CALL 0xe8
-#define MNEM_JMP  0xe9
-#define MNEM_RET  0xc3
-
-#define IRQ_PATCH_INT_MASK 0
-#define IRQ_PATCH_DISABLE  5
-
-static inline void patch_offset(void *insnbuf,
-				unsigned long ip, unsigned long dest)
-{
-        *(unsigned long *)(insnbuf+1) = dest-ip-5;
-}
-
-static unsigned patch_internal(int call, unsigned len, void *insnbuf,
-			       unsigned long ip)
-{
-	u64 reloc;
-	struct vmi_relocation_info *const rel = (struct vmi_relocation_info *)&reloc;
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,	call);
-	switch(rel->type) {
-		case VMI_RELOCATION_CALL_REL:
-			BUG_ON(len < 5);
-			*(char *)insnbuf = MNEM_CALL;
-			patch_offset(insnbuf, ip, (unsigned long)rel->eip);
-			return 5;
-
-		case VMI_RELOCATION_JUMP_REL:
-			BUG_ON(len < 5);
-			*(char *)insnbuf = MNEM_JMP;
-			patch_offset(insnbuf, ip, (unsigned long)rel->eip);
-			return 5;
-
-		case VMI_RELOCATION_NOP:
-			/* obliterate the whole thing */
-			return 0;
-
-		case VMI_RELOCATION_NONE:
-			/* leave native code in place */
-			break;
-
-		default:
-			BUG();
-	}
-	return len;
-}
-
-/*
- * Apply patch if appropriate, return length of new instruction
- * sequence.  The callee does nop padding for us.
- */
-static unsigned vmi_patch(u8 type, u16 clobbers, void *insns,
-			  unsigned long ip, unsigned len)
-{
-	switch (type) {
-		case PARAVIRT_PATCH(pv_irq_ops.irq_disable):
-			return patch_internal(VMI_CALL_DisableInterrupts, len,
-					      insns, ip);
-		case PARAVIRT_PATCH(pv_irq_ops.irq_enable):
-			return patch_internal(VMI_CALL_EnableInterrupts, len,
-					      insns, ip);
-		case PARAVIRT_PATCH(pv_irq_ops.restore_fl):
-			return patch_internal(VMI_CALL_SetInterruptMask, len,
-					      insns, ip);
-		case PARAVIRT_PATCH(pv_irq_ops.save_fl):
-			return patch_internal(VMI_CALL_GetInterruptMask, len,
-					      insns, ip);
-		case PARAVIRT_PATCH(pv_cpu_ops.iret):
-			return patch_internal(VMI_CALL_IRET, len, insns, ip);
-		case PARAVIRT_PATCH(pv_cpu_ops.irq_enable_sysexit):
-			return patch_internal(VMI_CALL_SYSEXIT, len, insns, ip);
-		default:
-			break;
-	}
-	return len;
-}
-
-/* CPUID has non-C semantics, and paravirt-ops API doesn't match hardware ISA */
-static void vmi_cpuid(unsigned int *ax, unsigned int *bx,
-                               unsigned int *cx, unsigned int *dx)
-{
-	int override = 0;
-	if (*ax == 1)
-		override = 1;
-        asm volatile ("call *%6"
-                      : "=a" (*ax),
-                        "=b" (*bx),
-                        "=c" (*cx),
-                        "=d" (*dx)
-                      : "0" (*ax), "2" (*cx), "r" (vmi_ops.cpuid));
-	if (override) {
-		if (disable_pse)
-			*dx &= ~X86_FEATURE_PSE;
-		if (disable_pge)
-			*dx &= ~X86_FEATURE_PGE;
-		if (disable_sep)
-			*dx &= ~X86_FEATURE_SEP;
-		if (disable_tsc)
-			*dx &= ~X86_FEATURE_TSC;
-		if (disable_mtrr)
-			*dx &= ~X86_FEATURE_MTRR;
-	}
-}
-
-static inline void vmi_maybe_load_tls(struct desc_struct *gdt, int nr, struct desc_struct *new)
-{
-	if (gdt[nr].a != new->a || gdt[nr].b != new->b)
-		write_gdt_entry(gdt, nr, new, 0);
-}
-
-static void vmi_load_tls(struct thread_struct *t, unsigned int cpu)
-{
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
-	vmi_maybe_load_tls(gdt, GDT_ENTRY_TLS_MIN + 0, &t->tls_array[0]);
-	vmi_maybe_load_tls(gdt, GDT_ENTRY_TLS_MIN + 1, &t->tls_array[1]);
-	vmi_maybe_load_tls(gdt, GDT_ENTRY_TLS_MIN + 2, &t->tls_array[2]);
-}
-
-static void vmi_set_ldt(const void *addr, unsigned entries)
-{
-	unsigned cpu = smp_processor_id();
-	struct desc_struct desc;
-
-	pack_descriptor(&desc, (unsigned long)addr,
-			entries * sizeof(struct desc_struct) - 1,
-			DESC_LDT, 0);
-	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_LDT, &desc, DESC_LDT);
-	vmi_ops._set_ldt(entries ? GDT_ENTRY_LDT*sizeof(struct desc_struct) : 0);
-}
-
-static void vmi_set_tr(void)
-{
-	vmi_ops.set_tr(GDT_ENTRY_TSS*sizeof(struct desc_struct));
-}
-
-static void vmi_write_idt_entry(gate_desc *dt, int entry, const gate_desc *g)
-{
-	u32 *idt_entry = (u32 *)g;
-	vmi_ops.write_idt_entry(dt, entry, idt_entry[0], idt_entry[1]);
-}
-
-static void vmi_write_gdt_entry(struct desc_struct *dt, int entry,
-				const void *desc, int type)
-{
-	u32 *gdt_entry = (u32 *)desc;
-	vmi_ops.write_gdt_entry(dt, entry, gdt_entry[0], gdt_entry[1]);
-}
-
-static void vmi_write_ldt_entry(struct desc_struct *dt, int entry,
-				const void *desc)
-{
-	u32 *ldt_entry = (u32 *)desc;
-	vmi_ops.write_ldt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
-}
-
-static void vmi_load_sp0(struct tss_struct *tss,
-				   struct thread_struct *thread)
-{
-	tss->x86_tss.sp0 = thread->sp0;
-
-	/* This can only happen when SEP is enabled, no need to test "SEP"arately */
-	if (unlikely(tss->x86_tss.ss1 != thread->sysenter_cs)) {
-		tss->x86_tss.ss1 = thread->sysenter_cs;
-		wrmsr(MSR_IA32_SYSENTER_CS, thread->sysenter_cs, 0);
-	}
-	vmi_ops.set_kernel_stack(__KERNEL_DS, tss->x86_tss.sp0);
-}
-
-static void vmi_flush_tlb_user(void)
-{
-	vmi_ops._flush_tlb(VMI_FLUSH_TLB);
-}
-
-static void vmi_flush_tlb_kernel(void)
-{
-	vmi_ops._flush_tlb(VMI_FLUSH_TLB | VMI_FLUSH_GLOBAL);
-}
-
-/* Stub to do nothing at all; used for delays and unimplemented calls */
-static void vmi_nop(void)
-{
-}
-
-static void vmi_allocate_pte(struct mm_struct *mm, unsigned long pfn)
-{
-	vmi_ops.allocate_page(pfn, VMI_PAGE_L1, 0, 0, 0);
-}
-
-static void vmi_allocate_pmd(struct mm_struct *mm, unsigned long pfn)
-{
- 	/*
-	 * This call comes in very early, before mem_map is setup.
-	 * It is called only for swapper_pg_dir, which already has
-	 * data on it.
-	 */
-	vmi_ops.allocate_page(pfn, VMI_PAGE_L2, 0, 0, 0);
-}
-
-static void vmi_allocate_pmd_clone(unsigned long pfn, unsigned long clonepfn, unsigned long start, unsigned long count)
-{
-	vmi_ops.allocate_page(pfn, VMI_PAGE_L2 | VMI_PAGE_CLONE, clonepfn, start, count);
-}
-
-static void vmi_release_pte(unsigned long pfn)
-{
-	vmi_ops.release_page(pfn, VMI_PAGE_L1);
-}
-
-static void vmi_release_pmd(unsigned long pfn)
-{
-	vmi_ops.release_page(pfn, VMI_PAGE_L2);
-}
-
-/*
- * We use the pgd_free hook for releasing the pgd page:
- */
-static void vmi_pgd_free(struct mm_struct *mm, pgd_t *pgd)
-{
-	unsigned long pfn = __pa(pgd) >> PAGE_SHIFT;
-
-	vmi_ops.release_page(pfn, VMI_PAGE_L2);
-}
-
-/*
- * Helper macros for MMU update flags.  We can defer updates until a flush
- * or page invalidation only if the update is to the current address space
- * (otherwise, there is no flush).  We must check against init_mm, since
- * this could be a kernel update, which usually passes init_mm, although
- * sometimes this check can be skipped if we know the particular function
- * is only called on user mode PTEs.  We could change the kernel to pass
- * current->active_mm here, but in particular, I was unsure if changing
- * mm/highmem.c to do this would still be correct on other architectures.
- */
-#define is_current_as(mm, mustbeuser) ((mm) == current->active_mm ||    \
-                                       (!mustbeuser && (mm) == &init_mm))
-#define vmi_flags_addr(mm, addr, level, user)                           \
-        ((level) | (is_current_as(mm, user) ?                           \
-                (VMI_PAGE_CURRENT_AS | ((addr) & VMI_PAGE_VA_MASK)) : 0))
-#define vmi_flags_addr_defer(mm, addr, level, user)                     \
-        ((level) | (is_current_as(mm, user) ?                           \
-                (VMI_PAGE_DEFER | VMI_PAGE_CURRENT_AS | ((addr) & VMI_PAGE_VA_MASK)) : 0))
-
-static void vmi_update_pte(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	vmi_ops.update_pte(ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
-}
-
-static void vmi_update_pte_defer(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	vmi_ops.update_pte(ptep, vmi_flags_addr_defer(mm, addr, VMI_PAGE_PT, 0));
-}
-
-static void vmi_set_pte(pte_t *ptep, pte_t pte)
-{
-	/* XXX because of set_pmd_pte, this can be called on PT or PD layers */
-	vmi_ops.set_pte(pte, ptep, VMI_PAGE_PT);
-}
-
-static void vmi_set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
-{
-	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
-}
-
-static void vmi_set_pmd(pmd_t *pmdp, pmd_t pmdval)
-{
-#ifdef CONFIG_X86_PAE
-	const pte_t pte = { .pte = pmdval.pmd };
-#else
-	const pte_t pte = { pmdval.pud.pgd.pgd };
-#endif
-	vmi_ops.set_pte(pte, (pte_t *)pmdp, VMI_PAGE_PD);
-}
-
-#ifdef CONFIG_X86_PAE
-
-static void vmi_set_pte_atomic(pte_t *ptep, pte_t pteval)
-{
-	/*
-	 * XXX This is called from set_pmd_pte, but at both PT
-	 * and PD layers so the VMI_PAGE_PT flag is wrong.  But
-	 * it is only called for large page mapping changes,
-	 * the Xen backend, doesn't support large pages, and the
-	 * ESX backend doesn't depend on the flag.
-	 */
-	set_64bit((unsigned long long *)ptep,pte_val(pteval));
-	vmi_ops.update_pte(ptep, VMI_PAGE_PT);
-}
-
-static void vmi_set_pud(pud_t *pudp, pud_t pudval)
-{
-	/* Um, eww */
-	const pte_t pte = { .pte = pudval.pgd.pgd };
-	vmi_ops.set_pte(pte, (pte_t *)pudp, VMI_PAGE_PDP);
-}
-
-static void vmi_pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	const pte_t pte = { .pte = 0 };
-	vmi_ops.set_pte(pte, ptep, vmi_flags_addr(mm, addr, VMI_PAGE_PT, 0));
-}
-
-static void vmi_pmd_clear(pmd_t *pmd)
-{
-	const pte_t pte = { .pte = 0 };
-	vmi_ops.set_pte(pte, (pte_t *)pmd, VMI_PAGE_PD);
-}
-#endif
-
-#ifdef CONFIG_SMP
-static void __devinit
-vmi_startup_ipi_hook(int phys_apicid, unsigned long start_eip,
-		     unsigned long start_esp)
-{
-	struct vmi_ap_state ap;
-
-	/* Default everything to zero.  This is fine for most GPRs. */
-	memset(&ap, 0, sizeof(struct vmi_ap_state));
-
-	ap.gdtr_limit = GDT_SIZE - 1;
-	ap.gdtr_base = (unsigned long) get_cpu_gdt_table(phys_apicid);
-
-	ap.idtr_limit = IDT_ENTRIES * 8 - 1;
-	ap.idtr_base = (unsigned long) idt_table;
-
-	ap.ldtr = 0;
-
-	ap.cs = __KERNEL_CS;
-	ap.eip = (unsigned long) start_eip;
-	ap.ss = __KERNEL_DS;
-	ap.esp = (unsigned long) start_esp;
-
-	ap.ds = __USER_DS;
-	ap.es = __USER_DS;
-	ap.fs = __KERNEL_PERCPU;
-	ap.gs = __KERNEL_STACK_CANARY;
-
-	ap.eflags = 0;
-
-#ifdef CONFIG_X86_PAE
-	/* efer should match BSP efer. */
-	if (cpu_has_nx) {
-		unsigned l, h;
-		rdmsr(MSR_EFER, l, h);
-		ap.efer = (unsigned long long) h << 32 | l;
-	}
-#endif
-
-	ap.cr3 = __pa(swapper_pg_dir);
-	/* Protected mode, paging, AM, WP, NE, MP. */
-	ap.cr0 = 0x80050023;
-	ap.cr4 = mmu_cr4_features;
-	vmi_ops.set_initial_ap_state((u32)&ap, phys_apicid);
-}
-#endif
-
-static void vmi_start_context_switch(struct task_struct *prev)
-{
-	paravirt_start_context_switch(prev);
-	vmi_ops.set_lazy_mode(2);
-}
-
-static void vmi_end_context_switch(struct task_struct *next)
-{
-	vmi_ops.set_lazy_mode(0);
-	paravirt_end_context_switch(next);
-}
-
-static void vmi_enter_lazy_mmu(void)
-{
-	paravirt_enter_lazy_mmu();
-	vmi_ops.set_lazy_mode(1);
-}
-
-static void vmi_leave_lazy_mmu(void)
-{
-	vmi_ops.set_lazy_mode(0);
-	paravirt_leave_lazy_mmu();
-}
-
-static inline int __init check_vmi_rom(struct vrom_header *rom)
-{
-	struct pci_header *pci;
-	struct pnp_header *pnp;
-	const char *manufacturer = "UNKNOWN";
-	const char *product = "UNKNOWN";
-	const char *license = "unspecified";
-
-	if (rom->rom_signature != 0xaa55)
-		return 0;
-	if (rom->vrom_signature != VMI_SIGNATURE)
-		return 0;
-	if (rom->api_version_maj != VMI_API_REV_MAJOR ||
-	    rom->api_version_min+1 < VMI_API_REV_MINOR+1) {
-		printk(KERN_WARNING "VMI: Found mismatched rom version %d.%d\n",
-				rom->api_version_maj,
-				rom->api_version_min);
-		return 0;
-	}
-
-	/*
-	 * Relying on the VMI_SIGNATURE field is not 100% safe, so check
-	 * the PCI header and device type to make sure this is really a
-	 * VMI device.
-	 */
-	if (!rom->pci_header_offs) {
-		printk(KERN_WARNING "VMI: ROM does not contain PCI header.\n");
-		return 0;
-	}
-
-	pci = (struct pci_header *)((char *)rom+rom->pci_header_offs);
-	if (pci->vendorID != PCI_VENDOR_ID_VMWARE ||
-	    pci->deviceID != PCI_DEVICE_ID_VMWARE_VMI) {
-		/* Allow it to run... anyways, but warn */
-		printk(KERN_WARNING "VMI: ROM from unknown manufacturer\n");
-	}
-
-	if (rom->pnp_header_offs) {
-		pnp = (struct pnp_header *)((char *)rom+rom->pnp_header_offs);
-		if (pnp->manufacturer_offset)
-			manufacturer = (const char *)rom+pnp->manufacturer_offset;
-		if (pnp->product_offset)
-			product = (const char *)rom+pnp->product_offset;
-	}
-
-	if (rom->license_offs)
-		license = (char *)rom+rom->license_offs;
-
-	printk(KERN_INFO "VMI: Found %s %s, API version %d.%d, ROM version %d.%d\n",
-		manufacturer, product,
-		rom->api_version_maj, rom->api_version_min,
-		pci->rom_version_maj, pci->rom_version_min);
-
-	/* Don't allow BSD/MIT here for now because we don't want to end up
-	   with any binary only shim layers */
-	if (strcmp(license, "GPL") && strcmp(license, "GPL v2")) {
-		printk(KERN_WARNING "VMI: Non GPL license `%s' found for ROM. Not used.\n",
-			license);
-		return 0;
-	}
-
-	return 1;
-}
-
-/*
- * Probe for the VMI option ROM
- */
-static inline int __init probe_vmi_rom(void)
-{
-	unsigned long base;
-
-	/* VMI ROM is in option ROM area, check signature */
-	for (base = 0xC0000; base < 0xE0000; base += 2048) {
-		struct vrom_header *romstart;
-		romstart = (struct vrom_header *)isa_bus_to_virt(base);
-		if (check_vmi_rom(romstart)) {
-			vmi_rom = romstart;
-			return 1;
-		}
-	}
-	return 0;
-}
-
-/*
- * VMI setup common to all processors
- */
-void vmi_bringup(void)
-{
- 	/* We must establish the lowmem mapping for MMU ops to work */
-	if (vmi_ops.set_linear_mapping)
-		vmi_ops.set_linear_mapping(0, (void *)__PAGE_OFFSET, MAXMEM_PFN, 0);
-}
-
-/*
- * Return a pointer to a VMI function or NULL if unimplemented
- */
-static void *vmi_get_function(int vmicall)
-{
-	u64 reloc;
-	const struct vmi_relocation_info *rel = (struct vmi_relocation_info *)&reloc;
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,	vmicall);
-	BUG_ON(rel->type == VMI_RELOCATION_JUMP_REL);
-	if (rel->type == VMI_RELOCATION_CALL_REL)
-		return (void *)rel->eip;
-	else
-		return NULL;
-}
-
-/*
- * Helper macro for making the VMI paravirt-ops fill code readable.
- * For unimplemented operations, fall back to default, unless nop
- * is returned by the ROM.
- */
-#define para_fill(opname, vmicall)				\
-do {								\
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,		\
-				    VMI_CALL_##vmicall);	\
-	if (rel->type == VMI_RELOCATION_CALL_REL) 		\
-		opname = (void *)rel->eip;			\
-	else if (rel->type == VMI_RELOCATION_NOP) 		\
-		opname = (void *)vmi_nop;			\
-	else if (rel->type != VMI_RELOCATION_NONE)		\
-		printk(KERN_WARNING "VMI: Unknown relocation "	\
-				    "type %d for " #vmicall"\n",\
-					rel->type);		\
-} while (0)
-
-/*
- * Helper macro for making the VMI paravirt-ops fill code readable.
- * For cached operations which do not match the VMI ROM ABI and must
- * go through a tranlation stub.  Ignore NOPs, since it is not clear
- * a NOP * VMI function corresponds to a NOP paravirt-op when the
- * functions are not in 1-1 correspondence.
- */
-#define para_wrap(opname, wrapper, cache, vmicall)		\
-do {								\
-	reloc = call_vrom_long_func(vmi_rom, get_reloc,		\
-				    VMI_CALL_##vmicall);	\
-	BUG_ON(rel->type == VMI_RELOCATION_JUMP_REL);		\
-	if (rel->type == VMI_RELOCATION_CALL_REL) {		\
-		opname = wrapper;				\
-		vmi_ops.cache = (void *)rel->eip;		\
-	}							\
-} while (0)
-
-/*
- * Activate the VMI interface and switch into paravirtualized mode
- */
-static inline int __init activate_vmi(void)
-{
-	short kernel_cs;
-	u64 reloc;
-	const struct vmi_relocation_info *rel = (struct vmi_relocation_info *)&reloc;
-
-	/*
-	 * Prevent page tables from being allocated in highmem, even if
-	 * CONFIG_HIGHPTE is enabled.
-	 */
-	__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
-
-	if (call_vrom_func(vmi_rom, vmi_init) != 0) {
-		printk(KERN_ERR "VMI ROM failed to initialize!");
-		return 0;
-	}
-	savesegment(cs, kernel_cs);
-
-	pv_info.paravirt_enabled = 1;
-	pv_info.kernel_rpl = kernel_cs & SEGMENT_RPL_MASK;
-	pv_info.name = "vmi [deprecated]";
-
-	pv_init_ops.patch = vmi_patch;
-
-	/*
-	 * Many of these operations are ABI compatible with VMI.
-	 * This means we can fill in the paravirt-ops with direct
-	 * pointers into the VMI ROM.  If the calling convention for
-	 * these operations changes, this code needs to be updated.
-	 *
-	 * Exceptions
-	 *  CPUID paravirt-op uses pointers, not the native ISA
-	 *  halt has no VMI equivalent; all VMI halts are "safe"
-	 *  no MSR support yet - just trap and emulate.  VMI uses the
-	 *    same ABI as the native ISA, but Linux wants exceptions
-	 *    from bogus MSR read / write handled
-	 *  rdpmc is not yet used in Linux
-	 */
-
-	/* CPUID is special, so very special it gets wrapped like a present */
-	para_wrap(pv_cpu_ops.cpuid, vmi_cpuid, cpuid, CPUID);
-
-	para_fill(pv_cpu_ops.clts, CLTS);
-	para_fill(pv_cpu_ops.get_debugreg, GetDR);
-	para_fill(pv_cpu_ops.set_debugreg, SetDR);
-	para_fill(pv_cpu_ops.read_cr0, GetCR0);
-	para_fill(pv_mmu_ops.read_cr2, GetCR2);
-	para_fill(pv_mmu_ops.read_cr3, GetCR3);
-	para_fill(pv_cpu_ops.read_cr4, GetCR4);
-	para_fill(pv_cpu_ops.write_cr0, SetCR0);
-	para_fill(pv_mmu_ops.write_cr2, SetCR2);
-	para_fill(pv_mmu_ops.write_cr3, SetCR3);
-	para_fill(pv_cpu_ops.write_cr4, SetCR4);
-
-	para_fill(pv_irq_ops.save_fl.func, GetInterruptMask);
-	para_fill(pv_irq_ops.restore_fl.func, SetInterruptMask);
-	para_fill(pv_irq_ops.irq_disable.func, DisableInterrupts);
-	para_fill(pv_irq_ops.irq_enable.func, EnableInterrupts);
-
-	para_fill(pv_cpu_ops.wbinvd, WBINVD);
-	para_fill(pv_cpu_ops.read_tsc, RDTSC);
-
-	/* The following we emulate with trap and emulate for now */
-	/* paravirt_ops.read_msr = vmi_rdmsr */
-	/* paravirt_ops.write_msr = vmi_wrmsr */
-	/* paravirt_ops.rdpmc = vmi_rdpmc */
-
-	/* TR interface doesn't pass TR value, wrap */
-	para_wrap(pv_cpu_ops.load_tr_desc, vmi_set_tr, set_tr, SetTR);
-
-	/* LDT is special, too */
-	para_wrap(pv_cpu_ops.set_ldt, vmi_set_ldt, _set_ldt, SetLDT);
-
-	para_fill(pv_cpu_ops.load_gdt, SetGDT);
-	para_fill(pv_cpu_ops.load_idt, SetIDT);
-	para_fill(pv_cpu_ops.store_gdt, GetGDT);
-	para_fill(pv_cpu_ops.store_idt, GetIDT);
-	para_fill(pv_cpu_ops.store_tr, GetTR);
-	pv_cpu_ops.load_tls = vmi_load_tls;
-	para_wrap(pv_cpu_ops.write_ldt_entry, vmi_write_ldt_entry,
-		  write_ldt_entry, WriteLDTEntry);
-	para_wrap(pv_cpu_ops.write_gdt_entry, vmi_write_gdt_entry,
-		  write_gdt_entry, WriteGDTEntry);
-	para_wrap(pv_cpu_ops.write_idt_entry, vmi_write_idt_entry,
-		  write_idt_entry, WriteIDTEntry);
-	para_wrap(pv_cpu_ops.load_sp0, vmi_load_sp0, set_kernel_stack, UpdateKernelStack);
-	para_fill(pv_cpu_ops.set_iopl_mask, SetIOPLMask);
-	para_fill(pv_cpu_ops.io_delay, IODelay);
-
-	para_wrap(pv_cpu_ops.start_context_switch, vmi_start_context_switch,
-		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_cpu_ops.end_context_switch, vmi_end_context_switch,
-		  set_lazy_mode, SetLazyMode);
-
-	para_wrap(pv_mmu_ops.lazy_mode.enter, vmi_enter_lazy_mmu,
-		  set_lazy_mode, SetLazyMode);
-	para_wrap(pv_mmu_ops.lazy_mode.leave, vmi_leave_lazy_mmu,
-		  set_lazy_mode, SetLazyMode);
-
-	/* user and kernel flush are just handled with different flags to FlushTLB */
-	para_wrap(pv_mmu_ops.flush_tlb_user, vmi_flush_tlb_user, _flush_tlb, FlushTLB);
-	para_wrap(pv_mmu_ops.flush_tlb_kernel, vmi_flush_tlb_kernel, _flush_tlb, FlushTLB);
-	para_fill(pv_mmu_ops.flush_tlb_single, InvalPage);
-
-	/*
-	 * Until a standard flag format can be agreed on, we need to
-	 * implement these as wrappers in Linux.  Get the VMI ROM
-	 * function pointers for the two backend calls.
-	 */
-#ifdef CONFIG_X86_PAE
-	vmi_ops.set_pte = vmi_get_function(VMI_CALL_SetPxELong);
-	vmi_ops.update_pte = vmi_get_function(VMI_CALL_UpdatePxELong);
-#else
-	vmi_ops.set_pte = vmi_get_function(VMI_CALL_SetPxE);
-	vmi_ops.update_pte = vmi_get_function(VMI_CALL_UpdatePxE);
-#endif
-
-	if (vmi_ops.set_pte) {
-		pv_mmu_ops.set_pte = vmi_set_pte;
-		pv_mmu_ops.set_pte_at = vmi_set_pte_at;
-		pv_mmu_ops.set_pmd = vmi_set_pmd;
-#ifdef CONFIG_X86_PAE
-		pv_mmu_ops.set_pte_atomic = vmi_set_pte_atomic;
-		pv_mmu_ops.set_pud = vmi_set_pud;
-		pv_mmu_ops.pte_clear = vmi_pte_clear;
-		pv_mmu_ops.pmd_clear = vmi_pmd_clear;
-#endif
-	}
-
-	if (vmi_ops.update_pte) {
-		pv_mmu_ops.pte_update = vmi_update_pte;
-		pv_mmu_ops.pte_update_defer = vmi_update_pte_defer;
-	}
-
-	vmi_ops.allocate_page = vmi_get_function(VMI_CALL_AllocatePage);
-	if (vmi_ops.allocate_page) {
-		pv_mmu_ops.alloc_pte = vmi_allocate_pte;
-		pv_mmu_ops.alloc_pmd = vmi_allocate_pmd;
-		pv_mmu_ops.alloc_pmd_clone = vmi_allocate_pmd_clone;
-	}
-
-	vmi_ops.release_page = vmi_get_function(VMI_CALL_ReleasePage);
-	if (vmi_ops.release_page) {
-		pv_mmu_ops.release_pte = vmi_release_pte;
-		pv_mmu_ops.release_pmd = vmi_release_pmd;
-		pv_mmu_ops.pgd_free = vmi_pgd_free;
-	}
-
-	/* Set linear is needed in all cases */
-	vmi_ops.set_linear_mapping = vmi_get_function(VMI_CALL_SetLinearMapping);
-
-	/*
-	 * These MUST always be patched.  Don't support indirect jumps
-	 * through these operations, as the VMI interface may use either
-	 * a jump or a call to get to these operations, depending on
-	 * the backend.  They are performance critical anyway, so requiring
-	 * a patch is not a big problem.
-	 */
-	pv_cpu_ops.irq_enable_sysexit = (void *)0xfeedbab0;
-	pv_cpu_ops.iret = (void *)0xbadbab0;
-
-#ifdef CONFIG_SMP
-	para_wrap(pv_apic_ops.startup_ipi_hook, vmi_startup_ipi_hook, set_initial_ap_state, SetInitialAPState);
-#endif
-
-#ifdef CONFIG_X86_LOCAL_APIC
-       para_fill(apic->read, APICRead);
-       para_fill(apic->write, APICWrite);
-#endif
-
-	/*
-	 * Check for VMI timer functionality by probing for a cycle frequency method
-	 */
-	reloc = call_vrom_long_func(vmi_rom, get_reloc, VMI_CALL_GetCycleFrequency);
-	if (!disable_vmi_timer && rel->type != VMI_RELOCATION_NONE) {
-		vmi_timer_ops.get_cycle_frequency = (void *)rel->eip;
-		vmi_timer_ops.get_cycle_counter =
-			vmi_get_function(VMI_CALL_GetCycleCounter);
-		vmi_timer_ops.get_wallclock =
-			vmi_get_function(VMI_CALL_GetWallclockTime);
-		vmi_timer_ops.wallclock_updated =
-			vmi_get_function(VMI_CALL_WallclockUpdated);
-		vmi_timer_ops.set_alarm = vmi_get_function(VMI_CALL_SetAlarm);
-		vmi_timer_ops.cancel_alarm =
-			 vmi_get_function(VMI_CALL_CancelAlarm);
-		x86_init.timers.timer_init = vmi_time_init;
-#ifdef CONFIG_X86_LOCAL_APIC
-		x86_init.timers.setup_percpu_clockev = vmi_time_bsp_init;
-		x86_cpuinit.setup_percpu_clockev = vmi_time_ap_init;
-#endif
-		pv_time_ops.sched_clock = vmi_sched_clock;
-		x86_platform.calibrate_tsc = vmi_tsc_khz;
-		x86_platform.get_wallclock = vmi_get_wallclock;
-		x86_platform.set_wallclock = vmi_set_wallclock;
-
-		/* We have true wallclock functions; disable CMOS clock sync */
-		no_sync_cmos_clock = 1;
-	} else {
-		disable_noidle = 1;
-		disable_vmi_timer = 1;
-	}
-
-	para_fill(pv_irq_ops.safe_halt, Halt);
-
-	/*
-	 * Alternative instruction rewriting doesn't happen soon enough
-	 * to convert VMI_IRET to a call instead of a jump; so we have
-	 * to do this before IRQs get reenabled.  Fortunately, it is
-	 * idempotent.
-	 */
-	apply_paravirt(__parainstructions, __parainstructions_end);
-
-	vmi_bringup();
-
-	return 1;
-}
-
-#undef para_fill
-
-void __init vmi_init(void)
-{
-	if (!vmi_rom)
-		probe_vmi_rom();
-	else
-		check_vmi_rom(vmi_rom);
-
-	/* In case probing for or validating the ROM failed, basil */
-	if (!vmi_rom)
-		return;
-
-	reserve_top_address(-vmi_rom->virtual_top);
-
-#ifdef CONFIG_X86_IO_APIC
-	/* This is virtual hardware; timer routing is wired correctly */
-	no_timer_check = 1;
-#endif
-}
-
-void __init vmi_activate(void)
-{
-	unsigned long flags;
-
-	if (!vmi_rom)
-		return;
-
-	local_irq_save(flags);
-	activate_vmi();
-	local_irq_restore(flags & X86_EFLAGS_IF);
-}
-
-static int __init parse_vmi(char *arg)
-{
-	if (!arg)
-		return -EINVAL;
-
-	if (!strcmp(arg, "disable_pge")) {
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_PGE);
-		disable_pge = 1;
-	} else if (!strcmp(arg, "disable_pse")) {
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_PSE);
-		disable_pse = 1;
-	} else if (!strcmp(arg, "disable_sep")) {
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
-		disable_sep = 1;
-	} else if (!strcmp(arg, "disable_tsc")) {
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_TSC);
-		disable_tsc = 1;
-	} else if (!strcmp(arg, "disable_mtrr")) {
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_MTRR);
-		disable_mtrr = 1;
-	} else if (!strcmp(arg, "disable_timer")) {
-		disable_vmi_timer = 1;
-		disable_noidle = 1;
-	} else if (!strcmp(arg, "disable_noidle"))
-		disable_noidle = 1;
-	return 0;
-}
-
-early_param("vmi", parse_vmi);
diff --git a/arch/x86/kernel/vmiclock_32.c b/arch/x86/kernel/vmiclock_32.c
deleted file mode 100644
index 5e1ff66..0000000
--- a/arch/x86/kernel/vmiclock_32.c
+++ /dev/null
@@ -1,317 +0,0 @@
-/*
- * VMI paravirtual timer support routines.
- *
- * Copyright (C) 2007, VMware, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- * NON INFRINGEMENT.  See the GNU General Public License for more
- * details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#include <linux/smp.h>
-#include <linux/interrupt.h>
-#include <linux/cpumask.h>
-#include <linux/clocksource.h>
-#include <linux/clockchips.h>
-
-#include <asm/vmi.h>
-#include <asm/vmi_time.h>
-#include <asm/apicdef.h>
-#include <asm/apic.h>
-#include <asm/timer.h>
-#include <asm/i8253.h>
-#include <asm/irq_vectors.h>
-
-#define VMI_ONESHOT  (VMI_ALARM_IS_ONESHOT  | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
-#define VMI_PERIODIC (VMI_ALARM_IS_PERIODIC | VMI_CYCLES_REAL | vmi_get_alarm_wiring())
-
-static DEFINE_PER_CPU(struct clock_event_device, local_events);
-
-static inline u32 vmi_counter(u32 flags)
-{
-	/* Given VMI_ONESHOT or VMI_PERIODIC, return the corresponding
-	 * cycle counter. */
-	return flags & VMI_ALARM_COUNTER_MASK;
-}
-
-/* paravirt_ops.get_wallclock = vmi_get_wallclock */
-unsigned long vmi_get_wallclock(void)
-{
-	unsigned long long wallclock;
-	wallclock = vmi_timer_ops.get_wallclock(); // nsec
-	(void)do_div(wallclock, 1000000000);       // sec
-
-	return wallclock;
-}
-
-/* paravirt_ops.set_wallclock = vmi_set_wallclock */
-int vmi_set_wallclock(unsigned long now)
-{
-	return 0;
-}
-
-/* paravirt_ops.sched_clock = vmi_sched_clock */
-unsigned long long vmi_sched_clock(void)
-{
-	return cycles_2_ns(vmi_timer_ops.get_cycle_counter(VMI_CYCLES_AVAILABLE));
-}
-
-/* x86_platform.calibrate_tsc = vmi_tsc_khz */
-unsigned long vmi_tsc_khz(void)
-{
-	unsigned long long khz;
-	khz = vmi_timer_ops.get_cycle_frequency();
-	(void)do_div(khz, 1000);
-	return khz;
-}
-
-static inline unsigned int vmi_get_timer_vector(void)
-{
-	return IRQ0_VECTOR;
-}
-
-/** vmi clockchip */
-#ifdef CONFIG_X86_LOCAL_APIC
-static unsigned int startup_timer_irq(unsigned int irq)
-{
-	unsigned long val = apic_read(APIC_LVTT);
-	apic_write(APIC_LVTT, vmi_get_timer_vector());
-
-	return (val & APIC_SEND_PENDING);
-}
-
-static void mask_timer_irq(unsigned int irq)
-{
-	unsigned long val = apic_read(APIC_LVTT);
-	apic_write(APIC_LVTT, val | APIC_LVT_MASKED);
-}
-
-static void unmask_timer_irq(unsigned int irq)
-{
-	unsigned long val = apic_read(APIC_LVTT);
-	apic_write(APIC_LVTT, val & ~APIC_LVT_MASKED);
-}
-
-static void ack_timer_irq(unsigned int irq)
-{
-	ack_APIC_irq();
-}
-
-static struct irq_chip vmi_chip __read_mostly = {
-	.name 		= "VMI-LOCAL",
-	.startup 	= startup_timer_irq,
-	.mask	 	= mask_timer_irq,
-	.unmask	 	= unmask_timer_irq,
-	.ack 		= ack_timer_irq
-};
-#endif
-
-/** vmi clockevent */
-#define VMI_ALARM_WIRED_IRQ0    0x00000000
-#define VMI_ALARM_WIRED_LVTT    0x00010000
-static int vmi_wiring = VMI_ALARM_WIRED_IRQ0;
-
-static inline int vmi_get_alarm_wiring(void)
-{
-	return vmi_wiring;
-}
-
-static void vmi_timer_set_mode(enum clock_event_mode mode,
-			       struct clock_event_device *evt)
-{
-	cycle_t now, cycles_per_hz;
-	BUG_ON(!irqs_disabled());
-
-	switch (mode) {
-	case CLOCK_EVT_MODE_ONESHOT:
-	case CLOCK_EVT_MODE_RESUME:
-		break;
-	case CLOCK_EVT_MODE_PERIODIC:
-		cycles_per_hz = vmi_timer_ops.get_cycle_frequency();
-		(void)do_div(cycles_per_hz, HZ);
-		now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_PERIODIC));
-		vmi_timer_ops.set_alarm(VMI_PERIODIC, now, cycles_per_hz);
-		break;
-	case CLOCK_EVT_MODE_UNUSED:
-	case CLOCK_EVT_MODE_SHUTDOWN:
-		switch (evt->mode) {
-		case CLOCK_EVT_MODE_ONESHOT:
-			vmi_timer_ops.cancel_alarm(VMI_ONESHOT);
-			break;
-		case CLOCK_EVT_MODE_PERIODIC:
-			vmi_timer_ops.cancel_alarm(VMI_PERIODIC);
-			break;
-		default:
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-}
-
-static int vmi_timer_next_event(unsigned long delta,
-				struct clock_event_device *evt)
-{
-	/* Unfortunately, set_next_event interface only passes relative
-	 * expiry, but we want absolute expiry.  It'd be better if were
-	 * were passed an absolute expiry, since a bunch of time may
-	 * have been stolen between the time the delta is computed and
-	 * when we set the alarm below. */
-	cycle_t now = vmi_timer_ops.get_cycle_counter(vmi_counter(VMI_ONESHOT));
-
-	BUG_ON(evt->mode != CLOCK_EVT_MODE_ONESHOT);
-	vmi_timer_ops.set_alarm(VMI_ONESHOT, now + delta, 0);
-	return 0;
-}
-
-static struct clock_event_device vmi_clockevent = {
-	.name		= "vmi-timer",
-	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.shift		= 22,
-	.set_mode	= vmi_timer_set_mode,
-	.set_next_event = vmi_timer_next_event,
-	.rating         = 1000,
-	.irq		= 0,
-};
-
-static irqreturn_t vmi_timer_interrupt(int irq, void *dev_id)
-{
-	struct clock_event_device *evt = &__get_cpu_var(local_events);
-	evt->event_handler(evt);
-	return IRQ_HANDLED;
-}
-
-static struct irqaction vmi_clock_action  = {
-	.name 		= "vmi-timer",
-	.handler 	= vmi_timer_interrupt,
-	.flags 		= IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TIMER,
-};
-
-static void __devinit vmi_time_init_clockevent(void)
-{
-	cycle_t cycles_per_msec;
-	struct clock_event_device *evt;
-
-	int cpu = smp_processor_id();
-	evt = &__get_cpu_var(local_events);
-
-	/* Use cycles_per_msec since div_sc params are 32-bits. */
-	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
-	(void)do_div(cycles_per_msec, 1000);
-
-	memcpy(evt, &vmi_clockevent, sizeof(*evt));
-	/* Must pick .shift such that .mult fits in 32-bits.  Choosing
-	 * .shift to be 22 allows 2^(32-22) cycles per nano-seconds
-	 * before overflow. */
-	evt->mult = div_sc(cycles_per_msec, NSEC_PER_MSEC, evt->shift);
-	/* Upper bound is clockevent's use of ulong for cycle deltas. */
-	evt->max_delta_ns = clockevent_delta2ns(ULONG_MAX, evt);
-	evt->min_delta_ns = clockevent_delta2ns(1, evt);
-	evt->cpumask = cpumask_of(cpu);
-
-	printk(KERN_WARNING "vmi: registering clock event %s. mult=%u shift=%u\n",
-	       evt->name, evt->mult, evt->shift);
-	clockevents_register_device(evt);
-}
-
-void __init vmi_time_init(void)
-{
-	unsigned int cpu;
-	/* Disable PIT: BIOSes start PIT CH0 with 18.2hz peridic. */
-	outb_pit(0x3a, PIT_MODE); /* binary, mode 5, LSB/MSB, ch 0 */
-
-	vmi_time_init_clockevent();
-	setup_irq(0, &vmi_clock_action);
-	for_each_possible_cpu(cpu)
-		per_cpu(vector_irq, cpu)[vmi_get_timer_vector()] = 0;
-}
-
-#ifdef CONFIG_X86_LOCAL_APIC
-void __devinit vmi_time_bsp_init(void)
-{
-	/*
-	 * On APIC systems, we want local timers to fire on each cpu.  We do
-	 * this by programming LVTT to deliver timer events to the IRQ handler
-	 * for IRQ-0, since we can't re-use the APIC local timer handler
-	 * without interfering with that code.
-	 */
-	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
-	local_irq_disable();
-#ifdef CONFIG_SMP
-	/*
-	 * XXX handle_percpu_irq only defined for SMP; we need to switch over
-	 * to using it, since this is a local interrupt, which each CPU must
-	 * handle individually without locking out or dropping simultaneous
-	 * local timers on other CPUs.  We also don't want to trigger the
-	 * quirk workaround code for interrupts which gets invoked from
-	 * handle_percpu_irq via eoi, so we use our own IRQ chip.
-	 */
-	set_irq_chip_and_handler_name(0, &vmi_chip, handle_percpu_irq, "lvtt");
-#else
-	set_irq_chip_and_handler_name(0, &vmi_chip, handle_edge_irq, "lvtt");
-#endif
-	vmi_wiring = VMI_ALARM_WIRED_LVTT;
-	apic_write(APIC_LVTT, vmi_get_timer_vector());
-	local_irq_enable();
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
-}
-
-void __devinit vmi_time_ap_init(void)
-{
-	vmi_time_init_clockevent();
-	apic_write(APIC_LVTT, vmi_get_timer_vector());
-}
-#endif
-
-/** vmi clocksource */
-static struct clocksource clocksource_vmi;
-
-static cycle_t read_real_cycles(struct clocksource *cs)
-{
-	cycle_t ret = (cycle_t)vmi_timer_ops.get_cycle_counter(VMI_CYCLES_REAL);
-	return max(ret, clocksource_vmi.cycle_last);
-}
-
-static struct clocksource clocksource_vmi = {
-	.name			= "vmi-timer",
-	.rating			= 450,
-	.read			= read_real_cycles,
-	.mask			= CLOCKSOURCE_MASK(64),
-	.mult			= 0, /* to be set */
-	.shift			= 22,
-	.flags			= CLOCK_SOURCE_IS_CONTINUOUS,
-};
-
-static int __init init_vmi_clocksource(void)
-{
-	cycle_t cycles_per_msec;
-
-	if (!vmi_timer_ops.get_cycle_frequency)
-		return 0;
-	/* Use khz2mult rather than hz2mult since hz arg is only 32-bits. */
-	cycles_per_msec = vmi_timer_ops.get_cycle_frequency();
-	(void)do_div(cycles_per_msec, 1000);
-
-	/* Note that clocksource.{mult, shift} converts in the opposite direction
-	 * as clockevents.  */
-	clocksource_vmi.mult = clocksource_khz2mult(cycles_per_msec,
-						    clocksource_vmi.shift);
-
-	printk(KERN_WARNING "vmi: registering clock source khz=%lld\n", cycles_per_msec);
-	return clocksource_register(&clocksource_vmi);
-
-}
-module_init(init_vmi_clocksource);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 5c4ee42..a96023e 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -98,10 +98,6 @@ static void pgd_ctor(pgd_t *pgd)
 		clone_pgd_range(pgd + KERNEL_PGD_BOUNDARY,
 				swapper_pg_dir + KERNEL_PGD_BOUNDARY,
 				KERNEL_PGD_PTRS);
-		paravirt_alloc_pmd_clone(__pa(pgd) >> PAGE_SHIFT,
-					 __pa(swapper_pg_dir) >> PAGE_SHIFT,
-					 KERNEL_PGD_BOUNDARY,
-					 KERNEL_PGD_PTRS);
 	}
 
 	/* list required to sync kernel mapping updates */
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 42086ac..b2363fc 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1969,7 +1969,6 @@ static const struct pv_mmu_ops xen_mmu_ops __initdata = {
 	.alloc_pte = xen_alloc_pte_init,
 	.release_pte = xen_release_pte_init,
 	.alloc_pmd = xen_alloc_pmd_init,
-	.alloc_pmd_clone = paravirt_nop,
 	.release_pmd = xen_release_pmd_init,
 
 #ifdef CONFIG_X86_64

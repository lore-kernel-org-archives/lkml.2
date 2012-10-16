Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2JPP0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:26:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:53109 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123Ab2JPP0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="234561110"
Date: Tue, 16 Oct 2012 23:26:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: (ima_inode_post_setattr related) BUG: unable to handle kernel paging
 request
Message-ID: <20121016152629.GA5236@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi James,

FYI, I got the attached oops in linux-next and it's bisected down to:

commit 88265322c14cce39f7afbc416726ef4fac413298
Merge: 65b99c7 bf53083
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Tue Oct 2 21:38:48 2012 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Tue Oct 2 21:38:48 2012 -0700

    Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security
    
    Pull security subsystem updates from James Morris:
     "Highlights:
    
       - Integrity: add local fs integrity verification to detect offline
         attacks
       - Integrity: add digital signature verification
       - Simple stacking of Yama with other LSMs (per LSS discussions)
       - IBM vTPM support on ppc64
       - Add new driver for Infineon I2C TIS TPM
       - Smack: add rule revocation for subject labels"
    
    Fixed conflicts with the user namespace support in kernel/auditsc.c and
    security/integrity/ima/ima_policy.c.
    
    * 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security: (39 commits)

[    8.887933] Write protecting the kernel read-only data: 3212k
[    8.924449] =============================================================================
[    8.925786] BUG dentry (Not tainted): Invalid object pointer 0xcd48f9a8
[    8.926749] -----------------------------------------------------------------------------
[    8.926749] 
[    8.928011] Disabling lock debugging due to kernel taint
[    8.928011] INFO: Slab 0xcdee81e0 objects=23 used=23 fp=0x  (null) flags=0x40000081
[    8.928011] Pid: 1, comm: init Tainted: G    B        3.7.0-rc1-bisect-00005-gdd8e8c4 #2
[    8.928011] Call Trace:
[    8.928011]  [<c10bc7fd>] slab_err+0x38/0x40
[    8.928011]  [<c10bd09d>] ? slab_pad_check.part.50+0x5e/0xd2
[    8.928011]  [<c1683420>] free_debug_processing+0x19b/0x1a0
[    8.928011]  [<c1683460>] __slab_free+0x3b/0x26a
[    8.928011]  [<c10dc46b>] ? __simple_xattr_set+0xe8/0xf8
[    8.928011]  [<c10be6c5>] kfree+0xaa/0xb3
[    8.928011]  [<c10be6c5>] ? kfree+0xaa/0xb3
[    8.928011]  [<c10dc46b>] ? __simple_xattr_set+0xe8/0xf8
[    8.928011]  [<c10aa6da>] ? unmap_mapping_range+0x11f/0x127
[    8.928011]  [<c16a4a0e>] ? mutex_lock+0x18/0x31
[    8.928011]  [<c10dc46b>] ? __simple_xattr_set+0xe8/0xf8
[    8.928011]  [<c10dc46b>] __simple_xattr_set+0xe8/0xf8
[    8.928011]  [<c10dc516>] simple_xattr_remove+0xe/0x10
[    8.928011]  [<c109f136>] shmem_removexattr+0x42/0x47
[    8.928011]  [<c11c3e75>] ima_inode_post_setattr+0x76/0x7b
[    8.928011]  [<c10d6a60>] notify_change+0x268/0x284
[    8.928011]  [<c10c2c52>] do_truncate+0x60/0x77
[    8.928011]  [<c11c3583>] ? ima_get_action+0x1f/0x24
[    8.928011]  [<c10cac23>] handle_truncate+0x73/0x84
[    8.928011]  [<c10cd614>] do_last.isra.27+0x445/0x502
[    8.928011]  [<c10cd764>] path_openat.isra.28+0x93/0x340
[    8.928011]  [<c1683974>] ? __slab_alloc.constprop.66+0x258/0x27d
[    8.928011]  [<c10cda32>] do_filp_open+0x21/0x5d
[    8.928011]  [<c10d7445>] ? __alloc_fd+0x36/0xdc
[    8.928011]  [<c10c3979>] do_sys_open+0xfa/0x173
[    8.928011]  [<c10c3a13>] sys_open+0x21/0x29
[    8.928011]  [<c16a6c4a>] sysenter_do_call+0x12/0x2c
[    8.961197] FIX dentry: Object at 0xcd48f9a8 not freed
[    8.962022] BUG: unable to handle kernel paging request at 6b6b6be3
[    8.963103] IP: [<c16a4a2a>] mutex_unlock+0x3/0x16
[    8.963939] *pde = 00000000 
[    8.964551] Oops: 0002 [#1] SMP 
[    8.965122] Pid: 1, comm: init Tainted: G    B        3.7.0-rc1-bisect-00005-gdd8e8c4 #2 Bochs Bochs
[    8.965122] EIP: 0060:[<c16a4a2a>] EFLAGS: 00010212 CPU: 0
[    8.965122] EIP is at mutex_unlock+0x3/0x16
[    8.965122] EAX: 6b6b6bd3 EBX: cd765790 ECX: cd89b998 EDX: 0000a068
[    8.965122] ESI: 00000000 EDI: cf925c00 EBP: cd84fe04 ESP: cd84fe04
[    8.965122]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    8.965122] CR0: 80050033 CR2: 6b6b6be3 CR3: 0f8a9000 CR4: 00000690
[    8.965122] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    8.965122] DR6: ffff0ff0 DR7: 00000400
[    8.965122] Process init (pid: 1, ti=cd84e000 task=cd850000 task.ti=cd84e000)
[    8.965122] Stack:
[    8.965122]  cd84fe4c c10c2c5f 0000a068 cd84fecc cd84fe24 c11c3583 00000000 00000000
[    8.965122]  507d1295 37049458 507d1295 37049458 507d1295 37049458 cf925c00 cd89b9a4
[    8.965122]  cd765790 cf925c00 cd84fe68 c10cac23 00008060 cf925c00 cd84ff00 00000000
[    8.965122] Call Trace:
[    8.965122]  [<c10c2c5f>] do_truncate+0x6d/0x77
[    8.965122]  [<c11c3583>] ? ima_get_action+0x1f/0x24
[    8.965122]  [<c10cac23>] handle_truncate+0x73/0x84
[    8.965122]  [<c10cd614>] do_last.isra.27+0x445/0x502
[    8.965122]  [<c10cd764>] path_openat.isra.28+0x93/0x340
[    8.965122]  [<c1683974>] ? __slab_alloc.constprop.66+0x258/0x27d
[    8.965122]  [<c10cda32>] do_filp_open+0x21/0x5d
[    8.965122]  [<c10d7445>] ? __alloc_fd+0x36/0xdc
[    8.965122]  [<c10c3979>] do_sys_open+0xfa/0x173
[    8.965122]  [<c10c3a13>] sys_open+0x21/0x29
[    8.965122]  [<c16a6c4a>] sysenter_do_call+0x12/0x2c
[    8.965122] Code: b8 c0 91 8c c1 ba 55 00 00 00 e8 d5 9f 9c ff 89 d8 f0 ff 08 79 05 e8 ce 00 00 00 64 a1 88 17 af c1 89 43 10 59 5b 5d c
3 55 89 e5 <c7> 40 10 00 00 00 00 f0 ff 00 7f 05 e8 02 00 00 00 5d c3 55 89
[    8.965122] EIP: [<c16a4a2a>] mutex_unlock+0x3/0x16 SS:ESP 0068:cd84fe04
[    8.965122] CR2: 000000006b6b6be3
[    8.998377] ---[ end trace c748b36104e4e97e ]---

Thanks,
Fengguang

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm_bisect-inn-20853-2012-10-16-23-11-09-3.7.0-rc1-bisect-next-20121016-24"

[    0.000000] Linux version 3.7.0-rc1-bisect-next-20121016 (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #24 SMP Tue Oct 16 22:20:10 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x01ffa000-0x01ffffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128476(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1af5d41, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1a4b7c0, node_mem_map cdd3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @cdd2b000 s25792 r0 d15168 u40960
[    0.000000] pcpu-alloc: s25792 r0 d15168 u40960 alloc=10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dd30d41, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd2d6c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-i070 branch=internal-yuanhan/pm-sleep-fixes log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 214104k/262136k available (6821k kernel code, 47532k reserved, 3847k data, 556k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1a6c000 - 0xc1af7000   ( 556 kB)
[    0.000000]       .data : 0xc16a9660 - 0xc1a6b2c0   (3847 kB)
[    0.000000]       .text : 0xc1000000 - 0xc16a9660   (6821 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=cd808000 soft=cd80a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.456 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5386.91 BogoMIPS (lpj=10773824)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008133] Security Framework initialized
[    0.009380] Yama: becoming mindful.
[    0.010531] Mount-cache hash table entries: 512
[    0.012597] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012597] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.012597] tlb_flushall_shift: 6
[    0.016304] Freeing SMP alternatives: 24k freed
[    0.022274] ACPI: Core revision 20120913
[    0.033421] Getting VERSION: 50014
[    0.034487] Getting VERSION: 50014
[    0.035525] Getting ID: 0
[    0.036018] Getting ID: f000000
[    0.037064] Getting LVT0: 8700
[    0.038077] Getting LVT1: 8400
[    0.039038] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.040093] enabled ExtINT on CPU#0
[    0.042207] ENABLING IO-APIC IRQs
[    0.044013] init IO_APIC IRQs
[    0.045046]  apic 2 pin 0 not connected
[    0.046099] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.048033] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.050186] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.052029] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.054228] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.056033] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.058245] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.060035] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.064028] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.066235] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.068031] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.070301] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.072032] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.074320] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.076031] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.080024]  apic 2 pin 16 not connected
[    0.081192]  apic 2 pin 17 not connected
[    0.082289]  apic 2 pin 18 not connected
[    0.083425]  apic 2 pin 19 not connected
[    0.084007]  apic 2 pin 20 not connected
[    0.085164]  apic 2 pin 21 not connected
[    0.086319]  apic 2 pin 22 not connected
[    0.088005]  apic 2 pin 23 not connected
[    0.089297] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.091147] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.094389] Using local APIC timer interrupts.
[    0.094389] calibrating APIC timer ...
[    0.100000] ... lapic delta = 6249876
[    0.100000] ... PM-Timer delta = 357948
[    0.100000] ... PM-Timer result ok
[    0.100000] ..... delta 6249876
[    0.100000] ..... mult: 268430130
[    0.100000] ..... calibration result: 3999920
[    0.100000] ..... CPU clock speed is 2693.1840 MHz.
[    0.100000] ..... host bus clock speed is 999.3920 MHz.
[    0.100068] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.105266] CPU 1 irqstacks, hard=cd88c000 soft=cd88e000
[    0.106732] smpboot: Booting Node   0, Processors  #1 OK
[    0.008000] Initializing CPU#1
[    0.008000] kvm-clock: cpu 1, msr 0:dd3ad41, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.132047] Brought up 2 CPUs
[    0.133081] smpboot: Total of 2 processors activated (10773.82 BogoMIPS)
[    0.132025] KVM setup async PF for cpu 1
[    0.132025] kvm-stealtime: cpu 1, msr dd376c0
[    0.136464] CPU0 attaching sched-domain:
[    0.140008]  domain 0: span 0-1 level CPU
[    0.141281]   groups: 0 (cpu_power = 1003) 1
[    0.142947] CPU1 attaching sched-domain:
[    0.144007]  domain 0: span 0-1 level CPU
[    0.145268]   groups: 1 0 (cpu_power = 1003)
[    0.148490] EVM: security.ima
[    0.149459] EVM: security.capability
[    0.151399] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.152225] NET: Registered protocol family 16
[    0.154580] EISA bus registered
[    0.156696] ACPI: bus type pci registered
[    0.158121] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.160005] PCI: Using configuration type 1 for base access
[    0.175628] bio: create slab <bio-0> at 0
[    0.176591] ACPI: Added _OSI(Module Device)
[    0.177913] ACPI: Added _OSI(Processor Device)
[    0.179101] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.180015] ACPI: Added _OSI(Processor Aggregator Device)
[    0.182286] ACPI: EC: Look up EC in DSDT
[    0.195531] ACPI: Interpreter enabled
[    0.196007] ACPI: (supports S0 S3 S5)
[    0.197584] ACPI: Using IOAPIC for interrupt routing
[    0.215413] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.216106] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.220027] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.222223] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.224008] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.226387] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.228016] PCI: root bus 00: using default resources
[    0.229504] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.232139] PCI host bridge to bus 0000:00
[    0.233363] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.236009] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.237726] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.240070] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.242049] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.244371] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.246933] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.248562] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.249797] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.251029] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.252134] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.254892] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.256803] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.261653] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.263686] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.264883] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.268845] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.274057] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.276057] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.278589] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.280327] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.284467] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.286039] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.287516] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.291109] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.292631] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.294118] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.298517] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.300320] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.301780] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.305635] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.307219] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.308594] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.312748] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.314351] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.316004] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.320139] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.321413] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.324347] pci_bus 0000:00: on NUMA node 0
[    0.325106] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.329463]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.330775]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.355134] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.356585] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.358049] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.359540] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.360817] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.362176] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.363544] vgaarb: loaded
[    0.364003] vgaarb: bridge control possible 0000:00:02.0
[    0.364912] tps65010: version 2 May 2005
[    0.396071] tps65010: no chip?
[    0.398247] SCSI subsystem initialized
[    0.399494] libata version 3.00 loaded.
[    0.400087] ACPI: bus type usb registered
[    0.401375] usbcore: registered new interface driver usbfs
[    0.408048] usbcore: registered new interface driver hub
[    0.409733] usbcore: registered new device driver usb
[    0.412152] Linux video capture interface: v2.00
[    0.413120] PCI: Using ACPI for IRQ routing
[    0.413874] PCI: pci_cache_line_size set to 64 bytes
[    0.414882] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.416010] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.417914] Switching to clocksource kvm-clock
[    0.418674] FS-Cache: Loaded
[    0.418869] CacheFiles: Loaded
[    0.419766] pnp: PnP ACPI init
[    0.420000] ACPI: bus type pnp registered
[    0.420000] pnp 00:00: [bus 00-ff]
[    0.420799] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.421789] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.422897] pnp 00:00: [io  0x0d00-0xffff window]
[    0.423992] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.425227] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.426512] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.427976] pnp 00:01: [io  0x0070-0x0071]
[    0.429008] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.430877] pnp 00:01: [irq 8]
[    0.431694] pnp 00:01: [io  0x0072-0x0077]
[    0.432796] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.434363] pnp 00:02: [io  0x0060]
[    0.435259] pnp 00:02: [io  0x0064]
[    0.436160] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.438004] pnp 00:02: [irq 1]
[    0.438892] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.440481] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.442395] pnp 00:03: [irq 12]
[    0.443301] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.444846] pnp 00:04: [io  0x03f2-0x03f5]
[    0.445837] pnp 00:04: [io  0x03f7]
[    0.446720] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.448589] pnp 00:04: [irq 6]
[    0.449403] pnp 00:04: [dma 2]
[    0.450267] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.451961] pnp 00:05: [io  0x0378-0x037f]
[    0.452991] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.454850] pnp 00:05: [irq 7]
[    0.455741] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.457451] pnp 00:06: [io  0x03f8-0x03ff]
[    0.458439] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.460406] pnp 00:06: [irq 4]
[    0.461495] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.464144] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.465662] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.468357] pnp: PnP ACPI: found 8 devices
[    0.469473] ACPI: ACPI bus type pnp unregistered
[    0.510290] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.511844] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.513714] NET: Registered protocol family 2
[    0.515370] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.517340] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.519142] TCP: Hash tables configured (established 8192 bind 8192)
[    0.520956] TCP: reno registered
[    0.522000] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.523660] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.525541] NET: Registered protocol family 1
[    0.526868] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.528515] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.530098] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.531757] pci 0000:00:02.0: Boot video device
[    0.533213] PCI: CLS 0 bytes, default 64
[    0.534663] Trying to unpack rootfs image as initramfs...
[    1.429083] Freeing initrd memory: 25284k freed
[    1.436677] kvm: no hardware support
[    1.438310] apm: BIOS not found.
[    1.439614] NatSemi SCx200 Driver
[    1.441463] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.451720] VFS: Disk quotas dquot_6.5.2
[    1.453022] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.455845] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.457233] QNX4 filesystem 0.2.3 registered.
[    1.458458] SGI XFS with security attributes, realtime, no debug enabled
[    1.462038] alg: No test for cipher_null (cipher_null-generic)
[    1.463708] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.465390] alg: No test for compress_null (compress_null-generic)
[    1.467075] alg: No test for digest_null (digest_null-generic)
[    1.472632] alg: No test for fcrypt (fcrypt-generic)
[    1.478055] alg: No test for stdrng (krng)
[    1.479245] NET: Registered protocol family 38
[    1.480655] Key type asymmetric registered
[    1.482095] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.484325] io scheduler noop registered (default)
[    1.485713] io scheduler deadline registered
[    1.487174] io scheduler cfq registered
[    1.488464] xz_dec_test: module loaded
[    1.489637] xz_dec_test: Create a device node with 'mknod xz_dec_test c 252 0' and write .xz files to it.
[    1.492662] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.494226] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    1.496086] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[    1.501369] GHES: HEST is not enabled!
[    1.502566] ERST DBG: ERST support is disabled.
[    1.503956] isapnp: Scanning for PnP cards...
[    1.871479] isapnp: No Plug & Play device found
[    1.872455] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.895101] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.897879] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.899563] Real Time Clock Driver v1.12b
[    1.900781] Non-volatile memory driver v1.3
[    1.901968] toshiba: not a supported Toshiba laptop
[    1.903322] scx200_gpio: no SCx200 gpio present
[    1.904667] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    1.906415] platform pc8736x_gpio.0: no device found
[    1.907761] nsc_gpio initializing
[    1.908799] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    1.910202] SyncLink PC Card driver $Revision: 4.34 $, tty major#246
[    1.911743] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    1.914107] Hangcheck: Using getrawmonotonic().
[    1.919266] brd: module loaded
[    1.920269] HP CISS Driver (v 3.6.26)
[    1.921798] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    1.921933] Floppy drive(s): fd0 is 1.44M
[    1.924762] Phantom Linux Driver, version n0.9.8, init OK
[    1.926254] i2c-core: driver [tsl2550] using legacy suspend method
[    1.927726] i2c-core: driver [tsl2550] using legacy resume method
[    1.929326] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    1.931520] i2c-core: driver [fsa9480] using legacy suspend method
[    1.933166] i2c-core: driver [fsa9480] using legacy resume method
[    1.934967] Driver for timberdale has been successfully registered.
[    1.936750] Uniform Multi-Platform E-IDE driver
[    1.938431] ide-gd driver 1.18
[    1.939591] hp_sw: device handler registered
[    1.940864] emc: device handler registered
[    1.942044] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.943762] osst :I: Tape driver with OnStream support version 0.99.4
[    1.943762] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    1.944720] FDC 0 is a S82078B
[    1.948582] SCSI Media Changer driver v0.25 
[    1.950003] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    1.951379] YAM driver version 0.8 by F1OAT/F6FBB
[    1.953696] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    1.953696] baycom_ser_fdx: version 0.10
[    1.957332] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    1.958862] hdlcdrv: version 0.8
[    1.959832] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    1.959832] baycom_ser_hdx: version 0.10
[    1.963566] I2O subsystem v1.325
[    1.964607] i2o: max drivers = 8
[    1.965851] I2O Bus Adapter OSM v1.317
[    1.966950] I2O Block Device OSM v1.325
[    1.968520] I2O SCSI Peripheral OSM v1.316
[    1.969717] Fusion MPT base driver 3.04.20
[    1.970876] Copyright (c) 1999-2008 LSI Corporation
[    1.972297] Fusion MPT FC Host driver 3.04.20
[    1.973958] Databook TCIC-2 PCMCIA probe: not found.
[    1.975483] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.977182] ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
[    1.978787] uhci_hcd: USB Universal Host Controller Interface driver
[    1.980637] driver u132_hcd
[    1.981731] usbcore: registered new interface driver usblp
[    1.983202] usbcore: registered new interface driver usbtmc
[    1.984730] usbcore: registered new interface driver uas
[    1.986335] Initializing USB Mass Storage driver...
[    1.987672] usbcore: registered new interface driver usb-storage
[    1.989283] USB Mass Storage support registered.
[    1.990564] usbcore: registered new interface driver ums-alauda
[    1.992169] usbcore: registered new interface driver ums-cypress
[    1.993730] usbcore: registered new interface driver ums-datafab
[    1.995214] usbcore: registered new interface driver ums-freecom
[    1.996784] usbcore: registered new interface driver ums-jumpshot
[    1.998314] usbcore: registered new interface driver ums-onetouch
[    1.999859] usbcore: registered new interface driver ums-sddr55
[    2.001414] usbcore: registered new interface driver ums-usbat
[    2.002916] usbcore: registered new interface driver microtekX6
[    2.004582] usbcore: registered new interface driver usbserial
[    2.006115] usbcore: registered new interface driver usbserial_generic
[    2.007780] usbserial: USB Serial support registered for generic
[    2.022598] usbcore: registered new interface driver aircable
[    2.024177] usbserial: USB Serial support registered for aircable
[    2.025755] usbcore: registered new interface driver ch341
[    2.027170] usbserial: USB Serial support registered for ch341-uart
[    2.028789] usbcore: registered new interface driver cyberjack
[    2.030294] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    2.032675] usbcore: registered new interface driver cypress_m8
[    2.034241] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    2.036293] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    2.038350] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    2.040458] usbcore: registered new interface driver digi_acceleport
[    2.042119] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    2.044137] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    2.046207] usbcore: registered new interface driver io_edgeport
[    2.047771] usbserial: USB Serial support registered for Edgeport 2 port adapter
[    2.049924] usbserial: USB Serial support registered for Edgeport 4 port adapter
[    2.052046] usbserial: USB Serial support registered for Edgeport 8 port adapter
[    2.054174] usbserial: USB Serial support registered for EPiC device
[    2.055823] usbcore: registered new interface driver io_ti
[    2.057370] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[    2.059517] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[    2.061659] usbcore: registered new interface driver empeg
[    2.063167] usbserial: USB Serial support registered for empeg
[    2.064764] usbcore: registered new interface driver ftdi_sio
[    2.066274] usbserial: USB Serial support registered for FTDI USB Serial Device
[    2.068377] usbcore: registered new interface driver funsoft
[    2.069907] usbserial: USB Serial support registered for funsoft
[    2.071476] usbcore: registered new interface driver ipaq
[    2.072959] usbserial: USB Serial support registered for PocketPC PDA
[    2.074617] usbcore: registered new interface driver ipw
[    2.076049] usbserial: USB Serial support registered for IPWireless converter
[    2.077698] usbcore: registered new interface driver ir_usb
[    2.079187] usbserial: USB Serial support registered for IR Dongle
[    2.080940] usbcore: registered new interface driver kl5kusb105
[    2.082565] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    2.084653] usbcore: registered new interface driver mos7720
[    2.086148] usbserial: USB Serial support registered for Moschip 2 port adapter
[    2.088241] usbcore: registered new interface driver navman
[    2.089679] usbserial: USB Serial support registered for navman
[    2.091220] usbcore: registered new interface driver option
[    2.092844] usbserial: USB Serial support registered for GSM modem (1-port)
[    2.094654] usbcore: registered new interface driver oti6858
[    2.096141] usbserial: USB Serial support registered for oti6858
[    2.097636] usbcore: registered new interface driver qcaux
[    2.099211] usbserial: USB Serial support registered for qcaux
[    2.100798] usbcore: registered new interface driver quatech2
[    2.102284] usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    2.104640] usbcore: registered new interface driver safe_serial
[    2.106225] usbserial: USB Serial support registered for safe_serial
[    2.107853] usbcore: registered new interface driver ssu100
[    2.109314] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    2.111524] usbcore: registered new interface driver ti_usb_3410_5052
[    2.113240] usbserial: USB Serial support registered for TI USB 3410 1 port adapter
[    2.115213] usbserial: USB Serial support registered for TI USB 5052 2 port adapter
[    2.117354] usbcore: registered new interface driver visor
[    2.118800] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    2.120925] usbserial: USB Serial support registered for Sony Clie 5.0
[    2.122555] usbserial: USB Serial support registered for Sony Clie 3.5
[    2.124221] usbcore: registered new interface driver whiteheat
[    2.125781] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    2.128246] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    2.130399] usbcore: registered new interface driver zte_ev
[    2.131893] usbserial: USB Serial support registered for zte_ev
[    2.133499] usbcore: registered new interface driver adutux
[    2.135187] usbcore: registered new interface driver appledisplay
[    2.136774] usbcore: registered new interface driver cypress_cy7c63
[    2.138392] usbcore: registered new interface driver cytherm
[    2.139885] usbcore: registered new interface driver emi26 - firmware loader
[    2.141741] usbcore: registered new interface driver emi62 - firmware loader
[    2.143538] driver ftdi-elan
[    2.144837] usbcore: registered new interface driver ftdi-elan
[    2.146438] usbcore: registered new interface driver isight_firmware
[    2.148118] usbcore: registered new interface driver usblcd
[    2.149648] usbcore: registered new interface driver usbled
[    2.151163] usbcore: registered new interface driver legousbtower
[    2.152797] usbcore: registered new interface driver usbtest
[    2.154245] usbcore: registered new interface driver trancevibrator
[    2.155842] usbcore: registered new interface driver usbsevseg
[    2.157412] usbcore: registered new interface driver yurex
[    2.159109] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.162347] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.163839] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.240635] mousedev: PS/2 mouse device common for all mice
[    2.242486] usbcore: registered new interface driver bcm5974
[    2.244199] logibm.c: Didn't find Logitech busmouse at 0x23c
[    2.246340] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.248986] usbcore: registered new interface driver synaptics_usb
[    2.251660] usbcore: registered new interface driver aiptek
[    2.253186] usbcore: registered new interface driver hanwang
[    2.254733] usbcore: registered new interface driver kbtab
[    2.258552] usbcore: registered new interface driver wacom
[    2.260052] i2c /dev entries driver
[    2.261748] i2c-parport-light: adapter type unspecified
[    2.263247] scx200_acb: NatSemi SCx200 ACCESS.bus Driver
[    2.264783] scx200_i2c: NatSemi SCx200 I2C Driver
[    2.266222] scx200_i2c: no SCx200 gpio pins available
[    2.268159] i2c-core: driver [adv7180] using legacy suspend method
[    2.269802] i2c-core: driver [adv7180] using legacy resume method
[    2.272025] usbcore: registered new interface driver ati_remote
[    2.273669] usbcore: registered new interface driver imon
[    2.275199] usbcore: registered new interface driver redrat3
[    2.276719] usbcore: registered new interface driver streamzap
[    2.278289] Registered IR keymap rc-empty
[    2.279624] input: rc-core loopback device as /devices/virtual/rc/rc0/input1
[    2.281613] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    2.283484] usbcore: registered new interface driver iguanair
[    2.285016] Zoran MJPEG board driver version 0.10.1
[    2.286407] Linux video codec intermediate layer: v0.2
[    2.287753] meye: using 2 buffers with 600k (1200k total) for capture
[    2.289436] gspca_main: v2.14.0 registered
[    2.290631] usbcore: registered new interface driver benq
[    2.292139] usbcore: registered new interface driver conex
[    2.293619] usbcore: registered new interface driver cpia1
[    2.295072] usbcore: registered new interface driver finepix
[    2.296638] usbcore: registered new interface driver jeilinj
[    2.298111] usbcore: registered new interface driver jl2005bcd
[    2.299632] usbcore: registered new interface driver konica
[    2.301134] usbcore: registered new interface driver mars
[    2.302610] usbcore: registered new interface driver nw80x
[    2.304124] usbcore: registered new interface driver ov519
[    2.305610] usbcore: registered new interface driver ov534
[    2.307097] usbcore: registered new interface driver pac207
[    2.308622] usbcore: registered new interface driver sn9c2028
[    2.310153] usbcore: registered new interface driver gspca_sn9c20x
[    2.311808] usbcore: registered new interface driver sonixb
[    2.313347] usbcore: registered new interface driver sonixj
[    2.314743] usbcore: registered new interface driver spca501
[    2.316250] usbcore: registered new interface driver spca505
[    2.317735] usbcore: registered new interface driver spca1528
[    2.319261] usbcore: registered new interface driver sq905
[    2.320778] usbcore: registered new interface driver sq930x
[    2.322281] usbcore: registered new interface driver stk014
[    2.323786] usbcore: registered new interface driver tv8532
[    2.325271] usbcore: registered new interface driver vc032x
[    2.326744] usbcore: registered new interface driver xirlink-cit
[    2.328318] usbcore: registered new interface driver ALi m5602
[    2.329868] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[    2.331530] usbcore: registered new interface driver cpia2
[    2.333073] usbcore: registered new interface driver hdpvr
[    2.334534] usbcore: registered new interface driver usbvision
[    2.336067] USBVision USB Video Device Driver for Linux : 0.9.11
[    2.337631] usbcore: registered new interface driver tm6000
[    2.339077] usbcore: registered new interface driver em28xx
[    2.340571] Em28xx: Initialized (Em28xx Input Extension) extension
[    2.342169] radio-sf16fmi: no cards found
[    2.436107] tsc: Refined TSC clocksource calibration: 2693.500 MHz
[    2.488865] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    8.672602] radio-aimslab.0: Initialized radio card AIMSlab RadioTrack/RadioReveal on port 0x30f
[    8.674839] usbcore: registered new interface driver radio-si470x
[    8.676242] usbcore: registered new interface driver radio-keene
[    8.677645] Driver for 1-wire Dallas network protocol.
[    8.678935] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.681047] f71882fg: Not a Fintek device
[    8.682069] f71882fg: Not a Fintek device
[    8.683771] EISA: Probing bus 0 at eisa.0
[    8.698089] cpuidle: using governor ladder
[    8.699380] sdhci: Secure Digital Host Controller Interface driver
[    8.701042] sdhci: Copyright(c) Pierre Ossman
[    8.703337] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    8.705230] usbcore: registered new interface driver vub300
[    8.707462] ledtrig-cpu: registered to indicate activity on CPUs
[    8.709065] EFI Variables Facility v0.08 2004-May-17
[    8.710642] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.712922] usbip_core: USB/IP Core v1.0.0
[    8.714113] rts_pstor: Initializing Realtek PCIE storage driver...
[    8.715792] usbcore: registered new interface driver tranzport
[    8.717444] usbcore: registered new interface driver alphatrack
[    8.719420] Error: Driver 'adt7410' is already registered, aborting...
[    8.721890] Loading crystalhd 0.9.27
[    8.724342] input: Speakup as /devices/virtual/input/input3
[    8.726175] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    8.727974] speakup 3.1.6: initialized
[    8.729167] synth name on entry is: (null)
[    8.730678] ozwpan ozwpan: Ozmo Devices WPAN
[    8.731985] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    8.733850] usb usb1: default language 0x0409
[    8.735101] usb usb1: udev 1, busnum 1, minor = 0
[    8.736465] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    8.738257] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.740458] usb usb1: Product: Ozmo Devices WPAN
[    8.741735] usb usb1: Manufacturer: Linux 3.7.0-rc1-bisect-next-20121016 Ozmo WPAN
[    8.743982] usb usb1: SerialNumber: ozwpan
[    8.745513] usb usb1: usb_probe_device
[    8.746643] usb usb1: configuration #1 chosen from 1 choice
[    8.748217] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.749759] hub 1-0:1.0: usb_probe_interface
[    8.751029] hub 1-0:1.0: usb_probe_interface - got id
[    8.752553] hub 1-0:1.0: USB hub found
[    8.753721] hub 1-0:1.0: 8 ports detected
[    8.754875] hub 1-0:1.0: standalone hub
[    8.756088] hub 1-0:1.0: individual port power switching
[    8.757580] hub 1-0:1.0: global over-current protection
[    8.759084] hub 1-0:1.0: power on to power good time: 0ms
[    8.760698] hub 1-0:1.0: 200mA bus power budget for each child
[    8.762315] hub 1-0:1.0: local power source is good
[    8.763747] hub 1-0:1.0: no over-current condition exists
[    8.765686] hub 1-0:1.0: enabling power on all ports
[    8.767327] usbcore: registered new interface driver cedusb
[    8.769194] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
[    8.771761] hdaps: supported laptop not found!
[    8.773124] hdaps: driver init failed (ret=-19)!
[    8.774786] FUJ02B1: call_fext_func: FUNC interface is not present
[    8.776481] fujitsu_laptop: driver 0.6.0 successfully loaded
[    8.778119] fujitsu_tablet: Unknown (using defaults)
[    8.779722] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
[    8.782416] NET: Registered protocol family 26
[    8.784627] IPv4 over IPv4 tunneling driver
[    8.786203] gre: GRE over IPv4 demultiplexor driver
[    8.787484] ip_gre: GRE over IPv4 tunneling driver
[    8.789131] IPv4 over IPSec tunneling driver
[    8.790679] TCP: bic registered
[    8.792317] NET: Registered protocol family 10
[    8.794613] ip6_gre: GRE over IPv6 tunneling driver
[    8.796518] NET: Registered protocol family 4
[    8.799925] NET: Registered protocol family 11
[    8.801340] NET: Registered protocol family 3
[    8.802597] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    8.805231] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes
[    8.806924] NET: Registered protocol family 12
[    8.808367] NET: Registered protocol family 35
[    8.809871] NET: Registered protocol family 37
[    8.811206] Key type dns_resolver registered
[    8.820716] batman_adv: B.A.T.M.A.N. advanced 2012.4.0 (compatibility version 14) loaded
[    8.823248] openvswitch: Open vSwitch switching datapath
[    8.825733] 
[    8.825733] printing PIC contents
[    8.827413] ... PIC  IMR: ffff
[    8.828496] ... PIC  IRR: 1053
[    8.829566] ... PIC  ISR: 0000
[    8.830571] ... PIC ELCR: 0c00
[    8.831598] printing local APIC contents on CPU#0/0:
[    8.833133] ... APIC ID:      00000000 (0)
[    8.833553] ... APIC VERSION: 00050014
[    8.833553] ... APIC TASKPRI: 00000000 (00)
[    8.833553] ... APIC PROCPRI: 00000000
[    8.833553] ... APIC LDR: 01000000
[    8.833553] ... APIC DFR: ffffffff
[    8.833553] ... APIC SPIV: 000001ff
[    8.833553] ... APIC ISR field:
[    8.833553] 0000000000000000000000000000000000000000000000000000000000000000
[    8.833553] ... APIC TMR field:
[    8.833553] 0000000000000000000000000000000000000000000000000000000000000000
[    8.833553] ... APIC IRR field:
[    8.833553] 0000000000000000000000000000000000000000000000000000000000008000
[    8.833553] ... APIC ESR: 00000000
[    8.833553] ... APIC ICR: 000008fd
[    8.833553] ... APIC ICR2: 02000000
[    8.833553] ... APIC LVTT: 000000ef
[    8.833553] ... APIC LVTPC: 00010000
[    8.833553] ... APIC LVT0: 00010700
[    8.833553] ... APIC LVT1: 00000400
[    8.833553] ... APIC LVTERR: 000000fe
[    8.833553] ... APIC TMICT: 000254c5
[    8.833553] ... APIC TMCCT: 00000000
[    8.833553] ... APIC TDCR: 00000003
[    8.833553] 
[    8.866904] number of MP IRQ sources: 15.
[    8.868194] number of IO-APIC #2 registers: 24.
[    8.869488] testing the IO APIC.......................
[    8.870969] IO APIC #2......
[    8.871860] .... register #00: 00000000
[    8.873140] .......    : physical APIC id: 00
[    8.874406] .......    : Delivery Type: 0
[    8.875622] .......    : LTS          : 0
[    8.876922] .... register #01: 00170011
[    8.878139] .......     : max redirection entries: 17
[    8.879553] .......     : PRQ implemented: 0
[    8.880890] .......     : IO APIC version: 11
[    8.882223] .... register #02: 00000000
[    8.883400] .......     : arbitration: 00
[    8.884684] .... IRQ redirection table:
[    8.885758]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    8.887329]  00 00  1    0    0   0   0    0    0    00
[    8.889042]  01 03  0    0    0   0   0    1    1    31
[    8.890687]  02 03  0    0    0   0   0    1    1    30
[    8.892422]  03 03  0    0    0   0   0    1    1    33
[    8.894061]  04 03  1    0    0   0   0    1    1    34
[    8.895688]  05 03  1    1    0   0   0    1    1    35
[    8.897368]  06 03  0    0    0   0   0    1    1    36
[    8.898964]  07 03  0    0    0   0   0    1    1    37
[    8.900664]  08 03  0    0    0   0   0    1    1    38
[    8.902297]  09 03  0    1    0   0   0    1    1    39
[    8.903901]  0a 03  1    1    0   0   0    1    1    3A
[    8.905622]  0b 03  1    1    0   0   0    1    1    3B
[    8.907275]  0c 03  0    0    0   0   0    1    1    3C
[    8.908958]  0d 03  0    0    0   0   0    1    1    3D
[    8.910614]  0e 03  0    0    0   0   0    1    1    3E
[    8.912339]  0f 03  0    0    0   0   0    1    1    3F
[    8.913937]  10 00  1    0    0   0   0    0    0    00
[    8.915583]  11 00  1    0    0   0   0    0    0    00
[    8.917303]  12 00  1    0    0   0   0    0    0    00
[    8.918841]  13 00  1    0    0   0   0    0    0    00
[    8.920535]  14 00  1    0    0   0   0    0    0    00
[    8.922211]  15 00  1    0    0   0   0    0    0    00
[    8.923806]  16 00  1    0    0   0   0    0    0    00
[    8.925488]  17 00  1    0    0   0   0    0    0    00
[    8.927096] IRQ to pin mappings:
[    8.928237] IRQ0 -> 0:2
[    8.929394] IRQ1 -> 0:1
[    8.930547] IRQ3 -> 0:3
[    8.931680] IRQ4 -> 0:4
[    8.932879] IRQ5 -> 0:5
[    8.934006] IRQ6 -> 0:6
[    8.935045] IRQ7 -> 0:7
[    8.936150] IRQ8 -> 0:8
[    8.937278] IRQ9 -> 0:9
[    8.938420] IRQ10 -> 0:10
[    8.939596] IRQ11 -> 0:11
[    8.940841] IRQ12 -> 0:12
[    8.942024] IRQ13 -> 0:13
[    8.943226] IRQ14 -> 0:14
[    8.944470] IRQ15 -> 0:15
[    8.945629] .................................... done.
[    8.947136] Using IPI No-Shortcut mode
[    8.948663] registered taskstats version 1
[    8.958246] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    8.959864] Key type trusted registered
[    8.961443] Key type encrypted registered
[    8.963763] IMA: No TPM chip found, activating TPM-bypass!
[    8.969163] ### of_selftest(): No testcase data in device tree; not running tests
[    8.971662] Freeing unused kernel memory: 556k freed
[    8.973511] Write protecting the kernel text: 6824k
[    8.974955] Write protecting the kernel read-only data: 3212k
[    9.043042] BUG: unable to handle kernel paging request at 6b6b6be3
[    9.044021] IP: [<c16a504a>] mutex_unlock+0x3/0x16
[    9.044021] *pde = 00000000 
[    9.044021] Oops: 0002 [#1] SMP 
[    9.044021] Pid: 1, comm: init Not tainted 3.7.0-rc1-bisect-next-20121016 #24 Bochs Bochs
[    9.044021] EIP: 0060:[<c16a504a>] EFLAGS: 00010212 CPU: 0
[    9.044021] EIP is at mutex_unlock+0x3/0x16
[    9.044021] EAX: 6b6b6bd3 EBX: cd412d10 ECX: cd89b998 EDX: 0000a068
[    9.044021] ESI: 00000000 EDI: cf8f3100 EBP: cd84fe04 ESP: cd84fe04
[    9.044021]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    9.044021] CR0: 80050033 CR2: 6b6b6be3 CR3: 0f882000 CR4: 00000690
[    9.044021] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    9.044021] DR6: ffff0ff0 DR7: 00000400
[    9.044021] Process init (pid: 1, ti=cd84e000 task=cd850000 task.ti=cd84e000)
[    9.044021] Stack:
[    9.044021]  cd84fe4c c10c2fbb 0000a068 cd84fecc cd84fe24 c11c40ff 00000000 00000000
[    9.044021]  507d7909 0244c7b0 507d7909 0244c7b0 507d7909 0244c7b0 cf8f3100 cd89b9a4
[    9.044021]  cd412d10 cf8f3100 cd84fe68 c10caf7f 00008060 cf8f3100 cd84ff00 00000000
[    9.044021] Call Trace:
[    9.044021]  [<c10c2fbb>] do_truncate+0x6d/0x77
[    9.044021]  [<c11c40ff>] ? ima_get_action+0x1f/0x24
[    9.044021]  [<c10caf7f>] handle_truncate+0x73/0x84
[    9.044021]  [<c10cd970>] do_last.isra.27+0x445/0x502
[    9.044021]  [<c10cdac0>] path_openat.isra.28+0x93/0x340
[    9.044021]  [<c1683f90>] ? __slab_alloc.constprop.66+0x258/0x27d
[    9.044021]  [<c10cdd8e>] do_filp_open+0x21/0x5d
[    9.044021]  [<c10d77df>] ? __alloc_fd+0x36/0xdc
[    9.044021]  [<c10c3cd5>] do_sys_open+0xfa/0x173
[    9.044021]  [<c10c3d6f>] sys_open+0x21/0x29
[    9.044021]  [<c16a728a>] sysenter_do_call+0x12/0x2c
[    9.044021] Code: b8 13 91 8c c1 ba 55 00 00 00 e8 aa 98 9c ff 89 d8 f0 ff 08 79 05 e8 ce 00 00 00 64 a1 88 17 af c1 89 43 10 59 5b 5d c3 55 89 e5 <c7> 40 10 00 00 00 00 f0 ff 00 7f 05 e8 02 00 00 00 5d c3 55 89
[    9.044021] EIP: [<c16a504a>] mutex_unlock+0x3/0x16 SS:ESP 0068:cd84fe04
[    9.044021] CR2: 000000006b6b6be3
[    9.120800] ---[ end trace bbdf2c495901f8f4 ]---
[    9.122577] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    9.122577] 

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.7.0-rc1 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
# CONFIG_TICK_CPU_ACCOUNTING is not set
CONFIG_IRQ_TIME_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EXPERT is not set
CONFIG_HAVE_UID16=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_GENERIC_KERNEL_THREAD=y
CONFIG_GENERIC_KERNEL_EXECVE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=y
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_HIBERNATION is not set
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
# CONFIG_PM_WAKELOCKS_GC is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_EC_DEBUGFS=y
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_EINJ=y
CONFIG_ACPI_APEI_ERST_DEBUG=y
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
CONFIG_APM_DO_ENABLE=y
# CONFIG_APM_CPU_IDLE is not set
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ_CPB=y
# CONFIG_X86_POWERNOW_K6 is not set
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_LONGRUN=y
# CONFIG_X86_LONGHAUL is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_INTEL_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
# CONFIG_PCIEASPM_DEFAULT is not set
CONFIG_PCIEASPM_POWERSAVE=y
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=y
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
# CONFIG_EISA_VLB_PRIMING is not set
# CONFIG_EISA_PCI_EISA is not set
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO1_PM is not set
CONFIG_OLPC_XO15_SCI=y
CONFIG_ALIX=y
CONFIG_NET5501=y
# CONFIG_GEOS is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=y
# CONFIG_HOTPLUG_PCI_ACPI is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_TSI721=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
# CONFIG_XFRM_USER is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
CONFIG_NET_IPVTI=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=y
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_IPV6_SIT is not set
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_LLC=y
CONFIG_LLC2=y
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
CONFIG_PHONET=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
# CONFIG_NET_SCH_NETEM is not set
# CONFIG_NET_SCH_DRR is not set
CONFIG_NET_SCH_MQPRIO=y
CONFIG_NET_SCH_CHOKE=y
# CONFIG_NET_SCH_QFQ is not set
CONFIG_NET_SCH_CODEL=y
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=y
CONFIG_BATMAN_ADV_BLA=y
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_OPENVSWITCH=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_BQL=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
# CONFIG_NETROM is not set
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
# CONFIG_SCC is not set
CONFIG_BAYCOM_SER_FDX=y
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
CONFIG_CAIF_USB=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
# CONFIG_PROC_DEVICETREE is not set
CONFIG_OF_SELFTEST=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
CONFIG_AD525X_DPOT=y
# CONFIG_AD525X_DPOT_I2C is not set
CONFIG_AD525X_DPOT_SPI=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_INTEL_MID_PTI=y
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
CONFIG_HP_ILO=y
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
# CONFIG_TI_DAC7512 is not set
CONFIG_VMWARE_BALLOON=y
CONFIG_BMP085=y
CONFIG_BMP085_I2C=y
CONFIG_BMP085_SPI=y
# CONFIG_PCH_PHUB is not set
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
CONFIG_IDE_LEGACY=y
CONFIG_BLK_DEV_IDE_SATA=y
CONFIG_IDE_GD=y
# CONFIG_IDE_GD_ATA is not set
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECS=y
# CONFIG_BLK_DEV_DELKIN is not set
# CONFIG_BLK_DEV_IDECD is not set
CONFIG_BLK_DEV_IDETAPE=y
# CONFIG_BLK_DEV_IDEACPI is not set
CONFIG_IDE_TASK_IOCTL=y
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
# CONFIG_IDE_GENERIC is not set
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPNP=y
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=y
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
CONFIG_BLK_DEV_CMD64X=y
CONFIG_BLK_DEV_TRIFLEX=y
CONFIG_BLK_DEV_CS5530=y
CONFIG_BLK_DEV_CS5535=y
# CONFIG_BLK_DEV_CS5536 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
CONFIG_BLK_DEV_SC1200=y
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
CONFIG_BLK_DEV_NS87415=y
CONFIG_BLK_DEV_PDC202XX_OLD=y
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=y
# CONFIG_BLK_DEV_VIA82CXXX is not set
CONFIG_BLK_DEV_TC86C001=y

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
CONFIG_BLK_DEV_4DRIVES=y
CONFIG_BLK_DEV_ALI14XX=y
# CONFIG_BLK_DEV_DTC2278 is not set
CONFIG_BLK_DEV_HT6560B=y
CONFIG_BLK_DEV_QD65XX=y
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
# CONFIG_ATA_SFF is not set

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
# CONFIG_ATA_BMDMA is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_ISAPNP is not set
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
# CONFIG_PATA_PCMCIA is not set
CONFIG_PATA_QDI=y
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
# CONFIG_FIREWIRE_OHCI is not set
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
# CONFIG_NETDEVICES is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
# CONFIG_ISDN_DRV_GIGASET is not set
# CONFIG_MISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MATRIXKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ADP5589=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
CONFIG_KEYBOARD_LKKBD=y
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
CONFIG_KEYBOARD_TCA6416=y
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_MPR121=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_OMAP4=y
# CONFIG_KEYBOARD_TC3589X is not set
CONFIG_KEYBOARD_TWL4030=y
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_PS2_OLPC is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_INPORT is not set
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
CONFIG_TABLET_USB_AIPTEK=y
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
CONFIG_N_GSM=y
CONFIG_TRACE_ROUTER=y
CONFIG_TRACE_SINK=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
# CONFIG_SERIAL_MAX310X is not set
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_OF_PLATFORM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
# CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE is not set
CONFIG_SERIAL_ALTERA_UART=y
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
CONFIG_SERIAL_IFX6X60=y
CONFIG_SERIAL_PCH_UART=y
# CONFIG_SERIAL_PCH_UART_CONSOLE is not set
CONFIG_SERIAL_XILINX_PS_UART=y
CONFIG_SERIAL_XILINX_PS_UART_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_TPM is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_INFINEON=y
CONFIG_TCG_NSC=y
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=y
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_SIS5595 is not set
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_DESIGNWARE=y
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_TLE62X0=y
# CONFIG_HSI is not set

#
# PPS support
#

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=y
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TPS65912=y
# CONFIG_GPIO_TWL4030 is not set
CONFIG_GPIO_TWL6040=y
CONFIG_GPIO_WM8994=y
CONFIG_GPIO_ADP5588=y
# CONFIG_GPIO_ADP5588_IRQ is not set
# CONFIG_GPIO_ADNP is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_LANGWELL is not set
CONFIG_GPIO_PCH=y
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_SODAVILLE is not set
CONFIG_GPIO_TIMBERDALE=y
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y
CONFIG_GPIO_74X164=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
CONFIG_GPIO_TPS65910=y
CONFIG_W1=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
# CONFIG_W1_MASTER_DS2490 is not set
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
# CONFIG_W1_SLAVE_DS2408 is not set
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
# CONFIG_W1_SLAVE_DS2433 is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
# CONFIG_W1_SLAVE_DS2781 is not set
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_GENERIC_ADC_BATTERY=y
# CONFIG_MAX8925_POWER is not set
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
CONFIG_BATTERY_DS2780=y
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
CONFIG_CHARGER_ISP1704=y
CONFIG_CHARGER_MAX8903=y
CONFIG_CHARGER_TWL4030=y
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_SMB347=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7410=y
# CONFIG_SENSORS_ADT7411 is not set
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
CONFIG_SENSORS_FAM15H_POWER=y
CONFIG_SENSORS_ASB100=y
CONFIG_SENSORS_ATXP1=y
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
CONFIG_SENSORS_DA9052_ADC=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM73 is not set
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX1111=y
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MCP3021=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=y
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SHT21 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_ADS7871=y
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
# CONFIG_SSB_PCMCIAHOST is not set
CONFIG_SSB_SDIOHOST_POSSIBLE=y
# CONFIG_SSB_SDIOHOST is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DEBUG=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
CONFIG_MFD_LM3533=y
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
CONFIG_TPS6507X=y
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_I2C=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_TWL4030_CORE=y
# CONFIG_TWL4030_MADC is not set
# CONFIG_MFD_TWL4030_AUDIO is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_STMPE is not set
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
# CONFIG_MFD_DA9052_SPI is not set
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
CONFIG_MFD_MAX8925=y
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
CONFIG_MFD_ARIZONA_SPI=y
CONFIG_MFD_WM5102=y
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
# CONFIG_AB3100_OTP is not set
CONFIG_EZX_PCAP=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=y
CONFIG_LPC_ICH=y
# CONFIG_MFD_RDC321X is not set
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_RC5T583=y
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_PALMAS=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
CONFIG_MEDIA_RADIO_SUPPORT=y
CONFIG_MEDIA_RC_SUPPORT=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=y
CONFIG_VIDEOBUF_GEN=y
CONFIG_VIDEOBUF_VMALLOC=y

#
# Media drivers
#
CONFIG_RC_CORE=y
# CONFIG_RC_MAP is not set
# CONFIG_RC_DECODERS is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=y
# CONFIG_IR_ENE is not set
CONFIG_IR_IMON=y
# CONFIG_IR_MCEUSB is not set
# CONFIG_IR_ITE_CIR is not set
CONFIG_IR_FINTEK=y
CONFIG_IR_NUVOTON=y
CONFIG_IR_REDRAT3=y
CONFIG_IR_STREAMZAP=y
CONFIG_IR_WINBOND_CIR=y
CONFIG_IR_IGUANA=y
# CONFIG_IR_TTUSBIR is not set
CONFIG_RC_LOOPBACK=y
# CONFIG_IR_GPIO_CIR is not set
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=y
CONFIG_USB_M5602=y
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GL860 is not set
CONFIG_USB_GSPCA_BENQ=y
CONFIG_USB_GSPCA_CONEX=y
CONFIG_USB_GSPCA_CPIA1=y
# CONFIG_USB_GSPCA_ETOMS is not set
CONFIG_USB_GSPCA_FINEPIX=y
CONFIG_USB_GSPCA_JEILINJ=y
CONFIG_USB_GSPCA_JL2005BCD=y
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=y
CONFIG_USB_GSPCA_MARS=y
# CONFIG_USB_GSPCA_MR97310A is not set
CONFIG_USB_GSPCA_NW80X=y
CONFIG_USB_GSPCA_OV519=y
CONFIG_USB_GSPCA_OV534=y
# CONFIG_USB_GSPCA_OV534_9 is not set
CONFIG_USB_GSPCA_PAC207=y
# CONFIG_USB_GSPCA_PAC7302 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SE401 is not set
CONFIG_USB_GSPCA_SN9C2028=y
CONFIG_USB_GSPCA_SN9C20X=y
CONFIG_USB_GSPCA_SONIXB=y
CONFIG_USB_GSPCA_SONIXJ=y
# CONFIG_USB_GSPCA_SPCA500 is not set
CONFIG_USB_GSPCA_SPCA501=y
CONFIG_USB_GSPCA_SPCA505=y
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
CONFIG_USB_GSPCA_SPCA1528=y
CONFIG_USB_GSPCA_SQ905=y
# CONFIG_USB_GSPCA_SQ905C is not set
CONFIG_USB_GSPCA_SQ930X=y
CONFIG_USB_GSPCA_STK014=y
# CONFIG_USB_GSPCA_STV0680 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TOPRO is not set
CONFIG_USB_GSPCA_TV8532=y
CONFIG_USB_GSPCA_VC032X=y
# CONFIG_USB_GSPCA_VICAM is not set
CONFIG_USB_GSPCA_XIRLINK_CIT=y
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_USB_PWC is not set
CONFIG_VIDEO_CPIA2=y
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
# CONFIG_USB_SN9C102 is not set

#
# Analog TV USB devices
#
# CONFIG_VIDEO_PVRUSB2 is not set
CONFIG_VIDEO_HDPVR=y
CONFIG_VIDEO_USBVISION=y
# CONFIG_VIDEO_STK1160 is not set

#
# Analog/digital TV USB devices
#
# CONFIG_VIDEO_CX231XX is not set
CONFIG_VIDEO_TM6000=y

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=y
CONFIG_VIDEO_EM28XX_RC=y
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
CONFIG_VIDEO_MEYE=y

#
# Media capture/analog TV support
#
# CONFIG_VIDEO_IVTV is not set
CONFIG_VIDEO_ZORAN=y
CONFIG_VIDEO_ZORAN_DC30=y
CONFIG_VIDEO_ZORAN_ZR36060=y
CONFIG_VIDEO_ZORAN_BUZ=y
CONFIG_VIDEO_ZORAN_DC10=y
CONFIG_VIDEO_ZORAN_LML33=y
CONFIG_VIDEO_ZORAN_LML33R10=y
CONFIG_VIDEO_ZORAN_AVS6EYES=y
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set

#
# Media capture/analog/hybrid TV support
#
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
CONFIG_V4L_TEST_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_PARPORT_SUPPORT=y
# CONFIG_VIDEO_PMS is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=y
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_SHARK2 is not set
CONFIG_I2C_SI4713=y
# CONFIG_RADIO_SI4713 is not set
CONFIG_USB_KEENE=y
# CONFIG_RADIO_TEA5764 is not set
CONFIG_RADIO_SAA7706H=y
CONFIG_RADIO_TEF6862=y
CONFIG_RADIO_TIMBERDALE=y
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# CONFIG_RADIO_WL128X is not set
CONFIG_V4L_RADIO_ISA_DRIVERS=y
CONFIG_RADIO_ISA=y
CONFIG_RADIO_CADET=y
CONFIG_RADIO_RTRACK=y
CONFIG_RADIO_RTRACK_PORT=30f
# CONFIG_RADIO_RTRACK2 is not set
# CONFIG_RADIO_AZTECH is not set
# CONFIG_RADIO_GEMTEK is not set
CONFIG_RADIO_SF16FMI=y
# CONFIG_RADIO_TERRATEC is not set
# CONFIG_RADIO_TRUST is not set
# CONFIG_RADIO_TYPHOON is not set
# CONFIG_RADIO_ZOLTRIX is not set
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
CONFIG_VIDEO_TVEEPROM=y
CONFIG_VIDEO_IR_I2C=y

#
# Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
# CONFIG_VIDEO_TVAUDIO is not set
CONFIG_VIDEO_TDA7432=y
CONFIG_VIDEO_TDA9840=y
# CONFIG_VIDEO_TEA6415C is not set
CONFIG_VIDEO_TEA6420=y
CONFIG_VIDEO_MSP3400=y
# CONFIG_VIDEO_CS5345 is not set
# CONFIG_VIDEO_CS53L32A is not set
CONFIG_VIDEO_TLV320AIC23B=y
# CONFIG_VIDEO_WM8775 is not set
CONFIG_VIDEO_WM8739=y
# CONFIG_VIDEO_VP27SMPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=y

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=y
CONFIG_VIDEO_ADV7183=y
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
CONFIG_VIDEO_SAA7110=y
CONFIG_VIDEO_SAA711X=y
# CONFIG_VIDEO_SAA7191 is not set
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
CONFIG_VIDEO_TVP7002=y
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
# CONFIG_VIDEO_SAA717X is not set
CONFIG_VIDEO_CX25840=y

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=y

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=y
CONFIG_VIDEO_SAA7185=y
CONFIG_VIDEO_ADV7170=y
# CONFIG_VIDEO_ADV7175 is not set
CONFIG_VIDEO_ADV7343=y
CONFIG_VIDEO_ADV7393=y
CONFIG_VIDEO_AK881X=y

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9V011 is not set
CONFIG_VIDEO_TCM825X=y
CONFIG_VIDEO_SR030PC30=y

#
# Flash devices
#

#
# Video improvement chips
#
# CONFIG_VIDEO_UPD64031A is not set
# CONFIG_VIDEO_UPD64083 is not set

#
# Miscelaneous helper chips
#
CONFIG_VIDEO_THS7303=y
# CONFIG_VIDEO_M52790 is not set

#
# Sensors used on soc_camera driver
#
CONFIG_MEDIA_TUNER=y

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA827X=y
CONFIG_MEDIA_TUNER_TDA18271=y
# CONFIG_MEDIA_TUNER_TDA9887 is not set
CONFIG_MEDIA_TUNER_TEA5761=y
# CONFIG_MEDIA_TUNER_TEA5767 is not set
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=y
CONFIG_MEDIA_TUNER_MT2063=y
CONFIG_MEDIA_TUNER_MT2266=y
CONFIG_MEDIA_TUNER_MT2131=y
# CONFIG_MEDIA_TUNER_QT1010 is not set
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_XC4000=y
# CONFIG_MEDIA_TUNER_MXL5005S is not set
# CONFIG_MEDIA_TUNER_MXL5007T is not set
# CONFIG_MEDIA_TUNER_MC44S803 is not set
# CONFIG_MEDIA_TUNER_MAX2165 is not set
CONFIG_MEDIA_TUNER_TDA18218=y
CONFIG_MEDIA_TUNER_FC0011=y
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=y
CONFIG_MEDIA_TUNER_TDA18212=y
# CONFIG_MEDIA_TUNER_E4000 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set

#
# Customise DVB Frontends
#
CONFIG_DVB_AU8522=y
CONFIG_DVB_AU8522_V4L=y
CONFIG_DVB_TUNER_DIB0070=y
# CONFIG_DVB_TUNER_DIB0090 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_EXYNOS_VIDEO=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_TDO24M=y
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
# CONFIG_LCD_S6E63M0 is not set
# CONFIG_LCD_LD9040 is not set
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_LM3533=y
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=y
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_88PM860X=y
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630=y
# CONFIG_BACKLIGHT_LM3639 is not set
# CONFIG_BACKLIGHT_LP855X is not set
CONFIG_BACKLIGHT_PANDORA=y
CONFIG_BACKLIGHT_TPS65217=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
# CONFIG_HIDRAW is not set
CONFIG_UHID=y
# CONFIG_HID_GENERIC is not set

#
# Special HID drivers
#
# CONFIG_HID_HYPERV_MOUSE is not set

#
# USB HID support
#
# CONFIG_USB_HID is not set
# CONFIG_HID_PID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
CONFIG_USB_OXU210HP_HCD=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=y
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_EHCI_HCD_PLATFORM=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=y
# CONFIG_USB_SL811_HCD is not set
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HCD_BCMA=y
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_CHIPIDEA=y
# CONFIG_USB_CHIPIDEA_HOST is not set
# CONFIG_USB_CHIPIDEA_DEBUG is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
CONFIG_USB_UAS=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=y
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
CONFIG_USB_SERIAL_CH341=y
CONFIG_USB_SERIAL_WHITEHEAT=y
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=y
CONFIG_USB_SERIAL_VISOR=y
CONFIG_USB_SERIAL_IPAQ=y
CONFIG_USB_SERIAL_IR=y
CONFIG_USB_SERIAL_EDGEPORT=y
CONFIG_USB_SERIAL_EDGEPORT_TI=y
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=y
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
CONFIG_USB_SERIAL_KLSI=y
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
CONFIG_USB_SERIAL_NAVMAN=y
# CONFIG_USB_SERIAL_PL2303 is not set
CONFIG_USB_SERIAL_OTI6858=y
CONFIG_USB_SERIAL_QCAUX=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
CONFIG_USB_SERIAL_SAFE=y
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=y
CONFIG_USB_SERIAL_CYBERJACK=y
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_ZTE=y
CONFIG_USB_SERIAL_SSU100=y
CONFIG_USB_SERIAL_QT2=y
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=y
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_LED=y
CONFIG_USB_CYPRESS_CY7C63=y
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
CONFIG_USB_TRANCEVIBRATOR=y
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
CONFIG_USB_YUREX=y
CONFIG_USB_EZUSB_FX2=y

#
# USB Physical Layer drivers
#
CONFIG_OMAP_USB2=y
CONFIG_USB_ISP1301=y
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TWL6030_USB is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_MMC=y
CONFIG_MMC_DEBUG=y
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
# CONFIG_MMC_BLOCK is not set
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MMC_VUB300=y
# CONFIG_MMC_USHC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
# CONFIG_MSPRO_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
CONFIG_LEDS_LM3530=y
# CONFIG_LEDS_LM3533 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_NET48XX is not set
# CONFIG_LEDS_WRAP is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
CONFIG_LEDS_PCA9633=y
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
# CONFIG_LEDS_OT200 is not set
CONFIG_LEDS_BLINKM=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_CPU=y
CONFIG_LEDS_TRIGGER_GPIO=y
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# Virtio drivers
#

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
CONFIG_USBIP_CORE=y
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
CONFIG_ECHO=y
# CONFIG_ASUS_OLED is not set
CONFIG_RTS_PSTOR=y
CONFIG_RTS_PSTOR_DEBUG=y
CONFIG_RTS5139=y
CONFIG_RTS5139_DEBUG=y
CONFIG_TRANZPORT=y
# CONFIG_USB_SERIAL_QUATECH2 is not set
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
# CONFIG_IIO_ST_HWMON is not set
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#
CONFIG_ADIS16201=y
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=y
CONFIG_ADIS16209=y
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=y
# CONFIG_KXSD9 is not set
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=y

#
# Analog to digital converters
#
CONFIG_AD7291=y
CONFIG_AD7298=y
CONFIG_AD7606=y
CONFIG_AD7606_IFACE_PARALLEL=y
CONFIG_AD7606_IFACE_SPI=y
CONFIG_AD799X=y
CONFIG_AD799X_RING_BUFFER=y
# CONFIG_AD7887 is not set
# CONFIG_AD7780 is not set
CONFIG_AD7793=y
CONFIG_AD7816=y
# CONFIG_AD7192 is not set
CONFIG_ADT7310=y
CONFIG_ADT7410=y
CONFIG_AD7280=y
CONFIG_MAX1363=y
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#
CONFIG_AD5930=y
CONFIG_AD9832=y
# CONFIG_AD9834 is not set
# CONFIG_AD9850 is not set
# CONFIG_AD9852 is not set
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=y
CONFIG_ADIS16080=y
CONFIG_ADIS16130=y
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set

#
# Network Analyzer, Impedance Converters
#
CONFIG_AD5933=y

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
# CONFIG_SENSORS_TSL2563 is not set
CONFIG_TSL2583=y
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
# CONFIG_SENSORS_AK8975 is not set
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
# CONFIG_ADE7753 is not set
CONFIG_ADE7754=y
CONFIG_ADE7758=y
# CONFIG_ADE7759 is not set
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y
# CONFIG_ADE7854_SPI is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=y
# CONFIG_AD2S1200 is not set
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_GPIO_TRIGGER=y
# CONFIG_IIO_SYSFS_TRIGGER is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
# CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
# CONFIG_ZRAM is not set
CONFIG_ZCACHE=y
CONFIG_ZSMALLOC=y
CONFIG_CRYSTALHD=y
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_BCM_WIMAX is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
CONFIG_SPEAKUP=y
# CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
CONFIG_SPEAKUP_SYNTH_ACNTPC=y
# CONFIG_SPEAKUP_SYNTH_APOLLO is not set
# CONFIG_SPEAKUP_SYNTH_AUDPTR is not set
# CONFIG_SPEAKUP_SYNTH_BNS is not set
# CONFIG_SPEAKUP_SYNTH_DECTLK is not set
# CONFIG_SPEAKUP_SYNTH_DECEXT is not set
CONFIG_SPEAKUP_SYNTH_DTLK=y
# CONFIG_SPEAKUP_SYNTH_KEYPC is not set
CONFIG_SPEAKUP_SYNTH_LTLK=y
# CONFIG_SPEAKUP_SYNTH_SOFT is not set
# CONFIG_SPEAKUP_SYNTH_SPKOUT is not set
CONFIG_SPEAKUP_SYNTH_TXPRT=y
CONFIG_SPEAKUP_SYNTH_DUMMY=y
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
CONFIG_USB_WPAN_HCD=y
# CONFIG_IPACK_BUS is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_NET_VENDOR_SILICOM is not set
CONFIG_CED1401=y
CONFIG_DGRP=y
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=y
CONFIG_FUJITSU_LAPTOP_DEBUG=y
CONFIG_FUJITSU_TABLET=y
CONFIG_AMILO_RFKILL=y
# CONFIG_HP_ACCEL is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
# CONFIG_IDEAPAD_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_SENSORS_HDAPS=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=y
# CONFIG_ACPI_WMI is not set
CONFIG_TOPSTAR_LAPTOP=y
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO1_RFKILL=y
# CONFIG_XO15_EBOOK is not set
CONFIG_SAMSUNG_LAPTOP=y
CONFIG_INTEL_OAKTRAIL=y
# CONFIG_SAMSUNG_Q10 is not set
CONFIG_APPLE_GMUX=y

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
CONFIG_DEVFREQ_GOV_PERFORMANCE=y
CONFIG_DEVFREQ_GOV_POWERSAVE=y
CONFIG_DEVFREQ_GOV_USERSPACE=y

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=y
# CONFIG_AD7266 is not set
# CONFIG_AD7791 is not set
CONFIG_AD7476=y

#
# Amplifiers
#
CONFIG_AD8366=y

#
# Light sensors
#
CONFIG_ADJD_S311=y
CONFIG_SENSORS_LM3533=y
# CONFIG_VCNL4000 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=y

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
CONFIG_ADF4350=y

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
CONFIG_AD5624R_SPI=y
# CONFIG_AD5446 is not set
CONFIG_AD5504=y
# CONFIG_AD5755 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
CONFIG_MCP4725=y

#
# Hid Sensor IIO Common
#

#
# Digital gyroscope sensors
#

#
# Light sensors
#

#
# Magnetometer sensors
#
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
# CONFIG_EXT3_FS_POSIX_ACL is not set
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
# CONFIG_REISERFS_FS_XATTR is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
CONFIG_XFS_RT=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QFMT_V1=y
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_HFSPLUS_FS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_RAM is not set
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_DEBUG is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
# CONFIG_NLS_UTF8 is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
# CONFIG_MAGIC_SYSRQ is not set
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
CONFIG_SLUB_DEBUG_ON=y
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
CONFIG_SECURITY_YAMA=y
CONFIG_SECURITY_YAMA_STACKED=y
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_APPRAISE=y
CONFIG_EVM=y
CONFIG_DEFAULT_SECURITY_YAMA=y
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="yama"
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_GHASH is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=y
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=y
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
CONFIG_CRC7=y
# CONFIG_LIBCRC32C is not set
CONFIG_CRC8=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_XZ_DEC_TEST=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
# CONFIG_DRM_TTM is not set
# CONFIG_ISDN_DRV_LOOP is not set

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm_bisect-inn-9509-2012-10-16-22-52-22-3.7.0-rc1-bisect-next-20121016-24"

[    0.000000] Linux version 3.7.0-rc1-bisect-next-20121016 (wfg@bee) (gcc version 4.6.3 (Debian 4.6.3-1) ) #24 SMP Tue Oct 16 22:20:10 CST 2012
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x100000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at [c00fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x01ffffff]
[    0.000000] Base memory trampoline at [c008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x01ffa000-0x01ffffff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128476(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:1af5d41, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat c1a4b7c0, node_mem_map cdd3f200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3939 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 60958 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 10 pages/cpu @cdd2b000 s25792 r0 d15168 u40960
[    0.000000] pcpu-alloc: s25792 r0 d15168 u40960 alloc=10*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 
[    0.000000] kvm-clock: cpu 0, msr 0:dd30d41, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr dd2d6c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64897
[    0.000000] Kernel command line: rcutree.rcu_cpu_stall_timeout=100 hung_task_panic=1 bisect-reboot i386-randconfig-i070 branch=internal-yuanhan/pm-sleep-fixes log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 214104k/262136k available (6821k kernel code, 47532k reserved, 3847k data, 556k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fe000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffe000   ( 255 MB)
[    0.000000]       .init : 0xc1a6c000 - 0xc1af7000   ( 556 kB)
[    0.000000]       .data : 0xc16a9660 - 0xc1a6b2c0   (3847 kB)
[    0.000000]       .text : 0xc1000000 - 0xc16a9660   (6821 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=2.
[    0.000000] NR_IRQS:2304 nr_irqs:56 16
[    0.000000] CPU 0 irqstacks, hard=cd808000 soft=cd80a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.456 MHz processor
[    0.012000] Calibrating delay loop (skipped) preset value.. 5386.91 BogoMIPS (lpj=10773824)
[    0.012000] pid_max: default: 32768 minimum: 301
[    0.012157] Security Framework initialized
[    0.013424] Yama: becoming mindful.
[    0.016082] Mount-cache hash table entries: 512
[    0.018026] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.018026] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.018026] tlb_flushall_shift: 6
[    0.020283] Freeing SMP alternatives: 24k freed
[    0.027369] ACPI: Core revision 20120913
[    0.038457] Getting VERSION: 50014
[    0.039564] Getting VERSION: 50014
[    0.040017] Getting ID: 0
[    0.040881] Getting ID: f000000
[    0.041863] Getting LVT0: 8700
[    0.044012] Getting LVT1: 8400
[    0.045001] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.046507] enabled ExtINT on CPU#0
[    0.049162] ENABLING IO-APIC IRQs
[    0.050186] init IO_APIC IRQs
[    0.051101]  apic 2 pin 0 not connected
[    0.052019] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.054244] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.056033] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.058216] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.060032] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.062140] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.064029] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.066160] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.068030] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.072025] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.074159] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.076028] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.078164] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.080028] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.082223] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.084029]  apic 2 pin 16 not connected
[    0.085257]  apic 2 pin 17 not connected
[    0.088005]  apic 2 pin 18 not connected
[    0.089150]  apic 2 pin 19 not connected
[    0.090264]  apic 2 pin 20 not connected
[    0.091491]  apic 2 pin 21 not connected
[    0.092006]  apic 2 pin 22 not connected
[    0.093128]  apic 2 pin 23 not connected
[    0.094392] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.096006] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.098708] Using local APIC timer interrupts.
[    0.098708] calibrating APIC timer ...
[    0.104000] ... lapic delta = 6251142
[    0.104000] ... PM-Timer delta = 358034
[    0.104000] ... PM-Timer result ok
[    0.104000] ..... delta 6251142
[    0.104000] ..... mult: 268484504
[    0.104000] ..... calibration result: 4000730
[    0.104000] ..... CPU clock speed is 2694.0566 MHz.
[    0.104000] ..... host bus clock speed is 1000.0730 MHz.
[    0.104077] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.110087] CPU 1 irqstacks, hard=cd88c000 soft=cd88e000
[    0.112006] smpboot: Booting Node   0, Processors  #1 OK
[    0.012000] Initializing CPU#1
[    0.012000] kvm-clock: cpu 1, msr 0:dd3ad41, secondary cpu clock
[    0.012000] masked ExtINT on CPU#1
[    0.136037] Brought up 2 CPUs
[    0.136004] KVM setup async PF for cpu 1
[    0.136004] kvm-stealtime: cpu 1, msr dd376c0
[    0.140005] smpboot: Total of 2 processors activated (10773.82 BogoMIPS)
[    0.142151] CPU0 attaching sched-domain:
[    0.144010]  domain 0: span 0-1 level CPU
[    0.145220]   groups: 0 (cpu_power = 1001) 1 (cpu_power = 1020)
[    0.147257] CPU1 attaching sched-domain:
[    0.148007]  domain 0: span 0-1 level CPU
[    0.149240]   groups: 1 (cpu_power = 1020) 0 (cpu_power = 1001)
[    0.153179] EVM: security.ima
[    0.154107] EVM: security.capability
[    0.156055] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.157916] NET: Registered protocol family 16
[    0.160323] EISA bus registered
[    0.161913] ACPI: bus type pci registered
[    0.163255] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=0
[    0.164007] PCI: Using configuration type 1 for base access
[    0.179627] bio: create slab <bio-0> at 0
[    0.180606] ACPI: Added _OSI(Module Device)
[    0.181847] ACPI: Added _OSI(Processor Device)
[    0.184015] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.185347] ACPI: Added _OSI(Processor Aggregator Device)
[    0.187670] ACPI: EC: Look up EC in DSDT
[    0.204890] ACPI: Interpreter enabled
[    0.206062] ACPI: (supports S0 S3 S5)
[    0.207605] ACPI: Using IOAPIC for interrupt routing
[    0.224462] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.227181] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.228062] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.230278] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.232009] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.234263] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff] (ignored)
[    0.236018] PCI: root bus 00: using default resources
[    0.237341] pci_root PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.240146] PCI host bridge to bus 0000:00
[    0.241324] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.244011] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.245686] pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffff]
[    0.248068] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.250051] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.252284] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.256009] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.258564] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.260456] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
[    0.262499] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
[    0.264228] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.268589] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.271590] pci 0000:00:02.0: reg 14: [mem 0xfebf0000-0xfebf0fff]
[    0.278632] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.280224] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.282616] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.284836] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.290848] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.292159] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.294957] pci 0000:00:04.0: reg 10: [io  0xc040-0xc07f]
[    0.296858] pci 0000:00:04.0: reg 14: [mem 0xfebf1000-0xfebf1fff]
[    0.304114] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.306643] pci 0000:00:05.0: reg 10: [io  0xc080-0xc0bf]
[    0.308870] pci 0000:00:05.0: reg 14: [mem 0xfebf2000-0xfebf2fff]
[    0.314776] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.316919] pci 0000:00:06.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.319180] pci 0000:00:06.0: reg 14: [mem 0xfebf3000-0xfebf3fff]
[    0.325519] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.328010] pci 0000:00:07.0: reg 10: [io  0xc100-0xc13f]
[    0.330331] pci 0000:00:07.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.336269] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.338742] pci 0000:00:08.0: reg 10: [io  0xc140-0xc17f]
[    0.340876] pci 0000:00:08.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.346788] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.348920] pci 0000:00:09.0: reg 10: [io  0xc180-0xc1bf]
[    0.351245] pci 0000:00:09.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.357474] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.359492] pci 0000:00:0a.0: reg 10: [mem 0xfebf7000-0xfebf700f]
[    0.364285] pci_bus 0000:00: on NUMA node 0
[    0.365506] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.371728]  pci0000:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.372007]  pci0000:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.411857] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.413372] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.416438] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.418845] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.421357] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.423586] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.424009] vgaarb: loaded
[    0.424906] vgaarb: bridge control possible 0000:00:02.0
[    0.428087] tps65010: version 2 May 2005
[    0.460072] tps65010: no chip?
[    0.462060] SCSI subsystem initialized
[    0.463181] libata version 3.00 loaded.
[    0.464082] ACPI: bus type usb registered
[    0.465230] usbcore: registered new interface driver usbfs
[    0.472046] usbcore: registered new interface driver hub
[    0.477034] usbcore: registered new device driver usb
[    0.478584] Linux video capture interface: v2.00
[    0.480281] PCI: Using ACPI for IRQ routing
[    0.481448] PCI: pci_cache_line_size set to 64 bytes
[    0.484252] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    0.485818] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.488704] Switching to clocksource kvm-clock
[    0.490181] FS-Cache: Loaded
[    0.491174] CacheFiles: Loaded
[    0.492000] pnp: PnP ACPI init
[    0.492000] ACPI: bus type pnp registered
[    0.492570] pnp 00:00: [bus 00-ff]
[    0.493539] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.494723] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.495946] pnp 00:00: [io  0x0d00-0xffff window]
[    0.497201] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.498627] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.500119] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.501845] pnp 00:01: [io  0x0070-0x0071]
[    0.503049] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:3)
[    0.505205] pnp 00:01: [irq 8]
[    0.506091] pnp 00:01: [io  0x0072-0x0077]
[    0.507237] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.509054] pnp 00:02: [io  0x0060]
[    0.510072] pnp 00:02: [io  0x0064]
[    0.511130] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:3)
[    0.513291] pnp 00:02: [irq 1]
[    0.514282] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.516129] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:3)
[    0.518306] pnp 00:03: [irq 12]
[    0.519341] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.521126] pnp 00:04: [io  0x03f2-0x03f5]
[    0.522276] pnp 00:04: [io  0x03f7]
[    0.523331] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:3)
[    0.525502] pnp 00:04: [irq 6]
[    0.526447] pnp 00:04: [dma 2]
[    0.527465] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.529455] pnp 00:05: [io  0x0378-0x037f]
[    0.530630] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:3)
[    0.532840] pnp 00:05: [irq 7]
[    0.533878] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.535802] pnp 00:06: [io  0x03f8-0x03ff]
[    0.537020] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:3)
[    0.539196] pnp 00:06: [irq 4]
[    0.540276] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.542670] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.544098] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.546606] pnp: PnP ACPI: found 8 devices
[    0.547782] ACPI: ACPI bus type pnp unregistered
[    0.588595] pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
[    0.590150] pci_bus 0000:00: resource 5 [mem 0x00000000-0xffffffff]
[    0.591757] NET: Registered protocol family 2
[    0.593359] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.595254] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.597003] TCP: Hash tables configured (established 8192 bind 8192)
[    0.598661] TCP: reno registered
[    0.599653] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    0.601163] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    0.602917] NET: Registered protocol family 1
[    0.604080] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.605660] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.607182] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.608829] pci 0000:00:02.0: Boot video device
[    0.610215] PCI: CLS 0 bytes, default 64
[    0.611593] Trying to unpack rootfs image as initramfs...
[    1.598097] Freeing initrd memory: 25284k freed
[    1.608428] kvm: no hardware support
[    1.610116] apm: BIOS not found.
[    1.612628] NatSemi SCx200 Driver
[    1.614554] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.624841] VFS: Disk quotas dquot_6.5.2
[    1.626172] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.629177] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.630598] QNX4 filesystem 0.2.3 registered.
[    1.631794] SGI XFS with security attributes, realtime, no debug enabled
[    1.636617] alg: No test for cipher_null (cipher_null-generic)
[    1.638323] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.639895] alg: No test for compress_null (compress_null-generic)
[    1.641736] alg: No test for digest_null (digest_null-generic)
[    1.645586] alg: No test for fcrypt (fcrypt-generic)
[    1.649630] alg: No test for stdrng (krng)
[    1.650878] NET: Registered protocol family 38
[    1.652184] Key type asymmetric registered
[    1.653512] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.655463] io scheduler noop registered (default)
[    1.656776] io scheduler deadline registered
[    1.658114] io scheduler cfq registered
[    1.659172] xz_dec_test: module loaded
[    1.660186] xz_dec_test: Create a device node with 'mknod xz_dec_test c 252 0' and write .xz files to it.
[    1.663640] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.665147] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    1.666948] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[    1.672928] GHES: HEST is not enabled!
[    1.673930] ERST DBG: ERST support is disabled.
[    1.675220] isapnp: Scanning for PnP cards...
[    2.041642] isapnp: No Plug & Play device found
[    2.043107] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.068584] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.071248] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    2.072978] Real Time Clock Driver v1.12b
[    2.074186] Non-volatile memory driver v1.3
[    2.075457] toshiba: not a supported Toshiba laptop
[    2.076893] scx200_gpio: no SCx200 gpio present
[    2.078206] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initializing
[    2.080095] platform pc8736x_gpio.0: no device found
[    2.081469] nsc_gpio initializing
[    2.082487] telclk_interrupt = 0xf non-mcpbl0010 hw.
[    2.083933] SyncLink PC Card driver $Revision: 4.34 $, tty major#246
[    2.085651] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    2.087891] Hangcheck: Using getrawmonotonic().
[    2.093025] brd: module loaded
[    2.094038] HP CISS Driver (v 3.6.26)
[    2.095616] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.095740] Floppy drive(s): fd0 is 1.44M
[    2.098725] Phantom Linux Driver, version n0.9.8, init OK
[    2.100346] i2c-core: driver [tsl2550] using legacy suspend method
[    2.101914] i2c-core: driver [tsl2550] using legacy resume method
[    2.103557] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
[    2.105829] i2c-core: driver [fsa9480] using legacy suspend method
[    2.107396] i2c-core: driver [fsa9480] using legacy resume method
[    2.109184] Driver for timberdale has been successfully registered.
[    2.110862] Uniform Multi-Platform E-IDE driver
[    2.112783] ide-gd driver 1.18
[    2.114023] hp_sw: device handler registered
[    2.115239] emc: device handler registered
[    2.116784] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    2.117065] FDC 0 is a S82078B
[    2.119546] osst :I: Tape driver with OnStream support version 0.99.4
[    2.119546] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[    2.123033] SCSI Media Changer driver v0.25 
[    2.124502] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[    2.125851] YAM driver version 0.8 by F1OAT/F6FBB
[    2.128141] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.128141] baycom_ser_fdx: version 0.10
[    2.131811] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[    2.134431] hdlcdrv: version 0.8
[    2.135445] baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[    2.135445] baycom_ser_hdx: version 0.10
[    2.139128] I2O subsystem v1.325
[    2.140150] i2o: max drivers = 8
[    2.141418] I2O Bus Adapter OSM v1.317
[    2.142567] I2O Block Device OSM v1.325
[    2.144239] I2O SCSI Peripheral OSM v1.316
[    2.145440] Fusion MPT base driver 3.04.20
[    2.146603] Copyright (c) 1999-2008 LSI Corporation
[    2.147912] Fusion MPT FC Host driver 3.04.20
[    2.149674] Databook TCIC-2 PCMCIA probe: not found.
[    2.151183] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.152879] ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
[    2.154511] uhci_hcd: USB Universal Host Controller Interface driver
[    2.156337] driver u132_hcd
[    2.157456] usbcore: registered new interface driver usblp
[    2.158911] usbcore: registered new interface driver usbtmc
[    2.160486] usbcore: registered new interface driver uas
[    2.161865] Initializing USB Mass Storage driver...
[    2.163281] usbcore: registered new interface driver usb-storage
[    2.164914] USB Mass Storage support registered.
[    2.166271] usbcore: registered new interface driver ums-alauda
[    2.167770] usbcore: registered new interface driver ums-cypress
[    2.169350] usbcore: registered new interface driver ums-datafab
[    2.170912] usbcore: registered new interface driver ums-freecom
[    2.173555] usbcore: registered new interface driver ums-jumpshot
[    2.175160] usbcore: registered new interface driver ums-onetouch
[    2.176743] usbcore: registered new interface driver ums-sddr55
[    2.178323] usbcore: registered new interface driver ums-usbat
[    2.179570] usbcore: registered new interface driver microtekX6
[    2.181132] usbcore: registered new interface driver usbserial
[    2.182684] usbcore: registered new interface driver usbserial_generic
[    2.184382] usbserial: USB Serial support registered for generic
[    2.198801] usbcore: registered new interface driver aircable
[    2.200394] usbserial: USB Serial support registered for aircable
[    2.201892] usbcore: registered new interface driver ch341
[    2.203233] usbserial: USB Serial support registered for ch341-uart
[    2.204700] usbcore: registered new interface driver cyberjack
[    2.206188] usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
[    2.208531] usbcore: registered new interface driver cypress_m8
[    2.210049] usbserial: USB Serial support registered for DeLorme Earthmate USB
[    2.212080] usbserial: USB Serial support registered for HID->COM RS232 Adapter
[    2.214170] usbserial: USB Serial support registered for Nokia CA-42 V2 Adapter
[    2.216253] usbcore: registered new interface driver digi_acceleport
[    2.217909] usbserial: USB Serial support registered for Digi 2 port USB adapter
[    2.219958] usbserial: USB Serial support registered for Digi 4 port USB adapter
[    2.222072] usbcore: registered new interface driver io_edgeport
[    2.223678] usbserial: USB Serial support registered for Edgeport 2 port adapter
[    2.225747] usbserial: USB Serial support registered for Edgeport 4 port adapter
[    2.227818] usbserial: USB Serial support registered for Edgeport 8 port adapter
[    2.229931] usbserial: USB Serial support registered for EPiC device
[    2.231554] usbcore: registered new interface driver io_ti
[    2.233188] usbserial: USB Serial support registered for Edgeport TI 1 port adapter
[    2.235126] usbserial: USB Serial support registered for Edgeport TI 2 port adapter
[    2.237267] usbcore: registered new interface driver empeg
[    2.238682] usbserial: USB Serial support registered for empeg
[    2.240060] usbcore: registered new interface driver ftdi_sio
[    2.241505] usbserial: USB Serial support registered for FTDI USB Serial Device
[    2.243440] usbcore: registered new interface driver funsoft
[    2.244866] usbserial: USB Serial support registered for funsoft
[    2.246424] usbcore: registered new interface driver ipaq
[    2.247771] usbserial: USB Serial support registered for PocketPC PDA
[    2.249432] usbcore: registered new interface driver ipw
[    2.250798] usbserial: USB Serial support registered for IPWireless converter
[    2.252617] usbcore: registered new interface driver ir_usb
[    2.254076] usbserial: USB Serial support registered for IR Dongle
[    2.255689] usbcore: registered new interface driver kl5kusb105
[    2.257040] usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
[    2.258966] usbcore: registered new interface driver mos7720
[    2.260277] usbserial: USB Serial support registered for Moschip 2 port adapter
[    2.262077] usbcore: registered new interface driver navman
[    2.263399] usbserial: USB Serial support registered for navman
[    2.264789] usbcore: registered new interface driver option
[    2.266104] usbserial: USB Serial support registered for GSM modem (1-port)
[    2.267791] usbcore: registered new interface driver oti6858
[    2.269288] usbserial: USB Serial support registered for oti6858
[    2.270891] usbcore: registered new interface driver qcaux
[    2.272430] usbserial: USB Serial support registered for qcaux
[    2.274002] usbcore: registered new interface driver quatech2
[    2.275577] usbserial: USB Serial support registered for Quatech 2nd gen USB to Serial Driver
[    2.278029] usbcore: registered new interface driver safe_serial
[    2.279665] usbserial: USB Serial support registered for safe_serial
[    2.281415] usbcore: registered new interface driver ssu100
[    2.282951] usbserial: USB Serial support registered for Quatech SSU-100 USB to Serial Driver
[    2.285375] usbcore: registered new interface driver ti_usb_3410_5052
[    2.287041] usbserial: USB Serial support registered for TI USB 3410 1 port adapter
[    2.289760] usbserial: USB Serial support registered for TI USB 5052 2 port adapter
[    2.291994] usbcore: registered new interface driver visor
[    2.293552] usbserial: USB Serial support registered for Handspring Visor / Palm OS
[    2.295753] usbserial: USB Serial support registered for Sony Clie 5.0
[    2.297498] usbserial: USB Serial support registered for Sony Clie 3.5
[    2.299200] usbcore: registered new interface driver whiteheat
[    2.300857] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT - (prerenumeration)
[    2.303444] usbserial: USB Serial support registered for Connect Tech - WhiteHEAT
[    2.305650] usbcore: registered new interface driver zte_ev
[    2.307156] usbserial: USB Serial support registered for zte_ev
[    2.308526] usbcore: registered new interface driver adutux
[    2.310437] usbcore: registered new interface driver appledisplay
[    2.311970] usbcore: registered new interface driver cypress_cy7c63
[    2.314641] usbcore: registered new interface driver cytherm
[    2.316066] usbcore: registered new interface driver emi26 - firmware loader
[    2.317759] usbcore: registered new interface driver emi62 - firmware loader
[    2.319505] driver ftdi-elan
[    2.320843] usbcore: registered new interface driver ftdi-elan
[    2.322423] usbcore: registered new interface driver isight_firmware
[    2.324105] usbcore: registered new interface driver usblcd
[    2.325607] usbcore: registered new interface driver usbled
[    2.327016] usbcore: registered new interface driver legousbtower
[    2.328643] usbcore: registered new interface driver usbtest
[    2.330064] usbcore: registered new interface driver trancevibrator
[    2.331670] usbcore: registered new interface driver usbsevseg
[    2.333150] usbcore: registered new interface driver yurex
[    2.334786] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.337896] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.339272] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.417740] mousedev: PS/2 mouse device common for all mice
[    2.419483] usbcore: registered new interface driver bcm5974
[    2.421075] logibm.c: Didn't find Logitech busmouse at 0x23c
[    2.423109] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    2.427456] usbcore: registered new interface driver synaptics_usb
[    2.429121] usbcore: registered new interface driver aiptek
[    2.430616] usbcore: registered new interface driver hanwang
[    2.432125] usbcore: registered new interface driver kbtab
[    2.433642] usbcore: registered new interface driver wacom
[    2.435099] i2c /dev entries driver
[    2.436474] i2c-parport-light: adapter type unspecified
[    2.437863] scx200_acb: NatSemi SCx200 ACCESS.bus Driver
[    2.439295] scx200_i2c: NatSemi SCx200 I2C Driver
[    2.440563] scx200_i2c: no SCx200 gpio pins available
[    2.442226] i2c-core: driver [adv7180] using legacy suspend method
[    2.443831] i2c-core: driver [adv7180] using legacy resume method
[    2.445784] usbcore: registered new interface driver ati_remote
[    2.447325] usbcore: registered new interface driver imon
[    2.448807] usbcore: registered new interface driver redrat3
[    2.450292] usbcore: registered new interface driver streamzap
[    2.451876] Registered IR keymap rc-empty
[    2.453273] input: rc-core loopback device as /devices/virtual/rc/rc0/input1
[    2.455095] rc0: rc-core loopback device as /devices/virtual/rc/rc0
[    2.457830] usbcore: registered new interface driver iguanair
[    2.459251] Zoran MJPEG board driver version 0.10.1
[    2.460602] Linux video codec intermediate layer: v0.2
[    2.461969] meye: using 2 buffers with 600k (1200k total) for capture
[    2.463683] gspca_main: v2.14.0 registered
[    2.464897] usbcore: registered new interface driver benq
[    2.466299] usbcore: registered new interface driver conex
[    2.467760] usbcore: registered new interface driver cpia1
[    2.469220] usbcore: registered new interface driver finepix
[    2.470702] usbcore: registered new interface driver jeilinj
[    2.472238] usbcore: registered new interface driver jl2005bcd
[    2.473773] usbcore: registered new interface driver konica
[    2.475279] usbcore: registered new interface driver mars
[    2.476772] usbcore: registered new interface driver nw80x
[    2.478244] usbcore: registered new interface driver ov519
[    2.479733] usbcore: registered new interface driver ov534
[    2.481249] usbcore: registered new interface driver pac207
[    2.482787] usbcore: registered new interface driver sn9c2028
[    2.484368] usbcore: registered new interface driver gspca_sn9c20x
[    2.485944] usbcore: registered new interface driver sonixb
[    2.487441] usbcore: registered new interface driver sonixj
[    2.488918] usbcore: registered new interface driver spca501
[    2.490426] usbcore: registered new interface driver spca505
[    2.491884] usbcore: registered new interface driver spca1528
[    2.493423] usbcore: registered new interface driver sq905
[    2.494872] usbcore: registered new interface driver sq930x
[    2.496437] usbcore: registered new interface driver stk014
[    2.497878] usbcore: registered new interface driver tv8532
[    2.499424] usbcore: registered new interface driver vc032x
[    2.500902] usbcore: registered new interface driver xirlink-cit
[    2.502484] usbcore: registered new interface driver ALi m5602
[    2.503949] cpia2: V4L-Driver for Vision CPiA2 based cameras v3.0.1
[    2.505512] usbcore: registered new interface driver cpia2
[    2.506910] usbcore: registered new interface driver hdpvr
[    2.508363] usbcore: registered new interface driver usbvision
[    2.509821] USBVision USB Video Device Driver for Linux : 0.9.11
[    2.511374] usbcore: registered new interface driver tm6000
[    2.512864] usbcore: registered new interface driver em28xx
[    2.514299] Em28xx: Initialized (Em28xx Input Extension) extension
[    2.515878] radio-sf16fmi: no cards found
[    2.608236] tsc: Refined TSC clocksource calibration: 2693.499 MHz
[    2.722324] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input2
[    8.848594] radio-aimslab.0: Initialized radio card AIMSlab RadioTrack/RadioReveal on port 0x30f
[    8.850891] usbcore: registered new interface driver radio-si470x
[    8.852287] usbcore: registered new interface driver radio-keene
[    8.853724] Driver for 1-wire Dallas network protocol.
[    8.855052] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    8.857166] f71882fg: Not a Fintek device
[    8.858196] f71882fg: Not a Fintek device
[    8.859954] EISA: Probing bus 0 at eisa.0
[    8.874994] cpuidle: using governor ladder
[    8.876415] sdhci: Secure Digital Host Controller Interface driver
[    8.878191] sdhci: Copyright(c) Pierre Ossman
[    8.879698] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    8.882666] usbcore: registered new interface driver vub300
[    8.885193] ledtrig-cpu: registered to indicate activity on CPUs
[    8.886988] EFI Variables Facility v0.08 2004-May-17
[    8.888706] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    8.890848] usbip_core: USB/IP Core v1.0.0
[    8.891977] rts_pstor: Initializing Realtek PCIE storage driver...
[    8.893807] usbcore: registered new interface driver tranzport
[    8.895494] usbcore: registered new interface driver alphatrack
[    8.897327] Error: Driver 'adt7410' is already registered, aborting...
[    8.899924] Loading crystalhd 0.9.27
[    8.901390] input: Speakup as /devices/virtual/input/input3
[    8.903364] initialized device: /dev/synth, node (MAJOR 10, MINOR 25)
[    8.906352] speakup 3.1.6: initialized
[    8.907608] synth name on entry is: (null)
[    8.909322] ozwpan ozwpan: Ozmo Devices WPAN
[    8.910698] ozwpan ozwpan: new USB bus registered, assigned bus number 1
[    8.912730] usb usb1: default language 0x0409
[    8.914171] usb usb1: udev 1, busnum 1, minor = 0
[    8.915617] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    8.917487] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    8.919830] usb usb1: Product: Ozmo Devices WPAN
[    8.921313] usb usb1: Manufacturer: Linux 3.7.0-rc1-bisect-next-20121016 Ozmo WPAN
[    8.923743] usb usb1: SerialNumber: ozwpan
[    8.925342] usb usb1: usb_probe_device
[    8.926564] usb usb1: configuration #1 chosen from 1 choice
[    8.928249] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    8.930059] hub 1-0:1.0: usb_probe_interface
[    8.931313] hub 1-0:1.0: usb_probe_interface - got id
[    8.932864] hub 1-0:1.0: USB hub found
[    8.934174] hub 1-0:1.0: 8 ports detected
[    8.935379] hub 1-0:1.0: standalone hub
[    8.936620] hub 1-0:1.0: individual port power switching
[    8.938239] hub 1-0:1.0: global over-current protection
[    8.939833] hub 1-0:1.0: power on to power good time: 0ms
[    8.941547] hub 1-0:1.0: 200mA bus power budget for each child
[    8.943083] hub 1-0:1.0: local power source is good
[    8.944637] hub 1-0:1.0: no over-current condition exists
[    8.946464] hub 1-0:1.0: enabling power on all ports
[    8.948290] usbcore: registered new interface driver cedusb
[    8.950285] compal_laptop: Motherboard not recognized (You could try the module's force-parameter)
[    8.953150] hdaps: supported laptop not found!
[    8.954588] hdaps: driver init failed (ret=-19)!
[    8.956318] FUJ02B1: call_fext_func: FUNC interface is not present
[    8.958079] fujitsu_laptop: driver 0.6.0 successfully loaded
[    8.959796] fujitsu_tablet: Unknown (using defaults)
[    8.961552] intel_oaktrail: Platform not recognized (You could try the module's force-parameter)
[    8.964455] NET: Registered protocol family 26
[    8.966467] IPv4 over IPv4 tunneling driver
[    8.968139] gre: GRE over IPv4 demultiplexor driver
[    8.969659] ip_gre: GRE over IPv4 tunneling driver
[    8.971484] IPv4 over IPSec tunneling driver
[    8.973219] TCP: bic registered
[    8.974860] NET: Registered protocol family 10
[    8.977405] ip6_gre: GRE over IPv6 tunneling driver
[    8.979429] NET: Registered protocol family 4
[    8.983107] NET: Registered protocol family 11
[    8.984636] NET: Registered protocol family 3
[    8.986054] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    8.988859] DECnet: Routing cache hash table of 1024 buckets, 8Kbytes
[    8.990761] NET: Registered protocol family 12
[    8.992255] NET: Registered protocol family 35
[    8.993959] NET: Registered protocol family 37
[    8.995436] Key type dns_resolver registered
[    8.997391] batman_adv: B.A.T.M.A.N. advanced 2012.4.0 (compatibility version 14) loaded
[    8.999949] openvswitch: Open vSwitch switching datapath
[    9.003575] 
[    9.003575] printing PIC contents
[    9.005440] ... PIC  IMR: ffff
[    9.006559] ... PIC  IRR: 1053
[    9.007682] ... PIC  ISR: 0000
[    9.008816] ... PIC ELCR: 0c00
[    9.009971] printing local APIC contents on CPU#0/0:
[    9.011419] ... APIC ID:      00000000 (0)
[    9.012027] ... APIC VERSION: 00050014
[    9.012027] ... APIC TASKPRI: 00000000 (00)
[    9.012027] ... APIC PROCPRI: 00000000
[    9.012027] ... APIC LDR: 01000000
[    9.012027] ... APIC DFR: ffffffff
[    9.012027] ... APIC SPIV: 000001ff
[    9.012027] ... APIC ISR field:
[    9.012027] 0000000000000000000000000000000000000000000000000000000000000000
[    9.012027] ... APIC TMR field:
[    9.012027] 0000000000000000000000000000000000000000000000000000000000000000
[    9.012027] ... APIC IRR field:
[    9.012027] 0000000000000000000000000000000000000000000000000000000000008000
[    9.012027] ... APIC ESR: 00000000
[    9.012027] ... APIC ICR: 000008fd
[    9.012027] ... APIC ICR2: 02000000
[    9.012027] ... APIC LVTT: 000000ef
[    9.012027] ... APIC LVTPC: 00010000
[    9.012027] ... APIC LVT0: 00010700
[    9.012027] ... APIC LVT1: 00000400
[    9.012027] ... APIC LVTERR: 000000fe
[    9.012027] ... APIC TMICT: 0003c99e
[    9.012027] ... APIC TMCCT: 00000000
[    9.012027] ... APIC TDCR: 00000003
[    9.012027] 
[    9.042795] number of MP IRQ sources: 15.
[    9.044130] number of IO-APIC #2 registers: 24.
[    9.045585] testing the IO APIC.......................
[    9.047199] IO APIC #2......
[    9.048274] .... register #00: 00000000
[    9.049563] .......    : physical APIC id: 00
[    9.050962] .......    : Delivery Type: 0
[    9.052296] .......    : LTS          : 0
[    9.053634] .... register #01: 00170011
[    9.054930] .......     : max redirection entries: 17
[    9.056494] .......     : PRQ implemented: 0
[    9.057864] .......     : IO APIC version: 11
[    9.059262] .... register #02: 00000000
[    9.060587] .......     : arbitration: 00
[    9.061906] .... IRQ redirection table:
[    9.063194]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    9.064912]  00 00  1    0    0   0   0    0    0    00
[    9.066663]  01 03  0    0    0   0   0    1    1    31
[    9.068430]  02 03  0    0    0   0   0    1    1    30
[    9.070169]  03 03  0    0    0   0   0    1    1    33
[    9.071938]  04 03  1    0    0   0   0    1    1    34
[    9.073738]  05 03  1    1    0   0   0    1    1    35
[    9.075498]  06 03  0    0    0   0   0    1    1    36
[    9.077232]  07 03  0    0    0   0   0    1    1    37
[    9.078977]  08 03  0    0    0   0   0    1    1    38
[    9.080735]  09 03  0    1    0   0   0    1    1    39
[    9.082512]  0a 03  1    1    0   0   0    1    1    3A
[    9.084271]  0b 03  1    1    0   0   0    1    1    3B
[    9.086028]  0c 03  0    0    0   0   0    1    1    3C
[    9.087776]  0d 03  0    0    0   0   0    1    1    3D
[    9.089556]  0e 03  0    0    0   0   0    1    1    3E
[    9.091297]  0f 03  0    0    0   0   0    1    1    3F
[    9.093119]  10 00  1    0    0   0   0    0    0    00
[    9.094869]  11 00  1    0    0   0   0    0    0    00
[    9.096650]  12 00  1    0    0   0   0    0    0    00
[    9.098379]  13 00  1    0    0   0   0    0    0    00
[    9.100117]  14 00  1    0    0   0   0    0    0    00
[    9.101857]  15 00  1    0    0   0   0    0    0    00
[    9.103619]  16 00  1    0    0   0   0    0    0    00
[    9.105401]  17 00  1    0    0   0   0    0    0    00
[    9.107140] IRQ to pin mappings:
[    9.108283] IRQ0 -> 0:2
[    9.109532] IRQ1 -> 0:1
[    9.110729] IRQ3 -> 0:3
[    9.111966] IRQ4 -> 0:4
[    9.113217] IRQ5 -> 0:5
[    9.114437] IRQ6 -> 0:6
[    9.115663] IRQ7 -> 0:7
[    9.116884] IRQ8 -> 0:8
[    9.118109] IRQ9 -> 0:9
[    9.119325] IRQ10 -> 0:10
[    9.120614] IRQ11 -> 0:11
[    9.121878] IRQ12 -> 0:12
[    9.123136] IRQ13 -> 0:13
[    9.124442] IRQ14 -> 0:14
[    9.125679] IRQ15 -> 0:15
[    9.126939] .................................... done.
[    9.128553] Using IPI No-Shortcut mode
[    9.130095] registered taskstats version 1
[    9.131569] hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
[    9.132202] Key type trusted registered
[    9.132416] Key type encrypted registered
[    9.132503] IMA: No TPM chip found, activating TPM-bypass!
[    9.133742] ### of_selftest(): No testcase data in device tree; not running tests
[    9.140930] Freeing unused kernel memory: 556k freed
[    9.142656] Write protecting the kernel text: 6824k
[    9.144161] Write protecting the kernel read-only data: 3212k
[    9.206335] =============================================================================
[    9.208021] BUG dentry (Not tainted): Invalid object pointer 0xcd74de78
[    9.208021] -----------------------------------------------------------------------------
[    9.208021] 
[    9.208021] Disabling lock debugging due to kernel taint
[    9.208021] INFO: Slab 0xcdeed9a0 objects=23 used=17 fp=0xcd74d9a0 flags=0x40000081
[    9.208021] Pid: 1, comm: init Tainted: G    B        3.7.0-rc1-bisect-next-20121016 #24
[    9.208021] Call Trace:
[    9.208021]  [<c10bc9b9>] slab_err+0x38/0x40
[    9.208021]  [<c10bd259>] ? slab_pad_check.part.50+0x5e/0xd2
[    9.208021]  [<c1683a3c>] free_debug_processing+0x19b/0x1a0
[    9.208021]  [<c1683a7c>] __slab_free+0x3b/0x26a
[    9.208021]  [<c10dc807>] ? __simple_xattr_set+0xe8/0xf8
[    9.208021]  [<c10be881>] kfree+0xaa/0xb3
[    9.208021]  [<c10be881>] ? kfree+0xaa/0xb3
[    9.208021]  [<c10dc807>] ? __simple_xattr_set+0xe8/0xf8
[    9.208021]  [<c10aa7ea>] ? unmap_mapping_range+0x11f/0x127
[    9.208021]  [<c16a502e>] ? mutex_lock+0x18/0x31
[    9.208021]  [<c10dc807>] ? __simple_xattr_set+0xe8/0xf8
[    9.208021]  [<c10dc807>] __simple_xattr_set+0xe8/0xf8
[    9.208021]  [<c10dc8b2>] simple_xattr_remove+0xe/0x10
[    9.208021]  [<c109f09e>] shmem_removexattr+0x42/0x47
[    9.208021]  [<c11c49f1>] ima_inode_post_setattr+0x76/0x7b
[    9.208021]  [<c10d6dfd>] notify_change+0x2a9/0x2d8
[    9.208021]  [<c10c2fae>] do_truncate+0x60/0x77
[    9.208021]  [<c11c40ff>] ? ima_get_action+0x1f/0x24
[    9.208021]  [<c10caf7f>] handle_truncate+0x73/0x84
[    9.208021]  [<c10cd970>] do_last.isra.27+0x445/0x502
[    9.208021]  [<c10cdac0>] path_openat.isra.28+0x93/0x340
[    9.208021]  [<c1683f90>] ? __slab_alloc.constprop.66+0x258/0x27d
[    9.208021]  [<c10cdd8e>] do_filp_open+0x21/0x5d
[    9.208021]  [<c10d77df>] ? __alloc_fd+0x36/0xdc
[    9.208021]  [<c10c3cd5>] do_sys_open+0xfa/0x173
[    9.208021]  [<c10c3d6f>] sys_open+0x21/0x29
[    9.208021]  [<c16a728a>] sysenter_do_call+0x12/0x2c
[    9.270922] FIX dentry: Object at 0xcd74de78 not freed
[    9.272441] BUG: unable to handle kernel paging request at 6b6b6be3
[    9.274386] IP: [<c16a504a>] mutex_unlock+0x3/0x16
[    9.275970] *pde = 00000000 
[    9.276418] Oops: 0002 [#1] SMP 
[    9.276418] Pid: 1, comm: init Tainted: G    B        3.7.0-rc1-bisect-next-20121016 #24 Bochs Bochs
[    9.276418] EIP: 0060:[<c16a504a>] EFLAGS: 00010212 CPU: 0
[    9.276418] EIP is at mutex_unlock+0x3/0x16
[    9.276418] EAX: 6b6b6bd3 EBX: cd744dc0 ECX: cd89b998 EDX: 0000a068
[    9.276418] ESI: 00000000 EDI: cf8b9d00 EBP: cd84fe04 ESP: cd84fe04
[    9.276418]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[    9.276418] CR0: 80050033 CR2: 6b6b6be3 CR3: 0f895000 CR4: 00000690
[    9.276418] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    9.276418] DR6: ffff0ff0 DR7: 00000400
[    9.276418] Process init (pid: 1, ti=cd84e000 task=cd850000 task.ti=cd84e000)
[    9.276418] Stack:
[    9.276418]  cd84fe4c c10c2fbb 0000a068 cd84fecc cd84fe24 c11c40ff 00000000 00000000
[    9.276418]  507d74a4 0bffee10 507d74a4 0bffee10 507d74a4 0bffee10 cf8b9d00 cd89b9a4
[    9.276418]  cd744dc0 cf8b9d00 cd84fe68 c10caf7f 00008060 cf8b9d00 cd84ff00 00000000
[    9.276418] Call Trace:
[    9.276418]  [<c10c2fbb>] do_truncate+0x6d/0x77
[    9.276418]  [<c11c40ff>] ? ima_get_action+0x1f/0x24
[    9.276418]  [<c10caf7f>] handle_truncate+0x73/0x84
[    9.276418]  [<c10cd970>] do_last.isra.27+0x445/0x502
[    9.276418]  [<c10cdac0>] path_openat.isra.28+0x93/0x340
[    9.276418]  [<c1683f90>] ? __slab_alloc.constprop.66+0x258/0x27d
[    9.276418]  [<c10cdd8e>] do_filp_open+0x21/0x5d
[    9.276418]  [<c10d77df>] ? __alloc_fd+0x36/0xdc
[    9.276418]  [<c10c3cd5>] do_sys_open+0xfa/0x173
[    9.276418]  [<c10c3d6f>] sys_open+0x21/0x29
[    9.276418]  [<c16a728a>] sysenter_do_call+0x12/0x2c
[    9.276418] Code: b8 13 91 8c c1 ba 55 00 00 00 e8 aa 98 9c ff 89 d8 f0 ff 08 79 05 e8 ce 00 00 00 64 a1 88 17 af c1 89 43 10 59 5b 5d c3 55 89 e5 <c7> 40 10 00 00 00 00 f0 ff 00 7f 05 e8 02 00 00 00 5d c3 55 89
[    9.276418] EIP: [<c16a504a>] mutex_unlock+0x3/0x16 SS:ESP 0068:cd84fe04
[    9.276418] CR2: 000000006b6b6be3
[    9.338044] ---[ end trace cc086ee780e60dd0 ]---
[    9.339660] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[    9.339660] 

--Q68bSM7Ycu6FN28Q--

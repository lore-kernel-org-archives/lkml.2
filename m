Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab0HNOap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 10:30:45 -0400
Received: from legolas.restena.lu ([158.64.1.34]:42375 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab0HNOao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 10:30:44 -0400
Date: Sat, 14 Aug 2010 16:29:48 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>, Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.36-git: BUG in highmem_32.c:45 causing scheduling while atomic
Message-ID: <20100814162948.2e31ddc6@neptune.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.36-git at commit 92fa5bd9a946b6e7aab6764e7312e4e3d9bed295 (with
a few DRM/KMS branches merged on top) I have seen the following BUG:

[    5.764691] BUG: scheduling while atomic: udevd/848/0x10000001
[    5.764700] Modules linked in: ac97_bus snd_pcm snd_timer nsc_ircc snd irda ehci_hcd snd_page_alloc pcspkr uhci_hcd i2c_i801 usbcore crc_ccitt
[    5.764736] Pid: 848, comm: udevd Not tainted 2.6.35-08069-geb0c3f9 #34
[    5.764743] Call Trace:
[    5.764764]  [<c1301440>] ? printk+0x18/0x20
[    5.764778]  [<c10271d8>] __schedule_bug+0x58/0x60
[    5.764788]  [<c13019a8>] schedule+0x448/0x4f0
[    5.764799]  [<c102a446>] __cond_resched+0x16/0x30
[    5.764809]  [<c1301af5>] _cond_resched+0x25/0x30
[    5.764820]  [<c1083c67>] anon_vma_prepare+0x17/0xd0
[    5.764834]  [<c1080498>] expand_downwards+0x18/0x140
[    5.764846]  [<c10805c8>] expand_stack+0x8/0x10
[    5.764856]  [<c107e18f>] handle_mm_fault+0x78f/0x7c0
[    5.764869]  [<c107e2b9>] __get_user_pages+0xf9/0x360
[    5.764880]  [<c107e5bf>] get_user_pages+0x4f/0x60
[    5.764893]  [<c109615b>] get_arg_page+0x4b/0xa0
[    5.764907]  [<c1128ff6>] ? strnlen_user+0x26/0x50
[    5.764917]  [<c1096279>] copy_strings+0xc9/0x190
[    5.764929]  [<c1096364>] copy_strings_kernel+0x24/0x40
[    5.764939]  [<c1097742>] do_execve+0x172/0x240
[    5.764954]  [<c100950d>] sys_execve+0x2d/0x70
[    5.764963]  [<c1002bf2>] ptregs_execve+0x12/0x18
[    5.764973]  [<c1002b90>] ? sysenter_do_call+0x12/0x26
[    5.765011] ------------[ cut here ]------------
[    5.770014] kernel BUG at /usr/src/linux-2.6/arch/x86/mm/highmem_32.c:45!
[    5.770014] invalid opcode: 0000 [#1] 
[    5.770014] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host0/target0:0:0/0:0:0:0/block/sda/uevent
[    5.770014] Modules linked in: ac97_bus snd_pcm snd_timer nsc_ircc snd irda ehci_hcd snd_page_alloc pcspkr uhci_hcd i2c_i801 usbcore crc_ccitt
[    5.770014] 
[    5.770014] Pid: 846, comm: irda-setup Not tainted 2.6.35-08069-geb0c3f9 #34 TravelMate 660/TravelMate 660
[    5.770014] EIP: 0060:[<c102464e>] EFLAGS: 00010206 CPU: 0
[    5.770014] EIP is at kmap_atomic_prot+0xbe/0xd0
[    5.770014] EAX: c24bcda0 EBX: c14b6ecc ECX: 00000163 EDX: 00000007
[    5.770014] ESI: 7dbe8163 EDI: c14b6ee8 EBP: f6992e48 ESP: f6992e38
[    5.770014]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[    5.770014] Process irda-setup (pid: 846, ti=f6992000 task=f688aec0 task.ti=f6992000)
[    5.770014] Stack:
[    5.770014]  fffff000 00000017 bfffffed f6993bfc f6992e50 c102466e f6992e94 c107da72
[    5.770014] <0> 00000080 00000000 f68d3480 00000000 00000000 c1317b40 f70db280 f6993bfc
[    5.770014] <0> f69b8058 bffff000 f683a8c0 00000017 00000017 f69b8058 bfffffed f6992ed0
[    5.770014] Call Trace:
[    5.770014]  [<c102466e>] ? kmap_atomic+0xe/0x10
[    5.770014]  [<c107da72>] ? handle_mm_fault+0x72/0x7c0
[    5.770014]  [<c107e2b9>] ? __get_user_pages+0xf9/0x360
[    5.770014]  [<c107e5bf>] ? get_user_pages+0x4f/0x60
[    5.770014]  [<c109615b>] ? get_arg_page+0x4b/0xa0
[    5.770014]  [<c1128ff6>] ? strnlen_user+0x26/0x50
[    5.770014]  [<c1096279>] ? copy_strings+0xc9/0x190
[    5.770014]  [<c1096364>] ? copy_strings_kernel+0x24/0x40
[    5.770014]  [<c1097742>] ? do_execve+0x172/0x240
[    5.770014]  [<c100950d>] ? sys_execve+0x2d/0x70
[    5.770014]  [<c1002bf2>] ? ptregs_execve+0x12/0x18
[    5.770014]  [<c1002b90>] ? sysenter_do_call+0x12/0x26
[    5.770014] Code: 8b 3d e0 be 51 c1 89 ce 74 08 8b 0d 3c f5 45 c1 21 ce 29 f8 83 c2 45 c1 f8 05 c1 e0 0c 09 f0 89 03 c1 e2 0c 8b 45 f0 29 d0 eb 8a <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 8b 0d 04 
[    5.770014] EIP: [<c102464e>] kmap_atomic_prot+0xbe/0xd0 SS:ESP 0068:f6992e38
[    5.983467] ---[ end trace 3a8cbdf92d372161 ]---

(and a few more, often with the BUG() at highmem_32.c).
That all happened during udev run at early userspace startup, hitting
either udev itself or helper binaries like modprobe.


Looking at highmem32.c, around line 45 I have:

30: void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)
31: {
32:         enum fixed_addresses idx;
33:         unsigned long vaddr;
34: 
35:         /* even !CONFIG_PREEMPT needs this, for in_atomic in do_page_fault */
36:         pagefault_disable();
37: 
38:         if (!PageHighMem(page))
39:                 return page_address(page);
40: 
41:         debug_kmap_atomic(type);
42: 
43:         idx = type + KM_TYPE_NR*smp_processor_id();
44:         vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
45:         BUG_ON(!pte_none(*(kmap_pte-idx)));
46:         set_pte(kmap_pte-idx, mk_pte(page, prot));
47: 
48:         return (void *)vaddr;
49: }


Config extract (whole config and dmesg available on demand):
#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
...
CONFIG_MPENTIUMM=y
...
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
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
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

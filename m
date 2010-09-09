Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab0IIWfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:35:06 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44653 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab0IIWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:34:58 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Damien Wyart <damien.wyart@free.fr>, John Drescher <drescherjm@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (HPET)
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette> <87iq2gyllg.fsf@spindle.srvr.nix>
From: Nix <nix@esperi.org.uk>
Emacs: more boundary conditions than the Middle East.
Date: Thu, 09 Sep 2010 23:34:37 +0100
In-Reply-To: <87iq2gyllg.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of "8 Sep 2010 22:25:24 +0100")
Message-ID: <87wrqu8s1u.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Sep 2010, nix@esperi.org.uk spake thusly:

> On 6 Sep 2010, Damien Wyart uttered the following:
>> So if you can reproduce it quite easily, I guess bisection (even
>
> ha ha ha. I thought I could, but it's intermittent enough to make
> bisection pretty much impossible, and when I gave up and rebooted back
> into 2.6.35.4 the bug went away entirely.
>
> I don't think bisection will work with something this intermittent :/

It did: I found a system on which the fault was consistently
reproducible. Bisected.

The horrible slowdowns some people are experiencing in 2.6.35 are *not*
a result of bootmem interfering with the scheduler. They are a result of
an HPET patch, specifically, this one:

commit 30a564be9d9554c168a654eddc2165869cc0d7bf
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Tue Apr 13 15:31:36 2010 +0200

    x86, hpet: Restrict read back to affected ATI chipsets

    After programming the HPET, we do a readback as a workaround for
    ATI/SBx00 chipsets as a synchronization.  Unfortunately this triggers
    an erratum in newer ICH chipsets (ICH9+) where reading the comparator
    immediately after the write returns the old value.  Furthermore, as
    always, I/O reads are bad for performance.

    Therefore, restrict the readback to the chipsets that need it, or, for
    debugging purposes, when we are running with hpet=verbose.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Venkatesh Pallipadi <venki@google.com>
    LKML-Reference: <20100225185348.GA9674@linux-os.sc.intel.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

On (at least) my ICH10 motherboard (a Tyan S7010), running this commit
(or later) without hpet=verbose leads to one of two behaviours depending
on whether or not CONFIG_NO_HZ is on. (This system is using HPET timers
rather than the TSC even though it is a constant_tsc system, because it
is an always-on headless server and I wanted it to spend as much time in
C3 as possible. Why, yes, bisecting a bug on an always-on headless
server with a dozen client systems *was* a complete pig, why do you
ask?)

If CONFIG_NO_HZ is off, I see weird intermittent stutters that make it
very hard to type: keys sometimes autorepeat when they should not, or
fail to be detected until some seconds have passed (I have the contents
of /proc/timer_list when the system was in this state: attached
below). If CONFIG_NO_HZ is on, I see increasing slowdowns when the
system is idle that eventually (in a few minutes) make it unusable.


The chipset is an Intel Corporation 82801JI. It looks like it needs this
readback. Good old Intel, ICH9 has an erratum related to this readback
and ICH10 needs it...


John, Damien, you seem to be experiencing this: are you using HPET as
your clocksource? Do you also have ICH10 82801JIs, or is this more
widespread?


.config (again), lspci, and timer_list from afflicted system in
!CONFIG_NO_HZ mode follow:

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_LZMA=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_TREE_RCU=y
CONFIG_RCU_FANOUT=8
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="usr/initramfs.spindle"
CONFIG_INITRAMFS_ROOT_UID=99
CONFIG_INITRAMFS_ROOT_GID=101
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_LZO=y
CONFIG_INITRAMFS_COMPRESSION_LZMA=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_OPTPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLOCK_COMPAT=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=m
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_INLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_NO_BOOTMEM=y
CONFIG_MCORE2=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MTRR=y
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_HZ_100=y
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_PM=y
CONFIG_PM_RUNTIME=y
CONFIG_PM_OPS=y
CONFIG_ACPI=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_X86_PM_TIMER=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_LLC=y
CONFIG_RPS=y
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_HCIBTUSB=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=16
CONFIG_MISC_DEVICES=y
CONFIG_HAVE_IDE=y
CONFIG_SCSI_MOD=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_TUN=y
CONFIG_NETDEV_1000=y
CONFIG_E1000E=y
CONFIG_INPUT=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1680
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=1050
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y
CONFIG_GAMEPORT=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_POWEROFF=m
CONFIG_NVRAM=m
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_I801=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_W83793=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_SSB_POSSIBLE=y
CONFIG_MFD_SUPPORT=y
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=1
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_PCI=y
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_USB_HID=y
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_HID_ZEROPLUS=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_ACM=y
CONFIG_USB_STORAGE=y
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_PL2303=m
CONFIG_EDAC=y
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_MCE=y
CONFIG_EDAC_I7CORE=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_CMOS=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_ROOT_NFS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_UTF8=m
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_SYSPROF_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_TESTS=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CBC=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_VHOST_NET=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=y
CONFIG_BINARY_PRINTF=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

00:00.0 Host bridge: Intel Corporation 5520 I/O Hub to ESI Port (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: fast devsel
	Capabilities: [60] MSI: Enable- Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot-), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>

00:01.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 1 (rev 13) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:03.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 3 (rev 13) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:05.0 PCI bridge: Intel Corporation 5520/X58 I/O Hub PCI Express Root Port 5 (rev 13) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Kernel driver in use: pcieport

00:07.0 PCI bridge: Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port 7 (rev 13) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=07, sec-latency=0
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000f9c00000-00000000f9ffffff
	Capabilities: [40] Subsystem: Intel Corporation Device 0000
	Capabilities: [60] MSI: Enable+ Count=1/2 Maskable+ 64bit-
	Capabilities: [90] Express Root Port (Slot+), MSI 00
	Capabilities: [e0] Power Management version 3
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [150] Access Control Services
	Capabilities: [160] Vendor Specific Information: ID=0002 Rev=0 Len=00c <?>
	Kernel driver in use: pcieport

00:13.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller (rev 13) (prog-if 20 [IO(X)-APIC])
	Flags: bus master, fast devsel, latency 0
	Memory at fec8a000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [6c] Power Management version 3

00:14.0 PIC: Intel Corporation 5520/5500/X58 I/O Hub System Management Registers (rev 13) (prog-if 00 [8259])
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
	Kernel driver in use: i7core_edac

00:14.1 PIC: Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers (rev 13) (prog-if 00 [8259])
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.2 PIC: Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers (rev 13) (prog-if 00 [8259])
	Flags: fast devsel
	Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00

00:14.3 PIC: Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers (rev 13) (prog-if 00 [8259])
	Flags: fast devsel

00:16.0 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at faed4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.1 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at faed8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.2 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 15
	Memory at faedc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.3 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at faee0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.4 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 10
	Memory at faee4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.5 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at faee8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.6 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 15
	Memory at faeec000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:16.7 System peripheral: Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device (rev 13)
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at faef0000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [80] MSI-X: Enable- Count=1 Masked-
	Capabilities: [90] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [e0] Power Management version 3

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at a400 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at a480 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at a800 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2 (prog-if 20 [EHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 18
	Memory at faef8000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
	Subsystem: Intel Corporation 82801JI (ICH10 Family) HD Audio Controller
	Flags: bus master, fast devsel, latency 0, IRQ 79
	Memory at faef4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Root Complex Link
	Kernel driver in use: HDA Intel

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1 (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: c0000000-c01fffff
	Prefetchable memory behind bridge: 00000000c0200000-00000000c03fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 1
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5 (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbd00000-fbdfffff
	Prefetchable memory behind bridge: 00000000c0400000-00000000c05fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 5
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6 (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbc00000-fbcfffff
	Prefetchable memory behind bridge: 00000000c0600000-00000000c07fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
	Capabilities: [90] Subsystem: Intel Corporation 82801JI (ICH10 Family) PCI Express Root Port 6
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Root Complex Link
	Kernel driver in use: pcieport

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at a880 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at ac00 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3 (prog-if 00 [UHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at b000 [size=32]
	Capabilities: [50] PCI Advanced Features
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1 (prog-if 20 [EHCI])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at faefa000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: faf00000-fbbfffff
	Capabilities: [50] Subsystem: Intel Corporation 82801 PCI Bridge

00:1f.0 ISA bridge: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Subsystem: Intel Corporation 82801JIR (ICH10R) LPC Interface Controller
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Intel Corporation 82801JI (ICH10 Family) SATA AHCI Controller
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 72
	I/O ports at b880 [size=8]
	I/O ports at b800 [size=4]
	I/O ports at b480 [size=8]
	I/O ports at b400 [size=4]
	I/O ports at b080 [size=32]
	Memory at faefc000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Flags: medium devsel, IRQ 18
	Memory at faefe000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus

01:00.0 VGA compatible controller: ASPEED Technology, Inc. ASPEED Graphics Family (rev 10) (prog-if 00 [VGA controller])
	Subsystem: ASPEED Technology, Inc. ASPEED Graphics Family
	Flags: medium devsel, IRQ 10
	Memory at fb000000 (32-bit, non-prefetchable) [size=8M]
	Memory at fafe0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at c880 [size=128]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [40] Power Management version 3

01:05.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link Layer Controller (rev c0) (prog-if 10 [OHCI])
	Subsystem: VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link Layer Controller
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at fbbfe000 (32-bit, non-prefetchable) [size=2K]
	I/O ports at cc00 [size=128]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

02:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 17
	Memory at fbce0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at dc00 [size=32]
	Memory at fbcdc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: e1000e

03:00.0 Ethernet controller: Intel Corporation 82574L Gigabit Network Connection
	Subsystem: Intel Corporation Device 0000
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at fbde0000 (32-bit, non-prefetchable) [size=128K]
	I/O ports at ec00 [size=32]
	Memory at fbddc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [a0] MSI-X: Enable+ Count=5 Masked-
	Capabilities: [100] Advanced Error Reporting
	Kernel driver in use: e1000e

05:00.0 PCI bridge: Intel Corporation 80333 Segment-A PCI Express-to-PCI Express Bridge (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=05, secondary=07, subordinate=07, sec-latency=64
	Memory behind bridge: fbe00000-fbefffff
	Prefetchable memory behind bridge: 00000000f9c00000-00000000f9ffffff
	Capabilities: [44] Express PCI/PCI-X Bridge, MSI 00
	Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [6c] Power Management version 2
	Capabilities: [d8] PCI-X bridge device
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [300] Power Budgeting <?>

05:00.2 PCI bridge: Intel Corporation 80333 Segment-B PCI Express-to-PCI Express Bridge (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=05, secondary=06, subordinate=06, sec-latency=64
	Capabilities: [44] Express PCI/PCI-X Bridge, MSI 00
	Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [6c] Power Management version 2
	Capabilities: [d8] PCI-X bridge device
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [300] Power Budgeting <?>

07:0e.0 RAID bus controller: Areca Technology Corp. ARC-1210 4-Port PCI-Express to SATA RAID Controller
	Subsystem: Areca Technology Corp. ARC-1210 4-Port PCI-Express to SATA RAID Controller
	Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 39
	Memory at fbeff000 (32-bit, non-prefetchable) [size=4K]
	Memory at f9c00000 (32-bit, prefetchable) [size=4M]
	Expansion ROM at fbee0000 [disabled] [size=64K]
	Capabilities: [c0] Power Management version 2
	Capabilities: [d0] MSI: Enable- Count=1/2 Maskable- 64bit+
	Capabilities: [e0] PCI-X non-bridge device
	Kernel driver in use: arcmsr

ff:00.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Architecture Generic Non-Core Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:00.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QuickPath Architecture System Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.0 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.1 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 0 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.4 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Link 1 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:02.5 Host bridge: Intel Corporation Xeon 5500/Core i7 QPI Physical 1 (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:03.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:03.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Target Address Decoder (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:03.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller RAS Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:03.4 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Test Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:04.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:04.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:04.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:04.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 0 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:05.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:05.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:05.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:05.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 1 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:06.0 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:06.1 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Address Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:06.2 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Rank Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

ff:06.3 Host bridge: Intel Corporation Xeon 5500/Core i7 Integrated Memory Controller Channel 2 Thermal Control Registers (rev 05)
	Subsystem: Intel Corporation Device 8086
	Flags: bus master, fast devsel, latency 0

Timer List Version: v0.6
HRTIMER_MAX_CLOCK_BASES: 2
now at 231894261610 nsecs

cpu: 0
 clock 0:
  .base:       ffff880001c0ece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 clock 1:
  .base:       ffff880001c0ed28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001c0edc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 231900000000-231900000000 nsecs [in 5738390 to 5738390 nsecs]
 #1: <ffff88062eee98f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, postgres/1230
 # expires at 232092012123-232092212122 nsecs [in 197750513 to 197950512 nsecs]
 #2: <ffff880622af78f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, mysqld/1421
 # expires at 232150046633-232155046629 nsecs [in 255785023 to 260785019 nsecs]
 #3: <ffff88063bc41a48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, hald-addon-stor/1007
 # expires at 232268982012-232270939011 nsecs [in 374720402 to 376677401 nsecs]
 #4: <ffff88063b3c3a48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, console-kit-dae/846
 # expires at 238269036616-238287035615 nsecs [in 6374775006 to 6392774005 nsecs]
 #5: <ffff88063b3cda48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, hald/911
 # expires at 250269119315-250299098314 nsecs [in 18374857705 to 18404836704 nsecs]
 #6: <ffff88062edb1ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, uptimed/1203
 # expires at 350444764521-350444814521 nsecs [in 118550502911 to 118550552911 nsecs]
 #7: <ffff88062ef7f8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, spamd/1238
 # expires at 505444337806-505544337806 nsecs [in 273550076196 to 273650076196 nsecs]
 #8: <ffff8806150578f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, xfs/1437
 # expires at 685458606700-685558606700 nsecs [in 453564345090 to 453664345090 nsecs]
 #9: <ffff88062284ba48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, clamd/1240
 # expires at 2018495067438-2018595067438 nsecs [in 1786600805828 to 1786700805828 nsecs]
 #10: <ffff88063b95bea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, atd/1192
 # expires at 3649780824423-3649780874423 nsecs [in 3417886562813 to 3417886612813 nsecs]
 #11: <ffff88063ae0a8b0>, it_real_fn, S:01, hrtimer_start, freshclam/1244
 # expires at 7282478562632-7282478562632 nsecs [in 7050584301022 to 7050584301022 nsecs]
 #12: <ffff88063bceba48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, rpc.rwalld/1066
 # expires at 4295011676530118-4295011776530118 nsecs [in 4294779782268508 to 4294779882268508 nsecs]
  .expires_next   : 231900000000 nsecs
  .hres_active    : 1
  .nr_events      : 14585
  .nr_retries     : 7
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 1
 clock 0:
  .base:       ffff880001c4ece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 #0: <ffff8806228d1d18>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, clamav-milter/1247
 # expires at 1284058723000000000-1284058723000050000 nsecs [in 1284058491105738390 to 1284058491105788390 nsecs]
 clock 1:
  .base:       ffff880001c4ed28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001c4edc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 231900625000-231900625000 nsecs [in 6363390 to 6363390 nsecs]
 #1: <ffff880622bf98f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, mysqld/1423
 # expires at 231951832944-231976832939 nsecs [in 57571334 to 82571329 nsecs]
 #2: def_rt_bandwidth, sched_rt_period_timer, S:01, enqueue_task_rt, swapper/1
 # expires at 232000000000-232000000000 nsecs [in 105738390 to 105738390 nsecs]
 #3: <ffff88062eda9ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, sensord/1208
 # expires at 256921915524-256921965524 nsecs [in 25027653914 to 25027703914 nsecs]
 #4: <ffff88062efb18f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, spamd/1237
 # expires at 505444341041-505544341041 nsecs [in 273550079431 to 273650079431 nsecs]
 #5: <ffff8806050f3ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, sleep/1737
 # expires at 3708674106337-3708674156337 nsecs [in 3476779844727 to 3476779894727 nsecs]
  .expires_next   : 231900625000 nsecs
  .hres_active    : 1
  .nr_events      : 16901
  .nr_retries     : 13
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 2
 clock 0:
  .base:       ffff880001c8ece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 #0: <ffff88063b055d18>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, named/725
 # expires at 1284059696253405000-1284059696253455000 nsecs [in 1284059464359143390 to 1284059464359193390 nsecs]
 clock 1:
  .base:       ffff880001c8ed28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001c8edc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/1
 # expires at 230351250000-230351250000 nsecs [in -1543011610 to -1543011610 nsecs]
 #1: <ffff8806229b98f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, mysqld/1422
 # expires at 230416366012-230421366007 nsecs [in -1477895598 to -1472895603 nsecs]
 #2: <ffff88063fcbb8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, init/1
 # expires at 231521267327-231526267326 nsecs [in -372994283 to -367994284 nsecs]
 #3: <ffff88062eebb8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, spamd/1222
 # expires at 232070475699-232072475698 nsecs [in 176214089 to 178214088 nsecs]
 #4: <ffff8806228d98f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, dccm/1251
 # expires at 232546267648-232551267647 nsecs [in 652006038 to 657006037 nsecs]
 #5: <ffff88062ef4d8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, clamav-milter/1246
 # expires at 232546272690-232551272689 nsecs [in 652011080 to 657011079 nsecs]
 #6: <ffff88063b865a48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, syslog-ng/712
 # expires at 249951994533-249972166532 nsecs [in 18057732923 to 18077904922 nsecs]
 #7: <ffff88062edad8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, innfeed/1191
 # expires at 262510044831-262610044831 nsecs [in 30615783221 to 30715783221 nsecs]
 #8: <ffff88063b28ec70>, it_real_fn, S:01, hrtimer_start, spamd/1222
 # expires at 294070472347-294070472347 nsecs [in 62176210737 to 62176210737 nsecs]
 #9: <ffff88063b7ddd18>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, nscd/754
 # expires at 510879307173-510879357173 nsecs [in 278985045563 to 278985095563 nsecs]
  .expires_next   : 230351250000 nsecs
  .hres_active    : 1
  .nr_events      : 15694
  .nr_retries     : 31
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 3
 clock 0:
  .base:       ffff880001ccece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 clock 1:
  .base:       ffff880001cced28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001ccedc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 231901875000-231901875000 nsecs [in 7613390 to 7613390 nsecs]
 #1: <ffff88062eeeb8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, postgres/1231
 # expires at 231951548088-231951748087 nsecs [in 57286478 to 57486477 nsecs]
 #2: <ffff88062ef0b8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, postgres/1232
 # expires at 232351139757-232352139756 nsecs [in 456878147 to 457878146 nsecs]
 #3: <ffff8806229c38f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, httpd/1393
 # expires at 232421879981-232426879979 nsecs [in 527618371 to 532618369 nsecs]
  .expires_next   : 231901875000 nsecs
  .hres_active    : 1
  .nr_events      : 16806
  .nr_retries     : 43
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 4
 clock 0:
  .base:       ffff880001d0ece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 clock 1:
  .base:       ffff880001d0ed28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001d0edc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 231902500000-231902500000 nsecs [in 8238390 to 8238390 nsecs]
 #1: <ffff88062ef2da48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, postgres/1233
 # expires at 232872021154-232874021153 nsecs [in 977759544 to 979759543 nsecs]
 #2: <ffff88062ecfd8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, httpd/1397
 # expires at 232892034997-232897034994 nsecs [in 997773387 to 1002773384 nsecs]
 #3: <ffff88063b8938f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, postgres/1219
 # expires at 249702509574-249762509573 nsecs [in 17808247964 to 17868247963 nsecs]
 #4: <ffff88063b84dea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, crond/1188
 # expires at 281252091288-281252141288 nsecs [in 49357829678 to 49357879678 nsecs]
 #5: <ffff88063b5178f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, innd/1106
 # expires at 86450485260674-86450585260674 nsecs [in 86218590999064 to 86218690999064 nsecs]
  .expires_next   : 231902500000 nsecs
  .hres_active    : 1
  .nr_events      : 15914
  .nr_retries     : 29
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 5
 clock 0:
  .base:       ffff880001d4ece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 #0: <ffff880622a51d18>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, clamd/1964
 # expires at 1284058709000000000-1284058709000050000 nsecs [in 1284058477105738390 to 1284058477105788390 nsecs]
 clock 1:
  .base:       ffff880001d4ed28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001d4edc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 231903125000-231903125000 nsecs [in 8863390 to 8863390 nsecs]
 #1: <ffff88062ed09ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, irqbalance/1196
 # expires at 232268475305-232268525305 nsecs [in 374213695 to 374263695 nsecs]
 #2: <ffff88063a87b8f8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, lisa/976
 # expires at 235323136647-235330136646 nsecs [in 3428875037 to 3435875036 nsecs]
 #3: <ffff88062281ba48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, polipo/1404
 # expires at 1584105245782-1584205245782 nsecs [in 1352210984172 to 1352310984172 nsecs]
  .expires_next   : 231903125000 nsecs
  .hres_active    : 1
  .nr_events      : 15506
  .nr_retries     : 15
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 6
 clock 0:
  .base:       ffff880001d8ece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 clock 1:
  .base:       ffff880001d8ed28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001d8edc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 231903750000-231903750000 nsecs [in 9488390 to 9488390 nsecs]
 #1: <ffff880622801ea8>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, dccm/1255
 # expires at 233310176360-233310226360 nsecs [in 1415914750 to 1415964750 nsecs]
 #2: <ffff88063b5f9d18>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, nscd/755
 # expires at 251210471945-251210521945 nsecs [in 19316210335 to 19316260335 nsecs]
  .expires_next   : 231903750000 nsecs
  .hres_active    : 1
  .nr_events      : 18045
  .nr_retries     : 31
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485

cpu: 7
 clock 0:
  .base:       ffff880001dcece8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1284058460731526176 nsecs
active timers:
 clock 1:
  .base:       ffff880001dced28
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff880001dcedc0>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0
 # expires at 230394375000-230394375000 nsecs [in -1499886610 to -1499886610 nsecs]
 #1: <ffff88063b294b20>, posix_timer_fn, S:01, hrtimer_start_range_ns, ntpd/825
 # expires at 231092804369-231092804369 nsecs [in -801457241 to -801457241 nsecs]
 #2: <ffff88063b587a48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, kerneloops/837
 # expires at 235914635125-236914635125 nsecs [in 4020373515 to 5020373515 nsecs]
 #3: <ffff88063b52dd18>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, nscd/756
 # expires at 637190269759-637190319759 nsecs [in 405296008149 to 405296058149 nsecs]
 #4: <ffff88063b2b1a48>, hrtimer_wakeup, S:01, hrtimer_start_range_ns, avahi-daemon/815
 # expires at 3663469247262-3663569247262 nsecs [in 3431574985652 to 3431674985652 nsecs]
  .expires_next   : 230394375000 nsecs
  .hres_active    : 1
  .nr_events      : 13392
  .nr_retries     : 32
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 0 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 0 nsecs
  .iowait_sleeptime: 0 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294960485


Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   149983005959
 min_delta_ns:   5000
 mult:           61496114
 shift:          32
 mode:           3
 next_event:     38934375000 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        3
tick_broadcast_mask: 000000ff
tick_broadcast_oneshot_mask: 00000084


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           3
 next_event:     231900000000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        668

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           3
 next_event:     231900625000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        501

Tick Device: mode:     1
Per CPU device: 2
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           1
 next_event:     230351250000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        774

Tick Device: mode:     1
Per CPU device: 3
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           3
 next_event:     231901875000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        649

Tick Device: mode:     1
Per CPU device: 4
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           3
 next_event:     231902500000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        760

Tick Device: mode:     1
Per CPU device: 5
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           3
 next_event:     231903125000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        805

Tick Device: mode:     1
Per CPU device: 6
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           3
 next_event:     231903750000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        688

Tick Device: mode:     1
Per CPU device: 7
Clock Event Device: lapic
 max_delta_ns:   1006632056
 min_delta_ns:   1799
 mult:           35791422
 shift:          32
 mode:           1
 next_event:     230394375000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
 retries:        934


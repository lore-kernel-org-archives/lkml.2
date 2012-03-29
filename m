Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986Ab2C2Kof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:44:35 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35139 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2C2Ko1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:44:27 -0400
Date: Thu, 29 Mar 2012 12:44:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes and updates
Message-ID: <20120329104421.GA28032@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 8abc3122aa02567bfe626cd13f4d34853c9b1225 x86/apic/amd: Be more verbose about LVT offset assignments

Note, the following ended up in x86/urgent:

 out-of-topic modifications in x86-urgent-for-linus:
 ---------------------------------------------------
 arch/mips/configs/db1300_defconfig # e335e3e: locking/kconfig: Simplify INLINE_
 arch/xtensa/configs/iss_defconfig  # e335e3e: locking/kconfig: Simplify INLINE_
 include/linux/spinlock_api_smp.h   # e335e3e: locking/kconfig: Simplify INLINE_
 kernel/Kconfig.locks               # e335e3e: locking/kconfig: Simplify INLINE_
 kernel/Kconfig.preempt             # e335e3e: locking/kconfig: Simplify INLINE_
 kernel/spinlock.c                  # e335e3e: locking/kconfig: Simplify INLINE_

not in core/urgent where it would normally be, to keep the 
dependencies simpler.

 Thanks,

	Ingo

------------------>
Alexander Gordeev (1):
      x86/io_apic: Move and reenable irq only when CONFIG_GENERIC_PENDING_IRQ=y

Dan Carpenter (1):
      x86, tls: Off by one limit check

Daniel Drake (1):
      x86/olpc: Add debugfs interface for EC commands

Hugh Dickins (1):
      x86: Stop recursive fault in print_context_stack after stack overflow

Ingo Molnar (1):
      x86/kconfig: Update defconfigs

Jeremy Fitzhardinge (1):
      x86/ioapic: Add io_apic_ops driver layer to allow interception

Raghavendra K T (1):
      locking/kconfig: Simplify INLINE_SPIN_UNLOCK usage

Randy Dunlap (1):
      x86/kconfig: Remove CONFIG_TR=y from the defconfigs

Richard Weinberger (1):
      x86: Merge the x86_32 and x86_64 cpu_idle() functions

Robert Richter (1):
      x86/apic/amd: Be more verbose about LVT offset assignments

Steffen Persvold (1):
      x86/apic: Add separate apic_id_valid() functions for selected apic drivers

Yinghai Lu (1):
      x86: Fix excessive MSR print out when show_msr is not specified


 Documentation/ABI/testing/debugfs-olpc |   16 +++
 arch/mips/configs/db1300_defconfig     |    2 +-
 arch/x86/configs/i386_defconfig        |   64 +++++---------
 arch/x86/configs/x86_64_defconfig      |   67 +++++---------
 arch/x86/include/asm/apic.h            |    2 +-
 arch/x86/include/asm/idle.h            |    1 +
 arch/x86/include/asm/io_apic.h         |    9 ++
 arch/x86/include/asm/x2apic.h          |    5 +
 arch/x86/kernel/acpi/boot.c            |    2 +-
 arch/x86/kernel/apic/apic.c            |   13 ++-
 arch/x86/kernel/apic/apic_numachip.c   |    3 +-
 arch/x86/kernel/apic/io_apic.c         |  159 ++++++++++++++++++++++----------
 arch/x86/kernel/apic/x2apic_cluster.c  |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c     |    2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c     |    7 +-
 arch/x86/kernel/cpu/common.c           |    2 +-
 arch/x86/kernel/dumpstack.c            |    7 +-
 arch/x86/kernel/process.c              |  114 +++++++++++++++++++++++
 arch/x86/kernel/process_32.c           |   58 ------------
 arch/x86/kernel/process_64.c           |  107 ---------------------
 arch/x86/kernel/tls.c                  |    4 +-
 arch/x86/mm/srat.c                     |    2 +-
 arch/x86/platform/olpc/olpc.c          |   97 +++++++++++++++++++
 arch/xtensa/configs/iss_defconfig      |    2 +-
 include/linux/spinlock_api_smp.h       |    2 +-
 kernel/Kconfig.locks                   |    4 +-
 kernel/Kconfig.preempt                 |    1 +
 kernel/spinlock.c                      |    2 +-
 lib/Kconfig.debug                      |    1 +
 29 files changed, 436 insertions(+), 321 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-olpc

diff --git a/Documentation/ABI/testing/debugfs-olpc b/Documentation/ABI/testing/debugfs-olpc
new file mode 100644
index 0000000..bd76cc6
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-olpc
@@ -0,0 +1,16 @@
+What:		/sys/kernel/debug/olpc-ec/cmd
+Date:		Dec 2011
+KernelVersion:	3.4
+Contact:	devel@lists.laptop.org
+Description:
+
+A generic interface for executing OLPC Embedded Controller commands and
+reading their responses.
+
+To execute a command, write data with the format: CC:N A A A A
+CC is the (hex) command, N is the count of expected reply bytes, and A A A A
+are optional (hex) arguments.
+
+To read the response (if any), read from the generic node after executing
+a command. Hex reply bytes will be returned, *whether or not* they came from
+the immediately previous command.
diff --git a/arch/mips/configs/db1300_defconfig b/arch/mips/configs/db1300_defconfig
index c38b190..3590ab5 100644
--- a/arch/mips/configs/db1300_defconfig
+++ b/arch/mips/configs/db1300_defconfig
@@ -133,7 +133,7 @@ CONFIG_BLK_DEV_BSG=y
 CONFIG_IOSCHED_NOOP=y
 CONFIG_DEFAULT_NOOP=y
 CONFIG_DEFAULT_IOSCHED="noop"
-CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_UNINLINE_SPIN_UNLOCK is not set
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
 CONFIG_INLINE_READ_UNLOCK=y
 CONFIG_INLINE_READ_UNLOCK_IRQ=y
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 2bf18059f..119db67 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -15,23 +15,28 @@ CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
-CONFIG_UTS_NS=y
-CONFIG_IPC_NS=y
-CONFIG_USER_NS=y
-CONFIG_PID_NS=y
-CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_KPROBES=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_OSF_PARTITION=y
+CONFIG_AMIGA_PARTITION=y
+CONFIG_MAC_PARTITION=y
+CONFIG_BSD_DISKLABEL=y
+CONFIG_MINIX_SUBPARTITION=y
+CONFIG_SOLARIS_X86_PARTITION=y
+CONFIG_UNIXWARE_DISKLABEL=y
+CONFIG_SGI_PARTITION=y
+CONFIG_SUN_PARTITION=y
+CONFIG_KARMA_PARTITION=y
+CONFIG_EFI_PARTITION=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_SMP=y
-CONFIG_SPARSE_IRQ=y
 CONFIG_X86_GENERIC=y
 CONFIG_HPET_TIMER=y
 CONFIG_SCHED_SMT=y
@@ -51,14 +56,12 @@ CONFIG_HZ_1000=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
 # CONFIG_COMPAT_VDSO is not set
-CONFIG_PM=y
+CONFIG_HIBERNATION=y
 CONFIG_PM_DEBUG=y
 CONFIG_PM_TRACE_RTC=y
-CONFIG_HIBERNATION=y
 CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_DOCK=y
 CONFIG_CPU_FREQ=y
-CONFIG_CPU_FREQ_DEBUG=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
@@ -69,7 +72,6 @@ CONFIG_PCI_MSI=y
 CONFIG_PCCARD=y
 CONFIG_YENTA=y
 CONFIG_HOTPLUG_PCI=y
-CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_BINFMT_MISC=y
 CONFIG_NET=y
 CONFIG_PACKET=y
@@ -120,7 +122,6 @@ CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_TARGET_REJECT=y
-CONFIG_IP_NF_TARGET_LOG=y
 CONFIG_IP_NF_TARGET_ULOG=y
 CONFIG_NF_NAT=y
 CONFIG_IP_NF_TARGET_MASQUERADE=y
@@ -128,7 +129,6 @@ CONFIG_IP_NF_MANGLE=y
 CONFIG_NF_CONNTRACK_IPV6=y
 CONFIG_IP6_NF_IPTABLES=y
 CONFIG_IP6_NF_MATCH_IPV6HEADER=y
-CONFIG_IP6_NF_TARGET_LOG=y
 CONFIG_IP6_NF_FILTER=y
 CONFIG_IP6_NF_TARGET_REJECT=y
 CONFIG_IP6_NF_MANGLE=y
@@ -169,25 +169,20 @@ CONFIG_DM_ZERO=y
 CONFIG_MACINTOSH_DRIVERS=y
 CONFIG_MAC_EMUMOUSEBTN=y
 CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
-CONFIG_NET_VENDOR_3COM=y
+CONFIG_NETCONSOLE=y
+CONFIG_BNX2=y
+CONFIG_TIGON3=y
 CONFIG_NET_TULIP=y
-CONFIG_NET_PCI=y
-CONFIG_FORCEDETH=y
 CONFIG_E100=y
+CONFIG_E1000=y
+CONFIG_E1000E=y
+CONFIG_SKY2=y
 CONFIG_NE2K_PCI=y
+CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 # CONFIG_8139TOO_PIO is not set
-CONFIG_E1000=y
-CONFIG_E1000E=y
 CONFIG_R8169=y
-CONFIG_SKY2=y
-CONFIG_TIGON3=y
-CONFIG_BNX2=y
-CONFIG_TR=y
-CONFIG_NET_PCMCIA=y
 CONFIG_FDDI=y
-CONFIG_NETCONSOLE=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
@@ -196,6 +191,7 @@ CONFIG_INPUT_TABLET=y
 CONFIG_INPUT_TOUCHSCREEN=y
 CONFIG_INPUT_MISC=y
 CONFIG_VT_HW_CONSOLE_BINDING=y
+# CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_NONSTANDARD=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
@@ -205,7 +201,6 @@ CONFIG_SERIAL_8250_MANY_PORTS=y
 CONFIG_SERIAL_8250_SHARE_IRQ=y
 CONFIG_SERIAL_8250_DETECT_IRQ=y
 CONFIG_SERIAL_8250_RSA=y
-# CONFIG_LEGACY_PTYS is not set
 CONFIG_HW_RANDOM=y
 CONFIG_NVRAM=y
 CONFIG_HPET=y
@@ -220,7 +215,6 @@ CONFIG_DRM_I915=y
 CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_TILEBLITTING=y
 CONFIG_FB_EFI=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_LOGO=y
@@ -283,7 +277,6 @@ CONFIG_ZISOFS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
-CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_NFS_FS=y
@@ -291,18 +284,6 @@ CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_OSF_PARTITION=y
-CONFIG_AMIGA_PARTITION=y
-CONFIG_MAC_PARTITION=y
-CONFIG_BSD_DISKLABEL=y
-CONFIG_MINIX_SUBPARTITION=y
-CONFIG_SOLARIS_X86_PARTITION=y
-CONFIG_UNIXWARE_DISKLABEL=y
-CONFIG_SGI_PARTITION=y
-CONFIG_SUN_PARTITION=y
-CONFIG_KARMA_PARTITION=y
-CONFIG_EFI_PARTITION=y
 CONFIG_NLS_DEFAULT="utf8"
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
@@ -317,13 +298,12 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
-CONFIG_DEBUG_STACK_USAGE=y
 # CONFIG_DEBUG_RODATA_TEST is not set
 CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 058a35b..76eb290 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1,4 +1,3 @@
-CONFIG_64BIT=y
 CONFIG_EXPERIMENTAL=y
 # CONFIG_LOCALVERSION_AUTO is not set
 CONFIG_SYSVIPC=y
@@ -16,26 +15,29 @@ CONFIG_CPUSETS=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 CONFIG_CGROUP_SCHED=y
-CONFIG_UTS_NS=y
-CONFIG_IPC_NS=y
-CONFIG_USER_NS=y
-CONFIG_PID_NS=y
-CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_KALLSYMS_EXTRA_PASS=y
 # CONFIG_COMPAT_BRK is not set
 CONFIG_PROFILING=y
 CONFIG_KPROBES=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_OSF_PARTITION=y
+CONFIG_AMIGA_PARTITION=y
+CONFIG_MAC_PARTITION=y
+CONFIG_BSD_DISKLABEL=y
+CONFIG_MINIX_SUBPARTITION=y
+CONFIG_SOLARIS_X86_PARTITION=y
+CONFIG_UNIXWARE_DISKLABEL=y
+CONFIG_SGI_PARTITION=y
+CONFIG_SUN_PARTITION=y
+CONFIG_KARMA_PARTITION=y
+CONFIG_EFI_PARTITION=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_SMP=y
-CONFIG_SPARSE_IRQ=y
 CONFIG_CALGARY_IOMMU=y
-CONFIG_AMD_IOMMU=y
-CONFIG_AMD_IOMMU_STATS=y
 CONFIG_NR_CPUS=64
 CONFIG_SCHED_SMT=y
 CONFIG_PREEMPT_VOLUNTARY=y
@@ -53,27 +55,22 @@ CONFIG_HZ_1000=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
 # CONFIG_COMPAT_VDSO is not set
-CONFIG_PM=y
+CONFIG_HIBERNATION=y
 CONFIG_PM_DEBUG=y
 CONFIG_PM_TRACE_RTC=y
-CONFIG_HIBERNATION=y
 CONFIG_ACPI_PROCFS=y
 CONFIG_ACPI_DOCK=y
 CONFIG_CPU_FREQ=y
-CONFIG_CPU_FREQ_DEBUG=y
 # CONFIG_CPU_FREQ_STAT is not set
 CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
 CONFIG_CPU_FREQ_GOV_ONDEMAND=y
 CONFIG_X86_ACPI_CPUFREQ=y
 CONFIG_PCI_MMCONFIG=y
-CONFIG_INTEL_IOMMU=y
-# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
 CONFIG_PCIEPORTBUS=y
 CONFIG_PCCARD=y
 CONFIG_YENTA=y
 CONFIG_HOTPLUG_PCI=y
-CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
 CONFIG_BINFMT_MISC=y
 CONFIG_IA32_EMULATION=y
 CONFIG_NET=y
@@ -125,7 +122,6 @@ CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_TARGET_REJECT=y
-CONFIG_IP_NF_TARGET_LOG=y
 CONFIG_IP_NF_TARGET_ULOG=y
 CONFIG_NF_NAT=y
 CONFIG_IP_NF_TARGET_MASQUERADE=y
@@ -133,7 +129,6 @@ CONFIG_IP_NF_MANGLE=y
 CONFIG_NF_CONNTRACK_IPV6=y
 CONFIG_IP6_NF_IPTABLES=y
 CONFIG_IP6_NF_MATCH_IPV6HEADER=y
-CONFIG_IP6_NF_TARGET_LOG=y
 CONFIG_IP6_NF_FILTER=y
 CONFIG_IP6_NF_TARGET_REJECT=y
 CONFIG_IP6_NF_MANGLE=y
@@ -172,20 +167,15 @@ CONFIG_DM_ZERO=y
 CONFIG_MACINTOSH_DRIVERS=y
 CONFIG_MAC_EMUMOUSEBTN=y
 CONFIG_NETDEVICES=y
-CONFIG_NET_ETHERNET=y
-CONFIG_NET_VENDOR_3COM=y
+CONFIG_NETCONSOLE=y
+CONFIG_TIGON3=y
 CONFIG_NET_TULIP=y
-CONFIG_NET_PCI=y
-CONFIG_FORCEDETH=y
 CONFIG_E100=y
-CONFIG_8139TOO=y
 CONFIG_E1000=y
 CONFIG_SKY2=y
-CONFIG_TIGON3=y
-CONFIG_TR=y
-CONFIG_NET_PCMCIA=y
+CONFIG_FORCEDETH=y
+CONFIG_8139TOO=y
 CONFIG_FDDI=y
-CONFIG_NETCONSOLE=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
@@ -194,6 +184,7 @@ CONFIG_INPUT_TABLET=y
 CONFIG_INPUT_TOUCHSCREEN=y
 CONFIG_INPUT_MISC=y
 CONFIG_VT_HW_CONSOLE_BINDING=y
+# CONFIG_LEGACY_PTYS is not set
 CONFIG_SERIAL_NONSTANDARD=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
@@ -203,7 +194,6 @@ CONFIG_SERIAL_8250_MANY_PORTS=y
 CONFIG_SERIAL_8250_SHARE_IRQ=y
 CONFIG_SERIAL_8250_DETECT_IRQ=y
 CONFIG_SERIAL_8250_RSA=y
-# CONFIG_LEGACY_PTYS is not set
 CONFIG_HW_RANDOM=y
 # CONFIG_HW_RANDOM_INTEL is not set
 # CONFIG_HW_RANDOM_AMD is not set
@@ -221,7 +211,6 @@ CONFIG_DRM_I915_KMS=y
 CONFIG_FB_MODE_HELPERS=y
 CONFIG_FB_TILEBLITTING=y
 CONFIG_FB_EFI=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
 CONFIG_VGACON_SOFT_SCROLLBACK=y
 CONFIG_LOGO=y
@@ -268,6 +257,10 @@ CONFIG_RTC_CLASS=y
 # CONFIG_RTC_HCTOSYS is not set
 CONFIG_DMADEVICES=y
 CONFIG_EEEPC_LAPTOP=y
+CONFIG_AMD_IOMMU=y
+CONFIG_AMD_IOMMU_STATS=y
+CONFIG_INTEL_IOMMU=y
+# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
 CONFIG_EFI_VARS=y
 CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
@@ -284,7 +277,6 @@ CONFIG_ZISOFS=y
 CONFIG_MSDOS_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_PROC_KCORE=y
-CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_NFS_FS=y
@@ -292,18 +284,6 @@ CONFIG_NFS_V3=y
 CONFIG_NFS_V3_ACL=y
 CONFIG_NFS_V4=y
 CONFIG_ROOT_NFS=y
-CONFIG_PARTITION_ADVANCED=y
-CONFIG_OSF_PARTITION=y
-CONFIG_AMIGA_PARTITION=y
-CONFIG_MAC_PARTITION=y
-CONFIG_BSD_DISKLABEL=y
-CONFIG_MINIX_SUBPARTITION=y
-CONFIG_SOLARIS_X86_PARTITION=y
-CONFIG_UNIXWARE_DISKLABEL=y
-CONFIG_SGI_PARTITION=y
-CONFIG_SUN_PARTITION=y
-CONFIG_KARMA_PARTITION=y
-CONFIG_EFI_PARTITION=y
 CONFIG_NLS_DEFAULT="utf8"
 CONFIG_NLS_CODEPAGE_437=y
 CONFIG_NLS_ASCII=y
@@ -317,13 +297,12 @@ CONFIG_DEBUG_KERNEL=y
 # CONFIG_SCHED_DEBUG is not set
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
-# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
 CONFIG_BLK_DEV_IO_TRACE=y
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
 CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
-CONFIG_DEBUG_STACK_USAGE=y
 # CONFIG_DEBUG_RODATA_TEST is not set
 CONFIG_DEBUG_NX_TEST=m
 CONFIG_DEBUG_BOOT_PARAMS=y
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a9371c9..d3eaac4 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -535,7 +535,7 @@ static inline unsigned int read_apic_id(void)
 
 static inline int default_apic_id_valid(int apicid)
 {
-	return x2apic_mode || (apicid < 255);
+	return (apicid < 255);
 }
 
 extern void default_setup_apic_routing(void);
diff --git a/arch/x86/include/asm/idle.h b/arch/x86/include/asm/idle.h
index f49253d7..c5d1785 100644
--- a/arch/x86/include/asm/idle.h
+++ b/arch/x86/include/asm/idle.h
@@ -14,6 +14,7 @@ void exit_idle(void);
 #else /* !CONFIG_X86_64 */
 static inline void enter_idle(void) { }
 static inline void exit_idle(void) { }
+static inline void __exit_idle(void) { }
 #endif /* CONFIG_X86_64 */
 
 void amd_e400_remove_cpu(int cpu);
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 690d1cc..2c4943d 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -21,6 +21,15 @@
 #define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
 #define IO_APIC_REDIR_MASKED		(1 << 16)
 
+struct io_apic_ops {
+	void		(*init)  (void);
+	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
+	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+};
+
+void __init set_io_apic_ops(const struct io_apic_ops *);
+
 /*
  * The structure of the IO-APIC:
  */
diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
index 6bf5b8e..92e54ab 100644
--- a/arch/x86/include/asm/x2apic.h
+++ b/arch/x86/include/asm/x2apic.h
@@ -18,6 +18,11 @@ static const struct cpumask *x2apic_target_cpus(void)
 	return cpu_online_mask;
 }
 
+static int x2apic_apic_id_valid(int apicid)
+{
+	return 1;
+}
+
 static int x2apic_apic_id_registered(void)
 {
 	return 1;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 406ed77..0f42c2f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -239,7 +239,7 @@ acpi_parse_x2apic(struct acpi_subtable_header *header, const unsigned long end)
 	 * to not preallocating memory for all NR_CPUS
 	 * when we use CPU hotplug.
 	 */
-	if (!cpu_has_x2apic && (apic_id >= 0xff) && enabled)
+	if (!apic->apic_id_valid(apic_id) && enabled)
 		printk(KERN_WARNING PREFIX "x2apic entry ignored\n");
 	else
 		acpi_register_lapic(apic_id, enabled);
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 2eec05b..11544d8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -383,20 +383,25 @@ static inline int eilvt_entry_is_changeable(unsigned int old, unsigned int new)
 
 static unsigned int reserve_eilvt_offset(int offset, unsigned int new)
 {
-	unsigned int rsvd;			/* 0: uninitialized */
+	unsigned int rsvd, vector;
 
 	if (offset >= APIC_EILVT_NR_MAX)
 		return ~0;
 
-	rsvd = atomic_read(&eilvt_offsets[offset]) & ~APIC_EILVT_MASKED;
+	rsvd = atomic_read(&eilvt_offsets[offset]);
 	do {
-		if (rsvd &&
-		    !eilvt_entry_is_changeable(rsvd, new))
+		vector = rsvd & ~APIC_EILVT_MASKED;	/* 0: unassigned */
+		if (vector && !eilvt_entry_is_changeable(vector, new))
 			/* may not change if vectors are different */
 			return rsvd;
 		rsvd = atomic_cmpxchg(&eilvt_offsets[offset], rsvd, new);
 	} while (rsvd != new);
 
+	rsvd &= ~APIC_EILVT_MASKED;
+	if (rsvd && rsvd != vector)
+		pr_info("LVT offset %d assigned for vector 0x%02x\n",
+			offset, rsvd);
+
 	return new;
 }
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index d9ea5f3..899803e 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -229,11 +229,10 @@ static int __init numachip_system_init(void)
 }
 early_initcall(numachip_system_init);
 
-static int __cpuinit numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int numachip_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strncmp(oem_id, "NUMASC", 6)) {
 		numachip_system = 1;
-		setup_force_cpu_cap(X86_FEATURE_X2APIC);
 		return 1;
 	}
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6d10a66..e88300d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -64,9 +64,28 @@
 #include <asm/apic.h>
 
 #define __apicdebuginit(type) static type __init
+
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
+static void		__init __ioapic_init_mappings(void);
+
+static unsigned int	__io_apic_read  (unsigned int apic, unsigned int reg);
+static void		__io_apic_write (unsigned int apic, unsigned int reg, unsigned int val);
+static void		__io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
+
+static struct io_apic_ops io_apic_ops = {
+	.init	= __ioapic_init_mappings,
+	.read	= __io_apic_read,
+	.write	= __io_apic_write,
+	.modify = __io_apic_modify,
+};
+
+void __init set_io_apic_ops(const struct io_apic_ops *ops)
+{
+	io_apic_ops = *ops;
+}
+
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -294,6 +313,22 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
+static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+{
+	return io_apic_ops.read(apic, reg);
+}
+
+static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	io_apic_ops.write(apic, reg, value);
+}
+
+static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	io_apic_ops.modify(apic, reg, value);
+}
+
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -314,16 +349,17 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 	writel(vector, &io_apic->eoi);
 }
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+static unsigned int __io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
+
 	writel(reg, &io_apic->index);
 	writel(value, &io_apic->data);
 }
@@ -334,7 +370,7 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
  *
  * Older SiS APIC requires we rewrite the index register
  */
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -377,6 +413,7 @@ static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
 
 	eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
 	eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
+
 	return eu.entry;
 }
 
@@ -384,9 +421,11 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 {
 	union entry_union eu;
 	unsigned long flags;
+
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	eu.entry = __ioapic_read_entry(apic, pin);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
+
 	return eu.entry;
 }
 
@@ -396,8 +435,7 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
  * the interrupt, and we need to make sure the entry is fully populated
  * before that happens.
  */
-static void
-__ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
+static void __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	union entry_union eu = {{0, 0}};
 
@@ -409,6 +447,7 @@ __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 static void ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
 	unsigned long flags;
+
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	__ioapic_write_entry(apic, pin, e);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -435,8 +474,7 @@ static void ioapic_mask_entry(int apic, int pin)
  * shared ISA-space IRQs, so we have to support them. We are super
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
-static int
-__add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
+static int __add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
@@ -521,6 +559,7 @@ static void io_apic_sync(struct irq_pin_list *entry)
 	 * a dummy read from the IO-APIC
 	 */
 	struct io_apic __iomem *io_apic;
+
 	io_apic = io_apic_base(entry->apic);
 	readl(&io_apic->data);
 }
@@ -2512,21 +2551,73 @@ static void ack_apic_edge(struct irq_data *data)
 
 atomic_t irq_mis_count;
 
-static void ack_apic_level(struct irq_data *data)
-{
-	struct irq_cfg *cfg = data->chip_data;
-	int i, do_unmask_irq = 0, irq = data->irq;
-	unsigned long v;
-
-	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
+static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
+{
 	/* If we are moving the irq we need to mask it */
 	if (unlikely(irqd_is_setaffinity_pending(data))) {
-		do_unmask_irq = 1;
 		mask_ioapic(cfg);
+		return true;
 	}
+	return false;
+}
+
+static inline void ioapic_irqd_unmask(struct irq_data *data,
+				      struct irq_cfg *cfg, bool masked)
+{
+	if (unlikely(masked)) {
+		/* Only migrate the irq if the ack has been received.
+		 *
+		 * On rare occasions the broadcast level triggered ack gets
+		 * delayed going to ioapics, and if we reprogram the
+		 * vector while Remote IRR is still set the irq will never
+		 * fire again.
+		 *
+		 * To prevent this scenario we read the Remote IRR bit
+		 * of the ioapic.  This has two effects.
+		 * - On any sane system the read of the ioapic will
+		 *   flush writes (and acks) going to the ioapic from
+		 *   this cpu.
+		 * - We get to see if the ACK has actually been delivered.
+		 *
+		 * Based on failed experiments of reprogramming the
+		 * ioapic entry from outside of irq context starting
+		 * with masking the ioapic entry and then polling until
+		 * Remote IRR was clear before reprogramming the
+		 * ioapic I don't trust the Remote IRR bit to be
+		 * completey accurate.
+		 *
+		 * However there appears to be no other way to plug
+		 * this race, so if the Remote IRR bit is not
+		 * accurate and is causing problems then it is a hardware bug
+		 * and you can go talk to the chipset vendor about it.
+		 */
+		if (!io_apic_level_ack_pending(cfg))
+			irq_move_masked_irq(data);
+		unmask_ioapic(cfg);
+	}
+}
+#else
+static inline bool ioapic_irqd_mask(struct irq_data *data, struct irq_cfg *cfg)
+{
+	return false;
+}
+static inline void ioapic_irqd_unmask(struct irq_data *data,
+				      struct irq_cfg *cfg, bool masked)
+{
+}
 #endif
 
+static void ack_apic_level(struct irq_data *data)
+{
+	struct irq_cfg *cfg = data->chip_data;
+	int i, irq = data->irq;
+	unsigned long v;
+	bool masked;
+
+	irq_complete_move(cfg);
+	masked = ioapic_irqd_mask(data, cfg);
+
 	/*
 	 * It appears there is an erratum which affects at least version 0x11
 	 * of I/O APIC (that's the 82093AA and cores integrated into various
@@ -2581,38 +2672,7 @@ static void ack_apic_level(struct irq_data *data)
 		eoi_ioapic_irq(irq, cfg);
 	}
 
-	/* Now we can move and renable the irq */
-	if (unlikely(do_unmask_irq)) {
-		/* Only migrate the irq if the ack has been received.
-		 *
-		 * On rare occasions the broadcast level triggered ack gets
-		 * delayed going to ioapics, and if we reprogram the
-		 * vector while Remote IRR is still set the irq will never
-		 * fire again.
-		 *
-		 * To prevent this scenario we read the Remote IRR bit
-		 * of the ioapic.  This has two effects.
-		 * - On any sane system the read of the ioapic will
-		 *   flush writes (and acks) going to the ioapic from
-		 *   this cpu.
-		 * - We get to see if the ACK has actually been delivered.
-		 *
-		 * Based on failed experiments of reprogramming the
-		 * ioapic entry from outside of irq context starting
-		 * with masking the ioapic entry and then polling until
-		 * Remote IRR was clear before reprogramming the
-		 * ioapic I don't trust the Remote IRR bit to be
-		 * completey accurate.
-		 *
-		 * However there appears to be no other way to plug
-		 * this race, so if the Remote IRR bit is not
-		 * accurate and is causing problems then it is a hardware bug
-		 * and you can go talk to the chipset vendor about it.
-		 */
-		if (!io_apic_level_ack_pending(cfg))
-			irq_move_masked_irq(data);
-		unmask_ioapic(cfg);
-	}
+	ioapic_irqd_unmask(data, cfg, masked);
 }
 
 #ifdef CONFIG_IRQ_REMAP
@@ -3873,6 +3933,11 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 
 void __init ioapic_and_gsi_init(void)
 {
+	io_apic_ops.init();
+}
+
+static void __init __ioapic_init_mappings(void)
+{
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
 	int i;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 9193713..48f3103 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -213,7 +213,7 @@ static struct apic apic_x2apic_cluster = {
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
-	.apic_id_valid			= default_apic_id_valid,
+	.apic_id_valid			= x2apic_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_LowestPrio,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index bcd1db6..8a778db 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -119,7 +119,7 @@ static struct apic apic_x2apic_phys = {
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
-	.apic_id_valid			= default_apic_id_valid,
+	.apic_id_valid			= x2apic_apic_id_valid,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index fc47714..87bfa69 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -266,6 +266,11 @@ static void uv_send_IPI_all(int vector)
 	uv_send_IPI_mask(cpu_online_mask, vector);
 }
 
+static int uv_apic_id_valid(int apicid)
+{
+	return 1;
+}
+
 static int uv_apic_id_registered(void)
 {
 	return 1;
@@ -351,7 +356,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.name				= "UV large system",
 	.probe				= uv_probe,
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
-	.apic_id_valid			= default_apic_id_valid,
+	.apic_id_valid			= uv_apic_id_valid,
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.irq_delivery_mode		= dest_Fixed,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index ade9c79..b240323 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -998,7 +998,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else
 		printk(KERN_CONT "\n");
 
-	__print_cpu_msr();
+	print_cpu_msr(c);
 }
 
 void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 4025fe4..90bf130 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -37,13 +37,16 @@ print_ftrace_graph_addr(unsigned long addr, void *data,
 			const struct stacktrace_ops *ops,
 			struct thread_info *tinfo, int *graph)
 {
-	struct task_struct *task = tinfo->task;
+	struct task_struct *task;
 	unsigned long ret_addr;
-	int index = task->curr_ret_stack;
+	int index;
 
 	if (addr != (unsigned long)return_to_handler)
 		return;
 
+	task = tinfo->task;
+	index = task->curr_ret_stack;
+
 	if (!task->ret_stack || index < *graph)
 		return;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14baf78..29309c4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -12,6 +12,9 @@
 #include <linux/user-return-notifier.h>
 #include <linux/dmi.h>
 #include <linux/utsname.h>
+#include <linux/stackprotector.h>
+#include <linux/tick.h>
+#include <linux/cpuidle.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
@@ -23,6 +26,24 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/debugreg.h>
+#include <asm/nmi.h>
+
+#ifdef CONFIG_X86_64
+static DEFINE_PER_CPU(unsigned char, is_idle);
+static ATOMIC_NOTIFIER_HEAD(idle_notifier);
+
+void idle_notifier_register(struct notifier_block *n)
+{
+	atomic_notifier_chain_register(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_register);
+
+void idle_notifier_unregister(struct notifier_block *n)
+{
+	atomic_notifier_chain_unregister(&idle_notifier, n);
+}
+EXPORT_SYMBOL_GPL(idle_notifier_unregister);
+#endif
 
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
@@ -371,6 +392,99 @@ static inline int hlt_use_halt(void)
 }
 #endif
 
+#ifndef CONFIG_SMP
+static inline void play_dead(void)
+{
+	BUG();
+}
+#endif
+
+#ifdef CONFIG_X86_64
+void enter_idle(void)
+{
+	percpu_write(is_idle, 1);
+	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
+}
+
+static void __exit_idle(void)
+{
+	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
+		return;
+	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
+}
+
+/* Called from interrupts to signify idle end */
+void exit_idle(void)
+{
+	/* idle loop has pid 0 */
+	if (current->pid)
+		return;
+	__exit_idle();
+}
+#endif
+
+/*
+ * The idle thread. There's no useful work to be
+ * done, so just try to conserve power and have a
+ * low exit latency (ie sit in a loop waiting for
+ * somebody to say that they'd like to reschedule)
+ */
+void cpu_idle(void)
+{
+	/*
+	 * If we're the non-boot CPU, nothing set the stack canary up
+	 * for us.  CPU0 already has it initialized but no harm in
+	 * doing it again.  This is a good place for updating it, as
+	 * we wont ever return from this function (so the invalid
+	 * canaries already on the stack wont ever trigger).
+	 */
+	boot_init_stack_canary();
+	current_thread_info()->status |= TS_POLLING;
+
+	while (1) {
+		tick_nohz_idle_enter();
+
+		while (!need_resched()) {
+			rmb();
+
+			if (cpu_is_offline(smp_processor_id()))
+				play_dead();
+
+			/*
+			 * Idle routines should keep interrupts disabled
+			 * from here on, until they go to idle.
+			 * Otherwise, idle callbacks can misfire.
+			 */
+			local_touch_nmi();
+			local_irq_disable();
+
+			enter_idle();
+
+			/* Don't trace irqs off for idle */
+			stop_critical_timings();
+
+			/* enter_idle() needs rcu for notifiers */
+			rcu_idle_enter();
+
+			if (cpuidle_idle_call())
+				pm_idle();
+
+			rcu_idle_exit();
+			start_critical_timings();
+
+			/* In many cases the interrupt that ended idle
+			   has already called exit_idle. But some idle
+			   loops can be woken up without interrupt. */
+			__exit_idle();
+		}
+
+		tick_nohz_idle_exit();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
+	}
+}
+
 /*
  * We use this if we don't have any better
  * idle routine..
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9d7d484..ea207c2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -9,7 +9,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -31,14 +30,12 @@
 #include <linux/kallsyms.h>
 #include <linux/ptrace.h>
 #include <linux/personality.h>
-#include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/kdebug.h>
-#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -58,7 +55,6 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-#include <asm/nmi.h>
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -70,60 +66,6 @@ unsigned long thread_saved_pc(struct task_struct *tsk)
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-#ifndef CONFIG_SMP
-static inline void play_dead(void)
-{
-	BUG();
-}
-#endif
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	int cpu = smp_processor_id();
-
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
-	current_thread_info()->status |= TS_POLLING;
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		rcu_idle_enter();
-		while (!need_resched()) {
-
-			check_pgt_cache();
-			rmb();
-
-			if (cpu_is_offline(cpu))
-				play_dead();
-
-			local_touch_nmi();
-			local_irq_disable();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-			if (cpuidle_idle_call())
-				pm_idle();
-			start_critical_timings();
-		}
-		rcu_idle_exit();
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
-
 void __show_regs(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 292da13..ce5e34f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -14,7 +14,6 @@
  * This file handles the architecture-dependent parts of process handling..
  */
 
-#include <linux/stackprotector.h>
 #include <linux/cpu.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -32,12 +31,10 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
-#include <linux/tick.h>
 #include <linux/prctl.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/ftrace.h>
-#include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
 #include <asm/system.h>
@@ -52,114 +49,10 @@
 #include <asm/idle.h>
 #include <asm/syscalls.h>
 #include <asm/debugreg.h>
-#include <asm/nmi.h>
 
 asmlinkage extern void ret_from_fork(void);
 
 DEFINE_PER_CPU(unsigned long, old_rsp);
-static DEFINE_PER_CPU(unsigned char, is_idle);
-
-static ATOMIC_NOTIFIER_HEAD(idle_notifier);
-
-void idle_notifier_register(struct notifier_block *n)
-{
-	atomic_notifier_chain_register(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_register);
-
-void idle_notifier_unregister(struct notifier_block *n)
-{
-	atomic_notifier_chain_unregister(&idle_notifier, n);
-}
-EXPORT_SYMBOL_GPL(idle_notifier_unregister);
-
-void enter_idle(void)
-{
-	percpu_write(is_idle, 1);
-	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
-}
-
-static void __exit_idle(void)
-{
-	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
-		return;
-	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
-}
-
-/* Called from interrupts to signify idle end */
-void exit_idle(void)
-{
-	/* idle loop has pid 0 */
-	if (current->pid)
-		return;
-	__exit_idle();
-}
-
-#ifndef CONFIG_SMP
-static inline void play_dead(void)
-{
-	BUG();
-}
-#endif
-
-/*
- * The idle thread. There's no useful work to be
- * done, so just try to conserve power and have a
- * low exit latency (ie sit in a loop waiting for
- * somebody to say that they'd like to reschedule)
- */
-void cpu_idle(void)
-{
-	current_thread_info()->status |= TS_POLLING;
-
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
-	/* endless idle loop with no priority at all */
-	while (1) {
-		tick_nohz_idle_enter();
-		while (!need_resched()) {
-
-			rmb();
-
-			if (cpu_is_offline(smp_processor_id()))
-				play_dead();
-			/*
-			 * Idle routines should keep interrupts disabled
-			 * from here on, until they go to idle.
-			 * Otherwise, idle callbacks can misfire.
-			 */
-			local_touch_nmi();
-			local_irq_disable();
-			enter_idle();
-			/* Don't trace irqs off for idle */
-			stop_critical_timings();
-
-			/* enter_idle() needs rcu for notifiers */
-			rcu_idle_enter();
-
-			if (cpuidle_idle_call())
-				pm_idle();
-
-			rcu_idle_exit();
-			start_critical_timings();
-
-			/* In many cases the interrupt that ended idle
-			   has already called exit_idle. But some idle
-			   loops can be woken up without interrupt. */
-			__exit_idle();
-		}
-
-		tick_nohz_idle_exit();
-		schedule_preempt_disabled();
-	}
-}
 
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs *regs, int all)
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..bcfec2d 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -163,7 +163,7 @@ int regset_tls_get(struct task_struct *target, const struct user_regset *regset,
 {
 	const struct desc_struct *tls;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
@@ -198,7 +198,7 @@ int regset_tls_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_desc infobuf[GDT_ENTRY_TLS_ENTRIES];
 	const struct user_desc *info;
 
-	if (pos > GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
+	if (pos >= GDT_ENTRY_TLS_ENTRIES * sizeof(struct user_desc) ||
 	    (pos % sizeof(struct user_desc)) != 0 ||
 	    (count % sizeof(struct user_desc)) != 0)
 		return -EINVAL;
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1c1c4f4..efb5b4b 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -70,7 +70,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 		return;
 	pxm = pa->proximity_domain;
 	apic_id = pa->apic_id;
-	if (!cpu_has_x2apic && (apic_id >= 0xff)) {
+	if (!apic->apic_id_valid(apic_id)) {
 		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
 			 pxm, apic_id);
 		return;
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index 7cce722..a4bee53 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -20,6 +20,8 @@
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/syscore_ops.h>
+#include <linux/debugfs.h>
+#include <linux/mutex.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -31,6 +33,15 @@ EXPORT_SYMBOL_GPL(olpc_platform_info);
 
 static DEFINE_SPINLOCK(ec_lock);
 
+/* debugfs interface to EC commands */
+#define EC_MAX_CMD_ARGS (5 + 1)	/* cmd byte + 5 args */
+#define EC_MAX_CMD_REPLY (8)
+
+static struct dentry *ec_debugfs_dir;
+static DEFINE_MUTEX(ec_debugfs_cmd_lock);
+static unsigned char ec_debugfs_resp[EC_MAX_CMD_REPLY];
+static unsigned int ec_debugfs_resp_bytes;
+
 /* EC event mask to be applied during suspend (defining wakeup sources). */
 static u16 ec_wakeup_mask;
 
@@ -269,6 +280,91 @@ int olpc_ec_sci_query(u16 *sci_value)
 }
 EXPORT_SYMBOL_GPL(olpc_ec_sci_query);
 
+static ssize_t ec_debugfs_cmd_write(struct file *file, const char __user *buf,
+				    size_t size, loff_t *ppos)
+{
+	int i, m;
+	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
+	unsigned int ec_cmd_int[EC_MAX_CMD_ARGS];
+	char cmdbuf[64];
+	int ec_cmd_bytes;
+
+	mutex_lock(&ec_debugfs_cmd_lock);
+
+	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);
+
+	m = sscanf(cmdbuf, "%x:%u %x %x %x %x %x", &ec_cmd_int[0],
+		   &ec_debugfs_resp_bytes,
+		   &ec_cmd_int[1], &ec_cmd_int[2], &ec_cmd_int[3],
+		   &ec_cmd_int[4], &ec_cmd_int[5]);
+	if (m < 2 || ec_debugfs_resp_bytes > EC_MAX_CMD_REPLY) {
+		/* reset to prevent overflow on read */
+		ec_debugfs_resp_bytes = 0;
+
+		printk(KERN_DEBUG "olpc-ec: bad ec cmd:  "
+		       "cmd:response-count [arg1 [arg2 ...]]\n");
+		size = -EINVAL;
+		goto out;
+	}
+
+	/* convert scanf'd ints to char */
+	ec_cmd_bytes = m - 2;
+	for (i = 0; i <= ec_cmd_bytes; i++)
+		ec_cmd[i] = ec_cmd_int[i];
+
+	printk(KERN_DEBUG "olpc-ec: debugfs cmd 0x%02x with %d args "
+	       "%02x %02x %02x %02x %02x, want %d returns\n",
+	       ec_cmd[0], ec_cmd_bytes, ec_cmd[1], ec_cmd[2], ec_cmd[3],
+	       ec_cmd[4], ec_cmd[5], ec_debugfs_resp_bytes);
+
+	olpc_ec_cmd(ec_cmd[0], (ec_cmd_bytes == 0) ? NULL : &ec_cmd[1],
+		    ec_cmd_bytes, ec_debugfs_resp, ec_debugfs_resp_bytes);
+
+	printk(KERN_DEBUG "olpc-ec: response "
+	       "%02x %02x %02x %02x %02x %02x %02x %02x (%d bytes expected)\n",
+	       ec_debugfs_resp[0], ec_debugfs_resp[1], ec_debugfs_resp[2],
+	       ec_debugfs_resp[3], ec_debugfs_resp[4], ec_debugfs_resp[5],
+	       ec_debugfs_resp[6], ec_debugfs_resp[7], ec_debugfs_resp_bytes);
+
+out:
+	mutex_unlock(&ec_debugfs_cmd_lock);
+	return size;
+}
+
+static ssize_t ec_debugfs_cmd_read(struct file *file, char __user *buf,
+				   size_t size, loff_t *ppos)
+{
+	unsigned int i, r;
+	char *rp;
+	char respbuf[64];
+
+	mutex_lock(&ec_debugfs_cmd_lock);
+	rp = respbuf;
+	rp += sprintf(rp, "%02x", ec_debugfs_resp[0]);
+	for (i = 1; i < ec_debugfs_resp_bytes; i++)
+		rp += sprintf(rp, ", %02x", ec_debugfs_resp[i]);
+	mutex_unlock(&ec_debugfs_cmd_lock);
+	rp += sprintf(rp, "\n");
+
+	r = rp - respbuf;
+	return simple_read_from_buffer(buf, size, ppos, respbuf, r);
+}
+
+static const struct file_operations ec_debugfs_genops = {
+	.write	 = ec_debugfs_cmd_write,
+	.read	 = ec_debugfs_cmd_read,
+};
+
+static void setup_debugfs(void)
+{
+	ec_debugfs_dir = debugfs_create_dir("olpc-ec", 0);
+	if (ec_debugfs_dir == ERR_PTR(-ENODEV))
+		return;
+
+	debugfs_create_file("cmd", 0600, ec_debugfs_dir, NULL,
+			    &ec_debugfs_genops);
+}
+
 static int olpc_ec_suspend(void)
 {
 	return olpc_ec_mask_write(ec_wakeup_mask);
@@ -372,6 +468,7 @@ static int __init olpc_init(void)
 	}
 
 	register_syscore_ops(&olpc_syscore_ops);
+	setup_debugfs();
 
 	return 0;
 }
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index f932b30..ddab37b 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -113,7 +113,7 @@ CONFIG_DEFAULT_IOSCHED="noop"
 # CONFIG_INLINE_SPIN_LOCK_BH is not set
 # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
 # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
-CONFIG_INLINE_SPIN_UNLOCK=y
+# CONFIG_UNINLINE_SPIN_UNLOCK is not set
 # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
 CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
 # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index e253ccd..51df117 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -67,7 +67,7 @@ _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 #define _raw_spin_trylock_bh(lock) __raw_spin_trylock_bh(lock)
 #endif
 
-#ifdef CONFIG_INLINE_SPIN_UNLOCK
+#ifndef CONFIG_UNINLINE_SPIN_UNLOCK
 #define _raw_spin_unlock(lock) __raw_spin_unlock(lock)
 #endif
 
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 5068e2a..2251882 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -124,8 +124,8 @@ config INLINE_SPIN_LOCK_IRQSAVE
 	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
 		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
 
-config INLINE_SPIN_UNLOCK
-	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK)
+config UNINLINE_SPIN_UNLOCK
+	bool
 
 config INLINE_SPIN_UNLOCK_BH
 	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 24e7cb0..3f9c974 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -36,6 +36,7 @@ config PREEMPT_VOLUNTARY
 config PREEMPT
 	bool "Preemptible Kernel (Low-Latency Desktop)"
 	select PREEMPT_COUNT
+	select UNINLINE_SPIN_UNLOCK if !ARCH_INLINE_SPIN_UNLOCK
 	help
 	  This option reduces the latency of the kernel by making
 	  all kernel code (that is not executing in a critical section)
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 84c7d96..5cdd806 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -163,7 +163,7 @@ void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
 EXPORT_SYMBOL(_raw_spin_lock_bh);
 #endif
 
-#ifndef CONFIG_INLINE_SPIN_UNLOCK
+#ifdef CONFIG_UNINLINE_SPIN_UNLOCK
 void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 {
 	__raw_spin_unlock(lock);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 05037dc..f32a41f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -499,6 +499,7 @@ config RT_MUTEX_TESTER
 config DEBUG_SPINLOCK
 	bool "Spinlock and rw-lock debugging: basic checks"
 	depends on DEBUG_KERNEL
+	select UNINLINE_SPIN_UNLOCK
 	help
 	  Say Y here and build SMP to catch missing spinlock initialization
 	  and certain other kinds of spinlock errors commonly made.  This is

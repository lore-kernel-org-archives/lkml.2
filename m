Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab0E2DwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:52:15 -0400
Received: from king.tilera.com ([72.1.168.226]:16223 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288Ab0E2DwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:52:07 -0400
Message-Id: <201005290351.o4T3pxLU031493@farm-0002.internal.tilera.com>
In-Reply-To: <dVZMmBu$KHA.5388@exchange1.tad.internal.tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 28 May 2010 23:20:03 -0400
Subject: Re: [PATCH 0/8] revised patch for arch/tile/ support
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, torvalds@linux-foundation.org
X-OriginalArrivalTime: 29 May 2010 03:52:01.0538 (UTC) FILETIME=[4B731E20:01CAFEE2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann suggested that providing a diff of what has changed
between the two "arch/tile" patch sets would be helpful to the reviewers.

The "hvglue.ld" file was renamed, but I didn't bother to include it in
the diff otherwise, since all that changed was the addition of a comment
at the top.  A new "spinlock_common.h" is included in the diff.

diff -ru tile.old/Kbuild tile/Kbuild
--- tile.old/Kbuild	2010-05-28 18:03:30.805351000 -0400
+++ tile/Kbuild	2010-05-28 23:07:06.099173000 -0400
@@ -1,4 +1,3 @@
 
 obj-y += kernel/
 obj-y += mm/
-obj-y += feedback/
diff -ru tile.old/Kconfig tile/Kconfig
--- tile.old/Kconfig	2010-05-28 18:03:30.834316000 -0400
+++ tile/Kconfig	2010-05-28 23:07:04.674403000 -0400
@@ -1,9 +1,70 @@
 # For a description of the syntax of this configuration file,
 # see Documentation/kbuild/config-language.txt.
 
-mainmenu "Linux/TILE Kernel Configuration"
+config MMU
+	def_bool y
+
+config GENERIC_CSUM
+	def_bool y
+
+config GENERIC_HARDIRQS
+	def_bool y
+
+config GENERIC_HARDIRQS_NO__DO_IRQ
+	def_bool y
+
+config GENERIC_IRQ_PROBE
+	def_bool y
+
+config GENERIC_PENDING_IRQ
+	def_bool y
+	depends on GENERIC_HARDIRQS && SMP
+
+config ZONE_DMA
+	def_bool y
+
+config SEMAPHORE_SLEEPERS
+	def_bool y
+
+config CC_OPTIMIZE_FOR_SIZE
+	def_bool y
+
+config HAVE_ARCH_ALLOC_REMAP
+	def_bool y
+
+config HAVE_SETUP_PER_CPU_AREA
+	def_bool y
+
+config NEED_PER_CPU_PAGE_FIRST_CHUNK
+        def_bool y
+
+config SYS_SUPPORTS_HUGETLBFS
+	def_bool y
+
+config GENERIC_TIME
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config CLOCKSOURCE_WATCHDOG
+	def_bool y
+
+# FIXME: tilegx can implement a more efficent rwsem.
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+# We have a very flat architecture from a migration point of view,
+# so save boot time by presetting this (particularly useful on tile-sim).
+config DEFAULT_MIGRATION_COST
+	int
+	default "10000000"
 
-config GENERIC_CALIBRATE_DELAY
+# We only support gcc 4.4 and above, so this should work.
+config ARCH_SUPPORTS_OPTIMIZED_INLINING
+	def_bool y
+
+config ARCH_PHYS_ADDR_T_64BIT
 	def_bool y
 
 config LOCKDEP_SUPPORT
@@ -13,26 +74,62 @@
 	def_bool y
 	select STACKTRACE
 
+config ARCH_DISCONTIGMEM_ENABLE
+	def_bool y
+
+config ARCH_DISCONTIGMEM_DEFAULT
+	def_bool y
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
+
+config STRICT_DEVMEM
+	def_bool y
+
+# SMP is required for Tilera Linux.
+config SMP
+	def_bool y
+
+# Allow checking for compile-time determined overflow errors in
+# copy_from_user().  There are still unprovable places in the
+# generic code as of 2.6.34, so this option is not really compatible
+# with -Werror, which is more useful in general.
+config DEBUG_COPY_FROM_USER
+	def_bool n
+
+config SERIAL_CONSOLE
+	def_bool y
+
+config HVC_TILE
+	select HVC_DRIVER
+	def_bool y
+
 config TILE
 	def_bool y
-	select HAVE_OPROFILE
-	select HAVE_IDE
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_FIND_NEXT_BIT
 	select RESOURCES_64BIT
 	select USE_GENERIC_SMP_HELPERS
 
 # FIXME: investigate whether we need/want these options.
-#	select HAVE_GENERIC_DMA_COHERENT
-#	select HAVE_DMA_ATTRS
 #	select HAVE_IOREMAP_PROT
 #       select HAVE_OPTPROBES
 #       select HAVE_REGS_AND_STACK_ACCESS_API
 #       select HAVE_HW_BREAKPOINT
 #       select PERF_EVENTS
 #       select HAVE_USER_RETURN_NOTIFIER
+#       config NO_BOOTMEM
+#       config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+#       config HUGETLB_PAGE_SIZE_VARIABLE
+
+
+mainmenu "Linux/TILE Kernel Configuration"
 
+# Please note: TILE-Gx support is not yet finalized; this is
+# the preliminary support.  TILE-Gx drivers are only provided
+# with the alpha or beta test versions for Tilera customers.
 config TILEGX
+	depends on EXPERIMENTAL
 	bool "Building with TILE-Gx (64-bit) compiler and toolchain"
 
 config 64BIT
@@ -44,47 +141,10 @@
 	default "arch/tile/configs/tile_defconfig" if !TILEGX
 	default "arch/tile/configs/tilegx_defconfig" if TILEGX
 
-config MMU
-	def_bool y
-
 source "init/Kconfig"
 
 menu "Tilera-specific configuration"
 
-# This flag should be marked as "def_bool y" if the kernel is being
-# built as part of the Tilera MDE, which includes a variety of
-# platform-independent kernel changes to add features and performance,
-# and "def_bool n" if building Tile Linux from generic sources.
-#
-# Over time we hope the use of this flag decreases as more of the
-# Tilera platform-independent changes are accepted into the community.
-# It should only be used here in this file, in "depends on" clauses.
-#
-# Note that enabling PCI requires a one-line change in the
-# drivers/pci/Makefile, and TILEmpower requires a quirk change.
-#
-config TILERA_MDE
-	def_bool n
-
-# SMP is required for Tilera Linux.
-config SMP
-	def_bool y
-
-# By default we always build with -Werror, but allow an escape hatch,
-# for example to build vanilla 2.6.26 with gcc 4.4, which generates
-# warnings in the architecture-independent code.
-config WERROR
-	bool "Build the kernel with warnings treated as errors"
-	depends on TILERA_MDE
-	default y
-
-# Allow checking for compile-time determined overflow errors in
-# copy_from_user().  There are still unprovable places in the
-# generic code as of 2.6.34, so this option is not really compatible
-# with WERROR, which is more useful in general.
-config DEBUG_COPY_FROM_USER
-	def_bool n
-
 config NR_CPUS
 	int "Maximum number of tiles (2-255)"
 	range 2 255
@@ -95,34 +155,6 @@
 	  smaller kernel memory footprint results from using a smaller
 	  value on chips with fewer tiles.
 
-config HOMECACHE
-	bool "Support for dynamic home cache management"
-	depends on TILERA_MDE
-	---help---
-	  Home cache management allows Linux to dynamically adjust
-	  which core's (or cores') cache is the "home" for every page
-	  of memory.  This allows performance improvements on TILEPro
-	  (for example, by enabling the default "allbutstack" mode
-	  where stack pages are always homed on the core running the
-	  task).  TILE64 has less performant cache-coherent support,
-	  so it is not recommended to disable homecaching for TILE64.
-
-config DATAPLANE
-	bool "Support for Zero-Overhead Linux mode"
-	depends on SMP
-	depends on NO_HZ
-	depends on TILERA_MDE
-	---help---
-	  Zero-Overhead Linux mode, also called "dataplane" mode,
-	  allows Linux cpus running only a single user task to run
-	  without any kernel overhead on that cpu.  The normal
-	  scheduler tick is disabled, kernel threads such as the
-	  softlockup thread are not run, kernel TLB flush IPIs are
-	  deferred, vmstat updates are not performed, etc.
-
-config SERIAL_CONSOLE
-	def_bool y
-
 source "kernel/time/Kconfig"
 
 source "kernel/Kconfig.hz"
@@ -188,26 +220,6 @@
 	  By default, 2, i.e. 2^2 == 4 DDR2 controllers.
 	  In a system with more controllers, this value should be raised.
 
-# FIXME: not yet implemented.
-config HUGETLB_PAGE_SIZE_VARIABLE
-	def_bool n
-	depends on HUGETLB_PAGE
-
-# This option is not likely to work yet
-config HIGHPTE
-	def_bool n
-
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool y
-
-# We do not currently support this, though it would be reasonable
-# with memory striping on TILEPro, or on systems with just one controller.
-config ARCH_FLATMEM_ENABLE
-	def_bool n
-
-config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y
-
 # Need 16MB areas to enable hugetlb
 # See build-time check in arch/tile/mm/init.c.
 config FORCE_MAX_ZONEORDER
@@ -215,7 +227,7 @@
 	default 9
 
 choice
-	depends on EXPERIMENTAL
+	depends on !TILEGX
 	prompt "Memory split" if EMBEDDED
 	default VMSPLIT_3G
 	---help---
@@ -304,132 +316,20 @@
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
-config FEEDBACK_COLLECT
-	bool "Collect feedback for optimizing the build"
-	default n
-	---help---
-	  This option enables collecting feedback data that can be
-	  used to optimize a later build of the kernel.  The feedback
-	  data can be read from /proc/tile/feedback.
-	  See the FEEDBACK_USE option for how to use this data.
-
-config FEEDBACK_USE
-	string "Path to file with feedback data to optimize the build"
-	default ""
-	---help---
-	  Supply an absolute path to a feedback data file (as generated
-	  by tile-convert-feedback) to use for optimizing the kernel.
-	  See the FEEDBACK_COLLECT option for how to collect this data.
-
-# This is not useful to enable now, since we have no huge-page drivers.
-config NR_HUGE_VMAPS
-	int # "Number of huge page addresses reserved for the kernel"
-	default 0
-	---help---
-	  The kernel will reserve address regions for huge pages
-	  needed by kernel drivers, in much the same way it reserves
-	  address space for the normal small-page vmalloc subsystem.
-	  Since the impact on addressable kernel memory is much
-	  greater, this is broken out as a separate configuration.
-
 config VMALLOC_RESERVE
 	hex
 	default 0x1000000
 
-config XGBE_MAIN
-	tristate "Tilera GBE/XGBE character device support"
-	default y
-	depends on HUGETLBFS
-	---help---
-	  This is the low-level driver for access to xgbe/gbe/pcie.
-
-config NET_TILE
-	tristate "Tilera GBE/XGBE network driver support"
-	select CRC32
-	depends on XGBE_MAIN
-	depends on !TILEGX
-	---help---
-	  This is a standard Linux network device driver for the
-	  Tilera Gigabit Ethernet and XAUI interfaces.
-
-config NET_TILEGX
-	tristate "Tilera GBE/XGBE network driver support"
-	select CRC32
-	depends on TILEGX
-	---help---
-	  This is a standard Linux network device driver for the
-	  Tilera Gigabit Ethernet and XAUI interfaces (mPIPE).
-
-config PSEUDO_NAPI
-	boolean "Support optimized kernel API for Tilera network driver"
-	default y
-	depends on NET_TILE || NET_TILEGX
-	depends on TILERA_MDE
-	---help---
-	  Define this to take turns between grabbing packets and
-	  processing them.  This can easily yield a 20% improvement
-	  due to reduced interrupts.
-
-config TILEPCI_ENDP
-	tristate "Tilera PCIE Endpoint Channel Driver"
-	default y
-	depends on !TILEGX
-	---help---
-	  This device is required on Tilera PCI cards; the driver
-	  allows Tilera Linux on the chip to communicate with the
-	  Intel Linux running on the host.
-
-config TILE_IDE_GPIO
-	bool "Tilera IDE driver for GPIO"
-	depends on IDE
-	default y
-	---help---
-	  This device provides an IDE interface using the GPIO pins.
-
-config TILE_SOFTUART
-	bool "Tilera Soft UART"
-	default n
-	depends on !TILEGX
-	---help---
-	  This device provides access to the FlexIO UART functionality.
-	  It requires a dedicated hypervisor "softuart" driver tile.
-
 endmenu  # Tilera-specific configuration
 
 menu "Bus options"
 
-config PCI
-	bool "PCI support"
-	default y
-	select PCI_DOMAINS
-	---help---
-	  Enable PCI root complex support, so PCIe endpoint devices can
-	  be attached to the Tile chip.  Many, but not all, PCI devices
-	  are supported under Tilera's root complex driver.
-
-config PCI_DOMAINS
+config NO_IOMEM
 	bool
+	def_bool !PCI
 
 source "drivers/pci/Kconfig"
 
-config HOTPLUG
-	bool "Support for hot-pluggable devices"
-	---help---
-	  Say Y here if you want to plug devices into your computer while
-	  the system is running, and be able to use them quickly.  In many
-	  cases, the devices can likewise be unplugged at any time too.
-
-	  One well known example of this is PCMCIA- or PC-cards, credit-card
-	  size devices such as network cards, modems or hard drives which are
-	  plugged into slots found on all modern laptop computers.  Another
-	  example, used on modern desktops as well as laptops, is USB.
-
-	  Enable HOTPLUG and KMOD, and build a modular kernel.  Get agent
-	  software (at <http://linux-hotplug.sourceforge.net/>) and install it.
-	  Then your kernel will automatically call out to a user mode "policy
-	  agent" (/sbin/hotplug) to load modules and set up software needed
-	  to use devices as you hotplug them.
-
 source "drivers/pci/hotplug/Kconfig"
 
 endmenu
@@ -458,76 +358,3 @@
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
-
-# FIXME: tilegx can implement a more efficent rwsem.
-config RWSEM_GENERIC_SPINLOCK
-	def_bool y
-
-config GENERIC_HARDIRQS
-	def_bool y
-
-config GENERIC_HARDIRQS_NO__DO_IRQ
-	def_bool y
-
-config GENERIC_IRQ_PROBE
-	def_bool y
-
-config GENERIC_PENDING_IRQ
-	def_bool y
-	depends on GENERIC_HARDIRQS && SMP
-
-config ZONE_DMA
-	def_bool y
-
-config SEMAPHORE_SLEEPERS
-	def_bool y
-
-config CC_OPTIMIZE_FOR_SIZE
-	def_bool y
-
-config RWSEM_GENERIC_SPINLOCK
-	def_bool y
-
-config HAVE_ARCH_ALLOC_REMAP
-	def_bool y
-
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool y
-
-config NEED_PER_CPU_PAGE_FIRST_CHUNK
-        def_bool y
-
-config SYS_SUPPORTS_HUGETLBFS
-	def_bool y
-
-config GENERIC_TIME
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config CLOCKSOURCE_WATCHDOG
-	def_bool y
-
-# We have a very flat architecture from a migration point of view,
-# so save boot time by presetting this (particularly useful on tile-sim).
-config DEFAULT_MIGRATION_COST
-	int
-	default "10000000"
-
-# We only support gcc 4.4 and above, so this should work.
-config ARCH_SUPPORTS_OPTIMIZED_INLINING
-	def_bool y
-
-# This may not work out of the box, but it should be easy to make it work.
-config ARCH_SUPPORTS_DEBUG_PAGEALLOC
-	def_bool y
-
-config ARCH_PHYS_ADDR_T_64BIT
-	def_bool y
-
-# FIXME: Enabling this will allow us to remove the bootmem support,
-# which hackily only works on controller zero at the moment.
-# However, it currently is not supported.
-config NO_BOOTMEM
-	def_bool n
diff -ru tile.old/Kconfig.debug tile/Kconfig.debug
--- tile.old/Kconfig.debug	2010-05-28 18:03:30.857289000 -0400
+++ tile/Kconfig.debug	2010-05-28 23:07:04.653422000 -0400
@@ -1,13 +1,7 @@
 menu "Kernel hacking"
 
-config TRACE_IRQFLAGS_SUPPORT
-	def_bool y
-
 source "lib/Kconfig.debug"
 
-config STRICT_DEVMEM
-	def_bool y
-
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
 	default y
diff -ru tile.old/Makefile tile/Makefile
--- tile.old/Makefile	2010-05-28 18:03:30.870281000 -0400
+++ tile/Makefile	2010-05-28 23:07:06.121168000 -0400
@@ -8,31 +8,33 @@
 # for "archclean" and "archdep" for cleaning up and making dependencies for
 # this architecture
 
+ifeq ($(CROSS_COMPILE),)
+# If building with TILERA_ROOT set (i.e. using the Tilera Multicore
+# Development Environment) we can set CROSS_COMPILE based on that.
 ifdef TILERA_ROOT
-TILERA_BIN = $(TILERA_ROOT)/bin/
+CROSS_COMPILE	= $(TILERA_ROOT)/bin/tile-
+endif
 endif
 
-# Test for cross compiling
-COMPILE_ARCH = $(shell uname -m)
-ifneq ($(COMPILE_ARCH), $(ARCH))
-  CROSS_COMPILE = $(TILERA_BIN)tile-
+# If we're not cross-compiling, make sure we're on the right architecture.
+ifeq ($(CROSS_COMPILE),)
+HOST_ARCH = $(shell uname -m)
+ifneq ($(HOST_ARCH),$(ARCH))
+$(error Set TILERA_ROOT or CROSS_COMPILE when building $(ARCH) on $(HOST_ARCH))
+endif
 endif
 
-CC = $(CROSS_COMPILE)gcc
 
-# FIXME: Handle feedback.
-ifeq ($(CONFIG_WERROR),y)
-# We try to keep the builds warning-free.
-KBUILD_CFLAGS	+= -Werror
-endif
 KBUILD_CFLAGS   += $(CONFIG_DEBUG_EXTRA_FLAGS)
 
-LIBGCC_PATH     := `$(CC) -print-libgcc-file-name`
+LIBGCC_PATH     := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
 
 # Provide the path to use for "make defconfig".
 KBUILD_DEFCONFIG := $(ARCH)_defconfig
 
 # Used as a file extension when useful, e.g. head_$(BITS).o
+# Not needed for (e.g.) "$(CC) -m32" since the compiler automatically
+# uses the right default anyway.
 export BITS
 ifeq ($(CONFIG_TILEGX),y)
 BITS := 64
@@ -45,24 +47,6 @@
 libs-y		+= arch/tile/lib/
 libs-y		+= $(LIBGCC_PATH)
 
+
 # See arch/tile/Kbuild for content of core part of the kernel
 core-y		+= arch/tile/
-
-drivers-y	+= arch/tile/drivers/
-drivers-y	+= arch/tile/oprofile/
-
-boot		:= arch/tile/boot
-
-all: vmlinux
-
-CLEAN_FILES	+= arch/tile/vmlinux.lds
-
-install: vmlinux
-ifeq ($(COMPILE_ARCH), $(ARCH))
-	cp $< $(INSTALL_PATH)
-else
-ifndef TILERA_ROOT
-$(error Must set TILERA_ROOT to do a cross-install)
-endif
-	cp $< $(TILERA_ROOT)/tile$(INSTALL_PATH)
-endif
diff -ru tile.old/configs/tile_defconfig tile/configs/tile_defconfig
--- tile.old/configs/tile_defconfig	2010-05-28 18:03:30.889258000 -0400
+++ tile/configs/tile_defconfig	2010-05-28 22:57:14.692455000 -0400
@@ -1,15 +1,42 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.34-rc7
-# Thu May 13 11:56:25 2010
+# Linux kernel version: 2.6.34
+# Fri May 28 17:51:43 2010
 #
-CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_MMU=y
+CONFIG_GENERIC_CSUM=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_PENDING_IRQ=y
+CONFIG_ZONE_DMA=y
+CONFIG_SEMAPHORE_SLEEPERS=y
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_HAVE_ARCH_ALLOC_REMAP=y
+CONFIG_HAVE_SETUP_PER_CPU_AREA=y
+CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
+CONFIG_SYS_SUPPORTS_HUGETLBFS=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_CLOCKSOURCE_WATCHDOG=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_DEFAULT_MIGRATION_COST=10000000
+CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
+CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
+CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_STRICT_DEVMEM=y
+CONFIG_SMP=y
+CONFIG_WERROR=y
+# CONFIG_DEBUG_COPY_FROM_USER is not set
+CONFIG_SERIAL_CONSOLE=y
+CONFIG_HVC_TILE=y
 CONFIG_TILE=y
 # CONFIG_TILEGX is not set
 CONFIG_ARCH_DEFCONFIG="arch/tile/configs/tile_defconfig"
-CONFIG_MMU=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 CONFIG_CONSTRUCTORS=y
 
@@ -59,7 +86,6 @@
 # CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
 # CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
 # CONFIG_INITRAMFS_COMPRESSION_LZO is not set
-CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
 CONFIG_EMBEDDED=y
@@ -98,7 +124,6 @@
 #
 # GCOV-based kernel profiling
 #
-# CONFIG_GCOV_KERNEL is not set
 # CONFIG_SLOW_WORK is not set
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
@@ -159,14 +184,9 @@
 #
 # Tilera-specific configuration
 #
-CONFIG_TILERA_MDE=y
-CONFIG_SMP=y
-CONFIG_WERROR=y
-# CONFIG_DEBUG_COPY_FROM_USER is not set
 CONFIG_NR_CPUS=64
 CONFIG_HOMECACHE=y
 CONFIG_DATAPLANE=y
-CONFIG_SERIAL_CONSOLE=y
 CONFIG_TICK_ONESHOT=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
@@ -181,11 +201,6 @@
 CONFIG_HIGHMEM=y
 CONFIG_NUMA=y
 CONFIG_NODES_SHIFT=2
-# CONFIG_HUGETLB_PAGE_SIZE_VARIABLE is not set
-# CONFIG_HIGHPTE is not set
-CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
-# CONFIG_ARCH_FLATMEM_ENABLE is not set
-CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
 CONFIG_FORCE_MAX_ZONEORDER=9
 # CONFIG_VMSPLIT_375G is not set
 # CONFIG_VMSPLIT_35G is not set
@@ -213,8 +228,10 @@
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_FEEDBACK_COLLECT is not set
 CONFIG_FEEDBACK_USE=""
-CONFIG_NR_HUGE_VMAPS=0
+# CONFIG_HUGEVMAP is not set
 CONFIG_VMALLOC_RESERVE=0x1000000
+CONFIG_HARDWALL=y
+CONFIG_MEMPROF=y
 CONFIG_XGBE_MAIN=y
 CONFIG_NET_TILE=y
 CONFIG_PSEUDO_NAPI=y
@@ -714,6 +731,7 @@
 CONFIG_UNIX98_PTYS=y
 # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 # CONFIG_LEGACY_PTYS is not set
+CONFIG_HVC_DRIVER=y
 # CONFIG_IPMI_HANDLER is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_R3964 is not set
@@ -724,7 +742,6 @@
 #
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_TCG_TPM is not set
-CONFIG_DEVPORT=y
 CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
 CONFIG_I2C_COMPAT=y
@@ -929,7 +946,6 @@
 # CONFIG_EXT3_FS_SECURITY is not set
 # CONFIG_EXT4_FS is not set
 CONFIG_JBD=y
-# CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
@@ -1072,7 +1088,6 @@
 #
 # Kernel hacking
 #
-CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 # CONFIG_PRINTK_TIME is not set
 CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
@@ -1116,16 +1131,14 @@
 # CONFIG_DEBUG_SG is not set
 # CONFIG_DEBUG_NOTIFIERS is not set
 # CONFIG_DEBUG_CREDENTIALS is not set
-# CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
-# CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
-# CONFIG_DEBUG_PAGEALLOC is not set
+# CONFIG_PAGE_POISONING is not set
 CONFIG_RING_BUFFER=y
 CONFIG_RING_BUFFER_ALLOW_SWAP=y
 CONFIG_TRACING_SUPPORT=y
@@ -1141,9 +1154,7 @@
 # CONFIG_WORKQUEUE_TRACER is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_RING_BUFFER_BENCHMARK is not set
-# CONFIG_DYNAMIC_DEBUG is not set
 # CONFIG_SAMPLES is not set
-CONFIG_STRICT_DEVMEM=y
 CONFIG_EARLY_PRINTK=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 # CONFIG_DEBUG_STACK_USAGE is not set
@@ -1276,22 +1287,3 @@
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
 CONFIG_NLATTR=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-CONFIG_GENERIC_HARDIRQS=y
-CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
-CONFIG_GENERIC_IRQ_PROBE=y
-CONFIG_GENERIC_PENDING_IRQ=y
-CONFIG_ZONE_DMA=y
-CONFIG_SEMAPHORE_SLEEPERS=y
-CONFIG_HAVE_ARCH_ALLOC_REMAP=y
-CONFIG_HAVE_SETUP_PER_CPU_AREA=y
-CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
-CONFIG_SYS_SUPPORTS_HUGETLBFS=y
-CONFIG_GENERIC_TIME=y
-CONFIG_GENERIC_CLOCKEVENTS=y
-CONFIG_CLOCKSOURCE_WATCHDOG=y
-CONFIG_DEFAULT_MIGRATION_COST=10000000
-CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
-CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
-CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
-# CONFIG_NO_BOOTMEM is not set
Only in tile.old: drivers
Only in tile.old: feedback
diff -ru tile.old/include/arch/abi.h tile/include/arch/abi.h
--- tile.old/include/arch/abi.h	2010-05-28 18:03:31.579736000 -0400
+++ tile/include/arch/abi.h	2010-05-28 23:07:05.843397000 -0400
@@ -76,7 +76,7 @@
 //! String prefix to use for printf().
 #define INT_REG_FMT "ll"
 
-#else
+#elif !defined(__LP64__)   /* avoid confusion with LP64 cross-build tools */
 
 //! Unsigned type that can hold a register.
 typedef unsigned long uint_reg_t;
diff -ru tile.old/include/arch/chip.h tile/include/arch/chip.h
--- tile.old/include/arch/chip.h	2010-05-28 18:03:31.588724000 -0400
+++ tile/include/arch/chip.h	2010-05-28 23:07:04.781288000 -0400
@@ -16,8 +16,8 @@
 #include <arch/chip_tile64.h>
 #elif __tile_chip__ == 1
 #include <arch/chip_tilepro.h>
-
-
+#elif defined(__tilegx__)
+#include <arch/chip_tilegx.h>
 #else
 #error Unexpected Tilera chip type
 #endif
diff -ru tile.old/include/arch/chip_tile64.h tile/include/arch/chip_tile64.h
--- tile.old/include/arch/chip_tile64.h	2010-05-28 18:03:31.600712000 -0400
+++ tile/include/arch/chip_tile64.h	2010-05-28 23:07:05.863374000 -0400
@@ -193,60 +193,60 @@
 /** Does the chip have native single step support? */
 #define CHIP_HAS_SINGLE_STEP() 0
 
+#ifndef __OPEN_SOURCE__  /* features only relevant to hypervisor-level code */
 
+/** How many entries are present in the instruction TLB? */
+#define CHIP_ITLB_ENTRIES() 8
 
+/** How many entries are present in the data TLB? */
+#define CHIP_DTLB_ENTRIES() 16
 
+/** How many MAF entries does the XAUI shim have? */
+#define CHIP_XAUI_MAF_ENTRIES() 16
 
+/** Does the memory shim have a source-id table? */
+#define CHIP_HAS_MSHIM_SRCID_TABLE() 1
 
+/** Does the L1 instruction cache clear on reset? */
+#define CHIP_HAS_L1I_CLEAR_ON_RESET() 0
 
+/** Does the chip come out of reset with valid coordinates on all tiles?
+ * Note that if defined, this also implies that the upper left is 1,1.
+ */
+#define CHIP_HAS_VALID_TILE_COORD_RESET() 0
 
+/** Does the chip have unified packet formats? */
+#define CHIP_HAS_UNIFIED_PACKET_FORMATS() 0
 
+/** Does the chip support write reordering? */
+#define CHIP_HAS_WRITE_REORDERING() 0
 
+/** Does the chip support Y-X routing as well as X-Y? */
+#define CHIP_HAS_Y_X_ROUTING() 0
 
+/** Is INTCTRL_3 managed with the correct MPL? */
+#define CHIP_HAS_INTCTRL_3_STATUS_FIX() 0
 
+/** Is it possible to configure the chip to be big-endian? */
+#define CHIP_HAS_BIG_ENDIAN_CONFIG() 0
 
+/** Is the CACHE_RED_WAY_OVERRIDDEN SPR supported? */
+#define CHIP_HAS_CACHE_RED_WAY_OVERRIDDEN() 0
 
+/** Is the DIAG_TRACE_WAY SPR supported? */
+#define CHIP_HAS_DIAG_TRACE_WAY() 0
 
+/** Is the MEM_STRIPE_CONFIG SPR supported? */
+#define CHIP_HAS_MEM_STRIPE_CONFIG() 0
 
+/** Are the TLB_PERF SPRs supported? */
+#define CHIP_HAS_TLB_PERF() 0
 
+/** Is the VDN_SNOOP_SHIM_CTL SPR supported? */
+#define CHIP_HAS_VDN_SNOOP_SHIM_CTL() 0
 
+/** Does the chip support rev1 DMA packets? */
+#define CHIP_HAS_REV1_DMA_PACKETS() 0
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#endif /* !__OPEN_SOURCE__ */
 #endif /* __ARCH_CHIP_H__ */
diff -ru tile.old/include/arch/chip_tilepro.h tile/include/arch/chip_tilepro.h
--- tile.old/include/arch/chip_tilepro.h	2010-05-28 18:03:31.609701000 -0400
+++ tile/include/arch/chip_tilepro.h	2010-05-28 23:07:05.851404000 -0400
@@ -193,60 +193,60 @@
 /** Does the chip have native single step support? */
 #define CHIP_HAS_SINGLE_STEP() 0
 
+#ifndef __OPEN_SOURCE__  /* features only relevant to hypervisor-level code */
 
+/** How many entries are present in the instruction TLB? */
+#define CHIP_ITLB_ENTRIES() 16
 
+/** How many entries are present in the data TLB? */
+#define CHIP_DTLB_ENTRIES() 16
 
+/** How many MAF entries does the XAUI shim have? */
+#define CHIP_XAUI_MAF_ENTRIES() 32
 
+/** Does the memory shim have a source-id table? */
+#define CHIP_HAS_MSHIM_SRCID_TABLE() 0
 
+/** Does the L1 instruction cache clear on reset? */
+#define CHIP_HAS_L1I_CLEAR_ON_RESET() 1
 
+/** Does the chip come out of reset with valid coordinates on all tiles?
+ * Note that if defined, this also implies that the upper left is 1,1.
+ */
+#define CHIP_HAS_VALID_TILE_COORD_RESET() 1
 
+/** Does the chip have unified packet formats? */
+#define CHIP_HAS_UNIFIED_PACKET_FORMATS() 1
 
+/** Does the chip support write reordering? */
+#define CHIP_HAS_WRITE_REORDERING() 1
 
+/** Does the chip support Y-X routing as well as X-Y? */
+#define CHIP_HAS_Y_X_ROUTING() 1
 
+/** Is INTCTRL_3 managed with the correct MPL? */
+#define CHIP_HAS_INTCTRL_3_STATUS_FIX() 1
 
+/** Is it possible to configure the chip to be big-endian? */
+#define CHIP_HAS_BIG_ENDIAN_CONFIG() 1
 
+/** Is the CACHE_RED_WAY_OVERRIDDEN SPR supported? */
+#define CHIP_HAS_CACHE_RED_WAY_OVERRIDDEN() 1
 
+/** Is the DIAG_TRACE_WAY SPR supported? */
+#define CHIP_HAS_DIAG_TRACE_WAY() 1
 
+/** Is the MEM_STRIPE_CONFIG SPR supported? */
+#define CHIP_HAS_MEM_STRIPE_CONFIG() 1
 
+/** Are the TLB_PERF SPRs supported? */
+#define CHIP_HAS_TLB_PERF() 1
 
+/** Is the VDN_SNOOP_SHIM_CTL SPR supported? */
+#define CHIP_HAS_VDN_SNOOP_SHIM_CTL() 1
 
+/** Does the chip support rev1 DMA packets? */
+#define CHIP_HAS_REV1_DMA_PACKETS() 1
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#endif /* !__OPEN_SOURCE__ */
 #endif /* __ARCH_CHIP_H__ */
Only in tile.old/include/arch: cycle.h
Only in tile.old/include/arch: inline.h
diff -ru tile.old/include/arch/interrupts.h tile/include/arch/interrupts.h
--- tile.old/include/arch/interrupts.h	2010-05-28 18:03:31.645675000 -0400
+++ tile/include/arch/interrupts.h	2010-05-28 23:07:04.742333000 -0400
@@ -12,7 +12,8 @@
  *   more details.
  */
 
-
-
-
+#ifdef __tilegx__
+#include <arch/interrupts_64.h>
+#else
 #include <arch/interrupts_32.h>
+#endif
Only in tile.old/include/arch: sim.h
diff -ru tile.old/include/arch/spr_def.h tile/include/arch/spr_def.h
--- tile.old/include/arch/spr_def.h	2010-05-28 18:03:31.718596000 -0400
+++ tile/include/arch/spr_def.h	2010-05-28 23:07:04.778296000 -0400
@@ -12,7 +12,8 @@
  *   more details.
  */
 
-
-
-
+#ifdef __tilegx__
+#include <arch/spr_def_64.h>
+#else
 #include <arch/spr_def_32.h>
+#endif
diff -ru tile.old/include/asm/Kbuild tile/include/asm/Kbuild
--- tile.old/include/asm/Kbuild	2010-05-28 18:03:31.751566000 -0400
+++ tile/include/asm/Kbuild	2010-05-28 23:07:06.106169000 -0400
@@ -1,17 +1,3 @@
 include include/asm-generic/Kbuild.asm
 
-header-y += hardwall.h
-header-y += memprof.h
 header-y += ucontext.h
-header-y += user.h
-
-unifdef-y += bme.h
-unifdef-y += page.h
-unifdef-y += tilepci.h
-
-# FIXME: The kernel probably shouldn't provide these to user-space,
-# but it's convenient for now to do so.
-unifdef-y += opcode-tile.h
-unifdef-y += opcode_constants.h
-unifdef-y += opcode-tile_32.h
-unifdef-y += opcode_constants_32.h
Only in tile.old/include/asm: a.out.h
Only in tile.old/include/asm: addrspace.h
Only in tile.old/include/asm: asm.h
diff -ru tile.old/include/asm/atomic.h tile/include/asm/atomic.h
--- tile.old/include/asm/atomic.h	2010-05-28 18:03:31.793516000 -0400
+++ tile/include/asm/atomic.h	2010-05-28 23:07:05.209010000 -0400
@@ -145,11 +145,11 @@
 
 #endif /* __ASSEMBLY__ */
 
-
+#ifndef __tilegx__
 #include <asm/atomic_32.h>
-
-
-
+#else
+#include <asm/atomic_64.h>
+#endif
 
 /* Provide the appropriate atomic_long_t definitions. */
 #ifndef __ASSEMBLY__
diff -ru tile.old/include/asm/backtrace.h tile/include/asm/backtrace.h
--- tile.old/include/asm/backtrace.h	2010-05-28 18:03:31.825489000 -0400
+++ tile/include/asm/backtrace.h	2010-05-28 23:07:05.990252000 -0400
@@ -15,18 +15,9 @@
 #ifndef _TILE_BACKTRACE_H
 #define _TILE_BACKTRACE_H
 
-#ifndef _LANGUAGE_ASSEMBLY
 
-#ifdef __cplusplus
-extern "C" {
-#endif /* __cplusplus */
 
-#ifdef __KERNEL__
 #include <linux/types.h>
-#else
-#include <stdint.h>
-#include <stdbool.h>
-#endif
 
 #include <arch/chip.h>
 
@@ -197,22 +188,6 @@
 } CallerLocation;
 
 
-#ifdef __cplusplus
-}  /* extern "C" */
-#endif /* __cplusplus */
-
-#else  /* __ASSEMBLY__ */
-
-/* BacktraceIterator offsets */
-#define BACKTRACE_ITERATOR_SIZE                     24
-
-#define BACKTRACE_ITERATOR_PC_OFFSET                 0
-#define BACKTRACE_ITERATOR_SP_OFFSET                 4
-#define BACKTRACE_ITERATOR_FP_OFFSET                 8
-#define BACKTRACE_ITERATOR_INITIAL_FRAME_CALLER_PC  12
-#define BACKTRACE_ITERATOR_READ_MEMORY_FUNC         16
-#define BACKTRACE_ITERATOR_READ_MEMORY_FUNC_EXTRA   20
 
-#endif /* __ASSEMBLY__ */
 
 #endif /* _TILE_BACKTRACE_H */
diff -ru tile.old/include/asm/bitops.h tile/include/asm/bitops.h
--- tile.old/include/asm/bitops.h	2010-05-28 18:03:31.841470000 -0400
+++ tile/include/asm/bitops.h	2010-05-28 23:07:05.260975000 -0400
@@ -22,11 +22,11 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
-
-
-
+#ifdef __tilegx__
+#include <asm/bitops_64.h>
+#else
 #include <asm/bitops_32.h>
-
+#endif
 
 /**
  * __ffs - find first set bit in word
diff -ru tile.old/include/asm/bitsperlong.h tile/include/asm/bitsperlong.h
--- tile.old/include/asm/bitsperlong.h	2010-05-28 18:03:31.862457000 -0400
+++ tile/include/asm/bitsperlong.h	2010-05-28 23:07:05.262991000 -0400
@@ -15,11 +15,11 @@
 #ifndef _ASM_TILE_BITSPERLONG_H
 #define _ASM_TILE_BITSPERLONG_H
 
-
-
-
+#ifdef __LP64__
+# define __BITS_PER_LONG 64
+#else
 # define __BITS_PER_LONG 32
-
+#endif
 
 #include <asm-generic/bitsperlong.h>
 
Only in tile.old/include/asm: bme.h
diff -ru tile.old/include/asm/bugs.h tile/include/asm/bugs.h
--- tile.old/include/asm/bugs.h	2010-05-28 18:03:31.886439000 -0400
+++ tile/include/asm/bugs.h	2010-05-28 23:07:05.271964000 -0400
@@ -1,22 +1 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_BUGS_H
-#define _ASM_TILE_BUGS_H
-
-static inline void check_bugs(void)
-{
-}
-
-#endif /* _ASM_TILE_BUGS_H */
+#include <asm-generic/bugs.h>
diff -ru tile.old/include/asm/byteorder.h tile/include/asm/byteorder.h
--- tile.old/include/asm/byteorder.h	2010-05-28 18:03:31.905415000 -0400
+++ tile/include/asm/byteorder.h	2010-05-28 23:07:05.275961000 -0400
@@ -1,20 +1 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_BYTEORDER_H
-#define _ASM_TILE_BYTEORDER_H
-
 #include <linux/byteorder/little_endian.h>
-
-#endif /* _ASM_TILE_BYTEORDER_H */
diff -ru tile.old/include/asm/checksum.h tile/include/asm/checksum.h
--- tile.old/include/asm/checksum.h	2010-05-28 18:03:31.945371000 -0400
+++ tile/include/asm/checksum.h	2010-05-28 23:07:05.310928000 -0400
@@ -15,106 +15,10 @@
 #ifndef _ASM_TILE_CHECKSUM_H
 #define _ASM_TILE_CHECKSUM_H
 
-#include <linux/in6.h>
-#include <linux/uaccess.h>
+#include <asm-generic/checksum.h>
 
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 32-bit boundary
- */
-__wsum csum_partial(const void *buff, int len, __wsum sum);
-
-/*
- * the same as csum_partial, but copies from src while it checksums.
- */
-__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum);
-
-/*
- * the same as csum_partial, but copies from src while it
- * checksums, and handles user-space pointer exceptions correctly, when needed.
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-
-__wsum csum_partial_copy_from_user(const void __user *src, void *dst,
-				   int len, __wsum sum, int *err_ptr);
-
-/*
- *	Note: when you get a NULL pointer exception here this means someone
- *	passed in an incorrect kernel address to one of these functions.
- *
- *	If you use these functions directly please don't forget the
- *	access_ok().
- */
-static inline __wsum csum_partial_copy_nocheck(const void *src, void *dst,
-					       int len, __wsum sum)
-{
-	return csum_partial_copy(src, dst, len, sum);
-}
-
-/*
- *	Fold a partial checksum
- */
-
-static inline __sum16 csum_fold(__wsum sum)
-{
-	/* Add up 16-bit and 16-bit for 16+c bit, then add up carry. */
-	unsigned long ret;
-
-
-
-
-	ret = __insn_sadh_u(sum, 0);
-	ret = __insn_sadh_u(ret, 0);
-
-	return (__force __sum16) ~ret;
-}
-
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl);
-
-static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
-					unsigned short len,
-					unsigned short proto,
-					__wsum sum)
-{
-	u64 value = sum;
-	value += (u32) saddr;
-	value += (u32) daddr;
-	value += (u32) ((ntohs(len) << 16) + (proto << 8));
-	value = (value & 0xffffffff) + (value >> 32);
-	value = (value & 0xffffffff) + (value >> 32);
-	return (__wsum) value;
-}
-
-/*
- * computes the checksum of the TCP/UDP pseudo-header
- * returns a 16-bit checksum, already complemented
- */
-static inline __sum16 csum_tcpudp_magic(__be32 saddr, __be32 daddr,
-					unsigned short len,
-					unsigned short proto,
-					__wsum sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
-}
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-
-static inline __sum16 ip_compute_csum(const void *buff, int len)
-{
-    return csum_fold(csum_partial(buff, len, 0));
-}
+/* Allow us to provide a more optimized do_csum(). */
+__wsum do_csum(const unsigned char *buff, int len);
+#define do_csum do_csum
 
 #endif /* _ASM_TILE_CHECKSUM_H */
diff -ru tile.old/include/asm/compat.h tile/include/asm/compat.h
--- tile.old/include/asm/compat.h	2010-05-28 18:03:31.947365000 -0400
+++ tile/include/asm/compat.h	2010-05-28 23:07:05.352898000 -0400
@@ -78,14 +78,16 @@
 	unsigned int	st_uid;
 	unsigned int	st_gid;
 	unsigned int	st_rdev;
+	unsigned int    __pad1;
 	int		st_size;
-	unsigned int	st_blksize;
-	unsigned int	st_blocks;
-	unsigned int	st_atime;
+	int		st_blksize;
+	int		__pad2;
+	int		st_blocks;
+	int		st_atime;
 	unsigned int	st_atime_nsec;
-	unsigned int	st_mtime;
+	int		st_mtime;
 	unsigned int	st_mtime_nsec;
-	unsigned int	st_ctime;
+	int		st_ctime;
 	unsigned int	st_ctime_nsec;
 	unsigned int	__unused[2];
 };
@@ -249,4 +251,58 @@
 				 siginfo_t *info, sigset_t *set,
 				 struct pt_regs *regs);
 
+/* Compat syscalls. */
+struct compat_sigaction;
+struct compat_siginfo;
+struct compat_sigaltstack;
+long compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+		       compat_uptr_t __user *envp);
+long compat_sys_rt_sigaction(int sig, struct compat_sigaction __user *act,
+			     struct compat_sigaction __user *oact,
+			     size_t sigsetsize);
+long compat_sys_rt_sigqueueinfo(int pid, int sig,
+				struct compat_siginfo __user *uinfo);
+long compat_sys_rt_sigreturn(void);
+long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			    struct compat_sigaltstack __user *uoss_ptr);
+long compat_sys_truncate64(char __user *filename, u32 dummy, u32 low, u32 high);
+long compat_sys_ftruncate64(unsigned int fd, u32 dummy, u32 low, u32 high);
+long compat_sys_pread64(unsigned int fd, char __user *ubuf, size_t count,
+			u32 dummy, u32 low, u32 high);
+long compat_sys_pwrite64(unsigned int fd, char __user *ubuf, size_t count,
+			 u32 dummy, u32 low, u32 high);
+long compat_sys_lookup_dcookie(u32 low, u32 high, char __user *buf, size_t len);
+long compat_sys_sync_file_range2(int fd, unsigned int flags,
+				 u32 offset_lo, u32 offset_hi,
+				 u32 nbytes_lo, u32 nbytes_hi);
+long compat_sys_fallocate(int fd, int mode,
+			  u32 offset_lo, u32 offset_hi,
+			  u32 len_lo, u32 len_hi);
+long compat_sys_stat64(char __user *filename,
+		       struct compat_stat64 __user *statbuf);
+long compat_sys_lstat64(char __user *filename,
+			struct compat_stat64 __user *statbuf);
+long compat_sys_fstat64(unsigned int fd, struct compat_stat64 __user *statbuf);
+long compat_sys_fstatat64(int dfd, char __user *filename,
+			  struct compat_stat64 __user *statbuf, int flag);
+long compat_sys_sched_rr_get_interval(compat_pid_t pid,
+				      struct compat_timespec __user *interval);
+ssize_t compat_sys_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
+			    size_t count);
+
+/* Versions of compat functions that differ from generic Linux. */
+struct compat_msgbuf;
+long tile_compat_sys_msgsnd(int msqid,
+			    struct compat_msgbuf __user *msgp,
+			    size_t msgsz, int msgflg);
+long tile_compat_sys_msgrcv(int msqid,
+			    struct compat_msgbuf __user *msgp,
+			    size_t msgsz, long msgtyp, int msgflg);
+long tile_compat_sys_ptrace(compat_long_t request, compat_long_t pid,
+			    compat_long_t addr, compat_long_t data);
+
+/* Tilera Linux syscalls that don't have "compat" versions. */
+#define compat_sys_raise_fpe sys_raise_fpe
+#define compat_sys_flush_cache sys_flush_cache
+
 #endif /* _ASM_TILE_COMPAT_H */
diff -ru tile.old/include/asm/delay.h tile/include/asm/delay.h
--- tile.old/include/asm/delay.h	2010-05-28 18:03:31.966351000 -0400
+++ tile/include/asm/delay.h	2010-05-28 23:07:05.330909000 -0400
@@ -15,8 +15,6 @@
 #ifndef _ASM_TILE_DELAY_H
 #define _ASM_TILE_DELAY_H
 
-#include <arch/cycle.h>
-
 /* Undefined functions to get compile-time errors. */
 extern void __bad_udelay(void);
 extern void __bad_ndelay(void);
@@ -33,26 +31,4 @@
 	((n) > 20000 ? __bad_ndelay() : __ndelay(n)) : \
 	__ndelay(n))
 
-/*
- * Our stall mechanism is an instruction that takes 6 cycles, and
- * looping around it takes 8.
- */
-#define CYCLES_PER_RELAX_LOOP 8
-
-/*
- * Idle the core for 8 * iterations cycles.
- * Also make this a compiler barrier, as it's sometimes used in
- * lieue of cpu_relax(), which has barrier semantics.
- */
-static inline void
-relax(int iterations)
-{
-	for (/*above*/; iterations > 0; iterations--)
-		cycle_relax();
-	barrier();
-}
-
-/* Delay using bounded exponential backoff. */
-extern void delay_backoff(int iterations);
-
 #endif /* _ASM_TILE_DELAY_H */
diff -ru tile.old/include/asm/dma-mapping.h tile/include/asm/dma-mapping.h
--- tile.old/include/asm/dma-mapping.h	2010-05-28 18:03:31.979338000 -0400
+++ tile/include/asm/dma-mapping.h	2010-05-28 23:07:05.347888000 -0400
@@ -59,35 +59,17 @@
 void dma_free_coherent(struct device *dev, size_t size,
 			 void *vaddr, dma_addr_t dma_handle);
 
-static inline void
-dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
-			enum dma_data_direction direction)
-{
-	panic("dma_sync_single_for_cpu");
-}
-
-static inline void
-dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
-			   size_t size, enum dma_data_direction direction)
-{
-	panic("dma_sync_single_for_device");
-}
-
-static inline void
-dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
-			      unsigned long offset, size_t size,
-			      enum dma_data_direction direction)
-{
-	panic("dma_sync_single_range_for_cpu");
-}
-
-static inline void
-dma_sync_single_range_for_device(struct device *dev, dma_addr_t dma_handle,
-				 unsigned long offset, size_t size,
-				 enum dma_data_direction direction)
-{
-	panic("dma_sync_single_range_for_device");
-}
+extern void dma_sync_single_for_cpu(struct device *, dma_addr_t, size_t,
+				    enum dma_data_direction);
+extern void dma_sync_single_for_device(struct device *, dma_addr_t,
+				       size_t, enum dma_data_direction);
+extern void dma_sync_single_range_for_cpu(struct device *, dma_addr_t,
+					  unsigned long offset, size_t,
+					  enum dma_data_direction);
+extern void dma_sync_single_range_for_device(struct device *, dma_addr_t,
+					     unsigned long offset, size_t,
+					     enum dma_data_direction);
+extern void dma_cache_sync(void *vaddr, size_t, enum dma_data_direction);
 
 static inline int
 dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
@@ -120,11 +102,5 @@
 
 #define dma_is_consistent(d, h)	(1)
 
-static inline void
-dma_cache_sync(void *vaddr, size_t size,
-	       enum dma_data_direction direction)
-{
-	panic("dma_cache_sync");
-}
 
 #endif /* _ASM_TILE_DMA_MAPPING_H */
diff -ru tile.old/include/asm/dma.h tile/include/asm/dma.h
--- tile.old/include/asm/dma.h	2010-05-28 18:03:31.982327000 -0400
+++ tile/include/asm/dma.h	2010-05-28 23:07:05.362870000 -0400
@@ -15,20 +15,11 @@
 #ifndef _ASM_TILE_DMA_H
 #define _ASM_TILE_DMA_H
 
-#include <asm/page.h>
-
-#define MAX_DMA_ADDRESS	((unsigned long)high_memory - 1)
-
-/* Reserve a DMA channel. */
-extern int request_dma(unsigned int dmanr, const char *device_id);
-
-/* Release it again. */
-extern void free_dma(unsigned int dmanr);
+#include <asm-generic/dma.h>
 
+/* Needed by drivers/pci/quirks.c */
 #ifdef CONFIG_PCI
 extern int isa_dma_bridge_buggy;
-#else
-#define isa_dma_bridge_buggy    (0)
 #endif
 
 #endif /* _ASM_TILE_DMA_H */
diff -ru tile.old/include/asm/elf.h tile/include/asm/elf.h
--- tile.old/include/asm/elf.h	2010-05-28 18:03:31.988338000 -0400
+++ tile/include/asm/elf.h	2010-05-28 23:07:05.361880000 -0400
@@ -39,11 +39,11 @@
 typedef double elf_fpreg_t;
 typedef elf_fpreg_t elf_fpregset_t[ELF_NFPREG];
 
-
-
-
+#ifdef __tilegx__
+#define ELF_CLASS	ELFCLASS64
+#else
 #define ELF_CLASS	ELFCLASS32
-
+#endif
 #define ELF_DATA	ELFDATA2LSB
 
 /*
@@ -63,23 +63,23 @@
 	  (x)->e_machine == CHIP_COMPAT_ELF_TYPE()))
 
 /* The module loader only handles a few relocation types. */
-
+#ifndef __tilegx__
 #define R_TILE_32                 1
 #define R_TILE_JOFFLONG_X1       15
 #define R_TILE_IMM16_X0_LO       25
 #define R_TILE_IMM16_X1_LO       26
 #define R_TILE_IMM16_X0_HA       29
 #define R_TILE_IMM16_X1_HA       30
-
-
-
-
-
-
-
-
-
-
+#else
+#define R_TILEGX_64                       1
+#define R_TILEGX_JUMPOFF_X1              21
+#define R_TILEGX_IMM16_X0_HW0            36
+#define R_TILEGX_IMM16_X1_HW0            37
+#define R_TILEGX_IMM16_X0_HW1            38
+#define R_TILEGX_IMM16_X1_HW1            39
+#define R_TILEGX_IMM16_X0_HW2_LAST       48
+#define R_TILEGX_IMM16_X1_HW2_LAST       49
+#endif
 
 /* Use standard page size for core dumps. */
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
@@ -120,8 +120,6 @@
 extern int dump_task_regs(struct task_struct *, elf_gregset_t *);
 #define ELF_CORE_COPY_TASK_REGS(tsk, elf_regs) dump_task_regs(tsk, elf_regs)
 
-#ifdef __KERNEL__
-
 /* Tilera Linux has no personalities currently, so no need to do anything. */
 #define SET_PERSONALITY(ex) do { } while (0)
 
@@ -130,8 +128,6 @@
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 				       int executable_stack);
-#endif
-
 #ifdef CONFIG_COMPAT
 
 #define COMPAT_ELF_PLATFORM "tilegx-m32"
diff -ru tile.old/include/asm/futex.h tile/include/asm/futex.h
--- tile.old/include/asm/futex.h	2010-05-28 18:03:32.050266000 -0400
+++ tile/include/asm/futex.h	2010-05-28 23:07:05.387861000 -0400
@@ -23,7 +23,6 @@
 #ifndef _ASM_TILE_FUTEX_H
 #define _ASM_TILE_FUTEX_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
 #include <linux/futex.h>
@@ -36,23 +35,23 @@
 extern struct __get_user futex_andn(int *v, int n);
 extern struct __get_user futex_cmpxchg(int *v, int o, int n);
 
-
+#ifndef __tilegx__
 extern struct __get_user futex_xor(int *v, int n);
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#else
+static inline struct __get_user futex_xor(int __user *uaddr, int n)
+{
+	struct __get_user asm_ret = __get_user_4(uaddr);
+	if (!asm_ret.err) {
+		int oldval, newval;
+		do {
+			oldval = asm_ret.val;
+			newval = oldval ^ n;
+			asm_ret = futex_cmpxchg(uaddr, oldval, newval);
+		} while (asm_ret.err == 0 && oldval != asm_ret.val);
+	}
+	return asm_ret;
+}
+#endif
 
 static inline int futex_atomic_op_inuser(int encoded_op, int __user *uaddr)
 {
@@ -134,6 +133,4 @@
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_FUTEX_H */
Only in tile.old/include/asm: hardwall.h
diff -ru tile.old/include/asm/highmem.h tile/include/asm/highmem.h
--- tile.old/include/asm/highmem.h	2010-05-28 18:03:32.092272000 -0400
+++ tile/include/asm/highmem.h	2010-05-28 23:07:05.390850000 -0400
@@ -21,8 +21,6 @@
 #ifndef _ASM_TILE_HIGHMEM_H
 #define _ASM_TILE_HIGHMEM_H
 
-#ifdef __KERNEL__
-
 #include <linux/interrupt.h>
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
@@ -72,6 +70,4 @@
 
 #define flush_cache_kmaps()	do { } while (0)
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_HIGHMEM_H */
diff -ru tile.old/include/asm/homecache.h tile/include/asm/homecache.h
--- tile.old/include/asm/homecache.h	2010-05-28 18:03:32.095262000 -0400
+++ tile/include/asm/homecache.h	2010-05-28 23:07:05.422818000 -0400
@@ -104,131 +104,11 @@
  * routines use homecache_change_page_home() to reset the home
  * back to the default before returning the page to the allocator.
  */
-#ifdef CONFIG_HOMECACHE
-#define homecache_free_pages(addr, order) free_pages(addr, order)
-#else
 void homecache_free_pages(unsigned long addr, unsigned int order);
-#endif
 #define homecache_free_page(page) \
   homecache_free_pages((page), 0)
 
 
-#ifdef CONFIG_HOMECACHE
-
-/* Get home cache of a page. */
-#define page_home(page)			((page)->home)
-
-/* Set home cache of a page. */
-#define set_page_home(page, _home) \
-	do { \
-		int __home = (_home); \
-		BUG_ON(__home <= PAGE_HOME_UNKNOWN || __home >= NR_CPUS); \
-		(page)->home = __home; \
-	} while (0)
-
-/*
- * Allocate a page intended for user-space with suitable homecaching.
- */
-struct page *homecache_alloc_page_vma(gfp_t gfp, struct vm_area_struct *vma,
-				      unsigned long addr);
-
-/*
- * Regenerate a PTE that has been migrated by taking the vm_page_prot
- * values for caching and the PTE's own read/write/access/dirty bits,
- * then rewriting the PTE.  This will cause various components (e.g.
- * the home, whether it's coherent, etc.) to be filled in correctly.
- * In addition, reset the PTE to match the page.
- */
-extern void homecache_update_migrating_pte(struct page *, pte_t *,
-					   struct vm_area_struct *,
-					   unsigned long address);
-
-/*
- * Make a freshly-allocated page be homed on the current cpu,
- * or some other home if requested by homecache_alloc_pages() et al.
- * If the page is unsuitable for allocation (e.g. it is cached on
- * a dataplane tile and some other tile is requesting it) we return
- * "1" and sequester the page just like homecache_check_free_page().
- */
-extern int homecache_new_kernel_page(struct page *, int order);
-
-/*
- * Called by the page_alloc allocation code prior to checking the
- * per-cpu free lists.  If there's a hit for the type of page that
- * we're currently looking for here, we return that page and
- * short-circuit any futher allocation work.
- * Must be called with interrupts disabled.
- */
-extern struct page *homecache_get_cached_page(struct zone *zone, int gfpflags);
-
-/*
- * Called by the page_alloc free code when just about to return a page
- * to the free pool.  If it returns "1", the generic code does not
- * return the page to the free pool.
- */
-extern int homecache_check_free_page(struct page *, int order);
-
-/*
- * Report the number of pages sequestered by homecache_new_kernel_page()
- * or homecache_check_free_page().
- */
-extern long homecache_count_sequestered_pages(void);
-
-/*
- * Recover any free pages that were sequestered by homecache_free_page()
- * by doing a global cache flush and returning them to the free pool.
- * Called from the page allocator when free pool is empty.
- */
-extern int homecache_recover_free_pages(void);
-
-/*
- * Take a user page and try to associate it with the current cpu.
- * Called from do_wp_page() when un-cow'ing a page with only one reference.
- * The page must be locked.
- */
-extern void homecache_home_page_here(struct page *, int order, pgprot_t);
-
-/*
- * Update caching to match a pgprot, and unmap any other mappings of
- * this page in other address spaces.  Called when we are mapping a page
- * into an address space, before any page table locks are taken.
- * If the page is a file mapping with no shared writers and we are setting
- * up a read-only mapping, we ignore vm_page_prot and make it immutable.
- * The page must be locked.
- */
-extern void homecache_update_page(struct page *, int order,
-				  struct vm_area_struct *, int writable);
-
-/*
- * Make an immutable page writable by giving it default cache homing.
- * This may only last as long as it takes to complete the action
- * (e.g. page writeout) that required it to be locked in the first place,
- * since if the page is mapped not shared-writable it will be reset to
- * immutable when the page gets faulted back in again.
- * The page must be locked.
- */
-extern void homecache_make_writable(struct page *page, int order);
-
-/*
- * Fix the caching on a new page that we are about to map into user space.
- * The page is freshly-allocated, so should not be locked.
- * This is currently only used by the hugepage code; small pages
- * come through homecache_alloc_page_vma().
- */
-extern void homecache_new_user_page(struct page *, int order,
-				    pgprot_t prot, int writable);
-
-/* Migrate the current user-space process to the current cpu. */
-extern void homecache_migrate(void);
-
-/* Migrate the current kernel thread to the current cpu. */
-extern void homecache_migrate_kthread(void);
-
-/* Acquire/release the lock needed to create new kernel PTE mappings. */
-extern unsigned long homecache_kpte_lock(void);
-extern void homecache_kpte_unlock(unsigned long);
-
-#else
 
 /*
  * Report the page home for LOWMEM pages by examining their kernel PTE,
@@ -241,6 +121,5 @@
 #define homecache_kpte_lock() 0
 #define homecache_kpte_unlock(flags) do {} while (0)
 
-#endif /* CONFIG_HOMECACHE */
 
 #endif /* _ASM_TILE_HOMECACHE_H */
Only in tile.old/include/asm: hugevmap.h
diff -ru tile.old/include/asm/hv_driver.h tile/include/asm/hv_driver.h
--- tile.old/include/asm/hv_driver.h	2010-05-28 18:03:32.128265000 -0400
+++ tile/include/asm/hv_driver.h	2010-05-28 23:07:05.423818000 -0400
@@ -20,7 +20,6 @@
 #ifndef _ASM_TILE_HV_DRIVER_H
 #define _ASM_TILE_HV_DRIVER_H
 
-#ifdef __KERNEL__
 #include <hv/hypervisor.h>
 
 struct hv_driver_cb;
@@ -58,6 +57,4 @@
 }
 
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_HV_DRIVER_H */
diff -ru tile.old/include/asm/ide.h tile/include/asm/ide.h
--- tile.old/include/asm/ide.h	2010-05-28 18:03:32.141263000 -0400
+++ tile/include/asm/ide.h	2010-05-28 23:07:05.447794000 -0400
@@ -15,8 +15,6 @@
 #ifndef _ASM_TILE_IDE_H
 #define _ASM_TILE_IDE_H
 
-#ifdef __KERNEL__
-
 /* For IDE on PCI */
 #define MAX_HWIFS       10
 
@@ -24,6 +22,4 @@
 
 #include <asm-generic/ide_iops.h>
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_IDE_H */
diff -ru tile.old/include/asm/io.h tile/include/asm/io.h
--- tile.old/include/asm/io.h	2010-05-28 18:03:32.144265000 -0400
+++ tile/include/asm/io.h	2010-05-28 23:07:05.447788000 -0400
@@ -37,22 +37,34 @@
  */
 #define page_to_phys(page)    ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)
 
-#define readb_relaxed(a) readb(a)
-#define readw_relaxed(a) readw(a)
-#define readl_relaxed(a) readl(a)
-#define readq_relaxed(a) readq(a)
+/*
+ * Some places try to pass in an loff_t for PHYSADDR (?!), so we cast it to
+ * long before casting it to a pointer to avoid compiler warnings.
+ */
+#if CHIP_HAS_MMIO()
+extern void __iomem *ioremap(resource_size_t offset, unsigned long size);
+extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
+	pgprot_t pgprot);
+extern void iounmap(volatile void __iomem *addr);
+#else
+#define ioremap(physaddr, size)	((void __iomem *)(unsigned long)(physaddr))
+#define iounmap(addr)		((void)0)
+#endif
 
-#ifdef CONFIG_PCI
+#define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
+#define ioremap_writethrough(physaddr, size)	ioremap(physaddr, size)
+#define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
 
-#define readb(addr) _tile_readb((unsigned long)addr)
-#define readw(addr) _tile_readw((unsigned long)addr)
-#define readl(addr) _tile_readl((unsigned long)addr)
-#define readq(addr) _tile_readq((unsigned long)addr)
+void __iomem *ioport_map(unsigned long port, unsigned int len);
+extern inline void ioport_unmap(void __iomem *addr) {}
 
-#define writeb(val, addr) _tile_writeb(val, (unsigned long)addr)
-#define writew(val, addr) _tile_writew(val, (unsigned long)addr)
-#define writel(val, addr) _tile_writel(val, (unsigned long)addr)
-#define writeq(val, addr) _tile_writeq(val, (unsigned long)addr)
+#define mmiowb()
+
+/* Conversion between virtual and physical mappings.  */
+#define mm_ptov(addr)		((void *)phys_to_virt(addr))
+#define mm_vtop(addr)		((unsigned long)virt_to_phys(addr))
+
+#ifdef CONFIG_PCI
 
 extern u8 _tile_readb(unsigned long addr);
 extern u16 _tile_readw(unsigned long addr);
@@ -63,43 +75,14 @@
 extern void _tile_writel(u32 val, unsigned long addr);
 extern void _tile_writeq(u64 val, unsigned long addr);
 
-extern u32 inb(u32 addr);
-extern u32 inw(u32 addr);
-extern u32 inl(u32 addr);
-extern void outb(u32 val, u32 addr);
-extern void outw(u32 val, u32 addr);
-extern void outl(u32 val, u32 addr);
-
-#else
-
-#define readb(addr) \
-  ({ unsigned char __v = (*(volatile unsigned char *) (addr)); __v; })
-#define readw(addr) \
-  ({ unsigned short __v = (*(volatile unsigned short *) (addr)); __v; })
-#define readl(addr) \
-  ({ unsigned int __v = (*(volatile unsigned int *) (addr)); __v; })
-#define readq(addr) \
-  ({ unsigned long long __v = (*(volatile unsigned long long *)(addr)); __v; })
-
-#define writeb(val, addr) \
-  (void)((*(volatile unsigned char *) (addr)) = (val))
-#define writew(val, addr) \
-  (void)((*(volatile unsigned short *) (addr)) = (val))
-#define writel(val, addr) \
-  (void)((*(volatile unsigned int *) (addr)) = (val))
-#define writeq(val, addr) \
-  (void)((*(volatile unsigned long long *) (addr)) = (val))
-
-#define inb(addr)       readb(addr)
-#define inw(addr)       readw(addr)
-#define inl(addr)       readl(addr)
-#define inq(addr)       readq(addr)
-#define outb(x, addr)   ((void)writeb((x), (addr)))
-#define outw(x, addr)   ((void)writew((x), (addr)))
-#define outl(x, addr)   ((void)writel((x), (addr)))
-#define outq(x, addr)   ((void)writeq((x), (addr)))
-
-#endif
+#define readb(addr) _tile_readb((unsigned long)addr)
+#define readw(addr) _tile_readw((unsigned long)addr)
+#define readl(addr) _tile_readl((unsigned long)addr)
+#define readq(addr) _tile_readq((unsigned long)addr)
+#define writeb(val, addr) _tile_writeb(val, (unsigned long)addr)
+#define writew(val, addr) _tile_writew(val, (unsigned long)addr)
+#define writel(val, addr) _tile_writel(val, (unsigned long)addr)
+#define writeq(val, addr) _tile_writeq(val, (unsigned long)addr)
 
 #define __raw_readb readb
 #define __raw_readw readw
@@ -110,117 +93,128 @@
 #define __raw_writel writel
 #define __raw_writeq writeq
 
-#define inb_p(port)		inb((port))
-#define outb_p(val, port)	outb((val), (port))
-#define inw_p(port)		inw((port))
-#define outw_p(val, port)	outw((val), (port))
-#define inl_p(port)		inl((port))
-#define outl_p(val, port)	outl((val), (port))
+#define readb_relaxed readb
+#define readw_relaxed readw
+#define readl_relaxed readl
+#define readq_relaxed readq
+
+#define ioread8 readb
+#define ioread16 readw
+#define ioread32 readl
+#define ioread64 readq
+#define iowrite8 writeb
+#define iowrite16 writew
+#define iowrite32 writel
+#define iowrite64 writeq
 
-static inline void insb(unsigned long port, void *dst, unsigned long count)
+static inline void *memcpy_fromio(void *dst, void *src, int len)
 {
-	unsigned char *p = dst;
-	while (count--)
-		*p++ = inb(port);
+	int x;
+	BUG_ON((unsigned long)src & 0x3);
+	for (x = 0; x < len; x += 4)
+		*(u32 *)(dst + x) = readl(src + x);
+	return dst;
 }
-static inline void insw(unsigned long port, void *dst, unsigned long count)
+
+static inline void *memcpy_toio(void *dst, void *src, int len)
 {
-	unsigned short *p = dst;
-	while (count--)
-		*p++ = inw(port);
+	int x;
+	BUG_ON((unsigned long)dst & 0x3);
+	for (x = 0; x < len; x += 4)
+		writel(*(u32 *)(src + x), dst + x);
+	return dst;
 }
-static inline void insl(unsigned long port, void *dst, unsigned long count)
+
+#endif
+
+/*
+ * The Tile architecture does not support IOPORT, even with PCI.
+ * Unfortunately we can't yet simply not declare these methods,
+ * since some generic code that compiles into the kernel, but
+ * we never run, uses them unconditionally.
+ */
+
+extern int ioport_panic(void);
+
+static inline u8 inb(unsigned long addr)
 {
-	unsigned int *p = dst;
-	while (count--)
-		*p++ = inl(port);
+	return ioport_panic();
 }
 
-static inline void outsb(unsigned long port, const void *src,
-			 unsigned long count)
+static inline u16 inw(unsigned long addr)
 {
-	const unsigned char *p = src;
-	while (count--)
-		outb(*p++, port);
+	return ioport_panic();
 }
-static inline void outsw(unsigned long port, const void *src,
-			 unsigned long count)
+
+static inline u32 inl(unsigned long addr)
 {
-	const unsigned short *p = src;
-	while (count--)
-		outw(*p++, port);
+	return ioport_panic();
 }
-static inline void outsl(unsigned long port, const void *src,
-			 unsigned long count)
+
+static inline void outb(u8 b, unsigned long addr)
 {
-	const unsigned int *p = src;
-	while (count--)
-		outl(*p++, port);
+	ioport_panic();
 }
 
+static inline void outw(u16 b, unsigned long addr)
+{
+	ioport_panic();
+}
 
-/*
- * Some places try to pass in an loff_t for PHYSADDR (?!), so we cast it to
- * long before casting it to a pointer to avoid compiler warnings.
- */
-#if CHIP_HAS_MMIO()
-extern void __iomem *ioremap(resource_size_t offset, unsigned long size);
-extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
-	pgprot_t pgprot);
-extern void iounmap(volatile void __iomem *addr);
-#else
-#define ioremap(physaddr, size)	((void __iomem *)(unsigned long)(physaddr))
-#define iounmap(addr)		((void)0)
-#endif
+static inline void outl(u32 b, unsigned long addr)
+{
+	ioport_panic();
+}
 
-void __iomem *ioport_map(unsigned long port, unsigned int len);
-extern inline void ioport_unmap(void __iomem *addr) {}
+#define inb_p(addr)	inb(addr)
+#define inw_p(addr)	inw(addr)
+#define inl_p(addr)	inl(addr)
+#define outb_p(x, addr)	outb((x), (addr))
+#define outw_p(x, addr)	outw((x), (addr))
+#define outl_p(x, addr)	outl((x), (addr))
 
-#define ioremap_nocache(physaddr, size)		ioremap(physaddr, size)
-#define ioremap_writethrough(physaddr, size)	ioremap(physaddr, size)
-#define ioremap_fullcache(physaddr, size)	ioremap(physaddr, size)
+static inline void insb(unsigned long addr, void *buffer, int count)
+{
+	ioport_panic();
+}
 
-#define ioread8(addr)		readb(addr)
-#define ioread16(addr)		readw(addr)
-#define ioread32(addr)		readl(addr)
-#define ioread64(addr)		readq(addr)
-#define iowrite8(val, addr)	writeb((val), (addr))
-#define iowrite16(val, addr)	writew((val), (addr))
-#define iowrite32(val, addr)	writel((val), (addr))
-#define iowrite64(val, addr)	writeq((val), (addr))
-
-#define ioread8_rep(a, b, c)    insb((unsigned long)(a), (b), (c))
-#define ioread16_rep(a, b, c)   insw((unsigned long)(a), (b), (c))
-#define ioread32_rep(a, b, c)   insl((unsigned long)(a), (b), (c))
-
-#define iowrite8_rep(a, b, c)   outsb((unsigned long)(a), (b), (c))
-#define iowrite16_rep(a, b, c)  outsw((unsigned long)(a), (b), (c))
-#define iowrite32_rep(a, b, c)  outsl((unsigned long)(a), (b), (c))
+static inline void insw(unsigned long addr, void *buffer, int count)
+{
+	ioport_panic();
+}
 
-#define mmiowb()
+static inline void insl(unsigned long addr, void *buffer, int count)
+{
+	ioport_panic();
+}
 
-/* Conversion between virtual and physical mappings.  */
-#define mm_ptov(addr)		((void *)phys_to_virt(addr))
-#define mm_vtop(addr)		((unsigned long)virt_to_phys(addr))
+static inline void outsb(unsigned long addr, const void *buffer, int count)
+{
+	ioport_panic();
+}
 
-static inline void *memcpy_fromio(void *dst, void *src, int len)
+static inline void outsw(unsigned long addr, const void *buffer, int count)
 {
-	int x;
-	if ((unsigned long)src & 0x3)
-		panic("memcpy_fromio from non dword aligned address");
-	for (x = 0; x < len; x += 4)
-		*(u32 *)(dst + x) = readl(src + x);
-	return dst;
+	ioport_panic();
 }
 
-static inline void *memcpy_toio(void *dst, void *src, int len)
+static inline void outsl(unsigned long addr, const void *buffer, int count)
 {
-	int x;
-	if ((unsigned long)dst & 0x3)
-		panic("memcpy_toio to non dword aligned address");
-	for (x = 0; x < len; x += 4)
-		writel(*(u32 *)(src + x), dst + x);
-	return dst;
+	ioport_panic();
 }
 
+#define ioread8_rep(p, dst, count) \
+	insb((unsigned long) (p), (dst), (count))
+#define ioread16_rep(p, dst, count) \
+	insw((unsigned long) (p), (dst), (count))
+#define ioread32_rep(p, dst, count) \
+	insl((unsigned long) (p), (dst), (count))
+
+#define iowrite8_rep(p, src, count) \
+	outsb((unsigned long) (p), (src), (count))
+#define iowrite16_rep(p, src, count) \
+	outsw((unsigned long) (p), (src), (count))
+#define iowrite32_rep(p, src, count) \
+	outsl((unsigned long) (p), (src), (count))
+
 #endif /* _ASM_TILE_IO_H */
diff -ru tile.old/include/asm/irq.h tile/include/asm/irq.h
--- tile.old/include/asm/irq.h	2010-05-28 18:03:32.157277000 -0400
+++ tile/include/asm/irq.h	2010-05-28 23:07:05.485756000 -0400
@@ -15,7 +15,6 @@
 #ifndef _ASM_TILE_IRQ_H
 #define _ASM_TILE_IRQ_H
 
-#ifdef __KERNEL__
 #include <linux/hardirq.h>
 
 /* The hypervisor interface provides 32 IRQs. */
@@ -27,18 +26,12 @@
 /* The HV interrupt state object. */
 DECLARE_PER_CPU(HV_IntrState, dev_intr_state);
 
-
 void ack_bad_irq(unsigned int irq);
-void tile_irq_request_level(int tile_irq);
-void tile_irq_request_edge(int tile_irq);
-void tile_enable_irq(int irq);
-
-/* Register or unregister a function to be called upon a particular IRQ. */
-void tile_request_irq(void (*handler)(void *), void *dev_id, int index);
-void tile_free_irq(int index);
-
-extern int tile_irq_base;
 
-#endif /* __KERNEL__ */
+/*
+ * Paravirtualized drivers should call this when their init calls
+ * discover a valid HV IRQ.
+ */
+void tile_irq_activate(unsigned int irq);
 
 #endif /* _ASM_TILE_IRQ_H */
diff -ru tile.old/include/asm/irqflags.h tile/include/asm/irqflags.h
--- tile.old/include/asm/irqflags.h	2010-05-28 18:03:32.161264000 -0400
+++ tile/include/asm/irqflags.h	2010-05-28 23:07:05.488744000 -0400
@@ -161,28 +161,43 @@
 
 /* We provide a somewhat more restricted set for assembly. */
 
+#ifdef __tilegx__
 
+#if INT_MEM_ERROR != 0
+# error Fix IRQ_DISABLED() macro
+#endif
 
+/* Return 0 or 1 to indicate whether interrupts are currently disabled. */
+#define IRQS_DISABLED(tmp)					\
+	mfspr   tmp, INTERRUPT_MASK_1;				\
+	andi    tmp, tmp, 1
 
+/* Load up a pointer to &interrupts_enabled_mask. */
+#define GET_INTERRUPTS_ENABLED_MASK_PTR(reg)			\
+	moveli reg, hw2_last(interrupts_enabled_mask); \
+	shl16insli reg, reg, hw1(interrupts_enabled_mask); \
+	shl16insli reg, reg, hw0(interrupts_enabled_mask); \
+	add     reg, reg, tp
 
+/* Disable interrupts. */
+#define IRQ_DISABLE(tmp0, tmp1)					\
+	moveli  tmp0, hw2_last(LINUX_MASKABLE_INTERRUPTS);	\
+	shl16insli tmp0, tmp0, hw1(LINUX_MASKABLE_INTERRUPTS);	\
+	shl16insli tmp0, tmp0, hw0(LINUX_MASKABLE_INTERRUPTS);	\
+	mtspr   INTERRUPT_MASK_SET_1, tmp0
 
+/* Disable ALL synchronous interrupts (used by NMI entry). */
+#define IRQ_DISABLE_ALL(tmp)					\
+	movei   tmp, -1;					\
+	mtspr   INTERRUPT_MASK_SET_1, tmp
 
+/* Enable interrupts. */
+#define IRQ_ENABLE(tmp0, tmp1)					\
+	GET_INTERRUPTS_ENABLED_MASK_PTR(tmp0);			\
+	ld      tmp0, tmp0;					\
+	mtspr   INTERRUPT_MASK_RESET_1, tmp0
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#else /* !__tilegx__ */
 
 /*
  * Return 0 or 1 to indicate whether interrupts are currently disabled.
@@ -232,7 +247,7 @@
 	lw      tmp1, tmp1;					\
 	mtspr   INTERRUPT_MASK_RESET_1_0, tmp0;			\
 	mtspr   INTERRUPT_MASK_RESET_1_1, tmp1
-
+#endif
 
 /*
  * Do the CPU's IRQ-state tracing from assembly code. We call a
Only in tile.old/include/asm: kvm.h
diff -ru tile.old/include/asm/mman.h tile/include/asm/mman.h
--- tile.old/include/asm/mman.h	2010-05-28 18:03:32.243228000 -0400
+++ tile/include/asm/mman.h	2010-05-28 23:07:05.521712000 -0400
@@ -29,80 +29,6 @@
 #define MAP_EXECUTABLE	0x1000		/* mark it as an executable */
 #define MAP_HUGETLB	0x4000		/* create a huge page mapping */
 
-/*
- * Specify the "home cache" for the page explicitly.  The home cache is
- * the cache of one particular "home" cpu, which is used as a coherence
- * point for normal cached operations.  Normally the kernel chooses for
- * you, but you can use the MAP_CACHE_HOME_xxx flags to override.
- *
- * User code should not use any symbols with a leading "_" as they are
- * implementation specific and may change from release to release
- * without warning.
- *
- * See the Tilera mmap(2) man page for more details (e.g. "tile-man mmap").
- */
-
-/* Implementation details; do not use directly. */
-#define _MAP_CACHE_INCOHERENT   0x40000
-#define _MAP_CACHE_HOME         0x80000
-#define _MAP_CACHE_HOME_SHIFT   20
-#define _MAP_CACHE_HOME_MASK    0x3ff
-#define _MAP_CACHE_MKHOME(n) \
-  (_MAP_CACHE_HOME | (((n) & _MAP_CACHE_HOME_MASK) << _MAP_CACHE_HOME_SHIFT))
-
-/* Set the home cache to the specified cpu. */
-#define MAP_CACHE_HOME(n)       _MAP_CACHE_MKHOME(n)
-
-/* Set the home cache to the current cpu. */
-#define _MAP_CACHE_HOME_HERE    (_MAP_CACHE_HOME_MASK - 0)
-#define MAP_CACHE_HOME_HERE     _MAP_CACHE_MKHOME(_MAP_CACHE_HOME_HERE)
-
-/* Request no on-chip home, i.e. read from memory.  Invalid with PROT_WRITE. */
-#define _MAP_CACHE_HOME_NONE    (_MAP_CACHE_HOME_MASK - 1)
-#define MAP_CACHE_HOME_NONE     _MAP_CACHE_MKHOME(_MAP_CACHE_HOME_NONE)
-
-/* Request no on-chip home, and allow incoherent PROT_WRITE mappings. */
-#define MAP_CACHE_INCOHERENT    (_MAP_CACHE_INCOHERENT | MAP_CACHE_HOME_NONE)
-
-/* Force the system to choose a single home cache, on a cpu of its choice. */
-#define _MAP_CACHE_HOME_SINGLE  (_MAP_CACHE_HOME_MASK - 2)
-#define MAP_CACHE_HOME_SINGLE   _MAP_CACHE_MKHOME(_MAP_CACHE_HOME_SINGLE)
-
-/* Create a mapping that follows the task when it migrates. */
-#define _MAP_CACHE_HOME_TASK    (_MAP_CACHE_HOME_MASK - 3)
-#define MAP_CACHE_HOME_TASK     _MAP_CACHE_MKHOME(_MAP_CACHE_HOME_TASK)
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-/* Create a hash-for-home mapping. */
-#define _MAP_CACHE_HOME_HASH    (_MAP_CACHE_HOME_MASK - 4)
-#define MAP_CACHE_HOME_HASH     _MAP_CACHE_MKHOME(_MAP_CACHE_HOME_HASH)
-#endif
-
-/*
- * Specify local caching attributes for the mapping.  Normally the kernel
- * chooses whether to use the local cache, but these flags can be used
- * to override the kernel.
- */
-
-/* Disable use of local L2 (ignored on tile64). */
-#define MAP_CACHE_NO_L2         0x20000
-
-/* Disable use of local L1 (ignored on tile64). */
-#define MAP_CACHE_NO_L1         0x08000
-
-/* Convenience alias that should be used for forward compatibility. */
-#define MAP_CACHE_NO_LOCAL      (MAP_CACHE_NO_L1 | MAP_CACHE_NO_L2)
-
-/* Convenience alias for direct-to-RAM mappings. */
-#define MAP_CACHE_NONE          (MAP_CACHE_HOME_NONE | MAP_CACHE_NO_LOCAL)
-
-/* Arrange for this mapping to take priority in the cache. */
-#define MAP_CACHE_PRIORITY      0x02000
-
-/*
- * Environment variable that controls hash-for-home in user programs.
- */
-#define MAP_CACHE_HASH_ENV_VAR "LD_CACHE_HASH"
 
 /*
  * Flags for mlockall
@@ -110,17 +36,5 @@
 #define MCL_CURRENT	1		/* lock all current mappings */
 #define MCL_FUTURE	2		/* lock all future mappings */
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
-
-#include <asm/page.h>
-
-struct vm_area_struct;
-struct address_space;
-extern int arch_vm_area_flags(struct mm_struct *mm, unsigned long flags,
-			      unsigned long vm_flags, pid_t *, pgprot_t *);
-extern int arch_vm_area_validate(struct vm_area_struct *,
-				 struct address_space *);
-
-#endif /* kernel C code */
 
 #endif /* _ASM_TILE_MMAN_H */
diff -ru tile.old/include/asm/mmu_context.h tile/include/asm/mmu_context.h
--- tile.old/include/asm/mmu_context.h	2010-05-28 18:03:32.271204000 -0400
+++ tile/include/asm/mmu_context.h	2010-05-28 23:07:05.550694000 -0400
@@ -114,9 +114,6 @@
 		 * the icache in case some physical page now being mapped
 		 * has subsequently been repurposed and has new code.
 		 */
-
-
-
 		__flush_icache();
 
 	}
Only in tile/include/asm: opcode-tile_64.h
Only in tile/include/asm: opcode_constants_64.h
diff -ru tile.old/include/asm/page.h tile/include/asm/page.h
--- tile.old/include/asm/page.h	2010-05-28 18:03:32.366106000 -0400
+++ tile/include/asm/page.h	2010-05-28 23:07:05.588654000 -0400
@@ -15,9 +15,9 @@
 #ifndef _ASM_TILE_PAGE_H
 #define _ASM_TILE_PAGE_H
 
-#include <arch/chip.h>
-
 #include <linux/const.h>
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
 
 /* PAGE_SHIFT and HPAGE_SHIFT determine the page sizes. */
 #define PAGE_SHIFT	16
@@ -29,17 +29,6 @@
 #define PAGE_MASK	(~(PAGE_SIZE - 1))
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 
-#ifndef __KERNEL__
-/* Tolerate i386-derived user code that expects LARGE_PAGE_xxx. */
-#define LARGE_PAGE_SIZE  HPAGE_SIZE
-#define LARGE_PAGE_SHIFT HPAGE_SHIFT
-#define LARGE_PAGE_MASK  HPAGE_MASK
-#endif
-
-#ifdef __KERNEL__
-
-#include <hv/hypervisor.h>
-
 /*
  * The {,H}PAGE_SHIFT values must match the HV_LOG2_PAGE_SIZE_xxx
  * definitions in <hv/hypervisor.h>.  We validate this at build time
@@ -126,16 +115,16 @@
 	return hv_pte_val(pgd);
 }
 
+#ifdef __tilegx__
 
+typedef HV_PTE pmd_t;
 
+static inline u64 pmd_val(pmd_t pmd)
+{
+	return hv_pte_val(pmd);
+}
 
-
-
-
-
-
-
-
+#endif
 
 #endif /* !__ASSEMBLY__ */
 
@@ -153,47 +142,47 @@
 #define __pa_to_highbits(pa) ((phys_addr_t)(pa) >> NR_PA_HIGHBIT_SHIFT)
 #define __pfn_to_highbits(pfn) ((pfn) >> (NR_PA_HIGHBIT_SHIFT - PAGE_SHIFT))
 
+#ifdef __tilegx__
 
+/*
+ * We reserve the lower half of memory for user-space programs, and the
+ * upper half for system code.  We re-map all of physical memory in the
+ * upper half, which takes a quarter of our VA space.  Then we have
+ * the vmalloc regions.  The supervisor code lives at 0xfffffff700000000,
+ * with the hypervisor above that.
+ *
+ * Loadable kernel modules are placed immediately after the static
+ * supervisor code, with each being allocated a 256MB region of
+ * address space, so we don't have to worry about the range of "jal"
+ * and other branch instructions.
+ *
+ * For now we keep life simple and just allocate one pmd (4GB) for vmalloc.
+ * Similarly, for now we don't play any struct page mapping games.
+ */
 
+#if CHIP_PA_WIDTH() + 2 > CHIP_VA_WIDTH()
+# error Too much PA to map with the VA available!
+#endif
+#define HALF_VA_SPACE           (_AC(1, UL) << (CHIP_VA_WIDTH() - 1))
 
+#define MEM_LOW_END		(HALF_VA_SPACE - 1)         /* low half */
+#define MEM_HIGH_START		(-HALF_VA_SPACE)            /* high half */
+#define PAGE_OFFSET		MEM_HIGH_START
+#define _VMALLOC_START		_AC(0xfffffff500000000, UL) /* 4 GB */
+#define HUGE_VMAP_BASE		_AC(0xfffffff600000000, UL) /* 4 GB */
+#define MEM_SV_START		_AC(0xfffffff700000000, UL) /* 256 MB */
+#define MEM_SV_INTRPT		MEM_SV_START
+#define MEM_MODULE_START	_AC(0xfffffff710000000, UL) /* 256 MB */
+#define MEM_MODULE_END		(MEM_MODULE_START + (256*1024*1024))
+#define MEM_HV_START		_AC(0xfffffff800000000, UL) /* 32 GB */
 
+/* Highest DTLB address we will use */
+#define KERNEL_HIGH_VADDR	MEM_SV_START
 
+/* Since we don't currently provide any fixmaps, we use an impossible VA. */
+#define FIXADDR_TOP             MEM_HV_START
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#else /* !__tilegx__ */
 
 /*
  * A PAGE_OFFSET of 0xC0000000 means that the kernel has
@@ -245,7 +234,7 @@
 #define MEM_MODULE_START	VMALLOC_START
 #define MEM_MODULE_END		VMALLOC_END
 
-
+#endif /* __tilegx__ */
 
 #ifndef __ASSEMBLY__
 
@@ -342,5 +331,4 @@
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-#endif /* __KERNEL__ */
 #endif /* _ASM_TILE_PAGE_H */
diff -ru tile.old/include/asm/pci-bridge.h tile/include/asm/pci-bridge.h
--- tile.old/include/asm/pci-bridge.h	2010-05-28 18:03:32.396084000 -0400
+++ tile/include/asm/pci-bridge.h	2010-05-28 23:07:05.589645000 -0400
@@ -15,8 +15,6 @@
 #ifndef _ASM_TILE_PCI_BRIDGE_H
 #define _ASM_TILE_PCI_BRIDGE_H
 
-#ifdef __KERNEL__
-
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
@@ -116,6 +114,4 @@
 }
 #endif
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_PCI_BRIDGE_H */
diff -ru tile.old/include/asm/pgalloc.h tile/include/asm/pgalloc.h
--- tile.old/include/asm/pgalloc.h	2010-05-28 18:03:32.431047000 -0400
+++ tile/include/asm/pgalloc.h	2010-05-28 23:07:05.607630000 -0400
@@ -40,11 +40,11 @@
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
-
-
-
+#ifdef CONFIG_64BIT
+	set_pte_order(pmdp, pmd, L2_USER_PGTABLE_ORDER);
+#else
 	set_pte_order(&pmdp->pud.pgd, pmd.pud.pgd, L2_USER_PGTABLE_ORDER);
-
+#endif
 }
 
 static inline void pmd_populate_kernel(struct mm_struct *mm,
@@ -100,16 +100,20 @@
 /* During init, we can shatter kernel huge pages if needed. */
 void shatter_pmd(pmd_t *pmd);
 
-
-
-
-
-
-
-
-
-
-
-
+#ifdef __tilegx__
+/* We share a single page allocator for both L1 and L2 page tables. */
+#if HV_L1_SIZE != HV_L2_SIZE
+# error Rework assumption that L1 and L2 page tables are same size.
+#endif
+#define L1_USER_PGTABLE_ORDER L2_USER_PGTABLE_ORDER
+#define pud_populate(mm, pud, pmd) \
+  pmd_populate_kernel((mm), (pmd_t *)(pud), (pte_t *)(pmd))
+#define pmd_alloc_one(mm, addr) \
+  ((pmd_t *)page_to_virt(pte_alloc_one((mm), (addr))))
+#define pmd_free(mm, pmdp) \
+  pte_free((mm), virt_to_page(pmdp))
+#define __pmd_free_tlb(tlb, pmdp, address) \
+  __pte_free_tlb((tlb), virt_to_page(pmdp), (address))
+#endif
 
 #endif /* _ASM_TILE_PGALLOC_H */
diff -ru tile.old/include/asm/pgtable.h tile/include/asm/pgtable.h
--- tile.old/include/asm/pgtable.h	2010-05-28 18:03:32.444029000 -0400
+++ tile/include/asm/pgtable.h	2010-05-28 23:07:05.621616000 -0400
@@ -127,12 +127,7 @@
 #define PAGE_KERNEL_RO		__pgprot(_PAGE_KERNEL_RO)
 #define PAGE_KERNEL_EXEC	__pgprot(_PAGE_KERNEL_EXEC)
 
-#ifdef CONFIG_HOMECACHE
-#define page_to_kpgprot(p) \
-	(page_home(p) == PAGE_HOME_IMMUTABLE ? PAGE_KERNEL_RO : PAGE_KERNEL)
-#else
 #define page_to_kpgprot(p) PAGE_KERNEL
-#endif
 
 /*
  * We could tighten these up, but for now writable or executable
@@ -177,14 +172,14 @@
  */
 static inline void __pte_clear(pte_t *ptep)
 {
-
-
-
+#ifdef __tilegx__
+	ptep->val = 0;
+#else
 	u32 *tmp = (u32 *)ptep;
 	tmp[0] = 0;
 	barrier();
 	tmp[1] = 0;
-
+#endif
 }
 #define pte_clear(mm, addr, ptep) __pte_clear(ptep)
 
@@ -387,11 +382,11 @@
 
 #endif /* !__ASSEMBLY__ */
 
-
-
-
+#ifdef __tilegx__
+#include <asm/pgtable_64.h>
+#else
 #include <asm/pgtable_32.h>
-
+#endif
 
 #ifndef __ASSEMBLY__
 
diff -ru tile.old/include/asm/pgtable_32.h tile/include/asm/pgtable_32.h
--- tile.old/include/asm/pgtable_32.h	2010-05-28 18:03:32.476000000 -0400
+++ tile/include/asm/pgtable_32.h	2010-05-28 23:07:05.625621000 -0400
@@ -49,19 +49,26 @@
 #define LAST_PKMAP PTRS_PER_PTE
 
 #define PKMAP_BASE   ((FIXADDR_BOOT_START - PAGE_SIZE*LAST_PKMAP) & PGDIR_MASK)
+
 #ifdef CONFIG_HIGHMEM
-# define HUGE_VMAP_END	(PKMAP_BASE & ~(HPAGE_SIZE-1))
+# define __VMAPPING_END	(PKMAP_BASE & ~(HPAGE_SIZE-1))
 #else
-# define HUGE_VMAP_END	(FIXADDR_START & ~(HPAGE_SIZE-1))
+# define __VMAPPING_END	(FIXADDR_START & ~(HPAGE_SIZE-1))
 #endif
+
+#ifdef CONFIG_HUGEVMAP
+#define HUGE_VMAP_END	__VMAPPING_END
 #define HUGE_VMAP_BASE	(HUGE_VMAP_END - CONFIG_NR_HUGE_VMAPS * HPAGE_SIZE)
+#define _VMALLOC_END	HUGE_VMAP_BASE
+#else
+#define _VMALLOC_END	__VMAPPING_END
+#endif
 
 /*
  * Align the vmalloc area to an L2 page table, and leave a guard page
  * at the beginning and end.  The vmalloc code also puts in an internal
  * guard page between each allocation.
  */
-#define _VMALLOC_END	HUGE_VMAP_BASE
 #define VMALLOC_END	(_VMALLOC_END - PAGE_SIZE)
 extern unsigned long VMALLOC_RESERVE /* = CONFIG_VMALLOC_RESERVE */;
 #define _VMALLOC_START	(_VMALLOC_END - VMALLOC_RESERVE)
diff -ru tile.old/include/asm/posix_types.h tile/include/asm/posix_types.h
--- tile.old/include/asm/posix_types.h	2010-05-28 18:03:32.486990000 -0400
+++ tile/include/asm/posix_types.h	2010-05-28 23:07:05.622635000 -0400
@@ -1,77 +1 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_POSIX_TYPES_H
-#define _ASM_TILE_POSIX_TYPES_H
-
-/*
- * This file is generally used by user-level software, so you need to
- * be a little careful about namespace pollution etc.
- */
-
-typedef unsigned long	__kernel_ino_t;
-typedef unsigned int	__kernel_mode_t;
-typedef unsigned int	__kernel_nlink_t;
-typedef long		__kernel_off_t;
-typedef long long	__kernel_loff_t;
-typedef int		__kernel_pid_t;
-typedef unsigned int	__kernel_ipc_pid_t;
-typedef unsigned int	__kernel_uid_t;
-typedef unsigned int	__kernel_gid_t;
-
-
-
-
-
-typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_ssize_t;
-typedef int		__kernel_ptrdiff_t;
-
-typedef long		__kernel_time_t;
-typedef long		__kernel_suseconds_t;
-typedef long		__kernel_clock_t;
-typedef int		__kernel_timer_t;
-typedef int		__kernel_clockid_t;
-typedef int		__kernel_daddr_t;
-typedef char		*__kernel_caddr_t;
-typedef unsigned short	__kernel_uid16_t;
-typedef unsigned short	__kernel_gid16_t;
-typedef unsigned int	__kernel_uid32_t;
-typedef unsigned int	__kernel_gid32_t;
-
-typedef unsigned short	__kernel_old_uid_t;
-typedef unsigned short	__kernel_old_gid_t;
-typedef unsigned short	__kernel_old_dev_t;
-
-typedef struct {
-	int	val[2];
-} __kernel_fsid_t;
-
-#if defined(__KERNEL__)
-
-#undef	__FD_SET
-#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
-
-#undef	__FD_CLR
-#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-
-#undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
-
-#undef	__FD_ZERO
-#define __FD_ZERO(fdsetp)	memset(fdsetp, 0, sizeof(fd_set))
-
-#endif /* defined(__KERNEL__) */
-
-#endif /* _ASM_TILE_POSIX_TYPES_H */
+#include <asm-generic/posix_types.h>
diff -ru tile.old/include/asm/processor.h tile/include/asm/processor.h
--- tile.old/include/asm/processor.h	2010-05-28 18:03:32.489982000 -0400
+++ tile/include/asm/processor.h	2010-05-28 23:07:05.635602000 -0400
@@ -25,13 +25,11 @@
 #include <asm/percpu.h>
 
 #include <arch/chip.h>
-#include <arch/cycle.h>
 #include <arch/spr_def.h>
 
 struct task_struct;
 struct thread_struct;
 struct list_head;
-struct khardwall_rectangle;
 
 typedef struct {
 	unsigned long seg;
@@ -41,9 +39,6 @@
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
  */
-
-
-
 void *current_text_addr(void);
 
 #if CHIP_HAS_TILE_DMA()
@@ -79,10 +74,6 @@
 	unsigned long address;   /* what address faulted? */
 };
 
-/* Can't use a normal list_head here due to header-file inclusion issues. */
-struct hardwall_list {
-	struct list_head *next, *prev;
-};
 
 struct thread_struct {
 	/* kernel stack pointer */
@@ -109,10 +100,6 @@
 	/* Any other miscellaneous processor state bits */
 	unsigned long proc_status;
 #endif
-	/* Is this task tied to an activated hardwall? */
-	struct khardwall_rectangle *hardwall;
-	/* Chains this task into the list at hardwall->list. */
-	struct hardwall_list hardwall_list;
 #if CHIP_HAS_TILE_DMA()
 	/* Async DMA TLB fault information */
 	struct async_tlb dma_async_tlb;
@@ -123,17 +110,6 @@
 	/* Async SNI TLB fault information */
 	struct async_tlb sn_async_tlb;
 #endif
-#ifdef CONFIG_HOMECACHE
-	/* Requested home for allocated pages. */
-	int homecache_desired_home;
-	/*
-	 * Per-thread storage for migrating kernel threads.
-	 * This is effectively a cpumask_t, but header inclusion
-	 * issues prevent us from declaring it as such here.
-	 */
-	unsigned long homecache_tlb_flush[(NR_CPUS + (8 * sizeof(long)) - 1) /
-					  (8 * sizeof(long))];
-#endif
 };
 
 #endif /* !__ASSEMBLY__ */
@@ -149,19 +125,19 @@
  * pt_regs structure this many bytes below the top of the page.
  * This aligns the pt_regs structure optimally for cache-line access.
  */
-
-
-
+#ifdef __tilegx__
+#define KSTK_PTREGS_GAP  48
+#else
 #define KSTK_PTREGS_GAP  56
-
+#endif
 
 #ifndef __ASSEMBLY__
 
-
-
-
+#ifdef __tilegx__
+#define TASK_SIZE_MAX		(MEM_LOW_END + 1)
+#else
 #define TASK_SIZE_MAX		PAGE_OFFSET
-
+#endif
 
 /* TASK_SIZE and related variables are always checked in "current" context. */
 #ifdef CONFIG_COMPAT
@@ -219,15 +195,6 @@
 extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
 /* Helper routines for setting home cache modes at exec() time. */
-#if defined(CONFIG_HOMECACHE) && CHIP_HAS_CBOX_HOME_MAP()
-struct vm_area_struct;
-extern void arch_exec_env(char __user *__user *envp);
-extern void arch_exec_vma(struct vm_area_struct *);
-extern void arch_exec_map(unsigned long addr);
-#define arch_exec_env arch_exec_env
-#define arch_exec_vma arch_exec_vma
-#define arch_exec_map arch_exec_map
-#endif /* CHIP_HAS_CBOX_HOME_MAP() */
 
 
 /*
@@ -252,11 +219,11 @@
 #define KSTK_ESP(task)	task_sp(task)
 
 /* Standard format for printing registers and other word-size data. */
-
-
-
+#ifdef __tilegx__
+# define REGFMT "0x%016lx"
+#else
 # define REGFMT "0x%08lx"
-
+#endif
 
 /*
  * Do some slow action (e.g. read a slow SPR).
@@ -265,7 +232,7 @@
  */
 static inline void cpu_relax(void)
 {
-	cycle_relax();
+	__insn_mfspr(SPR_PASS);
 	barrier();
 }
 
@@ -279,15 +246,6 @@
 /* Data on which physical memory controller corresponds to which NUMA node. */
 extern int node_controller[];
 
-#ifdef CONFIG_DATAPLANE
-/*
- * Which cpu does any specific "singlethread" type work, such as
- * running the main timer tick code or the singlethread workqueue.
- * Defined in platform-generic code in kernel/workqueue.c but not
- * always exported.
- */
-extern int singlethread_cpu;
-#endif
 
 /* Do we dump information to the console when a user application crashes? */
 extern int show_crashinfo;
diff -ru tile.old/include/asm/ptrace.h tile/include/asm/ptrace.h
--- tile.old/include/asm/ptrace.h	2010-05-28 18:03:32.499974000 -0400
+++ tile/include/asm/ptrace.h	2010-05-28 23:07:05.633608000 -0400
@@ -146,10 +146,10 @@
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code);
 
-
-
-
-
+#ifdef __tilegx__
+/* We need this since sigval_t has a user pointer in it, for GETSIGINFO etc. */
+#define __ARCH_WANT_COMPAT_SYS_PTRACE
+#endif
 
 #endif /* !__ASSEMBLY__ */
 
diff -ru tile.old/include/asm/sections.h tile/include/asm/sections.h
--- tile.old/include/asm/sections.h	2010-05-28 18:03:32.503972000 -0400
+++ tile/include/asm/sections.h	2010-05-28 23:07:05.650582000 -0400
@@ -20,8 +20,7 @@
 #include <asm-generic/sections.h>
 
 /* Text and data are at different areas in the kernel VA space. */
-extern char __init_text_begin[], __init_text_end[];
-extern char __init_data_begin[], __init_data_end[];
+extern char _sinitdata[], _einitdata[];
 
 /* Write-once data is writable only till the end of initialization. */
 extern char __w1data_begin[], __w1data_end[];
diff -ru tile.old/include/asm/sembuf.h tile/include/asm/sembuf.h
--- tile.old/include/asm/sembuf.h	2010-05-28 18:03:32.513967000 -0400
+++ tile/include/asm/sembuf.h	2010-05-28 23:07:05.652593000 -0400
@@ -1,42 +1 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_SEMBUF_H
-#define _ASM_TILE_SEMBUF_H
-
-/*
- * The semid64_ds structure for TILE architecture.
- * Note extra padding because this structure is passed back and forth
- * between kernel and user space.
- *
- * Pad space is left for:
- * - 64-bit time_t to solve y2038 problem
- * - 2 miscellaneous 32-bit values
- */
-struct semid64_ds {
-	struct ipc64_perm sem_perm;	/* permissions .. see ipc.h */
-	__kernel_time_t	sem_otime;	/* last semop time */
-
-	unsigned long	__unused1;
-
-	__kernel_time_t	sem_ctime;	/* last change time */
-
-	unsigned long	__unused2;
-
-	unsigned long	sem_nsems;	/* no. of semaphores in array */
-	unsigned long	__unused3;
-	unsigned long	__unused4;
-};
-
-#endif /* _ASM_TILE_SEMBUF_H */
+#include <asm-generic/sembuf.h>
diff -ru tile.old/include/asm/setup.h tile/include/asm/setup.h
--- tile.old/include/asm/setup.h	2010-05-28 18:03:32.530951000 -0400
+++ tile/include/asm/setup.h	2010-05-28 23:07:05.666569000 -0400
@@ -15,7 +15,6 @@
 #ifndef _ASM_TILE_SETUP_H
 #define _ASM_TILE_SETUP_H
 
-#ifdef __KERNEL__
 #include <linux/pfn.h>
 #include <linux/init.h>
 
@@ -23,7 +22,6 @@
  * Reserved space for vmalloc and iomap - defined in asm/page.h
  */
 #define MAXMEM_PFN	PFN_DOWN(MAXMEM)
-#endif
 
 #define COMMAND_LINE_SIZE	2048
 
diff -ru tile.old/include/asm/shmparam.h tile/include/asm/shmparam.h
--- tile.old/include/asm/shmparam.h	2010-05-28 18:03:32.539936000 -0400
+++ tile/include/asm/shmparam.h	2010-05-28 23:07:05.659580000 -0400
@@ -1,20 +1 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_SHMPARAM_H
-#define _ASM_TILE_SHMPARAM_H
-
-#define SHMLBA PAGE_SIZE		 /* attach addr a multiple of this */
-
-#endif /* _ASM_TILE_SHMPARAM_H */
+#include <asm-generic/shmparam.h>
diff -ru tile.old/include/asm/siginfo.h tile/include/asm/siginfo.h
--- tile.old/include/asm/siginfo.h	2010-05-28 18:03:32.579892000 -0400
+++ tile/include/asm/siginfo.h	2010-05-28 23:07:05.685548000 -0400
@@ -23,7 +23,8 @@
  * Additional Tile-specific SIGILL si_codes
  */
 #define ILL_DBLFLT	(__SI_FAULT|9)	/* double fault */
+#define ILL_HARDWALL	(__SI_FAULT|10)	/* user networks hardwall violation */
 #undef NSIGILL
-#define NSIGILL		9
+#define NSIGILL		10
 
 #endif /* _ASM_TILE_SIGINFO_H */
diff -ru tile.old/include/asm/smp.h tile/include/asm/smp.h
--- tile.old/include/asm/smp.h	2010-05-28 18:03:32.596886000 -0400
+++ tile/include/asm/smp.h	2010-05-28 23:07:05.691560000 -0400
@@ -19,6 +19,7 @@
 
 #include <asm/processor.h>
 #include <linux/cpumask.h>
+#include <linux/irqreturn.h>
 
 /* Set up this tile to support receiving hypervisor messages */
 void init_messaging(void);
@@ -39,7 +40,7 @@
 void evaluate_message(int tag);
 
 /* Process an IRQ_RESCHEDULE IPI. */
-void handle_reschedule_ipi(void *token);
+irqreturn_t handle_reschedule_ipi(int irq, void *token);
 
 /* Boot a secondary cpu */
 void online_secondary(void);
@@ -87,9 +88,6 @@
 
 #endif /* !CONFIG_SMP */
 
-#ifdef CONFIG_DATAPLANE
-extern struct cpumask dataplane_map;      /* set of cpus in the dataplane */
-#endif
 
 /* Which cpus may be used as the lotar in a page table entry. */
 extern struct cpumask cpu_lotar_map;
diff -ru tile.old/include/asm/spinlock.h tile/include/asm/spinlock.h
--- tile.old/include/asm/spinlock.h	2010-05-28 18:03:32.621853000 -0400
+++ tile/include/asm/spinlock.h	2010-05-28 23:07:05.695536000 -0400
@@ -15,10 +15,10 @@
 #ifndef _ASM_TILE_SPINLOCK_H
 #define _ASM_TILE_SPINLOCK_H
 
-
-
-
+#ifdef __tilegx__
+#include <asm/spinlock_64.h>
+#else
 #include <asm/spinlock_32.h>
-
+#endif
 
 #endif /* _ASM_TILE_SPINLOCK_H */
diff -ru tile.old/include/asm/spinlock_32.h tile/include/asm/spinlock_32.h
--- tile.old/include/asm/spinlock_32.h	2010-05-28 18:03:32.635843000 -0400
+++ tile/include/asm/spinlock_32.h	2010-05-28 23:07:05.701539000 -0400
@@ -108,9 +108,6 @@
 {
 	u32 val = __insn_tns((int *)&rwlock->lock);
 	if (unlikely(val << _RD_COUNT_WIDTH)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		arch_read_lock_slow(rwlock, val);
 		return;
 	}
@@ -124,9 +121,6 @@
 {
 	u32 val = __insn_tns((int *)&rwlock->lock);
 	if (unlikely(val != 0)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		arch_write_lock_slow(rwlock, val);
 		return;
 	}
@@ -141,9 +135,6 @@
 	int locked;
 	u32 val = __insn_tns((int *)&rwlock->lock);
 	if (unlikely(val & 1)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		return arch_read_trylock_slow(rwlock);
 	}
 	locked = (val << _RD_COUNT_WIDTH) == 0;
@@ -163,9 +154,6 @@
 	 * or active readers, we can't take the lock, so give up.
 	 */
 	if (unlikely(val != 0)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		if (!(val & 1))
 			rwlock->lock = val;
 		return 0;
@@ -185,9 +173,6 @@
 	mb();  /* guarantee anything modified under the lock is visible */
 	val = __insn_tns((int *)&rwlock->lock);
 	if (unlikely(val & 1)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		arch_read_unlock_slow(rwlock);
 		return;
 	}
@@ -203,9 +188,6 @@
 	mb();  /* guarantee anything modified under the lock is visible */
 	val = __insn_tns((int *)&rwlock->lock);
 	if (unlikely(val != (1 << _WR_NEXT_SHIFT))) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		arch_write_unlock_slow(rwlock, val);
 		return;
 	}
diff -ru tile.old/include/asm/spinlock_types.h tile/include/asm/spinlock_types.h
--- tile.old/include/asm/spinlock_types.h	2010-05-28 18:03:32.659812000 -0400
+++ tile/include/asm/spinlock_types.h	2010-05-28 23:07:05.709529000 -0400
@@ -19,23 +19,23 @@
 # error "please don't include this file directly"
 #endif
 
+#ifdef __tilegx__
 
+/* Low 15 bits are "next"; high 15 bits are "current". */
+typedef struct arch_spinlock {
+	unsigned int lock;
+} arch_spinlock_t;
 
+#define __ARCH_SPIN_LOCK_UNLOCKED	{ 0 }
 
+/* High bit is "writer owns"; low 31 bits are a count of readers. */
+typedef struct arch_rwlock {
+	unsigned int lock;
+} arch_rwlock_t;
 
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
-
-
-
-
-
-
-
-
-
-
-
-
+#else
 
 typedef struct arch_spinlock {
 	/* Next ticket number to hand out. */
@@ -56,5 +56,5 @@
 
 #define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
-
+#endif
 #endif /* _ASM_TILE_SPINLOCK_TYPES_H */
diff -ru tile.old/include/asm/stat.h tile/include/asm/stat.h
--- tile.old/include/asm/stat.h	2010-05-28 18:03:32.684792000 -0400
+++ tile/include/asm/stat.h	2010-05-28 23:07:05.714520000 -0400
@@ -1,79 +1 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- */
-
-#ifndef _ASM_TILE_STAT_H
-#define _ASM_TILE_STAT_H
-
-#include <linux/posix_types.h>
-
-#define STAT_HAVE_NSEC 1
-
-struct stat {
-	unsigned long	st_dev;
-	unsigned long	st_ino;
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned long	st_rdev;
-	long		st_size;
-	unsigned long	st_blksize;
-	unsigned long	st_blocks;
-
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-	unsigned long	st_ctime;
-	unsigned long	st_ctime_nsec;
-	unsigned long	__unused[2];
-};
-
-
-
-struct stat64 {
-	unsigned long long	st_dev;
-
-	unsigned long long	st_ino;
-
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-
-	unsigned long long	st_rdev;
-
-	long long	st_size;
-	unsigned long	st_blksize;
-
-	/* No. 512-byte blocks allocated */
-	unsigned long long	st_blocks __attribute__((packed));
-
-	unsigned long	st_atime;
-	unsigned long	st_atime_nsec;
-
-	unsigned long	st_mtime;
-	unsigned long	st_mtime_nsec;
-
-	unsigned long	st_ctime;
-	unsigned long	st_ctime_nsec;
-
-	unsigned long	__unused8;
-};
-
-
-
-#endif /* _ASM_TILE_STAT_H */
+#include <asm-generic/stat.h>
diff -ru tile.old/include/asm/swab.h tile/include/asm/swab.h
--- tile.old/include/asm/swab.h	2010-05-28 18:03:32.714769000 -0400
+++ tile/include/asm/swab.h	2010-05-28 23:07:05.748487000 -0400
@@ -20,10 +20,10 @@
 #define __arch_swab64(x) __builtin_bswap64(x)
 
 /* Use the variant that is natural for the wordsize. */
-
-
-
+#ifdef CONFIG_64BIT
+#define __arch_swab16(x) (__builtin_bswap64(x) >> 48)
+#else
 #define __arch_swab16(x) (__builtin_bswap32(x) >> 16)
-
+#endif
 
 #endif /* _ASM_TILE_SWAB_H */
diff -ru tile.old/include/asm/syscalls.h tile/include/asm/syscalls.h
--- tile.old/include/asm/syscalls.h	2010-05-28 18:03:32.733747000 -0400
+++ tile/include/asm/syscalls.h	2010-05-28 23:07:05.765467000 -0400
@@ -39,16 +39,22 @@
 int sys_raise_fpe(int code, unsigned long addr, struct pt_regs*);
 
 /* kernel/sys.c */
+ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count);
+long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
+		     u32 len, int advice);
+int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
+		       u32 len_lo, u32 len_hi, int advice);
+long sys_flush_cache(void);
 long sys_mmap(unsigned long addr, unsigned long len,
 	      unsigned long prot, unsigned long flags,
 	      unsigned long fd, unsigned long offset);
 long sys_mmap2(unsigned long addr, unsigned long len,
 	       unsigned long prot, unsigned long flags,
-	       unsigned long fd, unsigned long pgoff);
-
+	       unsigned long fd, unsigned long offset);
 
+#ifndef __tilegx__
 /* mm/fault.c */
 int sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
-
+#endif
 
 #endif /* _ASM_TILE_SYSCALLS_H */
diff -ru tile.old/include/asm/system.h tile/include/asm/system.h
--- tile.old/include/asm/system.h	2010-05-28 18:03:32.741735000 -0400
+++ tile/include/asm/system.h	2010-05-28 23:07:05.767478000 -0400
@@ -22,7 +22,6 @@
 
 /* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
 #include <asm/ptrace.h>
-#include <asm/addrspace.h>
 
 #include <arch/chip.h>
 #include <arch/sim_def.h>
@@ -192,17 +191,13 @@
 void grant_dma_mpls(void);
 void restrict_dma_mpls(void);
 
-/* User-level network management functions */
-void reset_network_state(void);
-void grant_network_mpls(void);
-void restrict_network_mpls(void);
-int hardwall_deactivate(struct task_struct *task);
-
-/* Hook hardwall code into changes in affinity. */
-#define arch_set_cpus_allowed(p, new_mask) do { \
-	if (p->thread.hardwall && !cpumask_equal(&p->cpus_allowed, new_mask)) \
-		hardwall_deactivate(p); \
-  } while (0)
+
+/* Invoke the simulator "syscall" mechanism (see arch/tile/kernel/entry.S). */
+extern int _sim_syscall(int syscall_num, ...);
+#define sim_syscall(syscall_num, ...) \
+	_sim_syscall(SIM_CONTROL_SYSCALL + \
+		((syscall_num) << _SIM_CONTROL_OPERATOR_BITS), \
+		## __VA_ARGS__)
 
 /*
  * Kernel threads can check to see if they need to migrate their
diff -ru tile.old/include/asm/thread_info.h tile/include/asm/thread_info.h
--- tile.old/include/asm/thread_info.h	2010-05-28 18:03:32.751726000 -0400
+++ tile/include/asm/thread_info.h	2010-05-28 23:07:05.771466000 -0400
@@ -16,8 +16,6 @@
 #ifndef _ASM_TILE_THREAD_INFO_H
 #define _ASM_TILE_THREAD_INFO_H
 
-#ifdef __KERNEL__
-
 #include <asm/processor.h>
 #include <asm/page.h>
 #ifndef __ASSEMBLY__
@@ -96,11 +94,11 @@
 #else /* __ASSEMBLY__ */
 
 /* how to get the thread information struct from ASM */
-
-
-
+#ifdef __tilegx__
+#define GET_THREAD_INFO(reg) move reg, sp; mm reg, zero, LOG2_THREAD_SIZE, 63
+#else
 #define GET_THREAD_INFO(reg) mm reg, sp, zero, LOG2_THREAD_SIZE, 31
-
+#endif
 
 #endif /* !__ASSEMBLY__ */
 
@@ -141,9 +139,9 @@
  * ever touches our thread-synchronous status, so we don't
  * have to worry about atomic accesses.
  */
-
-
-
+#ifdef __tilegx__
+#define TS_COMPAT		0x0001	/* 32-bit compatibility mode */
+#endif
 #define TS_POLLING		0x0004	/* in idle loop but not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal */
 #define TS_EXEC_HASH_SET	0x0010	/* apply TS_EXEC_HASH_xxx flags */
@@ -164,6 +162,4 @@
 }
 #endif	/* !__ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_TILE_THREAD_INFO_H */
Only in tile.old/include/asm: tilepci.h
diff -ru tile.old/include/asm/timex.h tile/include/asm/timex.h
--- tile.old/include/asm/timex.h	2010-05-28 18:03:32.776707000 -0400
+++ tile/include/asm/timex.h	2010-05-28 23:07:05.782451000 -0400
@@ -15,18 +15,25 @@
 #ifndef _ASM_TILE_TIMEX_H
 #define _ASM_TILE_TIMEX_H
 
-#include <arch/cycle.h>
-
-/* Use this random value, just like most archs.  Mysterious. */
-#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+/*
+ * This rate should be a multiple of the possible HZ values (100, 250, 1000)
+ * and a fraction of the possible hardware timer frequencies.  Our timer
+ * frequency is highly tunable but also quite precise, so for the primary use
+ * of this value (setting ACT_HZ from HZ) we just pick a value that causes
+ * ACT_HZ to be set to HZ.  We make the value somewhat large just to be
+ * more robust in case someone tries out a new value of HZ.
+ */
+#define CLOCK_TICK_RATE	1000000
 
 typedef unsigned long long cycles_t;
 
 #if CHIP_HAS_SPLIT_CYCLE()
-/* Use out-of-line implementation of get_cycle_count() for code density. */
 cycles_t get_cycles(void);
 #else
-static inline cycles_t get_cycles(void) { return get_cycle_count(); }
+static inline cycles_t get_cycles(void)
+{
+	return __insn_mfspr(SPR_CYCLE);
+}
 #endif
 
 cycles_t get_clock_rate(void);
@@ -37,15 +44,4 @@
 /* Called at cpu initialization to start the tile-timer clock device. */
 void setup_tile_timer(void);
 
-/* Preferred technique for setting LPJ. */
-#define arch_calibrate_delay_direct() (get_clock_rate() / HZ)
-
-/* Backup technique for setting LPJ. */
-#define ARCH_HAS_READ_CURRENT_TIMER
-static inline int read_current_timer(unsigned long *timer_value)
-{
-	*timer_value = get_cycle_count_low();
-	return 0;
-}
-
 #endif /* _ASM_TILE_TIMEX_H */
diff -ru tile.old/include/asm/traps.h tile/include/asm/traps.h
--- tile.old/include/asm/traps.h	2010-05-28 18:03:32.849635000 -0400
+++ tile/include/asm/traps.h	2010-05-28 23:07:05.803452000 -0400
@@ -22,9 +22,6 @@
 /* kernel/traps.c */
 void do_trap(struct pt_regs *, int fault_num, unsigned long reason);
 
-/* kernel/hardwall.c */
-void do_hardwall_trap(struct pt_regs*, int fault_num);
-
 /* kernel/time.c */
 void do_timer_interrupt(struct pt_regs *, int fault_num);
 
@@ -34,10 +31,6 @@
 /* kernel/irq.c */
 void tile_dev_intr(struct pt_regs *, int intnum);
 
-/* oprofile/op_common.c */
-void op_handle_perf_interrupt(struct pt_regs*, int fault_num,
-			      unsigned long perf_count_sts);
-void op_handle_aux_perf_interrupt(struct pt_regs*, int fault_num,
-				  unsigned long perf_count_sts);
+
 
 #endif /* _ASM_TILE_SYSCALLS_H */
diff -ru tile.old/include/asm/uaccess.h tile/include/asm/uaccess.h
--- tile.old/include/asm/uaccess.h	2010-05-28 18:03:32.902570000 -0400
+++ tile/include/asm/uaccess.h	2010-05-28 23:07:05.820434000 -0400
@@ -45,7 +45,7 @@
 
 #define segment_eq(a, b) ((a).seg == (b).seg)
 
-
+#ifndef __tilegx__
 /*
  * We could allow mapping all 16 MB at 0xfc000000, but we set up a
  * special hack in arch_setup_additional_pages() to auto-create a mapping
@@ -60,9 +60,9 @@
 		size <= (MEM_USER_INTRPT + INTRPT_SIZE) - addr);
 }
 #define is_arch_mappable_range is_arch_mappable_range
-
-
-
+#else
+#define is_arch_mappable_range(addr, size) 0
+#endif
 
 /*
  * Test whether a block of memory is a valid user space address.
@@ -372,39 +372,39 @@
 #define copy_from_user _copy_from_user
 #endif
 
+#ifdef __tilegx__
+/**
+ * __copy_in_user() - copy data within user space, with less checking.
+ * @to:   Destination address, in user space.
+ * @from: Source address, in kernel space.
+ * @n:    Number of bytes to copy.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Copy data from user space to user space.  Caller must check
+ * the specified blocks with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be copied.
+ * On success, this will be zero.
+ */
+extern unsigned long __copy_in_user_asm(
+	void __user *to, const void __user *from, unsigned long n);
 
+static inline unsigned long __must_check
+__copy_in_user(void __user *to, const void __user *from, unsigned long n)
+{
+	might_sleep();
+	return __copy_in_user_asm(to, from, n);
+}
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+static inline unsigned long __must_check
+copy_in_user(void __user *to, const void __user *from, unsigned long n)
+{
+	if (access_ok(VERIFY_WRITE, to, n) && access_ok(VERIFY_READ, from, n))
+		n = __copy_in_user(to, from, n);
+	return n;
+}
+#endif
 
 
 /**
diff -ru tile.old/include/asm/unistd.h tile/include/asm/unistd.h
--- tile.old/include/asm/unistd.h	2010-05-28 18:03:32.908576000 -0400
+++ tile/include/asm/unistd.h	2010-05-28 23:07:05.829406000 -0400
@@ -12,385 +12,36 @@
  *   more details.
  */
 
-#ifndef _ASM_TILE_UNISTD_H
+#if !defined(_ASM_TILE_UNISTD_H) || defined(__SYSCALL)
 #define _ASM_TILE_UNISTD_H
 
-/*
- * This file contains the system call numbers.
- */
 
-#define __NR_restart_syscall	  0
-#define __NR_exit		  1
-#define __NR_fork		  2
-#define __NR_read		  3
-#define __NR_write		  4
-#define __NR_open		  5
-#define __NR_close		  6
-#define __NR_waitpid		  7
-#define __NR_creat		  8
-#define __NR_link		  9
-#define __NR_unlink		 10
-#define __NR_execve		 11
-#define __NR_chdir		 12
-#define __NR_time		 13
-#define __NR_mknod		 14
-#define __NR_chmod		 15
-#define __NR_lchown		 16
-#define __NR_stat		 17
-#define __NR_lseek		 18
-#define __NR_getpid		 19
-#define __NR_mount		 20
-#define __NR_umount2		 21
-#define __NR_setuid		 22
-#define __NR_getuid		 23
-#define __NR_stime		 24
-#define __NR_ptrace		 25
-#define __NR_alarm		 26
-#define __NR_fstat		 27
-#define __NR_pause		 28
-#define __NR_utime		 29
-#define __NR_access		 30
-#define __NR_nice		 31
-#define __NR_sync		 32
-#define __NR_kill		 33
-#define __NR_rename		 34
-#define __NR_mkdir		 35
-#define __NR_rmdir		 36
-#define __NR_dup		 37
-#define __NR_pipe		 38
-#define __NR_times		 39
-#define __NR_brk		 40
-#define __NR_setgid		 41
-#define __NR_getgid		 42
-/* unused			 43 */
-#define __NR_geteuid		 44
-#define __NR_getegid		 45
-#define __NR_acct		 46
-#define __NR_ioctl		 47
-#define __NR_fcntl		 48
-#define __NR_setpgid		 49
-#define __NR_umask		 50
-#define __NR_chroot		 51
-#define __NR_ustat		 52
-#define __NR_dup2		 53
-#define __NR_getppid		 54
-#define __NR_getpgrp		 55
-#define __NR_setsid		 56
-/* unused			 57 */
-/* unused			 58 */
-#define __NR_setreuid		 59
-#define __NR_setregid		 60
-/* unused			 61 */
-#define __NR_sethostname	 62
-#define __NR_setrlimit		 63
-#define __NR_getrlimit		 64
-#define __NR_getrusage		 65
-#define __NR_gettimeofday	 66
-#define __NR_settimeofday	 67
-#define __NR_getgroups		 68
-#define __NR_setgroups		 69
-#define __NR_select		 70
-#define __NR_symlink		 71
-#define __NR_lstat		 72
-#define __NR_readlink		 73
-#define __NR_uselib		 74
-#define __NR_swapon		 75
-#define __NR_reboot		 76
-#define __NR_mmap2		 77
-#define __NR_munmap		 78
-#define __NR_truncate		 79
-#define __NR_ftruncate		 80
-#define __NR_fchmod		 81
-#define __NR_fchown		 82
-#define __NR_getpriority	 83
-#define __NR_setpriority	 84
-#define __NR_statfs		 85
-#define __NR_fstatfs		 86
-#define __NR_socket		 87
-#define __NR_bind		 88
-#define __NR_connect		 89
-#define __NR_listen		 90
-#define __NR_accept		 91
-#define __NR_getsockname	 92
-#define __NR_getpeername	 93
-#define __NR_socketpair		 94
-#define __NR_send		 95
-#define __NR_sendto		 96
-#define __NR_recv		 97
-#define __NR_recvfrom		 98
-#define __NR_shutdown		 99
-#define __NR_setsockopt		100
-#define __NR_getsockopt		101
-#define __NR_sendmsg		102
-#define __NR_recvmsg		103
-#define __NR_syslog		104
-#define __NR_setitimer		105
-#define __NR_getitimer		106
-#define __NR_vhangup		107
-#define __NR_wait4		108
-#define __NR_swapoff		109
-#define __NR_sysinfo		110
-#define __NR_shmget		111
-#define __NR_shmat		112
-#define __NR_shmctl		113
-#define __NR_shmdt		114
-#define __NR_semget		115
-#define __NR_semop		116
-#define __NR_semctl		117
-#define __NR_semtimedop		118
-#define __NR_msgget		119
-#define __NR_msgsnd		120
-#define __NR_msgrcv		121
-#define __NR_msgctl		122
-#define __NR_fsync		123
-#define __NR_sigreturn		124
-#define __NR_clone		125
-#define __NR_setdomainname	126
-#define __NR_uname		127
-#define __NR_adjtimex		128
-#define __NR_mprotect		129
-/* unused			130 */
-#define __NR_init_module	131
-#define __NR_delete_module	132
-#define __NR_quotactl		133
-#define __NR_getpgid		134
-#define __NR_fchdir		135
-#define __NR_bdflush		136
-#define __NR_sysfs		137
-#define __NR_personality	138
-#define __NR_afs_syscall	139 /* Syscall for Andrew File System */
-#define __NR_setfsuid		140
-#define __NR_setfsgid		141
-#define __NR__llseek		142
-#define __NR_getdents		143
-#define __NR_flock		144
-#define __NR_msync		145
-#define __NR_readv		146
-#define __NR_writev		147
-#define __NR_getsid		148
-#define __NR_fdatasync		149
-#define __NR__sysctl		150
-#define __NR_mlock		151
-#define __NR_munlock		152
-#define __NR_mlockall		153
-#define __NR_munlockall		154
-#define __NR_sched_setparam	155
-#define __NR_sched_getparam	156
-#define __NR_sched_setscheduler 157
-#define __NR_sched_getscheduler 158
-#define __NR_sched_yield	159
-#define __NR_sched_get_priority_max	160
-#define __NR_sched_get_priority_min	161
-#define __NR_sched_rr_get_interval	162
-#define __NR_nanosleep		163
-#define __NR_mremap		164
-#define __NR_setresuid		165
-#define __NR_getresuid		166
-#define __NR_poll		167
-#define __NR_nfsservctl		168
-#define __NR_setresgid		169
-#define __NR_getresgid		170
-#define __NR_prctl		171
-#define __NR_rt_sigreturn	172
-#define __NR_rt_sigaction	173
-#define __NR_rt_sigprocmask	174
-#define __NR_rt_sigpending	175
-#define __NR_rt_sigtimedwait	176
-#define __NR_rt_sigqueueinfo	177
-#define __NR_rt_sigsuspend	178
-#define __NR_pread64		179
-#define __NR_pwrite64		180
-#define __NR_chown		181
-#define __NR_getcwd		182
-#define __NR_capget		183
-#define __NR_capset		184
-#define __NR_sigaltstack	185
-#define __NR_sendfile		186
-#define __NR_getpmsg		187	/* some people actually want streams */
-#define __NR_putpmsg		188	/* some people actually want streams */
-#define __NR_vfork		189
-#define __NR_truncate64		190
-#define __NR_ftruncate64	191
-#define __NR_stat64		192
-#define __NR_lstat64		193
-#define __NR_fstat64		194
-#define __NR_pivot_root		195
-#define __NR_mincore		196
-#define __NR_madvise		197
-#define __NR_getdents64		198
-#define __NR_fcntl64		199
-#define __NR_gettid		200
-#define __NR_readahead		201
-#define __NR_setxattr		202
-#define __NR_lsetxattr		203
-#define __NR_fsetxattr		204
-#define __NR_getxattr		205
-#define __NR_lgetxattr		206
-#define __NR_fgetxattr		207
-#define __NR_listxattr		208
-#define __NR_llistxattr		209
-#define __NR_flistxattr		210
-#define __NR_removexattr	211
-#define __NR_lremovexattr	212
-#define __NR_fremovexattr	213
-#define __NR_tkill		214
-#define __NR_sendfile64		215
-#define __NR_futex		216
-#define __NR_sched_setaffinity	217
-#define __NR_sched_getaffinity	218
-#define __NR_io_setup		219
-#define __NR_io_destroy		220
-#define __NR_io_getevents	221
-#define __NR_io_submit		222
-#define __NR_io_cancel		223
-#define __NR_fadvise64		224
-#define __NR_migrate_pages	225
-#define __NR_exit_group		226
-#define __NR_lookup_dcookie	227
-#define __NR_epoll_create	228
-#define __NR_epoll_ctl		229
-#define __NR_epoll_wait		230
-#define __NR_remap_file_pages	231
-#define __NR_set_tid_address	232
-#define __NR_timer_create	233
-#define __NR_timer_settime	(__NR_timer_create+1)
-#define __NR_timer_gettime	(__NR_timer_create+2)
-#define __NR_timer_getoverrun	(__NR_timer_create+3)
-#define __NR_timer_delete	(__NR_timer_create+4)
-#define __NR_clock_settime	(__NR_timer_create+5)
-#define __NR_clock_gettime	(__NR_timer_create+6)
-#define __NR_clock_getres	(__NR_timer_create+7)
-#define __NR_clock_nanosleep	(__NR_timer_create+8)
-#define __NR_statfs64		242
-#define __NR_fstatfs64		243
-#define __NR_tgkill		244
-#define __NR_utimes		245
-#define __NR_fadvise64_64	246
-#define __NR_mbind		247
-#define __NR_get_mempolicy	248
-#define __NR_set_mempolicy	249
-#define __NR_mq_open		250
-#define __NR_mq_unlink		(__NR_mq_open+1)
-#define __NR_mq_timedsend	(__NR_mq_open+2)
-#define __NR_mq_timedreceive	(__NR_mq_open+3)
-#define __NR_mq_notify		(__NR_mq_open+4)
-#define __NR_mq_getsetattr	(__NR_mq_open+5)
-#define __NR_kexec_load		256
-#define __NR_waitid		257
-#define __NR_add_key		258
-#define __NR_request_key	259
-#define __NR_keyctl		260
-#define __NR_ioprio_set		261
-#define __NR_ioprio_get		262
-#define __NR_inotify_init	263
-#define __NR_inotify_add_watch	264
-#define __NR_inotify_rm_watch	265
-#define __NR_raise_fpe		266  /* TILE-specific */
-#define __NR_openat		267
-#define __NR_mkdirat		268
-#define __NR_mknodat		269
-#define __NR_fchownat		270
-#define __NR_futimesat		271
-#define __NR_fstatat64		272
-#define __NR_unlinkat		273
-#define __NR_renameat		274
-#define __NR_linkat		275
-#define __NR_symlinkat		276
-#define __NR_readlinkat		277
-#define __NR_fchmodat		278
-#define __NR_faccessat		279
-#define __NR_pselect6		280
-#define __NR_ppoll		281
-#define __NR_unshare		282
-#define __NR_set_robust_list	283
-#define __NR_get_robust_list	284
-#define __NR_splice		285
-#define __NR_sync_file_range2	286
-#define __NR_tee		287
-#define __NR_vmsplice		288
-#define __NR_move_pages		289
-#define __NR_mmap		290
-#define __NR_cmpxchg_badaddr	291  /* TILE-specific */
-#define __NR_getcpu		292
-#define __NR_epoll_pwait	293
-#define __NR_utimensat		294
-#define __NR_signalfd		295
-#define __NR_timerfd_create	296
-#define __NR_eventfd		297
-#define __NR_fallocate		298
-#define __NR_timerfd_settime	299
-#define __NR_timerfd_gettime	300
-#define __NR_flush_cache	301
-#define __NR_accept4		302
-#define __NR_signalfd4		303
-#define __NR_eventfd2		304
-#define __NR_epoll_create1	305
-#define __NR_dup3		306
-#define __NR_pipe2		307
-#define __NR_inotify_init1	308
-#define __NR_preadv		309
-#define __NR_pwritev		310
-#define __NR_rt_tgsigqueueinfo	311
-#define __NR_perf_event_open	312
-#define __NR_recvmmsg		313
+#ifndef __LP64__
+/* Use the flavor of this syscall that matches the 32-bit API better. */
+#define __ARCH_WANT_SYNC_FILE_RANGE2
+#endif
 
-#define NR_syscalls 314
+/* Use the standard ABI for syscalls. */
+#include <asm-generic/unistd.h>
 
-/* "Fast" syscalls don't preserve the caller-saved registers. */
+#ifndef __tilegx__
+/* "Fast" syscalls provide atomic support for 32-bit chips. */
 #define __NR_FAST_cmpxchg	-1
 #define __NR_FAST_atomic_update	-2
 #define __NR_FAST_cmpxchg64	-3
+#define __NR_cmpxchg_badaddr	(__NR_arch_specific_syscall + 0)
+__SYSCALL(__NR_cmpxchg_badaddr, sys_cmpxchg_badaddr)
+#endif
 
-#define NR_fast_syscalls 3
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+/* Additional Tilera-specific syscalls. */
+#define __NR_flush_cache	(__NR_arch_specific_syscall + 1)
+__SYSCALL(__NR_flush_cache, sys_flush_cache)
 
 #ifdef __KERNEL__
-
-#define __ARCH_WANT_SYS_ALARM
-#define __ARCH_WANT_SYS_PAUSE
-#define __ARCH_WANT_SYS_TIME
-#define __ARCH_WANT_SYS_UTIME
-#define __ARCH_WANT_SYS_WAITPID
-#define __ARCH_WANT_SYS_FADVISE64
-#define __ARCH_WANT_SYS_GETPGRP
-#define __ARCH_WANT_SYS_NICE
-#define __ARCH_WANT_SYS_RT_SIGACTION
-#define __ARCH_WANT_SYS_RT_SIGSUSPEND
-#define __ARCH_WANT_SYS_LLSEEK
-
-
-#define __ARCH_WANT_IPC_PARSE_VERSION
-#define __ARCH_WANT_STAT64
-
-
+/* In compat mode, we use sys_llseek() for compat_sys_llseek(). */
 #ifdef CONFIG_COMPAT
-#define __ARCH_WANT_COMPAT_SYS_TIME
+#define __ARCH_WANT_SYS_LLSEEK
 #endif
-
-/*
- * "Conditional" syscalls
- *
- * What we want is __attribute__((weak,alias("sys_ni_syscall"))),
- * but not all the conditional syscalls are prototyped in kernel/sys_ni.c,
- * causing build warnings, so we just do it by hand
- */
-#ifndef cond_syscall
-#define cond_syscall(x) asm(".weak\t" #x "\n\t.set\t" #x ",sys_ni_syscall")
 #endif
 
-#endif /* __KERNEL__ */
 #endif /* _ASM_TILE_UNISTD_H */
Only in tile.old/include/hv: drv_eeprom_intf.h
Only in tile.old/include/hv: drv_gpio_intf.h
Only in tile.old/include/hv: drv_hpi_intf.h
Only in tile.old/include/hv: drv_i2cm_intf.h
Only in tile.old/include/hv: drv_memprof_intf.h
Only in tile.old/include/hv: drv_pcie_channel_intf.h
Only in tile.old/include/hv: drv_pcie_common.h
Only in tile.old/include/hv: drv_pcie_rctest_intf.h
Only in tile.old/include/hv: drv_rshim_intf.h
Only in tile.old/include/hv: drv_softuart_intf.h
Only in tile.old/include/hv: drv_srom_intf.h
Only in tile.old/include/hv: drv_watchdog_intf.h
Only in tile.old/include/hv: drv_xgbe_impl.h
Only in tile.old/include/hv: drv_xgbe_intf.h
Only in tile.old/include/hv: iorpc.h
Only in tile.old/include: netio
Only in tile.old: initramfs
diff -ru tile.old/kernel/Makefile tile/kernel/Makefile
--- tile.old/kernel/Makefile	2010-05-28 18:03:33.247396000 -0400
+++ tile/kernel/Makefile	2010-05-28 23:07:06.108168000 -0400
@@ -3,10 +3,9 @@
 #
 
 extra-y := vmlinux.lds head_$(BITS).o
-obj-y := irq.o time.o process.o reboot.o proc.o pci-dma.o init_task.o \
-	ptrace.o setup.o traps.o hv_drivers.o \
-	hardwall.o messaging.o single_step.o sys.o signal.o stack.o \
-	backtrace.o hugevmap.o memprof.o entry.o \
+obj-y := backtrace.o entry.o init_task.o irq.o messaging.o \
+	pci-dma.o proc.o process.o ptrace.o reboot.o \
+	setup.o signal.o single_step.o stack.o sys.o time.o traps.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
 
 obj-$(CONFIG_TILEGX)		+= futex_64.o
@@ -15,4 +14,3 @@
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
-obj-$(CONFIG_PCI)		+= pci.o
diff -ru tile.old/kernel/asm-offsets.c tile/kernel/asm-offsets.c
--- tile.old/kernel/asm-offsets.c	2010-05-28 18:03:33.261373000 -0400
+++ tile/kernel/asm-offsets.c	2010-05-28 23:07:04.914157000 -0400
@@ -22,18 +22,18 @@
 #include <hv/hypervisor.h>
 
 /* Check for compatible compiler early in the build. */
-
-
-
-
-
-
-
-
-
-
-
-
+#ifdef CONFIG_TILEGX
+# ifndef __tilegx__
+#  error Can only build TILE-Gx configurations with tilegx compiler
+# endif
+# ifndef __LP64__
+#  error Must not specify -m32 when building the TILE-Gx kernel
+# endif
+#else
+# ifdef __tilegx__
+#  error Can not build TILEPro/TILE64 configurations with tilegx compiler
+# endif
+#endif
 
 void foo(void)
 {
diff -ru tile.old/kernel/backtrace.c tile/kernel/backtrace.c
--- tile.old/kernel/backtrace.c	2010-05-28 18:03:33.273371000 -0400
+++ tile/kernel/backtrace.c	2010-05-28 23:07:06.001250000 -0400
@@ -12,34 +12,17 @@
  *   more details.
  */
 
-#ifndef __KERNEL__
-#include <stdlib.h>
-#include <stdbool.h>
-#include <string.h>
-#else
 #include <linux/kernel.h>
 #include <linux/string.h>
-#define abort() BUG()
-#endif
 
-#if defined(__KERNEL__)
 #include <asm/backtrace.h>
-#elif defined(__tile__)
-#include <sys/backtrace.h>
-#else
-#include "tools/backtrace/backtrace.h"
-#endif
 
 #include <arch/chip.h>
 
 #if TILE_CHIP < 10
 
 
-#ifdef __tile__
 #include <asm/opcode-tile.h>
-#else
-#include "tile-desc.h"
-#endif
 
 
 #define TREG_SP 54
@@ -56,7 +39,6 @@
 
 
 /* This implementation only makes sense for native tools. */
-#ifdef __tile__
 /** Default function to read memory. */
 static bool
 bt_read_memory(void *result, VirtualAddress addr, size_t size, void *extra)
@@ -70,7 +52,6 @@
 	memcpy(result, (const void *)addr, size);
 	return true;
 }
-#endif
 
 
 /** Locates an instruction inside the given bundle that
@@ -505,12 +486,7 @@
 	VirtualAddress fp, initial_frame_caller_pc;
 
 	if (read_memory_func == NULL) {
-#ifdef __tile__
 		read_memory_func = bt_read_memory;
-#else
-		/* Cross-tools MUST provide a way to read memory. */
-		abort();
-#endif
 	}
 
 	/* Find out where we are in the initial frame. */
@@ -532,7 +508,9 @@
 		break;
 
 	default:
-		abort();
+		/* Give up. */
+		fp = -1;
+		break;
 	}
 
 	/* The frame pointer should theoretically be aligned mod 8. If
@@ -567,7 +545,9 @@
 		break;
 
 	default:
-		abort();
+		/* Give up. */
+		fp = -1;
+		break;
 	}
 
 	state->pc = pc;
diff -ru tile.old/kernel/compat.c tile/kernel/compat.c
--- tile.old/kernel/compat.c	2010-05-28 18:03:33.296340000 -0400
+++ tile/kernel/compat.c	2010-05-28 23:07:04.914154000 -0400
@@ -12,6 +12,9 @@
  *   more details.
  */
 
+/* Adjust unistd.h to provide 32-bit numbers and functions. */
+#define __SYSCALL_COMPAT
+
 #include <linux/compat.h>
 #include <linux/msg.h>
 #include <linux/syscalls.h>
@@ -20,6 +23,8 @@
 #include <linux/fcntl.h>
 #include <linux/smp_lock.h>
 #include <linux/uaccess.h>
+#include <linux/signal.h>
+#include <asm/syscalls.h>
 
 /*
  * Syscalls that take 64-bit numbers traditionally take them in 32-bit
@@ -74,110 +79,6 @@
 }
 
 
-/*
- * The 32-bit runtime uses layouts for "struct stat" and "struct stat64"
- * that match the TILEPro/TILE64 runtime.  Unfortunately the "stat64"
- * layout on existing 32 bit architectures doesn't quite match the
- * "normal" 64-bit bit layout, so we have to convert for that too.
- * Worse, it has an unaligned "st_blocks", so we have to use __copy_to_user().
- */
-
-int cp_compat_stat(struct kstat *kbuf, struct compat_stat __user *ubuf)
-{
-	compat_ino_t ino;
-
-	if (!old_valid_dev(kbuf->dev) || !old_valid_dev(kbuf->rdev))
-		return -EOVERFLOW;
-	if (kbuf->size >= 0x7fffffff)
-		return -EOVERFLOW;
-	ino = kbuf->ino;
-	if (sizeof(ino) < sizeof(kbuf->ino) && ino != kbuf->ino)
-		return -EOVERFLOW;
-	if (!access_ok(VERIFY_WRITE, ubuf, sizeof(struct compat_stat)) ||
-	    __put_user(old_encode_dev(kbuf->dev), &ubuf->st_dev) ||
-	    __put_user(ino, &ubuf->st_ino) ||
-	    __put_user(kbuf->mode, &ubuf->st_mode) ||
-	    __put_user(kbuf->nlink, &ubuf->st_nlink) ||
-	    __put_user(kbuf->uid, &ubuf->st_uid) ||
-	    __put_user(kbuf->gid, &ubuf->st_gid) ||
-	    __put_user(old_encode_dev(kbuf->rdev), &ubuf->st_rdev) ||
-	    __put_user(kbuf->size, &ubuf->st_size) ||
-	    __put_user(kbuf->atime.tv_sec, &ubuf->st_atime) ||
-	    __put_user(kbuf->atime.tv_nsec, &ubuf->st_atime_nsec) ||
-	    __put_user(kbuf->mtime.tv_sec, &ubuf->st_mtime) ||
-	    __put_user(kbuf->mtime.tv_nsec, &ubuf->st_mtime_nsec) ||
-	    __put_user(kbuf->ctime.tv_sec, &ubuf->st_ctime) ||
-	    __put_user(kbuf->ctime.tv_nsec, &ubuf->st_ctime_nsec) ||
-	    __put_user(kbuf->blksize, &ubuf->st_blksize) ||
-	    __put_user(kbuf->blocks, &ubuf->st_blocks))
-		return -EFAULT;
-	return 0;
-}
-
-static int cp_stat64(struct compat_stat64 __user *ubuf, struct kstat *stat)
-{
-	if (!access_ok(VERIFY_WRITE, ubuf, sizeof(struct compat_stat64)) ||
-	    __put_user(huge_encode_dev(stat->dev), &ubuf->st_dev) ||
-	    __put_user(stat->ino, &ubuf->st_ino) ||
-	    __put_user(stat->mode, &ubuf->st_mode) ||
-	    __put_user(stat->nlink, &ubuf->st_nlink) ||
-	    __put_user(stat->uid, &ubuf->st_uid) ||
-	    __put_user(stat->gid, &ubuf->st_gid) ||
-	    __put_user(huge_encode_dev(stat->rdev), &ubuf->st_rdev) ||
-	    __put_user(stat->size, &ubuf->st_size) ||
-	    __put_user(stat->blksize, &ubuf->st_blksize) ||
-	    __copy_to_user(&ubuf->st_blocks, &stat->blocks, sizeof(long)) ||
-	    __put_user(stat->atime.tv_sec, &ubuf->st_atime) ||
-	    __put_user(stat->atime.tv_nsec, &ubuf->st_atime_nsec) ||
-	    __put_user(stat->mtime.tv_sec, &ubuf->st_mtime) ||
-	    __put_user(stat->mtime.tv_nsec, &ubuf->st_mtime_nsec) ||
-	    __put_user(stat->ctime.tv_sec, &ubuf->st_ctime) ||
-	    __put_user(stat->ctime.tv_nsec, &ubuf->st_ctime_nsec))
-		return -EFAULT;
-	return 0;
-}
-
-long compat_sys_stat64(char __user *filename,
-		       struct compat_stat64 __user *statbuf)
-{
-	struct kstat stat;
-	int ret = vfs_stat(filename, &stat);
-
-	if (!ret)
-		ret = cp_stat64(statbuf, &stat);
-	return ret;
-}
-
-long compat_sys_lstat64(char __user *filename,
-			struct compat_stat64 __user *statbuf)
-{
-	struct kstat stat;
-	int ret = vfs_lstat(filename, &stat);
-	if (!ret)
-		ret = cp_stat64(statbuf, &stat);
-	return ret;
-}
-
-long compat_sys_fstat64(unsigned int fd, struct compat_stat64 __user *statbuf)
-{
-	struct kstat stat;
-	int ret = vfs_fstat(fd, &stat);
-	if (!ret)
-		ret = cp_stat64(statbuf, &stat);
-	return ret;
-}
-
-long compat_sys_fstatat64(int dfd, char __user *filename,
-			  struct compat_stat64 __user *statbuf, int flag)
-{
-	struct kstat stat;
-	int error;
-
-	error = vfs_fstatat(dfd, filename, &stat, flag);
-	if (error)
-		return error;
-	return cp_stat64(statbuf, &stat);
-}
 
 long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval)
@@ -252,3 +153,31 @@
  out:
 	return err;
 }
+
+/* Provide the compat syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (compat_##call),
+
+/* The generic versions of these don't work for Tile. */
+#define compat_sys_msgrcv tile_compat_sys_msgrcv
+#define compat_sys_msgsnd tile_compat_sys_msgsnd
+
+/* See comments in sys.c */
+#define compat_sys_fadvise64 sys32_fadvise64
+#define compat_sys_fadvise64_64 sys32_fadvise64_64
+#define compat_sys_readahead sys32_readahead
+#define compat_sys_sync_file_range compat_sys_sync_file_range2
+
+/* The native 64-bit "struct stat" matches the 32-bit "struct stat64". */
+#define compat_sys_stat64 sys_newstat
+#define compat_sys_lstat64 sys_newlstat
+#define compat_sys_fstat64 sys_newfstat
+#define compat_sys_fstatat64 sys_newfstatat
+
+/* Pass full 64-bit values through ptrace. */
+#define compat_sys_ptrace tile_compat_sys_ptrace
+
+void *compat_sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
diff -ru tile.old/kernel/compat_signal.c tile/kernel/compat_signal.c
--- tile.old/kernel/compat_signal.c	2010-05-28 18:03:33.328312000 -0400
+++ tile/kernel/compat_signal.c	2010-05-28 23:07:04.916159000 -0400
@@ -253,9 +253,9 @@
 	return err;
 }
 
-long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
-			    struct compat_sigaltstack __user *uoss_ptr,
-			    struct pt_regs *regs)
+long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			     struct compat_sigaltstack __user *uoss_ptr,
+			     struct pt_regs *regs)
 {
 	stack_t uss, uoss;
 	int ret;
@@ -287,7 +287,7 @@
 	return ret;
 }
 
-long compat_sys_rt_sigreturn(struct pt_regs *regs)
+long _compat_sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct compat_rt_sigframe __user *frame =
 		(struct compat_rt_sigframe __user *) compat_ptr(regs->sp);
@@ -308,7 +308,7 @@
 	if (restore_sigcontext(regs, &frame->uc.uc_mcontext, &r0))
 		goto badframe;
 
-	if (compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
+	if (_compat_sys_sigaltstack(&frame->uc.uc_stack, NULL, regs) != 0)
 		goto badframe;
 
 	return r0;
diff -ru tile.old/kernel/entry.S tile/kernel/entry.S
--- tile.old/kernel/entry.S	2010-05-28 18:03:33.383252000 -0400
+++ tile/kernel/entry.S	2010-05-28 23:07:04.915164000 -0400
@@ -17,19 +17,12 @@
 #include <asm/unistd.h>
 #include <asm/irqflags.h>
 
-
-
-
-
-/*
- * Don't use a local label in a #define because of compiler limitations.
- * Otherwise we end up with multiple copies of functions like skb_put().
- */
-
-
+#ifdef __tilegx__
+#define bnzt bnezt
+#endif
 
 STD_ENTRY(current_text_addr)
-	{ move r0,lr; jrp lr }
+	{ move r0, lr; jrp lr }
 	STD_ENDPROC(current_text_addr)
 
 STD_ENTRY(_sim_syscall)
@@ -60,7 +53,7 @@
  * careful not to write to the stack here.
  */
 STD_ENTRY(kernel_execve)
-	movei TREG_SYSCALL_NR_NAME,__NR_execve
+	moveli TREG_SYSCALL_NR_NAME, __NR_execve
 	swint1
 	jrp lr
 	STD_ENDPROC(kernel_execve)
@@ -146,34 +139,3 @@
 	nap
 	jrp lr
 	STD_ENDPROC(_cpu_idle)
-
-#ifdef CONFIG_FEEDBACK_COLLECT
-	/* Provide the header of the .feedback section. */
-	.section .feedback.start, "aw"
-	.align 8
-	.global __feedback_section_start
-__feedback_section_start:
-	.word 0x4fd5adb1	/* FEEDBACK_HEADER_MAGIC */
-	.word 1			/* FEEDBACK_HEADER_VERSION */
-
-	.word 0
-	.word __feedback_section_end - __feedback_section_start
-	.word __feedback_functions_start - __feedback_section_start
-	.word __feedback_functions_end - __feedback_section_start
-
-	.global __feedback_edges_count
-__feedback_edges_count:
-	.word 0			/* ConflictMissGraph starts out empty. */
-	.word __feedback_section_end - __feedback_section_start
-
-	/* No support for the linker hooks generated by the compiler. */
-	.section .text.__feedback_function_entered,"ax"
-	.weak __feedback_function_entered
-__feedback_function_entered:
-	jrp lr
-	ENDPROC(__feedback_function_entered)
-	.weak __feedback_function_resumed
-	.weak __feedback_function_entered_asm
-__feedback_function_resumed = __feedback_function_entered
-__feedback_function_entered_asm = __feedback_function_entered
-#endif
Only in tile.old/kernel: hardwall.c
diff -ru tile.old/kernel/head_32.S tile/kernel/head_32.S
--- tile.old/kernel/head_32.S	2010-05-28 18:03:33.399235000 -0400
+++ tile/kernel/head_32.S	2010-05-28 23:07:04.943136000 -0400
@@ -15,6 +15,7 @@
  */
 
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/thread_info.h>
@@ -28,7 +29,7 @@
  * minimal setup needed to call the generic C routines.
  */
 
-	.section .text.head, "ax"
+	__HEAD
 ENTRY(_start)
 	/* Notify the hypervisor of what version of the API we want */
 	{
@@ -165,13 +166,13 @@
 	.org swapper_pg_dir + HV_L1_SIZE
 	END(swapper_pg_dir)
 
-.section ".init.data","wa"
 	/*
 	 * Isolate swapper_pgprot to its own cache line, since each cpu
 	 * starting up will read it using VA-is-PA and local homing.
 	 * This would otherwise likely conflict with other data on the cache
 	 * line, once we have set its permanent home in the page tables.
 	 */
+	__INITDATA
 	.align CHIP_L2_LINE_SIZE()
 ENTRY(swapper_pgprot)
 	PTE	0, 0, HV_PTE_READABLE | HV_PTE_WRITABLE, 1
Only in tile.old/kernel: hugevmap.c
Only in tile.old/kernel: hv_drivers.c
Only in tile.old/kernel: hvglue.ld
Only in tile/kernel: hvglue.lds
diff -ru tile.old/kernel/intvec_32.S tile/kernel/intvec_32.S
--- tile.old/kernel/intvec_32.S	2010-05-28 18:03:33.414220000 -0400
+++ tile/kernel/intvec_32.S	2010-05-28 23:07:04.921151000 -0400
@@ -16,6 +16,7 @@
 
 #include <linux/linkage.h>
 #include <linux/errno.h>
+#include <linux/init.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
 #include <asm/unistd.h>
@@ -364,35 +365,6 @@
 
 	.endm
 
-#ifdef CONFIG_DATAPLANE
-	/*
-	 * Branch to the specified label if this is not a dataplane tile,
-	 * clobbering r20, r21 and r22.
-	 */
-	.macro  branch_if_not_dataplane, label
-	{
-	 mfspr  r22, SYSTEM_SAVE_1_0
-	 moveli r21, lo16(dataplane_map)
-	}
-	{
-	 auli   r21, r21, ha16(dataplane_map)
-	 mm     r22, r22, zero, 0, LOG2_THREAD_SIZE-1
-	}
-	{
-	 shri   r20, r22, 5
-	}
-	{
-	 s2a    r20, r20, r21
-	 movei  r21, 1
-	}
-	{
-	 lw     r20, r20
-	 shl    r21, r21, r22
-	}
-	and     r20, r20, r21
-	bzt     r20, \label
-	.endm
-#endif
 
 	/*
 	 * Save the rest of the registers that we didn't save in the actual
@@ -640,32 +612,6 @@
 	.endif
 #endif
 
-#ifdef CONFIG_DATAPLANE
-	/* If we're not a dataplane tile, skip the call. */
-	branch_if_not_dataplane 0f    /* clobbers r20, r21, r22 */
-
-	/* If we're not coming from user-space, don't worry about this. */
-	PTREGS_PTR(r20, PTREGS_OFFSET_EX1)
-	lw      r20, r20
-	andi    r20, r20, SPR_EX_CONTEXT_1_1__PL_MASK
-	bnz     r20, 0f
-
-	/* Like TRACE_IRQFLAGS, save r0-r3 before calling C code. */
-	.ifnc \function,handle_syscall
-	{ move r30, r0; move r31, r1 }
-	{ move r32, r2; move r33, r3 }
-	.endif
-
-	/* Do dataplane tile TLB management for kernel entry. */
-	jal     homecache_tlb_defer_enter
-	FEEDBACK_REENTER(\function)
-
-	.ifnc \function,handle_syscall
-	{ move r0, r30; move r1, r31 }
-	{ move r2, r32; move r3, r33 }
-	.endif
-0:
-#endif /* CONFIG_SMP */
 	.endm
 
 	.macro  check_single_stepping, kind, not_single_stepping
@@ -905,26 +851,6 @@
 	/* Get base of stack in r32; note r30/31 are used as arguments here. */
 	GET_THREAD_INFO(r32)
 
-#ifdef CONFIG_HOMECACHE
-	/*
-	 * If we're returning to user-space, see if we need to re-homecache
-	 * pages due to migration.  Note that homecache_migrate() will
-	 * internally enable interrupts if current->mm != NULL.
-	 */
-	{
-	 addli  r0, r32, THREAD_INFO_HOMECACHE_CPU_OFFSET
-	 mfspr  r1, SYSTEM_SAVE_1_0
-	}
-	{
-	 lw     r0, r0
-	 mm     r1, r1, zero, 0, LOG2_THREAD_SIZE-1
-	}
-	seq     r0, r0, r1
-	bbst    r0, 1f
-	jal     homecache_migrate
-	FEEDBACK_REENTER(interrupt_return)
-1:
-#endif
 
 	/* Check to see if there is any work to do before returning to user. */
 	{
@@ -971,14 +897,6 @@
 	 lw     r32, r32
 	}
 	bnz    r0, 1f
-#ifdef CONFIG_DATAPLANE
-	branch_if_not_dataplane 2f
-	jal     homecache_tlb_defer_exit
-	FEEDBACK_REENTER(interrupt_return)
-	bnz     r30, 2f   /* don't handle nohz stuff in an NMI */
-	jal     single_process_check_nohz
-	FEEDBACK_REENTER(interrupt_return)
-#endif
 	j       2f
 #if PT_FLAGS_DISABLE_IRQ != 1
 # error Assuming PT_FLAGS_DISABLE_IRQ == 1 so we can use bbnst below
@@ -997,17 +915,6 @@
 	bzt     r30, .Lrestore_regs
 3:
 
-#ifdef CONFIG_OPROFILE
-	/* We are relying on INT_PERF_COUNT at 33, and AUX_PERF_COUNT at 48 */
-	{
-	 moveli r0, lo16(INT_MASK(INT_PERF_COUNT))
-	 bz     r31, .Lrestore_regs
-	}
-#if CHIP_HAS_AUX_PERF_COUNTERS()
-	auli    r0, r0, ha16(INT_MASK(INT_AUX_PERF_COUNT))
-#endif
-	mtspr   INTERRUPT_MASK_RESET_1_1, r0
-#endif
 
 	/*
 	 * We now commit to returning from this interrupt, since we will be
@@ -1356,14 +1263,6 @@
 	 PTREGS_PTR(r0, PTREGS_OFFSET_BASE)
 	}
 	FEEDBACK_REENTER(handle_nmi)
-#ifdef CONFIG_OPROFILE
-	jal     op_enabled
-	FEEDBACK_REENTER(handle_nmi)
-	{
-	 movei  r30, 1
-	 move   r31, r0
-	}
-#endif
 	j       interrupt_return
 	STD_ENDPROC(handle_nmi)
 
@@ -1420,7 +1319,7 @@
 	pop_reg TREG_SYSCALL_NR_NAME, r11
 
 	/* Ensure that the syscall number is within the legal range. */
-	moveli  r21, NR_syscalls
+	moveli  r21, __NR_syscalls
 	{
 	 slt_u  r21, TREG_SYSCALL_NR_NAME, r21
 	 moveli r20, lo16(sys_call_table)
@@ -1622,12 +1521,12 @@
 
 /* Put address of pt_regs in reg and jump. */
 #define PTREGS_SYSCALL(x, reg)                          \
-	STD_ENTRY_LOCAL(ptregs_##x);                    \
+	STD_ENTRY(x);                                   \
 	{                                               \
 	 PTREGS_PTR(reg, PTREGS_OFFSET_BASE);           \
-	 j      x                                       \
+	 j      _##x                                    \
 	};                                              \
-	STD_ENDPROC(ptregs_##x)
+	STD_ENDPROC(x)
 
 PTREGS_SYSCALL(sys_execve, r3)
 PTREGS_SYSCALL(sys_sigaltstack, r2)
@@ -1635,15 +1534,14 @@
 
 /* Save additional callee-saves to pt_regs, put address in reg and jump. */
 #define PTREGS_SYSCALL_ALL_REGS(x, reg)                 \
-	STD_ENTRY_LOCAL(ptregs_##x);                    \
+	STD_ENTRY(x);                                   \
 	push_extra_callee_saves reg;                    \
-	j       x;                                      \
-	STD_ENDPROC(ptregs_##x)
+	j       _##x;                                   \
+	STD_ENDPROC(x)
 
 PTREGS_SYSCALL_ALL_REGS(sys_fork, r0)
 PTREGS_SYSCALL_ALL_REGS(sys_vfork, r0)
 PTREGS_SYSCALL_ALL_REGS(sys_clone, r4)
-PTREGS_SYSCALL_ALL_REGS(sys_raise_fpe, r2)
 PTREGS_SYSCALL_ALL_REGS(sys_cmpxchg_badaddr, r1)
 
 /*
@@ -1670,12 +1568,12 @@
  * we don't allow cmpxchg on the fc000000 memory region, since we only
  * validate that the user address is below PAGE_OFFSET.
  *
- * We place it in the .text.head section to ensure it is relatively
+ * We place it in the __HEAD section to ensure it is relatively
  * near to the intvec_SWINT_1 code (reachable by a conditional branch).
  *
  * Must match register usage in do_page_fault().
  */
-	.section .text.head,"ax"
+	__HEAD
 	.align 64
 	/* Align much later jump on the start of a cache line. */
 #if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
@@ -2040,10 +1938,10 @@
 /* Include .intrpt1 array of interrupt vectors */
 	.section ".intrpt1", "ax"
 
-#ifndef CONFIG_OPROFILE
 #define op_handle_perf_interrupt bad_intr
 #define op_handle_aux_perf_interrupt bad_intr
-#endif
+
+#define do_hardwall_trap bad_intr
 
 	int_hand     INT_ITLB_MISS, ITLB_MISS, \
 		     do_page_fault, handle_interrupt_no_single_step
@@ -2106,6 +2004,3 @@
 
 	/* Synthetic interrupt delivered only by the simulator */
 	int_hand     INT_BREAKPOINT, BREAKPOINT, do_breakpoint
-
-/* Include .data array of syscalls */
-#include "syscall_table.S"
diff -ru tile.old/kernel/irq.c tile/kernel/irq.c
--- tile.old/kernel/irq.c	2010-05-28 18:03:33.416231000 -0400
+++ tile/kernel/irq.c	2010-05-28 23:07:04.949121000 -0400
@@ -31,65 +31,20 @@
   INITIAL_INTERRUPTS_ENABLED;
 EXPORT_PER_CPU_SYMBOL(interrupts_enabled_mask);
 
-static void chip_unmask_level(unsigned int irq);
-
 /* Define per-tile device interrupt state */
 DEFINE_PER_CPU(HV_IntrState, dev_intr_state);
 
 DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
-atomic_t irq_err_count;
-
-struct tile_irq_desc {
-	void (*handler)(void *);
-	void *dev_id;
-};
-
-struct tile_irq_desc tile_irq_desc[NR_IRQS] __cacheline_aligned;
-
-/**
- * tile_request_irq() - Allocate an interrupt handling instance.
- * @handler: the device driver interrupt handler to be called.
- * @dev_id: a cookie passed back to the handler function.
- * @index: index into the interrupt handler table to set. It's
- *              derived from the interrupt bit mask allocated by the HV.
- *
- * Each device should call this function to register its interrupt
- * handler. dev_id must be globally unique. Normally the address of the
- * device data structure is used as the cookie.
- */
-void tile_request_irq(void (*handler)(void *), void *dev_id, int index)
-{
-	struct tile_irq_desc *irq_desc;
 
-	BUG_ON(!handler);
-	BUG_ON(index < 0 || index >= NR_IRQS);
-
-	irq_desc = tile_irq_desc + index;
-	irq_desc->handler = handler;
-	irq_desc->dev_id = dev_id;
-}
-EXPORT_SYMBOL(tile_request_irq);
-
-void tile_free_irq(int index)
-{
-	struct tile_irq_desc *irq_desc;
-
-	BUG_ON(index < 0 || index >= NR_IRQS);
-
-	irq_desc = tile_irq_desc + index;
-	irq_desc->handler = NULL;
-	irq_desc->dev_id = NULL;
-}
-EXPORT_SYMBOL(tile_free_irq);
 
 /*
  * Interrupt dispatcher, invoked upon a hypervisor device interrupt downcall
  */
 void tile_dev_intr(struct pt_regs *regs, int intnum)
 {
-	int count;
+	int irq;
 
 	/*
 	 * Get the device interrupt pending mask from where the hypervisor
@@ -115,18 +70,12 @@
 	}
 #endif
 
-	for (count = 0; pending_dev_intr_mask; ++count) {
+	for (irq = 0; pending_dev_intr_mask; ++irq) {
 		if (pending_dev_intr_mask & 0x1) {
-			struct tile_irq_desc *desc = &tile_irq_desc[count];
-			if (desc->handler == NULL) {
-				printk(KERN_ERR "Ignoring hv dev interrupt %d;"
-				       " handler not registered!\n", count);
-			} else {
-				desc->handler(desc->dev_id);
-			}
+			generic_handle_irq(irq);
 
 			/* Count device irqs; IPIs are counted elsewhere. */
-			if (count > HV_MAX_IPI_INTERRUPT)
+			if (irq > HV_MAX_IPI_INTERRUPT)
 				__get_cpu_var(irq_stat).irq_dev_intr_count++;
 		}
 		pending_dev_intr_mask >>= 1;
@@ -141,8 +90,61 @@
 }
 
 
+/* Mask an interrupt. */
+static void hv_dev_irq_mask(unsigned int irq)
+{
+	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
+	hv_disable_intr(p_intr_state, 1 << irq);
+}
+
+/* Unmask an interrupt. */
+static void hv_dev_irq_unmask(unsigned int irq)
+{
+	/* Re-enable the hypervisor to generate interrupts. */
+	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
+	hv_enable_intr(p_intr_state, 1 << irq);
+}
+
+/*
+ * The HV doesn't latch incoming interrupts while an interrupt is
+ * disabled, so we need to reenable interrupts before running the
+ * handler.
+ *
+ * ISSUE: Enabling the interrupt this early avoids any race conditions
+ * but introduces the possibility of nested interrupt stack overflow.
+ * An imminent change to the HV IRQ model will fix this.
+ */
+static void hv_dev_irq_ack(unsigned int irq)
+{
+	hv_dev_irq_unmask(irq);
+}
+
+/*
+ * Since ack() reenables interrupts, there's nothing to do at eoi().
+ */
+static void hv_dev_irq_eoi(unsigned int irq)
+{
+}
+
+static struct irq_chip hv_dev_irq_chip = {
+	.typename = "hv_dev_irq_chip",
+	.ack = hv_dev_irq_ack,
+	.mask = hv_dev_irq_mask,
+	.unmask = hv_dev_irq_unmask,
+	.eoi = hv_dev_irq_eoi,
+};
+
+static struct irqaction resched_action = {
+	.handler = handle_reschedule_ipi,
+	.name = "resched",
+	.dev_id = handle_reschedule_ipi /* unique token */,
+};
+
 void __init init_IRQ(void)
 {
+	/* Bind IPI irqs. Does this belong somewhere else in init? */
+	tile_irq_activate(IRQ_RESCHEDULE);
+	BUG_ON(setup_irq(IRQ_RESCHEDULE, &resched_action));
 }
 
 void __cpuinit init_per_tile_IRQs(void)
@@ -155,40 +157,26 @@
 	if (rc != HV_OK)
 		panic("hv_dev_register_intr_state: error %d", rc);
 
-#ifdef CONFIG_SMP
-	/* Bind the various IPI handlers. */
-	tile_request_irq(handle_reschedule_ipi, NULL, IRQ_RESCHEDULE);
-#endif
 }
 
-void tile_enable_irq(int irq)
+void tile_irq_activate(unsigned int irq)
 {
-	/* Re-enable the hypervisor to generate interrupts. */
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_enable_intr(p_intr_state, 1 << irq);
+	/*
+	 * Paravirtualized drivers can call up to the HV to find out
+	 * which irq they're associated with.  The HV interface
+	 * doesn't provide a generic call for discovering all valid
+	 * IRQs, so drivers must call this method to initialize newly
+	 * discovered IRQs.
+	 *
+	 * We could also just initialize all 32 IRQs at startup, but
+	 * doing so would lead to a kernel fault if an unexpected
+	 * interrupt fires and jumps to a NULL action.  By defering
+	 * the set_irq_chip_and_handler() call, unexpected IRQs are
+	 * handled properly by handle_bad_irq().
+	 */
+	hv_dev_irq_mask(irq);
+	set_irq_chip_and_handler(irq, &hv_dev_irq_chip, handle_percpu_irq);
 }
-EXPORT_SYMBOL(tile_enable_irq);
-
-
-/*
-From struct irq_chip (same as hv_interrupt_type):
-	const char	name;
-	unsigned int	startup - has default, calls enable
-	void		shutdown - has default, calls disable
-	void		enable - has default, calls unmask
-	void		disable - has default, calls mask
-	void		ack - required
-	void		mask - required
-	void		mask_ack - optional - calls mask,ack
-	void		unmask - required - optional for some?
-	void		eoi - required for for fasteoi, percpu
-	void		end - not used
-	void		set_affinity
-	int		retrigger - optional
-	int		set_type - optional
-	int		set_wake - optional
-	void		release - optional
-*/
 
 void ack_bad_irq(unsigned int irq)
 {
@@ -237,123 +225,3 @@
 	}
 	return 0;
 }
-
-/*
- * Mask a level sensitive interrupt.
- */
-static void chip_mask_ack_level(unsigned int irq)
-{
-	/*
-	 * Nothing to do here because the downcall from the Hypervisor
-	 * will automatically mask the interrupt.
-	 */
-}
-
-/*
- * Disable an interrupt.  Called, for example, at module unloading.
- */
-static void chip_disable_interrupt(unsigned int irq)
-{
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_disable_intr(p_intr_state, (1 << irq));
-}
-
-/*
- * Unmask a level sensitive interrupt.
- */
-static void chip_unmask_level(unsigned int irq)
-{
-	/* Re-enable the hypervisor to generate interrupts. */
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_enable_intr(p_intr_state, (1 << irq));
-}
-
-/*
- * Mask an edge-triggered interrupt.
- */
-static void chip_mask_edge(unsigned int irq)
-{
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_disable_intr(p_intr_state, 1 << irq);
-}
-
-/*
- * Unmask an edge-triggered interrupt.
- */
-static void chip_unmask_edge(unsigned int irq)
-{
-	/* Re-enable the hypervisor to generate interrupts. */
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_enable_intr(p_intr_state, 1 << irq);
-}
-
-
-static void chip_ack_edge(unsigned int irq)
-{
-	/* Re-enable the hypervisor to generate interrupts. */
-	HV_IntrState *p_intr_state = &__get_cpu_var(dev_intr_state);
-	hv_enable_intr(p_intr_state, 1 << irq);
-}
-
-/*
- * This is used with the handle_level_irq handler for legacy
- * interrupts.
- *
- * These functions can probably be reused with edge sensitive
- * interrupts.
- */
-static struct irq_chip chip_irq_legacy = {
-	.typename = "TILE-LEGACY",
-	.mask_ack = chip_mask_ack_level,
-	.disable = chip_disable_interrupt,
-	.eoi = NULL,
-	.unmask = chip_unmask_level,
-};
-
-static struct irq_chip chip_irq_edge = {
-	.typename = "TILE-EDGE",
-	.mask = chip_mask_edge,
-	.eoi = NULL,
-	.ack = chip_ack_edge,
-	.unmask = chip_unmask_edge,
-};
-
-/*
- * Handler for PCI IRQs.  This acts as a shim between the IRQ
- * framework at the top of this file and the conventional linux framework.
- * Invoked from tile_dev_intr() as a handler, with interrupts disabled.
- */
-static void tile_irq_shim(void *dev)
-{
-	int hv_irq = (int)(unsigned long)dev;
-
-
-
-	generic_handle_irq(hv_irq);
-}
-
-/*
- * Set an IRQ to the level handler.
- *
- * This registers the IRQ with both the IRQ handler at the top of this file
- * and the linux IRQ handler, since the interrupts get passed off to
- * the Linux framework in the above shim.
- *
- */
-void tile_irq_request_level(int hv_irq)
-{
-	tile_request_irq(tile_irq_shim, (void *)(long)hv_irq, hv_irq);
-
-	set_irq_chip_and_handler(hv_irq, &chip_irq_legacy,
-		handle_level_irq);
-}
-EXPORT_SYMBOL(tile_irq_request_level);
-
-void tile_irq_request_edge(int hv_irq)
-{
-	tile_request_irq(tile_irq_shim, (void *)(long)hv_irq, hv_irq);
-
-	set_irq_chip_and_handler(hv_irq, &chip_irq_edge,
-		handle_edge_irq);
-}
-EXPORT_SYMBOL(tile_irq_request_edge);
Only in tile.old/kernel: memprof.c
diff -ru tile.old/kernel/module.c tile/kernel/module.c
--- tile.old/kernel/module.c	2010-05-28 18:03:33.480164000 -0400
+++ tile/kernel/module.c	2010-05-28 23:07:05.056022000 -0400
@@ -23,15 +23,15 @@
 #include <asm/opcode-tile.h>
 #include <asm/pgtable.h>
 
-
-
-
-
-
+#ifdef __tilegx__
+# define Elf_Rela Elf64_Rela
+# define ELF_R_SYM ELF64_R_SYM
+# define ELF_R_TYPE ELF64_R_TYPE
+#else
 # define Elf_Rela Elf32_Rela
 # define ELF_R_SYM ELF32_R_SYM
 # define ELF_R_TYPE ELF32_R_TYPE
-
+#endif
 
 #ifdef MODULE_DEBUG
 #define DEBUGP printk
@@ -111,36 +111,36 @@
 	return -ENOEXEC;
 }
 
+#ifdef __tilegx__
+/*
+ * Validate that the high 16 bits of "value" is just the sign-extension of
+ * the low 48 bits.
+ */
+static int validate_hw2_last(long value, struct module *me)
+{
+	if (((value << 16) >> 16) != value) {
+		printk("module %s: Out of range HW2_LAST value %#lx\n",
+		       me->name, value);
+		return 0;
+	}
+	return 1;
+}
 
+/*
+ * Validate that "value" isn't too big to hold in a JumpOff relocation.
+ */
+static int validate_jumpoff(long value)
+{
+	/* Determine size of jump offset. */
+	int shift = __builtin_clzl(get_JumpOff_X1(create_JumpOff_X1(-1)));
 
+	/* Check to see if it fits into the relocation slot. */
+	long f = get_JumpOff_X1(create_JumpOff_X1(value));
+	f = (f << shift) >> shift;
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+	return f == value;
+}
+#endif
 
 int apply_relocate_add(Elf_Shdr *sechdrs,
 		       const char *strtab,
@@ -172,7 +172,7 @@
 
 #define MUNGE(func) (*location = ((*location & ~func(-1)) | func(value)))
 
-
+#ifndef __tilegx__
 		case R_TILE_32:
 			*(uint32_t *)location = value;
 			break;
@@ -193,45 +193,45 @@
 			value = (long) value >> 3;     /* count by instrs */
 			MUNGE(create_JOffLong_X1);
 			break;
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#else
+		case R_TILEGX_64:
+			*location = value;
+			break;
+		case R_TILEGX_IMM16_X0_HW2_LAST:
+			if (!validate_hw2_last(value, me))
+				return -ENOEXEC;
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X0_HW1:
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X0_HW0:
+			MUNGE(create_Imm16_X0);
+			break;
+		case R_TILEGX_IMM16_X1_HW2_LAST:
+			if (!validate_hw2_last(value, me))
+				return -ENOEXEC;
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X1_HW1:
+			value >>= 16;
+			/*FALLTHROUGH*/
+		case R_TILEGX_IMM16_X1_HW0:
+			MUNGE(create_Imm16_X1);
+			break;
+		case R_TILEGX_JUMPOFF_X1:
+			value -= (unsigned long) location;  /* pc-relative */
+			value = (long) value >> 3;     /* count by instrs */
+			if (!validate_jumpoff(value)) {
+				printk("module %s: Out of range jump to"
+				       " %#llx at %#llx (%p)\n", me->name,
+				       sym->st_value + rel[i].r_addend,
+				       rel[i].r_offset, location);
+				return -ENOEXEC;
+			}
+			MUNGE(create_JumpOff_X1);
+			break;
+#endif
 
 #undef MUNGE
 
diff -ru tile.old/kernel/pci-dma.c tile/kernel/pci-dma.c
--- tile.old/kernel/pci-dma.c	2010-05-28 18:03:33.492152000 -0400
+++ tile/kernel/pci-dma.c	2010-05-28 23:07:04.955126000 -0400
@@ -158,6 +158,26 @@
 }
 EXPORT_SYMBOL(dma_unmap_page);
 
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+			     size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(!valid_dma_direction(direction));
+}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
+				size_t size, enum dma_data_direction direction)
+{
+	unsigned long start = PFN_DOWN(dma_handle);
+	unsigned long end = PFN_DOWN(dma_handle + size - 1);
+	unsigned long i;
+
+	BUG_ON(!valid_dma_direction(direction));
+	for (i = start; i <= end; ++i)
+		homecache_flush_cache(pfn_to_page(i), 0);
+}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
 void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 		    enum dma_data_direction direction)
 {
@@ -177,10 +197,35 @@
 	BUG_ON(!valid_dma_direction(direction));
 	WARN_ON(nelems == 0 || sg[0].length == 0);
 
-	for (i = 0; i < nelems; i++) {
-		struct page *page =
-			pfn_to_page(sg[i].dma_address >> PAGE_SHIFT);
-		homecache_flush_cache(page, 0);
-	}
+	for (i = 0; i < nelems; i++)
+		dma_sync_single_for_device(dev, sg[i].dma_address,
+					   sg[i].dma_length, direction);
 }
 EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t dma_handle,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction direction)
+{
+	dma_sync_single_for_cpu(dev, dma_handle + offset, size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
+
+void dma_sync_single_range_for_device(struct device *dev,
+				      dma_addr_t dma_handle,
+				      unsigned long offset, size_t size,
+				      enum dma_data_direction direction)
+{
+	dma_sync_single_for_device(dev, dma_handle + offset, size, direction);
+}
+EXPORT_SYMBOL(dma_sync_single_range_for_device);
+
+/*
+ * dma_alloc_noncoherent() returns non-cacheable memory, so there's no
+ * need to do any flushing here.
+ */
+void dma_cache_sync(void *vaddr, size_t size,
+		    enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_cache_sync);
Only in tile.old/kernel: pci.c
diff -ru tile.old/kernel/proc.c tile/kernel/proc.c
--- tile.old/kernel/proc.c	2010-05-28 18:03:33.515128000 -0400
+++ tile/kernel/proc.c	2010-05-28 23:07:04.965107000 -0400
@@ -89,511 +89,3 @@
 	.stop	= c_stop,
 	.show	= show_cpuinfo,
 };
-
-
-/*
- * Support /proc/PID/pgtable
- */
-
-struct addr_marker {
-	unsigned long start_address;
-	const char *name;
-};
-
-/* Address space markers */
-static struct addr_marker address_markers[] = {
-	{ PAGE_OFFSET, "Low Kernel Mapping" },
-
-
-
-
-
-
-
-
-	{ 0, "vmalloc() Area" },
-# if CONFIG_NR_HUGE_VMAPS > 0
-	{ 0, "Huge vmap() Area" },
-# endif
-# ifdef CONFIG_HIGHMEM
-	{ 0, "Persistent kmap() Area" },
-# endif
-	{ 0, "Fixmap Area" },
-	{ MEM_SV_INTRPT, "Static Kernel Code" },
-
-	{ -1, NULL }		/* End of list */
-};
-
-
-/* Address markers are not compile-time constants on 32-bit platforms. */
-static int __init address_markers_init(void)
-{
-	struct addr_marker *marker = &address_markers[1];
-	(marker++)->start_address = _VMALLOC_START;
-#if CONFIG_NR_HUGE_VMAPS > 0
-	(marker++)->start_address = HUGE_VMAP_BASE;
-#endif
-#ifdef CONFIG_HIGHMEM
-	(marker++)->start_address = PKMAP_BASE;
-#endif
-	(marker++)->start_address = FIXADDR_START;
-
-	return 0;
-}
-arch_initcall(address_markers_init);
-
-
-int arch_proc_pgtable_show(struct seq_file *m, struct mm_struct *mm,
-			   unsigned long vaddr, pte_t *ptep, void **datap)
-{
-	pte_t pte = *ptep;
-	struct addr_marker *marker;
-
-	/*
-	 * We use %08 as the format here to match /proc/self/maps,
-	 * which does this regardless of the underlying size of "long".
-	 */
-	seq_printf(m, "%08lx %c%c%c", vaddr,
-		   hv_pte_get_readable(pte) ?
-		   (hv_pte_get_accessed(pte) ? 'R' : 'r') : '-',
-		   hv_pte_get_writable(pte) ?
-		   (hv_pte_get_dirty(pte) ? 'W' : 'w') : '-',
-		   hv_pte_get_executable(pte) ? 'X' : '-');
-	seq_printf(m, " PA=%010llx (N%d)",
-		   ((u64) hv_pte_get_pfn(pte)) << PAGE_SHIFT,
-		   pfn_to_nid(hv_pte_get_pfn(pte)));
-	if (!hv_pte_get_present(pte))
-		seq_printf(m, " NotPresent");
-	if (pte_huge(pte))
-		seq_printf(m, " Huge");
-	if (hv_pte_get_migrating(pte))
-		seq_printf(m, " Migrating");
-	if (hv_pte_get_cached_priority(pte))
-		seq_printf(m, " Priority");
-	if (hv_pte_get_global(pte))
-		seq_printf(m, " Global");
-	if (!hv_pte_get_user(pte))
-		seq_printf(m, " Kernel");
-
-	/*
-	 * If no caching modes are enabled, show "CacheNone",
-	 * otherwise show the details of what caching there is.
-	 */
-	if (hv_pte_get_mode(pte) == HV_PTE_MODE_UNCACHED) {
-		seq_printf(m, " CacheNone\n");
-		return 0;
-	}
-
-#if CHIP_HAS_NC_AND_NOALLOC_BITS()
-	if (hv_pte_get_no_alloc_l1(pte) && hv_pte_get_no_alloc_l2(pte))
-		seq_printf(m, " NoLocal");
-	else if (hv_pte_get_no_alloc_l1(pte))
-		seq_printf(m, " NoL1");
-	else if (hv_pte_get_no_alloc_l2(pte))
-		seq_printf(m, " NoL2");
-#endif
-
-	switch (hv_pte_get_mode(pte)) {
-	case HV_PTE_MODE_CACHE_NO_L3:
-		seq_printf(m, " NoHome");
-		break;
-
-	case HV_PTE_MODE_CACHE_TILE_L3:
-		seq_printf(m, " Home=%d", get_remote_cache_cpu(pte));
-		if (hv_pte_get_nc(pte))
-			seq_printf(m, " NC");
-		break;
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-	case HV_PTE_MODE_CACHE_HASH_L3:
-		seq_printf(m, " HashHome");
-		if (hv_pte_get_nc(pte))
-			seq_printf(m, " NC");
-		break;
-#endif
-
-	case 0:
-		/* Special case 0, since it often means a cleared PTE. */
-		break;
-
-	default:
-		seq_printf(m, " UnknownMode_%d", hv_pte_get_mode(pte));
-		break;
-	}
-
-	if (vaddr >= PAGE_OFFSET) {
-		marker = (struct addr_marker *)*datap;
-		if (marker == NULL)
-			marker = address_markers;
-		if (vaddr >= marker->start_address) {
-			while (vaddr >= marker[1].start_address)
-				++marker;
-			seq_printf(m, "  # %s", marker->name);
-			++marker;
-		}
-		*datap = marker;
-	}
-
-	seq_printf(m, "\n");
-	return 0;
-}
-
-/*
- * Support /proc/tile directory
- */
-
-struct proc_dir_entry *proc_tile_root;
-
-/* Define a /proc/tile init routine, common to both simple/seq macros. */
-#define PROC_INIT(name) \
-static void proc_tile_##name##_init(void) \
-{ \
-	struct proc_dir_entry *entry = \
-		create_proc_entry(#name, 0444, proc_tile_root); \
-	if (entry) \
-		entry->proc_fops = &proc_tile_##name##_fops; \
-}
-
-/* Define a simple /proc/tile file which just returns one string. */
-#define SIMPLE_PROC_ENTRY(name, format, args...) \
-static ssize_t proc_tile_##name##_read(struct file *file, char __user *buf, \
-				       size_t count, loff_t *ppos) \
-{ \
-	char tmpbuf[256]; \
-	ssize_t length = scnprintf(tmpbuf, sizeof(tmpbuf), format, ## args); \
-	return simple_read_from_buffer(buf, count, ppos, tmpbuf, length); \
-} \
-static const struct file_operations proc_tile_##name##_fops = { \
-	.read		= proc_tile_##name##_read, \
-}; \
-PROC_INIT(name)
-
-/*
- * Define a /proc/tile file which uses a seq_file to provide a more
- * complex set of data.
- */
-#define SEQ_PROC_ENTRY(name) \
-static int proc_tile_##name##_show(struct seq_file *m, void *v); \
-static int proc_tile_##name##_open(struct inode *inode, struct file *file) \
-{ \
-	return single_open(file, proc_tile_##name##_show, NULL); \
-} \
-static const struct file_operations proc_tile_##name##_fops = { \
-	.open		= proc_tile_##name##_open, \
-	.read		= seq_read, \
-	.llseek		= seq_lseek, \
-	.release	= single_release, \
-}; \
-PROC_INIT(name)
-
-/* Simple /proc/tile files. */
-SIMPLE_PROC_ENTRY(grid, "%u\t%u\n", smp_width, smp_height)
-
-/* More complex /proc/tile files. */
-static void proc_tile_seq_strconf(struct seq_file *sf, char* what,
-	uint32_t query)
-{
-	char tmpbuf[256];
-	char *bufptr = tmpbuf;
-	int buflen = sizeof(tmpbuf);
-	int len = hv_confstr(query, (HV_VirtAddr) bufptr, buflen);
-
-	if (len > buflen) {
-		bufptr = kmalloc(len, GFP_KERNEL);
-		if (!bufptr)
-			return;
-		buflen = len;
-		len = hv_confstr(query, (HV_VirtAddr) bufptr, buflen);
-	}
-
-	bufptr[buflen - 1] = 0;
-	/* Length includes the trailing null, so if it's 1, it's empty. */
-	if (len > 1) {
-		if (what)
-			seq_printf(sf, "%s: %s\n", what, bufptr);
-		else
-			seq_printf(sf, "%s", bufptr);
-	}
-
-	if (bufptr != tmpbuf)
-		kfree(bufptr);
-}
-
-SEQ_PROC_ENTRY(environment)
-static int proc_tile_environment_show(struct seq_file *sf, void *v)
-{
-	long cpu_temp = hv_sysconf(HV_SYSCONF_CPU_TEMP);
-	long board_temp = hv_sysconf(HV_SYSCONF_BOARD_TEMP);
-
-	if (cpu_temp < 0)
-		seq_printf(sf, "chip_temp: unknown\n");
-	else
-		seq_printf(sf, "chip_temp: %ld\n",
-			   cpu_temp - HV_SYSCONF_TEMP_KTOC);
-
-	if (board_temp < 0)
-		seq_printf(sf, "board_temp: unknown\n");
-	else
-		seq_printf(sf, "board_temp: %ld\n",
-			   board_temp - HV_SYSCONF_TEMP_KTOC);
-
-	return 0;
-}
-
-SEQ_PROC_ENTRY(hv)
-static int proc_tile_hv_show(struct seq_file *sf, void *v)
-{
-	proc_tile_seq_strconf(sf, "version", HV_CONFSTR_HV_SW_VER);
-	proc_tile_seq_strconf(sf, "config_version", HV_CONFSTR_HV_CONFIG_VER);
-	return 0;
-}
-
-SEQ_PROC_ENTRY(hvconfig)
-static int proc_tile_hvconfig_show(struct seq_file *sf, void *v)
-{
-	proc_tile_seq_strconf(sf, NULL, HV_CONFSTR_HV_CONFIG);
-	return 0;
-}
-
-SEQ_PROC_ENTRY(board)
-static int proc_tile_board_show(struct seq_file *sf, void *v)
-{
-	proc_tile_seq_strconf(sf, "board_part", HV_CONFSTR_BOARD_PART_NUM);
-	proc_tile_seq_strconf(sf, "board_serial", HV_CONFSTR_BOARD_SERIAL_NUM);
-	proc_tile_seq_strconf(sf, "chip_serial", HV_CONFSTR_CHIP_SERIAL_NUM);
-	proc_tile_seq_strconf(sf, "chip_revision", HV_CONFSTR_CHIP_REV);
-	proc_tile_seq_strconf(sf, "board_revision", HV_CONFSTR_BOARD_REV);
-	proc_tile_seq_strconf(sf, "board_description", HV_CONFSTR_BOARD_DESC);
-	proc_tile_seq_strconf(sf, "mezz_part", HV_CONFSTR_MEZZ_PART_NUM);
-	proc_tile_seq_strconf(sf, "mezz_serial", HV_CONFSTR_MEZZ_SERIAL_NUM);
-	proc_tile_seq_strconf(sf, "mezz_revision", HV_CONFSTR_MEZZ_REV);
-	proc_tile_seq_strconf(sf, "mezz_description", HV_CONFSTR_MEZZ_DESC);
-	return 0;
-}
-
-SEQ_PROC_ENTRY(switch)
-static int proc_tile_switch_show(struct seq_file *sf, void *v)
-{
-	proc_tile_seq_strconf(sf, "control", HV_CONFSTR_SWITCH_CONTROL);
-	return 0;
-}
-
-SEQ_PROC_ENTRY(memory)
-static int proc_tile_memory_show(struct seq_file *sf, void *v)
-{
-	int node;
-	int ctrl;
-	HV_Coord coord = { 0, 0 };
-	/*
-	 * We make two passes here; one through our memnodes to display
-	 * which controllers they correspond with, and one through all
-	 * controllers to get their speeds.  We may not actually have
-	 * access to all of the controllers whose speeds we retrieve, but
-	 * we get them because they're useful for mcstat, which provides
-	 * stats for physical controllers whether we're using them or not.
-	 */
-	for (node = 0; node < MAX_NUMNODES; node++) {
-		ctrl = node_controller[node];
-		if (ctrl >= 0)
-			seq_printf(sf, "controller_%d_node: %d\n", ctrl, node);
-	}
-	/*
-	 * Note that we use MAX_NUMNODES as the limit for the controller
-	 * loop because we don't have anything better.
-	 */
-	for (ctrl = 0; ctrl < MAX_NUMNODES; ctrl++) {
-		HV_MemoryControllerInfo info =
-			hv_inquire_memory_controller(coord, ctrl);
-		if (info.speed)
-			seq_printf(sf, "controller_%d_speed: %llu\n",
-				   ctrl, info.speed);
-	}
-	return 0;
-}
-
-#ifdef CONFIG_DATAPLANE
-SEQ_PROC_ENTRY(dataplane)
-static int proc_tile_dataplane_show(struct seq_file *sf, void *v)
-{
-	int cpu;
-	int space = 0;
-	for_each_cpu(cpu, &dataplane_map) {
-		if (space)
-			seq_printf(sf, " ");
-		else
-			space = 1;
-		seq_printf(sf, "%d", cpu);
-	}
-	if (space)
-		seq_printf(sf, "\n");
-	return 0;
-}
-#else
-#define proc_tile_dataplane_init() do {} while (0)
-#endif
-
-SEQ_PROC_ENTRY(interrupts)
-static int proc_tile_interrupts_show(struct seq_file *sf, void *v)
-{
-	int i;
-
-	seq_printf(sf, "%-8s%8s%8s%8s%8s%8s%8s%8s\n", "",
-		   "timer", "syscall", "resched", "hvflush", "SMPcall",
-		   "hvmsg", "devintr");
-
-	for_each_online_cpu(i) {
-		irq_cpustat_t *irq = &per_cpu(irq_stat, i);
-		seq_printf(sf, "%-8d%8d%8d%8d%8d%8d%8d%8d\n", i,
-			   irq->irq_timer_count,
-			   irq->irq_syscall_count,
-			   irq->irq_resched_count,
-			   irq->irq_hv_flush_count,
-			   irq->irq_call_count,
-			   irq->irq_hv_msg_count,
-			   irq->irq_dev_intr_count);
-	}
-	return 0;
-}
-
-#ifdef CONFIG_FEEDBACK_COLLECT
-
-extern void *__feedback_edges_ptr;
-extern long __feedback_edges_size;
-extern void flush_my_deferred_graph(void *dummy);
-
-ssize_t feedback_read(struct file *file, char __user *buf, size_t size,
-		      loff_t *ppos)
-{
-	void *start = __feedback_section_start;
-	size_t avail = __feedback_section_end - __feedback_section_start;
-
-	if (*ppos == 0)
-		on_each_cpu_mask(flush_my_deferred_graph, NULL,
-				 1, cpu_online_mask);
-	if (*ppos < avail) {
-		/* Return a short read as we cross into edges data. */
-		if (*ppos + size > avail)
-			size = avail - *ppos;
-	} else {
-		/* Bias the start to below the actual edges data. */
-		start = __feedback_edges_ptr - avail;
-		avail += __feedback_edges_size;
-	}
-
-	return simple_read_from_buffer(buf, size, ppos, start, avail);
-}
-static const struct file_operations proc_tile_feedback_fops = {
-	.read		= feedback_read
-};
-PROC_INIT(feedback)
-#endif
-
-static int __init proc_tile_init(void)
-{
-	proc_tile_root = proc_mkdir("tile", NULL);
-	if (!proc_tile_root)
-		return 0;
-
-	proc_tile_grid_init();
-	proc_tile_environment_init();
-	proc_tile_board_init();
-	proc_tile_switch_init();
-	proc_tile_hv_init();
-	proc_tile_hvconfig_init();
-	proc_tile_memory_init();
-	proc_tile_dataplane_init();
-	proc_tile_interrupts_init();
-#ifdef CONFIG_FEEDBACK_COLLECT
-	proc_tile_feedback_init();
-#endif
-
-	return 0;
-}
-
-arch_initcall(proc_tile_init);
-
-/*
- * Support /proc/sys/tile directory
- */
-
-
-static ctl_table unaligned_table[] = {
-	{
-		.procname	= "enabled",
-		.data		= &unaligned_fixup,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "printk",
-		.data		= &unaligned_printk,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "count",
-		.data		= &unaligned_fixup_count,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
-	},
-	{}
-};
-
-
-static ctl_table tile_root[] = {
-
-	{
-		.procname	= "unaligned_fixup",
-		.mode		= 0555,
-		unaligned_table
-	},
-
-	{
-		.procname	= "crashinfo",
-		.data		= &show_crashinfo,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec
-	},
-	{}
-};
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-static ctl_table hash_default_table[] = {
-	{
-		.procname	= "hash_default",
-		.data		= &hash_default,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{}
-};
-#endif
-
-static struct ctl_path tile_path[] = {
-	{ .procname = "tile" },
-	{ }
-};
-
-static int __init proc_sys_tile_init(void)
-{
-	(void) register_sysctl_paths(tile_path, tile_root);
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-	/*
-	 * Register this special file (which always has value "1")
-	 * only if we are actually in this mode, so we just need
-	 * to "stat" the file to perform the check.
-	 */
-	if (hash_default)
-		register_sysctl_paths(tile_path, hash_default_table);
-#endif
-
-	return 0;
-}
-
-arch_initcall(proc_sys_tile_init);
diff -ru tile.old/kernel/process.c tile/kernel/process.c
--- tile.old/kernel/process.c	2010-05-28 18:03:33.537105000 -0400
+++ tile/kernel/process.c	2010-05-28 23:07:04.971098000 -0400
@@ -26,7 +26,6 @@
 #include <linux/syscalls.h>
 #include <asm/system.h>
 #include <asm/stack.h>
-#include <asm/hardwall.h>
 #include <asm/homecache.h>
 #include <arch/chip.h>
 #include <arch/abi.h>
@@ -66,28 +65,6 @@
 	extern void _cpu_idle(void);
 	int cpu = smp_processor_id();
 
-#ifdef CONFIG_HOMECACHE
-	/*
-	 * If we enter cpu_idle with our stack still set to be the
-	 * initial stack, we switch to a new stack page now (and
-	 * free the initial stack back to the heap).
-	 * This allows the boot cpu's idle process to run with a
-	 * stack that has proper homecaching.
-	 */
-	if (current_thread_info() == &init_thread_union.thread_info) {
-		struct thread_info *ti = alloc_thread_info(current);
-		struct task_struct *p = current;
-		struct page *page = virt_to_page(current_thread_info());
-		*ti = *current_thread_info();
-		p->stack = ti;
-		p->thread.ksp = KSTK_TOP(p);
-		clear_bit(PG_homecache_nomigrate, &page->flags);
-		ClearPageReserved(page);
-		cpu_idle_on_new_stack(current_thread_info(), p->thread.ksp,
-				      next_current_ksp0(p));
-		/*NOTREACHED*/
-	}
-#endif
 
 	current_thread_info()->status |= TS_POLLING;
 
@@ -121,11 +98,7 @@
 				local_irq_enable();
 			current_thread_info()->status |= TS_POLLING;
 		}
-#ifdef CONFIG_DATAPLANE
-		tick_nohz_restart_sched_tick(0);
-#else
 		tick_nohz_restart_sched_tick();
-#endif
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
@@ -136,25 +109,12 @@
 {
 	struct page *page;
 	int flags = GFP_KERNEL;
-#ifdef CONFIG_HOMECACHE
-	int home;
-#endif
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	flags |= __GFP_ZERO;
 #endif
 
-#ifdef CONFIG_HOMECACHE
-#if CHIP_HAS_CBOX_HOME_MAP()
-	if (kstack_hash)
-		home = PAGE_HOME_HASH;
-	else
-#endif
-		home = PAGE_HOME_HERE;
-	page = homecache_alloc_pages(flags, THREAD_SIZE_ORDER, home);
-#else
 	page = alloc_pages(flags, THREAD_SIZE_ORDER);
-#endif
 	if (!page)
 		return 0;
 
@@ -169,16 +129,6 @@
 {
 	struct single_step_state *step_state = info->step_state;
 
-	/*
-	 * We free a thread_info from the context of the task that has
-	 * been scheduled next, so the original task is already dead.
-	 * Calling deactivate here just frees up the data structures.
-	 * If the task we're freeing held the last reference to a
-	 * hardwall fd, it would have been released prior to this point
-	 * anyway via exit_files(), and "hardwall" would be NULL by now.
-	 */
-	if (info->task->thread.hardwall)
-		hardwall_deactivate(info->task);
 
 	if (step_state) {
 
@@ -196,10 +146,6 @@
 		 * somehow, or we should associate the buffer(s) with the
 		 * mm itself so we can clean them up that way.
 		 */
-
-
-
-
 		kfree(step_state);
 	}
 
@@ -289,13 +235,7 @@
 	p->thread.proc_status = 0;
 #endif
 
-	/* New thread does not own any networks. */
-	p->thread.hardwall = NULL;
 
-#ifdef CONFIG_HOMECACHE
-	/* New thread gets memory without any homecache overrides. */
-	p->thread.homecache_desired_home = PAGE_HOME_UNKNOWN;
-#endif
 
 	/*
 	 * Start the new thread with the current architecture state
@@ -546,13 +486,6 @@
 	}
 #endif
 
-	/* Enable or disable access to the network registers appropriately. */
-	if (prev->thread.hardwall != NULL) {
-		if (next->thread.hardwall == NULL)
-			restrict_network_mpls();
-	} else if (next->thread.hardwall != NULL) {
-		grant_network_mpls();
-	}
 
 	/*
 	 * Switch kernel SP, PC, and callee-saved registers.
@@ -563,14 +496,14 @@
 	return __switch_to(prev, next, next_current_ksp0(next));
 }
 
-SYSCALL_DEFINE1(fork, struct pt_regs *, regs)
+int _sys_fork(struct pt_regs *regs)
 {
 	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
 
-SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
-		int __user *, parent_tidptr, int __user *, child_tidptr,
-		struct pt_regs *, regs)
+int _sys_clone(unsigned long clone_flags, unsigned long newsp,
+	       int __user *parent_tidptr, int __user *child_tidptr,
+	       struct pt_regs *regs)
 {
 	if (!newsp)
 		newsp = regs->sp;
@@ -578,7 +511,7 @@
 		       parent_tidptr, child_tidptr);
 }
 
-SYSCALL_DEFINE1(vfork, struct pt_regs *, regs)
+int _sys_vfork(struct pt_regs *regs)
 {
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp,
 		       regs, 0, NULL, NULL);
@@ -587,8 +520,8 @@
 /*
  * sys_execve() executes a new program.
  */
-SYSCALL_DEFINE4(execve, char __user *, path, char __user *__user *, argv,
-	       char __user *__user *, envp, struct pt_regs *, regs)
+int _sys_execve(char __user *path, char __user *__user *argv,
+		char __user *__user *envp, struct pt_regs *regs)
 {
 	int error;
 	char *filename;
@@ -604,8 +537,8 @@
 }
 
 #ifdef CONFIG_COMPAT
-int compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
-		      compat_uptr_t __user *envp, struct pt_regs *regs)
+int _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+		       compat_uptr_t __user *envp, struct pt_regs *regs)
 {
 	int error;
 	char *filename;
@@ -683,13 +616,13 @@
 	/* Nothing */
 }
 
-
-
-
-
+#ifdef __tilegx__
+# define LINECOUNT 3
+# define EXTRA_NL "\n"
+#else
 # define LINECOUNT 4
 # define EXTRA_NL ""
-
+#endif
 
 void show_regs(struct pt_regs *regs)
 {
Only in tile.old/kernel: sections.lds
diff -ru tile.old/kernel/setup.c tile/kernel/setup.c
--- tile.old/kernel/setup.c	2010-05-28 18:03:33.590046000 -0400
+++ tile/kernel/setup.c	2010-05-28 23:07:05.054017000 -0400
@@ -162,7 +162,7 @@
 early_param("pci_reserve", setup_pci_reserve);
 #endif
 
-
+#ifndef __tilegx__
 /*
  * vmalloc=size forces the vmalloc area to be exactly 'size' bytes.
  * This can be used to increase (or decrease) the vmalloc area.
@@ -182,7 +182,7 @@
 	return 0;
 }
 early_param("vmalloc", parse_vmalloc);
-
+#endif
 
 #ifdef CONFIG_HIGHMEM
 /*
@@ -287,7 +287,7 @@
 	}
 
 	hv_store_mapping((HV_VirtAddr)_stext,
-			 (uint32_t)(_etext - _stext), 0);
+			 (uint32_t)(_einittext - _stext), 0);
 }
 
 /*
@@ -302,10 +302,10 @@
 #ifdef CONFIG_HIGHMEM
 	long highmem_pages;
 #endif
-
+#ifndef __tilegx__
 	int cap;
-
-#if defined(CONFIG_HIGHMEM)
+#endif
+#if defined(CONFIG_HIGHMEM) || defined(__tilegx__)
 	long lowmem_pages;
 #endif
 
@@ -325,13 +325,13 @@
 			continue;
 		}
 #endif
-
+#ifndef __tilegx__
 		if ((unsigned long)range.start) {
 			printk("Range not at 4GB multiple: %#llx..%#llx\n",
 			       range.start, range.start + range.size);
 			continue;
 		}
-
+#endif
 		if ((range.start & (HPAGE_SIZE-1)) != 0 ||
 		    (range.size & (HPAGE_SIZE-1)) != 0) {
 			unsigned long long start_pa = range.start;
@@ -388,14 +388,14 @@
 		size = range.size >> PAGE_SHIFT;
 		end = start + size;
 
-
+#ifndef __tilegx__
 		if (((HV_PhysAddr)end << PAGE_SHIFT) !=
 		    (range.start + range.size)) {
 			printk("PAs too high to represent: %#llx..%#llx\n",
 			       range.start, range.start + range.size);
 			continue;
 		}
-
+#endif
 #ifdef CONFIG_PCI
 		/*
 		 * Blocks that overlap the pci reserved region must
@@ -433,7 +433,7 @@
 		node_set(i, node_possible_map);
 	}
 
-
+#ifndef __tilegx__
 	/*
 	 * For 4KB pages, mem_map "struct page" data is 1% of the size
 	 * of the physical memory, so can be quite big (640 MB for
@@ -462,7 +462,7 @@
 		       dropped_pages >> (20 - PAGE_SHIFT));
 		printk(KERN_WARNING "Consider using a larger page size.\n");
 	}
-
+#endif
 
 	/* Heap starts just above the last loaded address. */
 	min_low_pfn = PFN_UP((unsigned long)_end - PAGE_OFFSET);
@@ -486,7 +486,7 @@
 	/* Set max_low_pfn based on what node 0 can directly address. */
 	max_low_pfn = node_end_pfn[0];
 
-
+#ifndef __tilegx__
 	if (node_end_pfn[0] > MAXMEM_PFN) {
 		printk(KERN_WARNING "Only using %ldMB LOWMEM.\n",
 		       MAXMEM>>20);
@@ -504,17 +504,17 @@
 		node_end_pfn[i] = 0;
 	}
 	high_memory = __va(node_end_pfn[0]);
-
-
-
-
-
-
-
-
-
-
-
+#else
+	lowmem_pages = 0;
+	for (i = 0; i < MAX_NUMNODES; ++i) {
+		int pages = node_end_pfn[i] - node_start_pfn[i];
+		lowmem_pages += pages;
+		if (pages)
+			high_memory = pfn_to_kaddr(node_end_pfn[i]);
+	}
+	printk(KERN_NOTICE "%ldMB memory available.\n",
+	       pages_to_mb(lowmem_pages));
+#endif
 #endif
 }
 
@@ -556,13 +556,6 @@
 			crashk_res.end - crashk_res.start + 1, 0);
 #endif
 
-#ifdef CONFIG_HOMECACHE
-	/*
-	 * Ready for homecache page allocation; we don't set this statically
-	 * just to simplify header inclusion issues.
-	 */
-	current->thread.homecache_desired_home = PAGE_HOME_UNKNOWN;
-#endif
 }
 
 void *__init alloc_remap(int nid, unsigned long size)
@@ -884,15 +877,8 @@
 	 */
 	__insn_mtspr(SPR_MPL_WORLD_ACCESS_SET_0, 1);
 
-	/*
-	 * Static network is not restricted for now.
-	 * It should eventually be tied into hardwalling once
-	 * we want to implement the static network draining code.
-	 */
-
-
-
 #if CHIP_HAS_SN()
+	/* Static network is not restricted. */
 	__insn_mtspr(SPR_MPL_SN_ACCESS_SET_0, 1);
 #endif
 #if CHIP_HAS_SN_PROC()
@@ -1025,7 +1011,7 @@
 
 static void __init validate_va(void)
 {
-
+#ifndef __tilegx__   /* FIXME: GX: probably some validation relevant here */
 	/*
 	 * Similarly, make sure we're only using allowed VAs.
 	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_INTRPT,
@@ -1064,7 +1050,7 @@
 			"Reconfigure the kernel with fewer NR_HUGE_VMAPS\n"
 			"or smaller VMALLOC_RESERVE.\n",
 			VMALLOC_START);
-
+#endif
 }
 
 /*
@@ -1193,19 +1179,11 @@
 #endif
 }
 
-#ifdef CONFIG_DATAPLANE
-struct cpumask __write_once dataplane_map;
-EXPORT_SYMBOL(dataplane_map);
-#endif
 
 static int __init dataplane(char *str)
 {
-#ifdef CONFIG_DATAPLANE
-	return str ? cpulist_parse_crop(str, &dataplane_map) : -EINVAL;
-#else
 	printk("WARNING: dataplane support disabled in this kernel\n");
 	return 0;
-#endif
 }
 
 early_param("dataplane", dataplane);
@@ -1257,10 +1235,6 @@
 
 	setup_cpu_maps();
 
-#ifdef CONFIG_DATAPLANE
-	/* Make sure dataplane is only on valid cpus. */
-	cpumask_and(&dataplane_map, &dataplane_map, cpu_possible_mask);
-#endif
 
 #ifdef CONFIG_PCI
 	/*
@@ -1296,7 +1270,6 @@
 	zone_sizes_init();
 	set_page_homes();
 	setup_mpls();
-	reset_network_state();
 	setup_clock();
 	load_hv_initrd();
 }
@@ -1392,12 +1365,8 @@
 				virt_to_pte(NULL, (unsigned long)ptr + i);
 			pte_t pte = *ptep;
 			BUG_ON(pfn != pte_pfn(pte));
-#ifdef CONFIG_HOMECACHE
-			set_page_home(pg, cpu);
-#else
 			pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_TILE_L3);
 			pte = set_remote_cache_cpu(pte, cpu);
-#endif
 			set_pte(ptep, pte);
 
 			/* Update the lowmem mapping for consistency. */
diff -ru tile.old/kernel/signal.c tile/kernel/signal.c
--- tile.old/kernel/signal.c	2010-05-28 18:03:33.644003000 -0400
+++ tile/kernel/signal.c	2010-05-28 23:07:05.059009000 -0400
@@ -39,14 +39,12 @@
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
-/* Forward reference. */
-static void dump_mem(unsigned long address);
 
 /* Caller before callee in this file; other callee is in assembler */
 void do_signal(struct pt_regs *regs);
 
-SYSCALL_DEFINE3(sigaltstack, const stack_t __user *, uss,
-		stack_t __user *, uoss, struct pt_regs *, regs)
+int _sys_sigaltstack(const stack_t __user *uss,
+		     stack_t __user *uoss, struct pt_regs *regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
@@ -75,7 +73,7 @@
 	return err;
 }
 
-SYSCALL_DEFINE1(rt_sigreturn, struct pt_regs *, regs)
+int _sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame =
 		(struct rt_sigframe __user *)(regs->sp);
@@ -245,24 +243,6 @@
 {
 	int ret;
 
-	/*
-	 * If crashinfo is set to "2", we will report on kernel-generated
-	 * memory access signals here, even if they are being handled.
-	 */
-	if (show_crashinfo > 1 && info->si_code > 0) {
-		switch (info->si_signo) {
-		case SIGILL:
-		case SIGFPE:
-		case SIGSEGV:
-		case SIGBUS:
-			printk("\nHandling user fault: signal %d, code %#x,"
-			       " trap %d, address %#lx\n",
-			       info->si_signo, info->si_code, info->si_trapno,
-			       (unsigned long)(info->si_addr));
-			show_regs(regs);
-			dump_mem((unsigned long) (info->si_addr));
-		}
-	}
 
 	/* Are we from a system call? */
 	if (regs->faultnum == INT_SWINT_1) {
@@ -377,148 +357,3 @@
 		sigprocmask(SIG_SETMASK, &current->saved_sigmask, NULL);
 	}
 }
-
-SYSCALL_DEFINE3(raise_fpe, int, code, unsigned long, addr,
-		struct pt_regs *, regs)
-{
-	struct siginfo info;
-
-	/*
-	 * If we are coming here from kernel level, we must have tried
-	 * to do a divide-by-zero in kernel code.  For now, just panic.
-	 */
-	if (EX1_PL(regs->ex1) != USER_PL)
-		panic("Kernel divide by zero");
-
-	if (code & __SI_MASK)
-		return -EINVAL;   /* user space doesn't use the high bits */
-
-	/*
-	 * OR in the kernel value for __SI_FAULT so that the structure
-	 * gets copied to userspace correctly.
-	 */
-	code |= __SI_FAULT;
-
-	/* Only allow raising valid codes */
-	switch (code) {
-	case FPE_INTDIV:
-	case FPE_INTOVF:
-	case FPE_FLTDIV:
-	case FPE_FLTOVF:
-	case FPE_FLTUND:
-	case FPE_FLTRES:
-	case FPE_FLTINV:
-	case FPE_FLTSUB:
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	memset(&info, 0, sizeof(info));
-	info.si_signo = SIGFPE;
-	info.si_code = code;
-	info.si_addr = (void *)addr;
-	info.si_trapno = -1;   /* no corresponding hardware trap */
-
-	return group_send_sig_info(info.si_signo, &info, current);
-}
-
-
-
-
-int show_crashinfo;
-
-
-static int __init crashinfo(char *str)
-{
-	unsigned long val;
-	if (str == NULL) {
-		show_crashinfo = 1;
-		return 0;
-	}
-	if (strict_strtoul(str, 0, &val) != 0)
-		return 0;
-	show_crashinfo = val;
-	printk("User crash reports will%s be generated on the console\n",
-	       show_crashinfo ? "" : " not");
-	return 1;
-}
-__setup("crashinfo", crashinfo);
-
-static void dump_mem(unsigned long address)
-{
-	unsigned long addr;
-	enum { region_size = 256, bytes_per_line = 16 };
-	int i, j;
-	int found_readable_mem = 0;
-
-	if (!access_ok(VERIFY_READ, address, 1)) {
-		printk("\nNot dumping at address %#lx (kernel address)\n",
-		       address);
-		return;
-	}
-
-	addr = (address & -bytes_per_line) - region_size/2;
-	if (addr > address)
-		addr = 0;
-	for (i = 0; i < region_size;
-	     addr += bytes_per_line, i += bytes_per_line) {
-		unsigned char buf[bytes_per_line];
-		if (copy_from_user(buf, (void *)addr, bytes_per_line))
-			continue;
-		if (!found_readable_mem) {
-			printk("\nDumping memory around address %#lx:\n",
-			       address);
-			found_readable_mem = 1;
-		}
-		printk("%#08lx:", addr);
-		for (j = 0; j < bytes_per_line; ++j)
-			printk(" %02x", buf[j]);
-		printk("\n");
-	}
-	if (!found_readable_mem)
-		printk("\nNo readable memory around address %#lx\n", address);
-}
-
-void arch_coredump_signal(siginfo_t *info, struct pt_regs *regs)
-{
-	int show_mem = 0;
-
-	if (!show_crashinfo)
-		return;
-
-	/* Don't dump anything for what are essentially "requested" cores. */
-	switch (info->si_signo) {
-	case SIGABRT:
-	case SIGQUIT:
-	case SIGTRAP:
-		return;
-	}
-
-	/* Only show trapno and addr, and dump memory, for kernel signals. */
-	if (info->si_code > 0) {
-		switch (info->si_signo) {
-		case SIGILL:
-		case SIGFPE:
-		case SIGSEGV:
-		case SIGBUS:
-			show_mem = 1;
-			break;
-		}
-	}
-
-	if (show_mem) {
-		printk("\nUser crash: signal %d, code %#x,"
-		       " trap %d, address %#lx\n",
-		       info->si_signo, info->si_code, info->si_trapno,
-		       (unsigned long)(info->si_addr));
-		show_regs(regs);
-		dump_mem((unsigned long) (info->si_addr));
-	} else {
-		printk("\nUser crash: signal %d, code %#x\n",
-		       info->si_signo, info->si_code);
-		show_regs(regs);
-	}
-
-	printk("\n");
-}
diff -ru tile.old/kernel/single_step.c tile/kernel/single_step.c
--- tile.old/kernel/single_step.c	2010-05-28 18:03:33.654991000 -0400
+++ tile/kernel/single_step.c	2010-05-28 23:07:05.072003000 -0400
@@ -15,7 +15,7 @@
  * Derived from iLib's single-stepping code.
  */
 
-
+#ifndef __tilegx__   /* No support for single-step yet. */
 
 /* These functions are only used on the TILE platform */
 #include <linux/slab.h>
@@ -314,8 +314,7 @@
 		down_write(&current->mm->mmap_sem);
 		buffer = (void *) do_mmap(0, 0, 64,
 					  PROT_EXEC | PROT_READ | PROT_WRITE,
-					  MAP_PRIVATE | MAP_ANONYMOUS |
-					  MAP_CACHE_HOME_TASK,
+					  MAP_PRIVATE | MAP_ANONYMOUS,
 					  0);
 		up_write(&current->mm->mmap_sem);
 
@@ -653,3 +652,5 @@
 	if (regs->faultnum == INT_SWINT_1)
 		regs->pc += 8;
 }
+
+#endif /* !__tilegx__ */
diff -ru tile.old/kernel/smp.c tile/kernel/smp.c
--- tile.old/kernel/smp.c	2010-05-28 18:03:33.658000000 -0400
+++ tile/kernel/smp.c	2010-05-28 23:07:05.090011000 -0400
@@ -179,7 +179,7 @@
  * path but instead the faster tile_dev_intr() path for interrupts.
  */
 
-void handle_reschedule_ipi(void *token)
+irqreturn_t handle_reschedule_ipi(int irq, void *token)
 {
 	/*
 	 * Nothing to do here; when we return from interrupt, the
@@ -188,11 +188,7 @@
 	 */
 	__get_cpu_var(irq_stat).irq_resched_count++;
 
-	/*
-	 * Reenable the IPI before we return; any additional IPIs that
-	 * arrive before this point will be dropped.
-	 */
-	tile_enable_irq(IRQ_RESCHEDULE);
+	return IRQ_HANDLED;
 }
 
 void smp_send_reschedule(int cpu)
diff -ru tile.old/kernel/smpboot.c tile/kernel/smpboot.c
--- tile.old/kernel/smpboot.c	2010-05-28 18:03:33.667981000 -0400
+++ tile/kernel/smpboot.c	2010-05-28 23:07:05.096006000 -0400
@@ -78,13 +78,6 @@
 
 	/* Print information about disabled and dataplane cpus. */
 	print_disabled_cpus();
-#ifdef CONFIG_DATAPLANE
-	if (!cpumask_empty(&dataplane_map)) {
-		char buf[100];
-		cpulist_scnprintf(buf, sizeof(buf), &dataplane_map);
-		printk("Linux dataplane CPUs: %s\n", buf);
-	}
-#endif
 
 	/*
 	 * Tell the messaging subsystem how to respond to the
@@ -232,8 +225,6 @@
 	/* Set up MPLs for this processor */
 	setup_mpls();
 
-	/* Reset user network */
-	reset_network_state();
 
 	/* Set up tile-timer clock-event device on this cpu */
 	setup_tile_timer();
@@ -280,19 +271,7 @@
 	/* Reset the response to a (now illegal) MSG_START_CPU IPI. */
 	start_cpu_function_addr = (unsigned long) &panic_start_cpu;
 
-#ifdef CONFIG_DATAPLANE
-	/*
-	 * Compute the appropriate initial affinity, based on "dataplane".
-	 * We want to run generic Linux processes only on the
-	 * non-dataplane cpus.  If someone set dataplane_map too
-	 * aggressively, we'll allow any cpu on the whole chip.
-	 */
-	cpumask_andnot(&init_affinity, cpu_online_mask, &dataplane_map);
-	if (cpumask_empty(&init_affinity))
-		cpumask_copy(&init_affinity, cpu_online_mask);
-#else
 	cpumask_copy(&init_affinity, cpu_online_mask);
-#endif
 
 	/*
 	 * Pin ourselves to a single cpu in the initial affinity set
@@ -308,9 +287,6 @@
 	     (next = cpumask_next(cpu, &init_affinity)) < nr_cpu_ids;
 	     cpu = next)
 		;
-#ifdef CONFIG_DATAPLANE
-	singlethread_cpu = cpu;
-#endif
 	rc = sched_setaffinity(current->pid, cpumask_of(cpu));
 	if (rc != 0)
 		printk("Couldn't set init affinity to cpu %d (%d)\n", cpu, rc);
diff -ru tile.old/kernel/stack.c tile/kernel/stack.c
--- tile.old/kernel/stack.c	2010-05-28 18:03:33.670986000 -0400
+++ tile/kernel/stack.c	2010-05-28 23:07:05.106003000 -0400
@@ -28,7 +28,6 @@
 #include <asm/sigframe.h>
 #include <asm/stack.h>
 #include <arch/abi.h>
-#include <arch/sim.h>
 #include <arch/interrupts.h>
 
 
@@ -107,7 +106,7 @@
 /* Return a pt_regs pointer for a valid fault handler frame */
 static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 {
-
+#ifndef __tilegx__
 	const char *fault = NULL;  /* happy compiler */
 	char fault_buf[64];
 	VirtualAddress sp = kbt->it.sp;
@@ -145,7 +144,7 @@
 	}
 	if (!kbt->profile || (INT_MASK(p->faultnum) & QUEUED_INTERRUPTS) == 0)
 		return p;
-
+#endif
 	return NULL;
 }
 
@@ -351,10 +350,12 @@
 		       kbt->task->pid, kbt->task->tgid, kbt->task->comm,
 		       smp_processor_id(), get_cycles());
 	}
-
-
-
-
+#ifdef __tilegx__
+	if (kbt->is_current) {
+		__insn_mtspr(SPR_SIM_CONTROL,
+			     SIM_DUMP_SPR_ARG(SIM_DUMP_BACKTRACE));
+	}
+#endif
 	kbt->verbose = 1;
 	i = 0;
 	for (; !KBacktraceIterator_end(kbt); KBacktraceIterator_next(kbt)) {
diff -ru tile.old/kernel/sys.c tile/kernel/sys.c
--- tile.old/kernel/sys.c	2010-05-28 18:03:33.681954000 -0400
+++ tile/kernel/sys.c	2010-05-28 23:07:05.096009000 -0400
@@ -29,6 +29,8 @@
 #include <linux/fs.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/signal.h>
+#include <asm/syscalls.h>
 
 #include <asm/pgtable.h>
 #include <asm/homecache.h>
@@ -49,7 +51,7 @@
  * any other standard libcs we want to support.
  */
 
-
+#if !defined(__tilegx__) || defined(CONFIG_COMPAT)
 
 ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count)
 {
@@ -70,15 +72,15 @@
 				((loff_t)len_hi << 32) | len_lo, advice);
 }
 
-
+#endif /* 32-bit syscall wrappers */
 
 /*
  * This API uses a 4KB-page-count offset into the file descriptor.
  * It is likely not the right API to use on a 64-bit platform.
  */
 SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
-	       unsigned long, prot, unsigned long, flags,
-	       unsigned int, fd, unsigned long, off_4k)
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, off_4k)
 {
 #define PAGE_ADJUST (PAGE_SHIFT - 12)
 	if (off_4k & ((1 << PAGE_ADJUST) - 1))
@@ -92,8 +94,8 @@
  * It is likely not the right API to use on a 32-bit platform.
  */
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
-	      unsigned long, prot, unsigned long, flags,
-	      unsigned int, fd, unsigned long, offset)
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, offset)
 {
 	if (offset & ((1 << PAGE_SHIFT) - 1))
 		return -EINVAL;
@@ -101,278 +103,20 @@
 			      offset >> PAGE_SHIFT);
 }
 
-#ifdef CONFIG_HOMECACHE
 
-int arch_vm_area_flags(struct mm_struct *mm, unsigned long flags,
-		       unsigned long vm_flags,
-		       pid_t *pid_ptr, pgprot_t *prot_ptr)
-{
-	pgprot_t prot = __pgprot(0);
-	pid_t pid = 0;
-
-#if CHIP_HAS_NC_AND_NOALLOC_BITS()
-	if (flags & MAP_CACHE_NO_L1)
-		prot = hv_pte_set_no_alloc_l1(prot);
-	if (flags & MAP_CACHE_NO_L2)
-		prot = hv_pte_set_no_alloc_l2(prot);
+/* Provide the actual syscall number to call mapping. */
+#undef __SYSCALL
+#define __SYSCALL(nr, call) [nr] = (call),
+
+#ifndef __tilegx__
+/* See comments at the top of the file. */
+#define sys_fadvise64 sys32_fadvise64
+#define sys_fadvise64_64 sys32_fadvise64_64
+#define sys_readahead sys32_readahead
+#define sys_sync_file_range sys_sync_file_range2
 #endif
 
-	if (flags & _MAP_CACHE_HOME)
-		prot = pte_set_forcecache(prot);
-
-	if ((flags & _MAP_CACHE_MKHOME(_MAP_CACHE_HOME_MASK)) ==
-	    MAP_CACHE_HOME_NONE) {
-
-		/*
-		 * We special-case setting the home cache to "none".
-		 * If the user isn't indicating willingness to tolerate
-		 * incoherence, and is caching locally on the cpu, we
-		 * fail a writable mapping, or enforce a readonly mapping.
-		 */
-		if (!(flags & _MAP_CACHE_INCOHERENT) &&
-		    (flags & MAP_CACHE_NO_LOCAL) != MAP_CACHE_NO_LOCAL) {
-			if (vm_flags & VM_WRITE)
-				return -EINVAL;
-		}
-		if ((flags & MAP_CACHE_NO_LOCAL) == MAP_CACHE_NO_LOCAL)
-			prot = hv_pte_set_mode(prot, HV_PTE_MODE_UNCACHED);
-		else
-			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_NO_L3);
-
-	} else if (flags & _MAP_CACHE_HOME) {
-
-		/* Extract the cpu (or magic cookie). */
-		int cpu = (flags >> _MAP_CACHE_HOME_SHIFT) &
-			_MAP_CACHE_HOME_MASK;
-
-		switch (cpu) {
-
-		case _MAP_CACHE_HOME_SINGLE:
-			/*
-			 * This is the default case; we set "anyhome"
-			 * and the OS will pick the cpu for us in pfn_pte()
-			 * by examining the page_home() of the page.
-			 */
-			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_TILE_L3);
-			prot = pte_set_anyhome(prot);
-			break;
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-		case _MAP_CACHE_HOME_HASH:
-			/* Mark this page for home-map hash caching. */
-			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_HASH_L3);
-			break;
-#endif
-
-		case _MAP_CACHE_HOME_TASK:
-			pid = current->pid;
-			/*FALLTHROUGH*/
-
-		case _MAP_CACHE_HOME_HERE:
-			cpu = smp_processor_id();
-			/*FALLTHROUGH*/
-
-		default:
-			if (cpu < 0 || cpu >= nr_cpu_ids ||
-			    !cpu_is_valid_lotar(cpu))
-				return -EINVAL;
-			prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_TILE_L3);
-			prot = set_remote_cache_cpu(prot, cpu);
-		}
-	}
-
-	/*
-	 * If we get a request for priority, we have to start checking
-	 * this mm from now on when we switch to it.  We could do things
-	 * that are more efficient: for example, hack mmap and munmap
-	 * to reset a more definitive flag saying whether there is or
-	 * is not a priority mapping by rescanning; or even by tracking
-	 * the vm_area_structs themselves with a counter.  But this
-	 * technique seems most foolproof, and doesn't involve messing
-	 * with architecture-independent code at all.
-	 *
-	 * Note that if we implement VA<->PA coloring, we could then
-	 * also usefully implement tracking exactly which priority
-	 * pages are present, and use the hv_set_caching() argument to
-	 * only partially flip the cache out of red/black mode.
-	 * But this is an optimization for another day.
-	 */
-	if (flags & MAP_CACHE_PRIORITY) {
-		start_mm_caching(mm);
-		prot = hv_pte_set_cached_priority(prot);
-	}
-
-	*prot_ptr = prot;
-	*pid_ptr = pid;
-	return 0;
-}
-
-/*
- * If we are setting up a shared-writable mapping that forces homing
- * of part of a file, ensure that there are no other shared-writable
- * mappings that force the homing of an overlapping part of the
- * same file in an incompatible way.  This implies that the caching
- * mode matches, and if it is a "tile L3" mode, that the specified
- * remote cpus match (or one of them is an "anyhome" mapping).  Note
- * that we don't care about the NO_L1, etc., parts of the pgprot_t,
- * since those may differ without causing re-homecaching.
- */
-int arch_vm_area_validate(struct vm_area_struct *new_vma,
-			  struct address_space *mapping)
-{
-	size_t len = new_vma->vm_end - new_vma->vm_start;
-	pgprot_t prot = new_vma->vm_page_prot;
-	unsigned long end = new_vma->vm_pgoff + (len >> PAGE_SHIFT);
-	struct vm_area_struct *vma;
-	struct prio_tree_iter iter;
-
-	/* No existing writable mappings means we must be OK. */
-	if (mapping->i_mmap_writable == 0)
-		return 0;
-
-	/* If we're not trying to set up a shared mapping, we're OK. */
-	if (!(new_vma->vm_flags & VM_SHARED))
-		return 0;
-
-	/* If we're not forcing the caching, we're OK. */
-	if (!pte_get_forcecache(prot))
-		return 0;
-
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap,
-			      new_vma->vm_pgoff, end) {
-
-		/* If we are updating our own mapping, ignore it. */
-		if (vma == new_vma)
-			continue;
-
-		/*
-		 * The prio_tree is apparently conservative and will
-		 * report a mapping immediately following our proposed
-		 * new mapping as overlapping with ours, erroneously.
-		 * Watch for this and discard it.
-		 */
-		if (vma->vm_pgoff == end)
-			continue;
-
-		/* Ignore other private mappings or non-forcing mappings. */
-		if (!(vma->vm_flags & VM_SHARED) ||
-		    !pte_get_forcecache(vma->vm_page_prot))
-			continue;
-
-		if (hv_pte_get_mode(vma->vm_page_prot) !=
-		    hv_pte_get_mode(prot))
-			return -EINVAL;
-
-		if (hv_pte_get_mode(prot) == HV_PTE_MODE_CACHE_TILE_L3 &&
-		    !pte_get_anyhome(vma->vm_page_prot) &&
-		    !pte_get_anyhome(prot) &&
-		    hv_pte_get_lotar(vma->vm_page_prot) !=
-		    hv_pte_get_lotar(prot))
-			return -EINVAL;
-
-	}
-
-	return 0;
-}
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-
-#define CACHE_VAR MAP_CACHE_HASH_ENV_VAR "="
-
-void arch_exec_env(char __user *__user *envp)
-{
-	char buf[64];
-	char *val;
-	int i;
-	unsigned flags;
-
-	/* Clear flags so we have a clean slate. */
-	current_thread_info()->status &= ~TS_EXEC_HASH_FLAGS;
-
-	for (i = 0; ; ++i) {
-		char __user *str;
-		int len;
-
-		/* Copy in the next env string, with validity checking. */
-		if (get_user(str, &envp[i]) || str == NULL)
-			return;
-		len = strnlen_user(str, sizeof(buf));
-		if (len == 0 || _copy_from_user(buf, str, len))
-			return;
-
-		/* See if it is the one we're interested in. */
-		if (len < sizeof(buf) &&
-		    strncmp(buf, CACHE_VAR, sizeof(CACHE_VAR)-1) == 0)
-			break;
-	}
-
-	val = &buf[sizeof(CACHE_VAR)-1];
-
-	/* Set flags based on the environment variable string value. */
-	if (strcmp(val, "all") == 0)
-		flags = TS_EXEC_HASH_STACK | TS_EXEC_HASH_RW |
-			TS_EXEC_HASH_RO | TS_EXEC_HASH_SET;
-	else if (strcmp(val, "allbutstack") == 0 || strcmp(val, "static") == 0)
-		flags = TS_EXEC_HASH_RW | TS_EXEC_HASH_RO | TS_EXEC_HASH_SET;
-	else if (strcmp(val, "ro") == 0)
-		flags = TS_EXEC_HASH_RO | TS_EXEC_HASH_SET;
-	else if (strcmp(val, "none") == 0)
-		flags = TS_EXEC_HASH_SET;
-	else
-		return;  /* could issue a warning, but we don't */
-
-	/* Remember for later. */
-	current_thread_info()->status |= flags;
-}
-
-void arch_exec_vma(struct vm_area_struct *vma)
-{
-	unsigned long flags = current_thread_info()->status;
-	unsigned long vm_flags;
-	int use_hash, ro = 0;
-	pgprot_t prot;
-
-	if (!(flags & TS_EXEC_HASH_SET))
-		return;
-
-	vm_flags = vma->vm_flags;
-	if (vm_flags & VM_GROWSDOWN) {
-		use_hash = !!(flags & TS_EXEC_HASH_STACK);
-	} else if (vm_flags & VM_WRITE) {
-		use_hash = !!(flags & TS_EXEC_HASH_RW);
-	} else {
-		use_hash = !!(flags & TS_EXEC_HASH_RO);
-		ro = 1;
-	}
-	if (hash_default == use_hash)
-		return;
-
-	prot = vma->vm_page_prot;
-	if (use_hash) {
-		/* Use hash-for-home caching for this mapping. */
-		prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_HASH_L3);
-	} else {
-		/*
-		 * Cache this mapping all on one cpu.  For immutable
-		 * pages (r/o, or r/w pages before they are COW'ed) this
-		 * will always be homed on the local tile.
-		 */
-		prot = hv_pte_set_mode(prot, HV_PTE_MODE_CACHE_TILE_L3);
-		prot = pte_set_anyhome(prot);
-	}
-
-	prot = pte_set_forcecache(prot);
-	vma->vm_page_prot = prot;
-	vma->vm_flags |= VM_DONTMERGE;
-}
-
-void arch_exec_map(unsigned long addr)
-{
-	struct vm_area_struct *vma = find_vma(current->mm, addr);
-	BUG_ON(!vma || addr < vma->vm_start);
-	arch_exec_vma(vma);
-}
-
-#endif /* CHIP_HAS_CBOX_HOME_MAP() */
-
-#endif /* CONFIG_HOMECACHE */
+void *sys_call_table[__NR_syscalls] = {
+	[0 ... __NR_syscalls-1] = sys_ni_syscall,
+#include <asm/unistd.h>
+};
Only in tile.old/kernel: syscall_table.S
diff -ru tile.old/kernel/tile-desc_32.c tile/kernel/tile-desc_32.c
--- tile.old/kernel/tile-desc_32.c	2010-05-28 18:03:33.745888000 -0400
+++ tile/kernel/tile-desc_32.c	2010-05-28 22:57:16.340151000 -0400
@@ -13,12 +13,8 @@
 #define TREG_SN 56
 #define TREG_ZERO 63
 
-#if defined(__KERNEL__) || defined(_LIBC)
-// FIXME: Rename this.
+/* FIXME: Rename this. */
 #include <asm/opcode-tile.h>
-#else
-#include "tile-desc.h"
-#endif
 
 
 const struct tile_opcode tile_opcodes[394] =
@@ -13729,41 +13725,6 @@
 const int tile_num_sprs = 499;
 
 
-#if !defined(__KERNEL__) && !defined(_LIBC)
-
-#include <stdlib.h>
-
-static int
-tile_spr_compare (const void *a_ptr, const void *b_ptr)
-{
-  const struct tile_spr *a = (const struct tile_spr *) a_ptr;
-  const struct tile_spr *b = (const struct tile_spr *) b_ptr;
-  return (a->number - b->number);
-}
-
-const char *
-get_tile_spr_name (int num)
-{
-  void *result;
-  struct tile_spr key;
-
-  key.number = num;
-  result = bsearch((const void *) &key, (const void *) tile_sprs,
-                   tile_num_sprs, sizeof (struct tile_spr),
-                   tile_spr_compare);
-
-  if (result == NULL)
-  {
-    return (NULL);
-  }
-  else
-  {
-    struct tile_spr *result_ptr = (struct tile_spr *) result;
-    return (result_ptr->name);
-  }
-}
-
-#endif
 
 
 /* Canonical name of each register. */
diff -ru tile.old/kernel/time.c tile/kernel/time.c
--- tile.old/kernel/time.c	2010-05-28 18:03:33.760877000 -0400
+++ tile/kernel/time.c	2010-05-28 23:07:05.098017000 -0400
@@ -21,6 +21,7 @@
 #include <linux/hardirq.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
+#include <linux/delay.h>
 #include <asm/irq_regs.h>
 #include <hv/hypervisor.h>
 #include <arch/interrupts.h>
@@ -33,45 +34,36 @@
 
 /* How many cycles per second we are running at. */
 static cycles_t cycles_per_sec __write_once;
-static u32 cyc2ns_mult __write_once;
-#define cyc2ns_shift 30
-cycles_t get_clock_rate() { return cycles_per_sec; }
 
 /*
- * Called very early from setup_arch() to set cycles_per_sec.
- * Also called, if required, by sched_clock(), which can be even
- * earlier if built with CONFIG_LOCKDEP (during lockdep_init).
- * We initialize it early so we can use it to set up loops_per_jiffy.
+ * We set up shift and multiply values with a minsec of five seconds,
+ * since our timer counter counts down 31 bits at a frequency of
+ * no less than 500 MHz.  See @minsec for clocks_calc_mult_shift().
+ * We could use a different value for the 64-bit free-running
+ * cycle counter, but we use the same one for consistency, and since
+ * we will be reasonably precise with this value anyway.
  */
-void setup_clock(void)
-{
-	u64 mult;
+#define TILE_MINSEC 5
 
-	if (cyc2ns_mult)
-		return;
-	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
-
-	/*
-	 * Compute cyc2ns_mult, as used in sched_clock().
-	 * For efficiency of multiplication we want this to be a
-	 * 32-bit value, so we validate that here.  We want as large a
-	 * shift value as possible for precision, but too large a
-	 * shift would make cyc2ns_mult more than 32 bits.  We pick a
-	 * constant value that works well with our typical
-	 * frequencies, though we could in principle compute the most
-	 * precise value dynamically instead.  We can't make the shift
-	 * greater than 32 without fixing the algorithm.
-	 */
-	mult = (1000000000ULL << cyc2ns_shift) / cycles_per_sec;
-	cyc2ns_mult = (u32) mult;
-	BUILD_BUG_ON(cyc2ns_shift > 32);
-	BUG_ON(mult != cyc2ns_mult);
+cycles_t get_clock_rate()
+{
+	return cycles_per_sec;
 }
 
 #if CHIP_HAS_SPLIT_CYCLE()
 cycles_t get_cycles()
 {
-	return get_cycle_count();
+	unsigned int high = __insn_mfspr(SPR_CYCLE_HIGH);
+	unsigned int low = __insn_mfspr(SPR_CYCLE_LOW);
+	unsigned int high2 = __insn_mfspr(SPR_CYCLE_HIGH);
+
+	while (unlikely(high != high2)) {
+		low = __insn_mfspr(SPR_CYCLE_LOW);
+		high = high2;
+		high2 = __insn_mfspr(SPR_CYCLE_HIGH);
+	}
+
+	return (((cycles_t)high) << 32) | low;
 }
 #endif
 
@@ -80,7 +72,7 @@
 	return get_cycles();
 }
 
-static struct clocksource cycle_counter_clocksource = {
+static struct clocksource cycle_counter_cs = {
 	.name = "cycle counter",
 	.rating = 300,
 	.read = clocksource_get_cycles,
@@ -88,73 +80,33 @@
 	.flags = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
-/* Called fairly late in init/main.c, but before we go smp. */
-void __init time_init(void)
-{
-	struct clocksource *src = &cycle_counter_clocksource;
-
-	/* Pick an arbitrary time to start us up. */
-	xtime.tv_sec = mktime(1970, 1, 1, 0, 0, 0);
-	xtime.tv_nsec = 0;
-
-	/* Initialize and register the clock source. */
-	src->shift = 20;  /* arbitrary */
-	src->mult = (1000000000ULL << src->shift) / cycles_per_sec;
-	clocksource_register(src);
-
-	/* Start up the tile-timer interrupt source on the boot cpu. */
-	setup_tile_timer();
-}
-
-
 /*
- * Provide support for effectively turning the timer interrupt on and
- * off via the interrupt mask.  Make sure not to unmask it while we are
- * running the timer interrupt handler, to avoid recursive timer
- * interrupts; these may be OK in some cases, but it's generally cleaner
- * to reset the kernel stack before starting the next timer interrupt.
+ * Called very early from setup_arch() to set cycles_per_sec.
+ * We initialize it early so we can use it to set up loops_per_jiffy.
  */
-
-/* Track some status about the timer interrupt. */
-struct timer_status {
-	int enabled;   /* currently meant to be enabled? */
-	int in_intr;   /* currently in the interrupt handler? */
-};
-static DEFINE_PER_CPU(struct timer_status, timer_status);
-
-/* Enable the timer interrupt, unless we're in the handler. */
-static void enable_timer_intr(void)
+void __init setup_clock(void)
 {
-	struct timer_status *status = &__get_cpu_var(timer_status);
-	status->enabled = 1;
-	if (status->in_intr)
-		return;
-	raw_local_irq_unmask_now(INT_TILE_TIMER);
+	cycles_per_sec = hv_sysconf(HV_SYSCONF_CPU_SPEED);
+	clocksource_calc_mult_shift(&cycle_counter_cs, cycles_per_sec,
+				    TILE_MINSEC);
 }
 
-/* Disable the timer interrupt. */
-static void disable_timer_intr(void)
+void __init calibrate_delay(void)
 {
-	struct timer_status *status = &__get_cpu_var(timer_status);
-	status->enabled = 0;
-	raw_local_irq_mask_now(INT_TILE_TIMER);
+	loops_per_jiffy = get_clock_rate() / HZ;
+	pr_info("Clock rate yields %lu.%02lu BogoMIPS (lpj=%lu)\n",
+		loops_per_jiffy/(500000/HZ),
+		(loops_per_jiffy/(5000/HZ)) % 100, loops_per_jiffy);
 }
 
-/* Mark the start of processing for the timer interrupt. */
-static void start_timer_intr(void)
+/* Called fairly late in init/main.c, but before we go smp. */
+void __init time_init(void)
 {
-	struct timer_status *status = &__get_cpu_var(timer_status);
-	status->in_intr = 1;
-	disable_timer_intr();
-}
+	/* Initialize and register the clock source. */
+	clocksource_register(&cycle_counter_cs);
 
-/* Mark end of processing for the timer interrupt, unmasking if necessary. */
-static void end_timer_intr(void)
-{
-	struct timer_status *status = &__get_cpu_var(timer_status);
-	status->in_intr = 0;
-	if (status->enabled)
-		enable_timer_intr();
+	/* Start up the tile-timer interrupt source on the boot cpu. */
+	setup_tile_timer();
 }
 
 
@@ -173,7 +125,7 @@
 {
 	BUG_ON(ticks > MAX_TICK);
 	__insn_mtspr(SPR_TILE_TIMER_CONTROL, ticks);
-	enable_timer_intr();
+	raw_local_irq_unmask_now(INT_TILE_TIMER);
 	return 0;
 }
 
@@ -184,13 +136,17 @@
 static void tile_timer_set_mode(enum clock_event_mode mode,
 				struct clock_event_device *evt)
 {
-	disable_timer_intr();
+	raw_local_irq_mask_now(INT_TILE_TIMER);
 }
 
+/*
+ * Set min_delta_ns to 1 microsecond, since it takes about
+ * that long to fire the interrupt.
+ */
 static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
 	.name = "tile timer",
 	.features = CLOCK_EVT_FEAT_ONESHOT,
-	.min_delta_ns = 1000,  /* at least 1000 cycles to fire the interrupt */
+	.min_delta_ns = 1000,
 	.rating = 100,
 	.irq = -1,
 	.set_next_event = tile_timer_set_next_event,
@@ -202,15 +158,14 @@
 	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
 
 	/* Fill in fields that are speed-specific. */
-	evt->shift = 20;  /* arbitrary */
-	evt->mult = (cycles_per_sec << evt->shift) / 1000000000ULL;
-	evt->max_delta_ns = (MAX_TICK * 1000000000ULL) / cycles_per_sec;
+	clockevents_calc_mult_shift(evt, cycles_per_sec, TILE_MINSEC);
+	evt->max_delta_ns = clockevent_delta2ns(MAX_TICK, evt);
 
 	/* Mark as being for this cpu only. */
 	evt->cpumask = cpumask_of(smp_processor_id());
 
 	/* Start out with timer not firing. */
-	disable_timer_intr();
+	raw_local_irq_mask_now(INT_TILE_TIMER);
 
 	/* Register tile timer. */
 	clockevents_register_device(evt);
@@ -222,8 +177,11 @@
 	struct pt_regs *old_regs = set_irq_regs(regs);
 	struct clock_event_device *evt = &__get_cpu_var(tile_timer);
 
-	/* Mask timer interrupts in case someone enable interrupts later. */
-	start_timer_intr();
+	/*
+	 * Mask the timer interrupt here, since we are a oneshot timer
+	 * and there are now by definition no events pending.
+	 */
+	raw_local_irq_mask(INT_TILE_TIMER);
 
 	/* Track time spent here in an interrupt context */
 	irq_enter();
@@ -240,43 +198,20 @@
 	 */
 	irq_exit();
 
-	/*
-	 * Enable the timer interrupt (if requested) with irqs disabled,
-	 * so we don't get recursive timer interrupts.
-	 */
-	local_irq_disable();
-	end_timer_intr();
-
 	set_irq_regs(old_regs);
 }
 
 /*
  * Scheduler clock - returns current time in nanosec units.
- *
- * The normal algorithm computes (cycles * cyc2ns_mult) >> cyc2ns_shift.
- * We can make it potentially more efficient and with a better range
- * by writing "cycles" as two 32-bit components, "(H << 32) + L" and
- * then factoring.  Here we use M = cyc2ns_mult and S = cyc2ns_shift.
- *
- *   (((H << 32) + L) * M) >> S =
- *    (((H << 32) * M) >> S) + ((L * M) >> S) =
- *    ((H * M) << (32 - S)) + ((L * M) >> S)
+ * Note that with LOCKDEP, this is called during lockdep_init(), and
+ * we will claim that sched_clock() is zero for a little while, until
+ * we run setup_clock(), above.
  */
 unsigned long long sched_clock(void)
 {
-	u64 cycles;
-	u32 cyc_hi, cyc_lo;
-
-	if (unlikely(cyc2ns_mult == 0))
-		setup_clock();
-
-	cycles = get_cycles();
-	cyc_hi = (u32) (cycles >> 32);
-	cyc_lo = (u32) (cycles);
-
-	/* Compiler could optimize the 32x32 -> 64 multiplies here. */
-	return ((cyc_hi * (u64)cyc2ns_mult) << (32 - cyc2ns_shift)) +
-		((cyc_lo * (u64)cyc2ns_mult) >> cyc2ns_shift);
+	return clocksource_cyc2ns(get_cycles(),
+				  cycle_counter_cs.mult,
+				  cycle_counter_cs.shift);
 }
 
 int setup_profiling_timer(unsigned int multiplier)
diff -ru tile.old/kernel/traps.c tile/kernel/traps.c
--- tile.old/kernel/traps.c	2010-05-28 18:03:33.764878000 -0400
+++ tile/kernel/traps.c	2010-05-28 23:07:05.099015000 -0400
@@ -98,11 +98,11 @@
 #endif /* CHIP_HAS_TILE_DMA() */
 
 /* Defined inside do_trap(), below. */
-
-
-
+#ifdef __tilegx__
+extern tilegx_bundle_bits bpt_code;
+#else
 extern tile_bundle_bits bpt_code;
-
+#endif
 
 void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		       unsigned long reason)
@@ -177,7 +177,7 @@
 		address = regs->pc;
 		break;
 	case INT_UNALIGN_DATA:
-
+#ifndef __tilegx__  /* FIXME: GX: no single-step yet */
 		if (unaligned_fixup >= 0) {
 			struct single_step_state *state =
 				current_thread_info()->step_state;
@@ -186,7 +186,7 @@
 				return;
 			}
 		}
-
+#endif
 		signo = SIGBUS;
 		code = BUS_ADRALN;
 		address = 0;
@@ -204,16 +204,16 @@
 		code = ILL_DBLFLT;
 		address = regs->pc;
 		break;
-
-
-
-
-
-
-
-
-
-
+#ifdef __tilegx__
+	case INT_ILL_TRANS:
+		signo = SIGSEGV;
+		code = SEGV_MAPERR;
+		if (reason & SPR_ILL_TRANS_REASON__I_STREAM_VA_RMASK)
+			address = regs->pc;
+		else
+			address = 0;  /* FIXME: GX: single-step for address */
+		break;
+#endif
 	default:
 		panic("Unexpected do_trap interrupt number %d", fault_num);
 		return;
diff -ru tile.old/kernel/vmlinux.lds.S tile/kernel/vmlinux.lds.S
--- tile.old/kernel/vmlinux.lds.S	2010-05-28 18:03:33.767868000 -0400
+++ tile/kernel/vmlinux.lds.S	2010-05-28 23:07:05.103007000 -0400
@@ -1,12 +1,12 @@
-#define LOAD_OFFSET PAGE_OFFSET
-#define TEXT_OFFSET MEM_SV_INTRPT
-
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/page.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
 #include <hv/hypervisor.h>
 
+/* Text loads starting from the supervisor interrupt vector address. */
+#define TEXT_OFFSET MEM_SV_INTRPT
+
 OUTPUT_ARCH(tile)
 ENTRY(_start)
 jiffies = jiffies_64;
@@ -16,201 +16,83 @@
   intrpt1 PT_LOAD ;
   text PT_LOAD ;
   data PT_LOAD ;
-  note PT_NOTE FLAGS(0);
 }
 SECTIONS
 {
+  /* Text is loaded with a different VA than data; start with text. */
+  #undef LOAD_OFFSET
+  #define LOAD_OFFSET TEXT_OFFSET
+
   /* Interrupt vectors */
-  .intrpt1 (TEXT_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
+  .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
   {
     _text = .;
     _stext = .;
     *(.intrpt1)
   } :intrpt1 =0
 
-#include "hvglue.ld"
+  /* Hypervisor call vectors */
+  #include "hvglue.lds"
 
   /* Now the real code */
   . = ALIGN(0x20000);
-  .text : AT (ADDR(.text) - TEXT_OFFSET) {
-    *(.text.head)
+  HEAD_TEXT_SECTION :text =0
+  .text : AT (ADDR(.text) - LOAD_OFFSET) {
     SCHED_TEXT
     LOCK_TEXT
     __fix_text_end = .;   /* tile-cpack won't rearrange before this */
-#include "sections.lds"
     TEXT_TEXT
     *(.text.*)
     *(.coldtext*)
     *(.fixup)
     *(.gnu.warning)
-  } :text =0
+  }
+  _etext = .;
 
+  /* "Init" is divided into two areas with very different virtual addresses. */
+  INIT_TEXT_SECTION(PAGE_SIZE)
 
-  /* will be freed after init */
-  . = ALIGN(PAGE_SIZE);		/* Init code */
-  __init_text_begin = .;
-  .init.text : AT(ADDR(.init.text) - TEXT_OFFSET) {
-    _sinittext = .;
-    INIT_TEXT
-    _einittext = .;
-  }
+  /* Now we skip back to PAGE_OFFSET for the data. */
+  . = (. - TEXT_OFFSET + PAGE_OFFSET);
+  #undef LOAD_OFFSET
+  #define LOAD_OFFSET PAGE_OFFSET
+
+  . = ALIGN(PAGE_SIZE);
+  VMLINUX_SYMBOL(_sinitdata) = .;
+  .init.page : AT (ADDR(.init.page) - LOAD_OFFSET) {
+    *(.init.page)
+  } :data =0
+  INIT_DATA_SECTION(16)
+  PERCPU(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
-  __init_text_end = .;
-  _etext = .;			/* End of text section */
+  VMLINUX_SYMBOL(_einitdata) = .;
 
-  . = (. - TEXT_OFFSET + LOAD_OFFSET);
   _sdata = .;                   /* Start of data section */
 
-  . = ALIGN(PAGE_SIZE);
+  RO_DATA_SECTION(PAGE_SIZE)
 
   /* initially writeable, then read-only */
   . = ALIGN(PAGE_SIZE);
   __w1data_begin = .;
-
-  __ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-    __start___ex_table = .;
-    *(__ex_table)
-    __stop___ex_table = .;
-  } :data
-
-  __start___dbe_table = .;	/* Exception table for data bus errors */
-  __dbe_table : AT(ADDR(__dbe_table) - LOAD_OFFSET) { *(__dbe_table) }
-  __stop___dbe_table = .;
-
-  . = ALIGN(L2_CACHE_BYTES);
-  .w1data : AT(ADDR(.w1data) - LOAD_OFFSET) { *(.w1data) }
-
-  . = ALIGN(PAGE_SIZE);   /* align to page size */
-  __w1data_end = .;
-
-  NOTES :note
-
-  BUG_TABLE :data
-
-  . = ALIGN(4);
-  __tracedata_start = .;
-  .tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {
-    *(.tracedata)
+  .w1data : AT(ADDR(.w1data) - LOAD_OFFSET) {
+    VMLINUX_SYMBOL(__w1data_begin) = .;
+    *(.w1data)
+    VMLINUX_SYMBOL(__w1data_end) = .;
   }
-  __tracedata_end = .;
 
-  RO_DATA(PAGE_SIZE)
+  RW_DATA_SECTION(L2_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
 
-  /* writeable */
-  . = ALIGN(PAGE_SIZE);   /* align to page size */
-  .data  : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
-    PAGE_ALIGNED_DATA(PAGE_SIZE)
-    CACHELINE_ALIGNED_DATA(64)
-    DATA_DATA
-    CONSTRUCTORS
-    READ_MOSTLY_DATA(64)
-  }
+  _edata = .;
 
-#ifdef CONFIG_FEEDBACK_COLLECT
-  .feedback : {
-    *(.feedback.start)
-    __feedback_functions_start = .;
-    *(.feedback.functions)
-    __feedback_functions_end = .;
-    *(.feedback.strings)
-    *(.feedback.data)
-    __feedback_section_end = .;
-  }
-#endif
+  EXCEPTION_TABLE(L2_CACHE_BYTES)
+  NOTES
 
-  _edata =  .;			/* End of data section */
-
-  /* These sections are pretty big, and not used at all. */
-  /DISCARD/ : { *(.eh_frame) }
-
-  /* will be freed after init (note that init_task is freed separately) */
-  . = ALIGN(THREAD_SIZE);   /* align to thread_union size */
-  .init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-    INIT_TASK_DATA(THREAD_SIZE)
-  __init_data_begin = .;
-    *(.init.data.page_aligned)
-    INIT_DATA
-  }
-  . = ALIGN(16);
-  .init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-       __setup_start = .;
-       *(.init.setup)
-       __setup_end = .;
-   }
-  .initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-    __initcall_start = .;
-    INITCALLS
-    __initcall_end = .;
-  }
-  .con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-       __con_initcall_start = .;
-       *(.con_initcall.init)
-       __con_initcall_end = .;
-  }
-  SECURITY_INIT
-  . = ALIGN(8);
-  .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-       EXIT_TEXT
-  }
-  .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-       EXIT_DATA
-  }
-#if defined(CONFIG_BLK_DEV_INITRD)
-  . = ALIGN(PAGE_SIZE);
-  .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-       __initramfs_start = .;
-       *(.init.ramfs)
-       __initramfs_end = .;
-  }
-#endif
-  PERCPU(PAGE_SIZE)
-  . = ALIGN(PAGE_SIZE);
-  /* freed after init ends here */
-  __init_data_end = .;
-  /* freed after init ends here */
-
-  __bss_start = .;		/* BSS */
-  .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-    . = ALIGN(PAGE_SIZE);
-    *(.bss.page_aligned)
-    *(.bss)
-    *(COMMON)
-    __bss_stop = .;
-  }
 
+  BSS_SECTION(8, PAGE_SIZE, 1)
   _end = . ;
 
-  /* Sections to be discarded */
-  /DISCARD/ : {
-	*(.exit.text)
-	*(.exit.data)
-	*(.exitcall.exit)
-
-	/* ABI crap starts here */
-	*(.comment)
-	*(.MIPS.options)
-	*(.note)
-	*(.options)
-	*(.pdr)
-	*(.reginfo)
-	*(.mdebug*)
-  }
+  STABS_DEBUG
+  DWARF_DEBUG
 
-  /*
-   * DWARF debug sections.
-   * Symbols in the .debug DWARF section are relative to the beginning of the
-   * section so we begin .debug at 0.  It's not clear yet what needs to happen
-   * for the others.
-   */
-  .debug          0 : { *(.debug) }
-  .debug_srcinfo  0 : { *(.debug_srcinfo) }
-  .debug_aranges  0 : { *(.debug_aranges) }
-  .debug_pubnames 0 : { *(.debug_pubnames) }
-  .debug_sfnames  0 : { *(.debug_sfnames) }
-  .line           0 : { *(.line) }
-  /* These must appear regardless of  .  */
-  .gptab.sdata : { *(.gptab.data) *(.gptab.sdata) }
-  .gptab.sbss : { *(.gptab.bss) *(.gptab.sbss) }
-  .comment : { *(.comment) }
-  .note : { *(.note) }
+  DISCARDS
 }
diff -ru tile.old/lib/__invalidate_icache.S tile/lib/__invalidate_icache.S
--- tile.old/lib/__invalidate_icache.S	2010-05-28 18:03:33.790851000 -0400
+++ tile/lib/__invalidate_icache.S	2010-05-28 23:14:24.668719000 -0400
@@ -26,21 +26,21 @@
 #include <asm/page.h>
 #endif
 
+#ifdef __tilegx__
+/* Share code among Tile family chips but adjust opcodes appropriately. */
+#define slt cmpltu
+#define bbst blbst
+#define bnezt bnzt
+#endif
 
-
-
-
-
-
-
-
-
-
-
-
+#if defined(__tilegx__) && __SIZEOF_POINTER__ == 4
+/* Force 32-bit ops so pointers wrap around appropriately. */
+#define ADD_PTR addx
+#define ADDI_PTR addxi
+#else
 #define ADD_PTR add
 #define ADDI_PTR addi
-
+#endif
 
         .section .text.__invalidate_icache, "ax"
         .global __invalidate_icache
diff -ru tile.old/lib/atomic_32.c tile/lib/atomic_32.c
--- tile.old/lib/atomic_32.c	2010-05-28 18:03:33.793842000 -0400
+++ tile/lib/atomic_32.c	2010-05-28 23:14:24.673697000 -0400
@@ -122,25 +122,6 @@
 
 #endif /* CONFIG_SMP */
 
-int __tns_atomic_acquire(atomic_t *lock)
-{
-	int ret;
-	u32 iterations = 0;
-
-	BUG_ON(__insn_mfspr(SPR_INTERRUPT_CRITICAL_SECTION));
-	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 1);
-
-	while ((ret = __insn_tns((void *)&lock->counter)) == 1)
-		delay_backoff(iterations++);
-	return ret;
-}
-
-void __tns_atomic_release(atomic_t *p, int v)
-{
-	p->counter = v;
-	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0);
-}
-
 static inline int *__atomic_setup(volatile void *v)
 {
 	/* Issue a load to the target to bring it into cache. */
diff -ru tile.old/lib/checksum.c tile/lib/checksum.c
--- tile.old/lib/checksum.c	2010-05-28 18:03:33.814826000 -0400
+++ tile/lib/checksum.c	2010-05-28 23:14:24.675696000 -0400
@@ -1,41 +1,35 @@
 /*
- * INET		An implementation of the TCP/IP protocol suite for the LINUX
- *		operating system.  INET is implemented using the  BSD Socket
- *		interface as the means of communication with the user level.
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
  *
- *		IP/TCP/UDP checksumming routines
- *
- * Authors:	Jorge Cwik, <jorge@laser.satlink.net>
- *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
- *		Tom May, <ftom@netcom.com>
- *		Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
- *		Lots of code moved from tcp.c and ip.c; see those files
- *		for more names.
- *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ * Support code for the main lib/checksum.c.
  */
 
 #include <net/checksum.h>
-#include <asm/checksum.h>
 #include <linux/module.h>
 
 static inline unsigned int longto16(unsigned long x)
 {
 	unsigned long ret;
-
-
-
-
+#ifdef __tilegx__
+	ret = __insn_v2sadu(x, 0);
+	ret = __insn_v2sadu(ret, 0);
+#else
 	ret = __insn_sadh_u(x, 0);
 	ret = __insn_sadh_u(ret, 0);
-
+#endif
 	return ret;
 }
 
-static __wsum do_csum(const unsigned char *buff, int len)
+__wsum do_csum(const unsigned char *buff, int len)
 {
 	int odd, count;
 	unsigned long result = 0;
@@ -58,16 +52,16 @@
 		}
 		count >>= 1;		/* nr of 32-bit words.. */
 		if (count) {
-
-
-
-
-
-
-
-
-
-
+#ifdef __tilegx__
+			if (4 & (unsigned long) buff) {
+				unsigned int w = *(const unsigned int *)buff;
+				result = __insn_v2sadau(result, w, 0);
+				count--;
+				len -= 4;
+				buff += 4;
+			}
+			count >>= 1;		/* nr of 64-bit words.. */
+#endif
 
 			/*
 			 * This algorithm could wrap around for very
@@ -79,19 +73,19 @@
 				unsigned long w = *(const unsigned long *)buff;
 				count--;
 				buff += sizeof(w);
-
-
-
+#ifdef __tilegx__
+				result = __insn_v2sadau(result, w, 0);
+#else
 				result = __insn_sadah_u(result, w, 0);
-
+#endif
 			}
-
-
-
-
-
-
-
+#ifdef __tilegx__
+			if (len & 4) {
+				unsigned int w = *(const unsigned int *)buff;
+				result = __insn_v2sadau(result, w, 0);
+				buff += 4;
+			}
+#endif
 		}
 		if (len & 2) {
 			result += *(const unsigned short *) buff;
@@ -106,87 +100,3 @@
 out:
 	return result;
 }
-
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 32-bit boundary
- */
-__wsum csum_partial(const void *buff, int len, __wsum sum)
-{
-	__wsum result = do_csum(buff, len);
-
-	/* add in old sum, and carry.. */
-	result += sum;
-	if (sum > result)
-		result += 1;
-	return result;
-}
-EXPORT_SYMBOL(csum_partial);
-
-/*
- * copy from user space while checksumming, otherwise like csum_partial
- */
-__wsum csum_partial_copy_from_user(const void __user *src,
-				   void *dst, int len, __wsum sum,
-				   int *csum_err)
-{
-	int left = copy_from_user(dst, src, len);
-	if (csum_err)
-		*csum_err = left ? -EFAULT : 0;
-	return csum_partial(dst, len, sum);
-}
-
-/*
- * copy from ds while checksumming, otherwise like csum_partial
- */
-__wsum csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
-{
-	memcpy(dst, src, len);
-	return csum_partial(dst, len, sum);
-}
-
-/*
- *	This is a version of ip_compute_csum() optimized for IP headers,
- *	which always checksum on 4 octet boundaries.
- *
- *	By Jorge Cwik <jorge@laser.satlink.net>, adapted for linux by
- *	Arnt Gulbrandsen.
- */
-__sum16 ip_fast_csum(const void *iph, unsigned int ihl)
-{
-	unsigned int *word = (unsigned int *)iph;
-	unsigned int *stop = word + ihl;
-	unsigned int csum;
-	int carry;
-
-	csum = word[0];
-	csum += word[1];
-	carry = (csum < word[1]);
-	csum += carry;
-
-	csum += word[2];
-	carry = (csum < word[2]);
-	csum += carry;
-
-	csum += word[3];
-	carry = (csum < word[3]);
-	csum += carry;
-
-	word += 4;
-	do {
-		csum += *word;
-		carry = (csum < *word);
-		csum += carry;
-		word++;
-	} while (word != stop);
-
-	return csum_fold(csum);
-}
diff -ru tile.old/lib/delay.c tile/lib/delay.c
--- tile.old/lib/delay.c	2010-05-28 18:03:33.832807000 -0400
+++ tile/lib/delay.c	2010-05-28 23:14:24.679699000 -0400
@@ -32,33 +32,3 @@
 
 /* FIXME: should be declared in a header somewhere. */
 EXPORT_SYMBOL(__delay);
-
-/* Perform bounded exponential backoff.*/
-void delay_backoff(int iterations)
-{
-	u32 exponent, loops;
-
-	/*
-	 * 2^exponent is how many times we go around the loop,
-	 * which takes 8 cycles.  We want to start with a 16- to 31-cycle
-	 * loop, so we need to go around minimum 2 = 2^1 times, so we
-	 * bias the original value up by 1.
-	 */
-	exponent = iterations + 1;
-
-	/*
-	 * Don't allow exponent to exceed 7, so we have 128 loops,
-	 * or 1,024 (to 2,047) cycles, as our maximum.
-	 */
-	if (exponent > 8)
-		exponent = 8;
-
-	loops = 1 << exponent;
-
-	/* Add a randomness factor so two cpus never get in lock step. */
-	loops += __insn_crc32_32(stack_pointer, get_cycle_count_low()) &
-		(loops - 1);
-
-	relax(1 << exponent);
-}
-EXPORT_SYMBOL(delay_backoff);
diff -ru tile.old/lib/exports.c tile/lib/exports.c
--- tile.old/lib/exports.c	2010-05-28 18:03:33.853786000 -0400
+++ tile/lib/exports.c	2010-05-28 23:14:24.707666000 -0400
@@ -66,12 +66,13 @@
 EXPORT_SYMBOL(__umoddi3);
 int64_t __moddi3(int64_t dividend, int64_t divisor);
 EXPORT_SYMBOL(__moddi3);
-
+#ifndef __tilegx__
 uint64_t __ll_mul(uint64_t n0, uint64_t n1);
 EXPORT_SYMBOL(__ll_mul);
-
-
+#endif
+#ifndef __tilegx__
 int64_t __muldi3(int64_t, int64_t);
 EXPORT_SYMBOL(__muldi3);
 uint64_t __lshrdi3(uint64_t, unsigned int);
 EXPORT_SYMBOL(__lshrdi3);
+#endif
diff -ru tile.old/lib/memchr_32.c tile/lib/memchr_32.c
--- tile.old/lib/memchr_32.c	2010-05-28 18:03:33.879756000 -0400
+++ tile/lib/memchr_32.c	2010-05-28 23:14:25.050325000 -0400
@@ -12,18 +12,9 @@
  *   more details.
  */
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-EXPORT_SYMBOL(memchr);
-#else
-#include <string.h>
-#include <stdint.h>
-#ifdef _LIBC
-libc_hidden_proto(memchr)
-#endif
-#endif
 
 void *memchr(const void *s, int c, size_t n)
 {
@@ -55,9 +46,6 @@
 
 	if (__builtin_expect(n == 0, 0)) {
 		/* Don't dereference any memory if the array is empty. */
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		return NULL;
 	}
 
@@ -68,9 +56,6 @@
 			 */
 			return NULL;
 		}
-#ifdef __TILECC__
-#pragma frequency_hint FREQUENT
-#endif
 		v = *++p;
 	}
 
@@ -80,7 +65,4 @@
 	ret = ((char *)p) + (__insn_ctz(bits) >> 3);
 	return (ret <= last_byte_ptr) ? ret : NULL;
 }
-
-#ifdef _LIBC
-libc_hidden_def(memchr)
-#endif
+EXPORT_SYMBOL(memchr);
diff -ru tile.old/lib/memcpy_32.S tile/lib/memcpy_32.S
--- tile.old/lib/memcpy_32.S	2010-05-28 18:03:33.894741000 -0400
+++ tile/lib/memcpy_32.S	2010-05-28 23:14:25.037347000 -0400
@@ -21,7 +21,6 @@
 #define MEMCPY_USE_WH64
 #endif
 
-#ifdef __KERNEL__
 
 #include <linux/linkage.h>
 
@@ -94,21 +93,6 @@
 memcpy_common:
 	/* On entry, r29 holds one of the IS_* macro values from above. */
 
-#else  /* !__KERNEL__ */
-
-#include <feedback.h>
-
-	.section .text.memcpy, "ax"
-	.global memcpy
-	.type memcpy, @function
-	.align 64
-memcpy:
-	FEEDBACK_ENTER(memcpy)
-
-// Create a bogus unused local label.
-#define EX 9
-
-#endif  /* !__KERNEL__ */
 
 	/* r0 is the dest, r1 is the source, r2 is the size. */
 
@@ -118,11 +102,9 @@
 	/* Check for an empty size. */
 	{ bz r2, .Ldone; andi r4, r4, 3 }
 
-#ifdef __KERNEL__
 	/* Save aside original values in case of a fault. */
 	{ move r24, r1; move r25, r2 }
 	move r27, lr
-#endif
 
 	/* Check for an unaligned source or dest. */
 	{ bnz r4, .Lcopy_unaligned_maybe_many; addli r4, r2, -256 }
@@ -158,12 +140,8 @@
 	{ bnz r2, .Lcopy_unaligned_few }
 
 .Ldone:
-#ifdef __KERNEL__
 	/* For memcpy return original dest address, else zero. */
 	{ mz r0, r29, r23; jrp lr }
-#else
-	{ move r0, r23; jrp lr }
-#endif
 
 
 /*
@@ -577,18 +555,6 @@
 	{ bnzt r2, .Lcopy_unaligned_few }
 
 .Lcopy_unaligned_done:
-#ifndef __KERNEL__
-
-	{ move r0, r23; jrp lr }
-
-.Lend_memcpy:
-	.size memcpy, .Lend_memcpy - memcpy
-
-#ifdef _LIBC
-libc_hidden_def(memcpy)
-#endif
-
-#else  /* KERNEL */
 
 	/* For memcpy return original dest address, else zero. */
 	{ mz r0, r29, r23; jrp lr }
@@ -660,5 +626,3 @@
 	.section __ex_table,"a"
 	.word .Lcfu, .Lcopy_from_user_fixup_zero_remainder
 	.word .Lctu, .Lcopy_to_user_fixup_done
-
-#endif  /* __KERNEL__ */
diff -ru tile.old/lib/memmove_32.c tile/lib/memmove_32.c
--- tile.old/lib/memmove_32.c	2010-05-28 18:03:33.900732000 -0400
+++ tile/lib/memmove_32.c	2010-05-28 23:16:26.765512000 -0400
@@ -12,18 +12,9 @@
  *   more details.
  */
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-EXPORT_SYMBOL(memmove);
-#else
-#include <string.h>
-#include <stdint.h>
-#ifdef _LIBC
-libc_hidden_proto(memmove)
-#endif
-#endif
 
 void *memmove(void *dest, const void *src, size_t n)
 {
@@ -51,15 +42,12 @@
 			in = (const uint8_t *)src;
 			out = (uint8_t *)dest;
 			stride = 1;
-		}
+                }
 
 		/* Manually software-pipeline this loop. */
 		x = *in;
 		in += stride;
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 		while (--n != 0) {
 			*out = x;
 			out += stride;
@@ -72,7 +60,4 @@
 
 	return dest;
 }
-
-#ifdef _LIBC
-libc_hidden_def(memmove)
-#endif
+EXPORT_SYMBOL(memmove);
diff -ru tile.old/lib/memset_32.c tile/lib/memset_32.c
--- tile.old/lib/memset_32.c	2010-05-28 18:03:33.903730000 -0400
+++ tile/lib/memset_32.c	2010-05-28 23:14:25.222244000 -0400
@@ -14,22 +14,9 @@
 
 #include <arch/chip.h>
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-EXPORT_SYMBOL(memset);
-#else
-#include <string.h>
-#include <stdint.h>
-#ifndef __TILECC__
-#define __insn_prefetch(addr)
-#define __insn_wh64(addr)
-#endif
-#ifdef _LIBC
-libc_hidden_proto(memset)
-#endif
-#endif
 
 
 void *memset(void *s, int c, size_t n)
@@ -61,9 +48,6 @@
 		 * write this loop.
 		 */
 		if (n != 0) {
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 			do {
 				/* Strangely, combining these into one line
 				 * performs worse.
@@ -91,18 +75,12 @@
 #endif /* !CHIP_HAS_WH64() */
 
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 	/* Align 'out8'. We know n >= 3 so this won't write past the end. */
 	while (((uintptr_t) out8 & 3) != 0) {
 		*out8++ = c;
 		--n;
 	}
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 	/* Align 'n'. */
 	while (n & 3)
 		out8[--n] = c;
@@ -137,18 +115,12 @@
 		if (ahead32 > MAX_PREFETCH * CACHE_LINE_SIZE_IN_WORDS)
 			ahead32 = MAX_PREFETCH * CACHE_LINE_SIZE_IN_WORDS;
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 		for (i = CACHE_LINE_SIZE_IN_WORDS;
 		     i < ahead32; i += CACHE_LINE_SIZE_IN_WORDS)
 			__insn_prefetch(&out32[i]);
 	}
 
 	if (n32 > ahead32) {
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 		while (1) {
 			int j;
 
@@ -176,9 +148,6 @@
 
 			n32 -= CACHE_LINE_SIZE_IN_WORDS;
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 			/* Save icache space by only partially unrolling
 			 * this loop.
 			 */
@@ -250,9 +219,6 @@
 
 		/* Align out32 mod the cache line size so we can use wh64. */
 		n32 -= to_align32;
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 		for (; to_align32 != 0; to_align32--) {
 			*out32 = v32;
 			out32++;
@@ -261,9 +227,6 @@
 		/* Use unsigned divide to turn this into a right shift. */
 		lines_left = (unsigned)n32 / CACHE_LINE_SIZE_IN_WORDS;
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 		do {
 			/* Only wh64 a few lines at a time, so we don't
 			 * exceed the maximum number of victim lines.
@@ -277,19 +240,12 @@
 
 			lines_left -= x;
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 			do {
 				__insn_wh64(wh);
 				wh += CACHE_LINE_SIZE_IN_WORDS;
 			} while (--i);
 
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
-			for (j = x * (CACHE_LINE_SIZE_IN_WORDS / 4);
-			     j != 0; j--) {
+			for (j = x * (CACHE_LINE_SIZE_IN_WORDS / 4); j != 0; j--) {
 				*out32++ = v32;
 				*out32++ = v32;
 				*out32++ = v32;
@@ -307,9 +263,6 @@
 
 	/* Now handle any leftover values. */
 	if (n32 != 0) {
-#ifdef __TILECC__
-#pragma unroll 0
-#endif
 		do {
 			*out32 = v32;
 			out32++;
@@ -318,7 +271,4 @@
 
 	return s;
 }
-
-#ifdef _LIBC
-libc_hidden_def(memset)
-#endif
+EXPORT_SYMBOL(memset);
diff -ru tile.old/lib/spinlock_32.c tile/lib/spinlock_32.c
--- tile.old/lib/spinlock_32.c	2010-05-28 18:03:33.915730000 -0400
+++ tile/lib/spinlock_32.c	2010-05-28 23:14:24.719659000 -0400
@@ -14,9 +14,9 @@
 
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include <linux/delay.h>
 #include <asm/processor.h>
 
+#include "spinlock_common.h"
 
 void arch_spin_lock(arch_spinlock_t *lock)
 {
@@ -98,9 +98,6 @@
 	for (;;) {
 		u32 val = __insn_tns((int *)&rwlock->lock);
 		if (unlikely(val & 1)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 			delay_backoff(iterations++);
 			continue;
 		}
@@ -128,9 +125,6 @@
 {
 	u32 eq, mask = 1 << WR_CURR_SHIFT;
 	while (unlikely(val & 1)) {
-#ifdef __TILECC__
-#pragma frequency_hint NEVER
-#endif
 		/* Limited backoff since we are the highest-priority task. */
 		relax(4);
 		val = __insn_tns((int *)&rwlock->lock);
@@ -206,3 +200,22 @@
 	}
 }
 EXPORT_SYMBOL(arch_write_lock_slow);
+
+int __tns_atomic_acquire(atomic_t *lock)
+{
+	int ret;
+	u32 iterations = 0;
+
+	BUG_ON(__insn_mfspr(SPR_INTERRUPT_CRITICAL_SECTION));
+	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 1);
+
+	while ((ret = __insn_tns((void *)&lock->counter)) == 1)
+		delay_backoff(iterations++);
+	return ret;
+}
+
+void __tns_atomic_release(atomic_t *p, int v)
+{
+	p->counter = v;
+	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0);
+}
--- /dev/null	2010-03-18 09:49:04.311688576 -0400
+++ tile/lib/spinlock_common.h	2010-05-28 23:14:24.716655000 -0400
@@ -0,0 +1,64 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ * This file is included into spinlock_32.c or _64.c.
+ */
+
+/*
+ * The mfspr in __spinlock_relax() is 5 or 6 cycles plus 2 for loop
+ * overhead.
+ */
+#ifdef __tilegx__
+#define CYCLES_PER_RELAX_LOOP 7
+#else
+#define CYCLES_PER_RELAX_LOOP 8
+#endif
+
+/*
+ * Idle the core for CYCLES_PER_RELAX_LOOP * iterations cycles.
+ */
+static inline void
+relax(int iterations)
+{
+	for (/*above*/; iterations > 0; iterations--)
+		__insn_mfspr(SPR_PASS);
+	barrier();
+}
+
+/* Perform bounded exponential backoff.*/
+void delay_backoff(int iterations)
+{
+	u32 exponent, loops;
+
+	/*
+	 * 2^exponent is how many times we go around the loop,
+	 * which takes 8 cycles.  We want to start with a 16- to 31-cycle
+	 * loop, so we need to go around minimum 2 = 2^1 times, so we
+	 * bias the original value up by 1.
+	 */
+	exponent = iterations + 1;
+
+	/*
+	 * Don't allow exponent to exceed 7, so we have 128 loops,
+	 * or 1,024 (to 2,047) cycles, as our maximum.
+	 */
+	if (exponent > 8)
+		exponent = 8;
+
+	loops = 1 << exponent;
+
+	/* Add a randomness factor so two cpus never get in lock step. */
+	loops += __insn_crc32_32(stack_pointer, get_cycles_low()) &
+		(loops - 1);
+
+	relax(1 << exponent);
+}
diff -ru tile.old/lib/strchr_32.c tile/lib/strchr_32.c
--- tile.old/lib/strchr_32.c	2010-05-28 18:03:33.918727000 -0400
+++ tile/lib/strchr_32.c	2010-05-28 23:14:25.226239000 -0400
@@ -12,18 +12,9 @@
  *   more details.
  */
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-EXPORT_SYMBOL(strchr);
-#else
-#include <string.h>
-#include <stdint.h>
-#ifdef _LIBC
-libc_hidden_proto(strchr)
-#endif
-#endif
 
 #undef strchr
 
@@ -60,9 +51,6 @@
 		if (__builtin_expect(zero_matches | goal_matches, 0))
 			break;
 
-#ifdef __TILECC__
-#pragma frequency_hint FREQUENT
-#endif
 		v = *++p;
 	}
 
@@ -75,9 +63,4 @@
 	 */
 	return (g <= z) ? ((char *)p) + (g >> 3) : NULL;
 }
-
-#ifdef _LIBC
-#undef index
-weak_alias(strchr, index)
-libc_hidden_def(strchr)
-#endif
+EXPORT_SYMBOL(strchr);
diff -ru tile.old/lib/strlen_32.c tile/lib/strlen_32.c
--- tile.old/lib/strlen_32.c	2010-05-28 18:03:33.922713000 -0400
+++ tile/lib/strlen_32.c	2010-05-28 23:14:25.231237000 -0400
@@ -12,18 +12,9 @@
  *   more details.
  */
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/module.h>
-EXPORT_SYMBOL(strlen);
-#else
-#include <string.h>
-#include <stdint.h>
-#ifdef _LIBC
-libc_hidden_proto(strlen)
-#endif
-#endif
 
 size_t strlen(const char *s)
 {
@@ -42,7 +33,4 @@
 
 	return ((const char *)p) + (__insn_ctz(bits) >> 3) - s;
 }
-
-#ifdef _LIBC
-libc_hidden_def(strlen)
-#endif
+EXPORT_SYMBOL(strlen);
diff -ru tile.old/lib/uaccess.c tile/lib/uaccess.c
--- tile.old/lib/uaccess.c	2010-05-28 18:03:33.924714000 -0400
+++ tile/lib/uaccess.c	2010-05-28 23:14:24.751622000 -0400
@@ -15,11 +15,6 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 
-
-
-
-
-
 int __range_ok(unsigned long addr, unsigned long size)
 {
 	unsigned long limit = current_thread_info()->addr_limit.seg;
diff -ru tile.old/mm/elf.c tile/mm/elf.c
--- tile.old/mm/elf.c	2010-05-28 18:03:33.948698000 -0400
+++ tile/mm/elf.c	2010-05-28 22:57:15.180141000 -0400
@@ -91,10 +91,10 @@
 {
 	if (vma->vm_private_data == vdso_pages)
 		return "[vdso]";
-
+#ifndef __tilegx__
 	if (vma->vm_start == MEM_USER_INTRPT)
 		return "[intrpt]";
-
+#endif
 	return NULL;
 }
 
@@ -130,7 +130,7 @@
 					 VM_ALWAYSDUMP,
 					 vdso_pages);
 
-
+#ifndef __tilegx__
 	/*
 	 * Set up a user-interrupt mapping here; the user can't
 	 * create one themselves since it is above TASK_SIZE.
@@ -146,7 +146,7 @@
 		if (addr > (unsigned long) -PAGE_SIZE)
 			retval = (int) addr;
 	}
-
+#endif
 
 	up_write(&mm->mmap_sem);
 
diff -ru tile.old/mm/fault.c tile/mm/fault.c
--- tile.old/mm/fault.c	2010-05-28 18:03:33.953695000 -0400
+++ tile/mm/fault.c	2010-05-28 22:57:15.212108000 -0400
@@ -42,8 +42,6 @@
 
 #include <arch/interrupts.h>
 
-#include "../oprofile/op_impl.h"
-
 /*
  * Unlock any spinlocks which will prevent us from getting the
  * message out
@@ -86,14 +84,13 @@
 	force_sig_info(si_signo, &info, tsk);
 }
 
-
+#ifndef __tilegx__
 /*
  * Synthesize the fault a PL0 process would get by doing a word-load of
  * an unaligned address or a high kernel address.  Called indirectly
  * from sys_cmpxchg() in kernel/intvec.S.
  */
-SYSCALL_DEFINE2(cmpxchg_badaddr, unsigned long, address,
-		struct pt_regs *, regs)
+int _sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *regs)
 {
 	if (address >= PAGE_OFFSET)
 		force_sig_info_fault(SIGSEGV, SEGV_MAPERR, address,
@@ -118,7 +115,7 @@
 
 	return 0;
 }
-
+#endif
 
 static inline pmd_t *vmalloc_sync_one(pgd_t *pgd, unsigned long address)
 {
@@ -574,7 +571,7 @@
 	return 0;
 }
 
-
+#ifndef __tilegx__
 
 extern char sys_cmpxchg[], __sys_cmpxchg_end[];
 extern char __sys_cmpxchg_grab_lock[];
@@ -710,7 +707,7 @@
 	return state;
 }
 
-
+#endif /* !__tilegx__ */
 
 /*
  * This routine handles page faults.  It determines the address, and the
@@ -869,10 +866,10 @@
 
 void vmalloc_sync_all(void)
 {
-
-
-
-
+#ifdef __tilegx__
+	/* Currently all L1 kernel pmd's are static and shared. */
+	BUG_ON(pgd_index(VMALLOC_END) != pgd_index(VMALLOC_START));
+#else
 	/*
 	 * Note that races in the updates of insync and start aren't
 	 * problematic: insync can only get set bits added, and updates to
@@ -904,5 +901,5 @@
 		if (address == start && test_bit(pgd_index(address), insync))
 			start = address + PGDIR_SIZE;
 	}
-
+#endif
 }
diff -ru tile.old/mm/homecache.c tile/mm/homecache.c
--- tile.old/mm/homecache.c	2010-05-28 18:03:33.964669000 -0400
+++ tile/mm/homecache.c	2010-05-28 23:19:31.752709000 -0400
@@ -36,36 +36,8 @@
 #include <asm/pgalloc.h>
 #include <asm/homecache.h>
 
-#include <arch/sim.h>
-
 #include "migrate.h"
 
-#ifdef CONFIG_HOMECACHE
-
-/* Forward declarations. */
-static int homecache_get_desired_home(int home, pgprot_t, int writable);
-
-/* Various statistics exposed through /proc/sys/tile/homecache/. */
-
-/* Pages sequestered at "free" time (e.g. immutable). */
-static int homecache_proc_sequestered_free;
-
-/* Pages sequestered at "alloc" time (e.g. homed on a dataplane tile). */
-static int homecache_proc_sequestered_alloc;
-
-/* Times we have done a chip-wide flush and unsequestered everything. */
-static int homecache_proc_sequestered_purge;
-
-/* Number of unmapped pages migrated (i.e. no PTEs yet). */
-static int homecache_proc_migrated_unmapped;
-
-/* Number of mapped pages we have migrated. */
-static int homecache_proc_migrated_mapped;
-
-/* Number of tasks that have been migrated. */
-static int homecache_proc_migrated_tasks;
-
-#endif /* CONFIG_HOMECACHE */
 
 #if CHIP_HAS_COHERENT_LOCAL_CACHE()
 
@@ -89,155 +61,13 @@
 #endif
 
 
-#ifdef CONFIG_HOMECACHE
-
-/*
- * We manage a per-cpu word that says when the last full cache
- * eviction was, and a per-free-page timestamp that says when it was
- * freed, so we can know when we re-allocate that page whether or not
- * we have to go flush it off its old home.
- */
-
-/* Define a global "time" for cache eviction events */
-static atomic_t cache_flush_counter;
-
-/*
- * At what "time" was the cache fully evicted on a given processor?
- * Using -1 here means that all pages initially in the heap (with
- * free_time zero) will report that they are not in cache, even before
- * we do any flushes on any cpus.
- */
-DEFINE_PER_CPU(int, last_cache_flush) = -1;
-
-/*
- * Gather a timestamp to use before we start doing our cache evict.
- * The increment will mean any pages freed later than this time do
- * not assume they are clean based on the eviction we are about to do.
- */
-static inline int mark_caches_evicted_start(void)
-{
-	return atomic_inc_return(&cache_flush_counter);
-}
-
-/*
- * Publish the timestamp for cache eviction on the cpus we evicted.
- * Doing it after the eviction is complete means any pages re-allocated
- * prior to this time will not assume they are clean based on an
- * ongoing eviction.
- */
-static inline void mark_caches_evicted_finish(const struct cpumask *mask,
-					      int timestamp)
-{
-	int i;
-	for_each_cpu(i, mask)
-		per_cpu(last_cache_flush, i) = timestamp;
-}
-
-/* Mark this group of pages as freed at this "time". */
-static inline void mark_pages_free_time(struct page *page, int order)
-{
-	int timestamp = atomic_read(&cache_flush_counter);
-	int pages = 1 << order;
-	int i;
-	for (i = 0; i < pages; ++i)
-		page[i].free_time = timestamp;
-}
-
-/* Report whether this page might still be in the cache on this cpu. */
-static inline int is_free_page_in_cache(int cpu, struct page *page)
-{
-	/*
-	 * Compute an explicit delta so that even after we wrap
-	 * the counters, as long as everything stays within 2 billion
-	 * eviction calls of each other, we will still get correct
-	 * comparative results.  (Though -fwrapv may be an issue.)
-	 */
-	int delta = page->free_time - per_cpu(last_cache_flush, cpu);
-	return delta >= 0;
-}
-
-/* Remove any cpus that must have already flushed this page's data. */
-static void clear_flushed_cpus(struct cpumask *mask, struct page *page)
-{
-	int cpu;
-	for_each_cpu(cpu, mask)
-		if (!is_free_page_in_cache(cpu, page))
-			cpumask_clear_cpu(cpu, mask);
-}
-
-#else
 
 /* Provide no-op versions of these routines to keep flush_remote() cleaner. */
 #define mark_caches_evicted_start() 0
 #define mark_caches_evicted_finish(mask, timestamp) do {} while (0)
 
-#endif /* CONFIG_HOMECACHE */
-
-
-#ifdef CONFIG_DATAPLANE
-
-/* State of TLB deferral on a dataplane cpu. */
-static DEFINE_PER_CPU(atomic_t, dataplane_tlb_state);
-
-/* Provide constants for dataplane TLB deferral. */
-#define TLB_DEFER_KERNEL   0    /* in kernel space */
-/* Note: can't use value "1" since we are using tns-atomic routines. */
-#define TLB_DEFER_USER     2    /* in user space */
-#define TLB_DEFER_PENDING  3    /* in user space with a TLB flush pending */
-
-/*
- * This routine is called on kernel entry from userspace for dataplane
- * tiles, so we can properly adjust our state to be TLB_DEFER_KERNEL,
- * and run a TLB flush if necessary.
- *
- * This routine is only called with interrupts disabled, so we don't
- * need any special handling around the tns atomic call.
- */
-void homecache_tlb_defer_enter(void)
-{
-	atomic_t *state = &__get_cpu_var(dataplane_tlb_state);
-	if (tns_atomic_xchg(state, TLB_DEFER_KERNEL) == TLB_DEFER_PENDING) {
-		unsigned long size = KERNEL_HIGH_VADDR - PAGE_OFFSET;
-		int rc = hv_flush_pages(PAGE_OFFSET, PAGE_SIZE, size);
-		rc |= hv_flush_pages(PAGE_OFFSET, HPAGE_SIZE, size);
-		BUG_ON(rc != 0);
-	}
-}
-
-/*
- * This routine is called on kernel exit to userspace for dataplane
- * tiles, so we can properly adjust our state to be TLB_DEFER_USER.
- *
- * This routine is only called with interrupts disabled, so we don't
- * need any special handling around the tns atomic call.
- */
-void homecache_tlb_defer_exit(void)
-{
-	atomic_t *state = &__get_cpu_var(dataplane_tlb_state);
-
-	/*
-	 * Note that we could write directly to state->counter here
-	 * instead of using the normal serializing tns_atomic_set(),
-	 * since we shouldn't be able to race with the other deferral
-	 * routines any more than we already do.  But it makes it easier
-	 * to reason about this code to use the serializing version,
-	 * and I'm not concerned about performance in this context.
-	 */
-	tns_atomic_set(state, TLB_DEFER_USER);
-}
 
-/*
- * This routine determines if we can defer a TLB flush.
- * It must be called with interrupts disabled.
- */
-static int homecache_tlb_can_defer(int cpu)
-{
-	atomic_t *state = &per_cpu(dataplane_tlb_state, cpu);
-	int old = tns_atomic_cmpxchg(state, TLB_DEFER_USER, TLB_DEFER_PENDING);
-	return (old != TLB_DEFER_KERNEL);
-}
 
-#endif /* CONFIG_DATAPLANE */
 
 /*
  * Update the irq_stat for cpus that we are going to interrupt
@@ -256,35 +86,6 @@
 	if (cache_cpumask)
 		cpumask_or(&mask, &mask, cache_cpumask);
 	if (tlb_cpumask && tlb_length) {
-#ifdef CONFIG_DATAPLANE
-		/*
-		 * If we are doing TLB flushes to kernel addresses we
-		 * check to see if there are any dataplane tiles that
-		 * are currently running user code and if so, mark
-		 * them as pending a TLB flush, and remove them from
-		 * tlb_cpumask.  We only proceed with the flush on
-		 * such tiles if they are in the kernel.
-		 */
-		if (tlb_va >= PAGE_OFFSET &&
-		    tlb_va + tlb_length < KERNEL_HIGH_VADDR) {
-			struct cpumask maybe_defer;
-			cpumask_and(&maybe_defer, tlb_cpumask, &dataplane_map);
-			if (!cpumask_empty(&maybe_defer)) {
-				/*
-				 * We save and restore interrupts here since
-				 * tns-atomic calls in homecache_tlb_can_defer
-				 * require interrupts to be disabled.
-				 */
-				unsigned long flags;
-				local_irq_save(flags);
-				for_each_cpu(cpu, &maybe_defer)
-					if (homecache_tlb_can_defer(cpu))
-						cpumask_clear_cpu(cpu,
-								  tlb_cpumask);
-				local_irq_restore(flags);
-			}
-		}
-#endif
 		cpumask_or(&mask, &mask, tlb_cpumask);
 	}
 
@@ -430,7 +231,8 @@
 /* On the simulator, confirm lines have been evicted everywhere. */
 static void validate_lines_evicted(unsigned long pfn, size_t length)
 {
-	sim_validate_lines_evicted((HV_PhysAddr)pfn << PAGE_SHIFT, length);
+	sim_syscall(SIM_SYSCALL_VALIDATE_LINES_EVICTED,
+		    (HV_PhysAddr)pfn << PAGE_SHIFT, length);
 }
 
 /* Flush a page out of whatever cache(s) it is in. */
@@ -559,8 +361,6 @@
 	return pte;
 }
 
-#ifndef CONFIG_HOMECACHE
-
 /*
  * The routines in this section are the "static" versions of the normal
  * dynamic homecaching routines; they just set the home cache
@@ -643,2069 +443,3 @@
 			__free_page(page++);
 	}
 }
-
-
-#else  /* dynamic homecaching support hooked into the Linux internals */
-
-
-
-/*
- * When we free a page, in addition to marking the pages as free,
- * we check the homing to determine what to do with it.
- *
- * Pages that are compatible with the buddy allocator get freed
- * normally.  With hash_default, this means hash-for-home pages only,
- * since we expect most pages to come back that way.  Otherwise, we
- * do all pages that are "cheap" to re-home (i.e. pages cached on
- * a single cpu, plus uncached pages).
- *
- * Pages that are potentially cached on every cpu are put onto
- * a special global "sequestered" list, since we don't anticipate
- * being able to easily reuse them for anything without doing
- * a global round of cache flushing first.
- *
- * Other pages (the kind that didn't go in the buddy allocator)
- * are stored on a special per-zone free list and checked whenever
- * we do an allocation from that zone that requests a home override,
- * so we can re-use them without having to do a remote flush
- * on a page that we pulled from the buddy allocator.
- */
-
-static spinlock_t homecache_free_lock =
-       __SPIN_LOCK_UNLOCKED(&homecache_free_lock);
-
-static struct list_head homecache_free_list =
-       LIST_HEAD_INIT(homecache_free_list);
-
-/* Do we want to free this page back to the buddy allocator? */
-static int home_is_freeable(int home)
-{
-	/* For hash-default heap, we only free back hash pages. */
-#if CHIP_HAS_CBOX_HOME_MAP()
-	if (hash_default)
-		return home == PAGE_HOME_HASH;
-#endif
-
-	/* Otherwise, we only free back things that are easy to re-home. */
-	return (home == PAGE_HOME_UNCACHED || home >= 0);
-}
-
-/*
- * When resetting a page's homecache (e.g. when freshly allocating the
- * page, flushing out the homecache free list, or converting an
- * immutable page) what home should we reset it to?
- */
-static int default_page_home(void)
-{
-#if CHIP_HAS_CBOX_HOME_MAP()
-	if (hash_default)
-		return PAGE_HOME_HASH;
-#endif
-	/* Arbitrarily home the page back on this cpu. */
-	return smp_processor_id();
-}
-
-/* When true, the homecache checker passes all pages to the buddy allocator. */
-static DEFINE_PER_CPU(int, homecache_is_unsequestering);
-
-int homecache_check_free_page(struct page *page, int order)
-{
-	int pages, i;
-	unsigned long flags;
-	int home = page_home(page);
-	spinlock_t *lock;  /* lock for "list" (below) */
-	struct list_head *list;
-
-	mark_pages_free_time(page, order);
-
-	/*
-	 * Clear the homecache_nomigrate bit; it would only have been
-	 * set if we had vmapped the page and now have unmapped it and
-	 * are freeing it.
-	 */
-	pages = (1 << order);
-	for (i = 0; i < pages; ++i)
-		__ClearPageHomecacheNomigrate(&page[i]);
-
-	/* Validate that the whole allocation was identically homed. */
-	for (i = 1; i < pages; ++i)
-		BUG_ON(page_home(&page[i]) != home);
-
-	/* Huge pages always go back to the allocator. */
-	if (order == HUGETLB_PAGE_ORDER)
-		return 0;
-
-	/*
-	 * In kdata=huge mode, any lowmem page mapped by a small
-	 * kernel PTE goes onto the per-zone freelists, unless the
-	 * "homecache_is_unsequestering" flag is set, in which case we
-	 * have to put them all back into the buddy allocator anyway.
-	 */
-	if (__get_cpu_var(homecache_is_unsequestering) ||
-	    ((!kdata_huge ||
-	      PageHighMem(page) ||
-	      pte_huge(*virt_to_pte(NULL, (ulong)page_address(page)))) &&
-	     home_is_freeable(home)))
-		return 0;
-
-	/*
-	 * Duplicate some code from __free_one_page(), in particular
-	 * unmarking compund pages.
-	 */
-	if (unlikely(PageCompound(page))) {
-		__ClearPageHead(page);
-		for (i = 1; i < pages; i++)
-			__ClearPageTail(page + i);
-	}
-
-	/*
-	 * Otherwise queue the individual pages and tell the buddy free code
-	 * that it doesn't need to deal with them.
-	 */
-	if (home == PAGE_HOME_IMMUTABLE || home == PAGE_HOME_INCOHERENT) {
-		/* We can't easily reuse these, so sequester them away. */
-		lock = &homecache_free_lock;
-		list = &homecache_free_list;
-	} else {
-		struct zone *zone = page_zone(page);
-		lock = &zone->lock;
-		list = &zone->homecache_list;
-	}
-	spin_lock_irqsave(lock, flags);
-	homecache_proc_sequestered_free += pages;
-	for (i = 0; i < pages; ++i)
-		list_add(&page[i].lru, list);
-	spin_unlock_irqrestore(lock, flags);
-	return 1;
-}
-
-/* Check that the page was allocated properly. */
-static void check_page_home(struct page *page, int home)
-{
-	pte_t pte;
-	if (home == PAGE_HOME_UNKNOWN)
-		return;
-#ifdef CONFIG_PREEMPT
-#warning Consider just testing that the page is not hfh here?
-#else
-	if (home == PAGE_HOME_HERE)
-		home = smp_processor_id();
-#endif
-	if (page_home(page) != home)
-		panic("Allocated page PFN %#lx should have home %d, has %d\n",
-		      page_to_pfn(page), home, page_home(page));
-	if (PageHighMem(page))
-		return;
-	pte = *virt_to_pte(NULL, (unsigned long)page_address(page));
-	BUG_ON(pte_to_home(pte) != home);
-}
-
-static inline int homecache_set_desired_home(int home)
-{
-	int oldhome = current->thread.homecache_desired_home;
-	current->thread.homecache_desired_home = home;
-	return oldhome;
-}
-
-struct page *homecache_alloc_pages(gfp_t gfp_mask,
-				   unsigned int order, int home)
-{
-	struct page *page;
-	int oldhome = homecache_set_desired_home(home);
-	page = alloc_pages(gfp_mask, order);
-	homecache_set_desired_home(oldhome);
-	if (page)
-		check_page_home(page, home);
-	return page;
-}
-
-struct page *homecache_alloc_pages_node(int nid, gfp_t gfp_mask,
-					unsigned int order, int home)
-{
-	struct page *page;
-	int oldhome = homecache_set_desired_home(home);
-	page = alloc_pages_node(nid, gfp_mask, order);
-	homecache_set_desired_home(oldhome);
-	if (page)
-		check_page_home(page, home);
-	return page;
-}
-
-struct page *homecache_alloc_page_vma(gfp_t gfp_mask,
-				      struct vm_area_struct *vma,
-				      unsigned long addr)
-{
-	pgprot_t prot = vma->vm_page_prot;
-	if (!pte_get_forcecache(prot)) {
-		return alloc_page_vma(gfp_mask, vma, addr);
-	} else {
-		struct page *page;
-		int oldhome, home = default_page_home();
-
-		home = homecache_get_desired_home(home, prot, 1);
-		oldhome = homecache_set_desired_home(home);
-		page = alloc_page_vma(gfp_mask, vma, addr);
-		homecache_set_desired_home(oldhome);
-		if (page == NULL)
-			return NULL;
-		check_page_home(page, home);
-
-#if CHIP_HAS_NC_AND_NOALLOC_BITS()
-		/*
-		 * If we are allocating a page with noalloc attributes,
-		 * we should ensure it starts with a clean local cache.
-		 * Normal coherence won't necessarily have flushed the
-		 * local cache.
-		 */
-		if (hv_pte_get_no_alloc_l2(prot) ||
-		    hv_pte_get_no_alloc_l1(prot)) {
-			void *addr = kmap_atomic(page, KM_USER0);
-			flush_buffer(addr, PAGE_SIZE);
-			kunmap_atomic(addr, KM_USER0);
-		}
-#endif
-
-		return page;
-	}
-}
-
-/**
- * shatter_huge_page() - ensure a given address is mapped by a small page.
- *
- * This function converts a huge PTE mapping kernel LOWMEM into a bunch
- * of small PTEs with the same caching.  No cache flush required, but we
- * must do a global TLB flush.
- *
- * Any caller that wishes to modify a kernel mapping that might
- * have been made with a huge page should call this function,
- * since doing so properly avoids race conditions with installing the
- * newly-shattered page and then flushing all the TLB entries.
- *
- * @addr: Address at which to shatter any existing huge page.
- */
-static void shatter_huge_page(unsigned long addr)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-	unsigned long flags = 0;  /* happy compiler */
-#ifdef __PAGETABLE_PMD_FOLDED
-	struct list_head *pos;
-#endif
-
-	/* Get a pointer to the pmd entry that we need to change. */
-	addr &= HPAGE_MASK;
-	BUG_ON(pgd_addr_invalid(addr));
-	BUG_ON(addr < PAGE_OFFSET);  /* only for kernel LOWMEM */
-	pgd = swapper_pg_dir + pgd_index(addr);
-	pud = pud_offset(pgd, addr);
-	BUG_ON(!pud_present(*pud));
-	pmd = pmd_offset(pud, addr);
-	BUG_ON(!pmd_present(*pmd));
-	if (!pmd_huge_page(*pmd))
-		return;
-
-	/*
-	 * Grab the pgd_lock, since we may need it to walk the pgd_list,
-	 * and since we need some kind of lock here to avoid races.
-	 */
-	spin_lock_irqsave(&pgd_lock, flags);
-	if (!pmd_huge_page(*pmd)) {
-		/* Lost the race to convert the huge page. */
-		spin_unlock_irqrestore(&pgd_lock, flags);
-		return;
-	}
-
-	/* Shatter the huge page into the preallocated L2 page table. */
-	pmd_populate_kernel(&init_mm, pmd,
-			    get_prealloc_pte(pte_pfn(*(pte_t *)pmd)));
-
-#ifdef __PAGETABLE_PMD_FOLDED
-	/* Walk every pgd on the system and update the pmd there. */
-	list_for_each(pos, &pgd_list) {
-		pmd_t *copy_pmd;
-		pgd = list_to_pgd(pos) + pgd_index(addr);
-		pud = pud_offset(pgd, addr);
-		copy_pmd = pmd_offset(pud, addr);
-		*copy_pmd = *pmd;
-	}
-#endif
-
-	/* Tell every cpu to notice the change. */
-	flush_remote(0, 0, NULL, addr, HPAGE_SIZE, HPAGE_SIZE,
-		     cpu_possible_mask, NULL, 0);
-
-	/* Hold the lock until the TLB flush is finished to avoid races. */
-	spin_unlock_irqrestore(&pgd_lock, flags);
-
-	printk(KERN_DEBUG "homecache: info: shattered huge page %#lx\n", addr);
-}
-
-/* Called with interrupts disabled but the zone unlocked. */
-struct page *homecache_get_cached_page(struct zone *zone, int gfp_flags)
-{
-	struct page *page;
-	int home = current->thread.homecache_desired_home;
-	int require_homecache = kdata_huge && !is_highmem(zone);
-	int order;
-
-	/* Safe to convert here since we have interrupts disabled. */
-	if (home == PAGE_HOME_HERE)
-		home = smp_processor_id();
-
-	/*
-	 * The __GFP_HIGHMEM flag is a hint to this code that, if it
-	 * is in a "require_homecache" zone (lowmem with kdata_huge)
-	 * it should go to the homecache free list even if the request
-	 * does not appear to merit homecaching.  This is because
-	 * such pages are for user space or the page cache, both of
-	 * which are prone to homecache adjustment.
-	 */
-	if (!((gfp_flags & __GFP_HIGHMEM) && require_homecache)) {
-
-		/* Don't bother looking on the list if there's no override. */
-		if (home == PAGE_HOME_UNKNOWN)
-			return NULL;
-
-		/* Don't bother for types that match the allocator. */
-		if (home_is_freeable(home))
-			return NULL;
-
-	}
-
-	/*
-	 * Walk the list looking for a match of homecache.
-	 * NOTE: we could have NR_CPUS+5 (or so) lists per zone and
-	 * just do lookups in constant time when the right type was on
-	 * the list to begin with.  But if we miss we then have
-	 * to check every list to see if there is some other small
-	 * page we can re-homecache.  So for now, keep it simple.
-	 */
-	spin_lock(&zone->lock);
-	list_for_each_entry(page, &zone->homecache_list, lru) {
-		if (page_home(page) == home) {
-			check_page_home(page, home);
-			list_del(&page->lru);
-			goto unlock;
-		}
-	}
-
-	/*
-	 * If we are using huge pages in the buddy allocator, and this
-	 * is a LOWMEM zone, we would rather re-homecache an existing
-	 * small page than shatter a new huge page.  So see if we
-	 * have anything that is usable if we re-homecache it.
-	 * We ignore the "migratetype", which is basically about
-	 * defragmentation, and segregating the homecache pages is
-	 * too, so it's plausible to ignore migratetype if necessary.
-	 */
-	if (require_homecache) {
-		if (!list_empty(&zone->homecache_list)) {
-			page = list_first_entry(&zone->homecache_list, \
-						struct page, lru);
-			list_del(&page->lru);
-			goto unlock;
-		}
-
-		/*
-		 * We need to shatter a new huge page.  Ideally we get
-		 * an entire huge page and shatter it.  But we work
-		 * our way down to order-0 anyway, to be robust.
-		 */
-		for (order = HUGETLB_PAGE_ORDER; order >= 0; --order) {
-			extern struct page *__rmqueue(struct zone *,
-						      unsigned int order,
-						      int migratetype);
-			int migratetype = allocflags_to_migratetype(gfp_flags);
-			page = __rmqueue(zone, order, migratetype);
-			if (page)
-				break;
-		}
-		if (page) {
-			int i, pages = 1 << order;
-			unsigned long kaddr =
-				(unsigned long)page_address(page);
-			shatter_huge_page(kaddr);
-			printk(KERN_DEBUG "homecache: info: added page range"
-			       " at %p (%d pages)\n",
-			       page_address(page), pages);
-			for (i = 1; i < pages; ++i)
-				list_add(&page[i].lru, &zone->homecache_list);
-			goto unlock;
-		}
-
-	}
-
-	/* No luck; just get something from the buddy allocator. */
-	page = NULL;
-
- unlock:
-	spin_unlock(&zone->lock);
-	return page;
-}
-
-/*
- * If this page is cached on a dataplane tile, don't allow the allocator
- * to return it to any other cpu, since it will induce cache flushes
- * on the dataplane tile.
- *
- * We could set a per-cpu word whenever we place a page on the list
- * that is cached on a single cpu.  Then, whenever a dataplane cpu
- * enters the kernel, it checks its per-cpu word to see if it is
- * non-zero, and if so it takes out the homecache free list lock,
- * frees all the pages cached on its own cpu, flushes its own cache,
- * resets the flag word to zero, then releases the lock.  Note that we
- * don't need to check the word under the lock, since if we miss it,
- * it's benign (we do need to modify the word under the lock, though).
- *
- * For now, we don't try to shield dataplane tiles from huge pages
- * being freed on a dataplane tile and reused on a different tile
- * later; huge pages are a very scarce resource and we don't really
- * want to try to sequester them, and in any case, real applications
- * tend to settle down into their final use of huge pages very quickly.
- */
-static int homecache_check_alloced_page(struct page *page, int order)
-{
-#ifdef CONFIG_DATAPLANE
-	int i, pages, cpu, home, rc;
-	unsigned long flags;
-
-	/* If no dataplane tiles or this is a huge page, take an early exit. */
-	if (cpumask_empty(&dataplane_map) || order == HUGETLB_PAGE_ORDER)
-		return 0;
-
-	/* Don't worry about any of this until we finish boot. */
-	if (system_state != SYSTEM_RUNNING)
-		return 0;
-
-	/* Check each page; exit the loop if we find a bad page. */
-	pages = (1 << order);
-	cpu = default_page_home();
-	for (i = 0; ; ++i) {
-		/* If we've checked all the pages, we can use this memory. */
-		if (i == pages)
-			return 0;
-
-		/*
-		 * If this page is already homed correctly, or is
-		 * uncached, it won't cause any trouble.
-		 */
-		home = page_home(&page[i]);
-		if (home == cpu || home == PAGE_HOME_UNCACHED)
-			continue;
-
-		/*
-		 * Any other kind of unusually-cached page is presumed
-		 * to cause trouble to some dataplane cache.  (In fact
-		 * it's possible that hash-for-home cpus might not overlap
-		 * dataplane cpus, but we ignore that for now.)
-		 */
-		if (home < 0)
-			break;
-
-		/*
-		 * The page is homed on a single cpu.  If it's not a
-		 * dataplane cpu, we don't have a problem.
-		 */
-		if (!cpumask_test_cpu(home, &dataplane_map))
-			continue;
-
-		/*
-		 * The page is on a dataplane cpu; if it might be in its
-		 * cache, we can't use this allocation.
-		 */
-		if (is_free_page_in_cache(home, &page[i]))
-			break;
-	}
-
-	/*
-	 * Bad page(s); just put them onto the homecache sequestered list.
-	 * If we put them on the zone free list, we'll probably get them
-	 * back again when we loop back to get a new page, which is bad.
-	 */
-	rc = put_page_testzero(page);
-	BUG_ON(!rc);
-	spin_lock_irqsave(&homecache_free_lock, flags);
-	homecache_proc_sequestered_alloc += pages;
-	for (i = 0; i < pages; ++i)
-		list_add(&page[i].lru, &homecache_free_list);
-	spin_unlock_irqrestore(&homecache_free_lock, flags);
-	return 1;
-#else
-	return 0;
-#endif
-}
-
-static int count_pages(struct list_head *list, spinlock_t *lock)
-{
-	struct list_head *pos;
-	int npages = 0;
-
-	spin_lock(lock);
-	list_for_each(pos, list)
-		++npages;
-	spin_unlock(lock);
-
-	return npages;
-}
-
-long homecache_count_sequestered_pages()
-{
-	struct zone *zone;
-	unsigned long flags;
-	int npages;
-
-	local_irq_save(flags);
-	npages = count_pages(&homecache_free_list, &homecache_free_lock);
-	for_each_zone(zone)
-		npages += count_pages(&zone->homecache_list, &zone->lock);
-	local_irq_restore(flags);
-
-	return npages;
-}
-
-static int homecache_do_free(struct list_head *list, spinlock_t *lock,
-			     unsigned long *low_kaddr,
-			     unsigned long *high_kaddr, int flush_whole_chip)
-{
-	struct list_head work_list;
-	int npages = 0;
-	struct pagevec pvec = { .nr = 1, .cold = 1 };
-
-	/* Capture list onto a local copy */
-	INIT_LIST_HEAD(&work_list);
-	spin_lock(lock);
-	list_splice_init(list, &work_list);
-	spin_unlock(lock);
-
-	/* Re-inject the pages back into the buddy allocator */
-	while (!list_empty(&work_list)) {
-		struct page *page =
-			list_entry(work_list.prev, struct page, lru);
-		int home = page_home(page);
-
-		/*
-		 * If the cpu where this page is cached isn't a cpu
-		 * the hypervisor can flush, we can't return it to the
-		 * allocator.  Just put it back on the homecache
-		 * freelist and continue.
-		 */
-		if (home >= 0 && !cpu_cacheable(home)) {
-			spin_lock(lock);
-			list_add(&page->lru, list);
-			spin_unlock(lock);
-			continue;
-		}
-
-		if (flush_whole_chip) {
-			unsigned long kva = (unsigned long) page_address(page);
-			set_page_home(page, default_page_home());
-			if (kva != 0) {
-				/*
-				 * Flush the TLB for the kernel so we
-				 * can rewrite the PTE to align with
-				 * the newly-chosen home.
-				 */
-				pte_t *pte = virt_to_pte(NULL, kva);
-				BUG_ON(pte == NULL || pte_huge(*pte));
-				set_pte(pte, mk_pte(page, PAGE_KERNEL));
-				if (kva < *low_kaddr)
-					*low_kaddr = kva;
-				if (kva + PAGE_SIZE > *high_kaddr)
-					*high_kaddr = kva + PAGE_SIZE;
-			}
-		}
-		list_del(&page->lru);
-		pvec.pages[0] = page;
-		__pagevec_free(&pvec);   /* free page as a cold page */
-		++npages;
-	}
-
-	/* TODO: this would be an obvious point to unshatter any huge pages. */
-
-	return npages;
-}
-
-int homecache_recover_free_pages()
-{
-	int npages;
-	unsigned long flags;
-	unsigned long low_kaddr = ~0UL, high_kaddr = 0;
-	int flush_whole_chip;
-	static int verbose_message;
-	struct zone *zone;
-
-	/* Disable interrupts so we don't uselessly re-enter this routine. */
-	local_irq_save(flags);
-	__get_cpu_var(homecache_is_unsequestering) = 1;
-
-	/*
-	 * If the per-zone freelists have sufficient pages, just free
-	 * them back to the allocator without resetting their homes
-	 * and without doing a disruptive whole-chip cache flush.
-	 * We can safely return pages from the per-zone lists with no
-	 * need to do anything else for now, since the per-zone pages
-	 * will be homed on single cpus anyway, and we can flush them
-	 * as we start re-allocating them.
-	 *
-	 * We pick an arbitrary threshold number of pages that will trigger
-	 * us to try to go back into the main kernel page allocator.
-	 */
-	flush_whole_chip = 1;
-	npages = 0;
-	for_each_zone(zone) {
-		struct page *page;
-		spin_lock(&zone->lock);
-		list_for_each_entry(page, &zone->homecache_list, lru) {
-			if (++npages > 256) {
-				flush_whole_chip = 0;
-				break;
-			}
-		}
-		spin_unlock(&zone->lock);
-		if (!flush_whole_chip)
-			break;
-	}
-
-	/* Now go and actually free the per-zone lists to the allocator. */
-	npages = 0;
-	for_each_zone(zone)
-		npages += homecache_do_free(&zone->homecache_list, &zone->lock,
-					    &low_kaddr, &high_kaddr,
-					    flush_whole_chip);
-	if (!flush_whole_chip) {
-		__get_cpu_var(homecache_is_unsequestering) = 0;
-		local_irq_restore(flags);
-		printk(KERN_DEBUG "Returned %d per-zone homecache pages"
-		       " to the buddy allocator\n", npages);
-		return 1;
-	}
-
-	/* Add the incoherent pages, and now we have to flush everything. */
-	npages += homecache_do_free(&homecache_free_list, &homecache_free_lock,
-				    &low_kaddr, &high_kaddr, 1);
-	__get_cpu_var(homecache_is_unsequestering) = 0;
-
-	if (npages == 0) {
-		local_irq_restore(flags);
-		return 0;
-	}
-
-	++homecache_proc_sequestered_purge;
-
-	if (low_kaddr > high_kaddr) {
-		low_kaddr = 0;
-		high_kaddr = 0;
-	}
-
-	/* Flush caches and probably TLBs everywhere */
-	flush_remote(0, HV_FLUSH_EVICT_L2, &cpu_cacheable_map,
-		     low_kaddr, high_kaddr - low_kaddr, PAGE_SIZE,
-		     cpu_online_mask, NULL, 0);
-
-	local_irq_restore(flags);
-
-#ifdef CONFIG_DATAPLANE
-	if (!cpus_empty(dataplane_map)) {
-		/*
-		 * If running dataplane tiles, warn on the console about this,
-		 * since we potentially just interrupted a dataplane tile.
-		 */
-		printk(KERN_INFO "cpu %d (%s/%d): homecache freed"
-		       " %d sequestered pages.\n", smp_processor_id(),
-		       current->comm, current->pid, npages);
-		if (!verbose_message) {
-			verbose_message = 1;
-			printk(KERN_INFO
-"The homecache subsystem of the kernel sequesters certain kinds of pages\n"
-"when they are freed, and requires a cache flush on all cpus to reuse them.\n"
-"This may cause unexpected, unavoidable glitches on dataplane cpus.\n"
-"This problem may be caused by running and deleting many executables,\n"
-"as for example is done over a FUSE connection.  It is also commonly seen\n"
-"when the page cache is in heavy use, which we anticipate correcting in a\n"
-"future MDE release.  Note that the cpu and the process that trigger this\n"
-"message may not be responsible for causing the page sequestering.\n"
-				);
-		}
-	}
-#endif
-
-	/* Tell the buddy allocator to jump back and try again. */
-	return 1;
-}
-
-
-/*
- * Provide a lock and two accessors to lock when we are doing
- * page migration and when we are trying to add new kernel mappings.
- */
-
-static spinlock_t kpte_lock = __SPIN_LOCK_UNLOCKED(&kpte_lock);
-
-unsigned long homecache_kpte_lock(void)
-{
-	unsigned long flags;
-	spin_lock_irqsave(&kpte_lock, flags);
-	return flags;
-}
-
-void homecache_kpte_unlock(unsigned long flags)
-{
-	spin_unlock_irqrestore(&kpte_lock, flags);
-}
-
-
-/*
- * Find the kernel PTE mapping this page (either lowmem or kmap) and
- * adjust it as follows.  If "finished" is false, we mark it as
- * migrating; otherwise, we rebuild it "from scratch".  In
- * the normal migration model (mark PTEs migrating; flush TLBs; flush
- * caches; rewrite PTEs) the finished=0 and finished=1 modes
- * correspond to the first and last phases, respectively.
- *
- * FIXME: ptrace writes on huge pages will create temporary mappings
- * of sub-pages within the huge page, and we will not see it since we
- * are only checking for the vaddr of the beginning of the huge page.
- * We could loop calling kmap_fix_kpte() or pass "pages" to kmap_fix_kpte,
- * but either way is still likely pretty inefficient, and we might end
- * up with a set of unrelated kernel VAs that we need to flush.
- */
-static unsigned long homecache_fix_kpte(struct page *page, int pages,
-					int finished)
-{
-	int i, pfn;
-	int home = page->home;
-	unsigned long vaddr;
-	pte_t *ptep;
-	pgprot_t prot;
-
-#ifdef CONFIG_HIGHMEM
-	if (PageHighMem(page)) {
-		kmap_atomic_fix_kpte(page, finished);
-		vaddr = (unsigned long) kmap_fix_kpte(page, finished);
-		return vaddr;
-	}
-#endif
-	pfn = page_to_pfn(page);
-	vaddr = (unsigned long) lowmem_page_address(page);
-	shatter_huge_page((unsigned long)vaddr);
-	ptep = virt_to_pte(NULL, (unsigned long) vaddr);
-	BUG_ON(ptep == NULL || pte_huge(*ptep));
-	prot = (home == PAGE_HOME_IMMUTABLE) ? PAGE_KERNEL_RO : PAGE_KERNEL;
-	prot = (pgprot_t) pte_set_home((pte_t) prot, home);
-	for (i = 0; i < pages; ++i, ++pfn, ++ptep) {
-		if (!finished) {
-			pte_t pte = *ptep;
-			set_pte(ptep, pte_mkmigrate(pte));
-			BUG_ON(!pte_same(pte, pfn_pte(pfn, prot)));
-		} else {
-			set_pte(ptep, pfn_pte(pfn, prot));
-		}
-	}
-	return vaddr;
-}
-
-/* Mark a group of pages with their new homecache. */
-static void set_pages_home(struct page *page, int pages, int home)
-{
-	int i;
-	for (i = 0; i < pages; ++i)
-		set_page_home(&page[i], home);
-}
-
-/*
- * Remember that we allocated this page on this processor,
- * so that we can set up our PTEs to always reference that home.
- * Arguably we might want to be able to batch page allocations
- * here so we can avoid multiple IPI round-trips.  TBD.
- * However, note that we have per-cpu freelists, so that it is
- * at least plausible that we will get mostly same-cpu homed
- * pages once we get into a steady state.
- *
- * Locking requirements are substantially eased in this code
- * because we are guaranteeing that the page(s) are not mapped
- * into user-space anywhere.
- *
- * The "home" argument is the requested new setting for the
- * specified block of pages; the "is_free" argument indicates whether
- * it may be legal to skip cache flushing for the page, which is only
- * true if its data has not been read or written since it was freed.
- */
-static void homecache_home_unmapped_page(struct page *page, int order,
-					 int new_home, int is_free)
-{
-	int pages = 1 << order;
-	int length = pages * PAGE_SIZE;
-	struct cpumask home_mask;
-	const struct cpumask *tlb_mask;
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long vaddr;
-	int i;
-
-	/*
-	 * Validate the assumption that the page is unmapped
-	 * and is available for migration.
-	 */
-	for (i = 0; i < pages; ++i) {
-		BUG_ON(page_mapcount(&page[i]) != 0);
-		BUG_ON(PageHomecacheNomigrate(&page[i]));
-	}
-
-	/* Do a quick check if migration is needed at all. */
-	for (i = 0; i < pages; ++i) {
-		if (page_home(&page[i]) != new_home)
-			break;
-	}
-	if (i == pages)
-		return;
-
-	/*
-	 * We do need to migrate, so build up the mask to flush.
-	 * For pages that are free, we can refine the set of
-	 * cpus to cache-flush, since we don't have to re-flush
-	 * the cache for pages that were freed before the last
-	 * cache evict on that page's cpu.
-	 */
-	cpumask_clear(&home_mask);
-	for (i = 0; i < pages; ++i) {
-		int home = page_home(&page[i]);
-		struct cpumask page_home_mask;
-		if (page_home(&page[i]) == new_home)
-			continue;
-		if (home == PAGE_HOME_UNCACHED)
-			continue;
-		if (home == PAGE_HOME_IMMUTABLE ||
-		    home == PAGE_HOME_INCOHERENT)
-			cpumask_copy(&page_home_mask, &cpu_possible_map);
-#if CHIP_HAS_CBOX_HOME_MAP()
-		else if (home == PAGE_HOME_HASH)
-			cpumask_copy(&page_home_mask, &hash_for_home_map);
-#endif
-		else {
-			BUG_ON(home < 0 || home >= NR_CPUS);
-			cpumask_copy(&page_home_mask, cpumask_of(home));
-		}
-		if (is_free)
-			clear_flushed_cpus(&page_home_mask, page);
-		cpumask_or(&home_mask, &home_mask, &page_home_mask);
-		if (i < pages && cpumask_equal(&home_mask, &cpu_cacheable_map))
-			break;
-	}
-
-	homecache_proc_migrated_unmapped += pages;
-
-	set_pages_home(page, pages, new_home);
-
-	vaddr = homecache_fix_kpte(page, pages, 1);
-	tlb_mask = vaddr ? cpu_online_mask : NULL;
-
-	if (cpumask_empty(&home_mask) && tlb_mask == NULL)
-		return;
-
-	flush_remote(pfn, cache_flush_length(length), &home_mask,
-		     vaddr, length, PAGE_SIZE, tlb_mask, NULL, 0);
-
-	/*
-	 * Don't try to validate for multi-page allocations, since
-	 * some subpages might have the right home to begin with,
-	 * and thus not be flushed at all.
-	 */
-	if (pages == 1)
-		validate_lines_evicted(pfn, length);
-}
-
-void homecache_change_page_home(struct page *page, int order, int home)
-{
-	homecache_home_unmapped_page(page, order, home, 0);
-}
-
-int homecache_new_kernel_page(struct page *page, int order)
-{
-	int rc = homecache_check_alloced_page(page, order);
-	if (rc == 0) {
-		int home = current->thread.homecache_desired_home;
-		if (home == PAGE_HOME_UNKNOWN)
-			home = default_page_home();
-		if (home == PAGE_HOME_HERE)
-			home = smp_processor_id();
-		homecache_home_unmapped_page(page, order, home, 1);
-	}
-	return rc;
-}
-
-void homecache_update_migrating_pte(struct page *page, pte_t *ptep,
-				    struct vm_area_struct *vma,
-				    unsigned long address)
-{
-	pte_t oldpte = *ptep;
-	unsigned long pfn = pte_pfn(oldpte);
-	pte_t pte = pfn_pte(pfn, vma->vm_page_prot);
-	pte.val = (pte.val & ~_PAGE_ALL) | (oldpte.val & _PAGE_ALL);
-	pte = hv_pte_clear_nc(pte_donemigrate(pte));
-	pte = pte_set_home(pte, page_home(page));
-	set_pte_at(vma->vm_mm, address, ptep, pte);
-}
-
-/*
- * Change the homing of a mapped page, flushing any stale PTEs.
- * The page must be locked on entry.
- */
-static void homecache_home_mapped_page(struct page *page, int order,
-				       int new_home)
-{
-	int pages = 1 << order;
-	int length = pages * PAGE_SIZE;
-	void *vaddr;
-	int cleared_home = 0;
-	int ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long flags;
-	struct cpumask home_mask;
-
-	/* Check some requirements. */
-	BUG_ON(!PageLocked(page));
-	BUG_ON(PageHomecacheNomigrate(page));
-
-	/* Check if we need to do anything. */
-	if (page_home(page) == new_home)
-		return;
-
-	homecache_proc_migrated_mapped += pages;
-
-	/*
-	 * Get the set of cpus we need to flush the cache on.
-	 * No need to flush the cache of the cpu that will be the new home.
-	 * This is obvious in the normal case of transitioning from a
-	 * read-only, non-homed page that was widely cached to a coherently
-	 * cached page, and we'll claim it makes sense for incoherent pages
-	 * too: the new coherence point gets to be the "master" in that case.
-	 */
-	homecache_mask(page, pages, &home_mask);
-	if (new_home >= 0) {
-		BUG_ON(new_home >= NR_CPUS);
-		cleared_home = cpumask_test_cpu(new_home, &home_mask);
-		if (cleared_home)
-			cpumask_clear_cpu(new_home, &home_mask);
-	}
-
-	/*
-	 * Now, find all the places where this PTE used to be set,
-	 * mark them all as migrating, and flush the page out of
-	 * TLB in all the mm's that are referencing the page,
-	 * and out of the kernel lowmem or kmap area (if any).
-	 * We flip anonymous PTEs to "migrating" (resetting them below),
-	 * but just clear file PTEs outright.
-	 */
-	if (pages == 1) {
-		int rc = try_to_unmap(page, ttu_flags | TTU_HOMECACHE_START);
-		BUG_ON(!PageAnon(page) && rc != SWAP_SUCCESS);
-	}
-
-	/*
-	 * Lock out any new kmaps so no new kernel PTEs can be created until
-	 * we have finished migration; this also disables interrupts
-	 * while the spinlock is held, to avoid self-deadlock.
-	 */
-	flags = homecache_kpte_lock();
-	vaddr = (void *)homecache_fix_kpte(page, pages, 0);
-	if (vaddr) {
-		flush_remote(0, 0, NULL,
-			     (HV_VirtAddr) vaddr, pages * PAGE_SIZE, PAGE_SIZE,
-			     cpu_online_mask, NULL, 0);
-	}
-
-	/*
-	 * Flush the caches, since no cpu can touch the caches that we
-	 * are migrating away from now.
-	 */
-	flush_remote(pfn, cache_flush_length(length), &home_mask,
-		     0, 0, 0, NULL, NULL, 0);
-
-	/* We expect dirty cache lines if "cleared_home" is true. */
-	if (!cleared_home)
-		validate_lines_evicted(pfn, length);
-
-	/* Mark the pages with their new cache info. */
-	set_pages_home(page, pages, new_home);
-
-	/* Release the kpte lock since new kmaps can be created now. */
-	homecache_kpte_unlock(flags);
-
-	/* Make any anonymous user PTEs assume their correct value. */
-	if (PageAnon(page) && pages == 1)
-		try_to_unmap(page, ttu_flags | TTU_HOMECACHE_FINISH);
-
-	/* Fix the kernel PTE. */
-	homecache_fix_kpte(page, pages, 1);
-}
-
-/*
- * This method checks the given home against the passed pgprot (and
- * whether we intend to write to it) and returns an appropriate new home.
- */
-static int homecache_get_desired_home(int home, pgprot_t prot, int writable)
-{
-	if (home == PAGE_HOME_IMMUTABLE) {
-		/*
-		 * Immutable pages are treated specially.  If we are
-		 * writing to them, we convert them to normal pages
-		 * following the pgprot.  Otherwise, we do nothing,
-		 * since any pgprot is compatible with an immutable page.
-		 */
-		if (!writable)
-			return home;
-		home = default_page_home();
-	}
-
-	/* If the pgprot isn't intended to force the mapping, we're done. */
-	if (!pte_get_forcecache(prot))
-		return home;
-
-	switch (hv_pte_get_mode(prot)) {
-	case HV_PTE_MODE_UNCACHED:
-		home = PAGE_HOME_UNCACHED;
-		break;
-	case HV_PTE_MODE_CACHE_NO_L3:
-		/*
-		 * If we are just caching locally, we must be
-		 * either incoherent or immutable.  Tolerate a
-		 * read-only mapping of incoherent memory.
-		 */
-		if (home != PAGE_HOME_INCOHERENT)
-			home = writable ? PAGE_HOME_INCOHERENT :
-				PAGE_HOME_IMMUTABLE;
-		break;
-	case HV_PTE_MODE_CACHE_TILE_L3:
-		/* Set the page home if requested by the pgprot. */
-		if (!pte_get_anyhome(prot)) {
-			/*
-			 * Get requested CPU.  Note that users can't
-			 * mmap() with a hypervisor lotar, so if one were
-			 * in the pgprot, we would correctly assert
-			 * in get_remote_cache_cpu().
-			 */
-			home = get_remote_cache_cpu(prot);
-		} else {
-			/* A lotar with anyhome is confused. */
-			BUG_ON(hv_pte_get_lotar(prot));
-			if (home < 0)
-				home = smp_processor_id();
-		}
-		/* Writable pages can't be immutable. */
-		if (!writable && hv_pte_get_nc(prot))
-			home = PAGE_HOME_IMMUTABLE;
-		break;
-#if CHIP_HAS_CBOX_HOME_MAP()
-	case HV_PTE_MODE_CACHE_HASH_L3:
-		home = PAGE_HOME_HASH;
-		BUG_ON(hv_pte_get_lotar(prot) != 0);
-		/* Writable pages can't be immutable. */
-		if (!writable && hv_pte_get_nc(prot))
-			home = PAGE_HOME_IMMUTABLE;
-		break;
-#endif
-	default:
-		panic("Invalid mode in pte %#llx", hv_pte_val(prot));
-		break;
-	}
-	return home;
-}
-
-void homecache_home_page_here(struct page *page, int order, pgprot_t prot)
-{
-	int home = page_home(page);
-
-	/*
-	 * If this pgprot forces the page to be homed somewhere specific,
-	 * just return and don't try to move it around.
-	 */
-	if (home != PAGE_HOME_IMMUTABLE &&
-	    pte_get_forcecache(prot) &&
-	    (hv_pte_get_mode(prot) == HV_PTE_MODE_UNCACHED ||
-	     hv_pte_get_mode(prot) == HV_PTE_MODE_CACHE_NO_L3 ||
-#if CHIP_HAS_CBOX_HOME_MAP()
-	     hv_pte_get_mode(prot) == HV_PTE_MODE_CACHE_HASH_L3 ||
-#endif
-	     !pte_get_anyhome(prot)))
-		return;
-
-	/* Make sure the page is actually homed on a single cpu. */
-	if (home < 0 && home != PAGE_HOME_IMMUTABLE)
-		return;
-
-	/* Change this page to be coherently cached on this cpu. */
-	home = homecache_get_desired_home(default_page_home(), prot, 1);
-
-	/* Re-home the page. */
-	homecache_home_mapped_page(page, order, home);
-}
-
-void homecache_update_page(struct page *page, int order,
-			   struct vm_area_struct *vma, int writable)
-{
-	int home = page_home(page);
-	pgprot_t prot = vma->vm_page_prot;
-
-	/*
-	 * If there is already a shared writable mapping for this file, it
-	 * will own the caching of its pages, so just return early.
-	 *
-	 * FIXME: walk through the vmas with vma_prio_tree_foreach()
-	 * and if we overlap with a shared one, force its homing here,
-	 * and if not, use our requested homing.  This would also give
-	 * us better granularity, since there might be a non-overlapping
-	 * shared-writable mapping that this mapping could then ignore.
-	 */
-	if (!(vma->vm_flags & VM_SHARED) &&
-	    vma->vm_file && vma->vm_file->f_mapping->i_mmap_writable > 0)
-		return;
-
-	/*
-	 * If we are setting up a shared writable mapping, we may not
-	 * come into this path via an actual write, but we still want
-	 * to set up the mapping as writable.
-	 */
-	if (hv_pte_get_writable(prot))
-		writable = 1;
-
-	/*
-	 * If the access is for read, and the mapping is private,
-	 * and the page is from a file and is not shared writably,
-	 * we ignore "prot" and make it immutable instead.
-	 *
-	 * If noallocl2 is set, we never cache pages locally, so
-	 * there's no point in claiming they are immutable.
-	 */
-	if (!writable && !(vma->vm_flags & VM_SHARED) && !noallocl2 &&
-	    vma->vm_file && vma->vm_file->f_mapping->i_mmap_writable == 0) {
-		home = PAGE_HOME_IMMUTABLE;
-	} else {
-		home = homecache_get_desired_home(home, prot, writable);
-	}
-
-	homecache_home_mapped_page(page, order, home);
-}
-
-void homecache_make_writable(struct page *page, int order)
-{
-	int home = page_home(page);
-	if (home == PAGE_HOME_IMMUTABLE) {
-		home = homecache_get_desired_home(home, PAGE_KERNEL, 1);
-		homecache_home_mapped_page(page, order, home);
-	}
-}
-
-void homecache_new_user_page(struct page *page, int order,
-			     pgprot_t prot, int writable)
-{
-	int home = page_home(page);
-
-
-	home = homecache_get_desired_home(home, prot, writable);
-	homecache_home_unmapped_page(page, order, home, 0);
-}
-
-
-/* Information needed to migrate user-space PTEs. */
-struct migrating_pte {
-	pte_t pteval;           /* copy of PTE (with migrating bit set) */
-	spinlock_t *ptl;        /* non-NULL if this entry locked the PTE */
-	pmd_t *pmd;             /* PMD that this pte is on */
-	unsigned long va;       /* address for this PTE */
-	struct page *page_lock; /* non-NULL if this entry locked the page */
-};
-
-/*
- * State for the migration algorithm that is passed among processes.
- * This structure is always placed at the beginning of a dedicated page.
- */
-struct migrate_state {
-	cpumask_t cache_cpumask;		/* cpus to flush cache on */
-	cpumask_t tlb_cpumask;			/* cpus to flush TLB on */
-	int num_rem_asids;			/* remote ASID count */
-	HV_Remote_ASID rem_asids[NR_CPUS];	/* remote ASIDs */
-	unsigned long low_kaddr, high_kaddr;    /* bounds of kaddrs to flush */
-	int migrating_index;                    /* next entry in migrating[] */
-	struct migrating_pte migrating[];       /* PTEs we are migrating */
-	/* Note that the migrating[] array extends to the end of the page. */
-};
-
-/* Number of entries we can put in the migrate_state.migrating[] array. */
-#define MIGRATING_COUNT \
-  ((PAGE_SIZE - sizeof(struct migrate_state)) / sizeof(struct migrating_pte))
-
-/* Add information for a new migrating_pte to the list. */
-static void add_migrating_pte(struct migrate_state *ms, pte_t pteval,
-			      spinlock_t *ptl, pmd_t *pmd, unsigned long va,
-			      struct page *page_lock)
-{
-	struct migrating_pte *mpte;
-	BUG_ON(ms->migrating_index >= MIGRATING_COUNT);
-	mpte = &ms->migrating[ms->migrating_index++];
-	mpte->pteval = pteval;
-	mpte->ptl = ptl;
-	mpte->pmd = pmd;
-	mpte->va = va;
-	mpte->page_lock = page_lock;
-}
-
-/* Check to see if we're already locked a given page. */
-static int is_page_locked(struct migrate_state *ms, struct page *page)
-{
-	int i, count = ms->migrating_index;
-	for (i = 0; i < count; ++i)
-		if (ms->migrating[i].page_lock == page)
-			return 1;
-	return 0;
-}
-
-/* Check to see if we're already locked a given page table lock. */
-static int is_page_table_locked(struct migrate_state *ms, spinlock_t *ptl)
-{
-	int i, count = ms->migrating_index;
-	for (i = 0; i < count; ++i)
-		if (ms->migrating[i].ptl == ptl)
-			return 1;
-	return 0;
-}
-
-/*
- * Add information on a region of kernel VAs that we need to flush.
- * Right now we end up just passing a single (start,size) argument to
- * the hypervisor, but we structure it as an API here so that we
- * can use a modified hypervisor API more easily at a later date.
- */
-static void add_kaddr_flush(struct migrate_state *ms,
-			    unsigned long kaddr, unsigned long size)
-{
-	unsigned long end = kaddr + size;
-	if (kaddr < ms->low_kaddr)
-		ms->low_kaddr = kaddr;
-	if (end > ms->high_kaddr)
-		ms->high_kaddr = end;
-}
-
-/*
- * Get a PTE pointer for a small or huge page in the current process
- * from a PMD and address.  Note that this relies on the tile
- * architecture using the same format for PTEs and PGDs (and thus PMDs).
- */
-static pte_t *map_pte(pmd_t *pmd, unsigned long address)
-{
-	if (pmd_huge_page(*pmd))
-		return (pte_t *) pmd;
-	else
-		return pte_offset_map(pmd, address);
-}
-
-/* Unmap a small or huge PTE (only necessary for small PTEs). */
-static inline void unmap_pte(pmd_t *pmd, pte_t *ptep)
-{
-	if (!pmd_huge_page(*pmd))
-		pte_unmap(ptep);
-}
-
-/*
- * Set the migrating bit on the page and PTE (and any kernel PTE),
- * and update the TLB flush info and cache flush info in the migrate_state.
- * Return the pteval that we should expect to find when we finish migrating.
- */
-static pte_t migrate_start_page(struct migrate_state *ms,
-				pte_t *ptep, struct page *page,
-				unsigned long va)
-{
-	pte_t pteval = *ptep;
-
-	/*
-	 * Rewrite the PTE as migrating so any attempt to use it will
-	 * cause a hang.  We use ptep_get_and_clear() to avoid racing
-	 * with the hypervisor's dirty/accessed bit setting.  Note that
-	 * there is a brief window of vulnerability where the pte is
-	 * zero-valued, but this is true elsewhere too, e.g. mprotect.
-	 */
-	pteval = pte_mkmigrate(ptep_get_and_clear(current->mm, va, ptep));
-	set_pte_at(current->mm, va, ptep, pteval);
-
-	/* Record that we need to flush the old cpu's cache. */
-	cpumask_set_cpu(page_home(page), &ms->cache_cpumask);
-
-	return pteval;
-}
-
-/* Poison any kernel PTEs for the page and track any TLB flushes. */
-static void migrate_start_kpte(struct migrate_state *ms,
-			       struct migrating_pte *mpte)
-{
-	pte_t pteval = mpte->pteval;
-	struct page *page = pfn_to_page(pte_pfn(pteval));
-	int npages = pte_huge(pteval) ? (1 << HUGETLB_PAGE_ORDER) : 1;
-	unsigned long kva = homecache_fix_kpte(page, npages, 0);
-	if (kva != 0)
-		add_kaddr_flush(ms, kva, npages * PAGE_SIZE);
-}
-
-/* Adjust the page so it is ready to go with its new cpu home. */
-static void migrate_finish_page(struct migrating_pte *mpte)
-{
-	pte_t pteval = mpte->pteval;
-	struct page *page = pfn_to_page(pte_pfn(pteval));
-	int cpu = smp_processor_id();
-	int npages = pte_huge(pteval) ? (1 << HUGETLB_PAGE_ORDER) : 1;
-	int i;
-
-	/* Fix the page attributes. */
-	for (i = 0; i < npages; i++)
-		set_page_home(&page[i], cpu);
-}
-
-/*
- * Adjust the pte(s) so they are ready to go with their new cpu home.
- * On exit, any cpus that were spinning in page fault are now
- * released, get the updated pte and reset their TLBs appropriately.
- */
-static void migrate_finish_pte(struct migrating_pte *mpte)
-{
-	pmd_t *pmd = mpte->pmd;
-	pte_t pteval = mpte->pteval;
-	struct page *page = pfn_to_page(pte_pfn(pteval));
-	pte_t *ptep;
-	int cpu = smp_processor_id();
-	int npages = pte_huge(pteval) ? (1 << HUGETLB_PAGE_ORDER) : 1;
-
-	/* Adjust the user PTE. */
-	ptep = map_pte(pmd, mpte->va);
-	pteval = pte_donemigrate(set_remote_cache_cpu(pteval, cpu));
-	set_pte_at(current->mm, mpte->va, ptep, pteval);
-	unmap_pte(pmd, ptep);
-
-	/* Adjust any kernel PTEs referencing this page. */
-	homecache_fix_kpte(page, npages, 1);
-}
-
-/*
- * Given a PTE, inspect it to see if it's one we can migrate; if
- * so, return a pointer to the page so we can try to lock it.
- */
-static struct page *pte_to_migratable_page(pte_t pteval)
-{
-	struct page *page;
-	int home;
-
-	if (!pte_present(pteval))
-		return NULL;
-
-	/* Only migrate pages that are coherently cached on a single cpu. */
-	if (hv_pte_get_mode(pteval) != HV_PTE_MODE_CACHE_TILE_L3 ||
-	    hv_pte_get_nc(pteval))
-		return NULL;
-
-	/* Sanity-check the PTE against the page info. */
-	page = pfn_to_page(pte_pfn(pteval));
-	home = page_home(page);
-	if (home != get_remote_cache_cpu(pteval))
-		panic("Candidate PTE %#llx (home %d) has PFN %#lx (home %d)",
-		      pteval.val, get_remote_cache_cpu(pteval),
-		      pte_pfn(pteval), home);
-
-	/* If we're already homed on this cpu, no need to migrate! */
-	if (home == smp_processor_id())
-		return NULL;
-
-	/* If the cpu is not one the hypervisor can cache-flush, skip it. */
-	BUG_ON(home < 0 || home >= NR_CPUS);
-	if (!cpu_cacheable(home))
-		return NULL;
-
-	return page;
-}
-
-/* Check that the page is one that we want to migrate. */
-static int page_migrates_with_process(pte_t pteval, struct page *page)
-{
-	int mapcount;
-
-	/*
-	 * If the page is mapped into multiple mm's, we don't migrate
-	 * it, since we don't provide try_to_unmap() functionality.
-	 *
-	 * NOTE: This also excludes pages that are mapped twice into
-	 * the same mm, but this is a rare case, so we don't worry.
-	 * We actually do support migrating a page mapped more than once
-	 * (see the is_page_locked() calls in maybe_migrate(), below)
-	 * so if we do need to do this later it may not be that hard.
-	 */
-	if (pte_huge(pteval)) {
-		/*
-		 * Mapcount apparently isn't tracked, but we know a huge
-		 * page always has a count for each mapping.
-		 */
-		BUG_ON(page_mapcount(page) != 0);
-		mapcount = page_count(page);
-	} else {
-		mapcount = page_mapcount(page);
-	}
-	BUG_ON(mapcount <= 0);
-	if (mapcount != 1)
-		return 0;
-
-	/* Unlikely to map one of these, but might as well check. */
-	if (PageHomecacheNomigrate(page))
-		return 0;
-
-	return 1;
-}
-
-/*
- * We enter with a candidate VA and a flag indicating whether we should
- * use "trylock" instead of lock, and no locks held (other than the
- * mmap_sem held for read).  We return 0 if things went OK, and 1 if
- * we were in "trylock" mode and failed to acquire a lock.
- *
- * First we validate that the PTE is plausible, and return early if not.
- * Then we try to get a lock on the page, and then map and lock the page
- * table.  This is a bit tricky because we have to lock the page before
- * the page table to respect the ordering in mm/rmap.c.  This means we
- * get a tentative page from the pte, then lock it, lock the page table,
- * and validate the PTE.  If the PTE has changed (perhaps because
- * another thread upgraded a zero-page ref to writable while we were
- * working) we try again until the PTE value is stable.  Once we have a
- * stable, migratable PTE, we call migrate_start_page() on it, and return.
- *
- * Prior to taking any page or page table locks, we scan the list of
- * locks we are currently holding to avoid double-taking any locks.
- * Note that this means that if we already have a page table lock for
- * some page, we will end up trying to take the page lock after the page
- * table lock, in violation of the rmap.c ordering; but since at that
- * point we must already be in trylock mode, and have already made some
- * progress, it doesn't matter.
- *
- * Note that we must have interrupts enabled during this routine
- * since we are acquiring the page lock and the page table lock.
- */
-static int maybe_migrate(struct migrate_state *ms,
-			 unsigned long va, int try_lock)
-{
-	pte_t *ptep;
-	pte_t pteval;
-	spinlock_t *ptl;  /* page table lock for "va" */
-	struct page *page;
-	struct mm_struct *mm = current->mm;
-	int took_page_lock, took_page_table_lock;
-
-	/* Map in the PTE. */
-	pmd_t *pmd = pmd_offset(pud_offset(pgd_offset(mm, va), va), va);
-	pmd_t pmdval = *pmd;
-	if (!pmd_present(pmdval))
-		return 0;
-	ptep = map_pte(pmd, va);
-
-	/*
-	 * Lock the page table (unless we locked it for a previous page).
-	 * We have to do this so it's safe to examine the PTE's page struct.
-	 */
-	took_page_table_lock = 0;
-	if (pmd_huge_page(pmdval))
-		ptl = &mm->page_table_lock;
-	else
-		ptl = pte_lockptr(mm, pmd);
-	if (!is_page_table_locked(ms, ptl)) {
-		if (!spin_trylock(ptl)) {
-			if (try_lock) {
-				unmap_pte(pmd, ptep);
-				return 1;
-			}
-			spin_lock(ptl);
-		}
-		took_page_table_lock = 1;
-	}
-
- retry:
-	/* See if we are interested in this PTE. */
-	pteval = *ptep;
-	page = pte_to_migratable_page(pteval);
-	if (page == NULL || !page_migrates_with_process(pteval, page)) {
-		if (took_page_table_lock)
-			spin_unlock(ptl);
-		unmap_pte(pmd, ptep);
-		return 0;
-	}
-
-	/* Now try to take the page lock. */
-	took_page_lock = 0;
-	if (!is_page_locked(ms, page)) {
-		if (TestSetPageLocked(page)) {
-			if (try_lock) {
-				if (took_page_table_lock)
-					spin_unlock(ptl);
-				unmap_pte(pmd, ptep);
-				return 1;
-			}
-
-			/*
-			 * This is the first page we're trying to acquire,
-			 * so we have to take the page lock first to avoid
-			 * deadlock with (e.g.)  the swapper.  But this
-			 * means we have to drop the existing page table
-			 * lock, which means we have to bump up the
-			 * reference count on the page beforehand, so we
-			 * can still validly look at it when we try to lock
-			 * it.  Then we have to check the PTE to make sure
-			 * it didn't change while we had the PTL dropped.
-			 */
-			BUG_ON(!took_page_table_lock);
-			get_page(page);
-			spin_unlock(ptl);
-			lock_page(page);
-			spin_lock(ptl);
-			if (unlikely(!pte_same(*ptep, pteval))) {
-				unlock_page(page);
-				put_page(page);
-				goto retry;
-			}
-
-			/*
-			 * Drop the extra refcount; we don't need it since
-			 * we will leave the PTL locked from now on.
-			 */
-			put_page(page);
-		}
-
-		/* Now that we have the lock, recheck the page. */
-		if (!page_migrates_with_process(pteval, page)) {
-			unlock_page(page);
-			if (took_page_table_lock)
-				spin_unlock(ptl);
-			unmap_pte(pmd, ptep);
-			return 0;
-		}
-
-		took_page_lock = 1;
-	}
-
-	/* Mark the page for migrating and unmap the PTE. */
-	pteval = migrate_start_page(ms, ptep, page, va);
-	unmap_pte(pmd, ptep);
-
-	/* Record what we migrated and what locks we took out. */
-	if (!took_page_lock)
-		page = NULL;
-	if (!took_page_table_lock)
-		ptl = NULL;
-	add_migrating_pte(ms, pteval, ptl, pmd, va, page);
-	if (page)
-		++homecache_proc_migrated_mapped;
-
-	return 0;
-}
-
-/*
- * Walk the user pages and try to start migrating the ones that need
- * it.  We enter holding the mmap_sem for read.  We return 0 if we
- * were able to migrate every page we were interested in, and the VA
- * to restart at if we need to complete this migration pass and then
- * try again.  On exit, the passed migrate_state structure is updated
- * with the list of user PTEs chosen to migrate, and the kernel VA
- * range is updated with any kernel addresses that have to be
- * explicitly flushed.
- *
- * Marking all the pages for migrating is tricky since we have to
- * worry about ABBA deadlock.  If we've already locked some pages and
- * marked them as migrating, then try to lock a new page or a page
- * table, it's possible that some other thread already holds that
- * lock, but is blocked trying to lock, or create a PTE for, a page
- * that we have already started to migrate.  This would be a deadlock,
- * but instead maybe_migrate() bails out (returning a non-zero start
- * va), we short-circuit this routine, complete the whole migration
- * pass for the pages we've already marked for migration, then loop
- * back in homecache_migrate() and retry.  This way we allow the other
- * task to make forward progress, thus allowing us to eventually be
- * able to acquire the lock that we need as well.
- */
-static unsigned long migrate_start_user(struct migrate_state *ms,
-					unsigned long start_va)
-{
-	struct task_struct *p = current;
-	struct mm_struct *mm = p->mm;
-	int is_threaded = (atomic_read(&mm->mm_users) > 1);
-	pid_t mypid = current->pid;
-	unsigned long usp0 = p->thread.usp0;
-	struct vm_area_struct *vm;
-
-	/* Walk user pages and discover which should be migrated. */
-	for (vm = mm->mmap; vm != NULL; vm = vm->vm_next) {
-		unsigned long va;
-		int page_size = (vm->vm_flags & VM_HUGETLB) ?
-			HPAGE_SIZE : PAGE_SIZE;
-
-		/* Handle MAP_CACHE_HOME_TASK regions. */
-		if (vm->vm_pid != 0) {
-			/* Skip regions owned by another task. */
-			if (vm->vm_pid != mypid)
-				continue;
-
-			/* Update vm_page_prot for subsequent faults. */
-			vm->vm_page_prot = (pgprot_t)
-				set_remote_cache_cpu((pte_t)(vm->vm_page_prot),
-						     smp_processor_id());
-		} else {
-			/* Don't try to migrate regions with explicit homes */
-			if (pte_get_forcecache(vm->vm_page_prot) &&
-			    !pte_get_anyhome(vm->vm_page_prot))
-				continue;
-
-			/* If threaded, we only migrate the stack. */
-			if (is_threaded &&
-			    (usp0 < vm->vm_start || usp0 >= vm->vm_end))
-				continue;
-		}
-
-		/* Walk each page in the region. */
-		va = vm->vm_start > start_va ? vm->vm_start : start_va;
-		for (; va < vm->vm_end; va += page_size) {
-			int try_lock;
-
-			/* If we can't store any more PTE info, retry. */
-			if (ms->migrating_index >= MIGRATING_COUNT)
-				return va;
-
-			/*
-			 * Check this address to see if it needs to
-			 * migrate.  If we've already marked page(s) for
-			 * migration, use "trylock" to avoid deadlock.
-			 * If we get a trylock failure notification,
-			 * give up and indicate we should retry.
-			 */
-			try_lock = (ms->migrating_index != 0);
-			if (maybe_migrate(ms, va, try_lock) != 0)
-				return va;
-		}
-	}
-
-	return 0;
-}
-
-/*
- * Kernel tasks only migrate their stack, at most.  So for kernel
- * tasks, we run a minimal version of homecache_trymigrate(), which
- * doesn't involve allocating any memory.  This is convenient if we
- * are low on memory.
- */
-void homecache_migrate_kthread(void)
-{
-	/*
-	 * We require a single-page stack for now since our assembly
-	 * helper only supports one PTE.  See also similar code in
-	 * homecache_trymigrate().
-	 */
-#if THREAD_SIZE > PAGE_SIZE
-# error Add some code
-#endif
-	struct thread_info *ti = current_thread_info();
-	struct task_struct *p = current;
-	unsigned long stack_va = (unsigned long) p->stack;
-	unsigned long stack_pfn = kaddr_to_pfn((void *)stack_va);
-	pte_t *stack_ptep = virt_to_pte(NULL, stack_va);
-	pte_t stack_pte = *stack_ptep;
-	struct page *stack_page = pfn_to_page(stack_pfn);
-	int stack_home = page_home(stack_page);
-	const struct cpumask *stack_cachemask;
-	struct cpumask *stack_tlbmask;
-	int cpu = smp_processor_id();
-	int rc, timestamp;
-
-	/* Set the homecache_cpu to reflect that we have migrated. */
-	ti->homecache_cpu = cpu;
-
-	/* See if we actually need to do anything. */
-#if CHIP_HAS_CBOX_HOME_MAP()
-	if (unlikely(stack_home == PAGE_HOME_HASH)) {
-		/*
-		 * Possible only for the boot idle task during init
-		 * before we move it to a properly-homed stack.
-		 */
-		return;
-	}
-#endif
-	if (unlikely(stack_home == cpu))
-		return;
-
-	BUG_ON(stack_home != pte_to_home(stack_pte));
-	BUG_ON(stack_home < 0 || stack_home > NR_CPUS);
-	stack_cachemask = &cpumask_of_cpu(stack_home);
-	stack_pte = set_remote_cache_cpu(stack_pte, cpu);
-	BUILD_BUG_ON(sizeof(p->thread.homecache_tlb_flush) !=
-		     sizeof(cpu_online_map));
-	stack_tlbmask = (cpumask_t *) p->thread.homecache_tlb_flush;
-	memcpy(stack_tlbmask, cpu_online_map.bits, sizeof(cpu_online_map));
-	hv_flush_update(stack_cachemask, stack_tlbmask,
-			stack_va, THREAD_SIZE, NULL, 0);
-	timestamp = mark_caches_evicted_start();
-	rc = homecache_migrate_stack_and_flush(stack_pte, stack_va,
-					       THREAD_SIZE, stack_ptep,
-					       stack_cachemask, stack_tlbmask,
-					       NULL, 0);
-	BUG_ON(rc != 0);
-	mark_caches_evicted_finish(stack_cachemask, timestamp);
-	set_page_home(stack_page, cpu);
-	homecache_proc_migrated_mapped++;
-	homecache_proc_migrated_tasks++;
-}
-
-/*
- * Migrate the caching of the current task's pages to its new cpu.
- * Return 0 if we completed successfully, otherwise the VA we should
- * restart at if we faced possible deadlock and gave up part way through.
- * The first invocation must be passed start_va as "0", because this
- * indicates the invocation that will migrate the kernel stack as well.
- */
-static unsigned long homecache_trymigrate(unsigned long start_va)
-{
-	struct task_struct *p = current;
-	struct migrate_state *ms;
-	struct page *stack_page;
-	pte_t *stack_ptep;
-	pte_t stack_pte;
-	int stack_home;
-	int cpu = smp_processor_id();
-	unsigned long end_va;
-	unsigned long flags;
-	int rc, i, other_cpu;
-	int migrate_stack;
-	int timestamp;
-
-	/*
-	 * For vfork'ed children, just return immediately; the parent
-	 * still owns the pages, so we don't want to move any of them.
-	 */
-	if (p->vfork_done != NULL)
-		return 0;
-
-	/*
-	 * Allocate a page that isn't being migrated to store state
-	 * that we can't pass in registers to our helper routine.
-	 * The migrate_state structure is sized to a full page to
-	 * avoid having to bail out of homecache_trymigrate early.
-	 */
-	ms = (struct migrate_state *)__get_free_page(__GFP_NOWARN|GFP_KERNEL);
-	if (ms == NULL) {
-		printk("%s/%d: out of memory: not migrating to cpu %d\n",
-		       current->comm, current->pid, cpu);
-		return 0;
-	}
-
-	/* Initialize the migrating_state */
-	cpumask_clear(&ms->cache_cpumask);
-	cpumask_clear(&ms->tlb_cpumask);
-	ms->num_rem_asids = 0;
-	ms->migrating_index = 0;
-	ms->high_kaddr = 0;
-	ms->low_kaddr = -1UL;
-
-	/*
-	 * This should only ever be called just before returning
-	 * a task to user-space, but be paranoid and check.
-	 */
-	BUG_ON(in_interrupt());
-
-	/* Mark user PTEs for migration. */
-	down_read(&p->mm->mmap_sem);
-	end_va = migrate_start_user(ms, start_va);
-	up_read(&p->mm->mmap_sem);
-
-	if (ms->migrating_index == 0) {
-#if CHIP_HAS_CBOX_HOME_MAP()
-		/*
-		 * In kstack_hash mode, we won't migrate any
-		 * kernel pages, and if we didn't find any
-		 * user pages to migrate either, we're done.
-		 */
-		if (kstack_hash)
-			goto done;
-#endif
-	} else {
-		/*
-		 * Construct the cpu/ASID vector to flush,
-		 * based on what other threads are sharing
-		 * this mm.  Once we have real ASID support we
-		 * will probably have something like a
-		 * cpu/ASID vector in the mm.  For now, we
-		 * just construct one manually.
-		 */
-		for_each_cpu_mask(other_cpu, p->mm->cpu_vm_mask) {
-			int index = ms->num_rem_asids++;
-			HV_Remote_ASID *rem_asid =
-				&ms->rem_asids[index];
-			rem_asid->x = other_cpu % smp_width;
-			rem_asid->y = other_cpu / smp_width;
-			rem_asid->asid =
-				per_cpu(current_asid, other_cpu);
-		}
-	}
-
-	/*
-	 * On our first pass, mark kernel stack for migration.
-	 * For kstack_hash, the kernel stack is hash-for-home,
-	 * so we never migrate it.
-	 */
-#if CHIP_HAS_CBOX_HOME_MAP()
-	if (kstack_hash)
-		migrate_stack = 0;
-	else
-#endif
-	migrate_stack = (start_va == 0);
-
-	if (migrate_stack) {
-		/* See comments above in homecache_migrate_kthread(). */
-		unsigned long stack_va = (unsigned long)(p->stack);
-		unsigned long stack_pfn = kaddr_to_pfn(p->stack);
-		stack_ptep = virt_to_pte(NULL, stack_va);
-		stack_pte = *stack_ptep;
-		stack_page = pfn_to_page(stack_pfn);
-		stack_home = page_home(stack_page);
-		BUG_ON(stack_home != pte_to_home(stack_pte));
-		if (unlikely(stack_home == cpu)) {
-			migrate_stack = 0;
-		} else {
-			cpumask_set_cpu(stack_home, &ms->cache_cpumask);
-			stack_pte = set_remote_cache_cpu(stack_pte, cpu);
-			homecache_proc_migrated_mapped++;
-			add_kaddr_flush(ms, stack_va, THREAD_SIZE);
-		}
-	} else {
-		/* Provide something for the assembly helper to scribble on. */
-		stack_ptep = &stack_pte;
-		__pte_clear(stack_ptep);  /* avoid uninitialized data */
-	}
-
-	/*
-	 * Take out the kpte lock, and disable interrupts, to avoid
-	 * any new kernel PTEs being created while we run this code.
-	 * Then poison any kernel ptes.  Note that we do this after
-	 * migrate_start_page(), in case we need kmaps for HIGHPTE.
-	 * Also note that we need interrupts disabled around the call
-	 * to homecache_migrate_stack_and_flush(), if migrate_stack is true,
-	 * since we are them marking this task's own stack as migrating.
-	 */
-	flags = homecache_kpte_lock();
-	for (i = 0; i < ms->migrating_index; ++i)
-		migrate_start_kpte(ms, &ms->migrating[i]);
-
-	/*
-	 * Call homecache_migrate_stack_and_flush() to ensure the pages that
-	 * we're migrating are flushed from all TLBs and caches,
-	 * then finally write the revised stack_pte to *stack_ptep.
-	 */
-	if (ms->low_kaddr > ms->high_kaddr) {
-		ms->low_kaddr = 0;
-		ms->high_kaddr = 0;
-	} else {
-		cpumask_copy(&ms->tlb_cpumask, cpu_online_mask);
-	}
-	hv_flush_update(&ms->cache_cpumask, &ms->tlb_cpumask,
-			ms->low_kaddr,
-			ms->high_kaddr - ms->low_kaddr,
-			ms->rem_asids,
-			ms->num_rem_asids);
-	timestamp = mark_caches_evicted_start();
-	rc = homecache_migrate_stack_and_flush(stack_pte, ms->low_kaddr,
-					       ms->high_kaddr - ms->low_kaddr,
-					       stack_ptep, &ms->cache_cpumask,
-					       &ms->tlb_cpumask, ms->rem_asids,
-					       ms->num_rem_asids);
-	if (rc != 0)
-		panic("homecache_migrate_stack_and_flush: %d", rc);
-	mark_caches_evicted_finish(&ms->cache_cpumask, timestamp);
-
-	if (migrate_stack)
-		set_page_home(stack_page, cpu);
-
-	/* Mark all the page structures as finished migrating. */
-	for (i = 0; i < ms->migrating_index; ++i)
-		migrate_finish_page(&ms->migrating[i]);
-
-	/*
-	 * Release the kpte lock, now that we can safely create new kmaps.
-	 * In particular note that we need the kpte lock released so we
-	 * can map in user PTEs to update them (if enabled by HIGHPTE).
-	 */
-	homecache_kpte_unlock(flags);
-
-	/*
-	 * Finish migrating.  We loop in reverse
-	 * order since that way we release any shared locks
-	 * after all the PTEs that referenced them.
-	 */
-	for (i = ms->migrating_index - 1; i >= 0; --i) {
-		struct migrating_pte *mpte = &ms->migrating[i];
-
-		/* Validate that we really evicted the page. */
-		unsigned long pfn = pte_pfn(mpte->pteval);
-		int length = pte_huge(mpte->pteval) ?
-			HPAGE_SIZE : PAGE_SIZE;
-		validate_lines_evicted(pfn, length);
-
-		/* Write the new PTE (and kernel PTE). */
-		migrate_finish_pte(mpte);
-
-		/* Unlock the page and the page table, if necessary. */
-		if (mpte->page_lock)
-			unlock_page(mpte->page_lock);
-		if (mpte->ptl)
-			spin_unlock(mpte->ptl);
-	}
-
- done:
-	free_page((unsigned long)ms);
-	return end_va;
-}
-
-/*
- * The migration locks essentially require only one task at a time to
- * migrate away from any given cpu.  This avoids clobbering the source
- * cpu with multiple simultaneous cpu and TLB flushes.  In practice we
- * find that forking many processes and immediately setting their
- * affinity to other cpus runs noticeably faster with this approach.
- */
-static struct mutex migration_lock[NR_CPUS];
-
-static int __init init_migration_locks(void)
-{
-	int i;
-	for (i = 0; i < NR_CPUS; ++i)
-		mutex_init(&migration_lock[i]);
-	return 1;
-}
-arch_initcall(init_migration_locks);
-
-
-/*
- * Called to migrate the home cache of any pages associated with the
- * task if the cpu has changed and we are resuming back to userspace.
- */
-void homecache_migrate(void)
-{
-	struct thread_info *ti;
-	unsigned long start_va, next_va;
-	int cpu, old_cpu;
-
-	/* kthreadd takes this path, so redirect it to kernel task path. */
-	if (current->mm == NULL) {
-		homecache_migrate_kthread();
-		return;
-	}
-
-	/*
-	 * Check and set homecache_cpu with interrupts disabled,
-	 * to avoid potential re-entrancy bugs after any interrupts.
-	 */
-	BUG_ON(!irqs_disabled());
-	cpu = smp_processor_id();
-	ti = current_thread_info();
-	old_cpu = ti->homecache_cpu;
-	BUG_ON(cpu == old_cpu);
-	ti->homecache_cpu = cpu;
-
-	/*
-	 * Disable preemption but enable interrupts; we need
-	 * interrupts enabled throughout the actual migration process,
-	 * in particular so we can handle IPIs to avoid deadlocks
-	 * while we are trying to acquire page table locks.
-	 */
-	preempt_disable();
-	local_irq_enable();
-	mutex_lock(&migration_lock[old_cpu]);
-	homecache_proc_migrated_tasks++;
-
-	/*
-	 * If we hit a potential deadlock (a page or page table locked
-	 * while we had other pages marked for migration) we just
-	 * complete migrating the pages we were holding, then go back
-	 * and rescan and try to pick up some more pages.
-	 */
-	start_va = 0;
-	while ((next_va = homecache_trymigrate(start_va)) != 0) {
-		BUG_ON(next_va <= start_va);
-		start_va = next_va;
-	}
-
-	mutex_unlock(&migration_lock[old_cpu]);
-	local_irq_disable();
-	preempt_enable();
-
-	if (unlikely(current->ptrace & PT_TRACE_MIGRATE)) {
-		current->ptrace_message = cpu;
-		ptrace_notify((PTRACE_EVENT_MIGRATE << 8) | SIGTRAP);
-	}
-}
-
-static ctl_table homecache_table[] = {
-	{
-		.procname	= "migrated_tasks",
-		.data		= &homecache_proc_migrated_tasks,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "migrated_mapped_pages",
-		.data		= &homecache_proc_migrated_mapped,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "migrated_unmapped_pages",
-		.data		= &homecache_proc_migrated_unmapped,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "sequestered_pages_at_free",
-		.data		= &homecache_proc_sequestered_free,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "sequestered_pages_at_alloc",
-		.data		= &homecache_proc_sequestered_alloc,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{
-		.procname	= "sequestered_purges",
-		.data		= &homecache_proc_sequestered_purge,
-		.maxlen		= sizeof(int),
-		.mode		= 0444,
-		.proc_handler	= &proc_dointvec
-	},
-	{}
-};
-
-static ctl_table tile_table[] = {
-	{
-		.procname	= "homecache",
-		.mode		= 0555,
-		.child		= homecache_table,
-	},
-	{0, },
-};
-
-static ctl_table root[] = {
-	{
-		.procname	= "tile",
-		.child		= tile_table,
-	},
-	{0, },
-};
-
-static int __init homecache_proc_init(void)
-{
-	register_sysctl_table(root);
-	return 0;
-}
-subsys_initcall(homecache_proc_init);
-
-#endif /* CONFIG_HOMECACHE */
diff -ru tile.old/mm/init.c tile/mm/init.c
--- tile.old/mm/init.c	2010-05-28 18:03:33.980675000 -0400
+++ tile/mm/init.c	2010-05-28 22:57:15.239079000 -0400
@@ -141,24 +141,24 @@
 		BUG();
 }
 
+#ifdef __tilegx__
 
+#if HV_L1_SIZE != HV_L2_SIZE
+# error Rework assumption that L1 and L2 page tables are same size.
+#endif
 
+/* Since pmd_t arrays and pte_t arrays are the same size, just use casts. */
+static inline pmd_t *alloc_pmd(void)
+{
+	return (pmd_t *)alloc_pte();
+}
 
+static inline void assign_pmd(pud_t *pud, pmd_t *pmd)
+{
+	assign_pte((pmd_t *)pud, (pte_t *)pmd);
+}
 
-
-
-
-
-
-
-
-
-
-
-
-
-
-
+#endif /* __tilegx__ */
 
 /* Replace the given pmd with a full PTE table. */
 void __init shatter_pmd(pmd_t *pmd)
@@ -206,113 +206,7 @@
 static int __initdata kdata_hash = 1;  /* .data and .bss pages */
 int __write_once hash_default = 1;     /* kernel allocator pages */
 EXPORT_SYMBOL(hash_default);
-#ifndef CONFIG_HOMECACHE
 int __write_once kstack_hash = 1;      /* if no homecaching, use h4h */
-#else
-int __write_once kstack_hash;      /* kernel stacks */
-
-/*
- * This function is the primary driver for caching modes set up
- * for kernel text and data.  The "ktext" and "kdata" boot options
- * are relevant only if we are using page-at-a-time caching modes.
- */
-static int __init setup_kcache_hash(char *str)
-{
-	if (str == NULL)
-		return -EINVAL;
-
-	if (strcmp(str, "all") == 0) {
-		ktext_hash = 1;
-		kdata_hash = 1;
-		hash_default = 1;
-		kstack_hash = 1;
-	} else if (strcmp(str, "allbutstack") == 0) {
-		ktext_hash = 1;
-		kdata_hash = 1;
-		hash_default = 1;
-		kstack_hash = 0;
-	} else if (strcmp(str, "static") == 0) {
-		ktext_hash = 1;
-		kdata_hash = 1;
-		hash_default = 0;
-		kstack_hash = 0;
-	} else if (strcmp(str, "ro") == 0) {
-		ktext_hash = 1;
-		kdata_hash = 0;
-		hash_default = 0;
-		kstack_hash = 0;
-	} else if (strcmp(str, "none") == 0) {
-		ktext_hash = 0;
-		kdata_hash = 0;
-		hash_default = 0;
-		kstack_hash = 0;
-	} else {
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-early_param("kcache_hash", setup_kcache_hash);
-
-static int __init set_hash_default(char *str)
-{
-	hash_default = 1;
-	printk("Warning: \"hash_default\" is obsolete and now the default\n.");
-	return 0;
-}
-early_param("hash_default", set_hash_default);
-
-/* From init/main.c */
-extern char *envp_init[CONFIG_INIT_ENV_ARG_LIMIT+2];
-
-static int __init set_ld_cache_hash(const char* env)
-{
-	int i;
-
-	for (i = 0; envp_init[i]; i++) {
-		BUG_ON(i == CONFIG_INIT_ENV_ARG_LIMIT);
-		if (!strncmp(MAP_CACHE_HASH_ENV_VAR "=", envp_init[i],
-			     sizeof(MAP_CACHE_HASH_ENV_VAR))) {
-			return 0;
-		}
-	}
-	if (i == CONFIG_INIT_ENV_ARG_LIMIT) {
-		printk("Warning: can't set default " MAP_CACHE_HASH_ENV_VAR
-		       " since the boot env limit has been reached.\n");
-	} else {
-		envp_init[i] = (char *)env;
-	}
-	return 0;
-}
-
-/*
- * This is hacky, but less so than the alternatives.  We want to make
- * sure we map in the init process suitably, which means we want to
- * have LD_CACHE_HASH set in the initial environment.
- */
-static int __init ld_cache_hash_init(void)
-{
-	return set_ld_cache_hash(MAP_CACHE_HASH_ENV_VAR "=allbutstack");
-}
-late_initcall(ld_cache_hash_init);
-
-/*
- * This is a combo function that both has the effect of kcache_hash
- * and also sets LD_CACHE_HASH to the specified value.
- */
-static int __init setup_cache_hash(char *str)
-{
-	static char env[64] = MAP_CACHE_HASH_ENV_VAR "=";
-	if (str == NULL)
-		return -EINVAL;
-	set_ld_cache_hash(strcat(env, str));
-	return setup_kcache_hash(str);
-}
-
-early_param("cache_hash", setup_cache_hash);
-
-#endif /* CONFIG_HOMECACHE */
 #endif /* CHIP_HAS_CBOX_HOME_MAP */
 
 /*
@@ -324,48 +218,7 @@
 static __initdata struct cpumask kdata_mask;
 static __initdata int kdata_arg_seen;
 
-#ifndef CONFIG_HOMECACHE
 int __write_once kdata_huge;       /* if no homecaching, small pages */
-#else
-int __write_once kdata_huge = CHIP_HAS_CBOX_HOME_MAP(); /* kernel huge pages */
-
-static int __init setup_kdata(char *str)
-{
-	char buf[NR_CPUS * 5];
-
-	if (str == NULL)
-		return -EINVAL;
-
-	if (strcmp(str, "huge") == 0) {
-#if CHIP_HAS_CBOX_HOME_MAP()
-		kdata_huge = 1;
-#else
-		printk("kdata=huge: only supported on TILEPro and later.\n");
-#endif
-		return 0;
-	}
-
-	if (strcmp(str, "small") == 0) {
-		kdata_huge = 0;
-		str += strlen("small");
-		if (*str == ',')
-			++str;
-		if (*str == '\0')
-			return 0;
-	}
-
-	if (cpulist_parse(str, &kdata_mask) != 0)
-		return -EINVAL;
-
-	kdata_arg_seen = 1;
-	cpulist_scnprintf(buf, sizeof(buf), &kdata_mask);
-	printk("kdata: using caching neighborhood %s\n", buf);
-	return 0;
-}
-
-early_param("kdata", setup_kdata);
-
-#endif  /* CONFIG_HOMECACHE */
 
 
 /* Combine a generic pgprot_t with cache home to get a cache-aware pgprot. */
@@ -400,7 +253,7 @@
 #endif
 
 	/* We map the aliased pages of permanent text inaccessible. */
-	if (address < (ulong) __init_text_begin - CODE_DELTA)
+	if (address < (ulong) _sinittext - CODE_DELTA)
 		return PAGE_NONE;
 
 	/*
@@ -418,20 +271,20 @@
 	    address < (ulong)&init_thread_union + THREAD_SIZE)
 		return construct_pgprot(PAGE_KERNEL, smp_processor_id());
 
-
+#ifndef __tilegx__
 #if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 	/* Force the atomic_locks[] array page to be hash-for-home. */
 	if (address == (ulong) atomic_locks)
 		return construct_pgprot(PAGE_KERNEL, PAGE_HOME_HASH);
 #endif
-
+#endif
 
 	/*
 	 * Everything else that isn't data or bss is heap, so mark it
 	 * with the initial heap home (hash-for-home, or this cpu).  This
 	 * includes any addresses after the loaded image; any address before
-	 * __init_text_end (since we already captured the case of text before
-	 * __init_text_begin); and any init-data pages.
+	 * _einittext (since we already captured the case of text before
+	 * _sinittext); and any init-data pages.
 	 *
 	 * All the LOWMEM pages that we mark this way will get their
 	 * struct page homecache properly marked later, in set_page_homes().
@@ -440,8 +293,8 @@
 	 * do a flush action the first time we use them, either.
 	 */
 	if (address >= (ulong) _end || address < (ulong) _sdata ||
-	    (address >= (ulong) __init_data_begin &&
-	     address < (ulong) __init_data_end))
+	    (address >= (ulong) _sinitdata &&
+	     address < (ulong) _einitdata))
 		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
 
 #if CHIP_HAS_CBOX_HOME_MAP()
@@ -457,7 +310,7 @@
 	 * the requested address, while walking cpu home around kdata_mask.
 	 * This is typically no more than a dozen or so iterations.
 	 */
-	BUG_ON(__init_data_end != __bss_start);
+	BUG_ON(_einitdata != __bss_start);
 	for (page = (ulong)_sdata, cpu = NR_CPUS; ; ) {
 		cpu = cpumask_next(cpu, &kdata_mask);
 		if (cpu == NR_CPUS)
@@ -469,16 +322,16 @@
 			page = (ulong)__end_rodata;
 		if (page == (ulong)&init_thread_union)
 			page += THREAD_SIZE;
-		if (page == (ulong)__init_data_begin)
-			page = (ulong)__init_data_end;
+		if (page == (ulong)_sinitdata)
+			page = (ulong)_einitdata;
 		if (page == (ulong)empty_zero_page)
 			page += PAGE_SIZE;
-
+#ifndef __tilegx__
 #if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 		if (page == (ulong)atomic_locks)
 			page += PAGE_SIZE;
 #endif
-
+#endif
 
 	}
 	return construct_pgprot(PAGE_KERNEL, cpu);
@@ -537,14 +390,6 @@
 		printk("ktext: using maximal caching neighborhood\n");
 	}
 
-#ifdef CONFIG_DATAPLANE
-	/* Neighborhood cache ktext pages on all non-dataplane cpus. */
-	else if (strcmp(str, "nondataplane") == 0) {
-		ktext_small = 1;
-		ktext_nondataplane = 1;
-		printk("ktext: caching on all non-dataplane tiles\n");
-	}
-#endif
 
 	/* Neighborhood ktext pages on specified mask */
 	else if (cpulist_parse(str, &ktext_mask) == 0) {
@@ -580,24 +425,24 @@
 	return prot;
 }
 
-
+#ifndef __tilegx__
 static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
 {
 	return pmd_offset(pud_offset(&pgtables[pgd_index(va)], va), va);
 }
-
-
-
-
-
-
-
-
-
+#else
+static pmd_t *__init get_pmd(pgd_t pgtables[], unsigned long va)
+{
+	pud_t *pud = pud_offset(&pgtables[pgd_index(va)], va);
+	if (pud_none(*pud))
+		assign_pmd(pud, alloc_pmd());
+	return pmd_offset(pud, va);
+}
+#endif
 
 /* Temporary page table we use for staging. */
 static pgd_t pgtables[PTRS_PER_PGD]
- __attribute__((section(".init.data.page_aligned")));
+ __attribute__((section(".init.page")));
 
 /*
  * This maps the physical memory to kernel virtual address space, a total
@@ -649,11 +494,6 @@
 	 * the whole chip too.
 	 */
 	cpumask_copy(&kstripe_mask, cpu_possible_mask);
-#ifdef CONFIG_DATAPLANE
-	cpumask_andnot(&kstripe_mask, &kstripe_mask, &dataplane_map);
-	if (cpumask_empty(&kstripe_mask))
-		cpumask_copy(&kstripe_mask, cpu_possible_mask);
-#endif
 	if (!kdata_arg_seen)
 		kdata_mask = kstripe_mask;
 
@@ -752,7 +592,7 @@
 		BUG_ON(address != (unsigned long)_stext);
 		pfn = 0;  /* code starts at PA 0 */
 		pte = alloc_pte();
-		for (pte_ofs = 0; address < (unsigned long)_etext;
+		for (pte_ofs = 0; address < (unsigned long)_einittext;
 		     pfn++, pte_ofs++, address += PAGE_SIZE) {
 			if (!ktext_local) {
 				prot = set_remote_cache_cpu(prot, cpu);
@@ -829,9 +669,9 @@
 {
 	return pagenr < kaddr_to_pfn(_end) &&
 		!(pagenr >= kaddr_to_pfn(&init_thread_union) ||
-		  pagenr < kaddr_to_pfn(__init_data_end)) &&
-		!(pagenr >= kaddr_to_pfn(__init_text_begin) ||
-		  pagenr < kaddr_to_pfn(__init_text_end));
+		  pagenr < kaddr_to_pfn(_einitdata)) &&
+		!(pagenr >= kaddr_to_pfn(_sinittext) ||
+		  pagenr <= kaddr_to_pfn(_einittext-1));
 }
 
 #ifdef CONFIG_HIGHMEM
@@ -936,9 +776,9 @@
 #ifdef CONFIG_HIGHMEM
 	unsigned long vaddr, end;
 #endif
-
-
-
+#ifdef __tilegx__
+	pud_t *pud;
+#endif
 	pgd_t *pgd_base = swapper_pg_dir;
 
 	kernel_physical_mapping_init(pgd_base);
@@ -954,34 +794,20 @@
 	permanent_kmaps_init(pgd_base);
 #endif
 
-
-
-
-
-
-
-
-
-
-
-
-
-}
-
-#ifdef CONFIG_HOMECACHE
-/* Return the PAGE_HOME_xxx value based on the kernel PTE. */
-static int get_page_home(pte_t pte)
-{
-	if (!hv_pte_get_writable(pte))
-		return PAGE_HOME_IMMUTABLE;
-#if CHIP_HAS_CBOX_HOME_MAP()
-	else if (hv_pte_get_mode(pte) == HV_PTE_MODE_CACHE_HASH_L3)
-		return PAGE_HOME_HASH;
+#ifdef __tilegx__
+	/*
+	 * Since GX allocates just one pmd_t array worth of vmalloc space,
+	 * we go ahead and allocate it statically here, then share it
+	 * globally.  As a result we don't have to worry about any task
+	 * changing init_mm once we get up and running, and there's no
+	 * need for e.g. vmalloc_sync_all().
+	 */
+	BUILD_BUG_ON(pgd_index(VMALLOC_START) != pgd_index(VMALLOC_END));
+	pud = pud_offset(pgd_base + pgd_index(VMALLOC_START), VMALLOC_START);
+	assign_pmd(pud, alloc_pmd());
 #endif
-	else
-		return get_remote_cache_cpu(pte);
 }
-#endif
+
 
 /*
  * Walk the kernel page tables and derive the page_home() from
@@ -990,40 +816,6 @@
  */
 void __init set_page_homes(void)
 {
-#ifdef CONFIG_HOMECACHE
-	struct zone *zone;
-	int home = initial_heap_home();
-	unsigned long address;
-
-	/*
-	 * First walk the zones and set the pages to all have
-	 * the default heap caching.
-	 */
-	for_each_zone(zone) {
-		unsigned long pfn = zone->zone_start_pfn;
-		unsigned long end_pfn = pfn + zone->spanned_pages;
-		struct page *page = pfn_to_page(pfn);
-		for (; pfn < end_pfn; ++pfn, ++page)
-			set_page_home(page, home);
-	}
-
-	/*
-	 * Now walk through the loaded pages, update the page homecache,
-	 * and mark all pages as non-migrateable.  (Init pages that
-	 * are freed back to the heap are unmarked when we free them.)
-	 */
-	for (address = PAGE_OFFSET; address < (unsigned long) _end;
-	     address += PAGE_SIZE) {
-		enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
-		struct page *pg = virt_to_page((void *)address);
-		pte_t pte = *virt_to_pte(NULL, address);
-
-		/* Adjust page.home on all loaded pages. */
-		BUG_ON(!pte_present(pte));
-		set_page_home(pg, get_page_home(pte));
-		__SetPageHomecacheNomigrate(pg);
-	}
-#endif
 }
 
 static void __init set_max_mapnr_init(void)
@@ -1037,9 +829,9 @@
 {
 	int codesize, datasize, initsize;
 	int i;
-
+#ifndef __tilegx__
 	void *last;
-
+#endif
 
 #ifdef CONFIG_FLATMEM
 	if (!mem_map)
@@ -1066,16 +858,10 @@
 	/* count all remaining LOWMEM and give all HIGHMEM to page allocator */
 	set_non_bootmem_pages_init();
 
-	codesize =  (unsigned long) &__init_text_begin -
-		(unsigned long) &_text;
-	initsize =  (unsigned long) &__init_text_end -
-		(unsigned long) &__init_text_begin;
-	datasize =  (unsigned long) &__init_data_begin -
-		(unsigned long) &_sdata;
-	initsize += (unsigned long) &__init_data_end -
-		(unsigned long) &__init_data_begin;
-	datasize += (unsigned long) &_end -
-		(unsigned long) &__bss_start;
+	codesize =  (unsigned long)&_etext - (unsigned long)&_text;
+	datasize =  (unsigned long)&_end - (unsigned long)&_sdata;
+	initsize =  (unsigned long)&_einittext - (unsigned long)&_sinittext;
+	initsize += (unsigned long)&_einitdata - (unsigned long)&_sinitdata;
 
 	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init, %ldk highmem)\n",
 		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
@@ -1095,23 +881,25 @@
 	printk(KERN_DEBUG "  PKMAP   %#lx - %#lx\n",
 	       PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP) - 1);
 #endif
+#ifdef CONFIG_HUGEVMAP
 	printk(KERN_DEBUG "  HUGEMAP %#lx - %#lx\n",
 	       HUGE_VMAP_BASE, HUGE_VMAP_END - 1);
+#endif
 	printk(KERN_DEBUG "  VMALLOC %#lx - %#lx\n",
 	       _VMALLOC_START, _VMALLOC_END - 1);
-
-
-
-
-
-
-
-
-
-
-
-
-
+#ifdef __tilegx__
+	for (i = MAX_NUMNODES-1; i >= 0; --i) {
+		struct pglist_data *node = &node_data[i];
+		if (node->node_present_pages) {
+			unsigned long start = (unsigned long)
+				pfn_to_kaddr(node->node_start_pfn);
+			unsigned long end = start +
+				(node->node_present_pages << PAGE_SHIFT);
+			printk(KERN_DEBUG "  MEM%d    %#lx - %#lx\n",
+			       i, start, end - 1);
+		}
+	}
+#else
 	last = high_memory;
 	for (i = MAX_NUMNODES-1; i >= 0; --i) {
 		if ((unsigned long)vbase_map[i] != -1UL) {
@@ -1121,15 +909,15 @@
 			last = vbase_map[i];
 		}
 	}
+#endif
 
-
-
+#ifndef __tilegx__
 	/*
 	 * Convert from using one lock for all atomic operations to
 	 * one per cpu.
 	 */
 	__init_atomic_per_cpu();
-
+#endif
 }
 
 /*
@@ -1178,15 +966,11 @@
 	/* Loop over page table entries */
 	unsigned long addr = (unsigned long)__w1data_begin;
 	BUG_ON((addr & (PAGE_SIZE-1)) != 0);
-	BUG_ON((((unsigned long)__w1data_end) & (PAGE_SIZE-1)) != 0);
-	for (; addr < (unsigned long)__w1data_end; addr += PAGE_SIZE) {
+	for (; addr <= (unsigned long)__w1data_end - 1; addr += PAGE_SIZE) {
 		unsigned long pfn = kaddr_to_pfn((void *)addr);
 		struct page *page = pfn_to_page(pfn);
 		pte_t *ptep = virt_to_pte(NULL, addr);
 		BUG_ON(pte_huge(*ptep));   /* not relevant for kdata_huge */
-#ifdef CONFIG_HOMECACHE
-		set_page_home(page, PAGE_HOME_IMMUTABLE);
-#endif
 		set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, PAGE_KERNEL_RO));
 	}
 }
@@ -1209,9 +993,6 @@
 
 static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 {
-#ifdef CONFIG_HOMECACHE
-	int home = initial_heap_home();
-#endif
 	unsigned long addr = (unsigned long) begin;
 
 	if (kdata_huge && !initfree) {
@@ -1219,6 +1000,7 @@
 		       " incompatible with kdata=huge\n");
 		initfree = 1;
 	}
+	end = (end + PAGE_SIZE - 1) & PAGE_MASK;
 	local_flush_tlb_pages(NULL, begin, PAGE_SIZE, end - begin);
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
 		/*
@@ -1240,10 +1022,6 @@
 			pte_clear(&init_mm, addr, ptep);
 			continue;
 		}
-#ifdef CONFIG_HOMECACHE
-		set_page_home(page, home);
-		__clear_bit(PG_homecache_nomigrate, &page->flags);
-#endif
 		__ClearPageReserved(page);
 		init_page_count(page);
 		if (pte_huge(*ptep))
@@ -1274,16 +1052,16 @@
 
 	/* Free the data pages that we won't use again after init. */
 	free_init_pages("unused kernel data",
-			(unsigned long)__init_data_begin,
-			(unsigned long)__init_data_end);
+			(unsigned long)_sinitdata,
+			(unsigned long)_einitdata);
 
 	/*
 	 * Free the pages mapped from 0xc0000000 that correspond to code
 	 * pages from 0xfd000000 that we won't use again after init.
 	 */
 	free_init_pages("unused kernel text",
-			(unsigned long)__init_text_begin - text_delta,
-			(unsigned long)__init_text_end - text_delta);
+			(unsigned long)_sinittext - text_delta,
+			(unsigned long)_einittext - text_delta);
 
 #if !CHIP_HAS_COHERENT_LOCAL_CACHE()
 	/*
diff -ru tile.old/mm/migrate_32.S tile/mm/migrate_32.S
--- tile.old/mm/migrate_32.S	2010-05-28 18:03:34.021619000 -0400
+++ tile/mm/migrate_32.S	2010-05-28 22:57:15.246070000 -0400
@@ -43,208 +43,6 @@
 #define FRAME_SIZE	32
 
 
-#ifdef CONFIG_HOMECACHE
-/*
- * On entry:
- *
- *   r0 low word of the new stack PTE to use (moved to r_stack_pte_lo)
- *   r1 high word of the new stack PTE to use (moved to r_stack_pte_hi)
- *   r2 low virtual address
- *   r3 length of virtual address range
- *   r4 pointer to stack PTE to use (moved to r_stack_ptep)
- *   r5 cache cpumask pointer
- *   r6 tlb cpumask pointer
- *   r7 HV_Remote_ASID array pointer
- *   r8 HV_Remote_ASID count
- */
-
-/* Arguments (caller-save) */
-#define r_stack_pte_lo_in r0
-#define r_stack_pte_hi_in r1
-#define r_va		r2
-#define r_length	r3
-#define r_stack_ptep_in	r4
-#define r_cache_cpumask_in r5
-#define r_tlb_cpumask   r6
-#define r_rem_asids     r7
-#define r_num_rem_asids r8
-
-/* Locals (callee-save); must not be more than FRAME_xxx above. */
-#define r_save_ics	r30
-#define r_cache_cpumask	r31
-#define r_stack_ptep	r32
-#define r_stack_pte_lo	r33
-#define r_stack_pte_hi	r34
-
-STD_ENTRY(homecache_migrate_stack_and_flush)
-
-	/*
-	 * Create a stack frame; we can't touch it once we set the
-	 * migrating bit on the stack PTE until we clear it at the end.
-	 */
-	{
-	 move r_save_sp, sp
-	 sw sp, lr
-	 addi sp, sp, -FRAME_SIZE
-	}
-	addi r_tmp, sp, FRAME_SP
-	{
-	 sw r_tmp, r_save_sp
-	 addi r_tmp, sp, FRAME_R30
-	}
-	{
-	 sw r_tmp, r30
-	 addi r_tmp, sp, FRAME_R31
-	}
-	{
-	 sw r_tmp, r31
-	 addi r_tmp, sp, FRAME_R32
-	}
-	{
-	 sw r_tmp, r32
-	 addi r_tmp, sp, FRAME_R33
-	}
-	{
-	 sw r_tmp, r33
-	 addi r_tmp, sp, FRAME_R34
-	}
-	sw r_tmp, r34
-
-	/* Move some arguments to callee-save registers. */
-	{
-	 move r_cache_cpumask, r_cache_cpumask_in
-	 move r_stack_ptep, r_stack_ptep_in
-	}
-	{
-	 move r_stack_pte_lo, r_stack_pte_lo_in
-	 move r_stack_pte_hi, r_stack_pte_hi_in
-	}
-
-	/* Make sure our stack writes have reached the remote cache. */
-	mf
-
-	/* Disable interrupts, since we can't use our stack. */
-	{
-	 mfspr r_save_ics, INTERRUPT_CRITICAL_SECTION
-	 movei r_tmp, 1
-	}
-	mtspr INTERRUPT_CRITICAL_SECTION, r_tmp
-
-	/* Clear the present bit and set the migrating bit on the stack. */
-#if HV_PTE_INDEX_MIGRATING >= 32 || HV_PTE_INDEX_PRESENT >= 32
-# error Fix code that assumes the present and migrating bits are in low word
-#endif
-	lw r_tmp, r_stack_ptep
-	andi r_tmp, r_tmp, ~HV_PTE_PRESENT
-	ori r_tmp, r_tmp, HV_PTE_MIGRATING
-	sw r_stack_ptep, r_tmp
-	mf
-
-	/*
-	 * Now we do a global TLB flush:
-	 *
-	 *   hv_flush_remote(0ULL, 0, NULL,
-	 *                   va, length, PAGE_SIZE, tlb_cpumask,
-	 *                   rem_asids, num_rem_asids);
-	 *
-	 */
-	{
-	 move r9, r_num_rem_asids
-	 move r8, r_rem_asids
-	}
-	{
-	 move r7, r_tlb_cpumask
-	 moveli r6, lo16(PAGE_SIZE)
-	}
-	{
-	 auli r6, r6, ha16(PAGE_SIZE)
-	 move r5, r_length
-	}
-	{
-	 move r4, r_va
-	 move r3, zero
-	}
-	{
-	 move r2, zero
-	 move r1, zero
-	}
-	{
-	 move r0, zero
-	 jal hv_flush_remote
-	}
-	bnz r0, .Lwrite_stack_pte
-
-	/*
-	 * And now a cache flush on the old cpus:
-	 *
-	 *   hv_flush_remote(0ULL, HV_FLUSH_EVICT_L2, cache_cpumask,
-	 *                   NULL, 0, 0, 0, NULL, 0)
-	 *
-	 */
-	{
-	 move r0, zero
-	 move r1, zero
-	}
-	{
-	 auli r2, zero, ha16(HV_FLUSH_EVICT_L2)
-	 move r3, r_cache_cpumask
-	}
-	{
-	 move r4, zero
-	 move r5, zero
-	}
-	{
-	 move r6, zero
-	 move r7, zero
-	}
-	{
-	 move r8, zero
-	 move r9, zero
-	}
-	jal hv_flush_remote
-
-.Lwrite_stack_pte:
-	/* Finally, write the new stack PTE. */
-#if HV_PTE_INDEX_MIGRATING >= 32
-# error Fix code that assumes we should unmigrate by writing high word first
-#endif
-	addi r_tmp, r_stack_ptep, 4
-	sw r_tmp, r_stack_pte_hi
-	sw r_stack_ptep, r_stack_pte_lo
-	mf
-
-	/* Reset interrupts back how they were before. */
-	mtspr INTERRUPT_CRITICAL_SECTION, r_save_ics
-
-	/* Restore the callee-saved registers and return. */
-	addli lr, sp, FRAME_SIZE
-	{
-	 lw lr, lr
-	 addli r_tmp, sp, FRAME_R30
-	}
-	{
-	 lw r30, r_tmp
-	 addli r_tmp, sp, FRAME_R31
-	}
-	{
-	 lw r31, r_tmp
-	 addli r_tmp, sp, FRAME_R32
-	}
-	{
-	 lw r32, r_tmp
-	 addli r_tmp, sp, FRAME_R33
-	}
-	{
-	 lw r33, r_tmp
-	 addli r_tmp, sp, FRAME_R34
-	}
-	{
-	 lw r34, r_tmp
-	 addi sp, sp, FRAME_SIZE
-	}
-	jrp lr
-	STD_ENDPROC(homecache_migrate_stack_and_flush)
-#endif
 
 
 /*
diff -ru tile.old/mm/mmap.c tile/mm/mmap.c
--- tile.old/mm/mmap.c	2010-05-28 18:03:34.031602000 -0400
+++ tile/mm/mmap.c	2010-05-28 22:57:15.270036000 -0400
@@ -51,13 +51,13 @@
  */
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
-
+#if !defined(__tilegx__)
 	int is_32bit = 1;
-
-
-
-
-
+#elif defined(CONFIG_COMPAT)
+	int is_32bit = is_compat_task();
+#else
+	int is_32bit = 0;
+#endif
 
 	/*
 	 * Use standard layout if the expected stack growth is unlimited
diff -ru tile.old/mm/pgtable.c tile/mm/pgtable.c
--- tile.old/mm/pgtable.c	2010-05-28 18:03:34.033601000 -0400
+++ tile/mm/pgtable.c	2010-05-28 22:57:15.268041000 -0400
@@ -212,14 +212,14 @@
 	memset(pgd, 0, KERNEL_PGD_INDEX_START*sizeof(pgd_t));
 	spin_lock_irqsave(&pgd_lock, flags);
 
-
+#ifndef __tilegx__
 	/*
 	 * Check that the user interrupt vector has no L2.
 	 * It never should for the swapper, and new page tables
 	 * should always start with an empty user interrupt vector.
 	 */
 	BUG_ON(((u64 *)swapper_pg_dir)[pgd_index(MEM_USER_INTRPT)] != 0);
-
+#endif
 
 	clone_pgd_range(pgd + KERNEL_PGD_INDEX_START,
 			swapper_pg_dir + KERNEL_PGD_INDEX_START,
@@ -304,7 +304,7 @@
 	}
 }
 
-
+#ifndef __tilegx__
 
 /*
  * FIXME: needs to be atomic vs hypervisor writes.  For now we make the
@@ -339,7 +339,7 @@
 	tmp[1] = tmp[1] & ~(1 << (HV_PTE_INDEX_WRITABLE - 32));
 }
 
-
+#endif
 
 pte_t *virt_to_pte(struct mm_struct* mm, unsigned long addr)
 {
@@ -391,9 +391,9 @@
 	/* Update the home of a PTE if necessary */
 	pte = pte_set_home(pte, page_home(page));
 
-
-
-
+#ifdef __tilegx__
+	*ptep = pte;
+#else
 	/*
 	 * When setting a PTE, write the high bits first, then write
 	 * the low bits.  This sets the "present" bit only after the
@@ -411,7 +411,7 @@
 	((u32 *)ptep)[1] = (u32)(pte_val(pte) >> 32);
 	barrier();
 	((u32 *)ptep)[0] = (u32)(pte_val(pte));
-
+#endif
 }
 
 /* Can this mm load a PTE with cached_priority set? */
Only in tile.old: oprofile

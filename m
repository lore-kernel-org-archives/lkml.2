Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab1BMG3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 01:29:42 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:55147 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab1BMG3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 01:29:35 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 01/11] unicore32 core architecture: build infrastructure
Date: Sun, 13 Feb 2011 14:29:23 +0800
Message-ID: <02e301cbcb47$5aa9b8e0$0ffd2aa0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvLR0d4YwNSWYDVR4mDhbEbDvArZg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements build infrastructure.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/.gitignore               |   21 +++
 arch/unicore32/Kconfig                  |  248 +++++++++++++++++++++++++++++++
 arch/unicore32/Kconfig.debug            |   68 +++++++++
 arch/unicore32/Makefile                 |   97 ++++++++++++
 arch/unicore32/configs/debug_defconfig  |  210 ++++++++++++++++++++++++++
 arch/unicore32/configs/nb0916_defconfig |  202 +++++++++++++++++++++++++
 arch/unicore32/include/asm/Kbuild       |    2 +
 arch/unicore32/include/asm/linkage.h    |   22 +++
 arch/unicore32/kernel/Makefile          |   34 +++++
 arch/unicore32/kernel/vmlinux.lds.S     |   61 ++++++++
 10 files changed, 965 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/.gitignore
 create mode 100644 arch/unicore32/Kconfig
 create mode 100644 arch/unicore32/Kconfig.debug
 create mode 100644 arch/unicore32/Makefile
 create mode 100644 arch/unicore32/configs/debug_defconfig
 create mode 100644 arch/unicore32/configs/nb0916_defconfig
 create mode 100644 arch/unicore32/include/asm/Kbuild
 create mode 100644 arch/unicore32/include/asm/linkage.h
 create mode 100644 arch/unicore32/kernel/Makefile
 create mode 100644 arch/unicore32/kernel/vmlinux.lds.S

diff --git a/arch/unicore32/.gitignore b/arch/unicore32/.gitignore
new file mode 100644
index 0000000..947e99c
--- /dev/null
+++ b/arch/unicore32/.gitignore
@@ -0,0 +1,21 @@
+#
+# Generated include files
+#
+include/generated
+#
+# Generated ld script file
+#
+kernel/vmlinux.lds
+#
+# Generated images in boot
+#
+boot/Image
+boot/zImage
+boot/uImage
+#
+# Generated files in boot/compressed
+#
+boot/compressed/piggy.S
+boot/compressed/piggy.gzip
+boot/compressed/vmlinux
+boot/compressed/vmlinux.lds
diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
new file mode 100644
index 0000000..c0624e9
--- /dev/null
+++ b/arch/unicore32/Kconfig
@@ -0,0 +1,248 @@
+config UNICORE32
+	def_bool y
+	select HAVE_MEMBLOCK
+	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_GENERIC_HARDIRQS
+	select HAVE_DMA_ATTRS
+	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_BZIP2
+	select HAVE_KERNEL_LZO
+	select HAVE_KERNEL_LZMA
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_IRQ_PROBE
+	select ARCH_WANT_FRAME_POINTERS
+	help
+	  UniCore-32 is 32-bit Instruction Set Architecture,
+	  including a series of low-power-consumption RISC chip
+	  designs licensed by PKUnity Ltd.
+	  Please see web page at <http://www.pkunity.com/>.
+
+config HAVE_PWM
+	bool
+
+config GENERIC_GPIO
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	bool
+
+config GENERIC_CSUM
+	def_bool y
+
+config NO_IOPORT
+	bool
+
+config STACKTRACE_SUPPORT
+	def_bool y
+
+config HAVE_LATENCYTOP_SUPPORT
+	def_bool y
+
+config LOCKDEP_SUPPORT
+	def_bool y
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config RWSEM_XCHGADD_ALGORITHM
+	bool
+
+config ARCH_HAS_ILOG2_U32
+	bool
+
+config ARCH_HAS_ILOG2_U64
+	bool
+
+config ARCH_HAS_CPUFREQ
+	bool
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+
+config NEED_DMA_MAP_STATE
+       def_bool y
+
+source "init/Kconfig"
+
+source "kernel/Kconfig.freezer"
+
+menu "System Type"
+
+config MMU
+	def_bool y
+
+config ARCH_FPGA
+	bool
+
+config ARCH_PUV3
+	def_bool y
+	select CPU_UCV2
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CLK
+	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_HAS_CPUFREQ
+
+# CONFIGs for ARCH_PUV3
+
+if ARCH_PUV3
+
+choice
+	prompt "Board Selection"
+	default PUV3_DB0913
+
+config PUV3_FPGA_DLX200
+	select ARCH_FPGA
+	bool "FPGA board"
+
+config PUV3_DB0913
+	bool "DEBUG board (0913)"
+
+config PUV3_NB0916
+	bool "NetBook board (0916)"
+	select HAVE_PWM
+
+config PUV3_SMW0919
+	bool "Security Mini-Workstation board (0919)"
+
+endchoice
+
+config PUV3_PM
+	def_bool y if !ARCH_FPGA
+
+endif
+
+source "arch/unicore32/mm/Kconfig"
+
+comment "Floating poing support"
+
+config UNICORE_FPU_F64
+	def_bool y if !ARCH_FPGA
+
+endmenu
+
+menu "Bus support"
+
+config PCI
+	bool "PCI Support"
+	help
+	  Find out whether you have a PCI motherboard. PCI is the name of a
+	  bus system, i.e. the way the CPU talks to the other stuff inside
+	  your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
+	  VESA. If you have PCI, say Y, otherwise N.
+
+source "drivers/pci/Kconfig"
+
+source "drivers/pcmcia/Kconfig"
+
+endmenu
+
+menu "Kernel Features"
+
+source "kernel/time/Kconfig"
+
+source "kernel/Kconfig.preempt"
+
+source "kernel/Kconfig.hz"
+
+source "mm/Kconfig"
+
+config LEDS
+	def_bool y
+	depends on GENERIC_GPIO
+
+config ALIGNMENT_TRAP
+	def_bool y
+	help
+	  Unicore processors can not fetch/store information which is not
+	  naturally aligned on the bus, i.e., a 4 byte fetch must start at an
+	  address divisible by 4. On 32-bit Unicore processors, these non-aligned
+	  fetch/store instructions will be emulated in software if you say
+	  here, which has a severe performance impact. This is necessary for
+	  correct operation of some network protocols. With an IP-only
+	  configuration it is safe to say N, otherwise say Y.
+
+endmenu
+
+menu "Boot options"
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+
+config CMDLINE_FORCE
+	bool "Always use the default kernel command string"
+	depends on CMDLINE != ""
+	help
+	  Always use the default kernel command string, even if the boot
+	  loader passes other arguments to the kernel.
+	  This is useful if you cannot or don't want to change the
+	  command-line options your boot loader passes to the kernel.
+
+	  If unsure, say N.
+
+endmenu
+
+menu "Userspace binary formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+menu "Power management options"
+
+source "kernel/power/Kconfig"
+
+if ARCH_HAS_CPUFREQ
+source "drivers/cpufreq/Kconfig"
+endif
+
+config ARCH_SUSPEND_POSSIBLE
+	def_bool y if !ARCH_FPGA
+
+config ARCH_HIBERNATION_POSSIBLE
+	def_bool y if !ARCH_FPGA
+
+endmenu
+
+source "net/Kconfig"
+
+if ARCH_PUV3
+
+config PUV3_GPIO
+	bool
+	depends on !ARCH_FPGA
+	select GENERIC_GPIO
+	select GPIO_SYSFS if EXPERIMENTAL
+	default y
+
+config PUV3_PWM
+	tristate
+	default BACKLIGHT_PWM
+	help
+	  Enable support for NB0916 PWM controllers
+
+config PUV3_RTC
+	tristate "PKUnity v3 RTC Support"
+	depends on !ARCH_FPGA
+
+source "arch/unicore32/Kconfig.puv3"
+
+endif
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "arch/unicore32/Kconfig.debug"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
new file mode 100644
index 0000000..3140151
--- /dev/null
+++ b/arch/unicore32/Kconfig.debug
@@ -0,0 +1,68 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config STRICT_DEVMEM
+	bool "Filter access to /dev/mem"
+	depends on MMU
+	---help---
+	  If this option is disabled, you allow userspace (root) access to all
+	  of memory, including kernel and userspace memory. Accidental
+	  access to this is obviously disastrous, but specific access can
+	  be used by people debugging the kernel.
+
+	  If this option is switched on, the /dev/mem file only allows
+	  userspace access to memory mapped peripherals.
+
+          If in doubt, say Y.
+
+config EARLY_PRINTK
+	def_bool DEBUG_OCD
+	help
+	  Write kernel log output directly into the ocd or to a serial port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash.
+
+config DEBUG_STACK_USAGE
+	bool "Enable stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T output.
+
+# These options are only for real kernel hackers who want to get their hands dirty.
+config DEBUG_LL
+	bool "Kernel low-level debugging functions"
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here to include definitions of printascii, printch, printhex
+	  in the kernel.  This is helpful if you are debugging code that
+	  executes before the console is initialized.
+
+config DEBUG_OCD
+	bool "Kernel low-level debugging via On-Chip-Debugger"
+	depends on DEBUG_LL
+	default y
+	help
+	  Say Y here if you want the debug print routines to direct their
+	  output to the UniCore On-Chip-Debugger channel using CP #1.
+
+config DEBUG_OCD_BREAKPOINT
+	bool "Breakpoint support via On-Chip-Debugger"
+	depends on DEBUG_OCD
+
+config DEBUG_UART
+	int "Kernel low-level debugging messages via serial port"
+	depends on DEBUG_LL
+	range 0 1
+	default "0"
+	help
+	  Choice for UART for kernel low-level using PKUnity UARTS,
+	  should be between zero and one. The port must have been
+	  initialised by the boot-loader before use.
+
+endmenu
diff --git a/arch/unicore32/Makefile b/arch/unicore32/Makefile
new file mode 100644
index 0000000..204cd68
--- /dev/null
+++ b/arch/unicore32/Makefile
@@ -0,0 +1,97 @@
+#
+# arch/unicore32/Makefile
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies.
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 2002~2010 by Guan Xue-tao
+#
+ifneq ($(SUBARCH),$(ARCH))
+	ifeq ($(CROSS_COMPILE),)
+		CROSS_COMPILE := $(call cc-cross-prefix, unicore32-linux-)
+	endif
+endif
+
+LDFLAGS_vmlinux		:= -p --no-undefined -X
+
+OBJCOPYFLAGS		:= -O binary -R .note -R .note.gnu.build-id -R .comment -S
+
+# Never generate .eh_frame
+KBUILD_CFLAGS		+= $(call cc-option,-fno-dwarf2-cfi-asm)
+
+# Never use hard float in kernel
+KBUILD_CFLAGS		+= -msoft-float
+
+ifeq ($(CONFIG_FRAME_POINTER),y)
+KBUILD_CFLAGS		+= -mno-sched-prolog
+endif
+
+CHECKFLAGS		+= -D__unicore32__
+
+head-y			:= arch/unicore32/kernel/head.o
+head-y			+= arch/unicore32/kernel/init_task.o
+
+core-y				+= arch/unicore32/kernel/
+core-y				+= arch/unicore32/mm/
+
+#drivers-$(CONFIG_ARCH_PUV3)	+= drivers/staging/puv3/
+
+libs-y				+= arch/unicore32/lib/
+
+ASM_GENERATED_DIR	:= $(srctree)/arch/unicore32/include/generated
+LINUXINCLUDE		+= -I$(ASM_GENERATED_DIR)
+
+ASM_GENERIC_HEADERS	:= atomic.h auxvec.h
+ASM_GENERIC_HEADERS	+= bitsperlong.h bug.h bugs.h
+ASM_GENERIC_HEADERS	+= cputime.h current.h
+ASM_GENERIC_HEADERS	+= device.h div64.h
+ASM_GENERIC_HEADERS	+= emergency-restart.h errno.h
+ASM_GENERIC_HEADERS	+= fb.h fcntl.h ftrace.h
+ASM_GENERIC_HEADERS	+= hardirq.h hw_irq.h
+ASM_GENERIC_HEADERS	+= ioctl.h ioctls.h ipcbuf.h irq_regs.h
+ASM_GENERIC_HEADERS	+= kdebug.h kmap_types.h
+ASM_GENERIC_HEADERS	+= local.h
+ASM_GENERIC_HEADERS	+= mman.h module.h msgbuf.h
+ASM_GENERIC_HEADERS	+= param.h parport.h percpu.h poll.h posix_types.h
+ASM_GENERIC_HEADERS	+= resource.h
+ASM_GENERIC_HEADERS	+= scatterlist.h sections.h segment.h sembuf.h serial.h
+ASM_GENERIC_HEADERS	+= setup.h shmbuf.h shmparam.h
+ASM_GENERIC_HEADERS	+= siginfo.h signal.h sizes.h
+ASM_GENERIC_HEADERS	+= socket.h sockios.h stat.h statfs.h swab.h syscalls.h
+ASM_GENERIC_HEADERS	+= termbits.h termios.h topology.h types.h
+ASM_GENERIC_HEADERS	+= ucontext.h unaligned.h user.h
+ASM_GENERIC_HEADERS	+= vga.h
+ASM_GENERIC_HEADERS	+= xor.h
+
+archprepare:
+ifneq ($(ASM_GENERATED_DIR), $(wildcard $(ASM_GENERATED_DIR)))
+	$(Q)mkdir -p $(ASM_GENERATED_DIR)/asm
+	$(Q)$(foreach a, $(ASM_GENERIC_HEADERS),	\
+		echo '#include <asm-generic/$a>'	\
+			> $(ASM_GENERATED_DIR)/asm/$a; )
+endif
+
+boot			:= arch/unicore32/boot
+
+# Default target when executing plain make
+KBUILD_IMAGE		:= zImage
+
+all:	$(KBUILD_IMAGE)
+
+zImage Image uImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+MRPROPER_DIRS		+= $(ASM_GENERATED_DIR)
+
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+define archhelp
+  echo  '* zImage        - Compressed kernel image (arch/$(ARCH)/boot/zImage)'
+  echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
+  echo  '  uImage        - U-Boot wrapped zImage'
+endef
diff --git a/arch/unicore32/configs/debug_defconfig b/arch/unicore32/configs/debug_defconfig
new file mode 100644
index 0000000..3647f68
--- /dev/null
+++ b/arch/unicore32/configs/debug_defconfig
@@ -0,0 +1,210 @@
+### General setup
+CONFIG_EXPERIMENTAL=y
+CONFIG_LOCALVERSION="-debug"
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_HOTPLUG=y
+#	Initial RAM filesystem and RAM disk (initramfs/initrd) support
+#CONFIG_BLK_DEV_INITRD=y
+#CONFIG_INITRAMFS_SOURCE="arch/unicore/ramfs/ramfs_config"
+
+### Enable loadable module support
+CONFIG_MODULES=n
+CONFIG_MODULE_UNLOAD=y
+
+### System Type
+CONFIG_ARCH_PUV3=y
+#	Board Selection
+CONFIG_PUV3_NB0916=y
+#	Processor Features
+CONFIG_CPU_DCACHE_LINE_DISABLE=y
+CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE=n
+
+### Bus support
+CONFIG_PCI=y
+CONFIG_PCI_LEGACY=n
+
+### Boot options
+#	for debug, adding: earlyprintk=ocd,keep initcall_debug
+#	others support: test_suspend=mem root=/dev/sda
+#	hibernate support: resume=/dev/sda3
+CONFIG_CMDLINE="earlyprintk=ocd,keep ignore_loglevel"
+# TODO: mem=512M video=unifb:1024x600-16@75
+# for nfs: root=/dev/nfs rw nfsroot=192.168.10.88:/home/udb/nfs/,rsize=1024,wsize=1024
+#	ip=192.168.10.83:192.168.10.88:192.168.10.1:255.255.255.0::eth0:off
+CONFIG_CMDLINE_FORCE=y
+
+### Power management options
+CONFIG_PM=y
+CONFIG_HIBERNATION=y
+CONFIG_PM_STD_PARTITION="/dev/sda3"
+CONFIG_CPU_FREQ=n
+CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
+
+### Networking support
+CONFIG_NET=y
+#	Networking options
+CONFIG_PACKET=m
+CONFIG_UNIX=m
+#	TCP/IP networking
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IPV6=n
+#	Wireless
+CONFIG_WIRELESS=y
+CONFIG_WIRELESS_EXT=y
+CONFIG_MAC80211=m
+
+### PKUnity SoC Features
+CONFIG_USB_WLAN_HED_AQ3=n
+CONFIG_USB_CMMB_INNOFIDEI=n
+CONFIG_I2C_BATTERY_BQ27200=n
+CONFIG_I2C_EEPROM_AT24=n
+CONFIG_LCD_BACKLIGHT=n
+
+CONFIG_PUV3_RTC=y
+CONFIG_PUV3_UMAL=y
+CONFIG_PUV3_UNIGFX=y
+CONFIG_PUV3_MUSB=n
+CONFIG_PUV3_AC97=n
+CONFIG_PUV3_NAND=n
+CONFIG_PUV3_MMC=n
+CONFIG_PUV3_UART=n
+
+### Device Drivers
+#	Memory Technology Device (MTD) support
+CONFIG_MTD=m
+CONFIG_MTD_UBI=m
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=m
+#	RAM/ROM/Flash chip drivers
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_CFI_AMDSTD=m
+#	Mapping drivers for chip access
+CONFIG_MTD_PHYSMAP=m
+
+#	Block devices
+CONFIG_BLK_DEV_LOOP=m
+
+#	SCSI device support
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_BLK_DEV_SR=m
+CONFIG_CHR_DEV_SG=m
+
+#	Serial ATA (prod) and Parallel ATA (experimental) drivers
+CONFIG_ATA=y
+CONFIG_SATA_VIA=y
+
+#	Network device support
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_NETDEV_1000=y
+#	Wireless LAN
+CONFIG_WLAN_80211=n
+CONFIG_RT2X00=n
+CONFIG_RT73USB=n
+
+#	Input device support
+CONFIG_INPUT_EVDEV=m
+#	Keyboards
+CONFIG_KEYBOARD_GPIO=m
+
+#	Hardware Monitoring support
+#CONFIG_SENSORS_LM75=m
+#	Generic Thermal sysfs driver
+#CONFIG_THERMAL=m
+#CONFIG_THERMAL_HWMON=y
+
+#	Multimedia support
+CONFIG_MEDIA_SUPPORT=n
+CONFIG_VIDEO_DEV=n
+CONFIG_USB_VIDEO_CLASS=n
+
+#	Graphics support
+#	Console display driver support
+CONFIG_VGA_CONSOLE=n
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+#	Bootup logo
+CONFIG_LOGO=n
+
+#	Sound card support
+CONFIG_SOUND=m
+#	Advanced Linux Sound Architecture
+CONFIG_SND=m
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+
+#	USB support
+CONFIG_USB_ARCH_HAS_HCD=n
+CONFIG_USB=n
+CONFIG_USB_DEVICEFS=n
+CONFIG_USB_PRINTER=n
+CONFIG_USB_STORAGE=n
+#	Inventra Highspeed Dual Role Controller
+CONFIG_USB_MUSB_HDRC=n
+
+#	LED Support
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+#	LED Triggers
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_IDE_DISK=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+
+#	Real Time Clock
+CONFIG_RTC_LIB=m
+CONFIG_RTC_CLASS=m
+
+### File systems
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=m
+#	CD-ROM/DVD Filesystems
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+CONFIG_UDF_FS=m
+#	DOS/FAT/NT Filesystems
+CONFIG_VFAT_FS=m
+#	Pseudo filesystems
+CONFIG_PROC_FS=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+#	Miscellaneous filesystems
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_JFFS2_FS=m
+CONFIG_UBIFS_FS=m
+#	Network File Systems
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_ROOT_NFS=y
+#	Partition Types
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_MSDOS_PARTITION=y
+#	Native language support
+CONFIG_NLS=y
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_UTF8=m
+
+### Kernel hacking
+CONFIG_FRAME_WARN=8096
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PROVE_LOCKING=n
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_FRAME_POINTER=y
+CONFIG_DEBUG_LL=y
+
diff --git a/arch/unicore32/configs/nb0916_defconfig b/arch/unicore32/configs/nb0916_defconfig
new file mode 100644
index 0000000..5cec53d
--- /dev/null
+++ b/arch/unicore32/configs/nb0916_defconfig
@@ -0,0 +1,202 @@
+### General setup
+CONFIG_EXPERIMENTAL=y
+CONFIG_LOCALVERSION="-nb0916"
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_HOTPLUG=y
+#	Initial RAM filesystem and RAM disk (initramfs/initrd) support
+#CONFIG_BLK_DEV_INITRD=y
+#CONFIG_INITRAMFS_SOURCE="arch/unicore/ramfs/ramfs_config"
+
+### Enable loadable module support
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+
+### System Type
+CONFIG_ARCH_PUV3=y
+#	Board Selection
+CONFIG_PUV3_NB0916=y
+#	Processor Features
+CONFIG_CPU_DCACHE_LINE_DISABLE=y
+CONFIG_CPU_TLB_SINGLE_ENTRY_DISABLE=n
+
+### Bus support
+CONFIG_PCI=y
+CONFIG_PCI_LEGACY=n
+
+### Boot options
+#	for debug, adding: earlyprintk=ocd,keep initcall_debug
+#	others support: test_suspend=mem root=/dev/sda
+#	hibernate support: resume=/dev/sda3
+CONFIG_CMDLINE=""
+# CONFIG_CMDLINE_FORCE is not set
+
+### Power management options
+CONFIG_PM=y
+CONFIG_HIBERNATION=y
+CONFIG_PM_STD_PARTITION="/dev/sda3"
+CONFIG_CPU_FREQ=n
+CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
+
+### Networking support
+CONFIG_NET=y
+#	Networking options
+CONFIG_PACKET=m
+CONFIG_UNIX=m
+#	TCP/IP networking
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_PNP=y
+CONFIG_IPV6=n
+#	Wireless
+CONFIG_WIRELESS=y
+CONFIG_WIRELESS_EXT=y
+CONFIG_MAC80211=m
+
+### PKUnity SoC Features
+CONFIG_USB_WLAN_HED_AQ3=n
+CONFIG_USB_CMMB_INNOFIDEI=n
+CONFIG_I2C_BATTERY_BQ27200=m
+CONFIG_I2C_EEPROM_AT24=m
+CONFIG_LCD_BACKLIGHT=m
+
+CONFIG_PUV3_RTC=m
+CONFIG_PUV3_UMAL=m
+CONFIG_PUV3_UNIGFX=y
+CONFIG_PUV3_MUSB=n
+CONFIG_PUV3_AC97=n
+CONFIG_PUV3_NAND=n
+CONFIG_PUV3_MMC=n
+CONFIG_PUV3_UART=n
+
+### Device Drivers
+#	Memory Technology Device (MTD) support
+CONFIG_MTD=m
+CONFIG_MTD_UBI=m
+CONFIG_MTD_PARTITIONS=y
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=m
+#	RAM/ROM/Flash chip drivers
+CONFIG_MTD_CFI=m
+CONFIG_MTD_JEDECPROBE=m
+CONFIG_MTD_CFI_AMDSTD=m
+#	Mapping drivers for chip access
+CONFIG_MTD_PHYSMAP=m
+
+#	Block devices
+CONFIG_BLK_DEV_LOOP=m
+
+#	SCSI device support
+CONFIG_SCSI=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_BLK_DEV_SR=m
+CONFIG_CHR_DEV_SG=m
+
+#	Serial ATA (prod) and Parallel ATA (experimental) drivers
+CONFIG_ATA=y
+CONFIG_SATA_VIA=y
+
+#	Network device support
+CONFIG_NETDEVICES=y
+CONFIG_NET_ETHERNET=y
+CONFIG_NETDEV_1000=y
+#	Wireless LAN
+CONFIG_WLAN_80211=y
+CONFIG_RT2X00=m
+CONFIG_RT73USB=n
+
+#	Input device support
+CONFIG_INPUT_EVDEV=m
+#	Keyboards
+CONFIG_KEYBOARD_GPIO=m
+
+#	Hardware Monitoring support
+#CONFIG_SENSORS_LM75=m
+#	Generic Thermal sysfs driver
+#CONFIG_THERMAL=m
+#CONFIG_THERMAL_HWMON=y
+
+#	Multimedia support
+CONFIG_MEDIA_SUPPORT=m
+CONFIG_VIDEO_DEV=m
+CONFIG_USB_VIDEO_CLASS=m
+
+#	Graphics support
+#	Console display driver support
+CONFIG_VGA_CONSOLE=n
+CONFIG_FRAMEBUFFER_CONSOLE=y
+CONFIG_FONTS=y
+CONFIG_FONT_8x8=y
+CONFIG_FONT_8x16=y
+#	Bootup logo
+CONFIG_LOGO=n
+
+#	Sound card support
+CONFIG_SOUND=m
+#	Advanced Linux Sound Architecture
+CONFIG_SND=m
+CONFIG_SND_MIXER_OSS=m
+CONFIG_SND_PCM_OSS=m
+
+#	USB support
+CONFIG_USB_ARCH_HAS_HCD=y
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_PRINTER=m
+CONFIG_USB_STORAGE=m
+#	Inventra Highspeed Dual Role Controller
+CONFIG_USB_MUSB_HDRC=m
+
+#	LED Support
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_LEDS_GPIO=y
+#	LED Triggers
+CONFIG_LEDS_TRIGGERS=y
+CONFIG_LEDS_TRIGGER_TIMER=y
+CONFIG_LEDS_TRIGGER_IDE_DISK=y
+CONFIG_LEDS_TRIGGER_HEARTBEAT=y
+
+#	Real Time Clock
+CONFIG_RTC_LIB=m
+CONFIG_RTC_CLASS=m
+
+### File systems
+CONFIG_EXT2_FS=m
+CONFIG_EXT3_FS=y
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=m
+#	CD-ROM/DVD Filesystems
+CONFIG_ISO9660_FS=m
+CONFIG_JOLIET=y
+CONFIG_UDF_FS=m
+#	DOS/FAT/NT Filesystems
+CONFIG_VFAT_FS=m
+#	Pseudo filesystems
+CONFIG_PROC_FS=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+#	Miscellaneous filesystems
+CONFIG_MISC_FILESYSTEMS=y
+CONFIG_JFFS2_FS=m
+CONFIG_UBIFS_FS=m
+#	Network File Systems
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_ROOT_NFS=y
+#	Partition Types
+CONFIG_PARTITION_ADVANCED=y
+CONFIG_MSDOS_PARTITION=y
+#	Native language support
+CONFIG_NLS=y
+CONFIG_NLS_CODEPAGE_437=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_ISO8859_1=m
+CONFIG_NLS_UTF8=m
+
+### Kernel hacking
+CONFIG_FRAME_WARN=8096
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_DEBUG_KERNEL=n
+
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
new file mode 100644
index 0000000..b200fda
--- /dev/null
+++ b/arch/unicore32/include/asm/Kbuild
@@ -0,0 +1,2 @@
+include include/asm-generic/Kbuild.asm
+
diff --git a/arch/unicore32/include/asm/linkage.h b/arch/unicore32/include/asm/linkage.h
new file mode 100644
index 0000000..d1618bd
--- /dev/null
+++ b/arch/unicore32/include/asm/linkage.h
@@ -0,0 +1,22 @@
+/*
+ * linux/arch/unicore32/include/asm/linkage.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_LINKAGE_H__
+#define __UNICORE_LINKAGE_H__
+
+#define __ALIGN .align 0
+#define __ALIGN_STR ".align 0"
+
+#define ENDPROC(name) \
+	.type name, %function; \
+	END(name)
+
+#endif
diff --git a/arch/unicore32/kernel/Makefile b/arch/unicore32/kernel/Makefile
new file mode 100644
index 0000000..b3bf9a9
--- /dev/null
+++ b/arch/unicore32/kernel/Makefile
@@ -0,0 +1,34 @@
+#
+# Makefile for the linux kernel.
+#
+
+# Object file lists.
+obj-y				:= dma.o elf.o entry.o process.o ptrace.o
+obj-y				+= setup.o signal.o sys.o stacktrace.o traps.o
+
+obj-$(CONFIG_MODULES)		+= ksyms.o module.o
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+
+obj-$(CONFIG_CPU_FREQ)		+= cpu-ucv2.o
+obj-$(CONFIG_UNICORE_FPU_F64)	+= fpu-ucf64.o
+
+# obj-y for architecture PKUnity v3
+obj-$(CONFIG_ARCH_PUV3)		+= clock.o irq.o time.o
+
+obj-$(CONFIG_PUV3_GPIO)		+= gpio.o
+obj-$(CONFIG_PUV3_RTC)		+= rtc.o
+obj-$(CONFIG_PUV3_PWM)		+= pwm.o
+obj-$(CONFIG_PUV3_PM)		+= pm.o sleep.o
+obj-$(CONFIG_HIBERNATION)	+= hibernate.o hibernate_asm.o
+
+obj-$(CONFIG_PCI)		+= pci.o
+
+# obj-y for specific machines
+obj-$(CONFIG_ARCH_PUV3)		+= puv3-core.o
+obj-$(CONFIG_PUV3_NB0916)	+= puv3-nb0916.o
+obj-$(CONFIG_PUV3_SMW0919)	+= puv3-smw0919.o
+
+head-y				:= head.o
+obj-$(CONFIG_DEBUG_LL)		+= debug.o
+
+extra-y				:= $(head-y) init_task.o vmlinux.lds
diff --git a/arch/unicore32/kernel/vmlinux.lds.S b/arch/unicore32/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..0b4eb89
--- /dev/null
+++ b/arch/unicore32/kernel/vmlinux.lds.S
@@ -0,0 +1,61 @@
+/*
+ * linux/arch/unicore32/kernel/vmlinux.lds.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+#include <asm/page.h>
+
+OUTPUT_ARCH(unicore32)
+ENTRY(stext)
+
+jiffies = jiffies_64;
+
+SECTIONS
+{
+	. = PAGE_OFFSET + KERNEL_IMAGE_START;
+
+	_text = .;
+	__init_begin = .;
+	HEAD_TEXT_SECTION
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	INIT_DATA_SECTION(16)
+	PERCPU(PAGE_SIZE)
+	__init_end = .;
+
+	_stext = .;
+	.text : {		/* Real text segment */
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+
+		*(.fixup)
+		*(.gnu.warning)
+	}
+	_etext = .;
+
+	_sdata = .;
+	RO_DATA_SECTION(PAGE_SIZE)
+	RW_DATA_SECTION(32, PAGE_SIZE, THREAD_SIZE)
+	_edata = .;
+
+	EXCEPTION_TABLE(32)
+	NOTES
+
+	BSS_SECTION(0, 0, 0)
+	_end = .;
+
+	STABS_DEBUG
+	DWARF_DEBUG
+
+	DISCARDS		/* Exit code and data */
+}
-- 
1.7.0.4



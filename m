Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000Ab2B1KXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:23:01 -0500
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:39540 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964968Ab2B1KWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:22:55 -0500
From: Martyn Welch <martyn.welch@ge.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        Martyn Welch <martyn.welch@ge.com>
Subject: [PATCH V2 2/2] powerpc: Board support for GE IMP3A
Date: Tue, 28 Feb 2012 10:22:21 +0000
Message-Id: <1330424541-5299-3-git-send-email-martyn.welch@ge.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330424541-5299-1-git-send-email-martyn.welch@ge.com>
References: <1330424541-5299-1-git-send-email-martyn.welch@ge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initial board support for the GE IMP3A, a 3U compactPCI card with a p2020
processor.

Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

v2: Rebase patch onto powerpc/next, taking work by Kyle Moffett into
    account.

 arch/powerpc/boot/dts/ge_imp3a.dts      |  254 ++++++++++++++++++++++++++++++
 arch/powerpc/configs/ge_imp3a_defconfig |  256 +++++++++++++++++++++++++++++++
 arch/powerpc/platforms/85xx/Kconfig     |   15 ++
 arch/powerpc/platforms/85xx/Makefile    |    1 +
 arch/powerpc/platforms/85xx/ge_imp3a.c  |  246 +++++++++++++++++++++++++++++
 arch/powerpc/sysdev/ge/ge_gpio.c        |   28 ++++
 6 files changed, 800 insertions(+), 0 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/ge_imp3a.dts
 create mode 100644 arch/powerpc/configs/ge_imp3a_defconfig
 create mode 100644 arch/powerpc/platforms/85xx/ge_imp3a.c

diff --git a/arch/powerpc/boot/dts/ge_imp3a.dts b/arch/powerpc/boot/dts/ge_imp3a.dts
new file mode 100644
index 0000000..f30fadb
--- /dev/null
+++ b/arch/powerpc/boot/dts/ge_imp3a.dts
@@ -0,0 +1,254 @@
+/*
+ * GE IMP3A Device Tree Source
+ *
+ * Copyright 2010-2011 GE Intelligent Platforms Embedded Systems, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * Based on: P2020 DS Device Tree Source
+ * Copyright 2009 Freescale Semiconductor Inc.
+ */
+
+/include/ "fsl/p2020si-pre.dtsi"
+
+/ {
+	model = "GE_IMP3A";
+	compatible = "ge,imp3a";
+
+	memory {
+		device_type = "memory";
+	};
+
+	lbc: localbus@fef05000 {
+		reg = <0 0xfef05000 0 0x1000>;
+
+		ranges = <0x0 0x0 0x0 0xff000000 0x01000000
+			  0x1 0x0 0x0 0xe0000000 0x08000000
+			  0x2 0x0 0x0 0xe8000000 0x08000000
+			  0x3 0x0 0x0 0xfc100000 0x00020000
+			  0x4 0x0 0x0 0xfc000000 0x00008000
+			  0x5 0x0 0x0 0xfc008000 0x00008000
+			  0x6 0x0 0x0 0xfee00000 0x00040000
+			  0x7 0x0 0x0 0xfee80000 0x00040000>;
+
+		/* nor@0,0 is a mirror of part of the memory in nor@1,0
+		nor@0,0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "ge,imp3a-firmware-mirror", "cfi-flash";
+			reg = <0x0 0x0 0x1000000>;
+			bank-width = <2>;
+			device-width = <1>;
+
+			partition@0 {
+				label = "firmware";
+				reg = <0x0 0x1000000>;
+				read-only;
+			};
+		};
+		*/
+
+		nor@1,0 {
+			#address-cells = <1>;
+			#size-cells = <1>;
+			compatible = "ge,imp3a-paged-flash", "cfi-flash";
+			reg = <0x1 0x0 0x8000000>;
+			bank-width = <2>;
+			device-width = <1>;
+
+			partition@0 {
+				label = "user";
+				reg = <0x0 0x7800000>;
+			};
+
+			partition@7800000 {
+				label = "firmware";
+				reg = <0x7800000 0x800000>;
+				read-only;
+			};
+		};
+
+		nvram@3,0 {
+			device_type = "nvram";
+			compatible = "simtek,stk14ca8";
+			reg = <0x3 0x0 0x20000>;
+		};
+
+		fpga@4,0 {
+			compatible = "ge,imp3a-fpga-regs";
+			reg = <0x4 0x0 0x20>;
+		};
+
+		gef_pic: pic@4,20 {
+			#interrupt-cells = <1>;
+			interrupt-controller;
+			compatible = "ge,imp3a-fpga-pic", "gef,fpga-pic-1.00";
+			reg = <0x4 0x20 0x20>;
+			interrupts = <6 7 0 0>;
+		};
+
+		gef_gpio: gpio@4,400 {
+			#gpio-cells = <2>;
+			compatible = "ge,imp3a-gpio";
+			reg = <0x4 0x400 0x24>;
+			gpio-controller;
+		};
+
+		wdt@4,800 {
+			compatible = "ge,imp3a-fpga-wdt", "gef,fpga-wdt-1.00",
+				"gef,fpga-wdt";
+			reg = <0x4 0x800 0x8>;
+			interrupts = <10 4>;
+			interrupt-parent = <&gef_pic>;
+		};
+
+		/* Second watchdog available, driver currently supports one.
+		wdt@4,808 {
+			compatible = "gef,imp3a-fpga-wdt", "gef,fpga-wdt-1.00",
+				"gef,fpga-wdt";
+			reg = <0x4 0x808 0x8>;
+			interrupts = <9 4>;
+			interrupt-parent = <&gef_pic>;
+		};
+		*/
+
+		nand@6,0 {
+			compatible = "fsl,elbc-fcm-nand";
+			reg = <0x6 0x0 0x40000>;
+		};
+
+		nand@7,0 {
+			compatible = "fsl,elbc-fcm-nand";
+			reg = <0x7 0x0 0x40000>;
+		};
+	};
+
+	soc: soc@fef00000 {
+		ranges = <0x0 0 0xfef00000 0x100000>;
+
+		i2c@3000 {
+			hwmon@48 {
+				compatible = "national,lm92";
+				reg = <0x48>;
+			};
+
+			hwmon@4c {
+				compatible = "adi,adt7461";
+				reg = <0x4c>;
+			};
+
+			rtc@51 {
+				compatible = "epson,rx8581";
+				reg = <0x51>;
+			};
+
+			eti@6b {
+				compatible = "dallas,ds1682";
+				reg = <0x6b>;
+			};
+		};
+
+		usb@22000 {
+			phy_type = "ulpi";
+			dr_mode = "host";
+		};
+
+		mdio@24520 {
+			phy0: ethernet-phy@0 {
+				interrupt-parent = <&gef_pic>;
+				interrupts = <0xc 0x4>;
+				reg = <0x1>;
+			};
+			phy1: ethernet-phy@1 {
+				interrupt-parent = <&gef_pic>;
+				interrupts = <0xb 0x4>;
+				reg = <0x2>;
+			};
+			tbi0: tbi-phy@11 {
+				reg = <0x11>;
+				device_type = "tbi-phy";
+			};
+		};
+
+		mdio@25520 {
+			tbi1: tbi-phy@11 {
+				reg = <0x11>;
+				device_type = "tbi-phy";
+			};
+		};
+
+		mdio@26520 {
+			status = "disabled";
+		};
+
+		enet0: ethernet@24000 {
+			tbi-handle = <&tbi0>;
+			phy-handle = <&phy0>;
+			phy-connection-type = "gmii";
+		};
+
+		enet1: ethernet@25000 {
+			tbi-handle = <&tbi1>;
+			phy-handle = <&phy1>;
+			phy-connection-type = "gmii";
+		};
+
+		enet2: ethernet@26000 {
+			status = "disabled";
+		};
+	};
+
+	pci0: pcie@fef08000 {
+		ranges = <0x2000000 0x0 0xc0000000 0 0xc0000000 0x0 0x20000000
+			  0x1000000 0x0 0x00000000 0 0xfe020000 0x0 0x10000>;
+		reg = <0 0xfef08000 0 0x1000>;
+
+		pcie@0 {
+			ranges = <0x2000000 0x0 0xc0000000
+				  0x2000000 0x0 0xc0000000
+				  0x0 0x20000000
+
+				  0x1000000 0x0 0x0
+				  0x1000000 0x0 0x0
+				  0x0 0x10000>;
+		};
+	};
+
+	pci1: pcie@fef09000 {
+		reg = <0 0xfef09000 0 0x1000>;
+		ranges = <0x2000000 0x0 0xa0000000 0 0xa0000000 0x0 0x20000000
+			  0x1000000 0x0 0x00000000 0 0xfe010000 0x0 0x10000>;
+
+		pcie@0 {
+			ranges = <0x2000000 0x0 0xa0000000
+				  0x2000000 0x0 0xa0000000
+				  0x0 0x20000000
+
+				  0x1000000 0x0 0x0
+				  0x1000000 0x0 0x0
+				  0x0 0x10000>;
+		};
+
+	};
+
+	pci2: pcie@fef0a000 {
+		reg = <0 0xfef0a000 0 0x1000>;
+		ranges = <0x2000000 0x0 0x80000000 0 0x80000000 0x0 0x20000000
+			  0x1000000 0x0 0x00000000 0 0xfe000000 0x0 0x10000>;
+
+		pcie@0 {
+			ranges = <0x2000000 0x0 0x80000000
+				  0x2000000 0x0 0x80000000
+				  0x0 0x20000000
+
+				  0x1000000 0x0 0x0
+				  0x1000000 0x0 0x0
+				  0x0 0x10000>;
+		};
+	};
+};
+
+/include/ "fsl/p2020si-post.dtsi"
diff --git a/arch/powerpc/configs/ge_imp3a_defconfig b/arch/powerpc/configs/ge_imp3a_defconfig
new file mode 100644
index 0000000..ca4c5cb
--- /dev/null
+++ b/arch/powerpc/configs/ge_imp3a_defconfig
@@ -0,0 +1,256 @@
+CONFIG_PPC_85xx=y
+CONFIG_SMP=y
+CONFIG_NR_CPUS=2
+CONFIG_EXPERIMENTAL=y
+CONFIG_SYSVIPC=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_BSD_PROCESS_ACCT=y
+CONFIG_BSD_PROCESS_ACCT_V3=y
+CONFIG_SPARSE_IRQ=y
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+# CONFIG_UTS_NS is not set
+# CONFIG_IPC_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_NET_NS is not set
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+CONFIG_RELAY=y
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_PERF_EVENTS=y
+CONFIG_SLAB=y
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_BLK_DEV_BSG is not set
+CONFIG_GE_IMP3A=y
+CONFIG_QUICC_ENGINE=y
+CONFIG_QE_GPIO=y
+CONFIG_CPM2=y
+CONFIG_HIGHMEM=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_HZ_1000=y
+CONFIG_PREEMPT=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_BINFMT_MISC=m
+CONFIG_MATH_EMULATION=y
+CONFIG_IRQ_ALL_CPUS=y
+CONFIG_FORCE_MAX_ZONEORDER=17
+CONFIG_PCI=y
+CONFIG_PCIEPORTBUS=y
+CONFIG_PCI_MSI=y
+CONFIG_PCCARD=y
+# CONFIG_PCMCIA_LOAD_CIS is not set
+CONFIG_YENTA=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_XFRM_USER=m
+CONFIG_NET_KEY=y
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+CONFIG_IP_ADVANCED_ROUTER=y
+CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IP_ROUTE_MULTIPATH=y
+CONFIG_IP_ROUTE_VERBOSE=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_IP_PNP_RARP=y
+CONFIG_NET_IPIP=m
+CONFIG_IP_MROUTE=y
+CONFIG_IP_PIMSM_V1=y
+CONFIG_IP_PIMSM_V2=y
+CONFIG_SYN_COOKIES=y
+CONFIG_INET_AH=m
+CONFIG_INET_ESP=m
+CONFIG_INET_IPCOMP=m
+# CONFIG_INET_XFRM_MODE_BEET is not set
+CONFIG_INET6_AH=m
+CONFIG_INET6_IPCOMP=m
+CONFIG_IPV6_TUNNEL=m
+CONFIG_NET_PKTGEN=m
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_MTD=y
+CONFIG_MTD_OF_PARTS=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_PHYSMAP_OF=y
+CONFIG_MTD_NAND=y
+CONFIG_MTD_NAND_FSL_ELBC=y
+CONFIG_PROC_DEVICETREE=y
+CONFIG_BLK_DEV_LOOP=m
+CONFIG_BLK_DEV_CRYPTOLOOP=m
+CONFIG_BLK_DEV_NBD=m
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_SIZE=131072
+CONFIG_MISC_DEVICES=y
+CONFIG_DS1682=y
+CONFIG_BLK_DEV_SD=y
+CONFIG_CHR_DEV_ST=y
+CONFIG_BLK_DEV_SR=y
+CONFIG_ATA=y
+CONFIG_SATA_AHCI=y
+CONFIG_SATA_SIL24=y
+# CONFIG_ATA_SFF is not set
+CONFIG_NETDEVICES=y
+CONFIG_BONDING=m
+CONFIG_DUMMY=m
+CONFIG_NETCONSOLE=y
+CONFIG_NETPOLL_TRAP=y
+CONFIG_TUN=m
+# CONFIG_NET_VENDOR_3COM is not set
+CONFIG_FS_ENET=y
+CONFIG_UCC_GETH=y
+CONFIG_GIANFAR=y
+CONFIG_PPP=m
+CONFIG_PPP_BSDCOMP=m
+CONFIG_PPP_DEFLATE=m
+CONFIG_PPP_FILTER=y
+CONFIG_PPP_MULTILINK=y
+CONFIG_PPPOE=m
+CONFIG_PPP_ASYNC=m
+CONFIG_PPP_SYNC_TTY=m
+CONFIG_SLIP=m
+CONFIG_SLIP_COMPRESSED=y
+CONFIG_SLIP_SMART=y
+CONFIG_SLIP_MODE_SLIP6=y
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_SERIO is not set
+# CONFIG_LEGACY_PTYS is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_8250_NR_UARTS=2
+CONFIG_SERIAL_8250_RUNTIME_UARTS=2
+CONFIG_SERIAL_8250_EXTENDED=y
+CONFIG_SERIAL_8250_MANY_PORTS=y
+CONFIG_SERIAL_8250_DETECT_IRQ=y
+CONFIG_SERIAL_8250_RSA=y
+CONFIG_SERIAL_QE=m
+CONFIG_NVRAM=y
+CONFIG_I2C=y
+CONFIG_I2C_CHARDEV=y
+CONFIG_I2C_CPM=m
+CONFIG_I2C_MPC=y
+CONFIG_GPIO_SYSFS=y
+CONFIG_SENSORS_LM90=y
+CONFIG_SENSORS_LM92=y
+CONFIG_WATCHDOG=y
+CONFIG_GEF_WDT=y
+CONFIG_VIDEO_OUTPUT_CONTROL=m
+CONFIG_HID_DRAGONRISE=y
+CONFIG_HID_GYRATION=y
+CONFIG_HID_TWINHAN=y
+CONFIG_HID_ORTEK=y
+CONFIG_HID_PANTHERLORD=y
+CONFIG_HID_PETALYNX=y
+CONFIG_HID_SAMSUNG=y
+CONFIG_HID_SONY=y
+CONFIG_HID_SUNPLUS=y
+CONFIG_HID_GREENASIA=y
+CONFIG_HID_SMARTJOYPLUS=y
+CONFIG_HID_TOPSEED=y
+CONFIG_HID_THRUSTMASTER=y
+CONFIG_HID_ZEROPLUS=y
+CONFIG_USB=y
+CONFIG_USB_DEVICEFS=y
+CONFIG_USB_EHCI_HCD=y
+# CONFIG_USB_EHCI_TT_NEWSCHED is not set
+CONFIG_USB_EHCI_FSL=y
+CONFIG_USB_OHCI_HCD=y
+CONFIG_USB_OHCI_HCD_PPC_OF_BE=y
+CONFIG_USB_OHCI_HCD_PPC_OF_LE=y
+CONFIG_USB_STORAGE=y
+CONFIG_EDAC=y
+CONFIG_EDAC_MM_EDAC=y
+CONFIG_EDAC_MPC85XX=y
+CONFIG_RTC_CLASS=y
+# CONFIG_RTC_INTF_PROC is not set
+CONFIG_RTC_DRV_RX8581=y
+CONFIG_DMADEVICES=y
+CONFIG_FSL_DMA=y
+# CONFIG_NET_DMA is not set
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+CONFIG_EXT3_FS=y
+# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
+CONFIG_EXT3_FS_POSIX_ACL=y
+CONFIG_EXT4_FS=y
+CONFIG_FUSE_FS=y
+CONFIG_ISO9660_FS=y
+CONFIG_JOLIET=y
+CONFIG_ZISOFS=y
+CONFIG_UDF_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_FAT_DEFAULT_CODEPAGE=850
+CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
+CONFIG_NTFS_FS=y
+CONFIG_PROC_KCORE=y
+CONFIG_TMPFS=y
+CONFIG_JFFS2_FS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NFS_V4=y
+CONFIG_ROOT_NFS=y
+CONFIG_NFSD=y
+CONFIG_NFSD_V4=y
+CONFIG_CIFS=m
+CONFIG_CIFS_XATTR=y
+CONFIG_CIFS_POSIX=y
+CONFIG_NLS_CODEPAGE_437=y
+CONFIG_NLS_CODEPAGE_737=m
+CONFIG_NLS_CODEPAGE_775=m
+CONFIG_NLS_CODEPAGE_850=y
+CONFIG_NLS_CODEPAGE_852=m
+CONFIG_NLS_CODEPAGE_855=m
+CONFIG_NLS_CODEPAGE_857=m
+CONFIG_NLS_CODEPAGE_860=m
+CONFIG_NLS_CODEPAGE_861=m
+CONFIG_NLS_CODEPAGE_862=m
+CONFIG_NLS_CODEPAGE_863=m
+CONFIG_NLS_CODEPAGE_864=m
+CONFIG_NLS_CODEPAGE_865=m
+CONFIG_NLS_CODEPAGE_866=m
+CONFIG_NLS_CODEPAGE_869=m
+CONFIG_NLS_CODEPAGE_936=m
+CONFIG_NLS_CODEPAGE_950=m
+CONFIG_NLS_CODEPAGE_932=m
+CONFIG_NLS_CODEPAGE_949=m
+CONFIG_NLS_CODEPAGE_874=m
+CONFIG_NLS_ISO8859_8=m
+CONFIG_NLS_CODEPAGE_1250=m
+CONFIG_NLS_CODEPAGE_1251=m
+CONFIG_NLS_ASCII=y
+CONFIG_NLS_ISO8859_1=y
+CONFIG_NLS_ISO8859_2=m
+CONFIG_NLS_ISO8859_3=m
+CONFIG_NLS_ISO8859_4=m
+CONFIG_NLS_ISO8859_5=m
+CONFIG_NLS_ISO8859_6=m
+CONFIG_NLS_ISO8859_7=m
+CONFIG_NLS_ISO8859_9=m
+CONFIG_NLS_ISO8859_13=m
+CONFIG_NLS_ISO8859_14=m
+CONFIG_NLS_ISO8859_15=y
+CONFIG_NLS_KOI8_R=m
+CONFIG_NLS_KOI8_U=m
+CONFIG_NLS_UTF8=y
+CONFIG_CRC_CCITT=y
+CONFIG_CRC_T10DIF=y
+CONFIG_LIBCRC32C=y
+CONFIG_MAGIC_SYSRQ=y
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+CONFIG_CRYPTO_CBC=y
+CONFIG_CRYPTO_MD5=y
+CONFIG_CRYPTO_SHA256=m
+CONFIG_CRYPTO_SHA512=m
+CONFIG_CRYPTO_DES=y
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+CONFIG_CRYPTO_DEV_TALITOS=y
diff --git a/arch/powerpc/platforms/85xx/Kconfig b/arch/powerpc/platforms/85xx/Kconfig
index d7946be..db29803 100644
--- a/arch/powerpc/platforms/85xx/Kconfig
+++ b/arch/powerpc/platforms/85xx/Kconfig
@@ -171,6 +171,21 @@ config SBC8560
 	help
 	  This option enables support for the Wind River SBC8560 board
 
+config GE_IMP3A
+	bool "GE Intelligent Platforms IMP3A"
+	select DEFAULT_UIMAGE
+	select SWIOTLB
+	select MMIO_NVRAM
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	select GE_FPGA
+	help
+	  This option enables support for the GE Intelligent Platforms IMP3A
+	  board.
+
+	  This board is a 3U CompactPCI Single Board Computer with a Freescale
+	  P2020 processor.
+
 config P2041_RDB
 	bool "Freescale P2041 RDB"
 	select DEFAULT_UIMAGE
diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
index 9cb2d43..2125d4c 100644
--- a/arch/powerpc/platforms/85xx/Makefile
+++ b/arch/powerpc/platforms/85xx/Makefile
@@ -27,3 +27,4 @@ obj-$(CONFIG_SBC8548)     += sbc8548.o
 obj-$(CONFIG_SOCRATES)    += socrates.o socrates_fpga_pic.o
 obj-$(CONFIG_KSI8560)	  += ksi8560.o
 obj-$(CONFIG_XES_MPC85xx) += xes_mpc85xx.o
+obj-$(CONFIG_GE_IMP3A)	  += ge_imp3a.o
diff --git a/arch/powerpc/platforms/85xx/ge_imp3a.c b/arch/powerpc/platforms/85xx/ge_imp3a.c
new file mode 100644
index 0000000..b1ab759
--- /dev/null
+++ b/arch/powerpc/platforms/85xx/ge_imp3a.c
@@ -0,0 +1,246 @@
+/*
+ * GE IMP3A Board Setup
+ *
+ * Author Martyn Welch <martyn.welch@ge.com>
+ *
+ * Copyright 2010 GE Intelligent Platforms Embedded Systems, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * Based on: mpc85xx_ds.c (MPC85xx DS Board Setup)
+ * Copyright 2007 Freescale Semiconductor Inc.
+ */
+
+#include <linux/stddef.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/kdev_t.h>
+#include <linux/delay.h>
+#include <linux/seq_file.h>
+#include <linux/interrupt.h>
+#include <linux/of_platform.h>
+#include <linux/memblock.h>
+
+#include <asm/system.h>
+#include <asm/time.h>
+#include <asm/machdep.h>
+#include <asm/pci-bridge.h>
+#include <mm/mmu_decl.h>
+#include <asm/prom.h>
+#include <asm/udbg.h>
+#include <asm/mpic.h>
+#include <asm/swiotlb.h>
+#include <asm/nvram.h>
+
+#include <sysdev/fsl_soc.h>
+#include <sysdev/fsl_pci.h>
+#include "smp.h"
+
+#include "mpc85xx.h"
+#include <sysdev/ge/ge_pic.h>
+
+void __iomem *imp3a_regs;
+
+void __init ge_imp3a_pic_init(void)
+{
+	struct mpic *mpic;
+	struct device_node *np;
+	struct device_node *cascade_node = NULL;
+	unsigned long root = of_get_flat_dt_root();
+
+	if (of_flat_dt_is_compatible(root, "fsl,MPC8572DS-CAMP")) {
+		mpic = mpic_alloc(NULL, 0,
+			MPIC_NO_RESET |
+			MPIC_BIG_ENDIAN |
+			MPIC_SINGLE_DEST_CPU,
+			0, 256, " OpenPIC  ");
+	} else {
+		mpic = mpic_alloc(NULL, 0,
+			  MPIC_BIG_ENDIAN |
+			  MPIC_SINGLE_DEST_CPU,
+			0, 256, " OpenPIC  ");
+	}
+
+	BUG_ON(mpic == NULL);
+	mpic_init(mpic);
+	/*
+	 * There is a simple interrupt handler in the main FPGA, this needs
+	 * to be cascaded into the MPIC
+	 */
+	for_each_node_by_type(np, "interrupt-controller")
+	    if (of_device_is_compatible(np, "gef,fpga-pic-1.00")) {
+		cascade_node = np;
+		break;
+	}
+
+	if (cascade_node == NULL) {
+		printk(KERN_WARNING "IMP3A: No FPGA PIC\n");
+		return;
+	}
+
+	gef_pic_init(cascade_node);
+	of_node_put(cascade_node);
+}
+
+#ifdef CONFIG_PCI
+static int primary_phb_addr;
+#endif	/* CONFIG_PCI */
+
+/*
+ * Setup the architecture
+ */
+static void __init ge_imp3a_setup_arch(void)
+{
+	struct device_node *regs;
+#ifdef CONFIG_PCI
+	struct device_node *np;
+	struct pci_controller *hose;
+#endif
+	dma_addr_t max = 0xffffffff;
+
+	if (ppc_md.progress)
+		ppc_md.progress("ge_imp3a_setup_arch()", 0);
+
+#ifdef CONFIG_PCI
+	for_each_node_by_type(np, "pci") {
+		if (of_device_is_compatible(np, "fsl,mpc8540-pci") ||
+		    of_device_is_compatible(np, "fsl,mpc8548-pcie") ||
+		    of_device_is_compatible(np, "fsl,p2020-pcie")) {
+			struct resource rsrc;
+			of_address_to_resource(np, 0, &rsrc);
+			if ((rsrc.start & 0xfffff) == primary_phb_addr)
+				fsl_add_bridge(np, 1);
+			else
+				fsl_add_bridge(np, 0);
+
+			hose = pci_find_hose_for_OF_device(np);
+			max = min(max, hose->dma_window_base_cur +
+					hose->dma_window_size);
+		}
+	}
+#endif
+
+	mpc85xx_smp_init();
+
+#ifdef CONFIG_SWIOTLB
+	if (memblock_end_of_DRAM() > max) {
+		ppc_swiotlb_enable = 1;
+		set_pci_dma_ops(&swiotlb_dma_ops);
+		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
+	}
+#endif
+
+	/* Remap basic board registers */
+	regs = of_find_compatible_node(NULL, NULL, "ge,imp3a-fpga-regs");
+	if (regs) {
+		imp3a_regs = of_iomap(regs, 0);
+		if (imp3a_regs == NULL)
+			printk(KERN_WARNING "Unable to map board registers\n");
+		of_node_put(regs);
+	}
+
+#if defined(CONFIG_MMIO_NVRAM)
+	mmio_nvram_init();
+#endif
+
+	printk(KERN_INFO "GE Intelligent Platforms IMP3A 3U cPCI SBC\n");
+}
+
+/* Return the PCB revision */
+static unsigned int ge_imp3a_get_pcb_rev(void)
+{
+	unsigned int reg;
+
+	reg = ioread16(imp3a_regs);
+	return (reg >> 8) & 0xff;
+}
+
+/* Return the board (software) revision */
+static unsigned int ge_imp3a_get_board_rev(void)
+{
+	unsigned int reg;
+
+	reg = ioread16(imp3a_regs + 0x2);
+	return reg & 0xff;
+}
+
+/* Return the FPGA revision */
+static unsigned int ge_imp3a_get_fpga_rev(void)
+{
+	unsigned int reg;
+
+	reg = ioread16(imp3a_regs + 0x2);
+	return (reg >> 8) & 0xff;
+}
+
+/* Return compactPCI Geographical Address */
+static unsigned int ge_imp3a_get_cpci_geo_addr(void)
+{
+	unsigned int reg;
+
+	reg = ioread16(imp3a_regs + 0x6);
+	return (reg & 0x0f00) >> 8;
+}
+
+/* Return compactPCI System Controller Status */
+static unsigned int ge_imp3a_get_cpci_is_syscon(void)
+{
+	unsigned int reg;
+
+	reg = ioread16(imp3a_regs + 0x6);
+	return reg & (1 << 12);
+}
+
+static void ge_imp3a_show_cpuinfo(struct seq_file *m)
+{
+	seq_printf(m, "Vendor\t\t: GE Intelligent Platforms\n");
+
+	seq_printf(m, "Revision\t: %u%c\n", ge_imp3a_get_pcb_rev(),
+		('A' + ge_imp3a_get_board_rev() - 1));
+
+	seq_printf(m, "FPGA Revision\t: %u\n", ge_imp3a_get_fpga_rev());
+
+	seq_printf(m, "cPCI geo. addr\t: %u\n", ge_imp3a_get_cpci_geo_addr());
+
+	seq_printf(m, "cPCI syscon\t: %s\n",
+		ge_imp3a_get_cpci_is_syscon() ? "yes" : "no");
+}
+
+/*
+ * Called very early, device-tree isn't unflattened
+ */
+static int __init ge_imp3a_probe(void)
+{
+	unsigned long root = of_get_flat_dt_root();
+
+	if (of_flat_dt_is_compatible(root, "ge,IMP3A")) {
+#ifdef CONFIG_PCI
+		primary_phb_addr = 0x9000;
+#endif
+		return 1;
+	}
+
+	return 0;
+}
+
+machine_device_initcall(ge_imp3a, mpc85xx_common_publish_devices);
+
+machine_arch_initcall(ge_imp3a, swiotlb_setup_bus_notifier);
+
+define_machine(ge_imp3a) {
+	.name			= "GE_IMP3A",
+	.probe			= ge_imp3a_probe,
+	.setup_arch		= ge_imp3a_setup_arch,
+	.init_IRQ		= ge_imp3a_pic_init,
+	.show_cpuinfo		= ge_imp3a_show_cpuinfo,
+#ifdef CONFIG_PCI
+	.pcibios_fixup_bus	= fsl_pcibios_fixup_bus,
+#endif
+	.get_irq		= mpic_get_irq,
+	.restart		= fsl_rstcr_restart,
+	.calibrate_decr		= generic_calibrate_decr,
+	.progress		= udbg_progress,
+};
diff --git a/arch/powerpc/sysdev/ge/ge_gpio.c b/arch/powerpc/sysdev/ge/ge_gpio.c
index f8e6289..7b95a4a 100644
--- a/arch/powerpc/sysdev/ge/ge_gpio.c
+++ b/arch/powerpc/sysdev/ge/ge_gpio.c
@@ -162,6 +162,34 @@ static int __init gef_gpio_init(void)
 		}
 	}
 
+	for_each_compatible_node(np, NULL, "ge,imp3a-gpio") {
+
+		pr_debug("%s: Initialising GE GPIO\n", np->full_name);
+
+		/* Allocate chip structure */
+		gef_gpio_chip = kzalloc(sizeof(*gef_gpio_chip), GFP_KERNEL);
+		if (!gef_gpio_chip) {
+			pr_err("%s: Unable to allocate structure\n",
+				np->full_name);
+			continue;
+		}
+
+		/* Setup pointers to chip functions */
+		gef_gpio_chip->gc.of_gpio_n_cells = 2;
+		gef_gpio_chip->gc.ngpio = 16;
+		gef_gpio_chip->gc.direction_input = gef_gpio_dir_in;
+		gef_gpio_chip->gc.direction_output = gef_gpio_dir_out;
+		gef_gpio_chip->gc.get = gef_gpio_get;
+		gef_gpio_chip->gc.set = gef_gpio_set;
+
+		/* This function adds a memory mapped GPIO chip */
+		retval = of_mm_gpiochip_add(np, gef_gpio_chip);
+		if (retval) {
+			kfree(gef_gpio_chip);
+			pr_err("%s: Unable to add GPIO\n", np->full_name);
+		}
+	}
+
 	return 0;
 };
 arch_initcall(gef_gpio_init);
-- 
1.7.0.4


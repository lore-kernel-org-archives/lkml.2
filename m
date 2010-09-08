Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0IHUzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 16:55:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab0IHUzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 16:55:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC] annotating the remaining BKL users
Date: Wed, 8 Sep 2010 22:55:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.5.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>, Jan Blunck <jblunck@suse.de>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009082255.33035.arnd@arndb.de>
X-Provags-ID: V02:K0:0q0NVj3yMLP6tyeJhhx1NegqG7irAfYf2351/8hp5C8
 HcGFG5xvfOCZzaqikxTVYD8JAQ/Y3lvXd2C0UUiOSCir4yfgHT
 1woq9algRuCAP5NgBhDkFZ+g+kptPCd8/0GhTc7dUq6neQA5+f
 q/HbA9vei2d6z9nh6Yql5KC5clQ9myjneMAcIWPSqGCr9EEL8B
 rhAlY4hAdREmFsp02rq2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all the patches we have queued in the BKL removal tree, only a
few dozen modules are left that actually rely on the BKL, and even
there are lots of low-hanging fruit. We need to decide what to do
about them, this patch illustrates one of the options:

Every user of the BKL is marked as 'depends on BKL' in Kconfig,
and the CONFIG_BKL becomes a user-visible option. If it gets
disabled, no BKL using module can be built any more and the BKL
code itself is compiled out.

Eventually, I hope that all code that people care about gets
rid of the BKL and we can toss the rest into drivers/staging
and delete it some time later.

As an alternative to this patch, we could just mark all these
modules as "select BKL" in Kconfig and not make it the option
user-visible.

I'd like to hear preferences for one approach or the other,
especially from Linus, so we can give this some better testing
in -next before the merge window.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/alpha/Kconfig              |    1 +
 arch/cris/Kconfig               |    1 +
 arch/m68k/Kconfig               |    1 +
 arch/parisc/Kconfig             |    1 +
 arch/sh/Kconfig                 |    1 +
 arch/sparc/Kconfig              |    1 +
 arch/um/Kconfig.common          |    1 +
 drivers/char/Kconfig            |    4 ++--
 drivers/gpu/drm/Kconfig         |    3 ++-
 drivers/isdn/Kconfig            |    1 +
 drivers/isdn/capi/Kconfig       |    2 +-
 drivers/isdn/mISDN/Kconfig      |    1 +
 drivers/media/Kconfig           |    3 ++-
 drivers/message/i2o/Kconfig     |    2 +-
 drivers/misc/Kconfig            |    2 +-
 drivers/net/appletalk/Kconfig   |    1 +
 drivers/s390/block/Kconfig      |    2 +-
 drivers/sbus/char/Kconfig       |    2 +-
 drivers/staging/cx25821/Kconfig |    2 +-
 drivers/staging/easycap/Kconfig |    2 +-
 drivers/staging/go7007/Kconfig  |    2 +-
 drivers/staging/hv/Kconfig      |    2 +-
 drivers/staging/spectra/Kconfig |    2 +-
 drivers/staging/usbip/Kconfig   |    2 +-
 drivers/usb/gadget/Kconfig      |    2 +-
 fs/adfs/Kconfig                 |    1 +
 fs/afs/Kconfig                  |    1 +
 fs/autofs/Kconfig               |    1 +
 fs/autofs4/Kconfig              |    1 +
 fs/ceph/Kconfig                 |    2 +-
 fs/coda/Kconfig                 |    1 +
 fs/ecryptfs/Kconfig             |    1 +
 fs/fat/Kconfig                  |    2 ++
 fs/freevxfs/Kconfig             |    1 +
 fs/hpfs/Kconfig                 |    1 +
 fs/isofs/Kconfig                |    1 +
 fs/jffs2/Kconfig                |    1 +
 fs/ncpfs/Kconfig                |    1 +
 fs/nfs/Kconfig                  |    2 +-
 fs/nfsd/Kconfig                 |    1 +
 fs/ocfs2/Kconfig                |    1 +
 fs/qnx4/Kconfig                 |    1 +
 fs/reiserfs/Kconfig             |    1 +
 fs/smbfs/Kconfig                |    1 +
 fs/squashfs/Kconfig             |    2 +-
 fs/udf/Kconfig                  |    1 +
 fs/ufs/Kconfig                  |    2 +-
 include/linux/smp_lock.h        |    7 +++++--
 init/Kconfig                    |    2 +-
 kernel/trace/Kconfig            |    1 +
 lib/Kconfig.debug               |   11 ++++++++++-
 net/ipx/Kconfig                 |    1 +
 net/irda/Kconfig                |    2 +-
 net/irda/irnet/Kconfig          |    2 +-
 net/x25/Kconfig                 |    2 +-
 55 files changed, 72 insertions(+), 27 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index b9647bb..f12e64a 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -11,6 +11,7 @@ config ALPHA
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
+	select BKL
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index aefe3b1..47970b0 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -61,6 +61,7 @@ config CRIS
 	bool
 	default y
 	select HAVE_IDE
+	select BKL
 
 config HZ
 	int
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 8030e24..645bd28 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select HAVE_AOUT
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
+	select BKL
 
 config MMU
 	bool
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 907417d..5e309a5 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -17,6 +17,7 @@ config PARISC
 	select INIT_ALL_POSSIBLE
 	select BUG
 	select HAVE_PERF_EVENTS
+	select BKL
 	select GENERIC_ATOMIC64 if !64BIT
 	help
 	  The PA-RISC microprocessor is designed by Hewlett-Packard and used
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 2284215..0b934ef 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -26,6 +26,7 @@ config SUPERH
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select RTC_LIB
 	select GENERIC_ATOMIC64
+	select BKL
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 491e9d6..fe1ea33 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -33,6 +33,7 @@ config SPARC
 
 config SPARC32
 	def_bool !64BIT
+	select BKL
 
 config SPARC64
 	def_bool 64BIT
diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 7c8e277..6eecf76 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -10,6 +10,7 @@ config GENERIC_HARDIRQS
 
 config UML
 	bool
+	select BKL
 	default y
 
 config MMU
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 43d3395..49dd253 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -1049,7 +1049,7 @@ config CS5535_GPIO
 
 config RAW_DRIVER
 	tristate "RAW driver (/dev/raw/rawN)"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	help
 	  The raw driver permits block devices to be bound to /dev/raw/rawN.
 	  Once bound, I/O against /dev/raw/rawN uses efficient zero-copy I/O.
@@ -1117,7 +1117,7 @@ source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
 	tristate "Telecom clock driver for ATCA SBC"
-	depends on EXPERIMENTAL && X86
+	depends on EXPERIMENTAL && X86 && BKL
 	default n
 	help
 	  The telecom clock device is specific to the MPCBL0010 and MPCBL0050
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 4cab0c6..7db1d33 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -73,7 +73,7 @@ source "drivers/gpu/drm/radeon/Kconfig"
 
 config DRM_I810
 	tristate "Intel I810"
-	depends on DRM && AGP && AGP_INTEL
+	depends on DRM && AGP && AGP_INTEL && BKL
 	help
 	  Choose this option if you have an Intel I810 graphics card.  If M is
 	  selected, the module will be called i810.  AGP support is required
@@ -86,6 +86,7 @@ choice
 
 config DRM_I830
 	tristate "i830 driver"
+	depends on BKL
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,
 	  852GM, 855GM or 865G integrated graphics.  If M is selected, the
diff --git a/drivers/isdn/Kconfig b/drivers/isdn/Kconfig
index 4fb6016..ecf58c5 100644
--- a/drivers/isdn/Kconfig
+++ b/drivers/isdn/Kconfig
@@ -22,6 +22,7 @@ if ISDN
 
 menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
+	depends on BKL
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
diff --git a/drivers/isdn/capi/Kconfig b/drivers/isdn/capi/Kconfig
index a168e8a..bb40d8d 100644
--- a/drivers/isdn/capi/Kconfig
+++ b/drivers/isdn/capi/Kconfig
@@ -35,7 +35,7 @@ config ISDN_CAPI_CAPI20
 
 config ISDN_CAPI_CAPIFS_BOOL
 	bool "CAPI2.0 filesystem support (DEPRECATED)"
-	depends on ISDN_CAPI_MIDDLEWARE && ISDN_CAPI_CAPI20
+	depends on ISDN_CAPI_MIDDLEWARE && ISDN_CAPI_CAPI20 && BKL
 	help
 	  This option provides a special file system, similar to /dev/pts with
 	  device nodes for the special ttys established by using the
diff --git a/drivers/isdn/mISDN/Kconfig b/drivers/isdn/mISDN/Kconfig
index 1747a02..ba4fbd9 100644
--- a/drivers/isdn/mISDN/Kconfig
+++ b/drivers/isdn/mISDN/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig MISDN
 	tristate "Modular ISDN driver"
+	depends on BKL
 	help
 	  Enable support for the modular ISDN driver.
 
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a28541b..95d2a8b 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -19,6 +19,7 @@ comment "Multimedia core support"
 
 config VIDEO_DEV
 	tristate "Video For Linux"
+	depends on BKL
 	---help---
 	  V4L core support for video capture and overlay devices, webcams and
 	  AM/FM radio cards.
@@ -75,7 +76,7 @@ config VIDEO_V4L1_COMPAT
 
 config DVB_CORE
 	tristate "DVB for Linux"
-	depends on NET && INET
+	depends on NET && INET && BKL
 	select CRC32
 	help
 	  DVB core utility functions for device handling, software fallbacks etc.
diff --git a/drivers/message/i2o/Kconfig b/drivers/message/i2o/Kconfig
index 5afa0e3..1a66803 100644
--- a/drivers/message/i2o/Kconfig
+++ b/drivers/message/i2o/Kconfig
@@ -85,7 +85,7 @@ config I2O_BUS
 
 config I2O_BLOCK
 	tristate "I2O Block OSM"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	---help---
 	  Include support for the I2O Block OSM. The Block OSM presents disk
 	  and other structured block devices to the operating system. If you
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2c38d4e..1a58308 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -263,7 +263,7 @@ config HP_ILO
 
 config SGI_GRU
 	tristate "SGI GRU driver"
-	depends on X86_UV && SMP
+	depends on X86_UV && SMP && BKL
 	default n
 	select MMU_NOTIFIER
 	---help---
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index 0a0e0cd..04fa1e7 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -3,6 +3,7 @@
 #
 config ATALK
 	tristate "Appletalk protocol support"
+	depends on BKL
 	select LLC
 	---help---
 	  AppleTalk is the protocol that Apple computers can use to communicate
diff --git a/drivers/s390/block/Kconfig b/drivers/s390/block/Kconfig
index 0788319..ed63cad 100644
--- a/drivers/s390/block/Kconfig
+++ b/drivers/s390/block/Kconfig
@@ -19,7 +19,7 @@ config DCSSBLK
 
 config DASD
 	tristate "Support for DASD devices"
-	depends on CCW && BLOCK
+	depends on CCW && BLOCK && BKL
 	select IOSCHED_DEADLINE
 	help
 	  Enable this option if you want to access DASDs directly utilizing
diff --git a/drivers/sbus/char/Kconfig b/drivers/sbus/char/Kconfig
index 73cde85..b0272e2 100644
--- a/drivers/sbus/char/Kconfig
+++ b/drivers/sbus/char/Kconfig
@@ -31,7 +31,7 @@ config TADPOLE_TS102_UCTRL
 
 config SUN_JSFLASH
 	tristate "JavaStation OS Flash SIMM (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && SPARC32
+	depends on EXPERIMENTAL && SPARC32 && BKL
 	help
 	  If you say Y here, you will be able to boot from your JavaStation's
 	  Flash memory.
diff --git a/drivers/staging/cx25821/Kconfig b/drivers/staging/cx25821/Kconfig
index df7756a..944ee75 100644
--- a/drivers/staging/cx25821/Kconfig
+++ b/drivers/staging/cx25821/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && BKL
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
diff --git a/drivers/staging/easycap/Kconfig b/drivers/staging/easycap/Kconfig
index bd96f39..b9645c2 100644
--- a/drivers/staging/easycap/Kconfig
+++ b/drivers/staging/easycap/Kconfig
@@ -1,6 +1,6 @@
 config EASYCAP
 	tristate "EasyCAP USB ID 05e1:0408 support"
-	depends on USB && VIDEO_DEV
+	depends on USB && VIDEO_DEV && BKL
 
 	---help---
 	  This is an integrated audio/video driver for EasyCAP cards with
diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index e47f683..dda2b4e 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_DEV && PCI && I2C && INPUT && BKL
 	depends on SND
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
index 7455c80..cc066ee 100644
--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -10,7 +10,7 @@ if HYPERV
 
 config HYPERV_STORAGE
 	tristate "Microsoft Hyper-V virtual storage driver"
-	depends on SCSI
+	depends on SCSI && BKL
 	default HYPERV
 	help
 	 Select this option to enable the Hyper-V virtual storage driver.
diff --git a/drivers/staging/spectra/Kconfig b/drivers/staging/spectra/Kconfig
index 4fc2064..ba96e05 100644
--- a/drivers/staging/spectra/Kconfig
+++ b/drivers/staging/spectra/Kconfig
@@ -1,7 +1,7 @@
 
 menuconfig SPECTRA
 	tristate "Denali Spectra Flash Translation Layer"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	depends on X86_MRST
 	default n
 	---help---
diff --git a/drivers/staging/usbip/Kconfig b/drivers/staging/usbip/Kconfig
index 2c1d10a..b11ec37 100644
--- a/drivers/staging/usbip/Kconfig
+++ b/drivers/staging/usbip/Kconfig
@@ -1,6 +1,6 @@
 config USB_IP_COMMON
 	tristate "USB IP support (EXPERIMENTAL)"
-	depends on USB && NET && EXPERIMENTAL
+	depends on USB && NET && EXPERIMENTAL && BKL
 	default N
 	---help---
 	  This enables pushing USB packets over IP to allow remote
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index cd27f9b..4de1fc6 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -697,7 +697,7 @@ config USB_ETH_EEM
 
 config USB_GADGETFS
 	tristate "Gadget Filesystem (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && BKL
 	help
 	  This driver provides a filesystem based API that lets user mode
 	  programs implement a single-configuration USB device, including
diff --git a/fs/adfs/Kconfig b/fs/adfs/Kconfig
index e55182a..d72c786 100644
--- a/fs/adfs/Kconfig
+++ b/fs/adfs/Kconfig
@@ -1,6 +1,7 @@
 config ADFS_FS
 	tristate "ADFS file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
+	depends on BKL
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 8f975f2..5647a1c 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -1,6 +1,7 @@
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
+	depends on BKL
 	select AF_RXRPC
 	select DNS_RESOLVER
 	help
diff --git a/fs/autofs/Kconfig b/fs/autofs/Kconfig
index 5f3bea9..9126a42 100644
--- a/fs/autofs/Kconfig
+++ b/fs/autofs/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS_FS
 	tristate "Kernel automounter support"
+	depends on BKL
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..06831b5 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS4_FS
 	tristate "Kernel automounter version 4 support (also supports v3)"
+	depends on BKL
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index bc87b9c..6fd0bc1 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -1,6 +1,6 @@
 config CEPH_FS
         tristate "Ceph distributed file system (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	depends on INET && EXPERIMENTAL && BKL
 	select LIBCRC32C
 	select CRYPTO_AES
 	help
diff --git a/fs/coda/Kconfig b/fs/coda/Kconfig
index c0e5a7f..8689de8 100644
--- a/fs/coda/Kconfig
+++ b/fs/coda/Kconfig
@@ -1,6 +1,7 @@
 config CODA_FS
 	tristate "Coda file system support (advanced network fs)"
 	depends on INET
+	depends on BKL
 	help
 	  Coda is an advanced network file system, similar to NFS in that it
 	  enables you to mount file systems of a remote server and access them
diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index 1cd6d9d..2e8660f 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -1,6 +1,7 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && KEYS && CRYPTO
+	depends on BKL
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_MD5
diff --git a/fs/fat/Kconfig b/fs/fat/Kconfig
index 182f9ff..c4777ea 100644
--- a/fs/fat/Kconfig
+++ b/fs/fat/Kconfig
@@ -34,6 +34,7 @@ config FAT_FS
 
 config MSDOS_FS
 	tristate "MSDOS fs support"
+	depends on BKL
 	select FAT_FS
 	help
 	  This allows you to mount MSDOS partitions of your hard drive (unless
@@ -59,6 +60,7 @@ config MSDOS_FS
 
 config VFAT_FS
 	tristate "VFAT (Windows-95) fs support"
+	depends on BKL
 	select FAT_FS
 	help
 	  This option provides support for normal Windows file systems with
diff --git a/fs/freevxfs/Kconfig b/fs/freevxfs/Kconfig
index 8dc1cd5..aba5cb5 100644
--- a/fs/freevxfs/Kconfig
+++ b/fs/freevxfs/Kconfig
@@ -1,6 +1,7 @@
 config VXFS_FS
 	tristate "FreeVxFS file system support (VERITAS VxFS(TM) compatible)"
 	depends on BLOCK
+	depends on BKL
 	help
 	  FreeVxFS is a file system driver that support the VERITAS VxFS(TM)
 	  file system format.  VERITAS VxFS(TM) is the standard file system
diff --git a/fs/hpfs/Kconfig b/fs/hpfs/Kconfig
index 56bd15c..1012579 100644
--- a/fs/hpfs/Kconfig
+++ b/fs/hpfs/Kconfig
@@ -1,6 +1,7 @@
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
 	depends on BLOCK
+	depends on BKL
 	help
 	  OS/2 is IBM's operating system for PC's, the same as Warp, and HPFS
 	  is the file system used for organizing files on OS/2 hard disk
diff --git a/fs/isofs/Kconfig b/fs/isofs/Kconfig
index 8ab9878..2c45a34 100644
--- a/fs/isofs/Kconfig
+++ b/fs/isofs/Kconfig
@@ -1,5 +1,6 @@
 config ISO9660_FS
 	tristate "ISO 9660 CDROM file system support"
+	depends on BKL
 	help
 	  This is the standard file system used on CD-ROMs.  It was previously
 	  known as "High Sierra File System" and is called "hsfs" on other
diff --git a/fs/jffs2/Kconfig b/fs/jffs2/Kconfig
index 6ae169c..d13b148 100644
--- a/fs/jffs2/Kconfig
+++ b/fs/jffs2/Kconfig
@@ -1,6 +1,7 @@
 config JFFS2_FS
 	tristate "Journalling Flash File System v2 (JFFS2) support"
 	select CRC32
+	depends on BKL
 	depends on MTD
 	help
 	  JFFS2 is the second generation of the Journalling Flash File System
diff --git a/fs/ncpfs/Kconfig b/fs/ncpfs/Kconfig
index c931cf2..d0ed28d 100644
--- a/fs/ncpfs/Kconfig
+++ b/fs/ncpfs/Kconfig
@@ -3,6 +3,7 @@
 #
 config NCP_FS
 	tristate "NCP file system support (to mount NetWare volumes)"
+	depends on BKL
 	depends on IPX!=n || INET
 	help
 	  NCP (NetWare Core Protocol) is a protocol that runs over IPX and is
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 6c2aad4..6184df5 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -1,6 +1,6 @@
 config NFS_FS
 	tristate "NFS client support"
-	depends on INET && FILE_LOCKING
+	depends on INET && FILE_LOCKING && BKL
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 95932f5..93756a8 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -2,6 +2,7 @@ config NFSD
 	tristate "NFS server support"
 	depends on INET
 	depends on FILE_LOCKING
+	depends on BKL
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 0d84066..11b66d0 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,5 +1,6 @@
 config OCFS2_FS
 	tristate "OCFS2 file system support"
+	depends on BKL
 	depends on NET && SYSFS
 	select CONFIGFS_FS
 	select JBD2
diff --git a/fs/qnx4/Kconfig b/fs/qnx4/Kconfig
index 5f60899..4fae4a9 100644
--- a/fs/qnx4/Kconfig
+++ b/fs/qnx4/Kconfig
@@ -1,5 +1,6 @@
 config QNX4FS_FS
 	tristate "QNX4 file system support (read only)"
+	depends on BKL
 	depends on BLOCK
 	help
 	  This is the file system used by the real-time operating systems
diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
index 513f431..d9ac7c5 100644
--- a/fs/reiserfs/Kconfig
+++ b/fs/reiserfs/Kconfig
@@ -1,5 +1,6 @@
 config REISERFS_FS
 	tristate "Reiserfs support"
+	depends on BKL
 	select CRC32
 	help
 	  Stores not just filenames but the files themselves in a balanced
diff --git a/fs/smbfs/Kconfig b/fs/smbfs/Kconfig
index e668127..5361221 100644
--- a/fs/smbfs/Kconfig
+++ b/fs/smbfs/Kconfig
@@ -1,5 +1,6 @@
 config SMB_FS
 	tristate "SMB file system support (OBSOLETE, please use CIFS)"
+	depends on BKL
 	depends on INET
 	select NLS
 	help
diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index e5f63da..13de4c5 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,6 +1,6 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/udf/Kconfig b/fs/udf/Kconfig
index 0e0e99b..b344257 100644
--- a/fs/udf/Kconfig
+++ b/fs/udf/Kconfig
@@ -1,5 +1,6 @@
 config UDF_FS
 	tristate "UDF file system support"
+	depends on BKL
 	select CRC_ITU_T
 	help
 	  This is the new file system used on some CD-ROMs and DVDs. Say Y if
diff --git a/fs/ufs/Kconfig b/fs/ufs/Kconfig
index e4f10a4..7f1410f 100644
--- a/fs/ufs/Kconfig
+++ b/fs/ufs/Kconfig
@@ -1,6 +1,6 @@
 config UFS_FS
 	tristate "UFS file system support (read only)"
-	depends on BLOCK
+	depends on BLOCK && BKL
 	help
 	  BSD and derivate versions of Unix (such as SunOS, FreeBSD, NetBSD,
 	  OpenBSD and NeXTstep) use a file system called UFS. Some System V
diff --git a/include/linux/smp_lock.h b/include/linux/smp_lock.h
index 2ea1dd1..291f721 100644
--- a/include/linux/smp_lock.h
+++ b/include/linux/smp_lock.h
@@ -54,12 +54,15 @@ static inline void cycle_kernel_lock(void)
 
 #else
 
+#ifdef CONFIG_BKL /* provoke build bug if not set */
 #define lock_kernel()
 #define unlock_kernel()
-#define release_kernel_lock(task)		do { } while(0)
 #define cycle_kernel_lock()			do { } while(0)
-#define reacquire_kernel_lock(task)		0
 #define kernel_locked()				1
+#endif /* CONFIG_BKL */
+
+#define release_kernel_lock(task)		do { } while(0)
+#define reacquire_kernel_lock(task)		0
 
 #endif /* CONFIG_LOCK_KERNEL */
 #endif /* __LINUX_SMPLOCK_H */
diff --git a/init/Kconfig b/init/Kconfig
index 51269b1..dc91d9f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -64,7 +64,7 @@ config BROKEN_ON_SMP
 
 config LOCK_KERNEL
 	bool
-	depends on SMP || PREEMPT
+	depends on (SMP || PREEMPT) && BKL
 	default y
 
 config INIT_ENV_ARG_LIMIT
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 6329d06..a20780e 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -327,6 +327,7 @@ config BLK_DEV_IO_TRACE
 	bool "Support for tracing block IO actions"
 	depends on SYSFS
 	depends on BLOCK
+	depends on BKL
 	select RELAY
 	select DEBUG_FS
 	select TRACEPOINTS
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index cba0793..029b24f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -441,7 +441,7 @@ config DEBUG_PI_LIST
 
 config RT_MUTEX_TESTER
 	bool "Built-in scriptable tester for rt-mutexes"
-	depends on DEBUG_KERNEL && RT_MUTEXES
+	depends on DEBUG_KERNEL && RT_MUTEXES && BKL = y
 	help
 	  This option enables a rt-mutex tester.
 
@@ -461,6 +461,15 @@ config DEBUG_MUTEXES
 	 This feature allows mutex semantics violations to be detected and
 	 reported.
 
+config BKL
+	bool "Big Kernel Lock" if (SMP || PREEMPT)
+	default y
+	help
+	  This is the traditional lock that is used in old code instead
+	  of proper locking. All drivers that use the BKL should depend
+	  on this symbol.
+	  Say Y here unless you are working on removing the BKL.
+
 config DEBUG_LOCK_ALLOC
 	bool "Lock debugging: detect incorrect freeing of live locks"
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
diff --git a/net/ipx/Kconfig b/net/ipx/Kconfig
index e9ad006..45b232e 100644
--- a/net/ipx/Kconfig
+++ b/net/ipx/Kconfig
@@ -3,6 +3,7 @@
 #
 config IPX
 	tristate "The IPX protocol"
+	depends on BKL
 	select LLC
 	---help---
 	  This is support for the Novell networking protocol, IPX, commonly
diff --git a/net/irda/Kconfig b/net/irda/Kconfig
index c8671a7..b92874b 100644
--- a/net/irda/Kconfig
+++ b/net/irda/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig IRDA
-	depends on NET && !S390
+	depends on NET && !S390 && BKL
 	tristate "IrDA (infrared) subsystem support"
 	select CRC_CCITT
 	---help---
diff --git a/net/irda/irnet/Kconfig b/net/irda/irnet/Kconfig
index 28c557f..4646380 100644
--- a/net/irda/irnet/Kconfig
+++ b/net/irda/irnet/Kconfig
@@ -1,6 +1,6 @@
 config IRNET
 	tristate "IrNET protocol"
-	depends on IRDA && PPP
+	depends on IRDA && PPP && BKL
 	help
 	  Say Y here if you want to build support for the IrNET protocol.
 	  To compile it as a module, choose M here: the module will be
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index e6759c9..71f3164 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -4,7 +4,7 @@
 
 config X25
 	tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on EXPERIMENTAL && BKL
 	---help---
 	  X.25 is a set of standardized network protocols, similar in scope to
 	  frame relay; the one physical line from your box to the X.25 network
-- 
1.7.1


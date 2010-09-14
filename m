Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0INT5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:57:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57159 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab0INTza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] BKL: introduce CONFIG_BKL.
Date: Tue, 14 Sep 2010 21:55:24 +0200
Message-Id: <1284494124-7384-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:f9IEX8UTg5sN6KKmpviunD3Vp9n1atORkPsHdRsEID1
 i2xjjD3k8mKGBcR5hQtpkgev0G978pJYe1ColgGo6wSzqDXIjj
 JnvXh//ByhPtTz6SN/GscbjL+Qw/iCEiHpIUs+IiDggKl7i12u
 DrwtzH3hJrYszrNhH62hTw4fomAVY3onscEt8fIibO5Mbf2+Fn
 S0GvyWxNXKsjBFQMAs7Gw==
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

The one exception is file locking, which is practically always
enabled and does a 'select BKL' instead. This effectively forces
CONFIG_BKL to be enabled until we have solved the fs/lockd
mess and can apply the patch that removes the BKL from fs/locks.c.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpu/drm/Kconfig         |    5 ++++-
 drivers/isdn/capi/Kconfig       |    2 +-
 drivers/media/Kconfig           |    1 +
 drivers/net/appletalk/Kconfig   |    1 +
 drivers/staging/cx25821/Kconfig |    1 +
 drivers/staging/easycap/Kconfig |    1 +
 drivers/staging/go7007/Kconfig  |    1 +
 drivers/staging/usbip/Kconfig   |    2 +-
 drivers/usb/gadget/Kconfig      |    2 +-
 fs/Kconfig                      |    1 +
 fs/adfs/Kconfig                 |    1 +
 fs/afs/Kconfig                  |    1 +
 fs/autofs/Kconfig               |    1 +
 fs/autofs4/Kconfig              |    1 +
 fs/ceph/Kconfig                 |    1 +
 fs/coda/Kconfig                 |    1 +
 fs/ecryptfs/Kconfig             |    1 +
 fs/freevxfs/Kconfig             |    1 +
 fs/hpfs/Kconfig                 |    1 +
 fs/jffs2/Kconfig                |    1 +
 fs/ncpfs/Kconfig                |    1 +
 fs/nfs/Kconfig                  |    1 +
 fs/nfsd/Kconfig                 |    1 +
 fs/ocfs2/Kconfig                |    1 +
 fs/qnx4/Kconfig                 |    1 +
 fs/reiserfs/Kconfig             |    1 +
 fs/smbfs/Kconfig                |    1 +
 fs/squashfs/Kconfig             |    1 +
 fs/udf/Kconfig                  |    1 +
 fs/ufs/Kconfig                  |    1 +
 include/linux/smp_lock.h        |    7 +++++--
 init/Kconfig                    |    2 +-
 kernel/trace/Kconfig            |    1 +
 lib/Kconfig.debug               |    9 +++++++++
 net/ipx/Kconfig                 |    1 +
 net/irda/Kconfig                |    1 +
 net/irda/irnet/Kconfig          |    1 +
 net/x25/Kconfig                 |    1 +
 38 files changed, 53 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 4cab0c6..b755301 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -73,7 +73,8 @@ source "drivers/gpu/drm/radeon/Kconfig"
 
 config DRM_I810
 	tristate "Intel I810"
-	depends on DRM && AGP && AGP_INTEL
+	# BKL usage in order to avoid AB-BA deadlocks, may become BROKEN_ON_SMP
+	depends on DRM && AGP && AGP_INTEL && BKL
 	help
 	  Choose this option if you have an Intel I810 graphics card.  If M is
 	  selected, the module will be called i810.  AGP support is required
@@ -86,6 +87,8 @@ choice
 
 config DRM_I830
 	tristate "i830 driver"
+	# BKL usage in order to avoid AB-BA deadlocks, may become BROKEN_ON_SMP
+	depends on BKL
 	help
 	  Choose this option if you have a system that has Intel 830M, 845G,
 	  852GM, 855GM or 865G integrated graphics.  If M is selected, the
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
diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index a28541b..bad2ced 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -19,6 +19,7 @@ comment "Multimedia core support"
 
 config VIDEO_DEV
 	tristate "Video For Linux"
+	depends on BKL # used in many drivers for ioctl handling, need to kill
 	---help---
 	  V4L core support for video capture and overlay devices, webcams and
 	  AM/FM radio cards.
diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
index 0a0e0cd..abe967a 100644
--- a/drivers/net/appletalk/Kconfig
+++ b/drivers/net/appletalk/Kconfig
@@ -3,6 +3,7 @@
 #
 config ATALK
 	tristate "Appletalk protocol support"
+	depends on BKL # used in net/appletalk/ddp.c, probably fixable
 	select LLC
 	---help---
 	  AppleTalk is the protocol that Apple computers can use to communicate
diff --git a/drivers/staging/cx25821/Kconfig b/drivers/staging/cx25821/Kconfig
index df7756a..813cb35 100644
--- a/drivers/staging/cx25821/Kconfig
+++ b/drivers/staging/cx25821/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on BKL # please fix
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
diff --git a/drivers/staging/easycap/Kconfig b/drivers/staging/easycap/Kconfig
index bd96f39..9d5fe4d 100644
--- a/drivers/staging/easycap/Kconfig
+++ b/drivers/staging/easycap/Kconfig
@@ -1,6 +1,7 @@
 config EASYCAP
 	tristate "EasyCAP USB ID 05e1:0408 support"
 	depends on USB && VIDEO_DEV
+	depends on BKL # please fix
 
 	---help---
 	  This is an integrated audio/video driver for EasyCAP cards with
diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index e47f683..75fa468 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
 	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on BKL # please fix
 	depends on SND
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
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
diff --git a/fs/Kconfig b/fs/Kconfig
index 3d18530..56f20ee 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -50,6 +50,7 @@ endif # BLOCK
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EMBEDDED
 	default y
+	select BKL
 	help
 	  This option enables standard file locking support, required
           for filesystems like NFS and for the flock() system
diff --git a/fs/adfs/Kconfig b/fs/adfs/Kconfig
index e55182a..1dd5f34 100644
--- a/fs/adfs/Kconfig
+++ b/fs/adfs/Kconfig
@@ -1,6 +1,7 @@
 config ADFS_FS
 	tristate "ADFS file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
+	depends on BKL # need to fix
 	help
 	  The Acorn Disc Filing System is the standard file system of the
 	  RiscOS operating system which runs on Acorn's ARM-based Risc PC
diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 8f975f2..06e305c 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -1,6 +1,7 @@
 config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
+	depends on BKL # need to fix
 	select AF_RXRPC
 	select DNS_RESOLVER
 	help
diff --git a/fs/autofs/Kconfig b/fs/autofs/Kconfig
index 5f3bea9..480e210 100644
--- a/fs/autofs/Kconfig
+++ b/fs/autofs/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS_FS
 	tristate "Kernel automounter support"
+	depends on BKL # unfixable, just use autofs4
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
diff --git a/fs/autofs4/Kconfig b/fs/autofs4/Kconfig
index 1204d63..a639b21 100644
--- a/fs/autofs4/Kconfig
+++ b/fs/autofs4/Kconfig
@@ -1,5 +1,6 @@
 config AUTOFS4_FS
 	tristate "Kernel automounter version 4 support (also supports v3)"
+	depends on BKL # need to fix
 	help
 	  The automounter is a tool to automatically mount remote file systems
 	  on demand. This implementation is partially kernel-based to reduce
diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index bc87b9c..5172f09 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -1,6 +1,7 @@
 config CEPH_FS
         tristate "Ceph distributed file system (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
+	depends on BKL # need to fix
 	select LIBCRC32C
 	select CRYPTO_AES
 	help
diff --git a/fs/coda/Kconfig b/fs/coda/Kconfig
index c0e5a7f..ee99c5c 100644
--- a/fs/coda/Kconfig
+++ b/fs/coda/Kconfig
@@ -1,6 +1,7 @@
 config CODA_FS
 	tristate "Coda file system support (advanced network fs)"
 	depends on INET
+	depends on BKL # probably unfixable, will become BROKEN_ON_SMP
 	help
 	  Coda is an advanced network file system, similar to NFS in that it
 	  enables you to mount file systems of a remote server and access them
diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
index 1cd6d9d..ddfdfb5 100644
--- a/fs/ecryptfs/Kconfig
+++ b/fs/ecryptfs/Kconfig
@@ -1,6 +1,7 @@
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && KEYS && CRYPTO
+	depends on BKL # need to fix
 	select CRYPTO_ECB
 	select CRYPTO_CBC
 	select CRYPTO_MD5
diff --git a/fs/freevxfs/Kconfig b/fs/freevxfs/Kconfig
index 8dc1cd5..3632242 100644
--- a/fs/freevxfs/Kconfig
+++ b/fs/freevxfs/Kconfig
@@ -1,6 +1,7 @@
 config VXFS_FS
 	tristate "FreeVxFS file system support (VERITAS VxFS(TM) compatible)"
 	depends on BLOCK
+	depends on BKL # lookup/readdir, need to fix
 	help
 	  FreeVxFS is a file system driver that support the VERITAS VxFS(TM)
 	  file system format.  VERITAS VxFS(TM) is the standard file system
diff --git a/fs/hpfs/Kconfig b/fs/hpfs/Kconfig
index 56bd15c..a1f68ea 100644
--- a/fs/hpfs/Kconfig
+++ b/fs/hpfs/Kconfig
@@ -1,6 +1,7 @@
 config HPFS_FS
 	tristate "OS/2 HPFS file system support"
 	depends on BLOCK
+	depends on BKL # probably unfixable, will become BROKEN_ON_SMP
 	help
 	  OS/2 is IBM's operating system for PC's, the same as Warp, and HPFS
 	  is the file system used for organizing files on OS/2 hard disk
diff --git a/fs/jffs2/Kconfig b/fs/jffs2/Kconfig
index 6ae169c..b9afb6e 100644
--- a/fs/jffs2/Kconfig
+++ b/fs/jffs2/Kconfig
@@ -1,6 +1,7 @@
 config JFFS2_FS
 	tristate "Journalling Flash File System v2 (JFFS2) support"
 	select CRC32
+	depends on BKL # from pushdown, need to fix
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
index 6c2aad4..10b9524 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -1,6 +1,7 @@
 config NFS_FS
 	tristate "NFS client support"
 	depends on INET && FILE_LOCKING
+	depends on BKL # fix as soon as lockd is done
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 95932f5..429d4a1 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -2,6 +2,7 @@ config NFSD
 	tristate "NFS server support"
 	depends on INET
 	depends on FILE_LOCKING
+	depends on BKL # fix as soon as lockd is done
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 0d84066..20a1f1b 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,5 +1,6 @@
 config OCFS2_FS
 	tristate "OCFS2 file system support"
+	depends on BKL # from pushdown, need to fix
 	depends on NET && SYSFS
 	select CONFIGFS_FS
 	select JBD2
diff --git a/fs/qnx4/Kconfig b/fs/qnx4/Kconfig
index 5f60899..1b86b15 100644
--- a/fs/qnx4/Kconfig
+++ b/fs/qnx4/Kconfig
@@ -1,5 +1,6 @@
 config QNX4FS_FS
 	tristate "QNX4 file system support (read only)"
+	depends on BKL # need to fix or will become BROKEN_ON_SMP
 	depends on BLOCK
 	help
 	  This is the file system used by the real-time operating systems
diff --git a/fs/reiserfs/Kconfig b/fs/reiserfs/Kconfig
index 513f431..342a59d 100644
--- a/fs/reiserfs/Kconfig
+++ b/fs/reiserfs/Kconfig
@@ -1,5 +1,6 @@
 config REISERFS_FS
 	tristate "Reiserfs support"
+	depends on BKL # trivial
 	select CRC32
 	help
 	  Stores not just filenames but the files themselves in a balanced
diff --git a/fs/smbfs/Kconfig b/fs/smbfs/Kconfig
index e668127..2bc24a8 100644
--- a/fs/smbfs/Kconfig
+++ b/fs/smbfs/Kconfig
@@ -1,5 +1,6 @@
 config SMB_FS
 	tristate "SMB file system support (OBSOLETE, please use CIFS)"
+	depends on BKL # probably unfixable
 	depends on INET
 	select NLS
 	help
diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index e5f63da..33dbe68 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -1,6 +1,7 @@
 config SQUASHFS
 	tristate "SquashFS 4.0 - Squashed file system support"
 	depends on BLOCK
+	depends on BKL # trivial to fix
 	select ZLIB_INFLATE
 	help
 	  Saying Y here includes support for SquashFS 4.0 (a Compressed
diff --git a/fs/udf/Kconfig b/fs/udf/Kconfig
index 0e0e99b..f8def3c 100644
--- a/fs/udf/Kconfig
+++ b/fs/udf/Kconfig
@@ -1,5 +1,6 @@
 config UDF_FS
 	tristate "UDF file system support"
+	depends on BKL # needs serious work to remove
 	select CRC_ITU_T
 	help
 	  This is the new file system used on some CD-ROMs and DVDs. Say Y if
diff --git a/fs/ufs/Kconfig b/fs/ufs/Kconfig
index e4f10a4..5061244 100644
--- a/fs/ufs/Kconfig
+++ b/fs/ufs/Kconfig
@@ -1,6 +1,7 @@
 config UFS_FS
 	tristate "UFS file system support (read only)"
 	depends on BLOCK
+	depends on BKL # probably unfixable, will become BROKEN_ON_SMP
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
index 2de5b1c..2005a1d 100644
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
index 538501c..65d4023 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -327,6 +327,7 @@ config BLK_DEV_IO_TRACE
 	bool "Support for tracing block IO actions"
 	depends on SYSFS
 	depends on BLOCK
+	depends on BKL # please use bd_mutex instead
 	select RELAY
 	select DEBUG_FS
 	select TRACEPOINTS
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1b4afd2..088eea1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
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
index e9ad006..02549cb 100644
--- a/net/ipx/Kconfig
+++ b/net/ipx/Kconfig
@@ -3,6 +3,7 @@
 #
 config IPX
 	tristate "The IPX protocol"
+	depends on BKL # should be fixable
 	select LLC
 	---help---
 	  This is support for the Novell networking protocol, IPX, commonly
diff --git a/net/irda/Kconfig b/net/irda/Kconfig
index c8671a7..073243f 100644
--- a/net/irda/Kconfig
+++ b/net/irda/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig IRDA
 	depends on NET && !S390
+	depends on BKL # should be fixable
 	tristate "IrDA (infrared) subsystem support"
 	select CRC_CCITT
 	---help---
diff --git a/net/irda/irnet/Kconfig b/net/irda/irnet/Kconfig
index 28c557f..b1e68c1 100644
--- a/net/irda/irnet/Kconfig
+++ b/net/irda/irnet/Kconfig
@@ -1,6 +1,7 @@
 config IRNET
 	tristate "IrNET protocol"
 	depends on IRDA && PPP
+	depends on BKL # might need to lock against AF_IRDA
 	help
 	  Say Y here if you want to build support for the IrNET protocol.
 	  To compile it as a module, choose M here: the module will be
diff --git a/net/x25/Kconfig b/net/x25/Kconfig
index e6759c9..2196e55 100644
--- a/net/x25/Kconfig
+++ b/net/x25/Kconfig
@@ -5,6 +5,7 @@
 config X25
 	tristate "CCITT X.25 Packet Layer (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
+	depends on BKL # should be fixable
 	---help---
 	  X.25 is a set of standardized network protocols, similar in scope to
 	  frame relay; the one physical line from your box to the X.25 network
-- 
1.7.1


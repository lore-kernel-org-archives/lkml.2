Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1F3LBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:01:46 -0400
Received: from bar.sig21.net ([80.81.252.164]:57372 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1F3LBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:01:41 -0400
Date: Thu, 30 Jun 2011 13:01:35 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] compat_ioctl: fix warning caused by qemu
Message-ID: <20110630110135.GB3755@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -3.8 (---)
X-Spam-21-Report: No, score=-3.8 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.637,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Linux x86_64 host with 32bit userspace, running
qemu or even just "qemu-img create -f qcow2 some.img 1G"
causes a kernel warning:

ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(00005326){t:'S';sz:0} arg(7fffffff) on some.img
ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(801c0204){t:02;sz:28} arg(fff77350) on some.img

ioctl 00005326 is CDROM_DRIVE_STATUS,
ioctl 801c0204 is FDGETPRM.

The warning appears because the Linux compat-ioctl handler for these
ioctls only applies to block devices, while qemu also uses the ioctls on
plain files.

Signed-off-by: Johannes Stezenbach <js@sig21.net>
---
discussed in http://lkml.kernel.org/r/20110617090424.GA19345@sig21.net

Arnd, is this what you had in mind, or did you mean to move
all floppy compat definitions?  I decided to go with the
minimal change.  Tested on both 2.6.39.2 and 3.0-rc5-63-g0d72c6f.


diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index cc3eb78..7b72502 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -208,19 +208,6 @@ static int compat_blkpg_ioctl(struct block_device *bdev, fmode_t mode,
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
 
-struct compat_floppy_struct {
-	compat_uint_t	size;
-	compat_uint_t	sect;
-	compat_uint_t	head;
-	compat_uint_t	track;
-	compat_uint_t	stretch;
-	unsigned char	gap;
-	unsigned char	rate;
-	unsigned char	spec1;
-	unsigned char	fmt_gap;
-	const compat_caddr_t name;
-};
-
 struct compat_floppy_drive_params {
 	char		cmos;
 	compat_ulong_t	max_dtr;
@@ -288,7 +275,6 @@ struct compat_floppy_write_errors {
 
 #define FDSETPRM32 _IOW(2, 0x42, struct compat_floppy_struct)
 #define FDDEFPRM32 _IOW(2, 0x43, struct compat_floppy_struct)
-#define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
 #define FDSETDRVPRM32 _IOW(2, 0x90, struct compat_floppy_drive_params)
 #define FDGETDRVPRM32 _IOR(2, 0x11, struct compat_floppy_drive_params)
 #define FDGETDRVSTAT32 _IOR(2, 0x12, struct compat_floppy_drive_struct)
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 61abb63..8be086e 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -68,6 +68,8 @@
 
 #ifdef CONFIG_BLOCK
 #include <linux/loop.h>
+#include <linux/cdrom.h>
+#include <linux/fd.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
@@ -944,6 +946,9 @@ COMPATIBLE_IOCTL(FIOQSIZE)
 IGNORE_IOCTL(LOOP_CLR_FD)
 /* md calls this on random blockdevs */
 IGNORE_IOCTL(RAID_VERSION)
+/* qemu/qemu-img might call these two on plain files for probing */
+IGNORE_IOCTL(CDROM_DRIVE_STATUS)
+IGNORE_IOCTL(FDGETPRM32)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
diff --git a/include/linux/fd.h b/include/linux/fd.h
index f5d194a..c6a68d0 100644
--- a/include/linux/fd.h
+++ b/include/linux/fd.h
@@ -3,6 +3,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/compiler.h>
+#include <linux/compat.h>
 
 /* New file layout: Now the ioctl definitions immediately follow the
  * definitions of the structures that they use */
@@ -377,4 +378,21 @@ struct floppy_raw_cmd {
 #define FDEJECT _IO(2, 0x5a)
 /* eject the disk */
 
+#ifdef CONFIG_COMPAT
+struct compat_floppy_struct {
+	compat_uint_t	size;
+	compat_uint_t	sect;
+	compat_uint_t	head;
+	compat_uint_t	track;
+	compat_uint_t	stretch;
+	unsigned char	gap;
+	unsigned char	rate;
+	unsigned char	spec1;
+	unsigned char	fmt_gap;
+	const compat_caddr_t name;
+};
+
+#define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
+#endif
+
 #endif

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965598Ab2CAVy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:54:29 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965521Ab2CAVug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.125.133 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213927.083689176@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 30/34] compat: fix compile breakage on s390
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 048cd4e51d24ebf7f3552226d03c769d6ad91658 upstream.

The new is_compat_task() define for the !COMPAT case in
include/linux/compat.h conflicts with a similar define in
arch/s390/include/asm/compat.h.

This is the minimal patch which fixes the build issues.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/compat.h  |    7 -------
 arch/s390/kernel/process.c      |    1 -
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/s390/kernel/setup.c        |    2 +-
 arch/s390/mm/mmap.c             |    2 +-
 drivers/s390/block/dasd_eckd.c  |    1 +
 drivers/s390/block/dasd_ioctl.c |    1 +
 drivers/s390/char/fs3270.c      |    1 +
 drivers/s390/char/vmcp.c        |    1 +
 drivers/s390/cio/chsc_sch.c     |    1 +
 drivers/s390/scsi/zfcp_cfdc.c   |    1 +
 11 files changed, 9 insertions(+), 11 deletions(-)

--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -171,13 +171,6 @@ static inline int is_compat_task(void)
 	return test_thread_flag(TIF_31BIT);
 }
 
-#else
-
-static inline int is_compat_task(void)
-{
-	return 0;
-}
-
 #endif
 
 static inline void __user *arch_compat_alloc_user_space(long len)
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -32,7 +32,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
-#include <asm/compat.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -36,8 +36,8 @@
 #include <linux/regset.h>
 #include <linux/tracehook.h>
 #include <linux/seccomp.h>
+#include <linux/compat.h>
 #include <trace/syscall.h>
-#include <asm/compat.h>
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <linux/reboot.h>
 #include <linux/topology.h>
 #include <linux/ftrace.h>
+#include <linux/compat.h>
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
@@ -56,7 +57,6 @@
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/ebcdic.h>
-#include <asm/compat.h>
 #include <asm/kvm_virtio.h>
 
 long psw_kernel_bits	= (PSW_BASE_BITS | PSW_MASK_DAT | PSW_ASC_PRIMARY |
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,8 +27,8 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <asm/pgalloc.h>
-#include <asm/compat.h>
 
 /*
  * Top of mmap area (just below the process stack).
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -19,6 +19,7 @@
 #include <linux/bio.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/compat.h>
 
 #include <asm/debug.h>
 #include <asm/idals.h>
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -13,6 +13,7 @@
 #define KMSG_COMPONENT "dasd"
 
 #include <linux/interrupt.h>
+#include <linux/compat.h>
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/blkpg.h>
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -14,6 +14,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -16,6 +16,7 @@
 
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
+#include <linux/compat.h>
 
 #include <asm/cio.h>
 #include <asm/chsc.h>
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -12,6 +12,7 @@
 
 #include <linux/types.h>
 #include <linux/miscdevice.h>
+#include <linux/compat.h>
 #include <asm/ccwdev.h>
 #include "zfcp_def.h"
 #include "zfcp_ext.h"



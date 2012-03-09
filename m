Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031383Ab2CITvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:51:04 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43659 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031359Ab2CITu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:50:57 -0500
Message-Id: <20120309190202.672211571@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 04/95] compat: fix compile breakage on s390
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
 arch/s390/kernel/signal.c       |    1 -
 arch/s390/mm/fault.c            |    1 -
 arch/s390/mm/mmap.c             |    2 +-
 drivers/s390/block/dasd_eckd.c  |    2 +-
 drivers/s390/block/dasd_ioctl.c |    1 +
 drivers/s390/char/fs3270.c      |    1 +
 drivers/s390/char/vmcp.c        |    1 +
 drivers/s390/cio/chsc_sch.c     |    1 +
 drivers/s390/scsi/zfcp_cfdc.c   |    1 +
 13 files changed, 9 insertions(+), 14 deletions(-)

--- a/arch/s390/include/asm/compat.h
+++ b/arch/s390/include/asm/compat.h
@@ -172,13 +172,6 @@ static inline int is_compat_task(void)
 	return is_32bit_task();
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
@@ -29,7 +29,6 @@
 #include <asm/irq.h>
 #include <asm/timer.h>
 #include <asm/nmi.h>
-#include <asm/compat.h>
 #include <asm/smp.h>
 #include "entry.h"
 
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -20,8 +20,8 @@
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
@@ -45,6 +45,7 @@
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/memory.h>
+#include <linux/compat.h>
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
@@ -58,7 +59,6 @@
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/ebcdic.h>
-#include <asm/compat.h>
 #include <asm/kvm_virtio.h>
 #include <asm/diag.h>
 
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -30,7 +30,6 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/lowcore.h>
-#include <asm/compat.h>
 #include "entry.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -36,7 +36,6 @@
 #include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
-#include <asm/compat.h>
 #include "../kernel/entry.h"
 
 #ifndef CONFIG_64BIT
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -29,8 +29,8 @@
 #include <linux/mman.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/compat.h>
 #include <asm/pgalloc.h>
-#include <asm/compat.h>
 
 static unsigned long stack_maxrandom_size(void)
 {
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -18,12 +18,12 @@
 #include <linux/hdreg.h>	/* HDIO_GETGEO			    */
 #include <linux/bio.h>
 #include <linux/module.h>
+#include <linux/compat.h>
 #include <linux/init.h>
 
 #include <asm/debug.h>
 #include <asm/idals.h>
 #include <asm/ebcdic.h>
-#include <asm/compat.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/cio.h>
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
@@ -11,6 +11,7 @@
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/slab.h>
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -13,6 +13,7 @@
 
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -11,6 +11,7 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>



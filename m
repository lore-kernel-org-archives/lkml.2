Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab2B0JKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:10:07 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:48316 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2B0JKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:10:03 -0500
Date: Mon, 27 Feb 2012 10:09:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andreas Schwab <schwab@linux-m68k.org>, Ian Kent <raven@themaw.net>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] autofs4: fix compilation without CONFIG_COMPAT
Message-ID: <20120227090951.GA2681@osiris.boeblingen.de.ibm.com>
References: <20120221.221609.218135609185671883.davem@davemloft.net>
 <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net>
 <1329890027.2193.48.camel@perseus.themaw.net>
 <1329890251.2193.50.camel@perseus.themaw.net>
 <m2vcmuh8dg.fsf_-_@igel.home>
 <CA+55aFxH4_gucG7vpdV5NJPNHoXy5bSGtr0yHqmobvYO6PmjNw@mail.gmail.com>
 <4F4B30D5.6050305@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4B30D5.6050305@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12022709-3548-0000-0000-00000128A05C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 08:29:25AM +0100, Christian Borntraeger wrote:
> On 26/02/12 02:31, Linus Torvalds wrote:
> >  
> > +#else
> > +
> > +#define is_compat_task() (0)
> > +
> 
> Linus,
> 
> this breaks 32bit builds of s390 (and maybe others), since several platforms already
> define a is_compat_task.

It breaks only !COMPAT builds on s390, since only we have the is_compat_task()
function defined for !COMPAT. The reason for that was simply to get rid of a
couple of ugly  #ifdefs.
Note, that we still need to include asm/compat.h in some file since we need the
compat_ptr typedef.
That might be ugly, but I preferred including that header file so we could get
rid of the #ifdefs.
Anyway... the patch below fixes the build issues:

>From 5f96c00c9ace3935eb52ce6bdf25a4171f867f4a Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 27 Feb 2012 10:01:52 +0100
Subject: [PATCH] compat: fix compile breakage on s390

The new is_compat_task() define for the !COMPAT case in include/linux/compat.h
conflicts with a similar define in arch/s390/include/asm/compat.h.
This is the minimal patch which fixes the build issues.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
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

diff --git a/arch/s390/include/asm/compat.h b/arch/s390/include/asm/compat.h
index 2e49748..234f1d8 100644
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
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 4261aa7..e795933 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -29,7 +29,6 @@
 #include <asm/irq.h>
 #include <asm/timer.h>
 #include <asm/nmi.h>
-#include <asm/compat.h>
 #include <asm/smp.h>
 #include "entry.h"
 
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 9d82ed4..61f9548 100644
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
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 354de07..3b2efc8 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -46,6 +46,7 @@
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/memory.h>
+#include <linux/compat.h>
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
@@ -59,7 +60,6 @@
 #include <asm/ptrace.h>
 #include <asm/sections.h>
 #include <asm/ebcdic.h>
-#include <asm/compat.h>
 #include <asm/kvm_virtio.h>
 #include <asm/diag.h>
 
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index a8ba840..2d421d9 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -30,7 +30,6 @@
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/lowcore.h>
-#include <asm/compat.h>
 #include "entry.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 354dd39..e8fcd92 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -36,7 +36,6 @@
 #include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
-#include <asm/compat.h>
 #include "../kernel/entry.h"
 
 #ifndef CONFIG_64BIT
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index f09c748..a0155c0 100644
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
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 70880be..2617b1e 100644
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
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index f1a2016..792c69e 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -13,6 +13,7 @@
 #define KMSG_COMPONENT "dasd"
 
 #include <linux/interrupt.h>
+#include <linux/compat.h>
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/blkpg.h>
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index e712981..9117045 100644
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
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index 75bde6a..89c03e6 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -13,6 +13,7 @@
 
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
diff --git a/drivers/s390/cio/chsc_sch.c b/drivers/s390/cio/chsc_sch.c
index 0c87b0f..8f9a1a3 100644
--- a/drivers/s390/cio/chsc_sch.c
+++ b/drivers/s390/cio/chsc_sch.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/compat.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index 303dde0..fab2c25 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -11,6 +11,7 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/compat.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/miscdevice.h>
-- 
1.7.9.1


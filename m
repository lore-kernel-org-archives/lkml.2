Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215Ab0JZRvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:51:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41723 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760176Ab0JZRvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=IR5sOvmfak/0Efd1kA6VYa3v2Kc4jYJsY4qmLofBPq+6SFHOahfeZJzTUhqtKzS0ed
         wakVtFm1mAyatbHuGuHw1bOIGM6VpI650MF55+LdqDGo/KdbS8YzoRg94P8HcJZD61Nb
         L0mbUvOVsybvBBM8j9MYsfVacbcRWZsngNUbY=
From: Rabin Vincent <rabin@rab.in>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin@rab.in>, stable@kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH] kgdb,arm: fix register dump
Date: Tue, 26 Oct 2010 23:19:52 +0530
Message-Id: <1288115392-23383-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DBG_MAX_REG_NUM incorrectly had the number of indices in the GDB regs
array rather than the number of registers, leading to an oops when the
"rd" command is used in KDB.

Cc: stable@kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net
Signed-off-by: Rabin Vincent <rabin@rab.in>
---

Entering kdb (current=0xc0190d10, pid 0) due to Keyboard Entry
kdb> rd
r0: 00000067  r1: 00000001  r2: 20000193  r3: c01acef8  r4: c0196cd8
r5: 00000008  r6: 00000067  r7: 20000193  r8: c019f334  r9: 00000100
r10: 00000001  fp: 00000000  ip: c01a1580  sp: c018fee8  lr: c010229c
pc: c0055c24  f0: ??  f1: ??  f2: ??  f3: ??  f4: ??  f5: ??  f6: ??  f7: ??
fps: 00000000  cpsr: 20000193Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 17 [#1] PREEMPT
last sysfs file: 
KGDB: re-enter exception: ALL breakpoints killed
---[ end trace 6007df365f414cf9 ]---
Kernel panic - not syncing: Fatal exception in interrupt
[<c001e740>] (unwind_backtrace+0x0/0xe4) from [<c011c398>] (panic+0x58/0x180)
[<c011c398>] (panic+0x58/0x180) from [<c001d3ac>] (die+0x17c/0x1c0)
[<c001d3ac>] (die+0x17c/0x1c0) from [<c001f67c>] (__do_kernel_fault+0x64/0x84)
[<c001f67c>] (__do_kernel_fault+0x64/0x84) from [<c001f874>] (do_page_fault+0x1d8/0x1f4)
[<c001f874>] (do_page_fault+0x1d8/0x1f4) from [<c00192d8>] (do_DataAbort+0x34/0x98)
[<c00192d8>] (do_DataAbort+0x34/0x98) from [<c0019aec>] (__dabt_svc+0x4c/0x60)
Exception stack(0xc018fcb0 to 0xc018fcf8)
fca0:                                     00000000 c016549e c018fcec 00000000
fcc0: 0000001d 0000001a 00000138 00000000 00000000 00000000 c0191d78 00000000
fce0: 0000001c c018fcf8 c005a058 c00ee9c4 80000193 ffffffff
[<c0019aec>] (__dabt_svc+0x4c/0x60) from [<c00ee9c4>] (strlen+0xc/0x20)
[<c00ee9c4>] (strlen+0xc/0x20) from [<c005a058>] (kdb_rd+0x40/0x1b0)
[<c005a058>] (kdb_rd+0x40/0x1b0) from [<c005b758>] (kdb_parse+0x4a0/0x5b4)
[<c005b758>] (kdb_parse+0x4a0/0x5b4) from [<c005c348>] (kdb_main_loop+0x454/0x6b8)
[<c005c348>] (kdb_main_loop+0x454/0x6b8) from [<c005e4c8>] (kdb_stub+0x208/0x394)
[<c005e4c8>] (kdb_stub+0x208/0x394) from [<c005679c>] (kgdb_handle_exception+0x3f8/0x5f0)
[<c005679c>] (kgdb_handle_exception+0x3f8/0x5f0) from [<c001df98>] (kgdb_compiled_brk_fn+0x20/0x2c)
[<c001df98>] (kgdb_compiled_brk_fn+0x20/0x2c) from [<c001916c>] (do_undefinstr+0xd8/0x178)
[<c001916c>] (do_undefinstr+0xd8/0x178) from [<c0019c24>] (__und_svc+0x44/0x60)

 arch/arm/include/asm/kgdb.h |    5 +++--
 arch/arm/kernel/kgdb.c      |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 0826599..48066ce 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -70,7 +70,8 @@ extern int kgdb_fault_expected;
 #define _GP_REGS		16
 #define _FP_REGS		8
 #define _EXTRA_REGS		2
-#define DBG_MAX_REG_NUM		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+#define GDB_MAX_REGS		(_GP_REGS + (_FP_REGS * 3) + _EXTRA_REGS)
+#define DBG_MAX_REG_NUM		(_GP_REGS + _FP_REGS + _EXTRA_REGS)
 
 #define KGDB_MAX_NO_CPUS	1
 #define BUFMAX			400
@@ -93,7 +94,7 @@ extern int kgdb_fault_expected;
 #define _SPT			13
 #define _LR			14
 #define _PC			15
-#define _CPSR			(DBG_MAX_REG_NUM - 1)
+#define _CPSR			(GDB_MAX_REGS - 1)
 
 /*
  * So that we can denote the end of a frame for tracing,
diff --git a/arch/arm/kernel/kgdb.c b/arch/arm/kernel/kgdb.c
index d6e8b4d..778c2f7 100644
--- a/arch/arm/kernel/kgdb.c
+++ b/arch/arm/kernel/kgdb.c
@@ -79,7 +79,7 @@ sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *task)
 		return;
 
 	/* Initialize to zero */
-	for (regno = 0; regno < DBG_MAX_REG_NUM; regno++)
+	for (regno = 0; regno < GDB_MAX_REGS; regno++)
 		gdb_regs[regno] = 0;
 
 	/* Otherwise, we have only some registers from switch_to() */
-- 
1.7.2.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637Ab0J2SpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 14:45:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:58744 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761555Ab0J2SpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 14:45:10 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Rabin Vincent <rabin@rab.in>, stable@kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/7] kgdb,arm: fix register dump
Date: Fri, 29 Oct 2010 13:43:37 -0500
Message-Id: <1288377821-24520-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
References: <1288377821-24520-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 29 Oct 2010 18:43:50.0035 (UTC) FILETIME=[3A338E30:01CB7799]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

DBG_MAX_REG_NUM incorrectly had the number of indices in the GDB regs
array rather than the number of registers, leading to an oops when the
"rd" command is used in KDB.

Cc: stable@kernel.org
Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
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
1.6.3.3


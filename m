Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0ESBll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:41:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:41389 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab0ESBlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:41:36 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 4/7] x86,early dr regs,kgdb: Allow kernel debugger early dr register access
Date: Tue, 18 May 2010 20:39:59 -0500
Message-Id: <1274233202-3734-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
References: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:40:09.0188 (UTC) FILETIME=[3730D240:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel debugger was configured, attached and started with
kgdbwait, the hardware breakpoint registers should get restored by the
kgdb code which is managing the dr registers.

CC: x86@kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/cpu/common.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4868e4a..712c1eb 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1084,6 +1084,20 @@ static void clear_all_debug_regs(void)
 	}
 }
 
+#ifdef CONFIG_KGDB
+/*
+ * Restore debug regs if using kgdbwait and you have a kernel debugger
+ * connection established.
+ */
+static void dbg_restore_debug_regs(void)
+{
+	if (unlikely(kgdb_connected && arch_kgdb_ops.correct_hw_break))
+		arch_kgdb_ops.correct_hw_break();
+}
+#else /* ! CONFIG_KGDB */
+#define dbg_restore_debug_regs()
+#endif /* ! CONFIG_KGDB */
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
@@ -1174,18 +1188,8 @@ void __cpuinit cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-#ifdef CONFIG_KGDB
-	/*
-	 * If the kgdb is connected no debug regs should be altered.  This
-	 * is only applicable when KGDB and a KGDB I/O module are built
-	 * into the kernel and you are using early debugging with
-	 * kgdbwait. KGDB will control the kernel HW breakpoint registers.
-	 */
-	if (kgdb_connected && arch_kgdb_ops.correct_hw_break)
-		arch_kgdb_ops.correct_hw_break();
-	else
-#endif
-		clear_all_debug_regs();
+	clear_all_debug_regs();
+	dbg_restore_debug_regs();
 
 	fpu_init();
 
@@ -1239,6 +1243,7 @@ void __cpuinit cpu_init(void)
 #endif
 
 	clear_all_debug_regs();
+	dbg_restore_debug_regs();
 
 	/*
 	 * Force FPU initialization:
-- 
1.6.3.3


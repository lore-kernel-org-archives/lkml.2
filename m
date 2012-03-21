Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124Ab2CURz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:55:56 -0400
Received: from mail1.windriver.com ([147.11.146.13]:60786 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab2CURzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:55:54 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>, <masami.hiramatsu.pt@hitachi.com>,
        <tim.bird@am.sony.com>
Subject: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation using kprobe breakpoints
Date: Wed, 21 Mar 2012 12:55:36 -0500
Message-ID: <1332352536-29186-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com>
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has long been a limitation using software breakpoints with a
kernel compiled with CONFIG_DEBUG_RODATA.  The kprobe breakpoint code
has its own text_poke() function which accommodates writing a
breakpoint into a read-only page.  The debug_core can make use of the
text_poke() capabilities by using the kprobes API, specifically
arch_arm_kprobe() and arch_disarm_kprobe().  For now it is safe to use
a single statically allocated kprobe structure to call the kprobes API
because the debug_core breakpoint API is only used when the kernel is
in the debug state.

The debug_core will first attempt to use the traditional
probe_kernel_write(), and next try using a kprobe breakpoint.  The
kgdb test suite was updated to run all the software breakpoint tests
when using a kernel with built with CONFIG_DEBUG_RODATA.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c     |   13 -------------
 include/linux/kgdb.h      |    3 ++-
 kernel/debug/debug_core.c |   40 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 15 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 3f7ad83..672b4a5 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -940,19 +940,6 @@ static void kgdbts_run_tests(void)
 		run_nmi_sleep_test(nmi_sleep);
 	}
 
-#ifdef CONFIG_DEBUG_RODATA
-	/* Until there is an api to write to read-only text segments, use
-	 * HW breakpoints for the remainder of any tests, else print a
-	 * failure message if hw breakpoints do not work.
-	 */
-	if (!(arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT && hwbreaks_ok)) {
-		eprintk("kgdbts: HW breakpoints do not work,"
-			"skipping remaining tests\n");
-		return;
-	}
-	force_hwbrks = 1;
-#endif /* CONFIG_DEBUG_RODATA */
-
 	/* If the do_fork test is run it will be the last test that is
 	 * executed because a kernel thread will be spawned at the very
 	 * end to unregister the debug hooks.
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index e5d689c..48f17d2 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -63,7 +63,8 @@ enum kgdb_bptype {
 	BP_HARDWARE_BREAKPOINT,
 	BP_WRITE_WATCHPOINT,
 	BP_READ_WATCHPOINT,
-	BP_ACCESS_WATCHPOINT
+	BP_ACCESS_WATCHPOINT,
+	BP_KPROBE_BREAKPOINT,
 };
 
 enum kgdb_bpstate {
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index a7e52ca..9051844 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -49,6 +49,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 #include <linux/rcupdate.h>
+#include <linux/kprobes.h>
 
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
@@ -108,6 +109,13 @@ module_param(kgdbreboot, int, 0644);
 static struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
 	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
 };
+/*
+ * probe_write_tmp is used to r/w breakpoints with the kprobe
+ * interface, it is not protected for reentrancy
+ */
+#if defined(CONFIG_KPROBES) && defined(CONFIG_DEBUG_RODATA)
+static struct kprobe probe_write_tmp;
+#endif /* CONFIG_KPROBES && CONFIG_DEBUG_RODATA */
 
 /*
  * The CPU# of the active CPU, or -1 if none:
@@ -165,17 +173,48 @@ int __weak kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
 
+	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
 				BREAK_INSTR_SIZE);
 	if (err)
 		return err;
 	err = probe_kernel_write((char *)bpt->bpt_addr,
 				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
+#if defined(CONFIG_KPROBES) && defined(CONFIG_DEBUG_RODATA)
+	if (!err)
+		return err;
+	probe_write_tmp.addr = (kprobe_opcode_t *)bpt->bpt_addr;
+	arch_arm_kprobe(&probe_write_tmp);
+	err = probe_kernel_read(&probe_write_tmp.opcode, (char *)bpt->bpt_addr,
+				BREAK_INSTR_SIZE);
+	if (err)
+		return err;
+	if (memcmp(&probe_write_tmp.opcode, arch_kgdb_ops.gdb_bpt_instr,
+		   BREAK_INSTR_SIZE))
+		return -EINVAL;
+	bpt->type = BP_KPROBE_BREAKPOINT;
+#endif /* CONFIG_KPROBES && CONFIG_DEBUG_RODATA */
 	return err;
 }
 
 int __weak kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
+#if defined(CONFIG_KPROBES) && defined(CONFIG_DEBUG_RODATA)
+	int err;
+
+	if (bpt->type != BP_KPROBE_BREAKPOINT)
+		goto knl_write;
+	probe_write_tmp.addr = (kprobe_opcode_t *)bpt->bpt_addr;
+	memcpy(&probe_write_tmp.opcode, bpt->saved_instr, BREAK_INSTR_SIZE);
+	arch_disarm_kprobe(&probe_write_tmp);
+	err = probe_kernel_read(&probe_write_tmp.opcode, (char *)bpt->bpt_addr,
+				BREAK_INSTR_SIZE);
+	if (err ||
+	    memcmp(&probe_write_tmp.opcode, bpt->saved_instr, BREAK_INSTR_SIZE))
+		goto knl_write;
+	return err;
+knl_write:
+#endif /* CONFIG_KPROBES && CONFIG_DEBUG_RODATA */
 	return probe_kernel_write((char *)bpt->bpt_addr,
 				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
 }
@@ -294,7 +333,6 @@ int dbg_set_sw_break(unsigned long addr)
 		return -E2BIG;
 
 	kgdb_break[breakno].state = BP_SET;
-	kgdb_break[breakno].type = BP_BREAKPOINT;
 	kgdb_break[breakno].bpt_addr = addr;
 
 	return 0;
-- 
1.7.5.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab2CUR4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:56:23 -0400
Received: from mail.windriver.com ([147.11.1.11]:43315 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab2CURzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:55:55 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>, <masami.hiramatsu.pt@hitachi.com>,
        <tim.bird@am.sony.com>
Subject: [PATCH 1/2] kgdb,debug_core: pass the breakpoint struct instead of address and memory
Date: Wed, 21 Mar 2012 12:55:35 -0500
Message-ID: <1332352536-29186-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com>
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is extra state information that needs to be exposed in the
kgdb_bpt structure for tracking whether or not a breakpoint was
installed via a kprobe or via a probe_kernel_write().  In order to
access the structure it needs to be passed to the
kgdb_arch_set_breakpoint() and kgdb_arch_remove_breakpoint().

A future commit adds the logic for the kprobe breakpoint type.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 include/linux/kgdb.h      |    4 +-
 kernel/debug/debug_core.c |   53 ++++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index fa39183..e5d689c 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -207,8 +207,8 @@ extern void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long pc);
 
 /* Optional functions. */
 extern int kgdb_validate_break_address(unsigned long addr);
-extern int kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr);
-extern int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle);
+extern int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt);
+extern int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt);
 
 /**
  *	kgdb_arch_late - Perform any architecture specific initalization.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 3f88a45..a7e52ca 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -161,37 +161,39 @@ early_param("nokgdbroundup", opt_nokgdbroundup);
  * Weak aliases for breakpoint management,
  * can be overriden by architectures when needed:
  */
-int __weak kgdb_arch_set_breakpoint(unsigned long addr, char *saved_instr)
+int __weak kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
 
-	err = probe_kernel_read(saved_instr, (char *)addr, BREAK_INSTR_SIZE);
+	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
+				BREAK_INSTR_SIZE);
 	if (err)
 		return err;
-
-	return probe_kernel_write((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
-				  BREAK_INSTR_SIZE);
+	err = probe_kernel_write((char *)bpt->bpt_addr,
+				 arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE);
+	return err;
 }
 
-int __weak kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
+int __weak kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
-	return probe_kernel_write((char *)addr,
-				  (char *)bundle, BREAK_INSTR_SIZE);
+	return probe_kernel_write((char *)bpt->bpt_addr,
+				  (char *)bpt->saved_instr, BREAK_INSTR_SIZE);
 }
 
 int __weak kgdb_validate_break_address(unsigned long addr)
 {
-	char tmp_variable[BREAK_INSTR_SIZE];
+	struct kgdb_bkpt tmp;
 	int err;
-	/* Validate setting the breakpoint and then removing it.  In the
+	/* Validate setting the breakpoint and then removing it.  If the
 	 * remove fails, the kernel needs to emit a bad message because we
 	 * are deep trouble not being able to put things back the way we
 	 * found them.
 	 */
-	err = kgdb_arch_set_breakpoint(addr, tmp_variable);
+	tmp.bpt_addr = addr;
+	err = kgdb_arch_set_breakpoint(&tmp);
 	if (err)
 		return err;
-	err = kgdb_arch_remove_breakpoint(addr, tmp_variable);
+	err = kgdb_arch_remove_breakpoint(&tmp);
 	if (err)
 		printk(KERN_ERR "KGDB: Critical breakpoint error, kernel "
 		   "memory destroyed at: %lx", addr);
@@ -235,7 +237,6 @@ static void kgdb_flush_swbreak_addr(unsigned long addr)
  */
 int dbg_activate_sw_breakpoints(void)
 {
-	unsigned long addr;
 	int error;
 	int ret = 0;
 	int i;
@@ -244,16 +245,15 @@ int dbg_activate_sw_breakpoints(void)
 		if (kgdb_break[i].state != BP_SET)
 			continue;
 
-		addr = kgdb_break[i].bpt_addr;
-		error = kgdb_arch_set_breakpoint(addr,
-				kgdb_break[i].saved_instr);
+		error = kgdb_arch_set_breakpoint(&kgdb_break[i]);
 		if (error) {
 			ret = error;
-			printk(KERN_INFO "KGDB: BP install failed: %lx", addr);
+			printk(KERN_INFO "KGDB: BP install failed: %lx",
+			       kgdb_break[i].bpt_addr);
 			continue;
 		}
 
-		kgdb_flush_swbreak_addr(addr);
+		kgdb_flush_swbreak_addr(kgdb_break[i].bpt_addr);
 		kgdb_break[i].state = BP_ACTIVE;
 	}
 	return ret;
@@ -302,7 +302,6 @@ int dbg_set_sw_break(unsigned long addr)
 
 int dbg_deactivate_sw_breakpoints(void)
 {
-	unsigned long addr;
 	int error;
 	int ret = 0;
 	int i;
@@ -310,15 +309,14 @@ int dbg_deactivate_sw_breakpoints(void)
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
 		if (kgdb_break[i].state != BP_ACTIVE)
 			continue;
-		addr = kgdb_break[i].bpt_addr;
-		error = kgdb_arch_remove_breakpoint(addr,
-					kgdb_break[i].saved_instr);
+		error = kgdb_arch_remove_breakpoint(&kgdb_break[i]);
 		if (error) {
-			printk(KERN_INFO "KGDB: BP remove failed: %lx\n", addr);
+			printk(KERN_INFO "KGDB: BP remove failed: %lx\n",
+			       kgdb_break[i].bpt_addr);
 			ret = error;
 		}
 
-		kgdb_flush_swbreak_addr(addr);
+		kgdb_flush_swbreak_addr(kgdb_break[i].bpt_addr);
 		kgdb_break[i].state = BP_SET;
 	}
 	return ret;
@@ -352,7 +350,6 @@ int kgdb_isremovedbreak(unsigned long addr)
 
 int dbg_remove_all_break(void)
 {
-	unsigned long addr;
 	int error;
 	int i;
 
@@ -360,12 +357,10 @@ int dbg_remove_all_break(void)
 	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++) {
 		if (kgdb_break[i].state != BP_ACTIVE)
 			goto setundefined;
-		addr = kgdb_break[i].bpt_addr;
-		error = kgdb_arch_remove_breakpoint(addr,
-				kgdb_break[i].saved_instr);
+		error = kgdb_arch_remove_breakpoint(&kgdb_break[i]);
 		if (error)
 			printk(KERN_ERR "KGDB: breakpoint remove failed: %lx\n",
-			   addr);
+			       kgdb_break[i].bpt_addr);
 setundefined:
 		kgdb_break[i].state = BP_UNDEFINED;
 	}
-- 
1.7.5.4


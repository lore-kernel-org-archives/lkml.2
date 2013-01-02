Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3ABVVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:21:18 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62630 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3ABVVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:21:16 -0500
From: Matt Klein <mklein@twitter.com>
To: linux-kernel@vger.kernel.org
Cc: jason.wessel@windriver.com, Matt Klein <mklein@twitter.com>
Subject: [PATCH] kgdb,kdb: Setup basic kdb state before invoking commands via kgdb
Date: Wed,  2 Jan 2013 13:20:49 -0800
Message-Id: <1357161649-42894-1-git-send-email-mklein@twitter.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although invasive kdb commands are not supported via kgdb, some useful
non-invasive commands like bt* require basic kdb state to be setup before
calling into the kdb code. Factor out some of this code and call it before
and after executing kdb commands via kgdb.

Signed-off-by: Matt Klein <mklein@twitter.com>
---
 kernel/debug/debug_core.h       |  2 ++
 kernel/debug/gdbstub.c          |  7 +++++++
 kernel/debug/kdb/kdb_debugger.c | 24 ++++++++++++++++++------
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 3494c28..2235967 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -72,6 +72,8 @@ extern int dbg_kdb_mode;
 #ifdef CONFIG_KGDB_KDB
 extern int kdb_stub(struct kgdb_state *ks);
 extern int kdb_parse(const char *cmdstr);
+extern int kdb_common_init_state(struct kgdb_state *ks);
+extern int kdb_common_deinit_state(void);
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index ce615e0..3c96043 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -782,7 +782,14 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 			len = len / 2;
 			remcom_out_buffer[len++] = 0;
 
+			/*
+			 * Although invasive kdb commands are not supported via kgdb,
+			 * some non-invasive commands need basic setup (e.g., bt*),
+			 * so do that before calling into the kdb code. */
+			kdb_common_init_state(ks);
 			kdb_parse(remcom_out_buffer);
+			kdb_common_deinit_state();
+
 			strcpy(remcom_out_buffer, "OK");
 		}
 		break;
diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index be7b33b..9ac1e7f 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -34,6 +34,22 @@ EXPORT_SYMBOL_GPL(kdb_poll_idx);
 
 static struct kgdb_state *kdb_ks;
 
+int kdb_common_init_state(struct kgdb_state *ks)
+{
+	kdb_initial_cpu = atomic_read(&kgdb_active);
+	kdb_current_task = kgdb_info[ks->cpu].task;
+	kdb_current_regs = kgdb_info[ks->cpu].debuggerinfo;
+	return 0;
+}
+
+int kdb_common_deinit_state()
+{
+	kdb_initial_cpu = -1;
+	kdb_current_task = NULL;
+	kdb_current_regs = NULL;
+	return 0;
+}
+
 int kdb_stub(struct kgdb_state *ks)
 {
 	int error = 0;
@@ -94,9 +110,7 @@ int kdb_stub(struct kgdb_state *ks)
 	}
 	/* Set initial kdb state variables */
 	KDB_STATE_CLEAR(KGDB_TRANS);
-	kdb_initial_cpu = atomic_read(&kgdb_active);
-	kdb_current_task = kgdb_info[ks->cpu].task;
-	kdb_current_regs = kgdb_info[ks->cpu].debuggerinfo;
+	kdb_common_init_state(ks);
 	/* Remove any breakpoints as needed by kdb and clear single step */
 	kdb_bp_remove();
 	KDB_STATE_CLEAR(DOING_SS);
@@ -125,9 +139,7 @@ int kdb_stub(struct kgdb_state *ks)
 	 * Upon exit from the kdb main loop setup break points and restart
 	 * the system based on the requested continue state
 	 */
-	kdb_initial_cpu = -1;
-	kdb_current_task = NULL;
-	kdb_current_regs = NULL;
+	kdb_common_deinit_state();
 	KDB_STATE_CLEAR(PAGER);
 	kdbnearsym_cleanup();
 	if (error == KDB_CMD_KGDB) {
-- 
1.8.1


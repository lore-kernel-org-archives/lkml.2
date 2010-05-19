Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0ESBrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:47:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:41114 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0ESBkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:05 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 13/25] kgdb: gdb "monitor" -> kdb passthrough
Date: Tue, 18 May 2010 20:39:23 -0500
Message-Id: <1274233175-3675-14-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:52.0313 (UTC) FILETIME=[2D21E690:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the driving forces behind integrating another front end (kdb)
to the debug core is to allow front end commands to be accessible via
gdb's monitor command.  It is true that you could write gdb macros to
get certain data, but you may want to just use gdb to access the
commands that are available in the kdb front end.

This patch implements the Rcmd gdb stub packet.  In gdb you access
this with the "monitor" command.  For instance you could type "monitor
help", "monitor lsmod" or "monitor ps A" etc...

There is no error checking or command restrictions on what you can and
cannot access at this point.  Doing something like trying to set
breakpoints with the monitor command is going to cause nothing but
problems.  Perhaps in the future only the commands that are actually
known to work with the gdb monitor command will be available.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c      |    2 +-
 kernel/debug/debug_core.h      |    2 ++
 kernel/debug/gdbstub.c         |   22 ++++++++++++++++++++++
 kernel/debug/kdb/kdb_io.c      |   13 +++++++++----
 kernel/debug/kdb/kdb_private.h |    1 -
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1d71df6..1aed37b 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -82,7 +82,7 @@ static int kgdb_use_con;
 int dbg_switch_cpu;
 
 /* Use kdb or gdbserver mode */
-static int dbg_kdb_mode = 1;
+int dbg_kdb_mode = 1;
 
 static int __init opt_kgdb_con(char *str)
 {
diff --git a/kernel/debug/debug_core.h b/kernel/debug/debug_core.h
index 44cf3de..c5d753d 100644
--- a/kernel/debug/debug_core.h
+++ b/kernel/debug/debug_core.h
@@ -66,9 +66,11 @@ extern void gdbstub_msg_write(const char *s, int len);
 
 /* gdbstub functions used for kdb <-> gdbstub transition */
 extern int gdbstub_state(struct kgdb_state *ks, char *cmd);
+extern int dbg_kdb_mode;
 
 #ifdef CONFIG_KGDB_KDB
 extern int kdb_stub(struct kgdb_state *ks);
+extern int kdb_parse(const char *cmdstr);
 #else /* ! CONFIG_KGDB_KDB */
 static inline int kdb_stub(struct kgdb_state *ks)
 {
diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index 3c00049..4b17b32 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -201,6 +201,9 @@ void gdbstub_msg_write(const char *s, int len)
 	int wcount;
 	int i;
 
+	if (len == 0)
+		len = strlen(s);
+
 	/* 'O'utput */
 	gdbmsgbuf[0] = 'O';
 
@@ -685,6 +688,25 @@ static void gdb_cmd_query(struct kgdb_state *ks)
 			kgdb_mem2hex(tmpstr, remcom_out_buffer, strlen(tmpstr));
 		}
 		break;
+#ifdef CONFIG_KGDB_KDB
+	case 'R':
+		if (strncmp(remcom_in_buffer, "qRcmd,", 6) == 0) {
+			int len = strlen(remcom_in_buffer + 6);
+
+			if ((len % 2) != 0) {
+				strcpy(remcom_out_buffer, "E01");
+				break;
+			}
+			kgdb_hex2mem(remcom_in_buffer + 6,
+				     remcom_out_buffer, len);
+			len = len / 2;
+			remcom_out_buffer[len++] = 0;
+
+			kdb_parse(remcom_out_buffer);
+			strcpy(remcom_out_buffer, "OK");
+		}
+		break;
+#endif
 	}
 }
 
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 9e3cec7..8339b29 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/nmi.h>
 #include <linux/delay.h>
+#include <linux/kgdb.h>
 #include <linux/kdb.h>
 #include <linux/kallsyms.h>
 #include "kdb_private.h"
@@ -669,10 +670,14 @@ kdb_printit:
 	 * Write to all consoles.
 	 */
 	retlen = strlen(kdb_buffer);
-	while (c) {
-		c->write(c, kdb_buffer, retlen);
-		touch_nmi_watchdog();
-		c = c->next;
+	if (!dbg_kdb_mode && kgdb_connected) {
+		gdbstub_msg_write(kdb_buffer, retlen);
+	} else {
+		while (c) {
+			c->write(c, kdb_buffer, retlen);
+			touch_nmi_watchdog();
+			c = c->next;
+		}
 	}
 	if (logging) {
 		saved_loglevel = console_loglevel;
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 69ed2ef..97d3ba6 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -254,7 +254,6 @@ extern unsigned long kdb_task_state(const struct task_struct *p,
 				    unsigned long mask);
 extern void kdb_ps_suppressed(void);
 extern void kdb_ps1(const struct task_struct *p);
-extern int kdb_parse(const char *cmdstr);
 extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
 extern void kdb_meminfo_proc_show(void);
-- 
1.6.3.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2BRCHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 21:07:45 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:51457 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606Ab2BRCHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 21:07:23 -0500
From: Andrei Warkentin <andreiw@vmware.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        andreiw@vmware.com
Subject: [PATCH 1/2] KDB: Make LINES an internal variable.
Date: Fri, 17 Feb 2012 21:07:15 -0500
Message-Id: <1329530836-23958-2-git-send-email-andreiw@vmware.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1329530836-23958-1-git-send-email-andreiw@vmware.com>
References: <1329530836-23958-1-git-send-email-andreiw@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) If you run 'dumpall', LINES will remain set to
   10000, and you might wonder why dmesg now doesn't
   page.
2) If you run any command that sets LINES, you will
   eventually exhaust the heap.

To address (1), you can save and restore across
calls to "defcmd" commands, which might contain
"set LINES". This becomes awkward with keeping
LINES in env, but there is no real reason why
LINES cannot be treated as an internal variable.
Additionally, you get rid of the (small) kdb heap
usage for LINES.

Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
---
 kernel/debug/kdb/kdb_io.c      |    4 ++--
 kernel/debug/kdb/kdb_main.c    |   29 ++++++++++++++++++++++++++---
 kernel/debug/kdb/kdb_private.h |    1 +
 3 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 4802eb5..5eb7e23 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -580,8 +580,8 @@ int vkdb_printf(const char *fmt, va_list ap)
 		__acquire(kdb_printf_lock);
 	}
 
-	diag = kdbgetintenv("LINES", &linecount);
-	if (diag || linecount <= 1)
+	linecount = kdb_lines;
+	if (linecount <= 1)
 		linecount = 24;
 
 	diag = kdbgetintenv("LOGGING", &logging);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 63786e7..37f9d45 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -60,6 +60,7 @@ atomic_t kdb_event;
 int kdb_initial_cpu = -1;	/* cpu number that owns kdb */
 int kdb_nextline = 1;
 int kdb_state;			/* General KDB state */
+int kdb_lines = 0;		/* Lines displayed at once */
 
 struct task_struct *kdb_current_task;
 EXPORT_SYMBOL(kdb_current_task);
@@ -386,6 +387,18 @@ int kdb_set(int argc, const char **argv)
 			| (debugflags << KDB_DEBUG_FLAG_SHIFT);
 
 		return 0;
+	} else if (strcmp(argv[1], "LINES") == 0) {
+		int lines;
+		char *cp;
+
+		lines = simple_strtol(argv[2], &cp, 0);
+		if (cp == argv[2]) {
+			kdb_printf("kdb: illegal LINES value '%s'\n",
+				   argv[2]);
+			return 0;
+		}
+		kdb_lines = lines;
+		return 0;
 	}
 
 	/*
@@ -721,8 +734,11 @@ static int kdb_defcmd(int argc, const char **argv)
  */
 static int kdb_exec_defcmd(int argc, const char **argv)
 {
-	int i, ret;
+	int i;
+	int oldlines;
 	struct defcmd_set *s;
+	int ret = 0;
+
 	if (argc != 0)
 		return KDB_ARGCOUNT;
 	for (s = defcmd_set, i = 0; i < defcmd_set_count; ++i, ++s) {
@@ -734,6 +750,9 @@ static int kdb_exec_defcmd(int argc, const char **argv)
 			   argv[0]);
 		return KDB_NOTIMP;
 	}
+
+	/* command might have overridden LINES */
+	oldlines = kdb_lines;
 	for (i = 0; i < s->count; ++i) {
 		/* Recursive use of kdb_parse, do not use argv after
 		 * this point */
@@ -741,9 +760,10 @@ static int kdb_exec_defcmd(int argc, const char **argv)
 		kdb_printf("[%s]kdb> %s\n", s->name, s->command[i]);
 		ret = kdb_parse(s->command[i]);
 		if (ret)
-			return ret;
+			break;
 	}
-	return 0;
+	kdb_lines = oldlines;
+	return ret;
 }
 
 /* Command history */
@@ -2026,6 +2046,9 @@ static int kdb_env(int argc, const char **argv)
 	if (KDB_DEBUG(MASK))
 		kdb_printf("KDBFLAGS=0x%x\n", kdb_flags);
 
+	if (kdb_lines)
+		kdb_printf("LINES=%d\n", kdb_lines);
+
 	return 0;
 }
 
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index e381d10..41a221f 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -154,6 +154,7 @@ extern int kdb_state;
 #define KDB_STATE_CLEAR(flag) ((void)(kdb_state &= ~KDB_STATE_##flag))
 
 extern int kdb_nextline; /* Current number of lines displayed */
+extern int kdb_lines;    /* Limit on number of lines displayed at once. */
 
 typedef struct _kdb_bp {
 	unsigned long	bp_addr;	/* Address breakpoint is present at */
-- 
1.7.4.1


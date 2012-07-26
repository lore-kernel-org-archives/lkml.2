Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab2GZO2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:28:52 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42782 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab2GZO2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:28:50 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/7] kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
Date: Thu, 26 Jul 2012 07:26:26 -0700
Message-Id: <1343312791-9138-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120726142514.GA32158@lizard>
References: <20120726142514.GA32158@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're about to add more options for command behaviour, so let's expand
the meaning of kdb_repeat_t.

So far we just do various renames, there should be no functional changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kdb.h            |    4 ++--
 kernel/debug/kdb/kdb_main.c    |    6 +++---
 kernel/debug/kdb/kdb_private.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 0647258..029219c 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -36,7 +36,7 @@ typedef enum {
 	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
 	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
 	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
-} kdb_repeat_t;
+} kdb_cmdflags_t;
 
 typedef int (*kdb_func_t)(int, const char **);
 
@@ -148,7 +148,7 @@ static inline const char *kdb_walk_kallsyms(loff_t *pos)
 /* Dynamic kdb shell command registration */
 extern int kdb_register(char *, kdb_func_t, char *, char *, short);
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
-			       short, kdb_repeat_t);
+			       short, kdb_cmdflags_t);
 extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
 #define kdb_printf(...)
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index e2b14ea..c8e1c7b 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -991,7 +991,7 @@ int kdb_parse(const char *cmdstr)
 		if (result && ignore_errors && result > KDB_CMD_GO)
 			result = 0;
 		KDB_STATE_CLEAR(CMD);
-		switch (tp->cmd_repeat) {
+		switch (tp->cmd_flags) {
 		case KDB_REPEAT_NONE:
 			argc = 0;
 			if (argv[0])
@@ -2709,7 +2709,7 @@ int kdb_register_repeat(char *cmd,
 			char *usage,
 			char *help,
 			short minlen,
-			kdb_repeat_t repeat)
+			kdb_cmdflags_t flags)
 {
 	int i;
 	kdbtab_t *kp;
@@ -2758,7 +2758,7 @@ int kdb_register_repeat(char *cmd,
 	kp->cmd_usage  = usage;
 	kp->cmd_help   = help;
 	kp->cmd_minlen = minlen;
-	kp->cmd_repeat = repeat;
+	kp->cmd_flags  = flags;
 
 	return 0;
 }
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index b7869c7..9665af6 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -177,7 +177,7 @@ typedef struct _kdbtab {
 	char    *cmd_help;		/* Help message for this command */
 	short    cmd_minlen;		/* Minimum legal # command
 					 * chars required */
-	kdb_repeat_t cmd_repeat;	/* Does command auto repeat on enter? */
+	kdb_cmdflags_t cmd_flags;	/* Command behaviour flags */
 } kdbtab_t;
 
 extern int kdb_bt(int, const char **);	/* KDB display back trace */
-- 
1.7.10.4


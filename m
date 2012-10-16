Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2JPBVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:21:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54132 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2JPBVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:21:16 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Colin Cross <ccross@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/7] kdb: Rename kdb_repeat_t to kdb_cmdflags_t, cmd_repeat to cmd_flags
Date: Mon, 15 Oct 2012 18:18:00 -0700
Message-Id: <1350350285-3095-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <20121016011724.GB23146@lizard>
References: <20121016011724.GB23146@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're about to add more options for command behaviour, so let's expand
the meaning of kdb_repeat_t.

So far we just do various renames, there should be no functional changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kdb.h            | 4 ++--
 kernel/debug/kdb/kdb_main.c    | 6 +++---
 kernel/debug/kdb/kdb_private.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 7f6fe6e..cbd1c28 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -17,7 +17,7 @@ typedef enum {
 	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
 	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
 	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
-} kdb_repeat_t;
+} kdb_cmdflags_t;
 
 typedef int (*kdb_func_t)(int, const char **);
 
@@ -146,7 +146,7 @@ static inline const char *kdb_walk_kallsyms(loff_t *pos)
 /* Dynamic kdb shell command registration */
 extern int kdb_register(char *, kdb_func_t, char *, char *, short);
 extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
-			       short, kdb_repeat_t);
+			       short, kdb_cmdflags_t);
 extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
 static inline __printf(1, 2) int kdb_printf(const char *fmt, ...) { return 0; }
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index cdaaa52..c7a1797 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -992,7 +992,7 @@ int kdb_parse(const char *cmdstr)
 		if (result && ignore_errors && result > KDB_CMD_GO)
 			result = 0;
 		KDB_STATE_CLEAR(CMD);
-		switch (tp->cmd_repeat) {
+		switch (tp->cmd_flags) {
 		case KDB_REPEAT_NONE:
 			argc = 0;
 			if (argv[0])
@@ -2700,7 +2700,7 @@ int kdb_register_repeat(char *cmd,
 			char *usage,
 			char *help,
 			short minlen,
-			kdb_repeat_t repeat)
+			kdb_cmdflags_t flags)
 {
 	int i;
 	kdbtab_t *kp;
@@ -2749,7 +2749,7 @@ int kdb_register_repeat(char *cmd,
 	kp->cmd_usage  = usage;
 	kp->cmd_help   = help;
 	kp->cmd_minlen = minlen;
-	kp->cmd_repeat = repeat;
+	kp->cmd_flags  = flags;
 
 	return 0;
 }
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index f8245b3..9e1b8e9 100644
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
1.7.12.3


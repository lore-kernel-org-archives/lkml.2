Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2KWA5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:57:33 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49988 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab2KWA5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:57:31 -0500
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 4/7] kdb: Use KDB_REPEAT_* values as flags
Date: Thu, 22 Nov 2012 16:53:53 -0800
Message-Id: <1353632036-5354-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <20121123005315.GA12690@lizard.mcd25758.sjc.wayport.net>
References: <20121123005315.GA12690@lizard.mcd25758.sjc.wayport.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual values of KDB_REPEAT_* enum values and overall logic stayed
the same, but we now treat the values as flags.

This makes it possible to add other flags and combine them, plus makes
the code a lot simpler and shorter. But functionality-wise, there should
be no changes.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kdb.h         |  4 ++--
 kernel/debug/kdb/kdb_main.c | 21 +++++++--------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 0142cd3..c6f1ec3 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -15,8 +15,8 @@
 
 typedef enum {
 	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
-	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
-	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
+	KDB_REPEAT_NO_ARGS	= 0x1, /* Repeat the command w/o arguments */
+	KDB_REPEAT_WITH_ARGS	= 0x2, /* Repeat the command w/ its arguments */
 } kdb_cmdflags_t;
 
 typedef int (*kdb_func_t)(int, const char **);
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index bae9a1d..7245bab 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -992,20 +992,13 @@ int kdb_parse(const char *cmdstr)
 		if (result && ignore_errors && result > KDB_CMD_GO)
 			result = 0;
 		KDB_STATE_CLEAR(CMD);
-		switch (tp->cmd_flags) {
-		case KDB_REPEAT_NONE:
-			argc = 0;
-			if (argv[0])
-				*(argv[0]) = '\0';
-			break;
-		case KDB_REPEAT_NO_ARGS:
-			argc = 1;
-			if (argv[1])
-				*(argv[1]) = '\0';
-			break;
-		case KDB_REPEAT_WITH_ARGS:
-			break;
-		}
+
+		if (tp->cmd_flags & KDB_REPEAT_WITH_ARGS)
+			return result;
+
+		argc = tp->cmd_flags & KDB_REPEAT_NO_ARGS ? 1 : 0;
+		if (argv[argc])
+			*(argv[argc]) = '\0';
 		return result;
 	}
 
-- 
1.8.0


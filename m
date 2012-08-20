Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2HTOuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:50:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42679 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2HTOuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:50:06 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 03/12] kdb: Turn KGDB_KDB=n stubs into static inlines
Date: Mon, 20 Aug 2012 07:47:21 -0700
Message-Id: <1345474050-8339-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120820144449.GA32560@lizard>
References: <20120820144449.GA32560@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the stubs actually usable, since e.g. 'foo = kdb_register();'
leads to build errors in !KGDB_KDB case. Plus, with static inlines we
do type checking.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kdb.h | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index 42d9e86..7f6fe6e 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -13,6 +13,14 @@
  * Copyright (C) 2009 Jason Wessel <jason.wessel@windriver.com>
  */
 
+typedef enum {
+	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
+	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
+	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
+} kdb_repeat_t;
+
+typedef int (*kdb_func_t)(int, const char **);
+
 #ifdef	CONFIG_KGDB_KDB
 #include <linux/init.h>
 #include <linux/sched.h>
@@ -32,14 +40,6 @@ extern atomic_t kdb_event;
 
 #define KDB_MAXARGS    16 /* Maximum number of arguments to a function  */
 
-typedef enum {
-	KDB_REPEAT_NONE = 0,	/* Do not repeat this command */
-	KDB_REPEAT_NO_ARGS,	/* Repeat the command without arguments */
-	KDB_REPEAT_WITH_ARGS,	/* Repeat the command including its arguments */
-} kdb_repeat_t;
-
-typedef int (*kdb_func_t)(int, const char **);
-
 /* KDB return codes from a command or internal kdb function */
 #define KDB_NOTFOUND	(-1)
 #define KDB_ARGCOUNT	(-2)
@@ -149,11 +149,14 @@ extern int kdb_register_repeat(char *, kdb_func_t, char *, char *,
 			       short, kdb_repeat_t);
 extern int kdb_unregister(char *);
 #else /* ! CONFIG_KGDB_KDB */
-#define kdb_printf(...)
-#define kdb_init(x)
-#define kdb_register(...)
-#define kdb_register_repeat(...)
-#define kdb_uregister(x)
+static inline __printf(1, 2) int kdb_printf(const char *fmt, ...) { return 0; }
+static inline void kdb_init(int level) {}
+static inline int kdb_register(char *cmd, kdb_func_t func, char *usage,
+			       char *help, short minlen) { return 0; }
+static inline int kdb_register_repeat(char *cmd, kdb_func_t func, char *usage,
+				      char *help, short minlen,
+				      kdb_repeat_t repeat) { return 0; }
+static inline int kdb_unregister(char *cmd) { return 0; }
 #endif	/* CONFIG_KGDB_KDB */
 enum {
 	KDB_NOT_INITIALIZED,
-- 
1.7.11.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab0HEOlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:41:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:41883 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460Ab0HEOlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:41:09 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/9] vt,console,kdb: automatically set kdb LINES variable
Date: Thu,  5 Aug 2010 09:39:51 -0500
Message-Id: <1281019198-6777-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
References: <1281019198-6777-1-git-send-email-jason.wessel@windriver.com>
 <1281019198-6777-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:40:05.0342 (UTC) FILETIME=[1817BFE0:01CB34AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel console interface stores the number of lines it is
configured to use. The kdb debugger can greatly benefit by knowing how
many lines there are on the console for the pager functionality
without having the end user compile in the setting or have to
repeatedly change it at run time.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/vt.c              |   17 +++++++++++++++++
 include/linux/kdb.h            |    4 ++++
 kernel/debug/kdb/kdb_private.h |    2 --
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 117ce99..4a9eb30 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <asm/system.h>
 #include <linux/uaccess.h>
+#include <linux/kdb.h>
 
 #define MAX_NR_CON_DRIVER 16
 
@@ -3442,6 +3443,22 @@ int con_debug_enter(struct vc_data *vc)
 	console_blanked = 0;
 	if (vc->vc_sw->con_debug_enter)
 		ret = vc->vc_sw->con_debug_enter(vc);
+#ifdef CONFIG_KGDB_KDB
+	/* Set the initial LINES variable if it is not already set */
+	if (vc->vc_rows < 999) {
+		int linecount;
+		char lns[4];
+		const char *setargs[3] = {
+			"set",
+			"LINES",
+			lns,
+		};
+		if (kdbgetintenv(setargs[0], &linecount)) {
+			snprintf(lns, 4, "%i", vc->vc_rows);
+			kdb_set(2, setargs);
+		}
+	}
+#endif /* CONFIG_KGDB_KDB */
 	return ret;
 }
 EXPORT_SYMBOL_GPL(con_debug_enter);
diff --git a/include/linux/kdb.h b/include/linux/kdb.h
index ccb2b3e..ea6e524 100644
--- a/include/linux/kdb.h
+++ b/include/linux/kdb.h
@@ -114,4 +114,8 @@ enum {
 	KDB_INIT_EARLY,
 	KDB_INIT_FULL,
 };
+
+extern int kdbgetintenv(const char *, int *);
+extern int kdb_set(int, const char **);
+
 #endif	/* !_KDB_H */
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 97d3ba6..c438f54 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -144,9 +144,7 @@ extern int kdb_getword(unsigned long *, unsigned long, size_t);
 extern int kdb_putword(unsigned long, unsigned long, size_t);
 
 extern int kdbgetularg(const char *, unsigned long *);
-extern int kdb_set(int, const char **);
 extern char *kdbgetenv(const char *);
-extern int kdbgetintenv(const char *, int *);
 extern int kdbgetaddrarg(int, const char **, int*, unsigned long *,
 			 long *, char **);
 extern int kdbgetsymval(const char *, kdb_symtab_t *);
-- 
1.6.4.rc1


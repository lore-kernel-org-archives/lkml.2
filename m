Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2KZREP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:04:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47358 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab2KZREL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:04:11 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 071/270] kdb,vt_console: Fix missed data due to pager overruns
Date: Mon, 26 Nov 2012 14:56:01 -0200
Message-Id: <1353949160-26803-72-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit 17b572e82032bc246324ce136696656b66d4e3f1 upstream.

It is possible to miss data when using the kdb pager.  The kdb pager
does not pay attention to the maximum column constraint of the screen
or serial terminal.  This result is not incrementing the shown lines
correctly and the pager will print more lines that fit on the screen.
Obviously that is less than useful when using a VGA console where you
cannot scroll back.

The pager will now look at the kdb_buffer string to see how many
characters are printed.  It might not be perfect considering you can
output ASCII that might move the cursor position, but it is a
substantially better approximation for viewing dmesg and trace logs.

This also means that the vt screen needs to set the kdb COLUMNS
variable.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
[ herton: adjusted context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/tty/vt/vt.c       |   13 +++++++++++++
 kernel/debug/kdb/kdb_io.c |   33 ++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 84cbf29..a13f7e1 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3475,6 +3475,19 @@ int con_debug_enter(struct vc_data *vc)
 			kdb_set(2, setargs);
 		}
 	}
+	if (vc->vc_cols < 999) {
+		int colcount;
+		char cols[4];
+		const char *setargs[3] = {
+			"set",
+			"COLUMNS",
+			cols,
+		};
+		if (kdbgetintenv(setargs[0], &colcount)) {
+			snprintf(cols, 4, "%i", vc->vc_cols);
+			kdb_set(2, setargs);
+		}
+	}
 #endif /* CONFIG_KGDB_KDB */
 	return ret;
 }
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index bb9520f..572e604 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -552,6 +552,7 @@ int vkdb_printf(const char *fmt, va_list ap)
 {
 	int diag;
 	int linecount;
+	int colcount;
 	int logging, saved_loglevel = 0;
 	int saved_trap_printk;
 	int got_printf_lock = 0;
@@ -584,6 +585,10 @@ int vkdb_printf(const char *fmt, va_list ap)
 	if (diag || linecount <= 1)
 		linecount = 24;
 
+	diag = kdbgetintenv("COLUMNS", &colcount);
+	if (diag || colcount <= 1)
+		colcount = 80;
+
 	diag = kdbgetintenv("LOGGING", &logging);
 	if (diag)
 		logging = 0;
@@ -690,7 +695,7 @@ kdb_printit:
 		gdbstub_msg_write(kdb_buffer, retlen);
 	} else {
 		if (dbg_io_ops && !dbg_io_ops->is_console) {
-			len = strlen(kdb_buffer);
+			len = retlen;
 			cp = kdb_buffer;
 			while (len--) {
 				dbg_io_ops->write_char(*cp);
@@ -709,11 +714,29 @@ kdb_printit:
 		printk(KERN_INFO "%s", kdb_buffer);
 	}
 
-	if (KDB_STATE(PAGER) && strchr(kdb_buffer, '\n'))
-		kdb_nextline++;
+	if (KDB_STATE(PAGER)) {
+		/*
+		 * Check printed string to decide how to bump the
+		 * kdb_nextline to control when the more prompt should
+		 * show up.
+		 */
+		int got = 0;
+		len = retlen;
+		while (len--) {
+			if (kdb_buffer[len] == '\n') {
+				kdb_nextline++;
+				got = 0;
+			} else if (kdb_buffer[len] == '\r') {
+				got = 0;
+			} else {
+				got++;
+			}
+		}
+		kdb_nextline += got / (colcount + 1);
+	}
 
 	/* check for having reached the LINES number of printed lines */
-	if (kdb_nextline == linecount) {
+	if (kdb_nextline >= linecount) {
 		char buf1[16] = "";
 #if defined(CONFIG_SMP)
 		char buf2[32];
@@ -776,7 +799,7 @@ kdb_printit:
 			kdb_grepping_flag = 0;
 			kdb_printf("\n");
 		} else if (buf1[0] == ' ') {
-			kdb_printf("\n");
+			kdb_printf("\r");
 			suspend_grep = 1; /* for this recursion */
 		} else if (buf1[0] == '\n') {
 			kdb_nextline = linecount - 1;
-- 
1.7.9.5


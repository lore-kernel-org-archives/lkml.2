Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab1HATCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:02:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:50476 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1HATBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:01:44 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 2/4] kdb,kgdb: Implement switch and pass buffer from kdb -> gdb
Date: Mon, 1 Aug 2011 14:00:58 -0500
Message-ID: <1312225260-1028-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
References: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching from kdb mode to kgdb mode packets were getting lost
depending on the size of the fifo queue of the serial chip.  When gdb
initially connects if it is in kdb mode it should entirely send any
character buffer over to the gdbstub when switching connections.

Previously kdb was zero'ing out the character buffer and this could
lead to gdb failing to connect at all, or a lengthy pause could occur
on the initial connect.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/gdbstub.c          |   22 +++++++++++++++-------
 kernel/debug/kdb/kdb_debugger.c |   17 +++++++----------
 kernel/debug/kdb/kdb_io.c       |   10 ++++++----
 kernel/debug/kdb/kdb_private.h  |    1 +
 4 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/kernel/debug/gdbstub.c b/kernel/debug/gdbstub.c
index a11db95..3487248 100644
--- a/kernel/debug/gdbstub.c
+++ b/kernel/debug/gdbstub.c
@@ -42,6 +42,8 @@
 /* Our I/O buffers. */
 static char			remcom_in_buffer[BUFMAX];
 static char			remcom_out_buffer[BUFMAX];
+static int			gdbstub_use_prev_in_buf;
+static int			gdbstub_prev_in_buf_pos;
 
 /* Storage for the registers, in GDB format. */
 static unsigned long		gdb_regs[(NUMREGBYTES +
@@ -58,6 +60,13 @@ static int gdbstub_read_wait(void)
 	int ret = -1;
 	int i;
 
+	if (unlikely(gdbstub_use_prev_in_buf)) {
+		if (gdbstub_prev_in_buf_pos < gdbstub_use_prev_in_buf)
+			return remcom_in_buffer[gdbstub_prev_in_buf_pos++];
+		else
+			gdbstub_use_prev_in_buf = 0;
+	}
+
 	/* poll any additional I/O interfaces that are defined */
 	while (ret < 0)
 		for (i = 0; kdb_poll_funcs[i] != NULL; i++) {
@@ -109,7 +118,6 @@ static void get_packet(char *buffer)
 			buffer[count] = ch;
 			count = count + 1;
 		}
-		buffer[count] = 0;
 
 		if (ch == '#') {
 			xmitcsum = hex_to_bin(gdbstub_read_wait()) << 4;
@@ -124,6 +132,7 @@ static void get_packet(char *buffer)
 			if (dbg_io_ops->flush)
 				dbg_io_ops->flush();
 		}
+		buffer[count] = 0;
 	} while (checksum != xmitcsum);
 }
 
@@ -1082,12 +1091,11 @@ int gdbstub_state(struct kgdb_state *ks, char *cmd)
 	case 'c':
 		strcpy(remcom_in_buffer, cmd);
 		return 0;
-	case '?':
-		gdb_cmd_status(ks);
-		break;
-	case '\0':
-		strcpy(remcom_out_buffer, "");
-		break;
+	case '$':
+		strcpy(remcom_in_buffer, cmd);
+		gdbstub_use_prev_in_buf = strlen(remcom_in_buffer);
+		gdbstub_prev_in_buf_pos = 0;
+		return 0;
 	}
 	dbg_io_ops->write_char('+');
 	put_packet(remcom_out_buffer);
diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index dd0b1b7..fe422d2 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -30,6 +30,8 @@ EXPORT_SYMBOL_GPL(kdb_poll_funcs);
 int kdb_poll_idx = 1;
 EXPORT_SYMBOL_GPL(kdb_poll_idx);
 
+static struct kgdb_state *kdb_ks;
+
 int kdb_stub(struct kgdb_state *ks)
 {
 	int error = 0;
@@ -39,6 +41,7 @@ int kdb_stub(struct kgdb_state *ks)
 	kdb_dbtrap_t db_result = KDB_DB_NOBPT;
 	int i;
 
+	kdb_ks = ks;
 	if (KDB_STATE(REENTRY)) {
 		reason = KDB_REASON_SWITCH;
 		KDB_STATE_CLEAR(REENTRY);
@@ -124,16 +127,6 @@ int kdb_stub(struct kgdb_state *ks)
 	kdbnearsym_cleanup();
 	if (error == KDB_CMD_KGDB) {
 		if (KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)) {
-	/*
-	 * This inteface glue which allows kdb to transition in into
-	 * the gdb stub.  In order to do this the '?' or '' gdb serial
-	 * packet response is processed here.  And then control is
-	 * passed to the gdbstub.
-	 */
-			if (KDB_STATE(DOING_KGDB))
-				gdbstub_state(ks, "?");
-			else
-				gdbstub_state(ks, "");
 			KDB_STATE_CLEAR(DOING_KGDB);
 			KDB_STATE_CLEAR(DOING_KGDB2);
 		}
@@ -166,3 +159,7 @@ int kdb_stub(struct kgdb_state *ks)
 	return kgdb_info[ks->cpu].ret_state;
 }
 
+void kdb_gdb_state_pass(char *buf)
+{
+	gdbstub_state(kdb_ks, buf);
+}
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 96fdaac..bd23326 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -35,8 +35,8 @@ static void kgdb_transition_check(char *buffer)
 {
 	int slen = strlen(buffer);
 	if (strncmp(buffer, "$?#3f", slen) != 0 &&
-	    strncmp(buffer, "$qSupported#37", slen) != 0 &&
-	    strncmp(buffer, "+$qSupported#37", slen) != 0) {
+	    strncmp(buffer, "$qSupported", slen) != 0 &&
+	    strncmp(buffer, "+$qSupported", slen) != 0) {
 		KDB_STATE_SET(KGDB_TRANS);
 		kdb_printf("%s", buffer);
 	}
@@ -390,12 +390,14 @@ poll_again:
 			/* Special escape to kgdb */
 			if (lastchar - buffer >= 5 &&
 			    strcmp(lastchar - 5, "$?#3f") == 0) {
+				kdb_gdb_state_pass(lastchar - 5);
 				strcpy(buffer, "kgdb");
 				KDB_STATE_SET(DOING_KGDB);
 				return buffer;
 			}
-			if (lastchar - buffer >= 14 &&
-			    strcmp(lastchar - 14, "$qSupported#37") == 0) {
+			if (lastchar - buffer >= 11 &&
+			    strcmp(lastchar - 11, "$qSupported") == 0) {
+				kdb_gdb_state_pass(lastchar - 11);
 				strcpy(buffer, "kgdb");
 				KDB_STATE_SET(DOING_KGDB2);
 				return buffer;
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 35d69ed..03d332e 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -218,6 +218,7 @@ extern void kdb_print_nameval(const char *name, unsigned long val);
 extern void kdb_send_sig_info(struct task_struct *p, struct siginfo *info);
 extern void kdb_meminfo_proc_show(void);
 extern char *kdb_getstr(char *, size_t, char *);
+extern void kdb_gdb_state_pass(char *buf);
 
 /* Defines for kdb_symbol_print */
 #define KDB_SP_SPACEB	0x0001		/* Space before string */
-- 
1.7.1


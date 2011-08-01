Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1HATCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:02:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:50494 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1HATBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:01:49 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 4/4] kdb,kgdb: Allow arbitrary kgdb magic knock sequences
Date: Mon, 1 Aug 2011 14:01:00 -0500
Message-ID: <1312225260-1028-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
References: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first packet that gdb sends when the kernel is in kdb mode seems
to change with every release of gdb.  Instead of continuing to add
many different gdb packets, change kdb to automatically look for any
thing that looks like a gdb packet.

Example 1 cold start test:
echo g > /proc/sysrq-trigger
$D#44+

Example 2 cold start test:
echo g > /proc/sysrq-trigger
$3#33

The second one should re-enter kdb's shell right away and is purely a
test.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_io.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 0dbcdfb..4802eb5 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -31,15 +31,21 @@ char kdb_prompt_str[CMD_BUFLEN];
 
 int kdb_trap_printk;
 
-static void kgdb_transition_check(char *buffer)
+static int kgdb_transition_check(char *buffer)
 {
-	int slen = strlen(buffer);
-	if (strncmp(buffer, "$?#3f", slen) != 0 &&
-	    strncmp(buffer, "$qSupported", slen) != 0 &&
-	    strncmp(buffer, "+$qSupported", slen) != 0) {
+	if (buffer[0] != '+' && buffer[0] != '$') {
 		KDB_STATE_SET(KGDB_TRANS);
 		kdb_printf("%s", buffer);
+	} else {
+		int slen = strlen(buffer);
+		if (slen > 3 && buffer[slen - 3] == '#') {
+			kdb_gdb_state_pass(buffer);
+			strcpy(buffer, "kgdb");
+			KDB_STATE_SET(DOING_KGDB);
+			return 1;
+		}
 	}
+	return 0;
 }
 
 static int kdb_read_get_key(char *buffer, size_t bufsize)
@@ -251,6 +257,10 @@ poll_again:
 	case 13: /* enter */
 		*lastchar++ = '\n';
 		*lastchar++ = '\0';
+		if (!KDB_STATE(KGDB_TRANS)) {
+			KDB_STATE_SET(KGDB_TRANS);
+			kdb_printf("%s", buffer);
+		}
 		kdb_printf("\n");
 		return buffer;
 	case 4: /* Del */
@@ -382,10 +392,12 @@ poll_again:
 				 * printed characters if we think that
 				 * kgdb is connecting, until the check
 				 * fails */
-				if (!KDB_STATE(KGDB_TRANS))
-					kgdb_transition_check(buffer);
-				else
+				if (!KDB_STATE(KGDB_TRANS)) {
+					if (kgdb_transition_check(buffer))
+						return buffer;
+				} else {
 					kdb_printf("%c", key);
+				}
 			}
 			/* Special escape to kgdb */
 			if (lastchar - buffer >= 5 &&
-- 
1.7.1


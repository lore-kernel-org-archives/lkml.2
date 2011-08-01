Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1HATCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 15:02:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:50493 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1HATBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 15:01:48 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 3/4] kdb: Remove all references to DOING_KGDB2
Date: Mon, 1 Aug 2011 14:00:59 -0500
Message-ID: <1312225260-1028-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
References: <1312225260-1028-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DOING_KGDB2 was originally a state variable for one of the two
ways to automatically transition from kdb to kgdb.  Purge all these
variables and just use one single state for the transition.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_debugger.c |    4 +---
 kernel/debug/kdb/kdb_io.c       |    2 +-
 kernel/debug/kdb/kdb_main.c     |    2 +-
 kernel/debug/kdb/kdb_private.h  |    2 --
 4 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index fe422d2..d9ca9aa 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -126,10 +126,8 @@ int kdb_stub(struct kgdb_state *ks)
 	KDB_STATE_CLEAR(PAGER);
 	kdbnearsym_cleanup();
 	if (error == KDB_CMD_KGDB) {
-		if (KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)) {
+		if (KDB_STATE(DOING_KGDB))
 			KDB_STATE_CLEAR(DOING_KGDB);
-			KDB_STATE_CLEAR(DOING_KGDB2);
-		}
 		return DBG_PASS_EVENT;
 	}
 	kdb_bp_install(ks->linux_regs);
diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index bd23326..0dbcdfb 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -399,7 +399,7 @@ poll_again:
 			    strcmp(lastchar - 11, "$qSupported") == 0) {
 				kdb_gdb_state_pass(lastchar - 11);
 				strcpy(buffer, "kgdb");
-				KDB_STATE_SET(DOING_KGDB2);
+				KDB_STATE_SET(DOING_KGDB);
 				return buffer;
 			}
 		}
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index b33116e..63786e7 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1386,7 +1386,7 @@ int kdb_main_loop(kdb_reason_t reason, kdb_reason_t reason2, int error,
 		}
 
 		if (result == KDB_CMD_KGDB) {
-			if (!(KDB_STATE(DOING_KGDB) || KDB_STATE(DOING_KGDB2)))
+			if (!KDB_STATE(DOING_KGDB))
 				kdb_printf("Entering please attach debugger "
 					   "or use $D#44+ or $3#33\n");
 			break;
diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 03d332e..e381d10 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -21,7 +21,6 @@
 #define KDB_CMD_SS	(-1003)
 #define KDB_CMD_SSB	(-1004)
 #define KDB_CMD_KGDB (-1005)
-#define KDB_CMD_KGDB2 (-1006)
 
 /* Internal debug flags */
 #define KDB_DEBUG_FLAG_BP	0x0002	/* Breakpoint subsystem debug */
@@ -146,7 +145,6 @@ extern int kdb_state;
 						 * keyboard on this cpu */
 #define KDB_STATE_KEXEC		0x00040000	/* kexec issued */
 #define KDB_STATE_DOING_KGDB	0x00080000	/* kgdb enter now issued */
-#define KDB_STATE_DOING_KGDB2	0x00100000	/* kgdb enter now issued */
 #define KDB_STATE_KGDB_TRANS	0x00200000	/* Transition to kgdb */
 #define KDB_STATE_ARCH		0xff000000	/* Reserved for arch
 						 * specific use */
-- 
1.7.1


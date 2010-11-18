Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab0KRM4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:56:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:53212 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KRM4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:56:10 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/4] kdb: fix crash when KDB_BASE_CMD_MAX is exceeded
Date: Thu, 18 Nov 2010 06:56:01 -0600
Message-Id: <1290084963-6376-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
References: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Nov 2010 12:55:25.0072 (UTC) FILETIME=[DE225900:01CB871F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

When the number of dyanmic kdb commands exceeds KDB_BASE_CMD_MAX, the
kernel will fault.

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 3ab3fee..a6e7297 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -82,7 +82,7 @@ static kdbtab_t kdb_base_commands[50];
 #define for_each_kdbcmd(cmd, num)					\
 	for ((cmd) = kdb_base_commands, (num) = 0;			\
 	     num < kdb_max_commands;					\
-	     num == KDB_BASE_CMD_MAX ? cmd = kdb_commands : cmd++, num++)
+	     num++, num == KDB_BASE_CMD_MAX ? cmd = kdb_commands : cmd++)
 
 typedef struct _kdbmsg {
 	int	km_diag;	/* kdb diagnostic */
@@ -646,7 +646,7 @@ static int kdb_defcmd2(const char *cmdstr, const char *argv0)
 	}
 	if (!s->usable)
 		return KDB_NOTIMP;
-	s->command = kmalloc((s->count + 1) * sizeof(*(s->command)), GFP_KDB);
+	s->command = kzalloc((s->count + 1) * sizeof(*(s->command)), GFP_KDB);
 	if (!s->command) {
 		kdb_printf("Could not allocate new kdb_defcmd table for %s\n",
 			   cmdstr);
@@ -2740,13 +2740,13 @@ int kdb_register_repeat(char *cmd,
 		}
 		if (kdb_commands) {
 			memcpy(new, kdb_commands,
-			       kdb_max_commands * sizeof(*new));
+			  (kdb_max_commands - KDB_BASE_CMD_MAX) * sizeof(*new));
 			kfree(kdb_commands);
 		}
 		memset(new + kdb_max_commands, 0,
 		       kdb_command_extend * sizeof(*new));
 		kdb_commands = new;
-		kp = kdb_commands + kdb_max_commands;
+		kp = kdb_commands + kdb_max_commands - KDB_BASE_CMD_MAX;
 		kdb_max_commands += kdb_command_extend;
 	}
 
-- 
1.7.0.4


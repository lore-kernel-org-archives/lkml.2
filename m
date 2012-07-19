Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab2GSTrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:47:11 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55931 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2GSTqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:46:50 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: kay@vrfy.com, joe@perches.com, greg@kroah.com,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 2/3] dyndbg: in dynamic_emit_prefix, change inter-field separator
Date: Thu, 19 Jul 2012 13:46:22 -0600
Message-Id: <1342727183-4520-4-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
References: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_emit_prefix() currently separates modname, funcname, lineno
with ':'.  This is complicates use of cut -d: <logfile>, since the
field positions can change per callsite with dynamic-debug.  So change
inter-field separator to '.' and keep the ':' prefix terminator.

This improves the situation, but doesnt solve it entirely; if
dyndbg==p is used, the callsite is enabled but no prefix is added, so
theres one less ':' in the message.  Changing the terminator to ','
would fix this, and might be warranted.

pr_fmt(fmt) KBUILD_MODNAME ": " fmt, also adds another ':'.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7ca29a0..6bc34aa 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -532,16 +532,18 @@ static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 	}
 	pos_after_tid = pos;
 	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
-		pos += snprintf(buf + pos, remaining(pos), "%s:",
+		pos += snprintf(buf + pos, remaining(pos), "%s.",
 					desc->modname);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
-		pos += snprintf(buf + pos, remaining(pos), "%s:",
+		pos += snprintf(buf + pos, remaining(pos), "%s.",
 					desc->function);
 	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		pos += snprintf(buf + pos, remaining(pos), "%d:",
+		pos += snprintf(buf + pos, remaining(pos), "%d.",
 					desc->lineno);
-	if (pos - pos_after_tid)
-		pos += snprintf(buf + pos, remaining(pos), " ");
+	if (pos - pos_after_tid) {
+		pos--;
+		pos += snprintf(buf + pos, remaining(pos), ": ");
+	}
 	if (pos >= PREFIX_SIZE)
 		buf[PREFIX_SIZE - 1] = '\0';
 
-- 
1.7.10.4


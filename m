Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2IRXh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:37:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab2IRXhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:37:17 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Jim Cromie <jim.cromie@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 5/6] dyndbg: in dynamic_emit_prefix, change inter-field separator
Date: Tue, 18 Sep 2012 17:36:46 -0600
Message-Id: <1348011407-24108-6-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
References: <1348011407-24108-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamic_emit_prefix() currently separates modname, funcname, lineno
with ':'.  This is confounds use of cut -d: <logfile>, since the field
positions can change per callsite with dynamic-debug.  So change
inter-field separator to '.' and keep the ':' prefix terminator.

This improves the situation, but doesnt solve it entirely; if
dyndbg==p is used instead of dyndbg==p[fmlt]+, the callsite is enabled
but no prefix is added, so theres one less ':' in the message.
Changing the terminator to ',' would fix this, and might be warranted,
especially since pr_fmt() typically adds a ':' as well.

Joe Perches wasnt a fan of this, but his complaint was essentially
that cut -d: was a poor way to do this kind of thing.  I concede that
point, but note that the kernel is not in the habit of needlessly
confounding users work, at least when accommodating them is so trivial.

cc: Joe Perches <joe@perches.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 11a8897..f1f7467 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -556,16 +556,18 @@ static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
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
1.7.11.4


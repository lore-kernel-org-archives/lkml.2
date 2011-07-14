Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab1GNQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:09:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab1GNQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:09:26 -0400
Date: Thu, 14 Jul 2011 12:09:20 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <07ef9de13b16d5c50bc36f8c8d9a9aa28a05f2ca.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
Subject: [PATCH 03/11] dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Multiple printks with KERN_CONT can be interleaved by
other printks.  Reduce the likelihood of that interleaving
by consolidating multiple calls to printk.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 3721709..a3eb6ab 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -430,23 +430,35 @@ static int ddebug_exec_query(char *query_string)
 
 static int dynamic_emit_prefix(const struct _ddebug *descriptor)
 {
-	int res;
+	char tid[sizeof(int) + sizeof(int)/2 + 4];
+	char lineno[sizeof(int) + sizeof(int)/2];
 
-	res = printk(KERN_DEBUG);
 	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			res += printk(KERN_CONT "<intr> ");
+			snprintf(tid, sizeof(tid), "%s", "<intr> ");
 		else
-			res += printk(KERN_CONT "[%d] ", task_pid_vnr(current));
+			snprintf(tid, sizeof(tid), "[%d] ",
+				 task_pid_vnr(current));
+	} else {
+		tid[0] = 0;
 	}
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME)
-		res += printk(KERN_CONT "%s:", descriptor->modname);
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
-		res += printk(KERN_CONT "%s:", descriptor->function);
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		res += printk(KERN_CONT "%d ", descriptor->lineno);
 
-	return res;
+	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
+		snprintf(lineno, sizeof(lineno), "%d", descriptor->lineno);
+	else
+		lineno[0] = 0;
+
+	return printk(KERN_DEBUG "%s%s%s%s%s%s",
+		      tid,
+		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
+		      descriptor->modname : "",
+		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
+		      ":" : "",
+		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
+		      descriptor->function : "",
+		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
+		      ":" : "",
+		      lineno);
 }
 
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
-- 
1.7.5.4


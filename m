Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1HKSgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1HKSge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:36:34 -0400
Date: Thu, 11 Aug 2011 14:36:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <2b7575709d419c3693af77534af4b67e5c20efb8.1313085588.git.jbaron@redhat.com>
In-Reply-To: <cover.1313085588.git.jbaron@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
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


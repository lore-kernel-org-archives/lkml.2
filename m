Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1F3SOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:14:50 -0400
Received: from mail.perches.com ([173.55.12.10]:3378 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1F3SOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:14:46 -0400
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] dynamic_debug: Remove uses of KERN_CONT in dynamic_emit_prefix
Date: Thu, 30 Jun 2011 11:14:36 -0700
Message-Id: <f73b2aba0c9af68e68385389100f04e9125f4245.1309457340.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <20110630163218.GA2457@redhat.com>
References: <20110630163218.GA2457@redhat.com>
In-Reply-To: <cover.1309457340.git.joe@perches.com>
References: <cover.1309457340.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple printks with KERN_CONT can be interleaved by
other printks.  Reduce the likelihood of that interleaving
by consolidating multiple calls to printk.

Signed-off-by: Joe Perches <joe@perches.com>
---
 lib/dynamic_debug.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 758e922..6669078 100644
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
1.7.6.rc1


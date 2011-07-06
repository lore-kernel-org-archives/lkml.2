Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1GFRYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:24:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262Ab1GFRYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:24:50 -0400
Date: Wed, 6 Jul 2011 13:24:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <fe35f0bd31c166adea772ed6c93bf84e19266b04.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
In-Reply-To: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Subject: [PATCH 03/10] dynamic_debug: Remove uses of KERN_CONT in
 dynamic_emit_prefix
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
1.7.5.4


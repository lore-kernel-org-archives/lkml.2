Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab1GNQLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755271Ab1GNQJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:09:21 -0400
Date: Thu, 14 Jul 2011 12:09:15 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <24a481dab928664edaf84cbd29e29b6e9e20dff5.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
Subject: [PATCH 02/11] dynamic_debug: Consolidate prefix output to single routine
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Adding dynamic_dev_dbg duplicated prefix output.
Consolidate that output to a single routine.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   38 ++++++++++++++++++--------------------
 1 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 63b6f95..3721709 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -428,15 +428,10 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
-int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
+static int dynamic_emit_prefix(const struct _ddebug *descriptor)
 {
-	va_list args;
 	int res;
 
-	BUG_ON(!descriptor);
-	BUG_ON(!fmt);
-
-	va_start(args, fmt);
 	res = printk(KERN_DEBUG);
 	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
@@ -450,7 +445,23 @@ int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 		res += printk(KERN_CONT "%s:", descriptor->function);
 	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
 		res += printk(KERN_CONT "%d ", descriptor->lineno);
+
+	return res;
+}
+
+int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
+{
+	va_list args;
+	int res;
+
+	BUG_ON(!descriptor);
+	BUG_ON(!fmt);
+
+	va_start(args, fmt);
+
+	res = dynamic_emit_prefix(descriptor);
 	res += vprintk(fmt, args);
+
 	va_end(args);
 
 	return res;
@@ -472,20 +483,7 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	res = printk(KERN_DEBUG);
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
-		if (in_interrupt())
-			res += printk(KERN_CONT "<intr> ");
-		else
-			res += printk(KERN_CONT "[%d] ", task_pid_vnr(current));
-	}
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME)
-		res += printk(KERN_CONT "%s:", descriptor->modname);
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
-		res += printk(KERN_CONT "%s:", descriptor->function);
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		res += printk(KERN_CONT "%d ", descriptor->lineno);
-
+	res = dynamic_emit_prefix(descriptor);
 	res += __dev_printk(KERN_CONT, dev, &vaf);
 
 	va_end(args);
-- 
1.7.5.4


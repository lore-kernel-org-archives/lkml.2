Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1GFRYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:24:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1GFRYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:24:46 -0400
Date: Wed, 6 Jul 2011 13:24:40 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <151c1f3fc402d2f19f95e44de07cdc04917f7278.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
In-Reply-To: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
References: <cover.1309967232.git.root@dhcp-100-18-164.bos.redhat.com>
Subject: [PATCH 02/10] dynamic_debug: Consolidate prefix output to single
 routine
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
index 5c5f8f9..758e922 100644
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
 	res += __dev_printk("", dev, &vaf);
 
 	va_end(args);
-- 
1.7.5.4


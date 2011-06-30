Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1F3SOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 14:14:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3377 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1F3SOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 14:14:44 -0400
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] dynamic_debug: Consolidate prefix output to single routine
Date: Thu, 30 Jun 2011 11:14:35 -0700
Message-Id: <aa5707f15b88d4d7634672ae34a4bb996ea98b08.1309457340.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <20110630163218.GA2457@redhat.com>
References: <20110630163218.GA2457@redhat.com>
In-Reply-To: <cover.1309457340.git.joe@perches.com>
References: <cover.1309457340.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding dynamic_dev_dbg duplicated prefix output.
Consolidate that output to a single routine.

Signed-off-by: Joe Perches <joe@perches.com>
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
1.7.6.rc1


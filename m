Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1H3S27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:28:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab1H3S2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:28:55 -0400
Date: Tue, 30 Aug 2011 14:28:50 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <c106d5b6978b550e3a98b5425cc2ba00b090c9eb.1314725877.git.jbaron@redhat.com>
In-Reply-To: <cover.1314725877.git.jbaron@redhat.com>
References: <cover.1314725877.git.jbaron@redhat.com>
Subject: [PATCH 3/4] dynamic_debug: use a single printk() to emit msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were using KERN_CONT to combine msgs with their prefix. However,
KERN_CONT is not smp safe, in the sense that it can interleave messages.
This interleaving can result in printks coming out at the wrong loglevel.
With the high frequency of printks, that dynamic debug can produce, this
is not desirable.

Thus, make dynamic_emit_prefix(), fill a char buf[64], instead
of doing a printk directly. If we enable printing out of
function, module, line, or pid info, they are placed in this
64 byte buffer. In my testing 64 bytes was enough size to fulfill
all requests. Even if its not, we can match up the printk itself
to see where its from, so to me this is no big deal.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   72 +++++++++++++++++++++++---------------------------
 1 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 198d2af..7314e5e 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -422,52 +422,52 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
-static int dynamic_emit_prefix(const struct _ddebug *descriptor)
+#define PREFIX_SIZE 64
+#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
+
+static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
 {
-	char tid[sizeof(int) + sizeof(int)/2 + 4];
-	char lineno[sizeof(int) + sizeof(int)/2];
+	int pos_after_tid;
+	int pos = 0;
 
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
+	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
 		if (in_interrupt())
-			snprintf(tid, sizeof(tid), "%s", "<intr> ");
+			pos += snprintf(buf + pos, LEFT(pos), "%s ",
+						"<intr>");
 		else
-			snprintf(tid, sizeof(tid), "[%d] ",
-				 task_pid_vnr(current));
-	} else {
-		tid[0] = 0;
+			pos += snprintf(buf + pos, LEFT(pos), "[%d] ",
+						task_pid_vnr(current));
 	}
+	pos_after_tid = pos;
+	if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
+		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->modname);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
+		pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
+	if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
+		pos += snprintf(buf + pos, LEFT(pos), "%d:", desc->lineno);
+	if (pos - pos_after_tid)
+		pos += snprintf(buf + pos, LEFT(pos), " ");
+	if (pos >= PREFIX_SIZE)
+		buf[PREFIX_SIZE - 1] = '\0';
 
-	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
-		snprintf(lineno, sizeof(lineno), "%d", descriptor->lineno);
-	else
-		lineno[0] = 0;
-
-	return printk(KERN_DEBUG "%s%s%s%s%s%s",
-		      tid,
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
-		      descriptor->modname : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
-		      ":" : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
-		      descriptor->function : "",
-		      (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
-		      ":" : "",
-		      lineno);
+	return buf;
 }
 
 int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
 {
 	va_list args;
 	int res;
+	struct va_format vaf;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
-	res = dynamic_emit_prefix(descriptor);
-	res += vprintk(fmt, args);
-
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	res = printk("%s%pV", dynamic_emit_prefix(descriptor, buf), &vaf);
 	va_end(args);
 
 	return res;
@@ -480,18 +480,15 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
 	vaf.fmt = fmt;
 	vaf.va = &args;
-
-	res = dynamic_emit_prefix(descriptor);
-	res += __dev_printk(KERN_CONT, dev, &vaf);
-
+	res = __dev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
 	va_end(args);
 
 	return res;
@@ -504,18 +501,15 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
 
 	va_start(args, fmt);
-
 	vaf.fmt = fmt;
 	vaf.va = &args;
-
-	res = dynamic_emit_prefix(descriptor);
-	res += __netdev_printk(KERN_CONT, dev, &vaf);
-
+	res = __netdev_printk(dynamic_emit_prefix(descriptor, buf), dev, &vaf);
 	va_end(args);
 
 	return res;
-- 
1.7.5.4


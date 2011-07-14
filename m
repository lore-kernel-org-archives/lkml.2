Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab1GNQKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab1GNQKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:10:04 -0400
Date: Thu, 14 Jul 2011 12:09:59 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
Subject: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

We were using KERN_CONT to combine msgs with their prefix. However,
KERN_CONT is not smp safe, in the sense that it can interleave messages.
This interleaving can result in printks coming out at the wrong loglevel.
With the high frequency of printks, which dynamic debug can produce, this
is not desirable.

Thus, make dynamic_emit_prefix(), fill a char buf[64], instead
of doing a printk directly. If we enable printing out of
function, module, line, or pid info, they are placed in this
64 byte buffer. In my testing 64 bytes was enough size to fulfill
all requests. Even if its not, we can match up the printk itself
to see where its from, so to me this is no big deal.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c |   44 +++++++++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 198d2af..f0f692b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -422,7 +422,9 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
-static int dynamic_emit_prefix(const struct _ddebug *descriptor)
+#define PREFIX_SIZE 64
+
+static int dynamic_emit_prefix(const struct _ddebug *descriptor, char *buf)
 {
 	char tid[sizeof(int) + sizeof(int)/2 + 4];
 	char lineno[sizeof(int) + sizeof(int)/2];
@@ -442,31 +444,33 @@ static int dynamic_emit_prefix(const struct _ddebug *descriptor)
 	else
 		lineno[0] = 0;
 
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
+	return snprintf(buf, PREFIX_SIZE, KERN_DEBUG"%s%s%s%s%s%s",
+			tid,
+			(descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
+			descriptor->modname : "",
+			(descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
+			":" : "",
+			(descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
+			descriptor->function : "",
+			(descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
+			":" : "", lineno);
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
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	res = dynamic_emit_prefix(descriptor, buf);
+	res += printk("%s %pV", buf, &vaf);
 
 	va_end(args);
 
@@ -480,6 +484,7 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
@@ -489,8 +494,8 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	res = dynamic_emit_prefix(descriptor);
-	res += __dev_printk(KERN_CONT, dev, &vaf);
+	res = dynamic_emit_prefix(descriptor, buf);
+	res += __dev_printk(buf, dev, &vaf);
 
 	va_end(args);
 
@@ -504,6 +509,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	struct va_format vaf;
 	va_list args;
 	int res;
+	char buf[PREFIX_SIZE];
 
 	BUG_ON(!descriptor);
 	BUG_ON(!fmt);
@@ -513,8 +519,8 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	res = dynamic_emit_prefix(descriptor);
-	res += __netdev_printk(KERN_CONT, dev, &vaf);
+	res = dynamic_emit_prefix(descriptor, buf);
+	res += __netdev_printk(buf, dev, &vaf);
 
 	va_end(args);
 
-- 
1.7.5.4


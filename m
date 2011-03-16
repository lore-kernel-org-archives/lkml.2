Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab1CPVMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:12:06 -0400
Received: from kroah.org ([198.145.64.141]:42538 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1CPVLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:11:34 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Greg Banks <gnb@fmeh.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/50] Dynamic debug: Add more flags
Date: Wed, 16 Mar 2011 14:10:43 -0700
Message-Id: <1300309888-5028-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300309888-5028-1-git-send-email-gregkh@suse.de>
References: <20110316205204.GA2686@kroah.com>
 <1300309888-5028-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Add flags that allow the user to specify via debugfs whether or not the
module name, function name, line number and/or thread ID have to be
included in the printed message.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Banks <gnb@fmeh.org>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/dynamic-debug-howto.txt |   12 +++++-
 include/linux/dynamic_debug.h         |    8 ++++-
 lib/dynamic_debug.c                   |   60 ++++++++++++++++++++++++++++-----
 3 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/Documentation/dynamic-debug-howto.txt b/Documentation/dynamic-debug-howto.txt
index 58ea64a..e6c4b75 100644
--- a/Documentation/dynamic-debug-howto.txt
+++ b/Documentation/dynamic-debug-howto.txt
@@ -205,12 +205,20 @@ of the characters:
 
 The flags are:
 
+f
+    Include the function name in the printed message
+l
+    Include line number in the printed message
+m
+    Include module name in the printed message
 p
     Causes a printk() message to be emitted to dmesg
+t
+    Include thread ID in messages not generated from interrupt context
 
-Note the regexp ^[-+=][scp]+$ matches a flags specification.
+Note the regexp ^[-+=][flmpt]+$ matches a flags specification.
 Note also that there is no convenient syntax to remove all
-the flags at once, you need to use "-psc".
+the flags at once, you need to use "-flmpt".
 
 
 Debug messages during boot process
diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 1c70028..0c9653f 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -31,6 +31,10 @@ struct _ddebug {
 	 * writes commands to <debugfs>/dynamic_debug/control
 	 */
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
+#define _DPRINTK_FLAGS_INCL_MODNAME	(1<<1)
+#define _DPRINTK_FLAGS_INCL_FUNCNAME	(1<<2)
+#define _DPRINTK_FLAGS_INCL_LINENO	(1<<3)
+#define _DPRINTK_FLAGS_INCL_TID		(1<<4)
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
 	char enabled;
@@ -42,6 +46,8 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
+extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
+	__attribute__ ((format (printf, 2, 3)));
 
 #define dynamic_pr_debug(fmt, ...) do {					\
 	static struct _ddebug descriptor				\
@@ -50,7 +56,7 @@ extern int ddebug_remove_module(const char *mod_name);
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
 		_DPRINTK_FLAGS_DEFAULT };				\
 	if (unlikely(descriptor.enabled))				\
-		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
 	} while (0)
 
 
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index b335acb..863c834 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2008 Jason Baron <jbaron@redhat.com>
  * By Greg Banks <gnb@melbourne.sgi.com>
  * Copyright (c) 2008 Silicon Graphics Inc.  All Rights Reserved.
+ * Copyright (C) 2011 Bart Van Assche.  All Rights Reserved.
  */
 
 #include <linux/kernel.h>
@@ -27,6 +28,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/jump_label.h>
+#include <linux/hardirq.h>
 
 extern struct _ddebug __start___verbose[];
 extern struct _ddebug __stop___verbose[];
@@ -63,15 +65,25 @@ static inline const char *basename(const char *path)
 	return tail ? tail+1 : path;
 }
 
+static struct { unsigned flag:8; char opt_char; } opt_array[] = {
+	{ _DPRINTK_FLAGS_PRINT, 'p' },
+	{ _DPRINTK_FLAGS_INCL_MODNAME, 'm' },
+	{ _DPRINTK_FLAGS_INCL_FUNCNAME, 'f' },
+	{ _DPRINTK_FLAGS_INCL_LINENO, 'l' },
+	{ _DPRINTK_FLAGS_INCL_TID, 't' },
+};
+
 /* format a string into buf[] which describes the _ddebug's flags */
 static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 				    size_t maxlen)
 {
 	char *p = buf;
+	int i;
 
 	BUG_ON(maxlen < 4);
-	if (dp->flags & _DPRINTK_FLAGS_PRINT)
-		*p++ = 'p';
+	for (i = 0; i < ARRAY_SIZE(opt_array); ++i)
+		if (dp->flags & opt_array[i].flag)
+			*p++ = opt_array[i].opt_char;
 	if (p == buf)
 		*p++ = '-';
 	*p = '\0';
@@ -343,7 +355,7 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 			       unsigned int *maskp)
 {
 	unsigned flags = 0;
-	int op = '=';
+	int op = '=', i;
 
 	switch (*str) {
 	case '+':
@@ -358,13 +370,14 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 		printk(KERN_INFO "%s: op='%c'\n", __func__, op);
 
 	for ( ; *str ; ++str) {
-		switch (*str) {
-		case 'p':
-			flags |= _DPRINTK_FLAGS_PRINT;
-			break;
-		default:
-			return -EINVAL;
+		for (i = ARRAY_SIZE(opt_array) - 1; i >= 0; i--) {
+			if (*str == opt_array[i].opt_char) {
+				flags |= opt_array[i].flag;
+				break;
+			}
 		}
+		if (i < 0)
+			return -EINVAL;
 	}
 	if (flags == 0)
 		return -EINVAL;
@@ -413,6 +426,35 @@ static int ddebug_exec_query(char *query_string)
 	return 0;
 }
 
+int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
+{
+	va_list args;
+	int res;
+
+	BUG_ON(!descriptor);
+	BUG_ON(!fmt);
+
+	va_start(args, fmt);
+	res = printk(KERN_DEBUG);
+	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
+		if (in_interrupt())
+			res += printk(KERN_CONT "<intr> ");
+		else
+			res += printk(KERN_CONT "[%d] ", task_pid_vnr(current));
+	}
+	if (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME)
+		res += printk(KERN_CONT "%s:", descriptor->modname);
+	if (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
+		res += printk(KERN_CONT "%s:", descriptor->function);
+	if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
+		res += printk(KERN_CONT "%d ", descriptor->lineno);
+	res += vprintk(fmt, args);
+	va_end(args);
+
+	return res;
+}
+EXPORT_SYMBOL(__dynamic_pr_debug);
+
 static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
-- 
1.7.4.1


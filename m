Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1CPT7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:59:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1CPT7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:59:04 -0400
Date: Wed, 16 Mar 2011 15:58:23 -0400
From: Jason Baron <jbaron@redhat.com>
To: rostedt@goodmis.org
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        ralf@linux-mips.org, jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
Message-Id: <5b0030e4e7c2b0cfbea666ce2cf0ef95651af5a5.1300299760.git.jbaron@redhat.com>
In-Reply-To: <cover.1300299760.git.jbaron@redhat.com>
References: <cover.1300299760.git.jbaron@redhat.com>
Subject: [PATCH 2/4] dynamic debug: add jump label support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since jump labels make use of atomic_read(), and dynamic_debug.h
gets included by kernel.h, the inclusion of atomic.h in
dynamic_debug.h (to get atomic_read()), would cause a circular
dependency since atomic.h requires kernel.h. Thus, for dynamic
debug I am explicitly including jump_label.h when jump labels are
configured, and making use of a regular reads (non-atomic), when
jump labels are disabled.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |   46 ++++++++++++++++++++++++++++++++++------
 lib/dynamic_debug.c           |    4 +-
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 8906d52..455cb3e 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -1,6 +1,26 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
+/*
+ * When jump labels are disabled, they make use of atomic_read(). Since
+ * dynamic_debug.h gets included by kernel.h, the inclusion of jump_label.h by
+ * dynamic_debug.h and thus atomic.h (to get atomic_read()), would cause a
+ * circular dependency since atomic.h requires kernel.h. Thus, for dynamic debug
+ * we are explicitly including jump_label.h when jump labels are configured, and
+ * making use of a regular reads (non-atomic), when jump labels are disabled.
+ */
+#if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+#include <linux/jump_label.h>
+#endif
+
+#ifdef HAVE_JUMP_LABEL
+ #define dd_enable(dp) do { jump_label_inc(&dp->enabled); } while (0)
+ #define dd_disable(dp) do { jump_label_dec(&dp->enabled); } while (0)
+#else
+ #define dd_enable(dp) do { dp->enabled = 1; } while (0)
+ #define dd_disable(dp) do { dp->enabled = 0; } while (0)
+#endif
+
 /* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
  * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
  * use independent hash functions, to reduce the chance of false positives.
@@ -31,7 +51,11 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
-	char enabled;
+#ifdef HAVE_JUMP_LABEL
+	struct jump_label_key enabled;
+#else
+	int enabled;
+#endif
 } __attribute__((aligned(8)));
 
 
@@ -41,14 +65,22 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
 
+#ifdef HAVE_JUMP_LABEL
+# define DDEBUG_INIT JUMP_LABEL_INIT
+# define DDEBUG_BRANCH(enabled) static_branch(&enabled)
+#else
+# define DDEBUG_INIT 0
+# define DDEBUG_BRANCH(enabled) unlikely(enabled)
+#endif
+
 #define dynamic_pr_debug(fmt, ...) do {					\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
+		_DPRINTK_FLAGS_DEFAULT, DDEBUG_INIT };                   \
+	if (DDEBUG_BRANCH(descriptor.enabled))				\
+		printk(KERN_DEBUG pr_fmt(fmt),  ##__VA_ARGS__);         \
 	} while (0)
 
 
@@ -57,9 +89,9 @@ extern int ddebug_remove_module(const char *mod_name);
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
+		_DPRINTK_FLAGS_DEFAULT, DDEBUG_INIT };                  \
+	if (DDEBUG_BRANCH(descriptor.enabled))                          \
+		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);        \
 	} while (0)
 
 #else
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index b335acb..5973c53 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -142,9 +142,9 @@ static void ddebug_change(const struct ddebug_query *query,
 				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags)
-				dp->enabled = 1;
+				dd_enable(dp);
 			else
-				dp->enabled = 0;
+				dd_disable(dp);
 			if (verbose)
 				printk(KERN_INFO
 					"ddebug: changed %s:%d [%s]%s %s\n",
-- 
1.7.1


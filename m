Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0IQPJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165Ab0IQPJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:09:46 -0400
Date: Fri, 17 Sep 2010 11:09:17 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <b77627358cea3e27d7be4386f45f66219afb8452.1284733808.git.jbaron@redhat.com>
In-Reply-To: <cover.1284733808.git.jbaron@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com>
Subject: [PATCH 07/10] jump label v11: convert dynamic debug to use jump labels
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the 'dynamic debug' infrastructure to use jump labels.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |   39 +++++++++++++-----------
 lib/dynamic_debug.c           |   42 ++-------------------------
 scripts/Makefile.lib          |   11 +------
 scripts/basic/Makefile        |    2 +-
 scripts/basic/hash.c          |   64 -----------------------------------------
 5 files changed, 26 insertions(+), 132 deletions(-)
 delete mode 100644 scripts/basic/hash.c

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 52c0da4..bef3cda 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -1,6 +1,8 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
+#include <linux/jump_label.h>
+
 /* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
  * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
  * use independent hash functions, to reduce the chance of false positives.
@@ -22,8 +24,6 @@ struct _ddebug {
 	const char *function;
 	const char *filename;
 	const char *format;
-	char primary_hash;
-	char secondary_hash;
 	unsigned int lineno:24;
 	/*
  	 * The flags field controls the behaviour at the callsite.
@@ -33,6 +33,7 @@ struct _ddebug {
 #define _DPRINTK_FLAGS_PRINT   (1<<0)  /* printk() a message using the format */
 #define _DPRINTK_FLAGS_DEFAULT 0
 	unsigned int flags:8;
+	char enabled;
 } __attribute__((aligned(8)));
 
 
@@ -42,33 +43,35 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
 
-#define __dynamic_dbg_enabled(dd)  ({	     \
-	int __ret = 0;							     \
-	if (unlikely((dynamic_debug_enabled & (1LL << DEBUG_HASH)) &&	     \
-			(dynamic_debug_enabled2 & (1LL << DEBUG_HASH2))))   \
-				if (unlikely(dd.flags))			     \
-					__ret = 1;			     \
-	__ret; })
-
 #define dynamic_pr_debug(fmt, ...) do {					\
+	__label__ do_printk;						\
+	__label__ out;							\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
-		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
-	if (__dynamic_dbg_enabled(descriptor))				\
-		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
+	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
+		_DPRINTK_FLAGS_DEFAULT };				\
+	JUMP_LABEL(&descriptor.enabled, do_printk);			\
+	goto out;							\
+do_printk:								\
+	printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);			\
+out:	;								\
 	} while (0)
 
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
+	__label__ do_printk;						\
+	__label__ out;							\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, DEBUG_HASH,	\
-		DEBUG_HASH2, __LINE__, _DPRINTK_FLAGS_DEFAULT };	\
-	if (__dynamic_dbg_enabled(descriptor))				\
-		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
+	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
+		_DPRINTK_FLAGS_DEFAULT };				\
+	JUMP_LABEL(&descriptor.enabled, do_printk);			\
+	goto out;							\
+do_printk:								\
+	dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);		\
+out:	;								\
 	} while (0)
 
 #else
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 02afc25..e925c7b 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -26,19 +26,11 @@
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
+#include <linux/jump_label.h>
 
 extern struct _ddebug __start___verbose[];
 extern struct _ddebug __stop___verbose[];
 
-/* dynamic_debug_enabled, and dynamic_debug_enabled2 are bitmasks in which
- * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
- * use independent hash functions, to reduce the chance of false positives.
- */
-long long dynamic_debug_enabled;
-EXPORT_SYMBOL_GPL(dynamic_debug_enabled);
-long long dynamic_debug_enabled2;
-EXPORT_SYMBOL_GPL(dynamic_debug_enabled2);
-
 struct ddebug_table {
 	struct list_head link;
 	char *mod_name;
@@ -88,26 +80,6 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
 }
 
 /*
- * must be called with ddebug_lock held
- */
-
-static int disabled_hash(char hash, bool first_table)
-{
-	struct ddebug_table *dt;
-	char table_hash_value;
-
-	list_for_each_entry(dt, &ddebug_tables, link) {
-		if (first_table)
-			table_hash_value = dt->ddebugs->primary_hash;
-		else
-			table_hash_value = dt->ddebugs->secondary_hash;
-		if (dt->num_enabled && (hash == table_hash_value))
-			return 0;
-	}
-	return 1;
-}
-
-/*
  * Search the tables for _ddebug's which match the given
  * `query' and apply the `flags' and `mask' to them.  Tells
  * the user which ddebug's were changed, or whether none
@@ -170,17 +142,9 @@ static void ddebug_change(const struct ddebug_query *query,
 				dt->num_enabled++;
 			dp->flags = newflags;
 			if (newflags) {
-				dynamic_debug_enabled |=
-						(1LL << dp->primary_hash);
-				dynamic_debug_enabled2 |=
-						(1LL << dp->secondary_hash);
+				enable_jump_label(&dp->enabled);
 			} else {
-				if (disabled_hash(dp->primary_hash, true))
-					dynamic_debug_enabled &=
-						~(1LL << dp->primary_hash);
-				if (disabled_hash(dp->secondary_hash, false))
-					dynamic_debug_enabled2 &=
-						~(1LL << dp->secondary_hash);
+				disable_jump_label(&dp->enabled);
 			}
 			if (verbose)
 				printk(KERN_INFO
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54fd1b7..7bfcf1a 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -101,14 +101,6 @@ basename_flags = -D"KBUILD_BASENAME=KBUILD_STR($(call name-fix,$(basetarget)))"
 modname_flags  = $(if $(filter 1,$(words $(modname))),\
                  -D"KBUILD_MODNAME=KBUILD_STR($(call name-fix,$(modname)))")
 
-#hash values
-ifdef CONFIG_DYNAMIC_DEBUG
-debug_flags = -D"DEBUG_HASH=$(shell ./scripts/basic/hash djb2 $(@D)$(modname))"\
-              -D"DEBUG_HASH2=$(shell ./scripts/basic/hash r5 $(@D)$(modname))"
-else
-debug_flags =
-endif
-
 orig_c_flags   = $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(KBUILD_SUBDIR_CCFLAGS) \
                  $(ccflags-y) $(CFLAGS_$(basetarget).o)
 _c_flags       = $(filter-out $(CFLAGS_REMOVE_$(basetarget).o), $(orig_c_flags))
@@ -152,8 +144,7 @@ endif
 
 c_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(__c_flags) $(modkern_cflags)                           \
-		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) \
-		  $(debug_flags)
+		 -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags)
 
 a_flags        = -Wp,-MD,$(depfile) $(NOSTDINC_FLAGS) $(LINUXINCLUDE)     \
 		 $(__a_flags) $(modkern_aflags)
diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index 0955995..4c324a1 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -9,7 +9,7 @@
 # fixdep: 	 Used to generate dependency information during build process
 # docproc:	 Used in Documentation/DocBook
 
-hostprogs-y	:= fixdep docproc hash
+hostprogs-y	:= fixdep docproc
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
diff --git a/scripts/basic/hash.c b/scripts/basic/hash.c
deleted file mode 100644
index 2ef5d3f..0000000
--- a/scripts/basic/hash.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/*
- * Copyright (C) 2008 Red Hat, Inc., Jason Baron <jbaron@redhat.com>
- *
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-
-#define DYNAMIC_DEBUG_HASH_BITS 6
-
-static const char *program;
-
-static void usage(void)
-{
-	printf("Usage: %s <djb2|r5> <modname>\n", program);
-	exit(1);
-}
-
-/* djb2 hashing algorithm by Dan Bernstein. From:
- * http://www.cse.yorku.ca/~oz/hash.html
- */
-
-static unsigned int djb2_hash(char *str)
-{
-	unsigned long hash = 5381;
-	int c;
-
-	c = *str;
-	while (c) {
-		hash = ((hash << 5) + hash) + c;
-		c = *++str;
-	}
-	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
-}
-
-static unsigned int r5_hash(char *str)
-{
-	unsigned long hash = 0;
-	int c;
-
-	c = *str;
-	while (c) {
-		hash = (hash + (c << 4) + (c >> 4)) * 11;
-		c = *++str;
-	}
-	return (unsigned int)(hash & ((1 << DYNAMIC_DEBUG_HASH_BITS) - 1));
-}
-
-int main(int argc, char *argv[])
-{
-	program = argv[0];
-
-	if (argc != 3)
-		usage();
-	if (!strcmp(argv[1], "djb2"))
-		printf("%d\n", djb2_hash(argv[2]));
-	else if (!strcmp(argv[1], "r5"))
-		printf("%d\n", r5_hash(argv[2]));
-	else
-		usage();
-	exit(0);
-}
-
-- 
1.7.1


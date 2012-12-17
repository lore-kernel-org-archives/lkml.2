Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2LQPDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:03:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18300 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2LQPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:03:00 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 05/15] tracepoint: use new hashtable implementation
Date: Mon, 17 Dec 2012 10:01:25 -0500
Message-Id: <1355756497-15834-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch tracepoints to use the new hashtable implementation. This reduces the
amount of generic unrelated code in the tracepoints.

This patch depends on d9b482c ("hashtable: introduce a small and naive
hashtable") which was merged in v3.6.

Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/tracepoint.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d96ba22..5b599f1 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/static_key.h>
+#include <linux/hashtable.h>
 
 extern struct tracepoint * const __start___tracepoints_ptrs[];
 extern struct tracepoint * const __stop___tracepoints_ptrs[];
@@ -49,8 +50,7 @@ static LIST_HEAD(tracepoint_module_list);
  * Protected by tracepoints_mutex.
  */
 #define TRACEPOINT_HASH_BITS 6
-#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
-static struct hlist_head tracepoint_table[TRACEPOINT_TABLE_SIZE];
+static DEFINE_HASHTABLE(tracepoint_table, TRACEPOINT_HASH_BITS);
 
 /*
  * Note about RCU :
@@ -191,16 +191,15 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
  */
 static struct tracepoint_entry *get_tracepoint(const char *name)
 {
-	struct hlist_head *head;
 	struct hlist_node *node;
 	struct tracepoint_entry *e;
 	u32 hash = jhash(name, strlen(name), 0);
 
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
+	hash_for_each_possible(tracepoint_table, e, node, hlist, hash) {
 		if (!strcmp(name, e->name))
 			return e;
 	}
+
 	return NULL;
 }
 
@@ -210,19 +209,13 @@ static struct tracepoint_entry *get_tracepoint(const char *name)
  */
 static struct tracepoint_entry *add_tracepoint(const char *name)
 {
-	struct hlist_head *head;
-	struct hlist_node *node;
 	struct tracepoint_entry *e;
 	size_t name_len = strlen(name) + 1;
 	u32 hash = jhash(name, name_len-1, 0);
 
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
-		if (!strcmp(name, e->name)) {
-			printk(KERN_NOTICE
-				"tracepoint %s busy\n", name);
-			return ERR_PTR(-EEXIST);	/* Already there */
-		}
+	if (get_tracepoint(name)) {
+		printk(KERN_NOTICE "tracepoint %s busy\n", name);
+		return ERR_PTR(-EEXIST);	/* Already there */
 	}
 	/*
 	 * Using kmalloc here to allocate a variable length element. Could
@@ -234,7 +227,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
-	hlist_add_head(&e->hlist, head);
+	hash_add(tracepoint_table, &e->hlist, hash);
 	return e;
 }
 
@@ -244,7 +237,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
  */
 static inline void remove_tracepoint(struct tracepoint_entry *e)
 {
-	hlist_del(&e->hlist);
+	hash_del(&e->hlist);
 	kfree(e);
 }
 
-- 
1.8.0


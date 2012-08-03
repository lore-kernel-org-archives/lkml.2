Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2HCOXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:23:42 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35880 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2HCOXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:23:24 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org
Cc: tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com, davem@davemloft.net,
        rostedt@goodmis.org, mingo@elte.hu, ebiederm@xmission.com,
        aarcange@redhat.com, ericvh@gmail.com, netdev@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC v2 6/7] tracepoint: use new hashtable implementation
Date: Fri,  3 Aug 2012 16:23:07 +0200
Message-Id: <1344003788-1417-7-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch tracepoints to use the new hashtable implementation. This reduces the amount of
generic unrelated code in the tracepoints.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 kernel/tracepoint.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d96ba22..b5a2650 100644
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
+DEFINE_STATIC_HASHTABLE(tracepoint_table, TRACEPOINT_HASH_BITS);
 
 /*
  * Note about RCU :
@@ -191,16 +191,14 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
  */
 static struct tracepoint_entry *get_tracepoint(const char *name)
 {
-	struct hlist_head *head;
 	struct hlist_node *node;
 	struct tracepoint_entry *e;
 	u32 hash = jhash(name, strlen(name), 0);
 
-	head = &tracepoint_table[hash & (TRACEPOINT_TABLE_SIZE - 1)];
-	hlist_for_each_entry(e, node, head, hlist) {
+	hash_for_each_possible(&tracepoint_table, node, e, hlist, hash)
 		if (!strcmp(name, e->name))
 			return e;
-	}
+
 	return NULL;
 }
 
@@ -210,19 +208,13 @@ static struct tracepoint_entry *get_tracepoint(const char *name)
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
@@ -234,7 +226,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
 	memcpy(&e->name[0], name, name_len);
 	e->funcs = NULL;
 	e->refcount = 0;
-	hlist_add_head(&e->hlist, head);
+	hash_add(&tracepoint_table, &e->hlist, hash);
 	return e;
 }
 
@@ -244,7 +236,7 @@ static struct tracepoint_entry *add_tracepoint(const char *name)
  */
 static inline void remove_tracepoint(struct tracepoint_entry *e)
 {
-	hlist_del(&e->hlist);
+	hash_del(&e->hlist);
 	kfree(e);
 }
 
-- 
1.7.8.6


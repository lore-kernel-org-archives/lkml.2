Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1ESCND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 22:13:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58541 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab1ESCM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 22:12:57 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=k5rAD8_ZGUwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=meVymXHHAAAA:8 a=SN9RV68_6VhCKgxovi4A:9 a=4niIxAcjxNTzXcwDGfQA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110519021256.720408836@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 22:12:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH 09/13] ftrace: Free hash with call_rcu_sched()
References: <20110519021151.600991800@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Free-hash-with-call_rcu_sched.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When a hash is modified and might be in use, we need to perform
a schedule RCU operation on it, as the hashes will soon be used
directly in the function tracer callback.

Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   55 +++++++++++++++++++++++++------------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index dcce0bf..92b6fdf 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -913,6 +913,7 @@ struct ftrace_hash {
 	unsigned long		size_bits;
 	struct hlist_head	*buckets;
 	unsigned long		count;
+	struct rcu_head		rcu;
 };
 
 /*
@@ -1058,6 +1059,21 @@ static void free_ftrace_hash(struct ftrace_hash *hash)
 	kfree(hash);
 }
 
+static void __free_ftrace_hash_rcu(struct rcu_head *rcu)
+{
+	struct ftrace_hash *hash;
+
+	hash = container_of(rcu, struct ftrace_hash, rcu);
+	free_ftrace_hash(hash);
+}
+
+static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
+{
+	if (!hash || hash == EMPTY_HASH)
+		return;
+	call_rcu_sched(&hash->rcu, __free_ftrace_hash_rcu);
+}
+
 static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
 {
 	struct ftrace_hash *hash;
@@ -1122,7 +1138,8 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	struct ftrace_func_entry *entry;
 	struct hlist_node *tp, *tn;
 	struct hlist_head *hhd;
-	struct ftrace_hash *hash = *dst;
+	struct ftrace_hash *old_hash;
+	struct ftrace_hash *new_hash;
 	unsigned long key;
 	int size = src->count;
 	int bits = 0;
@@ -1133,13 +1150,11 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	 * the empty_hash.
 	 */
 	if (!src->count) {
-		free_ftrace_hash(*dst);
-		*dst = EMPTY_HASH;
+		free_ftrace_hash_rcu(*dst);
+		rcu_assign_pointer(*dst, EMPTY_HASH);
 		return 0;
 	}
 
-	ftrace_hash_clear(hash);
-
 	/*
 	 * Make the hash size about 1/2 the # found
 	 */
@@ -1150,27 +1165,9 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	if (bits > FTRACE_HASH_MAX_BITS)
 		bits = FTRACE_HASH_MAX_BITS;
 
-	/* We can't modify the empty_hash */
-	if (hash == EMPTY_HASH) {
-		/* Create a new hash */
-		*dst = alloc_ftrace_hash(bits);
-		if (!*dst) {
-			*dst = EMPTY_HASH;
-			return -ENOMEM;
-		}
-		hash = *dst;
-	} else {
-		size = 1 << bits;
-
-		/* Use the old hash, but create new buckets */
-		hhd = kzalloc(sizeof(*hhd) * size, GFP_KERNEL);
-		if (!hhd)
-			return -ENOMEM;
-
-		kfree(hash->buckets);
-		hash->buckets = hhd;
-		hash->size_bits = bits;
-	}
+	new_hash = alloc_ftrace_hash(bits);
+	if (!new_hash)
+		return -ENOMEM;
 
 	size = 1 << src->size_bits;
 	for (i = 0; i < size; i++) {
@@ -1181,10 +1178,14 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 			else
 				key = 0;
 			remove_hash_entry(src, entry);
-			__add_hash_entry(hash, entry);
+			__add_hash_entry(new_hash, entry);
 		}
 	}
 
+	old_hash = *dst;
+	rcu_assign_pointer(*dst, new_hash);
+	free_ftrace_hash_rcu(old_hash);
+
 	return 0;
 }
 
-- 
1.7.4.4



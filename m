Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1GPL0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:26:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab1GPLWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:22:54 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=EFbp286fV7wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=aGSmZ8zflFX0ffpJo1AA:9 a=QB1M6VmUMlts2c8EtdMA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112251.969749160@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/20] ftrace: Balance records when updating the hash
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Balance-records-when-updating-the-hash.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Whenever the hash of the ftrace_ops is updated, the record counts
must be balance. This requires disabling the records that are set
in the original hash, and then enabling the records that are set
in the updated hash.

Moving the update into ftrace_hash_move() removes the bug where the
hash was updated but the records were not, which results in ftrace
triggering a warning and disabling itself because the ftrace_ops filter
is updated while the ftrace_ops was registered, and then the failure
happens when the ftrace_ops is unregistered.

The current code will not trigger this bug, but new code will.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index df93392..853f6f0 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1170,8 +1170,14 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
 	return NULL;
 }
 
+static void
+ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
+static void
+ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
+
 static int
-ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
+ftrace_hash_move(struct ftrace_ops *ops, int enable,
+		 struct ftrace_hash **dst, struct ftrace_hash *src)
 {
 	struct ftrace_func_entry *entry;
 	struct hlist_node *tp, *tn;
@@ -1181,9 +1187,16 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	unsigned long key;
 	int size = src->count;
 	int bits = 0;
+	int ret;
 	int i;
 
 	/*
+	 * Remove the current set, update the hash and add
+	 * them back.
+	 */
+	ftrace_hash_rec_disable(ops, enable);
+
+	/*
 	 * If the new source is empty, just free dst and assign it
 	 * the empty_hash.
 	 */
@@ -1203,9 +1216,10 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	if (bits > FTRACE_HASH_MAX_BITS)
 		bits = FTRACE_HASH_MAX_BITS;
 
+	ret = -ENOMEM;
 	new_hash = alloc_ftrace_hash(bits);
 	if (!new_hash)
-		return -ENOMEM;
+		goto out;
 
 	size = 1 << src->size_bits;
 	for (i = 0; i < size; i++) {
@@ -1224,7 +1238,16 @@ ftrace_hash_move(struct ftrace_hash **dst, struct ftrace_hash *src)
 	rcu_assign_pointer(*dst, new_hash);
 	free_ftrace_hash_rcu(old_hash);
 
-	return 0;
+	ret = 0;
+ out:
+	/*
+	 * Enable regardless of ret:
+	 *  On success, we enable the new hash.
+	 *  On failure, we re-enable the original hash.
+	 */
+	ftrace_hash_rec_enable(ops, enable);
+
+	return ret;
 }
 
 /*
@@ -2845,7 +2868,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 		ftrace_match_records(hash, buf, len);
 
 	mutex_lock(&ftrace_lock);
-	ret = ftrace_hash_move(orig_hash, hash);
+	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
 	mutex_unlock(&ftrace_lock);
 
 	mutex_unlock(&ftrace_regex_lock);
@@ -3028,18 +3051,12 @@ ftrace_regex_release(struct inode *inode, struct file *file)
 			orig_hash = &iter->ops->notrace_hash;
 
 		mutex_lock(&ftrace_lock);
-		/*
-		 * Remove the current set, update the hash and add
-		 * them back.
-		 */
-		ftrace_hash_rec_disable(iter->ops, filter_hash);
-		ret = ftrace_hash_move(orig_hash, iter->hash);
-		if (!ret) {
-			ftrace_hash_rec_enable(iter->ops, filter_hash);
-			if (iter->ops->flags & FTRACE_OPS_FL_ENABLED
-			    && ftrace_enabled)
-				ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-		}
+		ret = ftrace_hash_move(iter->ops, filter_hash,
+				       orig_hash, iter->hash);
+		if (!ret && (iter->ops->flags & FTRACE_OPS_FL_ENABLED)
+		    && ftrace_enabled)
+			ftrace_run_update_code(FTRACE_ENABLE_CALLS);
+
 		mutex_unlock(&ftrace_lock);
 	}
 	free_ftrace_hash(iter->hash);
-- 
1.7.5.4



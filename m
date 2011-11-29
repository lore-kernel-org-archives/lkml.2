Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab1LERnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:43:42 -0500
Received: from www17.your-server.de ([213.133.104.17]:50777 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab1LERnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:43:40 -0500
Subject: [PATCH] tracing/syscalls: Use kcalloc instead of kzalloc to
 allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.347.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
--- a/kernel/trace/ftrace.c 2011-11-13 11:08:12.084207678 +0100
+++ b/kernel/trace/ftrace.c 2011-11-28 20:09:21.703638214 +0100
@@ -1131,7 +1131,7 @@ static struct ftrace_hash *alloc_ftrace_
 		return NULL;
 
 	size = 1 << size_bits;
-	hash->buckets = kzalloc(sizeof(*hash->buckets) * size, GFP_KERNEL);
+	hash->buckets = kcalloc(size, sizeof(*hash->buckets), GFP_KERNEL);
 
 	if (!hash->buckets) {
 		kfree(hash);
diff -u -p a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
--- a/kernel/trace/trace_events_filter.c 2011-11-13 11:08:12.107541380 +0100
+++ b/kernel/trace/trace_events_filter.c 2011-11-28 20:09:19.846949470 +0100
@@ -679,7 +679,7 @@ find_event_field(struct ftrace_event_cal
 
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
-	stack->preds = kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
+	stack->preds = kcalloc(n_preds + 1, sizeof(*stack->preds), GFP_KERNEL);
 	if (!stack->preds)
 		return -ENOMEM;
 	stack->index = n_preds;
@@ -820,8 +820,7 @@ static int __alloc_preds(struct event_fi
 	if (filter->preds)
 		__free_preds(filter);
 
-	filter->preds =
-		kzalloc(sizeof(*filter->preds) * n_preds, GFP_KERNEL);
+	filter->preds = kcalloc(n_preds, sizeof(*filter->preds), GFP_KERNEL);
 
 	if (!filter->preds)
 		return -ENOMEM;
@@ -1480,7 +1479,7 @@ static int fold_pred(struct filter_pred
 	children = count_leafs(preds, &preds[root->left]);
 	children += count_leafs(preds, &preds[root->right]);
 
-	root->ops = kzalloc(sizeof(*root->ops) * children, GFP_KERNEL);
+	root->ops = kcalloc(children, sizeof(*root->ops), GFP_KERNEL);
 	if (!root->ops)
 		return -ENOMEM;
 
diff -u -p a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
--- a/kernel/trace/trace_syscalls.c 2011-11-13 11:08:12.124208310 +0100
+++ b/kernel/trace/trace_syscalls.c 2011-11-28 20:09:23.100321500 +0100
@@ -468,8 +468,8 @@ int __init init_ftrace_syscalls(void)
 	unsigned long addr;
 	int i;
 
-	syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
-					NR_syscalls, GFP_KERNEL);
+	syscalls_metadata = kcalloc(NR_syscalls, sizeof(*syscalls_metadata),
+				    GFP_KERNEL);
 	if (!syscalls_metadata) {
 		WARN_ON(1);
 		return -ENOMEM;

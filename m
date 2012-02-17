Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2BQNx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:53:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40188 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab2BQNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:53:56 -0500
Date: Fri, 17 Feb 2012 05:52:51 -0800
From: tip-bot for Thomas Meyer <thomas@m3y3r.de>
Message-ID: <tip-47b0edcb599ea6eb9ef16d3a08932a0e01485293@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, thomas@m3y3r.de, hpa@zytor.com,
        mingo@redhat.com, rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <1322600880.1534.347.camel@localhost.localdomain>
References: <1322600880.1534.347.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/trivial:
  Use kcalloc instead of kzalloc to allocate array
Git-Commit-ID: 47b0edcb599ea6eb9ef16d3a08932a0e01485293
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 05:53:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47b0edcb599ea6eb9ef16d3a08932a0e01485293
Gitweb:     http://git.kernel.org/tip/47b0edcb599ea6eb9ef16d3a08932a0e01485293
Author:     Thomas Meyer <thomas@m3y3r.de>
AuthorDate: Tue, 29 Nov 2011 22:08:00 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 13 Feb 2012 13:48:11 -0500

tracing/trivial: Use kcalloc instead of kzalloc to allocate array

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Link: http://lkml.kernel.org/r/1322600880.1534.347.camel@localhost.localdomain

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c              |    2 +-
 kernel/trace/trace_events_filter.c |    7 +++----
 kernel/trace/trace_syscalls.c      |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e2e0597..d1499e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1129,7 +1129,7 @@ static struct ftrace_hash *alloc_ftrace_hash(int size_bits)
 		return NULL;
 
 	size = 1 << size_bits;
-	hash->buckets = kzalloc(sizeof(*hash->buckets) * size, GFP_KERNEL);
+	hash->buckets = kcalloc(size, sizeof(*hash->buckets), GFP_KERNEL);
 
 	if (!hash->buckets) {
 		kfree(hash);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 24aee71..76afaee 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -685,7 +685,7 @@ find_event_field(struct ftrace_event_call *call, char *name)
 
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
-	stack->preds = kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
+	stack->preds = kcalloc(n_preds + 1, sizeof(*stack->preds), GFP_KERNEL);
 	if (!stack->preds)
 		return -ENOMEM;
 	stack->index = n_preds;
@@ -826,8 +826,7 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 	if (filter->preds)
 		__free_preds(filter);
 
-	filter->preds =
-		kzalloc(sizeof(*filter->preds) * n_preds, GFP_KERNEL);
+	filter->preds = kcalloc(n_preds, sizeof(*filter->preds), GFP_KERNEL);
 
 	if (!filter->preds)
 		return -ENOMEM;
@@ -1486,7 +1485,7 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 	children = count_leafs(preds, &preds[root->left]);
 	children += count_leafs(preds, &preds[root->right]);
 
-	root->ops = kzalloc(sizeof(*root->ops) * children, GFP_KERNEL);
+	root->ops = kcalloc(children, sizeof(*root->ops), GFP_KERNEL);
 	if (!root->ops)
 		return -ENOMEM;
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cb65454..4350015 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
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

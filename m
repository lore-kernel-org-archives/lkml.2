Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab1GKHus (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:50:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776Ab1GKHra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:30 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 09/21] dynamic_debug: save_pending() saves non-matching queries for later.
Date: Mon, 11 Jul 2011 01:46:44 -0600
Message-Id: <1310370416-6322-10-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a query/rule doesnt match, call save_pending(new function)
to copy the query off the stack, into a (new) struct pending_query,
and add to pending_queries (new) list.

Patch adds: /sys/module/dynamic_debug/parameters/
  verbose - rw, added previously, here for completeness
  pending_ct - ro, shows current count of pending queries

With this and previous patches, queries added on the boot-line which
do not match (because module is not built-in, and thus not present yet)
are added to pending_queries.

IE, with these boot-line additions:
 dynamic_debug.verbose=1 ddebug_query="module scx200_hrt +p"

Kernel will log the following:

ddebug_exec_queries: query 0: "module scx200_hrt +p"
ddebug_tokenize: split into words: "module" "scx200_hrt" "+p"
ddebug_parse_query: parsed q->function="(null)" q->filename="(null)" \
	q->module="scx200_hrt" q->format="(null)" q->lineno=0-0
ddebug_parse_flags: op='+'
ddebug_parse_flags: flags=0x1
ddebug_parse_flags: *flagsp=0x1 *maskp=0xffffffff
ddebug_exec_query: nfound 0 on q->function="(null)" q->filename="(null)" \
	q->module="scx200_hrt" q->format="(null)" q->lineno=0-0
ddebug_save_pending: add to pending: q->function="(null)" q->filename="(null)"\
	q->module="scx200_hrt" q->format="(null)" q->lineno=0-0
ddebug_save_pending: ddebug: query saved as pending 1

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 81268e2..b049ef2 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -53,6 +53,16 @@ struct ddebug_query {
 	unsigned int first_lineno, last_lineno;
 };
 
+struct pending_query {
+	struct list_head link;
+	struct ddebug_query query;
+	char filename[100];
+	char module[30];
+	char function[50];
+	char format[200];
+	unsigned int flags, mask;
+};
+
 struct ddebug_iter {
 	struct ddebug_table *table;
 	unsigned int idx;
@@ -63,6 +73,11 @@ static LIST_HEAD(ddebug_tables);
 static int verbose = 0;
 module_param(verbose, int, 0644);
 
+/* legal but inapplicable queries, save and test against new modules */
+static LIST_HEAD(pending_queries);
+static int pending_ct;
+module_param(pending_ct, int, 0444);
+
 /* Return the last part of a pathname */
 static inline const char *basename(const char *path)
 {
@@ -421,6 +436,42 @@ static int ddebug_parse_flags(const char *str, unsigned int *flagsp,
 	return 0;
 }
 
+/* copy query off stack, save flags & mask, and store in pending-list */
+static int ddebug_save_pending(struct ddebug_query *query,
+				unsigned int flags, unsigned int mask)
+{
+	struct pending_query *pq;
+
+	if (verbose)
+		pr_info("add to pending: %s\n", show_ddebug_query(query));
+
+	pending_ct++;
+	pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
+	if (pq == NULL)
+		return -ENOMEM;
+
+	/* copy non-null match-specs into allocd mem, update pointers */
+	if (query->module)
+		pq->query.module = strcpy(pq->module, query->module);
+	if (query->function)
+		pq->query.function = strcpy(pq->function, query->function);
+	if (query->filename)
+		pq->query.filename = strcpy(pq->filename, query->filename);
+	if (query->format)
+		pq->query.format = strcpy(pq->format, query->format);
+
+	pq->flags = flags;
+	pq->mask = mask;
+
+	mutex_lock(&ddebug_lock);
+	list_add(&pq->link, &pending_queries);
+	mutex_unlock(&ddebug_lock);
+
+	if (verbose)
+		pr_info("query saved as pending %d\n", pending_ct);
+	return 0;
+}
+
 static int ddebug_exec_query(char *query_string)
 {
 	unsigned int flags = 0, mask = 0;
@@ -440,6 +491,11 @@ static int ddebug_exec_query(char *query_string)
 
 	/* actually go and implement the change */
 	nfound = ddebug_change(&query, flags, mask);
+
+	pr_info("nfound %d on %s\n", nfound, show_ddebug_query(&query));
+	if (!nfound)
+		return ddebug_save_pending(&query, flags, mask);
+
 	return 0;
 }
 
-- 
1.7.4.1


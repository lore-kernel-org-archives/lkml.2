Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1GYVpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:45:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37386 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab1GYVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:50 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 21/25] dynamic_debug: shrink struct pending query to size actually needed
Date: Mon, 25 Jul 2011 15:42:46 -0600
Message-Id: <1311630170-26057-22-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove struct pending_query's fixed sized char arrays; function,
filename, module, format, and replace them with a 0-sized charbuf.
Before the struct is allocd, determine the size needed to store
the 4 strings into the charbuf.  Then copy the strings off the stack,
and update the field ptrs in the embedded struct ddebug_query to point
into the charbuf.  This change uses strcpy instead of strlcpy, since
we know that the charbuf is big enough to hold the 4 strings.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   37 ++++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 8f56092..5ec8165 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -56,11 +56,8 @@ struct ddebug_query {
 struct pending_query {
 	struct list_head link;
 	struct ddebug_query query;
-	char filename[100];
-	char module[30];
-	char function[50];
-	char format[200];
 	unsigned int flags, mask;
+	char buf[0];
 };
 
 struct ddebug_iter {
@@ -507,7 +504,8 @@ static int ddebug_save_pending(struct ddebug_query *query,
 				unsigned int flags, unsigned int mask)
 {
 	struct pending_query *pq, *pqnext;
-	char *qstr;
+	char *qstr, *bp;
+	size_t buflen;
 
 	list_for_each_entry_safe(pq, pqnext, &pending_queries, link) {
 		if (queries_match(query, &pq->query)) {
@@ -537,26 +535,33 @@ static int ddebug_save_pending(struct ddebug_query *query,
 	pr_debug("add to pending: %s\n", qstr);
 	kfree(qstr);
 
-	pq = kzalloc(sizeof(struct pending_query), GFP_KERNEL);
+	buflen = (query->module ? strlen(query->module) : 0)
+		+ (query->function ? strlen(query->function) : 0)
+		+ (query->filename ? strlen(query->filename) : 0)
+		+ (query->format ? strlen(query->format) : 0)
+		+ 4; /* for \0's */
+
+	pq = kzalloc(sizeof(struct pending_query) + buflen, GFP_KERNEL);
 	if (pq == NULL)
 		return -ENOMEM;
 
 	/* copy non-null match-specs into allocd mem, update pointers */
+	bp = pq->buf;
 	if (query->module) {
-		strlcpy(pq->module, query->module, sizeof(pq->module));
-		pq->query.module = pq->module;
+		pq->query.module = strcpy(bp, query->module);
+		bp += strlen(bp) + 1;
 	}
 	if (query->function) {
-		strlcpy(pq->function, query->function, sizeof(pq->function));
-		pq->query.function = pq->function;
+		pq->query.function = strcpy(bp, query->function);
+		bp += strlen(bp) + 1;
 	}
 	if (query->filename) {
-		strlcpy(pq->filename, query->filename, sizeof(pq->filename));
-		pq->query.filename = pq->filename;
+		pq->query.filename = strcpy(bp, query->filename);
+		bp += strlen(bp) + 1;
 	}
 	if (query->format) {
-		strlcpy(pq->format, query->format, sizeof(pq->format));
-		pq->query.format = pq->format;
+		pq->query.format = strcpy(bp, query->format);
+		bp += strlen(bp) + 1;
 	}
 	pq->flags = flags;
 	pq->mask = mask;
@@ -564,7 +569,9 @@ static int ddebug_save_pending(struct ddebug_query *query,
 	list_add(&pq->link, &pending_queries);
 	pending_ct++;
 
-	pr_debug("query saved as pending %d\n", pending_ct);
+	pr_debug("query saved as pending %d, in %d+%d bytes\n",
+		pending_ct, sizeof(struct pending_query), buflen);
+
 	return 0;
 }
 
-- 
1.7.4.1


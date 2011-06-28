Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1F1HMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37663 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab1F1HKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Eff2uPUXgVIay0suM5gly9Bl783H/9y+Q9VStEncwMqlMeYi1AxfKgZ31qRE9ji37N
         joEOyFaemEAJ5wsjx4mdcP+/CZy4sQM2umuPhUcZahydpqsv3v5vjIEeIqG/pxb55BV9
         3YIxpgeVv9oA18wiDWnGgCMBSkdnNNvGHqQXI=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/11] dynamic_debug: return int from ddebug_change
Date: Tue, 28 Jun 2011 01:09:49 -0600
Message-Id: <1309244992-2305-9-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alter ddebug_change to return number of matches found for query/rule.
This lets caller know whether rule applied, and potentially what
to do next.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 97f6a9b..9b8b1e8 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -102,8 +102,8 @@ static char *ddebug_describe_flags(struct _ddebug *dp, char *buf,
  * the user which ddebug's were changed, or whether none
  * were matched.
  */
-static void ddebug_change(const struct ddebug_query *query,
-			   unsigned int flags, unsigned int mask)
+static int ddebug_change(const struct ddebug_query *query,
+			unsigned int flags, unsigned int mask)
 {
 	int i;
 	struct ddebug_table *dt;
@@ -172,8 +172,7 @@ static void ddebug_change(const struct ddebug_query *query,
 	}
 	mutex_unlock(&ddebug_lock);
 
-	if (!nfound && verbose)
-		pr_info("no matches for query\n");
+	return nfound;
 }
 
 /*
@@ -425,6 +424,7 @@ static int ddebug_exec_query(char *query_string)
 #define MAXWORDS 9
 	int nwords;
 	char *words[MAXWORDS];
+	int nfound;
 
 	nwords = ddebug_tokenize(query_string, words, MAXWORDS);
 	if (nwords <= 0)
@@ -435,7 +435,8 @@ static int ddebug_exec_query(char *query_string)
 		return -EINVAL;
 
 	/* actually go and implement the change */
-	ddebug_change(&query, flags, mask);
+	nfound = ddebug_change(&query, flags, mask);
+
 	return 0;
 }
 
-- 
1.7.4.1


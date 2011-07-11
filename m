Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1GKHrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:47:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab1GKHrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:47:21 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, bvanassche@acm.org, joe@perches.com,
        gregkh@suse.de, gnb@fmeh.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/21] dynamic_debug: warn when >1 of each type of match-spec is given
Date: Mon, 11 Jul 2011 01:46:39 -0600
Message-Id: <1310370416-6322-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
 <1310370416-6322-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue warning when a match-spec is given multiple times in a rule.
Previous code kept last one, but was silent about it.  Docs imply only
one is allowed by saying match-specs are ANDed together, given that
module M cannot match both A and B.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index ae72402..0575113 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -281,6 +281,14 @@ static char *unescape(char *str)
 	return str;
 }
 
+static inline void check_set(const char **dest, char *src, char *name)
+{
+	if (*dest)
+		pr_warn("match-spec:%s val:%s overridden by %s",
+			name, *dest, src);
+	*dest = src;
+}
+
 /*
  * Parse words[] as a ddebug query specification, which is a series
  * of (keyword, value) pairs chosen from these possibilities:
@@ -292,6 +300,9 @@ static char *unescape(char *str)
  * format <escaped-string-to-find-in-format>
  * line <lineno>
  * line <first-lineno>-<last-lineno> // where either may be empty
+ *
+ * only 1 pair of each type is expected, subsequent ones elicit a
+ * warning, and override the setting.
  */
 static int ddebug_parse_query(char *words[], int nwords,
 			       struct ddebug_query *query)
@@ -305,13 +316,14 @@ static int ddebug_parse_query(char *words[], int nwords,
 
 	for (i = 0 ; i < nwords ; i += 2) {
 		if (!strcmp(words[i], "func"))
-			query->function = words[i+1];
+			check_set(&query->function, words[i+1], "func");
 		else if (!strcmp(words[i], "file"))
-			query->filename = words[i+1];
+			check_set(&query->filename, words[i+1], "file");
 		else if (!strcmp(words[i], "module"))
-			query->module = words[i+1];
+			check_set(&query->module, words[i+1], "module");
 		else if (!strcmp(words[i], "format"))
-			query->format = unescape(words[i+1]);
+			check_set(&query->format, unescape(words[i+1]),
+				"format");
 		else if (!strcmp(words[i], "line")) {
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
-- 
1.7.4.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1GYVnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:43:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37386 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab1GYVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:43:28 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/25] dynamic_debug: warn when >1 of each type of match-spec is given
Date: Mon, 25 Jul 2011 15:42:33 -0600
Message-Id: <1311630170-26057-9-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
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
index 8ce941a..6746439 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -280,6 +280,14 @@ static char *unescape(char *str)
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
@@ -291,6 +299,9 @@ static char *unescape(char *str)
  * format <escaped-string-to-find-in-format>
  * line <lineno>
  * line <first-lineno>-<last-lineno> // where either may be empty
+ *
+ * only 1 pair of each type is expected, subsequent ones elicit a
+ * warning, and override the setting.
  */
 static int ddebug_parse_query(char *words[], int nwords,
 			       struct ddebug_query *query)
@@ -304,13 +315,14 @@ static int ddebug_parse_query(char *words[], int nwords,
 
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab1IUV4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 17:56:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49731 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab1IUVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 17:55:55 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: joe@perches.com, bart.vanassche@gmail.com, greg@kroah.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/26] dynamic_debug: warn when >1 of each type of match-spec is given
Date: Wed, 21 Sep 2011 15:54:53 -0600
Message-Id: <1316642115-20029-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
References: <1316642115-20029-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

Issue warning when a match-spec is given multiple times in a rule.
Previous code kept last one, but was silent about it.  Docs imply only
one is allowed by saying match-specs are ANDed together, given that
module M cannot match both A and B.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 6372b18..a52b78a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -276,6 +276,14 @@ static char *unescape(char *str)
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
@@ -287,6 +295,9 @@ static char *unescape(char *str)
  * format <escaped-string-to-find-in-format>
  * line <lineno>
  * line <first-lineno>-<last-lineno> // where either may be empty
+ *
+ * only 1 pair of each type is expected, subsequent ones elicit a
+ * warning, and override the setting.
  */
 static int ddebug_parse_query(char *words[], int nwords,
 			       struct ddebug_query *query)
@@ -300,13 +311,14 @@ static int ddebug_parse_query(char *words[], int nwords,
 
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
1.7.4.4


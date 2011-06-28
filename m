Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1F1HMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50563 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab1F1HKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NSnVGSc52Bxj+cr6IQtY9OlMDCWSOYyfj8cyErWWvXxRVYVM8ZoP5D42VxmW4l0p0A
         Mf+Muh3hJ4TyutW+oNMFlPZjHIsoUdqrwv12L1nfWfJ+ipaRLBiqb1M3T+YX+qn6C2pv
         eOnsOLaPMWTyMZMrZFLc8PZaNRlsNW/rDCboU=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 04/11] dynamic_debug: warn when >1 of each type of match-spec is given
Date: Tue, 28 Jun 2011 01:09:45 -0600
Message-Id: <1309244992-2305-5-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
References: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Issue warnings when any match-spec is given multiple times in a rule.
Code honoredi last one, but was silent about it.  Docs imply only one is
allowed, by saying match-specs are ANDed together, given that module M
cannot match both A and B.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 0e567ad..2505232 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -284,6 +284,14 @@ static char *unescape(char *str)
 	return str;
 }
 
+static inline void check_set(const char **dest, char *src, char *name)
+{
+	if (*dest)
+		pr_warning("match-spec:%s val:%s overridden by %s",
+			name, *dest, src);
+	*dest = src;
+}
+
 /*
  * Parse words[] as a ddebug query specification, which is a series
  * of (keyword, value) pairs chosen from these possibilities:
@@ -295,6 +303,9 @@ static char *unescape(char *str)
  * format <escaped-string-to-find-in-format>
  * line <lineno>
  * line <first-lineno>-<last-lineno> // where either may be empty
+ *
+ * only 1 pair of each type is expected, subsequent ones elicit a
+ * warning, and override the setting.
  */
 static int ddebug_parse_query(char *words[], int nwords,
 			       struct ddebug_query *query)
@@ -308,13 +319,13 @@ static int ddebug_parse_query(char *words[], int nwords,
 
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
+			check_set(&query->format, words[i+1], "format");
 		else if (!strcmp(words[i], "line")) {
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
-- 
1.7.4.1


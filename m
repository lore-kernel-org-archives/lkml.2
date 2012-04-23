Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2DWFAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 01:00:30 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46999 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab2DWE71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:59:27 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-d8-4f94e1ac06a7
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/11] parse-filter: Check return value of arg_to_str()
Date: Mon, 23 Apr 2012 13:58:38 +0900
Message-Id: <1335157118-14658-12-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arg_to_str() can fail so we should handle that case properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-filter.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/parse-filter.c b/parse-filter.c
index fa6e6a2..d09fbd2 100644
--- a/parse-filter.c
+++ b/parse-filter.c
@@ -2026,11 +2026,13 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 	char *lstr;
 	char *rstr;
 	char *op;
-	char *str;
+	char *str = NULL;
 	int len;
 
 	lstr = arg_to_str(filter, arg->exp.left);
 	rstr = arg_to_str(filter, arg->exp.right);
+	if (!lstr || !rstr)
+		goto out;
 
 	switch (arg->exp.type) {
 	case FILTER_EXP_ADD:
@@ -2070,6 +2072,7 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
 	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
 	str = malloc_or_die(len);
 	snprintf(str, len, "%s %s %s", lstr, op, rstr);
+out:
 	free(lstr);
 	free(rstr);
 
@@ -2086,6 +2089,8 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 
 	lstr = arg_to_str(filter, arg->num.left);
 	rstr = arg_to_str(filter, arg->num.right);
+	if (!lstr || !rstr)
+		goto out;
 
 	switch (arg->num.type) {
 	case FILTER_CMP_EQ:
@@ -2122,6 +2127,7 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
 		break;
 	}
 
+out:
 	free(lstr);
 	free(rstr);
 	return str;
@@ -2272,7 +2278,12 @@ int pevent_filter_compare(struct event_filter *filter1, struct event_filter *fil
 		/* The best way to compare complex filters is with strings */
 		str1 = arg_to_str(filter1, filter_type1->filter);
 		str2 = arg_to_str(filter2, filter_type2->filter);
-		result = strcmp(str1, str2) != 0;
+		if (str1 && str2)
+			result = strcmp(str1, str2) != 0;
+		else
+			/* bail out if allocation fails */
+			result = 1;
+
 		free(str1);
 		free(str2);
 		if (result)
-- 
1.7.10


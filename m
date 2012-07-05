Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab2GEPqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:46:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60781 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277Ab2GEPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 14/20] tools lib traceevent: Check return value of arg_to_str()
Date: Thu,  5 Jul 2012 12:45:12 -0300
Message-Id: <1341503118-13198-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The arg_to_str() can fail so we should handle that case properly.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1335157118-14658-12-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/parse-filter.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index d54c2b4..f020ac6 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
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
1.7.9.2.358.g22243


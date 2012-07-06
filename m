Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290Ab2GFLUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:20:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab2GFLUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:20:37 -0400
Date: Fri, 6 Jul 2012 04:20:04 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-0fed48341529716c38493be66591bda458921b75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@alien8.de,
        namhyung@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com, namhyung@gmail.com, bp@alien8.de,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        acme@infradead.org, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1335157118-14658-12-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-12-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Check return value of arg_to_str()
Git-Commit-ID: 0fed48341529716c38493be66591bda458921b75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:20:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fed48341529716c38493be66591bda458921b75
Gitweb:     http://git.kernel.org/tip/0fed48341529716c38493be66591bda458921b75
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 23 Apr 2012 13:58:38 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:31 +0900

tools lib traceevent: Check return value of arg_to_str()

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
 1 files changed, 13 insertions(+), 2 deletions(-)

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

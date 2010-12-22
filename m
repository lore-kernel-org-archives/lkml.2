Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0LVLcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:32:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:34780 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab0LVLcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:32:35 -0500
Date: Wed, 22 Dec 2010 11:32:17 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1292854685-8230-7-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-7-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Handle gracefully some stupid and buggy line syntaxes
Message-ID: <tip-21dd9ae5a4e9f717f3957ec934dd3158129436b8@git.kernel.org>
Git-Commit-ID: 21dd9ae5a4e9f717f3957ec934dd3158129436b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:32:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21dd9ae5a4e9f717f3957ec934dd3158129436b8
Gitweb:     http://git.kernel.org/tip/21dd9ae5a4e9f717f3957ec934dd3158129436b8
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Mon, 20 Dec 2010 15:18:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 17:20:13 -0200

perf probe: Handle gracefully some stupid and buggy line syntaxes

Currently perf probe doesn't handle those incorrect syntaxes:

   $ perf probe -L sched.c:++13
   $ perf probe -L sched.c:-+13
   $ perf probe -L sched.c:10000000000000000000000000000+13

This patches rewrites parse_line_range_desc() to handle them.

As a bonus, it reports more useful error messages instead of: "Tailing
with invalid character...".

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1292854685-8230-7-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |   92 ++++++++++++++++++++++++++--------------
 1 files changed, 60 insertions(+), 32 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 80cc0bc..099336e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -529,6 +529,19 @@ int show_available_vars(struct perf_probe_event *pevs __unused,
 }
 #endif
 
+static int parse_line_num(char **ptr, int *val, const char *what)
+{
+	const char *start = *ptr;
+
+	errno = 0;
+	*val = strtol(*ptr, ptr, 0);
+	if (errno || *ptr == start) {
+		semantic_error("'%s' is not a valid number.\n", what);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /*
  * Stuff 'lr' according to the line range described by 'arg'.
  * The line range syntax is described by:
@@ -538,50 +551,65 @@ int show_available_vars(struct perf_probe_event *pevs __unused,
  */
 int parse_line_range_desc(const char *arg, struct line_range *lr)
 {
-	const char *ptr;
-	char *tmp;
+	char *range, *name = strdup(arg);
+	int err;
+
+	if (!name)
+		return -ENOMEM;
+
+	lr->start = 0;
+	lr->end = INT_MAX;
+
+	range = strchr(name, ':');
+	if (range) {
+		*range++ = '\0';
+
+		err = parse_line_num(&range, &lr->start, "start line");
+		if (err)
+			goto err;
+
+		if (*range == '+' || *range == '-') {
+			const char c = *range++;
+
+			err = parse_line_num(&range, &lr->end, "end line");
+			if (err)
+				goto err;
+
+			if (c == '+') {
+				lr->end += lr->start;
+				/*
+				 * Adjust the number of lines here.
+				 * If the number of lines == 1, the
+				 * the end of line should be equal to
+				 * the start of line.
+				 */
+				lr->end--;
+			}
+		}
 
-	ptr = strchr(arg, ':');
-	if (ptr) {
-		lr->start = (int)strtoul(ptr + 1, &tmp, 0);
-		if (*tmp == '+') {
-			lr->end = lr->start + (int)strtoul(tmp + 1, &tmp, 0);
-			lr->end--;	/*
-					 * Adjust the number of lines here.
-					 * If the number of lines == 1, the
-					 * the end of line should be equal to
-					 * the start of line.
-					 */
-		} else if (*tmp == '-')
-			lr->end = (int)strtoul(tmp + 1, &tmp, 0);
-		else
-			lr->end = INT_MAX;
 		pr_debug("Line range is %d to %d\n", lr->start, lr->end);
+
+		err = -EINVAL;
 		if (lr->start > lr->end) {
 			semantic_error("Start line must be smaller"
 				       " than end line.\n");
-			return -EINVAL;
+			goto err;
 		}
-		if (*tmp != '\0') {
-			semantic_error("Tailing with invalid character '%d'.\n",
-				       *tmp);
-			return -EINVAL;
+		if (*range != '\0') {
+			semantic_error("Tailing with invalid str '%s'.\n", range);
+			goto err;
 		}
-		tmp = strndup(arg, (ptr - arg));
-	} else {
-		tmp = strdup(arg);
-		lr->end = INT_MAX;
 	}
 
-	if (tmp == NULL)
-		return -ENOMEM;
-
-	if (strchr(tmp, '.'))
-		lr->file = tmp;
+	if (strchr(name, '.'))
+		lr->file = name;
 	else
-		lr->function = tmp;
+		lr->function = name;
 
 	return 0;
+err:
+	free(name);
+	return err;
 }
 
 /* Check the name is good for event/group */

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2FMP3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:29:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34847 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2FMP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:29:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Cromie <jim.cromie@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf stat: Fix default output file
Date: Wed, 13 Jun 2012 12:29:26 -0300
Message-Id: <1339601367-17834-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1339601367-17834-1-git-send-email-acme@infradead.org>
References: <1339601367-17834-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The following commit:

commit 56f3bae70638b33477a6015fd362ccfe354fd3ee
Author: Jim Cromie <jim.cromie@gmail.com>
Date:   Wed Sep 7 17:14:00 2011 -0600

    perf stat: Add --log-fd <N> option to redirect stderr elsewhere

introduced a bug in the way perf stat outputs the results by default,
i.e., without the --log-fd or --output option. It would default to
writing to file descriptor 0, i.e., stdin. Writing to stdin is allowed
and is equivalent to writing to stdout. However, there is a major
difference for any script that was already capturing the output of perf
stat via redirection:

    perf stat >/tmp/log .... or perf stat 2>/tmp/log ....

They would not capture anything anymore. They would have to do:
    perf stat 0>/tmp/log ...

This breaks compatibility with existing scripts and does not look very
natural.

This patch fixes the problem by looking at output_fd only when it was
modified by user (> 0). It also checks that the value if positive.
Passing --log-fd 0 is ignored.

I would also argue that defaulting to stderr for the results is not the
right thing to do, though this patch does not address this specific
issue.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Link: http://lkml.kernel.org/r/20120515111111.GA9870@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2625899..07b5c77 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -1179,6 +1179,12 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		fprintf(stderr, "cannot use both --output and --log-fd\n");
 		usage_with_options(stat_usage, options);
 	}
+
+	if (output_fd < 0) {
+		fprintf(stderr, "argument to --log-fd must be a > 0\n");
+		usage_with_options(stat_usage, options);
+	}
+
 	if (!output) {
 		struct timespec tm;
 		mode = append_file ? "a" : "w";
@@ -1190,7 +1196,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		}
 		clock_gettime(CLOCK_REALTIME, &tm);
 		fprintf(output, "# started on %s\n", ctime(&tm.tv_sec));
-	} else if (output_fd != 2) {
+	} else if (output_fd > 0) {
 		mode = append_file ? "a" : "w";
 		output = fdopen(output_fd, mode);
 		if (!output) {
-- 
1.7.1


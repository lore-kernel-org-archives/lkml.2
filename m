Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab2FOTMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 15:12:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab2FOTMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 15:12:09 -0400
Date: Fri, 15 Jun 2012 12:11:46 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-fc3e4d077d5c7a7bc1ad5bc143895b4e070e5a8b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        jim.cromie@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        jim.cromie@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20120515111111.GA9870@quad>
References: <20120515111111.GA9870@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Fix default output file
Git-Commit-ID: fc3e4d077d5c7a7bc1ad5bc143895b4e070e5a8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 15 Jun 2012 12:11:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc3e4d077d5c7a7bc1ad5bc143895b4e070e5a8b
Gitweb:     http://git.kernel.org/tip/fc3e4d077d5c7a7bc1ad5bc143895b4e070e5a8b
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 15 May 2012 13:11:11 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 11 Jun 2012 11:20:21 -0300

perf stat: Fix default output file

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

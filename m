Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab2KROfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:35:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36573 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2KROaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/32] perf tools: Ensure single disable call per event in record comand
Date: Sun, 18 Nov 2012 11:29:45 -0300
Message-Id: <1353248997-30763-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

It's possible we issue the event disable ioctl multiple times until we
read the final portion of the mmap buffer.

Ensuring just single disable ioctl call for event, because there's no
need to do that more than once.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352741644-16809-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 268b356..f3151d3 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -502,6 +502,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	struct perf_evlist *evsel_list = rec->evlist;
 	const char *output_name = rec->output_name;
 	struct perf_session *session;
+	bool disabled = false;
 
 	rec->progname = argv[0];
 
@@ -735,8 +736,10 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 		 * die with the process and we wait for that. Thus no need to
 		 * disable events in this case.
 		 */
-		if (done && !perf_target__none(&opts->target))
+		if (done && !disabled && !perf_target__none(&opts->target)) {
 			perf_evlist__disable(evsel_list);
+			disabled = true;
+		}
 	}
 
 	if (quiet || signr == SIGUSR1)
-- 
1.7.9.2.358.g22243


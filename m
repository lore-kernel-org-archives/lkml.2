Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab2KLRep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:34:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891Ab2KLReh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:34:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf tool: Ensure single disable call per event in record comand
Date: Mon, 12 Nov 2012 18:34:02 +0100
Message-Id: <1352741644-16809-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
References: <1352741644-16809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible we issue the event disable ioctl multiple times
until we read the final portion of the mmap buffer.

Ensuring just single disable ioctl call for event, because
there's no need to do that more than once.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 5 ++++-
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
1.7.11.7


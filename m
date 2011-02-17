Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1BQUlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:41:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1BQUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:41:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/5] perf record: Delay setting the header writing atexit call
Date: Thu, 17 Feb 2011 18:41:30 -0200
Message-Id: <1297975291-12792-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1297975291-12792-1-git-send-email-acme@infradead.org>
References: <1297975291-12792-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

While testing the --filter option I noticed that we were writing lots of
unneeded stuff to the perf.data header when the filter ioctl fails, so
move the atexit(atexit_header) call to after we create the counters
successfully.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a4aaadc..db4cd1e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -538,11 +538,6 @@ static int __cmd_record(int argc, const char **argv)
 	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
-	/*
- 	 * perf_session__delete(session) will be called at atexit_header()
-	 */
-	atexit(atexit_header);
-
 	if (forks) {
 		child_pid = fork();
 		if (child_pid < 0) {
@@ -601,6 +596,11 @@ static int __cmd_record(int argc, const char **argv)
 
 	perf_session__set_sample_type(session, sample_type);
 
+	/*
+	 * perf_session__delete(session) will be called at atexit_header()
+	 */
+	atexit(atexit_header);
+
 	if (pipe_output) {
 		err = perf_header__write_pipe(output);
 		if (err < 0)
-- 
1.6.2.5


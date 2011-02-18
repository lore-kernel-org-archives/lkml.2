Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab1BRKic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 05:38:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:53308 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab1BRKi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 05:38:29 -0500
Date: Fri, 18 Feb 2011 10:38:00 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Delay setting the header writing atexit call
Message-ID: <tip-712a4b6049724278121d56aba683151d86c8c35a@git.kernel.org>
Git-Commit-ID: 712a4b6049724278121d56aba683151d86c8c35a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Feb 2011 10:38:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  712a4b6049724278121d56aba683151d86c8c35a
Gitweb:     http://git.kernel.org/tip/712a4b6049724278121d56aba683151d86c8c35a
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 17 Feb 2011 12:18:42 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Feb 2011 13:58:32 -0200

perf record: Delay setting the header writing atexit call

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

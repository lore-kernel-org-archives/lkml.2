Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab0EEADj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:03:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34078 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222Ab0EEADf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=qAjhTXeMoQ4GfeBfETjofIt/9v0WEYHzR0W2DIoHiUN5IOoc0zlOHiSZ8EcG5M+lgE
         Au1bER/JfPAkKmKi4MWZsJqveZh4i25MQGvNQFGj89XndhqDxLn/RNLoB7Hi32d6kDLg
         SQMci4erp7xOwQRhUa8oRTy73pOu711yki3c4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 1/2] perf: Introduce a new "round of buffers read" pseudo event
Date: Wed,  5 May 2010 02:03:30 +0200
Message-Id: <1273017811-16880-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273017811-16880-1-git-send-regression-fweisbec@gmail.com>
References: <1273017811-16880-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to provide a more robust and deterministic reordering
algorithm, we need to know when we reach a point where we just
did a pass through every counter buffers to read everything they
had.

This patch introduces a new PERF_RECORD_FINISHED_ROUND pseudo event
that only consists in an event header and doesn't need to contain
anything.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 tools/perf/builtin-record.c |   34 ++++++++++++++++++++++++----------
 tools/perf/util/event.h     |    3 ++-
 2 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0ff67d1..96bbf42 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -494,6 +494,29 @@ static void event__synthesize_guest_os(struct machine *machine, void *data)
 		       " relocation symbol.\n", machine->pid);
 }
 
+static struct perf_event_header finished_round_event = {
+	.size = sizeof(struct perf_event_header),
+	.type = PERF_RECORD_FINISHED_ROUND,
+};
+
+static void mmap_read_all(void)
+{
+	int i, counter, thread;
+
+	for (i = 0; i < nr_cpu; i++) {
+		for (counter = 0; counter < nr_counters; counter++) {
+			for (thread = 0; thread < thread_num; thread++) {
+				if (mmap_array[i][counter][thread].base)
+					mmap_read(&mmap_array[i][counter][thread]);
+			}
+
+		}
+	}
+
+	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
+		write_output(&finished_round_event, sizeof(finished_round_event));
+}
+
 static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
@@ -735,16 +758,7 @@ static int __cmd_record(int argc, const char **argv)
 		int hits = samples;
 		int thread;
 
-		for (i = 0; i < nr_cpu; i++) {
-			for (counter = 0; counter < nr_counters; counter++) {
-				for (thread = 0;
-					thread < thread_num; thread++) {
-					if (mmap_array[i][counter][thread].base)
-						mmap_read(&mmap_array[i][counter][thread]);
-				}
-
-			}
-		}
+		mmap_read_all();
 
 		if (hits == samples) {
 			if (done)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index b364da5..6cc1b1d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -84,11 +84,12 @@ struct build_id_event {
 	char			 filename[];
 };
 
-enum perf_header_event_type { /* above any possible kernel type */
+enum perf_user_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_ATTR			= 64,
 	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_BUILD_ID		= 67,
+	PERF_RECORD_FINISHED_ROUND		= 68,
 	PERF_RECORD_HEADER_MAX
 };
 
-- 
1.6.2.3


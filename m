Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab2HCOCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:02:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48819 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2HCOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:01:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/18] perf session: Use perf_evlist__sample_id_all more extensively
Date: Fri,  3 Aug 2012 11:00:58 -0300
Message-Id: <1344002470-5965-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344002470-5965-1-git-send-email-acme@infradead.org>
References: <1344002470-5965-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing perf_session->sample_id_all, as it can be obtained from the
evsel/evlist.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ok58u1mlc5ci9b6p36r52uh1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    9 ++++-----
 tools/perf/util/session.h |    1 -
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 00e180e..348cc11 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -25,7 +25,7 @@ int perf_session__parse_sample(struct perf_session *session,
 
 	return perf_event__parse_sample(event, first->attr.sample_type,
 					first->sample_size,
-					session->sample_id_all, sample,
+					first->attr.sample_id_all, sample,
 					session->header.needs_swap);
 }
 
@@ -103,7 +103,6 @@ out_close:
 
 void perf_session__update_sample_type(struct perf_session *self)
 {
-	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
 	machines__set_id_hdr_size(&self->machines, self->id_hdr_size);
@@ -177,7 +176,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	}
 
 	if (tool && tool->ordering_requires_timestamps &&
-	    tool->ordered_samples && !self->sample_id_all) {
+	    tool->ordered_samples && !perf_evlist__sample_id_all(self->evlist)) {
 		dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
 		tool->ordered_samples = false;
 	}
@@ -887,7 +886,7 @@ static void perf_session__print_tstamp(struct perf_session *session,
 	u64 sample_type = perf_evlist__sample_type(session->evlist);
 
 	if (event->header.type != PERF_RECORD_SAMPLE &&
-	    !session->sample_id_all) {
+	    !perf_evlist__sample_id_all(session->evlist)) {
 		fputs("-1 -1 ", stdout);
 		return;
 	}
@@ -1090,7 +1089,7 @@ static int perf_session__process_event(struct perf_session *session,
 	int ret;
 
 	if (session->header.needs_swap)
-		event_swap(event, session->sample_id_all);
+		event_swap(event, perf_evlist__sample_id_all(session->evlist));
 
 	if (event->header.type >= PERF_RECORD_HEADER_MAX)
 		return -EINVAL;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index c45ce43..a2c3ce9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -44,7 +44,6 @@ struct perf_session {
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
-	bool			sample_id_all;
 	u16			id_hdr_size;
 	int			cwdlen;
 	char			*cwd;
-- 
1.7.1


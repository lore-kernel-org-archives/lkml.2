Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab2HEQvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:51:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56839 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:51:22 -0400
Date: Sun, 5 Aug 2012 09:47:45 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ok58u1mlc5ci9b6p36r52uh1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session:
  Use perf_evlist__sample_id_all more extensively
Git-Commit-ID: 5e5624745d7e4a2c956c072ef2542872955b59c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:47:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e5624745d7e4a2c956c072ef2542872955b59c4
Gitweb:     http://git.kernel.org/tip/5e5624745d7e4a2c956c072ef2542872955b59c4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 1 Aug 2012 19:25:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Aug 2012 19:25:26 -0300

perf session: Use perf_evlist__sample_id_all more extensively

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

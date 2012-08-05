Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2HEQwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 12:52:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2HEQwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 12:52:16 -0400
Date: Sun, 5 Aug 2012 09:48:38 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-1nwc2kslu7gsfblu98xbqbll@git.kernel.org>
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
  Use perf_evlist__id_hdr_size more extensively
Git-Commit-ID: 7b56cce27123ccbf2cb82febbbc88443d719f1f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 05 Aug 2012 09:48:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b56cce27123ccbf2cb82febbbc88443d719f1f8
Gitweb:     http://git.kernel.org/tip/7b56cce27123ccbf2cb82febbbc88443d719f1f8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 1 Aug 2012 19:31:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 1 Aug 2012 19:31:00 -0300

perf session: Use perf_evlist__id_hdr_size more extensively

Removing perf_session->id_hdr_size, as it can be obtained from the
evsel/evlist.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-1nwc2kslu7gsfblu98xbqbll@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/session.c   |   13 +++++++------
 tools/perf/util/session.h   |    3 +--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f5a6452..dc2b625 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -313,7 +313,7 @@ try_again:
 		}
  	}
 
-	perf_session__update_sample_type(session);
+	perf_session__set_id_hdr_size(session);
 }
 
 static int process_buildids(struct perf_record *rec)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 35e86c6..520e425 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1032,7 +1032,7 @@ static int __cmd_top(struct perf_top *top)
 					       &top->session->host_machine);
 	perf_top__start_counters(top);
 	top->session->evlist = top->evlist;
-	perf_session__update_sample_type(top->session);
+	perf_session__set_id_hdr_size(top->session);
 
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 348cc11..5b8601d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -101,11 +101,12 @@ out_close:
 	return -1;
 }
 
-void perf_session__update_sample_type(struct perf_session *self)
+void perf_session__set_id_hdr_size(struct perf_session *session)
 {
-	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
-	self->host_machine.id_hdr_size = self->id_hdr_size;
-	machines__set_id_hdr_size(&self->machines, self->id_hdr_size);
+	u16 id_hdr_size = perf_evlist__id_hdr_size(session->evlist);
+
+	session->host_machine.id_hdr_size = id_hdr_size;
+	machines__set_id_hdr_size(&session->machines, id_hdr_size);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -165,7 +166,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
 	if (mode == O_RDONLY) {
 		if (perf_session__open(self, force) < 0)
 			goto out_delete;
-		perf_session__update_sample_type(self);
+		perf_session__set_id_hdr_size(self);
 	} else if (mode == O_WRONLY) {
 		/*
 		 * In O_RDONLY mode this will be performed when reading the
@@ -1054,7 +1055,7 @@ static int perf_session__process_user_event(struct perf_session *session, union
 	case PERF_RECORD_HEADER_ATTR:
 		err = tool->attr(event, &session->evlist);
 		if (err == 0)
-			perf_session__update_sample_type(session);
+			perf_session__set_id_hdr_size(session);
 		return err;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		return tool->event_type(tool, event);
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index a2c3ce9..e2a1a4b 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -44,7 +44,6 @@ struct perf_session {
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
-	u16			id_hdr_size;
 	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
@@ -83,7 +82,7 @@ void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 
-void perf_session__update_sample_type(struct perf_session *self);
+void perf_session__set_id_hdr_size(struct perf_session *session);
 void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline

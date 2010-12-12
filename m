Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0LLPK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 10:10:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:55098 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab0LLPKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 10:10:23 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf session: Fallback to unordered processing if no sample_id_all
Date: Sun, 12 Dec 2010 13:10:07 -0200
Message-Id: <1292166608-20770-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1292166608-20770-1-git-send-email-acme@infradead.org>
References: <1292166608-20770-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

If we are running the new perf on an old kernel without support for
sample_id_all, we should fall back to the old unordered processing of
events. If we didn't than we would *always* process events without
timestamps out of order, whether or not we hit a reordering race. In
other words, instead of there being a chance of not attributing samples
correctly, we would guarantee that samples would not be attributed.

While processing all events without timestamps before events with
timestamps may seem like an intuitive solution, it falls down as
PERF_RECORD_EXIT events would also be processed before any samples.
Even with a workaround for that case, samples before/after an exec would
not be attributed correctly.

This patch allows commands to indicate whether they need to fall back to
unordered processing, so that commands that do not care about timestamps
on every event will not be affected. If we do fallback, this will print
out a warning if report -D was invoked.

This patch adds the test in perf_session__new so that we only need to
test once per session. Commands that do not use an event_ops (such as
record and top) can simply pass NULL in it's place.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <1291951882-sup-6069@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-buildid-list.c |    3 ++-
 tools/perf/builtin-diff.c         |    4 ++--
 tools/perf/builtin-inject.c       |    2 +-
 tools/perf/builtin-kmem.c         |    3 ++-
 tools/perf/builtin-lock.c         |    2 +-
 tools/perf/builtin-record.c       |    2 +-
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-sched.c        |    3 ++-
 tools/perf/builtin-script.c       |    2 +-
 tools/perf/builtin-timechart.c    |    3 ++-
 tools/perf/builtin-top.c          |    2 +-
 tools/perf/util/session.c         |   11 ++++++++++-
 tools/perf/util/session.h         |    5 ++++-
 14 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 569a276..48dbab4 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -382,7 +382,7 @@ static int __cmd_annotate(void)
 	int ret;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force, false);
+	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index 44a47e1..3b06f9c 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -39,7 +39,8 @@ static int __cmd_buildid_list(void)
 	int err = -1;
 	struct perf_session *session;
 
-	session = perf_session__new(input_name, O_RDONLY, force, false);
+	session = perf_session__new(input_name, O_RDONLY, force, false,
+				    &build_id__mark_dso_hit_ops);
 	if (session == NULL)
 		return -1;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 5e1a043..af84e1c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -142,8 +142,8 @@ static int __cmd_diff(void)
 	int ret, i;
 	struct perf_session *session[2];
 
-	session[0] = perf_session__new(input_old, O_RDONLY, force, false);
-	session[1] = perf_session__new(input_new, O_RDONLY, force, false);
+	session[0] = perf_session__new(input_old, O_RDONLY, force, false, &event_ops);
+	session[1] = perf_session__new(input_new, O_RDONLY, force, false, &event_ops);
 	if (session[0] == NULL || session[1] == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 4b66b85..0c78ffa 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -196,7 +196,7 @@ static int __cmd_inject(void)
 		inject_ops.tracing_data	= event__repipe_tracing_data;
 	}
 
-	session = perf_session__new(input_name, O_RDONLY, false, true);
+	session = perf_session__new(input_name, O_RDONLY, false, true, &inject_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index c9620ff..def7ddc 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -481,7 +481,8 @@ static void sort_result(void)
 static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0, false);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index b41b449..b9c6e54 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -858,7 +858,7 @@ static struct perf_event_ops eops = {
 
 static int read_events(void)
 {
-	session = perf_session__new(input_name, O_RDONLY, 0, false);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
 	if (!session)
 		die("Initializing perf session failed\n");
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 699dd21..c1629dc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -571,7 +571,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	session = perf_session__new(output_name, O_WRONLY,
-				    write_mode == WRITE_FORCE, false);
+				    write_mode == WRITE_FORCE, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b6a2a89..fd4c450 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -308,7 +308,7 @@ static int __cmd_report(void)
 
 	signal(SIGINT, sig_handler);
 
-	session = perf_session__new(input_name, O_RDONLY, force, false);
+	session = perf_session__new(input_name, O_RDONLY, force, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index c775394..7a4ebeb 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1643,7 +1643,8 @@ static struct perf_event_ops event_ops = {
 static int read_events(void)
 {
 	int err = -EINVAL;
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0, false);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 54f1ea8..6ef65c0 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -779,7 +779,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __used)
 	if (!script_name)
 		setup_pager();
 
-	session = perf_session__new(input_name, O_RDONLY, 0, false);
+	session = perf_session__new(input_name, O_RDONLY, 0, false, &event_ops);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index d2fc461..459b5e3 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -937,7 +937,8 @@ static struct perf_event_ops event_ops = {
 
 static int __cmd_timechart(void)
 {
-	struct perf_session *session = perf_session__new(input_name, O_RDONLY, 0, false);
+	struct perf_session *session = perf_session__new(input_name, O_RDONLY,
+							 0, false, &event_ops);
 	int ret = -EINVAL;
 
 	if (session == NULL)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0515ce9..ae15f04 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1272,7 +1272,7 @@ static int __cmd_top(void)
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
 	 */
-	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false, false);
+	struct perf_session *session = perf_session__new(NULL, O_WRONLY, false, false, NULL);
 	if (session == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b59abf5..0f7e544 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -125,7 +125,9 @@ static void perf_session__destroy_kernel_maps(struct perf_session *self)
 	machines__destroy_guest_kernel_maps(&self->machines);
 }
 
-struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe)
+struct perf_session *perf_session__new(const char *filename, int mode,
+				       bool force, bool repipe,
+				       struct perf_event_ops *ops)
 {
 	size_t len = filename ? strlen(filename) + 1 : 0;
 	struct perf_session *self = zalloc(sizeof(*self) + len);
@@ -170,6 +172,13 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	}
 
 	perf_session__update_sample_type(self);
+
+	if (ops && ops->ordering_requires_timestamps &&
+	    ops->ordered_samples && !self->sample_id_all) {
+		dump_printf("WARNING: No sample_id_all support, falling back to unordered processing\n");
+		ops->ordered_samples = false;
+	}
+
 out:
 	return self;
 out_free:
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ac36f99..ffe4b98 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -78,9 +78,12 @@ struct perf_event_ops {
 			build_id;
 	event_op2	finished_round;
 	bool		ordered_samples;
+	bool		ordering_requires_timestamps;
 };
 
-struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe);
+struct perf_session *perf_session__new(const char *filename, int mode,
+				       bool force, bool repipe,
+				       struct perf_event_ops *ops);
 void perf_session__delete(struct perf_session *self);
 
 void perf_event_header__bswap(struct perf_event_header *self);
-- 
1.6.2.5


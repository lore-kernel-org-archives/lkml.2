Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0LJDgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:36:40 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55619 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab0LJDgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:36:39 -0500
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 9/9] pref: session: Break event ordering when timestamps are missing
From: Ian Munsie <imunsie@au1.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-reply-to: <alpine.LFD.2.00.1012091455590.2653@localhost6.localdomain6>
References: <20101207124527.868085529@linutronix.de> <20101207124551.209741779@linutronix.de> <1291865671-sup-8975@au1.ibm.com> <alpine.LFD.2.00.1012091455590.2653@localhost6.localdomain6>
Date: Fri, 10 Dec 2010 14:36:29 +1100
Message-Id: <1291951882-sup-6069@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Thomas Gleixner's message of Fri Dec 10 00:58:10 +1100 2010:
> On Thu, 9 Dec 2010, Ian Munsie wrote:
> > Excerpts from Thomas Gleixner's message of Tue Dec 07 12:49:04 UTC 2010:
> > > Allow the session client to specify that event ordering should be
> > > stopped when not all events have time stamps.
> > 
> > >      /* These events are processed right away */
> > >      switch (event->header.type) {
> > >      case PERF_RECORD_HEADER_ATTR:
> > > -        return ops->attr(event, session);
> > > +        /* This updates session->sample_id_all */
> > > +        ret = ops->attr(event, session);
> > > +        /* Break ordering if sample_id_all is false */
> > > +        if (ops->ordering_requires_timestamps &&
> > > +            ops->ordered_samples && !session->sample_id_all) {
> > > +            session->ordered_samples.next_flush = ULLONG_MAX;
> > > +            flush_sample_queue(session, ops);
> > > +            ops->ordered_samples = false;
> > > +        }
> > > +        return ret;
> > Since the fall back isn't triggered, not only are COMM and MMAP events
> > processed first (from patch 2 in this series), but EXIT will as well,
> > which causes no userspace events to be attributed.
> 
> So we need to check this in every event processing path? Or do we have
> for this kind of processing some other method which allows us to
> disable the ordered_samples bit once ?

Any reason we couldn't put it in the perf_session__new function? It
means passing the event_ops to it as well, but I can't see any reason
why not to:


>From 711157f13a9adeab87a83eb8e0d9bc67cf1e2be8 Mon Sep 17 00:00:00 2001
From: Ian Munsie <imunsie@au1.ibm.com>
Date: Fri, 10 Dec 2010 14:09:16 +1100
Subject: [PATCH] perf session: Fallback to unordered processing if no sample_id_all

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

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
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
index 793db36..c056cdc 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -384,7 +384,7 @@ static int __cmd_annotate(void)
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
index d21dc25a..97846dc 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -144,8 +144,8 @@ static int __cmd_diff(void)
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
index 310dd21..184c444 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -574,7 +574,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	session = perf_session__new(output_name, O_WRONLY,
-				    write_mode == WRITE_FORCE, false);
+				    write_mode == WRITE_FORCE, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ccaea63..4af7ce6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -310,7 +310,7 @@ static int __cmd_report(void)
 
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
1.7.2.3

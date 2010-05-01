Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab0EAFso (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 01:48:44 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:54106 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab0EAFsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 01:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Uqt3KulVSD/oB2MyZ0TNF98mUi66Mm/zZMqTl8JI52U5hW5Ily6LVNiwq5Avw53KGB
         6S4hDsRPaF0/+TFZqdac9T3G+8Fltv/EERYcc8cC7CmQISLkD1SYZXrO6Pqv3V2dhErn
         UTOxANoLyvRNPYnzWZKy9XziGXeeuC7qGpVrE=
Subject: Re: [BUG] perf: perf trace does not work anymore
From: Tom Zanussi <tzanussi@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <v2mbd4cb8901004290528jb13ced31j7f8b0231019bbbcb@mail.gmail.com>
References: <v2mbd4cb8901004290528jb13ced31j7f8b0231019bbbcb@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 01 May 2010 00:44:59 -0500
Message-Id: <1272692699.11904.16.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2010-04-29 at 14:28 +0200, Stephane Eranian wrote:
> Hi,
> 
> I am trying to use perf trace to dump the raw samples.
> 
> $ perf record -R noploop 5
> noploop for 5 seconds
> [ perf record: Woken up 3 times to write data ]
> [ perf record: Captured and wrote 0.269 MB perf.data (~11759 samples) ]
> 
> $ perf trace
>   Fatal: reading input file (size expected=3 received=-1)
> 
> Seems like trace does not understand the format of the perf.data file anymore.
> This used to work. Did you change the purpose of perf trace?

Hmm, I don't think this has ever worked - you're recording raw samples
but no tracepoints - the current code seems to assume raw samples means
tracepoints and anyway perf trace currently only deals with tracepoint
events.  It would have worked before if you had recorded tracepoint
events - perhaps that's what you're remembering? 

In any case, you should be able to dump the raw non-tracepoint samples
using perf report -D, but that also shows the same problem.

The patch below should at least allow perf report -D to work - that
won't help displaying them in perf trace though, unless/until it gets
enhanced to do something with non-tracepoint events.

Also, there seems to be another recent problem showing the 'size
expected' warnings, probably to do with some malformed trace event
descriptions, but that's a different problem, a warning whereas this
shows up as an error. 

>From 17b268102265b673b7e7d589f7aaf983d7178766 Mon Sep 17 00:00:00 2001
From: Tom Zanussi <tzanussi@gmail.com>
Date: Sat, 1 May 2010 00:09:25 -0500
Subject: [PATCH] perf: record TRACE_INFO only if using tracepoints and
SAMPLE_RAW

The current perf code implicitly assumes SAMPLE_RAW means tracepoints
are being used, but doesn't check for that.  It happily records the
TRACE_INFO even if SAMPLE_RAW is used without tracepoints, but when
the perf data is read it won't go any further when it finds TRACE_INFO
but no tracepoints, and displays misleading errors.

This adds a check for both in perf-record, and won't record TRACE_INFO
unless both are true.  This at least allows perf report -D to dump raw
events, and avoids triggering a misleading error condition in perf
trace.  It doesn't actually enable the non-tracepoint raw events to be
displayed in perf trace, since perf trace currently only deals with
tracepoint events.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c        |   25 ++++++++++++++-----------
 tools/perf/util/header.c           |    1 -
 tools/perf/util/parse-events.h     |    1 +
 tools/perf/util/trace-event-info.c |    5 +++++
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 83b308a..722b6f1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -567,11 +567,12 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 	}
 
-	if (raw_samples) {
+	if (raw_samples && have_tracepoints(attrs, nr_counters)) {
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 	} else {
 		for (i = 0; i < nr_counters; i++) {
-			if (attrs[i].sample_type & PERF_SAMPLE_RAW) {
+			if (attrs[i].sample_type & PERF_SAMPLE_RAW &&
+				attrs[i].type == PERF_TYPE_TRACEPOINT) {
 				perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 				break;
 			}
@@ -669,16 +670,18 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 		}
 
-		err = event__synthesize_tracing_data(output, attrs,
-						     nr_counters,
-						     process_synthesized_event,
-						     session);
-		if (err <= 0) {
-			pr_err("Couldn't record tracing data.\n");
-			return err;
-		}
+		if (have_tracepoints(attrs, nr_counters)) {
+			err = event__synthesize_tracing_data(output, attrs,
+							     nr_counters,
+							     process_synthesized_event,
+							     session);
+			if (err <= 0) {
+				pr_err("Couldn't record tracing data.\n");
+				return err;
+			}
 
-		advance_output(err);
+			advance_output(err);
+		}
 	}
 
 	machine = perf_session__find_host_machine(session);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 6227dc4..fe12276 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -436,7 +436,6 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
 		trace_sec->size = lseek(fd, 0, SEEK_CUR) - trace_sec->offset;
 	}
 
-
 	if (perf_header__has_feat(self, HEADER_BUILD_ID)) {
 		struct perf_file_section *buildid_sec;
 
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index b8c1f64..fc4ab3f 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -13,6 +13,7 @@ struct tracepoint_path {
 };
 
 extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
+extern bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events);
 
 extern int			nr_counters;
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 30cd9b5..0a1fb9d 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -487,6 +487,11 @@ get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 	return nr_tracepoints > 0 ? path.next : NULL;
 }
 
+bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
+{
+	return get_tracepoints_path(pattrs, nb_events) ? true : false;
+}
+
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 {
 	char buf[BUFSIZ];
-- 
1.6.4.GIT




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0ECFvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 01:51:10 -0400
Received: from mail-iw0-f202.google.com ([209.85.223.202]:50183 "EHLO
	mail-iw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0ECFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 01:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BqZ3ccIOmhQjVP+dEW6HHqCIe7D6/jNUpsu+mxHA9s634DOqbVcd4nm9h8a+F5rjZs
         +Xb6+Wrx9A2/Z+nXSY2IAKOm5f2O0zvwJFP3jNcDcb7T+pzB7PQ8QCEZlo55gkr4kmvW
         nH5/LpdaLoKONWNBzawSIcG4P2ce5fC00f+jc=
Subject: Re: [PATCH 4/5] perf record: Don't exit in live mode when no
 tracepoints are enabled
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1272841142-26029-5-git-send-email-acme@infradead.org>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
	 <1272841142-26029-5-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 00:51:01 -0500
Message-Id: <1272865861.7932.16.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2010-05-02 at 19:59 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> With this I was able to actually test Tom Zanussi's two previous patches
> in my usual perf testing ways, i.e. without any tracepoints activated.
> 
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-record.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index e382d93..ac989e9 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -666,12 +666,15 @@ static int __cmd_record(int argc, const char **argv)
>  						     nr_counters,
>  						     process_synthesized_event,
>  						     session);
> -		if (err <= 0) {
> -			pr_err("Couldn't record tracing data.\n");
> -			return err;
> -		}
> -
> -		advance_output(err);
> +		/*
> +		 * FIXME err <= 0 here actually means that there were no tracepoints
> +		 * so its not really an error, just that we don't need to synthesize
> +		 * anything.
> +		 * We really have to return this more properly and also propagate
> +		 * errors that now are calling die()
> +		 */
> +		if (err > 0)
> +			advance_output(err);
>  	}
>  
>  	machine = perf_session__find_host_machine(session);

Thanks for taking these patches and fixing them up!

BTW, I posted a patch a couple days ago that also fixes this problem, in
response to a bug report for a non-live-mode problem seen when using
SAMPLE_RAW with no tracepoints:

http://lkml.org/lkml/2010/5/1/2

Here it is again, fixed up to apply to your tree...

Tom

From: Tom Zanussi <tzanussi@gmail.com>
Date: Mon, 3 May 2010 00:14:48 -0500
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
 tools/perf/builtin-record.c        |   35
+++++++++++++++++++++--------------
 tools/perf/util/header.c           |    1 -
 tools/perf/util/parse-events.h     |    1 +
 tools/perf/util/trace-event-info.c |    5 +++++
 4 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ac989e9..0ff67d1 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -560,11 +560,12 @@ static int __cmd_record(int argc, const char **argv)
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
@@ -662,19 +663,25 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 		}
 
-		err = event__synthesize_tracing_data(output, attrs,
-						     nr_counters,
-						     process_synthesized_event,
-						     session);
-		/*
-		 * FIXME err <= 0 here actually means that there were no tracepoints
-		 * so its not really an error, just that we don't need to synthesize
-		 * anything.
-		 * We really have to return this more properly and also propagate
-		 * errors that now are calling die()
-		 */
-		if (err > 0)
+		if (have_tracepoints(attrs, nr_counters)) {
+			/*
+			 * FIXME err <= 0 here actually means that
+			 * there were no tracepoints so its not really
+			 * an error, just that we don't need to
+			 * synthesize anything.  We really have to
+			 * return this more properly and also
+			 * propagate errors that now are calling die()
+			 */
+			err = event__synthesize_tracing_data(output, attrs,
+							     nr_counters,
+							     process_synthesized_event,
+							     session);
+			if (err <= 0) {
+				pr_err("Couldn't record tracing data.\n");
+				return err;
+			}
 			advance_output(err);
+		}
 	}
 
 	machine = perf_session__find_host_machine(session);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 79da0e5..2b9f898 100644
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
1.6.6.1







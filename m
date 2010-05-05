Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202Ab0EEDjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 23:39:35 -0400
Received: from mail-iw0-f203.google.com ([209.85.223.203]:37690 "EHLO
	mail-iw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755559Ab0EEDjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 23:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NdufOmSBwI4+b5t6CPJtns2x44MuKq1mTMgxYAIN+1FP/vwxXiNE0yhyws72MZu8cJ
         ONQHN2iN1UzPPsTT+GV03atwEGg8i4Yb1NXPjlmV09sjkwVQQfOYNxLqZG7Ur3sgD8xO
         EHz/mi2cP59tQ1RqXQNDeP/KYG03AGbeveA1k=
Subject: Re: [PATCH 1/3] perf: record TRACE_INFO only if using tracepoints
 and SAMPLE_RAW
From: Tom Zanussi <tzanussi@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20100504211843.GF970@ghostprotocols.net>
References: <1272981607-28723-1-git-send-email-acme@infradead.org>
	 <1272981607-28723-2-git-send-email-acme@infradead.org>
	 <20100504170642.GA5427@nowhere>  <20100504211843.GF970@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 22:39:30 -0500
Message-Id: <1273030770.6383.6.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 18:18 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, May 04, 2010 at 07:06:45PM +0200, Frederic Weisbecker escreveu:
> > On Tue, May 04, 2010 at 11:00:05AM -0300, Arnaldo Carvalho de Melo wrote:
> > > From: Tom Zanussi <tzanussi@gmail.com>
> > > 
> > > The current perf code implicitly assumes SAMPLE_RAW means tracepoints
> > > are being used, but doesn't check for that.  It happily records the
> > > TRACE_INFO even if SAMPLE_RAW is used without tracepoints, but when the
> > > perf data is read it won't go any further when it finds TRACE_INFO but
> > > no tracepoints, and displays misleading errors.
> > > 
> > > This adds a check for both in perf-record, and won't record TRACE_INFO
> > > unless both are true.  This at least allows perf report -D to dump raw
> > > events, and avoids triggering a misleading error condition in perf
> > > trace.  It doesn't actually enable the non-tracepoint raw events to be
> > > displayed in perf trace, since perf trace currently only deals with
> > > tracepoint events.
> > > 
> > > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> > > Cc: Mike Galbraith <efault@gmx.de>
> > > Cc: Paul Mackerras <paulus@samba.org>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > LKML-Reference: <1272865861.7932.16.camel@tropicana>
> > > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > ---
> > >  tools/perf/builtin-record.c        |   35 +++++++++++++++++++++--------------
> > >  tools/perf/util/header.c           |    1 -
> > >  tools/perf/util/parse-events.h     |    1 +
> > >  tools/perf/util/trace-event-info.c |    5 +++++
> > >  4 files changed, 27 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> > > index ac989e9..0ff67d1 100644
> > > --- a/tools/perf/builtin-record.c
> > > +++ b/tools/perf/builtin-record.c
> > > @@ -560,11 +560,12 @@ static int __cmd_record(int argc, const char **argv)
> > >  			return err;
> > >  	}
> > >  
> > > -	if (raw_samples) {
> > > +	if (raw_samples && have_tracepoints(attrs, nr_counters)) {
> > >  		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
> > >  	} else {
> > 
> > 
> > 
> > Using get_tracepoints_path() is a bit costly just to check if we use
> > tracepoints as it allocates and fill the paths.
> 
> Can you please send a fix?
> 

Yeah, there's a lot of room for improvement here - thanks for pointing
it out, Frederic.  The patch below should make it better...

Tom

From: Tom Zanussi <tzanussi@gmail.com>
Date: Tue, 4 May 2010 22:20:16 -0500
Subject: [PATCH] perf/record: simplify TRACE_INFO tracepoint check

Fix a couple of inefficiencies and redundancies related to
have_tracepoints() and its use when checking whether to write
TRACE_INFO.

First, there's no need to use get_tracepoints_path() in
have_tracepoints() - we really just want the part that checks whether
any attributes correspondo to tracepoints.

Second, we really don't care about raw_samples per se - tracepoints
are always raw_samples.  In any case, the have_tracepoints() check
should be sufficient to decide whether or not to write TRACE_INFO.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c        |   11 +----------
 tools/perf/util/trace-event-info.c |    8 +++++++-
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0ff67d1..d3981ac 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -560,17 +560,8 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 	}
 
-	if (raw_samples && have_tracepoints(attrs, nr_counters)) {
+	if (have_tracepoints(attrs, nr_counters))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
-	} else {
-		for (i = 0; i < nr_counters; i++) {
-			if (attrs[i].sample_type & PERF_SAMPLE_RAW &&
-				attrs[i].type == PERF_TYPE_TRACEPOINT) {
-				perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
-				break;
-			}
-		}
-	}
 
 	atexit(atexit_header);
 
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 0a1fb9d..b157260 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -489,7 +489,13 @@ get_tracepoints_path(struct perf_event_attr *pattrs, int nb_events)
 
 bool have_tracepoints(struct perf_event_attr *pattrs, int nb_events)
 {
-	return get_tracepoints_path(pattrs, nb_events) ? true : false;
+	int i;
+
+	for (i = 0; i < nb_events; i++)
+		if (pattrs[i].type == PERF_TYPE_TRACEPOINT)
+			return true;
+
+	return false;
 }
 
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
-- 
1.6.4.GIT






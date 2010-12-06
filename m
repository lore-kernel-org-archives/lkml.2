Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0LFOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:41:51 -0500
Received: from www.tglx.de ([62.245.132.106]:57926 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab0LFOlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:41:50 -0500
Date: Mon, 6 Dec 2010 15:41:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Munsie <imunsie@au1.ibm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record/report: Process events in order
In-Reply-To: <1291640985-sup-4443@au1.ibm.com>
Message-ID: <alpine.LFD.2.00.1012061447080.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6> <1291603026-11785-4-git-send-email-imunsie@au1.ibm.com> <alpine.LFD.2.00.1012061014180.2653@localhost6.localdomain6> <1291637998-sup-4601@au1.ibm.com> <alpine.LFD.2.00.1012061359140.2653@localhost6.localdomain6>
 <1291640985-sup-4443@au1.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, Ian Munsie wrote:

> Excerpts from Thomas Gleixner's message of Tue Dec 07 00:04:20 +1100 2010:
> > > I just moved them into this routine to keep all the dispatching in one
> > > place, whether delayed or not. These particular events will still be
> > > processed immediately when encountered in the file. Only >=
> > > PERF_RECORD_MMAP && <= PERF_RECORD_SAMPLE will be delayed via the
> > > perf_session__process_timed function.
> > 
> > Gah. This is nasty. I really prefer the explicit split of instant
> > processed and possibly delayed events. That makes the code clear and
> > easy to extend. I just want to add a new event type at the right place
> > and not worry about magic comparisions in some other place.
> 
> Fair enough, I'll split them back out.
> 
> > > For instance, suppose we ran this on an old kernel without support for
> > > timestamps on every event (so timestamps are only on sample events):
> > > 
> > > perf record -T
> > > perf report
> > > 
> > > If perf report tried to process the events in order, all the events
> > > without timestamps would be processed first -- including the
> > > PERF_RECORD_EXIT event, which would cause every sample not to be
> > > attributed. Falling back means we should get no worse than the old
> > > behaviour, while an upgraded kernel will provide the timestamps and
> > > should not fall back.
> > 
> > Ok, but you'll break existing code which does only care about sample
> > ordering if you do that at the session level unconditionally.
> 
> Good point. I'll give this some thought overnight.

Does the patch below on top of my previous one work for you ?

Thanks,

	tglx

---
 tools/perf/util/session.c |   70 ++++++++++++++++++++++++++++------------------
 tools/perf/util/session.h |    1 
 2 files changed, 44 insertions(+), 27 deletions(-)

Index: linux-2.6-tip/tools/perf/util/session.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.c
+++ linux-2.6-tip/tools/perf/util/session.c
@@ -709,6 +709,29 @@ static int perf_session_deliver_event(st
 	}
 }
 
+static int preprocess_sample_record(struct perf_session *session,
+				    event_t *event, struct sample_data *sample)
+{
+	if (event->header.type != PERF_RECORD_SAMPLE)
+		return 0;
+
+	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+		    sample->pid, sample->tid, sample->ip, sample->period);
+
+	if (!(session->sample_type & PERF_SAMPLE_CALLCHAIN))
+		return 0;
+
+	if (!ip_callchain__valid(sample->callchain, event)) {
+		pr_debug("call-chain problem with event, skipping it.\n");
+		++session->hists.stats.nr_invalid_chains;
+		session->hists.stats.total_invalid_chains += sample->period;
+		return -EINVAL;
+	}
+
+	callchain__dump(sample);
+	return 0;
+}
+
 static int perf_session__process_event(struct perf_session *session,
 				       event_t *event,
 				       struct perf_event_ops *ops,
@@ -722,13 +745,6 @@ static int perf_session__process_event(s
 	if (session->header.needs_swap && event__swap_ops[event->header.type])
 		event__swap_ops[event->header.type](event);
 
-	if (event->header.type >= PERF_RECORD_MMAP &&
-	    event->header.type <= PERF_RECORD_SAMPLE) {
-		event__parse_sample(event, session, &sample);
-		if (dump_trace)
-			perf_session__print_tstamp(session, event, &sample);
-	}
-
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    file_offset, event->header.size,
@@ -738,27 +754,16 @@ static int perf_session__process_event(s
 
 	/* These events are processed right away */
 	switch (event->header.type) {
-	case PERF_RECORD_SAMPLE:
-		dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n",
-			    event->header.misc,
-			    sample.pid, sample.tid, sample.ip, sample.period);
-
-		if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
-			if (!ip_callchain__valid(sample.callchain, event)) {
-				pr_debug("call-chain problem with event, "
-					 "skipping it.\n");
-				++session->hists.stats.nr_invalid_chains;
-				session->hists.stats.total_invalid_chains +=
-					sample.period;
-				return 0;
-			}
-
-			callchain__dump(&sample);
-		}
-		break;
-
 	case PERF_RECORD_HEADER_ATTR:
-		return ops->attr(event, session);
+		/* This updates session->sample_id_all */
+		ret = ops->attr(event, session);
+		if (ops->ordering_requires_timestamps &&
+		    ops->ordered_samples && !session->sample_id_all) {
+			session->ordered_samples.next_flush = ULLONG_MAX;
+			flush_sample_queue(session, ops);
+			ops->ordered_samples = false;
+		}
+		return ret;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		return ops->event_type(event, session);
 	case PERF_RECORD_HEADER_TRACING_DATA:
@@ -773,6 +778,17 @@ static int perf_session__process_event(s
 		break;
 	}
 
+	/*
+	 * For all non synthetized events we get the sample data
+	 */
+	event__parse_sample(event, session, &sample);
+	if (dump_trace)
+		perf_session__print_tstamp(session, event, &sample);
+
+	/* Preprocess sample records - precheck callchains */
+	if (preprocess_sample_record(session, event, &sample))
+		return 0;
+
 	if (ops->ordered_samples) {
 		ret = perf_session_queue_event(session, event, &sample);
 		if (ret != -ETIME)
Index: linux-2.6-tip/tools/perf/util/session.h
===================================================================
--- linux-2.6-tip.orig/tools/perf/util/session.h
+++ linux-2.6-tip/tools/perf/util/session.h
@@ -82,6 +82,7 @@ struct perf_event_ops {
 			build_id;
 	event_op2	finished_round;
 	bool		ordered_samples;
+	bool		ordering_requires_timestamps;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force, bool repipe);

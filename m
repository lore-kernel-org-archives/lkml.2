Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab2HFWAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 18:00:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45270 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2HFWAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 18:00:07 -0400
Date: Mon, 6 Aug 2012 19:00:00 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Andrey Wagin <avagin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] perf: teach perf inject to merge sched_stat_* and
 sched_switch events
Message-ID: <20120806220000.GH21441@infradead.org>
References: <1344247319-304069-1-git-send-email-avagin@openvz.org>
 <1344247319-304069-3-git-send-email-avagin@openvz.org>
 <20120806181941.GG21441@infradead.org>
 <CANaxB-xq_wDGZQ16nTD6agwc_JiE4dQe1fXmvmPZckAX0EVr9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <CANaxB-xq_wDGZQ16nTD6agwc_JiE4dQe1fXmvmPZckAX0EVr9w@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Mon, Aug 06, 2012 at 11:43:04PM +0400, Andrey Wagin escreveu:
> 2012/8/6 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
> >> +struct perf_session  *session;
> 
> perf_event__sched_stat (perf_inject.sample) uses "session" for getting
> an event name. I don't know how to get it by another way

Can you try with the attached patch? We already lookup the event_format
entries when we read the perf.data header so that we can cache
evsel->name, we might as well cache the event_format in
evsel->tp_format, so that tools don't have to relookup this for each
sample.

It would look like:

	static int perf_event__sched_stat(struct perf_tool *tool,
					  union perf_event *event,
					  struct perf_sample *sample,
					  struct perf_evsel *evsel,
					  struct machine *machine)
	{
		int type;
		struct event_format *e = evsel->tp_format;
		const char *evname = e->name;

- Arnaldo

--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="a.patch"

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b559929..a56c457 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -56,6 +56,7 @@ struct perf_evsel {
 	int			ids;
 	struct hists		hists;
 	char			*name;
+	struct event_format	*tp_format;
 	union {
 		void		*priv;
 		off_t		id_offset;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 24c489b..5b328a4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2126,6 +2126,7 @@ static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
 	if (event->name == NULL)
 		return -1;
 
+	evsel->tp_format = event;
 	return 0;
 }
 

--2oS5YaxWCcQjTEyO--

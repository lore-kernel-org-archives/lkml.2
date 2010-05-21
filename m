Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab0EUOSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:18:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:55583 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0EUOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:18:28 -0400
Subject: Re: [PATCH 02/10] perf, trace: Use per-tracepoint-per-cpu hlist to
 track events
From: Peter Zijlstra <peterz@infradead.org>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1274450643.26328.3749.camel@gandalf.stny.rr.com>
References: <20100521090201.326791353@chello.nl>
	 <20100521090710.473188012@chello.nl>
	 <1274450643.26328.3749.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 16:18:18 +0200
Message-ID: <1274451498.1674.1706.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 10:04 -0400, Steven Rostedt wrote:
> On Fri, 2010-05-21 at 11:02 +0200, Peter Zijlstra wrote:
> > plain text document attachment (perf-trace-per-cpu-fold.patch)
> > Avoid the swevent hash-table by using per-tracepoint hlists.
> > 
> > Also, avoid conditionals on the fast path by ordering with probe unregister
> > so that we should never get on the callback path without the data being there.
> > 
> 
> > -void perf_trace_disable(int event_id)
> > +void perf_trace_destroy(struct perf_event *p_event)
> >  {
> > -	struct ftrace_event_call *event;
> > +	struct ftrace_event_call *tp_event = p_event->tp_event;
> > +	int i;
> >  
> > -	mutex_lock(&event_mutex);
> > -	list_for_each_entry(event, &ftrace_events, list) {
> > -		if (event->id == event_id) {
> > -			perf_trace_event_disable(event);
> > -			module_put(event->mod);
> > -			break;
> > +	if (--tp_event->perf_refcount > 0)
> > +		return;
> > +
> 
> You remove the event_mutex and then update the tp_event->perf_refcount
> without any protection.
> 
> That tp_event->perf_refcount is global to the event not to the perf
> event.

Oh, bugger, yes. I seem to have lost it on destroy..

Thanks!


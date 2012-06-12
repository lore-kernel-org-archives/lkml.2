Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2FLRLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:11:12 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47679 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2FLRLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:11:09 -0400
Date: Tue, 12 Jun 2012 14:11:02 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] perf sched replay: fix event lookup
Message-ID: <20120612171102.GD5816@infradead.org>
References: <1339232758-920-1-git-send-email-dmitry.antipov@linaro.org>
 <87pq96pfj9.fsf@sejong.aot.lge.com>
 <20120611140852.GB2202@infradead.org>
 <8739616pc9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8739616pc9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 12, 2012 at 03:01:26PM +0900, Namhyung Kim escreveu:
> Hi,
> 
> On Mon, 11 Jun 2012 11:08:52 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Mon, Jun 11, 2012 at 02:46:02PM +0900, Namhyung Kim escreveu:
> >> On Sat,  9 Jun 2012 13:05:58 +0400, Dmitry Antipov wrote:
> >> > Use new function trace_find_event_by_name to lookup events before
> >> > looking through /sys files. This helps 'perf sched replay' to map
> >> > event names to IDs correctly when processing perf.data recorded
> >> > on another machine.
> >> 
> >> Basically the same approach with the previous reply, please put this
> >> into trace_event__id(). And minor nits below..
> >
> > Well, trace_event__id() is private to evlist and evlist so far is a
> > local thing, i.e. it doesn't know anything about perf.data files.
> >
> 
> Really? I see that perf_session__open make up an evlist for the session
> and a tracepoint event in the evlist should look up the perf.data
> first. As this patch addressed, perf sched replay dealt with the
> session->evlist already. Am I missing something?

I sent a patch fixing it, basically after creating the evlist in
perf_session__open it will traverse it, looking up the pevents list
created while processing the trace feature section in the header,
setting up evsel->name properly.

> > So I think we should have a per perf.data (perf_session) method that
> > knows that it shouldn't look _at all_ to /sys, but just at what came in
> > the perf.data file.
> >
> 
> Fair enough. The method should be a simple wrapper to libtraceevent APIs
> like this patch.

Right, that is what it does.

> 
> > As well when we want something that is on the running machine, even if
> > we're dealing somehow with a perf.data file, we shouldn't use what is in
> > it.
> >
> 
> That's the current behavior of the trace_event__id(). Do you want to
> make it public?

No need for it, the only users should be inside evsel.c.

- Arnaldo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab2JWQv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:51:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab2JWQv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:51:27 -0400
Date: Tue, 23 Oct 2012 18:50:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 02/11] perf: Do not get values from disabled counters in
 group format read
Message-ID: <20121023165040.GA7553@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <1350743599-4805-3-git-send-email-jolsa@redhat.com>
 <1351008789.13456.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351008789.13456.37.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 06:13:09PM +0200, Peter Zijlstra wrote:
> On Sat, 2012-10-20 at 16:33 +0200, Jiri Olsa wrote:
> > It's possible some of the counters in the group could be
> > disabled when sampling member of the event group is reading
> > the rest via PERF_SAMPLE_READ sample type processing. Disabled
> > counters could then produce wrong numbers.
> > 
> > Fixing that by reading only enabled counters for PERF_SAMPLE_READ
> > sample type processing.
> > 
> 
> However did you run into this?

yep, with perf record -a

hm, I just checked and we enable/disable event groups atomicaly..
I haven't checked that before because it seemed obvious :-/

So, I'm not sure now about the exact code path that triggered it
in my test..  however you could always disable child event from
group and hit this issue, but thats not what happened in perf.

might be some other bug... I'll check

> 
> > ---
> >  kernel/events/core.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 32aec40..5220d01 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -4012,12 +4012,24 @@ static void perf_output_read_group(struct perf_output_handle *handle,
> >  	__output_copy(handle, values, n * sizeof(u64));
> >  
> >  	list_for_each_entry(sub, &leader->sibling_list, group_entry) {
> > +		u64 value = 0;
> >  		n = 0;
> >  
> > -		if (sub != event)
> > -			sub->pmu->read(sub);
> > +		/*
> > +		 * We are NOT interested in disabled counters,
> > +		 * giving us strange values and keeping us from
> > +		 * good night sleep!!!
> > +		 */
> > +		if (sub->state > PERF_EVENT_STATE_OFF) {
> > +
> 
> superfluous whitespace there... ;-)

yea.. v2 ;)


thanks,
jirka

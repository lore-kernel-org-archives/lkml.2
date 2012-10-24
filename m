Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab2JXMOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022Ab2JXMOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:14:52 -0400
Date: Wed, 24 Oct 2012 14:14:07 +0200
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
Message-ID: <20121024121406.GA5582@krava.brq.redhat.com>
References: <1350743599-4805-1-git-send-email-jolsa@redhat.com>
 <1350743599-4805-3-git-send-email-jolsa@redhat.com>
 <1351008789.13456.37.camel@twins>
 <20121023165040.GA7553@krava.brq.redhat.com>
 <1351080078.13456.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351080078.13456.60.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:01:18PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-10-23 at 18:50 +0200, Jiri Olsa wrote:
> > On Tue, Oct 23, 2012 at 06:13:09PM +0200, Peter Zijlstra wrote:
> > > On Sat, 2012-10-20 at 16:33 +0200, Jiri Olsa wrote:
> > > > It's possible some of the counters in the group could be
> > > > disabled when sampling member of the event group is reading
> > > > the rest via PERF_SAMPLE_READ sample type processing. Disabled
> > > > counters could then produce wrong numbers.
> > > > 
> > > > Fixing that by reading only enabled counters for PERF_SAMPLE_READ
> > > > sample type processing.
> > > > 
> > > 
> > > However did you run into this?
> > 
> > yep, with perf record -a
> > 
> > hm, I just checked and we enable/disable event groups atomicaly..
> > I haven't checked that before because it seemed obvious :-/
> > 
> > So, I'm not sure now about the exact code path that triggered it
> > in my test..  however you could always disable child event from
> > group and hit this issue, but thats not what happened in perf.
> > 
> > might be some other bug... I'll check 
> 
> Right, so I don't object to the patch per-se, I was just curious how you
> ran into it, because ISTR what you just said, we enable all this stuff
> together.
> 
> Also, why would disabled counters give strange values? They'd simply
> return the same old value time after time, right?

well, x86_pmu_read calls x86_perf_event_update, which expects the event
is active.. if it's not it'll update the count from whatever left in
event.hw.idx counter.. could be uninitialized or used by others..

I can easily reproduce this one, so let's see.. ;)

jirka

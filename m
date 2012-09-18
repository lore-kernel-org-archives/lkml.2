Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2IRQDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:03:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:48788 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326Ab2IRQDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,442,1344236400"; 
   d="scan'208";a="223547939"
Date: Tue, 18 Sep 2012 23:56:51 +0800
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: <mingo@elte.hu>, <a.p.zijlstra@chello.nl>, <andi@firstfloor.org>,
        <namhyung@kernel.org>, <dsahern@gmail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] perf ui/browser: Integrate script browser into
 annotation browser
Message-ID: <20120918235651.5ca65325@feng-i7>
In-Reply-To: <20120918113028.GD13283@infradead.org>
References: <1347007349-3102-1-git-send-email-feng.tang@intel.com>
	<1347007349-3102-7-git-send-email-feng.tang@intel.com>
	<20120917152301.GB16820@infradead.org>
	<20120918154010.451e5891@feng-i7>
	<20120918113028.GD13283@infradead.org>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Tue, 18 Sep 2012 08:30:28 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Sep 18, 2012 at 03:40:10PM +0800, Feng Tang escreveu:
> > Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > > Em Fri, Sep 07, 2012 at 04:42:28PM +0800, Feng Tang escreveu:
> > > > Integrate the script browser into annotation, users can press function
> > > > key 'r' to list all perf scripts and select one of them to run that
> > > > script, the output will be shown in a separate browser.
> > > 
> > > I think this needs a bit more work... i.e. I tried it with your script,
> > > event_analyzing_sample and I kinda get meaningful output when pressing
> > > 'r' + that script from the top and hists browser.
> > 
> > I would answer you question about "elllaborate on the assumptions" first
> > here, that the main purpose of this script browser is not to replace the
> > normal "perf script" command, but to:
> > 1. Provide a convenient way for user to directly run scripts while they
> 
> I think this is what confused me, you say "directly run scripts", but
> that only means "directly run the report phase of scripts, not the
> record phase". Ok, that is clear now.
> 
> > are browsing through the hists or annotation browser, and provide some
> > option for run script with samples from specific thread or symbol
> 
> > 2. Prepare for some advance feature, like inside the annotation browser,
> > analyze some specific hot line of code with samples containing precise
> > information, like the register values, store/load latency stuff. But I
> > have no idea how to implement it now, I guess after Stefan work out the
> > general perf latency tool, we may be able to revisit it.   
> 
> I'm ok with adding infrastructure for later improvements, but I think we
> should try to do it in a way that doesn't confuses users too much,
> otherwise they may get annoyed and not try the feature when it becomes
> useful, worse, tell others that it is cumbersome, don't bother trying
> it.

OK, will try to make it clear in the commit log and comments inside
the code.

> 
> So we should try to do it in a way that is useful for the constraints
> you explained here, more on that later in this message.
>  
> > And when I started to code, I assumed user will mainly use this feature
> > for running scripts for general samples other than the existing scripts
> > for tracepoints. And yes, some user cases you mentioned are not covered.
> 
> Ok, so we need to filter out some more, like you did for the top script.
>  
> > > But with other scripts, and you filtered the -top suffixed ones, that
> > > require special handling, I get things like "Press Control+C to get a
> > > summary", and when I press that, the browser exits, going back to
> > > annotate or report/top browser.
> > 
> > That's right, 4 current perf python scripts will print that line in its
> > "trace_begin" function, as some of the scripts may run for quiet some
> > time if the perf.data is huge. And what you see in the script browser 
> > is just some static text of the script output. 
> 
> Ok, so one thing I think we can do is to look at the record script:
> 
> [acme@sandy linux]$ cat
> tools/perf/scripts/python/bin/syscall-counts-by-pid-record 
> #!/bin/bash
> perf record -e raw_syscalls:sys_enter $@
> 
> and also at the perf.data file:
> 
> [root@sandy linux]# perf evlist
> cycles
> 
> See? we can't offer the syscall-counts-by-pid script to analyse this
> perf.data file, one is made for the raw_syscalls:sys_enter tracepoint
> while the other has only cpu cycles.

Yeah, good idea.

> 
> While the script you provided:
> 
> [acme@sandy linux]$ cat
> tools/perf/scripts/python/bin/event_analyzing_sample-record 
> #!/bin/bash
> 
> #
> # event_analyzing_sample.py can cover all type of perf samples including
> # the tracepoints, so no special record requirements, just record what
> # you want to analyze.
> #
> perf record $@
> [acme@sandy linux]$ 
> 
> -----------------------
> 
> You made it general purpose, so yeah, we can offer that script to the
> user analysing that perf.data file.
> 
> So this is one possible way of matching scripts to perf.data files,
> another would be for us to somehow annotate the scripts, in the first
> few lines, with markers that would help do this matching, but I'd start
> with what we have: parse the line that has the 'perf record' command in
> the tools/perf/scripts/python/bin/*-record file, look at the event it
> handles and match to what 'perf evlist' reports.
> 
> Not necessarily running 'perf evlist', just doing what it does to figure
> out the needed information. 

OK, will try this dynamic way for scripts filtering (comparing to the
static way of filtering xxxtop scripts) 

> 
> > > I.e. this only works if we are processing a perf.data file made
> > > specially for that specific script, right? I.e. the record phase is not
> > > integrated at all, just running specific scripts in specific perf.data
> > > files.
> > 
> > No, the record phase is not added, it just handle the recorded data. And
> > there is something missed in current implementation, that the script in
> > browser mode is only run for the "perf.data" even if the perf report/annotate
> > is run for data with another name.
> 
> Ok, so that needs to be handled, using the filtering I suggested above.

And I need to pass the filename of the perf.data to the script browser
in case the perf report/annotate use the "-i" option.

> 
> > > How to allow the user to chose appropriate scripts to run each perf.data
> > > file is an aspect of usability that is missing...
> > 
> > Do we need to run script for another perf.data when we run report/annotation
> > for one perf.data? or should we add a option for script browser to make it
> > work in browser mode, this is something Numhyung has mentioned in his review
> 
> Well, it would be great to be able to press some key in the main hists
> browser and then switch to a different perf.data file, the tool could
> just look at the current directory, looking at the magic number in the
> first few bytes of all files, looking for perf.data files to offer.
> 
> That, done in the 'top' tool would make it stop doing continuous
> profiling, stopping the thread it uses to read the counters and instead
> switch to static profiling, i.e. just reading a perf.data file.
> 
> This is something that is a nice new feature and one that would pave the
> way for a better top/report/script/annotate integration.

I will try to see what I can do with this.

One thing I need confirm is, the filtering method you mentioned above
is only against the perf.data that is currently processed by the
report/annotate browser, and not related with the perf.data switching?

Thanks,
Feng



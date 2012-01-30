Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2A3P3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:29:46 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55933 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab2A3P3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:29:44 -0500
Date: Mon, 30 Jan 2012 13:29:35 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Andrew Steets <asteets@rgmadvisors.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>
Subject: Re: perf: prctl(PR_TASK_PERF_EVENTS_DISABLE) has no effect
Message-ID: <20120130152935.GA15935@infradead.org>
References: <4F22D8D9.3010108@rgmadvisors.com>
 <20120128120151.GA10390@elte.hu>
 <4F248938.5030507@rgmadvisors.com>
 <20120129163235.GB23408@elte.hu>
 <1327917156.2446.191.camel@twins>
 <20120130101121.GB8924@elte.hu>
 <1327921293.2446.202.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327921293.2446.202.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 30, 2012 at 12:01:33PM +0100, Peter Zijlstra escreveu:
> On Mon, 2012-01-30 at 11:11 +0100, Ingo Molnar wrote:
> > So, what workflow are you suggesting to Andrew?
> 
> Librarize perf record, then in your code do something like:
> 
> #include "perf_record.h"
> 
>   handle = perf_record_init(); /* creates perf events and creates
>                                   a record thread that writes samples
>                                   to perf.data, consumes env(PERF_*)
>                                   for configuration, registers with
>                                   at_exit() for cleanup */
>   if (!handle)
>     /* burn */
> 
>   /* do you other code */
> 
>   perf_record_start(handle);
> 
>   /* do the bit you want profiled */
> 
>   perf_record_stop(handle);
> 
> Then build with -lperfrecord or so. Not too hard, right?

This looks like the test__PERF_RECORD function in
tools/perf/builtin-test.c, copying here just the equivalent parts to the
above:

	#include "util/evlist.h"

        struct perf_record_opts opts = {
                .target_pid = -1,
                .target_tid = -1,
                .no_delay   = true,
                .freq       = 10,
                .mmap_pages = 256,
                .sample_id_all_avail = true,
        };

        struct perf_evlist *handle = perf_evlist__new(NULL, NULL);

        /* 
         * We need at least one evsel in the evlist, use the default 
         * one: "cycles". 
         */ 
        err = perf_evlist__add_default(evlist);

	perf_evlist__config_attrs(evlist, &opts);

	err = perf_evlist__open(evlist, opts.group);

        perf_evlist__enable(evlist);

	/* do the bit you want profiled */

        perf_evlist__disable(evlist);


----


perf_evlist__config_attrs will, among other chores, do:

        if (opts->target_pid == -1 && opts->target_tid == -1 &&
            !opts->system_wide) {
                attr->disabled = 1;
                attr->enable_on_exec = 1;
        }

And you can fudge it a bit more to your liking before calling
perf_evlist__open().

	This 'perf test' use case was more for preparing for monitoring
a workload that a program would start, setting up the events, etc,
leaving all disabled and then letting the workload begin which would, by
means of enable_on_exec start the counters/events.

	But I guess you can just setup evlist->workload.pid to getpid()
and use perf_evlist__enable()/ perf_evlist_disable() pairs to your
liking.

	Writing a test case that would do exactly what you want in 'perf
test' would be awesome and would allow us to figure out if the
abstractions in place are enough for your use case. Then we could
librarize just this subset and go from there.

	Take a look as well at test__basic_mmap, it may be useful as
another example of using these evsel/evlist classes.

	What is needed to link you can find in tools/perf/util/setup.py,
remove util/python.c and you should be set.

- Arnaldo

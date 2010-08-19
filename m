Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab0HSJCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:02:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab0HSJCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:02:13 -0400
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, "Zhang, Rui" <rui.zhang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1282188497.11858.94.camel@minggr.sh.intel.com>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
	 <1282188497.11858.94.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 Aug 2010 11:02:01 +0200
Message-ID: <1282208521.1926.4535.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 11:28 +0800, Lin Ming wrote:
> On Wed, 2010-08-18 at 20:41 +0800, Matt Fleming wrote:
> > On Wed, Aug 18, 2010 at 02:25:29PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-08-18 at 15:59 +0800, Zhang Rui wrote:
> > > > Hi, all,
> > > > 
> > > > RAPL(running average power limit) is a new feature which provides
> > > > mechanisms to enforce power consumption limit, on some new processors.
> > > > 
> > > > Generally speaking, by using RAPL, OS can set a power budget in a
> > > > certain time window, and let Hardware to throttle the processor
> > > > P/T-state to meet this energy limitation.
> > > > 
> > > > RAPL also provides a new MSR, i.e. MSR_PKG_ENERGY_STATUS, which reports
> > > > the total amount of energy consumed by the package.
> > > > 
> > > > I'm not sure if to support RAPL or not, but anyway, it sounds like a
> > > > good idea to export the energy status in perf.
> > > > 
> > > > So a new perf pmu and event to show the package energy consumed is
> > > > introduced in this patch.
> > > > 
> > > > Here is what I get after applying the three patches,
> > > > 
> > > > #./perf stat -e energy test
> > > > Performance counter stats for 'test':
> > > > 
> > > > 	202	Joules cost by package
> > > > 7.926001238	seconds time elapsed
> > > > 
> > > > 
> > > > Note that this patch set is made based on Peter's perf-pmu branch,
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git
> > > >  which provides better interfaces to register/unregister a new pmu.
> > > > 
> > > > any comment are welcome. :)
> > > 
> > > 
> > > Nice,.. however:
> > > 
> > >  - if it is a pure read-only counter without sampling support,
> > >    expose it as such, don't fudge in the hrtimer stuff. Simply
> > >    fail to create a sampling event.
> > > 
> > >    SH has the same problem for its 'normal' PMU, the solution is
> > >    to use event groups, Matt was looking at adding support to
> > >    perf-record for that, if creating a sampling event fails, fall
> > >    back to {hrtimer, $event} groups.
> > 
> > I had a quick look over the patches and Peter is right - the group
> > events stuff would probably fit quite well here. Unfortunately, due to
> > holidays and things, I haven't been able to get them finished
> > yet. I'll get on that ASAP.
> 
> Hi, Matt
> 
> What's the "group events stuff"?
> Is there some discussion on LKML or elsewhere I can have a look at?

its some obscure perf feature:

 leader = sys_perf_event_open(&hrtimer_attr, pid, cpu, 0, 0);
 sibling = sys_perf_event_open(&rapl_attr, pid, cpu, leader, 0);

will create an even group (which means that both events require to be
co-scheduled). If you then provided:

hrtimer_attr.read_format |= PERF_FORMAT_GROUP;
hrtimer_attr.sample_type |= PERF_SAMPLE_READ;

the samples from the hrtimer will contain a field like:

 *      { u64           nr;
 *        { u64         time_enabled; } && PERF_FORMAT_ENABLED
 *        { u64         time_running; } && PERF_FORMAT_RUNNING
 *        { u64         value;
 *          { u64       id;           } && PERF_FORMAT_ID
 *        }             cntr[nr];
 *      } && PERF_FORMAT_GROUP

Which contains both the hrtimer count (ns) and the RAPL count (watts).

Using that you can compute the RAPL delta between consecutive samples
and use that to weight the sample.


For perf-stat non of this is needed, since it doesn't use sampling
counters anyway ;-).

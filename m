Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427Ab0HTBla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 21:41:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:22417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0HTBl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 21:41:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,236,1280732400"; 
   d="scan'208";a="829973910"
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Zhang Rui <rui.zhang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Lin, Ming M" <ming.m.lin@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1282208521.1926.4535.camel@laptop>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <20100818124116.GA17957@console-pimps.org>
	 <1282188497.11858.94.camel@minggr.sh.intel.com>
	 <1282208521.1926.4535.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 09:44:35 +0800
Message-ID: <1282268675.5181.1608.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 17:02 +0800, Peter Zijlstra wrote:
> > > > 
> > > >  - if it is a pure read-only counter without sampling support,
> > > >    expose it as such, don't fudge in the hrtimer stuff. Simply
> > > >    fail to create a sampling event.
> > > > 
> > > >    SH has the same problem for its 'normal' PMU, the solution is
> > > >    to use event groups, Matt was looking at adding support to
> > > >    perf-record for that, if creating a sampling event fails, fall
> > > >    back to {hrtimer, $event} groups.
> > > 
> > > I had a quick look over the patches and Peter is right - the group
> > > events stuff would probably fit quite well here. Unfortunately, due to
> > > holidays and things, I haven't been able to get them finished
> > > yet. I'll get on that ASAP.
> > 
> > Hi, Matt
> > 
> > What's the "group events stuff"?
> > Is there some discussion on LKML or elsewhere I can have a look at?
> 
> its some obscure perf feature:
> 
>  leader = sys_perf_event_open(&hrtimer_attr, pid, cpu, 0, 0);
>  sibling = sys_perf_event_open(&rapl_attr, pid, cpu, leader, 0);
> 
> will create an even group (which means that both events require to be
> co-scheduled). If you then provided:
> 
> hrtimer_attr.read_format |= PERF_FORMAT_GROUP;
> hrtimer_attr.sample_type |= PERF_SAMPLE_READ;
> 
hrtimer_attr is only shared in an event group, and rapl needs its owen
event group, right?

> the samples from the hrtimer will contain a field like:
> 
>  *      { u64           nr;
>  *        { u64         time_enabled; } && PERF_FORMAT_ENABLED
>  *        { u64         time_running; } && PERF_FORMAT_RUNNING
>  *        { u64         value;
>  *          { u64       id;           } && PERF_FORMAT_ID
>  *        }             cntr[nr];
>  *      } && PERF_FORMAT_GROUP
> 
> Which contains both the hrtimer count (ns) and the RAPL count (watts).
> 
> Using that you can compute the RAPL delta between consecutive samples
> and use that to weight the sample.
> 
> 
> For perf-stat non of this is needed, since it doesn't use sampling
> counters anyway ;-).

so what do you think the rapl counter should look like in userspace?
showing it in perf-stat looks nice, right? :)

thanks,
rui


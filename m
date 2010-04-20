Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0DTMDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:03:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab0DTMDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:03:19 -0400
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: "Gary.Mohr@Bull.com" <Gary.Mohr@Bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1271764547.13968.69.camel@minggr.sh.intel.com>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
	 <1271424250.4807.2277.camel@twins>
	 <1271764547.13968.69.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 14:03:13 +0200
Message-ID: <1271764993.1676.431.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 19:55 +0800, Lin Ming wrote:

> > One thing not on that list, which should happen first I guess, is to
> > remove hw_perf_group_sched_in(). The idea is to add some sort of
> > transactional API to the struct pmu, so that we can delay the
> > schedulability check until commit time (and roll back when it fails).
> > 
> > Something as simple as:
> > 
> >   struct pmu {
> >     void start_txn(struct pmu *);
> >     void commit_txn(struct pmu *);
> > 
> >     ,,,
> >   };
> 
> Could you please explain a bit more?
> 
> Does it mean that "start_txn" perform the schedule events stuff
> and "commit_txn" perform the assign events stuff?
> 
> Does "commit time" mean the actual activation in hw_perf_enable?

No, the idea behind hw_perf_group_sched_in() is to not perform
schedulability tests on each event in the group, but to add the group as
a whole and then perform one test.

Of course, when that test fails, you'll have to roll-back the whole
group again.

So start_txn (or a better name) would simply toggle a flag in the pmu
implementation that will make pmu::enable() not perform the
schedulablilty test.

Then commit_txn() will perform the schedulability test (so note the
method has to have a !void return value, my mistake in the earlier
email).

This will allow us to use the regular
kernel/perf_event.c::group_sched_in() and all the rollback code.
Currently each hw_perf_group_sched_in() implementation duplicates all
the rolllback code (with various bugs).



We must get rid of all weak hw_perf_*() functions before we can properly
consider multiple struct pmu implementations.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0DWCIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:08:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:11686 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755059Ab0DWCIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:08:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,259,1270450800"; 
   d="scan'208";a="791997871"
Subject: Re: [RFC][PATCH 1/4] perf: core, add group scheduling
	transactional APIs
From: Lin Ming <ming.m.lin@intel.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100422173152.GA5600@nowhere>
References: <1271922662.30535.107.camel@minggr.sh.intel.com>
	 <20100422173152.GA5600@nowhere>
Content-Type: text/plain
Date: Fri, 23 Apr 2010 10:08:25 +0800
Message-Id: <1271988505.3412.20.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 01:31 +0800, Frederic Weisbecker wrote:
> On Thu, Apr 22, 2010 at 03:51:02PM +0800, Lin Ming wrote:
> > Add group scheduling transactional APIs to struct pmu.
> > These APIs will be implemented in arch code, based on Peter's idea as
> > below.
> > 
> > > the idea behind hw_perf_group_sched_in() is to not perform
> > > schedulability tests on each event in the group, but to add the group
> > as
> > > a whole and then perform one test.
> > >
> > > Of course, when that test fails, you'll have to roll-back the whole
> > > group again.
> > >
> > > So start_txn (or a better name) would simply toggle a flag in the pmu
> > > implementation that will make pmu::enable() not perform the
> > > schedulablilty test.
> > >
> > > Then commit_txn() will perform the schedulability test (so note the
> > > method has to have a !void return value, my mistake in the earlier
> > > email).
> > >
> > > This will allow us to use the regular
> > > kernel/perf_event.c::group_sched_in() and all the rollback code.
> > > Currently each hw_perf_group_sched_in() implementation duplicates all
> > > the rolllback code (with various bugs).
> > 
> > 
> > Reviewed-by: Stephane Eranian <eranian@google.com>
> > Reviewed-by: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  include/linux/perf_event.h |    8 +++++---
> >  kernel/perf_event.c        |   29 ++++++++++++++++-------------
> >  2 files changed, 21 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index ace31fb..b16cfba 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -532,6 +532,8 @@ struct hw_perf_event {
> >  
> >  struct perf_event;
> >  
> > +#define PERF_EVENT_TRAN_STARTED 1
> > +
> >  /**
> >   * struct pmu - generic performance monitoring unit
> >   */
> > @@ -542,6 +544,9 @@ struct pmu {
> >  	void (*stop)			(struct perf_event *event);
> >  	void (*read)			(struct perf_event *event);
> >  	void (*unthrottle)		(struct perf_event *event);
> > +	void (*start_txn)		(const struct pmu *pmu);
> > +	void (*stop_txn)		(const struct pmu *pmu);
> > +	int (*commit_txn)		(const struct pmu *pmu);
> 
> 
> Please add a few comments that briefly explain what these
> *_txn callbacks are supposed to mean.
> 
> Unless txn is an acronym that most kernel developers are used to.

How about below changes?

Thanks for review.

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b16cfba..bba4c60 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -544,9 +544,21 @@ struct pmu {
 	void (*stop)			(struct perf_event *event);
 	void (*read)			(struct perf_event *event);
 	void (*unthrottle)		(struct perf_event *event);
-	void (*start_txn)		(const struct pmu *pmu);
-	void (*stop_txn)		(const struct pmu *pmu);
-	int (*commit_txn)		(const struct pmu *pmu);
+
+	/*
+	 * group events scheduling is treated as a transaction,
+	 * add group events as a whole and perform one schedulability test.
+	 * If test fails, roll back the whole group
+	 */
+
+	/* start group events transaction  */
+	void (*start_group_trans)	(const struct pmu *pmu);
+
+	/* stop group events transaction  */
+	void (*stop_group_trans)	(const struct pmu *pmu);
+
+	/* commit group events transaction */
+	int (*commit_group_trans)	(const struct pmu *pmu);
 };
 
 /**



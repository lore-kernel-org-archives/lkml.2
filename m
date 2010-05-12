Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0ELCMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:12:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:44648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0ELCL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,211,1272870000"; 
   d="scan'208";a="797610648"
Subject: Re: [RFC][PATCH 2/9] perf: core, remove hw_perf_event_init
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
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100510122443.GA5563@nowhere>
References: <1273483595.15998.56.camel@minggr.sh.intel.com>
	 <20100510122443.GA5563@nowhere>
Content-Type: text/plain
Date: Wed, 12 May 2010 10:11:12 +0800
Message-Id: <1273630272.30322.98.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 20:24 +0800, Frederic Weisbecker wrote:
> On Mon, May 10, 2010 at 05:26:35PM +0800, Lin Ming wrote:
> > A new field "pmu_id" is added to struct perf_event_attr.
> > 
> > 2 new functions: perf_event_register_pmu, perf_event_lookup_pmu
> > perf_event_register_pmu: the pmu registration facility
> > perf_event_lookup_pmu: lookup the pmu via the passed in event->attr.pmu_id.
> > 
> > A new api pmu->init_event to replace hw_perf_event_init
> > 
> > Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> > ---
> >  include/linux/perf_event.h |    9 +++++++++
> >  kernel/perf_event.c        |   39 +++++++++++++++++++++++++++++++--------
> >  2 files changed, 40 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 5856d3b..6246c99 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -225,6 +225,8 @@ struct perf_event_attr {
> >  	__u32			bp_type;
> >  	__u64			bp_addr;
> >  	__u64			bp_len;
> > +
> > +	int			pmu_id;
> >  };
> >  
> >  /*
> > @@ -553,6 +555,9 @@ struct perf_event;
> >   * struct pmu - generic performance monitoring unit
> >   */
> >  struct pmu {
> > +	int id;
> > +	struct list_head entry;
> > +
> >  	int (*enable)			(struct perf_event *event);
> >  	void (*disable)			(struct perf_event *event);
> >  	int (*start)			(struct perf_event *event);
> > @@ -569,6 +574,8 @@ struct pmu {
> >  	void (*start_txn)	(struct pmu *pmu);
> >  	void (*cancel_txn)	(struct pmu *pmu);
> >  	int  (*commit_txn)	(struct pmu *pmu);
> > +
> > +	int  (*init_event)	(struct perf_event *event);
> >  };
> >  
> >  /**
> > @@ -1014,6 +1021,8 @@ extern int perf_swevent_get_recursion_context(void);
> >  extern void perf_swevent_put_recursion_context(int rctx);
> >  extern void perf_event_enable(struct perf_event *event);
> >  extern void perf_event_disable(struct perf_event *event);
> > +
> > +extern void perf_event_register_pmu(struct pmu *pmu);
> >  #else
> >  static inline void
> >  perf_event_task_sched_in(struct task_struct *task)			{ }
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index 36baf85..f19d40e 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -40,6 +40,12 @@
> >   */
> >  static DEFINE_PER_CPU(struct perf_cpu_context, perf_cpu_context);
> >  
> > +/*
> > + * The list of multiple hw pmus
> > + */
> > +static struct list_head pmus;
> > +static int pmu_id_curr;
> > +
> >  int perf_max_events __read_mostly = 1;
> >  static int perf_reserved_percpu __read_mostly;
> >  static int perf_overcommit __read_mostly = 1;
> > @@ -75,11 +81,6 @@ static DEFINE_SPINLOCK(perf_resource_lock);
> >  /*
> >   * Architecture provided APIs - weak aliases:
> >   */
> > -extern __weak struct pmu *hw_perf_event_init(struct perf_event *event)
> > -{
> > -	return NULL;
> > -}
> > -
> >  void __weak hw_perf_disable(void)		{ barrier(); }
> >  void __weak hw_perf_enable(void)		{ barrier(); }
> >  
> > @@ -4670,6 +4671,19 @@ static struct pmu *sw_perf_event_init(struct perf_event *event)
> >  	return pmu;
> >  }
> >  
> > +static struct pmu *perf_event_lookup_pmu(struct perf_event *event)
> > +{
> > +	struct pmu *pmu;
> > +	int pmu_id = event->attr.pmu_id;
> > +
> > +	list_for_each_entry(pmu, &pmus, entry) {
> > +		if (pmu->id == pmu_id)
> > +			return pmu;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> >  /*
> >   * Allocate and initialize a event structure
> >   */
> > @@ -4685,7 +4699,7 @@ perf_event_alloc(struct perf_event_attr *attr,
> >  	struct pmu *pmu;
> >  	struct perf_event *event;
> >  	struct hw_perf_event *hwc;
> > -	long err;
> > +	long err = 0;
> >  
> >  	event = kzalloc(sizeof(*event), gfpflags);
> >  	if (!event)
> > @@ -4750,7 +4764,9 @@ perf_event_alloc(struct perf_event_attr *attr,
> >  	case PERF_TYPE_RAW:
> >  	case PERF_TYPE_HARDWARE:
> >  	case PERF_TYPE_HW_CACHE:
> > -		pmu = hw_perf_event_init(event);
> > +		pmu = perf_event_lookup_pmu(event);
> > +		if (pmu && pmu->init_event)
> > +			err = pmu->init_event(event);
> 
> 
> 
> Having the same for software, tracepoints and breakpoints events would
> be nice, so that we have a single simple path in perf_event_alloc
> to initialize the event.

Will add this later.
For now, let's first work on the hw pmus.

> 
> Thanks.
> 


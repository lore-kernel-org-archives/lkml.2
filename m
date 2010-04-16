Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429Ab0DPNX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 09:23:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397Ab0DPNX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 09:23:58 -0400
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: Gary.Mohr@Bull.com
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Stephane Eranian <eranian@googlemail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
References: <OFA47E1D5E.A81B0A43-ON07257706.00721254-07257706.0074D40F@us-phx1.az05.bull.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 16 Apr 2010 15:24:10 +0200
Message-ID: <1271424250.4807.2277.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 14:16 -0700, Gary.Mohr@Bull.com wrote:
> > On Tue, 2010-03-30 at 09:49 -0700, Corey Ashford wrote:
> >
> > Right, I've got some definite ideas on how to go here, just need some
> > time to implement them.
> >
> > The first thing that needs to be done is get rid of all the __weak
> > functions (with exception of perf_callchain*, since that really is arch
> > specific).
> >
> > For hw_perf_event_init() we need to create a pmu registration facility
> > and lookup a pmu_id, either passed as an actual id found in sysfs or an
> > open file handle from sysfs (the cpu pmu would be pmu_id 0 for backwards
> > compat).
> >
> > hw_perf_disable/enable() would become struct pmu functions and
> > perf_disable/enable need to become per-pmu, most functions operate on a
> > specific event, for those we know the pmu and hence can call the per-pmu
> > version. (XXX find those sites where this is not true).
> >
> > Then we can move to context, yes I think we want new context for new
> > PMUs, otherwise we get very funny RR interleaving problems. My idea was
> > to move find_get_context() into struct pmu as well, this allows you to
> > have per-pmu contexts. Initially I'd not allow per-pmu-per-task contexts
> > because then things like perf_event_task_sched_out() would get rather
> > complex.
> >
> > For RR we can move away from perf_event_task_tick and let the pmu
> > install a (hr)timer for this on their own.
> >
> > I've been planning to implement this for more than a week now, its just
> > that other stuff keeps getting in the way.
> >
> 
> Hi Peter,
> 
> My name is Gary Mohr and I work for Bull Information Systems.  I have been
> following your discussions with Corey (and others) about how to implement
> support for nest PMU's in the linux kernel.
> 
> My company feels that support for Intel Nehalem uncore events is very
> important to our customers.  Has the "other stuff" mentioned above quited down to
> allow you to get started on building support for these features ?? 

Sadly no.

>  If development
> is actually in progress, would you be willing to make a guess as to which
> version of the kernel may offer the new capabilities ??
> 
> As I said we are interested so if there is any way we can assist you,
> please let us know.  We would be happy to take experimental patch sets and
> validate, test, and debug any problems we encounter if that would help your
> development.

Supply patches to make the above happen ;-)

One thing not on that list, which should happen first I guess, is to
remove hw_perf_group_sched_in(). The idea is to add some sort of
transactional API to the struct pmu, so that we can delay the
schedulability check until commit time (and roll back when it fails).

Something as simple as:

  struct pmu {
    void start_txn(struct pmu *);
    void commit_txn(struct pmu *);

    ,,,
  };

and then change group_sched_in() to use this instead of
hw_perf_group_sched_in(), whose implementations mostly replicate
group_sched_in() in various buggy ways anyway.



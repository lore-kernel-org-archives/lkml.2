Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1CBAhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 19:37:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:36413 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab1CBAhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 19:37:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,250,1297065600"; 
   d="scan'208";a="662844063"
Subject: Re: [PATCH v2 1/4] perf-events: Add support for supplementary
 event registers
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimvx+MYhOw8VFsJn4V6FQutKiYO6pHxgd9xGY8A@mail.gmail.com>
References: <1298998076.2170.62.camel@localhost>
	 <AANLkTimvx+MYhOw8VFsJn4V6FQutKiYO6pHxgd9xGY8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 08:37:26 +0800
Message-ID: <1299026246.4937.99.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 01:09 +0800, Stephane Eranian wrote:
> Lin,
> 
> See comments below:
> 
> On Tue, Mar 1, 2011 at 5:47 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >  static struct event_constraint *
> > +intel_percore_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
> > +{
> > +       struct hw_perf_event *hwc = &event->hw;
> > +       unsigned int e = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
> > +       struct event_constraint *c;
> > +       struct intel_percore *pc;
> > +       struct er_account *era;
> > +       int i;
> > +       int free_slot;
> > +       int found;
> > +
> > +       if (!x86_pmu.percore_constraints || hwc->extra_alloc)
> > +               return NULL;
> > +
> > +       for (c = x86_pmu.percore_constraints; c->cmask; c++) {
> > +               if (e != c->code)
> > +                       continue;
> > +
> > +               /*
> > +                * Allocate resource per core.
> > +                */
> > +               c = NULL;
> 
> Not sure I understand this c = NULL, given you hardcoded return NULL
> outside of the
> loop. I forgot to mention this earlier.

Right, that is redundant.
Remove it.

> 
> > +               pc = cpuc->per_core;
> > +               if (!pc)
> > +                       break;
> > +               c = &emptyconstraint;
> > +               raw_spin_lock(&pc->lock);
> > +               free_slot = -1;
> > +               found = 0;
> > +               for (i = 0; i < MAX_EXTRA_REGS; i++) {
> > +                       era = &pc->regs[i];
> > +                       if (era->ref > 0 && hwc->extra_reg == era->extra_reg) {
> > +                               /* Allow sharing same config */
> > +                               if (hwc->extra_config == era->extra_config) {
> > +                                       era->ref++;
> > +                                       cpuc->percore_used = 1;
> > +                                       hwc->extra_alloc = 1;
> > +                                       c = NULL;
> > +                               }
> > +                               /* else conflict */
> > +                               found = 1;
> > +                               break;
> > +                       } else if (era->ref == 0 && free_slot == -1)
> > +                               free_slot = i;
> > +               }
> > +               if (!found && free_slot != -1) {
> > +                       era = &pc->regs[free_slot];
> > +                       era->ref = 1;
> > +                       era->extra_reg = hwc->extra_reg;
> > +                       era->extra_config = hwc->extra_config;
> > +                       cpuc->percore_used = 1;
> > +                       hwc->extra_alloc = 1;
> > +                       c = NULL;
> > +               }
> > +               raw_spin_unlock(&pc->lock);
> > +               return c;
> > +       }
> > +
> > +       return NULL;
> > +}
> > +
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 8ceb5a6..48d966a 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -225,8 +225,14 @@ struct perf_event_attr {
> >        };
> >
> >        __u32                   bp_type;
> > -       __u64                   bp_addr;
> > -       __u64                   bp_len;
> > +       union {
> > +               __u64           bp_addr;
> > +               __u64           config1; /* extension of config0 */
> > +       };
> > +       union {
> > +               __u64           bp_len;
> > +               __u64           config2; /* extension of config1 */
> > +       };
> >  };
> >
> I don't see where those config0 or config1 are coming from.

config0 means perf_event_attr::config.

Peter suggested to extend the attr config space.
http://marc.info/?l=linux-kernel&m=129838808907525&w=2



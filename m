Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1KGP0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:26:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab1KGPZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:25:58 -0500
Date: Mon, 7 Nov 2011 17:25:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
Message-ID: <20111107152540.GF8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-3-git-send-email-gleb@redhat.com>
 <1320676609.18053.44.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320676609.18053.44.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:36:49PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > +static u64 read_pmc(struct kvm_pmc *pmc)
> > +{
> > +       u64 counter, enabled, running;
> > +
> > +       counter = pmc->counter;
> > +
> > +       if (pmc->perf_event)
> > +               counter += perf_event_read_value(pmc->perf_event,
> > +                                                &enabled, &running);
> > +
> > +       /* FIXME: Scaling needed? */
> 
> Since the below programming doesn't use perf_event_attr::pinned, yes.
> 
Yes, that is on todo :). Actually I do want to place all guest perf
counters into the same event group and make it pinned. But currently perf
event groups are not very flexible. In our usage scenario we can't have
one event as a group leader since events are created and destroyed very
dynamically. What I would like is to have something like meta event that
will group all other real event.

> > +       return counter & pmc_bitmask(pmc);
> > +}
> 
> > +static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
> > +               unsigned config, bool exclude_user, bool exclude_kernel,
> > +               bool intr)
> > +{
> > +       struct perf_event *event;
> > +       struct perf_event_attr attr = {
> > +               .type = type,
> > +               .size = sizeof(attr),
> > +               .exclude_idle = true,
> > +               .exclude_host = 1,
> > +               .exclude_user = exclude_user,
> > +               .exclude_kernel = exclude_kernel,
> > +               .sample_period = (-pmc->counter) & pmc_bitmask(pmc),
> > +               .config = config,
> > +       };
> > +
> > +       event = perf_event_create_kernel_counter(&attr, -1, current,
> > +                                                intr ? kvm_perf_overflow_intr :
> > +                                                kvm_perf_overflow, pmc);
> > +       if (IS_ERR(event)) {
> > +               printk_once("kvm: pmu event creation failed %ld\n",
> > +                               PTR_ERR(event));
> > +               return;
> > +       }
> > +
> > +       pmc->perf_event = event;
> > +       clear_bit(pmc->idx, (unsigned long*)&pmc->vcpu->arch.pmu.reprogram_pmi);
> > +} 

--
			Gleb.

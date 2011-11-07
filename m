Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab1KGPx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:53:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab1KGPxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:53:52 -0500
Date: Mon, 7 Nov 2011 17:53:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
Message-ID: <20111107155336.GI8670@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-7-git-send-email-gleb@redhat.com>
 <1320674870.18053.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320674870.18053.37.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:07:50PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > @@ -1580,6 +1580,8 @@ __init int intel_pmu_init(void)
> >         x86_pmu.num_counters            = eax.split.num_counters;
> >         x86_pmu.cntval_bits             = eax.split.bit_width;
> >         x86_pmu.cntval_mask             = (1ULL << eax.split.bit_width) - 1;
> > +       x86_pmu.events_mask             = ebx;
> > +       x86_pmu.events_mask_len         = eax.split.mask_length;
> >  
> >         /*
> >          * Quirk: v2 perfmon does not report fixed-purpose events, so
> > @@ -1651,6 +1653,7 @@ __init int intel_pmu_init(void)
> >                          * architectural event which is often completely bogus:
> >                          */
> >                         intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
> > +                       x86_pmu.events_mask &= ~0x40;
> >  
> >                         pr_cont("erratum AAJ80 worked around, ");
> >                 } 
> 
> It might make sense to introduce cpuid10_ebx or so, also I think the
> removal of the branch-miss-retired event is either unwanted or
> incomplete. As seen software already expects that bit to be set, even
> though its known broken.
> 
I removed branch-miss-retired here because for perf user it exists. Perf
approximates it by other event but perf user shouldn't know that. A
guest is not always runs with exactly same cpu model number as a host,
so if we will not drop the bit here if guest will see cpu model other
than the one that has this quirk it will not be able to use the event.

BTW why perf does not check event mask to see if architectural event is
available before programming it?

> At the very least add a full ebx iteration to disable unsupported events
> in the intel-v1 case.

--
			Gleb.

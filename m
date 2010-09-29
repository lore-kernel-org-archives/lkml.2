Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0I2Qu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:50:57 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:39511
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0I2Qu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:50:56 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zzbb2cK1432N98dN179dN103dK2f55kzz1202hzzz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L9IPGH-02-6ZA-02
X-M-MSG: 
Date: Wed, 29 Sep 2010 18:50:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] oprofile, arm: proper release resources on failure
Message-ID: <20100929165027.GP13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
 <1285774784.30080.19.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1285774784.30080.19.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.10 11:39:44, Will Deacon wrote:

> I have a few minor clarifications:
> > 
> 
> > diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> > index 0691176..72e09eb 100644
> > --- a/arch/arm/oprofile/common.c
> > +++ b/arch/arm/oprofile/common.c
> > @@ -102,6 +102,7 @@ static int op_create_counter(int cpu, int event)
> >         if (IS_ERR(pevent)) {
> >                 ret = PTR_ERR(pevent);
> >         } else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
> > +               perf_event_release_kernel(pevent);
> >                 pr_warning("oprofile: failed to enable event %d "
> >                                 "on CPU %d\n", event, cpu);
> >                 ret = -EBUSY;
> 
> 
> Yup, this is needed. Thanks! It would be nice to do away with the
> else statement altogether but I think adding a pinned event and
> then failing to activate it still succeeds in
> perf_event_create_kernel_counter.

Yes, I have cleanup code already for this. But as this is an -rc and
stable fix, I didn't want to change too much here. But I will send a
follow-on patch with the cleanup I made.

> 
> 
> > @@ -365,6 +366,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
> >         ret = init_driverfs();
> >         if (ret) {
> >                 kfree(counter_config);
> > +               counter_config = NULL;
> >                 return ret;
> >         }
> > 
> > @@ -402,7 +404,6 @@ void oprofile_arch_exit(void)
> >         struct perf_event *event;
> > 
> >         if (*perf_events) {
> > -               exit_driverfs();
> >                 for_each_possible_cpu(cpu) {
> >                         for (id = 0; id < perf_num_counters; ++id) {
> >                                 event = perf_events[cpu][id];
> > @@ -413,8 +414,10 @@ void oprofile_arch_exit(void)
> >                 }
> >         }
> > 
> > -       if (counter_config)
> > +       if (counter_config) {
> >                 kfree(counter_config);
> > +               exit_driverfs();
> > +       }
> >  }
> >  #else
> >  int __init oprofile_arch_init(struct oprofile_operations *ops)
> > --
> > 1.7.2.2
> > 
> 
> Hmm, these three hunks conflict with the patches I posted last
> month to fix the resource allocation and freeing. Can't we
> merge those patches instead? I have versions against -rc6 here:

Yes, these patches are also in my oprofile/core branch and its changes
conflict, but are scheduled for the next merge window. This fix is for
urgent and for 2.6.36. We will then merge back rc7 or 2.6.36 to
oprofile/core and solve the conflicts. But if you don't have something
else for -rc7/.36 that conflicts, this should be ok.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


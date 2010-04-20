Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0DTQGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:06:47 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:2452 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751970Ab0DTQGp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:06:45 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0L16NDZ-01-DEH-02
X-M-MSG: 
Date: Tue, 20 Apr 2010 18:05:57 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100420160557.GT11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Apr 2010 16:05:57.0668 (UTC) FILETIME=[5CEB0E40:01CAE0A3]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.10 15:46:29, Stephane Eranian wrote:
> > +       if (event->hw.sample_period)
> > +               /*
> > +                * The usage of the sample period attribute to
> > +                * calculate the IBS max count value is not yet
> > +                * supported, the max count must be in the raw config
> > +                * value.
> > +                */
> > +               return -ENOSYS;
> > +
> What is the problem with directly using the period here, rejecting
> any value that is off range or with bottom 4 bits set?

Yes, I will create an updated version of this patch.

> > +       if (event->attr.type != PERF_TYPE_RAW)
> > +               /* only raw sample types are supported */
> > +               return -EINVAL;
> > +
> > +       type = get_model_spec_type(event->attr.config);
> > +       switch (type) {
> > +       case MODEL_SPEC_TYPE_IBS_FETCH:
> > +               event->hw.config = IBS_FETCH_CONFIG_MASK & event->attr.config;
> > +               event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_FETCH;
> > +               /*
> > +                * dirty hack, needed for __x86_pmu_enable_event(), we
> > +                * should better change event->hw.config_base into
> > +                * event->hw.config_msr that already includes the index
> > +                */
> > +               event->hw.config_base = MSR_AMD64_IBSFETCHCTL - event->hw.idx;
> > +               break;
> > +       case MODEL_SPEC_TYPE_IBS_OP:
> > +               event->hw.config = IBS_OP_CONFIG_MASK & event->attr.config;
> > +               event->hw.idx = X86_PMC_IDX_SPECIAL_IBS_OP;
> > +               event->hw.config_base = MSR_AMD64_IBSOPCTL - event->hw.idx;
> > +               break;
> 
> IBSOP.cnt_ctl only available from RevC, need to check and reject if older.

Right, for this patch I will modify IBS_OP_CONFIG_MASK to RevB only
bits, later I will add cpuid detection and pmu revision checks in a
separate patch.

> > +static struct event_constraint amd_event_constraints[] =
> > +{
> > +       /*
> > +        * The value for the weight of these constraints is higher
> > +        * than in the unconstrainted case to process ibs after the
> > +        * generic counters in x86_schedule_events().
> > +        */
> > +       __EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_FETCH, 0,
> > +                          AMD64_NUM_COUNTERS + 1),
> > +       __EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_SPECIAL_IBS_OP, 0,
> > +                          AMD64_NUM_COUNTERS + 1),
> > +       EVENT_CONSTRAINT_END
> > +};
> > +
> I think you could define EVENT_IBS_CONSTRAINT() and shorten
> the definitions here. You could pass FETCH or OP and the macro
> would do the bit shifting. This is how it's done for fixed counters on Intel.

Ok, I will update this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


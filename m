Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1BBRYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:24:31 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:23862
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503Ab1BBRYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:24:30 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2cK936eK1432N98dNzz1202hzzz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG030J-01-R3C-02
X-M-MSG: 
Date: Wed, 2 Feb 2011 18:24:19 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] perf, x86: Add support for AMD family 15h core
 counters
Message-ID: <20110202172419.GB5874@erda.amd.com>
References: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
 <1296664860-10886-6-git-send-email-robert.richter@amd.com>
 <1296666198.26581.343.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1296666198.26581.343.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.02.11 12:03:18, Peter Zijlstra wrote:
> On Wed, 2011-02-02 at 17:41 +0100, Robert Richter wrote:
> > +       unsigned int    eventsel;
> > +       unsigned int    perfctr;
> > +       unsigned int    *eventsel_map;
> > +       unsigned int    *perfctr_map;
> >         u64             (*event_map)(int);
> >         int             max_events;
> >         int             num_counters;
> > @@ -323,11 +325,17 @@ again:
> >  
> >  static inline unsigned int x86_pmu_config_addr(int index)
> >  {
> > +       if (x86_pmu.eventsel_map)
> > +               return x86_pmu.eventsel_map[index];
> > +
> >         return x86_pmu.eventsel + index;
> >  }
> >  
> >  static inline unsigned int x86_pmu_event_addr(int index)
> >  {
> > +       if (x86_pmu.perfctr_map)
> > +               return x86_pmu.perfctr_map[index];
> > +
> >         return x86_pmu.perfctr + index;
> >  } 
> 
> Why this and not something like x86_pmu.perfctr + (index << 1)?
> You could even use alternatives.

I was thinking about this. The main reason is the implementation of
northbridge counters, the range is in MSRC001_02[47:40]. This would
add more complexity then. Using a table would be something like

unsigned int eventsel_f15h[] = {
	MSR_F15H_PERF_CTL,
	MSR_F15H_PERF_CTL + 2,
	MSR_F15H_PERF_CTL + 4,
	MSR_F15H_PERF_CTL + 6,
	MSR_F15H_PERF_CTL + 8,
	MSR_F15H_PERF_CTL + 10,
	MSR_F15H_NB_PERF_CTL,
	MSR_F15H_NB_PERF_CTL + 2,
	MSR_F15H_NB_PERF_CTL + 6,
	MSR_F15H_NB_PERF_CTL + 8,
};

We don't need to change the address generation for this. Otherwise we
need to introduce more logic for the calculation.

Also, were could be potential easier implementations for fixed
counters, BTS, P4, IBS, etc. But didn't look that close at it.

(Btw, I am not yet sure if NB counters shouldn't better start at index
16 or so to reserve space for perf counter expansion.)

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


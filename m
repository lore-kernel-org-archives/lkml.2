Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0DTKb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 06:31:27 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:29339
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754339Ab0DTKb0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 06:31:26 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zz1432P98dN936eM179dN62a3Lzz1202hzzz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0L167VW-02-0QT-02
X-M-MSG: 
Date: Tue, 20 Apr 2010 12:31:06 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] perf, x86: implement AMD IBS event configuration
Message-ID: <20100420103106.GR11907@erda.amd.com>
References: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
 <1271190201-25705-12-git-send-email-robert.richter@amd.com>
 <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <h2obd4cb8901004190646v8231b6a1sf47d0cff6481cc5e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Apr 2010 10:31:06.0776 (UTC) FILETIME=[95D03980:01CAE074]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.04.10 15:46:29, Stephane Eranian wrote:
> > +static inline void amd_pmu_disable_ibs(void)
> > +{
> > +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > +       u64 val;
> > +
> > +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_FETCH, cpuc->active_mask)) {
> > +               rdmsrl(MSR_AMD64_IBSFETCHCTL, val);
> > +               val &= ~IBS_FETCH_ENABLE;
> > +               wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
> > +       }
> > +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_OP, cpuc->active_mask)) {
> > +               rdmsrl(MSR_AMD64_IBSOPCTL, val);
> > +               val &= ~IBS_OP_ENABLE;
> > +               wrmsrl(MSR_AMD64_IBSOPCTL, val);
> > +       }
> > +}
> > +
> > +static inline void amd_pmu_enable_ibs(void)
> > +{
> > +       struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> > +       u64 val;
> > +
> > +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_FETCH, cpuc->active_mask)) {
> > +               rdmsrl(MSR_AMD64_IBSFETCHCTL, val);
> > +               val |= IBS_FETCH_ENABLE;
> > +               wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
> > +       }
> > +       if (test_bit(X86_PMC_IDX_SPECIAL_IBS_OP, cpuc->active_mask)) {
> > +               rdmsrl(MSR_AMD64_IBSOPCTL, val);
> > +               val |= IBS_OP_ENABLE;
> > +               wrmsrl(MSR_AMD64_IBSOPCTL, val);
> > +       }
> > +}
> 
> Aren't you picking up stale state by using read-modify-write here?

Hmm, there is a reason for this implementation. Both functions are
only used in .enable_all() and .disable_all() which was originally
used in atomic sections to disable NMIs during event scheduling and
setup. For this short switch off of the pmu the register state is not
saved. On Intel this is implemented by only writing to
MSR_CORE_PERF_GLOBAL_CTRL. The proper way to enable events is to use
amd_pmu_enable_event() which is x86_pmu.enable(event).

Locking at the latest sources this might have changed a little in
between and we have to check that this functions above are not used to
enable events. So I am not really sure if the register may be setup
wrong. But if this happens, then only for the first sample after
enabling or reenabling of the whole pmu since the interrupt handler is
using __x86_pmu_enable_event() to reenable ibs. Thus I would prever
the implementation above and instead reimplement the nmi handling (see
below).

Also, We should avoid a global pmu disable generally since it is
expensive and also the pmu state may not be restored properly for some
events on some hw revisions. But the code must then be atomic.

An alternative solution to disable NMIs on AMD could be to mask the
nmi by writing to the lapic instead of the counter msrs. This could be
more efficient and the pmu will go on with sampling without the need
to restore the state. Or this way: the interrupt handler does not
handle events and only clears the reason if some 'atomic' flag is set?

IMHO I think, also the implementation for x86_pmu_enable_all() and
x86_pmu_disable_all() is not accurate, since the state is not stored
when disabling all counters and then reenabling it with the init
value. On Intel counters this is without impact since the global ctrl
msr is used. In all other cases x86_pmu_enable_all() does not restore
the previous counter state.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


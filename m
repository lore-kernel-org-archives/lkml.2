Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0KXBce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:32:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:8873 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0KXBcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:32:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,245,1288594800"; 
   d="scan'208";a="576963486"
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
References: <1290340877.2245.124.camel@localhost>
	 <AANLkTikt8AkZjNahrzTStJ5qM0D4Z+H_7snZBgsABm24@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 09:33:43 +0800
Message-ID: <1290562423.2405.54.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 18:17 +0800, Stephane Eranian wrote:
> Lin,
> 
> On Sun, Nov 21, 2010 at 1:01 PM, Lin Ming <ming.m.lin@intel.com> wrote:
> > +static void uncore_pmu_enable_all(void)
> > +{
> > +       u64 ctrl;
> > +
> > +       /*
> > +        * (0xFULL << 48): 1 of the 4 cores can receive NMI each time
> > +        * but we don't know which core will receive the NMI when overflow happens
> > +        */
> 
> That does not sound right. If you set bit 48-51 to 1, then all 4 cores
> will receive EVERY
> interrupt, i.e., it's a broadcast. That seems to contradict your
> comment: 1 of the 4. Unless
> you meant, they all get the interrupt and one will handle it, the
> other will find nothing to
> process. But I don't see the atomic op that would make this true in
> uncore_handle_irq().

I thought it's a broadcast too in the v1 patches, let me double check
it.

> 
> I also think that if you want all processors to receive the
> interrupts, then the mask should
> be 0xff when HT is on. The manual is rather obscure on this, but it
> does make sense.

Kernel panics if 0xff is set, but it maybe bugs of my code.

Anyway, is it told in some errata that the mask should be 0xff when HT
is on?

Thanks,
Lin Ming

> 
> 
> > +       ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | (0xFULL << 48);
> > +       ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
> > +
> > +       /*
> > +        * Freeze the uncore pmu on overflow of any uncore counter.
> > +        * This makes unocre NMI handling easier.
> > +        */
> > +       ctrl |= MSR_UNCORE_PERF_GLOBAL_CTRL_PMI_FRZ;
> > +
> > +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
> > +}
> > +



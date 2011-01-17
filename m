Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1AQB3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 20:29:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:33519 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab1AQB3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 20:29:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,331,1291622400"; 
   d="scan'208";a="877990449"
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTikZgmUQ2SHOL41_t-Vwss8T6tazTRJT2bVR+xRQ@mail.gmail.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
	 <AANLkTikZgmUQ2SHOL41_t-Vwss8T6tazTRJT2bVR+xRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 09:29:29 +0800
Message-ID: <1295227769.28388.82.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-14 at 01:14 +0800, Stephane Eranian wrote:
> Lin,

Hi, Stephane, 

Sorry for late response, I'm just back from vacation.

> 
> On Thu, Dec 2, 2010 at 6:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> > +static void uncore_pmu_enable_all(int nmi_core)
> > +{
> > +       u64 ctrl;
> > +
> > +       ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
> > +
> > +       /* Route all interrupts to the first core that accesses uncore */
> > +       ctrl |= 1ULL << (48 + nmi_core);
> > +
> > +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
> > +}
> 
> Are you sure nmi_core is always between 0-3 on a 4-core system and 0-5
> on a 6-core system?
> In other words, is that what topology_core_id(raw_smp_processor_id()) returns?

I just have a look at a 6-core system, the core id is not 0-5

$ cat /proc/cpuinfo |grep "core id"
core id		: 0
core id		: 1
core id		: 2
core id		: 8
core id		: 9
core id		: 10

So we'd better route all the interrupts to the first core of the socket.

Thanks for the catch.
Lin Ming

> 
> Note that, unfortunately, I have not seen documentation that says on
> 6-core system
> UNC_GLOBAL_CTRL has 6 interrupt target bits, but it would make sense.
> 
> 
> Otherwise, you will get a kernel panic when you wrmsr UNC_GLOBAL_CTRL.
> 
> > +
> > +       if (uncore->n_events == 1) {
> > +               nmi_core = topology_core_id(raw_smp_processor_id());
> > +               uncore->nmi_core = nmi_core;
> > +               uncore_pmu_enable_all(nmi_core);
> > +       }



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab1AMRO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:14:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42526 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab1AMROX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:14:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rY+n5w+uqB92iOlt5agvJdkjrmGLmykkpOf2XIiNZ1owyOox+b6xLWEY41NRIJbWtc
         w8o9s1D1US4o7+ZvukFA==
MIME-Version: 1.0
In-Reply-To: <1291267223.2405.314.camel@minggr.sh.intel.com>
References: <1291267223.2405.314.camel@minggr.sh.intel.com>
Date: Thu, 13 Jan 2011 18:14:19 +0100
Message-ID: <AANLkTikZgmUQ2SHOL41_t-Vwss8T6tazTRJT2bVR+xRQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3 v3] perf: Implement Nehalem uncore pmu
From: Stephane Eranian <eranian@google.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lin,

On Thu, Dec 2, 2010 at 6:20 AM, Lin Ming <ming.m.lin@intel.com> wrote:
> +static void uncore_pmu_enable_all(int nmi_core)
> +{
> +       u64 ctrl;
> +
> +       ctrl = ((1 << UNCORE_NUM_GENERAL_COUNTERS) - 1) | MSR_UNCORE_PERF_GLOBAL_CTRL_EN_FC0;
> +
> +       /* Route all interrupts to the first core that accesses uncore */
> +       ctrl |= 1ULL << (48 + nmi_core);
> +
> +       wrmsrl(MSR_UNCORE_PERF_GLOBAL_CTRL, ctrl);
> +}

Are you sure nmi_core is always between 0-3 on a 4-core system and 0-5
on a 6-core system?
In other words, is that what topology_core_id(raw_smp_processor_id()) returns?

Note that, unfortunately, I have not seen documentation that says on
6-core system
UNC_GLOBAL_CTRL has 6 interrupt target bits, but it would make sense.


Otherwise, you will get a kernel panic when you wrmsr UNC_GLOBAL_CTRL.

> +
> +       if (uncore->n_events == 1) {
> +               nmi_core = topology_core_id(raw_smp_processor_id());
> +               uncore->nmi_core = nmi_core;
> +               uncore_pmu_enable_all(nmi_core);
> +       }

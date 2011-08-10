Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1HJSdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 14:33:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41413 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585Ab1HJSdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 14:33:40 -0400
Date: Wed, 10 Aug 2011 19:33:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sam wang <linux.swang@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch] perf: ARMv7 wrong "branches" generalized instruction
Message-ID: <20110810183306.GA32695@e102144-lin.cambridge.arm.com>
References: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108101328440.22769@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 06:40:31PM +0100, Vince Weaver wrote:
> Hello

Hi Vince,

> Sam Wang reported to me that my perf_event validation tests were failing 
> with branches on ARM Cortex A9.
> 
> It turns out the branches event used (ARMV7_PERFCTR_PC_WRITE) only seems
> to count taken branches.

It also counts exceptions and instructions that write to the PC.

> ARMV7_PERFCTR_PC_IMM_BRANCH seems to do a better job of counting both 
> taken and not-taken.  So I've attached a patch to change the definition
> for Cotex A9.

Well, it also only considers immediate branches so whilst it might satisy
your test, I think that overall it's a less meaningful number.

> This might be needed for Cortex A8 but I don't have a machine to test on 
> (yet).

We use the same event encoding for HW_BRANCH_INSTRUCTIONS on the A8.

> I'm assuming this is a proper fix.  The "generalized" events aren't 
> defined very well so there's always some wiggle room about what they mean.

I'm really not a big fan of the generalised events. I appreciate that they
make perf easier to use but *only* if you can actually provide a sensible
definition of the event which can (ideally) be compared between two
different CPU implementations for the same architecture.

So, my take on this is that we should either:

(a) leave it like it is since taken branches is probably a more useful
    metric than number of immediate branches executed.

(b) start replacing our generalised events with HW_OP_UNSUPPORTED and force
    the user to use raw events. I agree this isn't very friendly, but it's
    better than giving them crazy results [for example, we currently report
    more cache misses than cache references on A9 iirc].

Personally, I'm favour of (b) and getting userspace to provide the user with
a CPU-specific event listing and then translate this to raw events using
something like libpfm.

As an aside, I also think this is part of a bigger problem. For example, the
software event PERF_COUNT_SW_EMULATION_FAULTS would be much more useful if
we could describe different types of emulation faults. These would probably
be architecture-specific and we would need a way for userspace to communicate
the event subclass to the kernel rather than having separate ABI events for
them. So not only would we want raw events, we'd also want a way to specify
the PMU to handle them (given that a global event namespace across PMUs is
unrealistic).

Will

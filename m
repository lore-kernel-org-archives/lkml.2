Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2FTJ3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:29:44 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:55812 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab2FTJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:29:42 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIzz1202hzzz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5WT1B-02-50A-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 11:29:32 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD
 family 15h
Message-ID: <20120620092932.GH1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane,

On 20.06.12 10:23:48, Stephane Eranian wrote:
> I dont' quite understand the design choice here. In Fam15h, there is
> a clean design for the uncore PMU. It has its own distinct set of 4
> counters. Unlike Fam10h, where you program core counters to access
> the NB counters. So why not like with Intel uncore, create a
> separate NB PMU which would advertise its characteristics? That does
> not preclude re-using the existing AMD-specific routines wherever
> possible. I think the advantage is that muxing or starting/stopping
> of the core PMU would not affect uncore and vice-versa for
> instance. Wouldn't this also alleviate the problems with assigning
> indexes to uncore PMU counters?

I was thinking of creating a separate pmu too. There were 2
fundamental problems with it. First, the implementation would have
been different to the family 10h implementation. But besides the new
counter msr range and the per-node counter msrs there is not much
difference to perfctrs of family 10h and also family 15h. Otherwise NB
events would have been programmed different for both families.

Second, since nb perfctr are implemented the same way as core
counters, the same code would have been used. Thus multiple (two) x86
pmus (struct x86_pmu) would reside in parallel in the kernel. The
current implemenation is not designed for this. A complete rework of
the x86 perf implementation with impact to more code than this
implemetation was the main reason against that approach and for
choosing this design.

The main problem with my approach was the introduction of counter
masks and conflicts with Intel's fixed counter. I think my patches
address this in a clean way which also led to a bit code cleanup.
Another advantage I see is the unification of AMD pmus and a straight
AMD setup code that is not widely spread other multiple pmus. The
setup code uses cpuid and is family independent.

I generally could imagine to switch AMD NB implementation to an
uncore-like counter support. But then I would prefer a homogeneous
implementation over all AMD families. This would be a separate patch
set that is independent from family 15h nb counter implementation.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


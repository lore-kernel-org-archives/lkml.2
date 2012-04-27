Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430Ab2D0PTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:19:06 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:34785
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760145Ab2D0PTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:19:03 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3597J-02-4IM-02
X-M-MSG: 
Date: Fri, 27 Apr 2012 17:18:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120427151852.GH18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
 <1334398906.2528.49.camel@twins>
 <20120423095659.GS9747@erda.amd.com>
 <20120427123434.GF18810@erda.amd.com>
 <CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
 <20120427125410.GG18810@erda.amd.com>
 <CABPqkBTS2NkFqjVT9HgzPT=TTo9oOc__H9ZDDbXJK7WRpO0Vgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBTS2NkFqjVT9HgzPT=TTo9oOc__H9ZDDbXJK7WRpO0Vgg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.04.12 15:10:22, Stephane Eranian wrote:
> perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count
> perf record -a -e r076:p ...          # same as -e cpu-cycles:p
> perf record -a -e r0C1:p ...          # use ibs op counting micro-ops
> 
> Each IBS sample contains a linear address that points to the
> instruction that was causing the sample to trigger. With ibs we have
> skid 0.
> 
> Though the skid is 0, we map IBS sampling to following precise levels:
> 
>  1: RIP taken from IBS sample or (if invalid) from stack.
> 
> I assume by stack you mean pt_regs, right?

Right.

> 
> 2: RIP always taken from IBS sample, samples with an invalid rip
>    are dropped. Thus samples of an event containing two precise
>    modifiers (e.g. r076:pp) only contain (precise) addresses
>    detected with IBS.
> 
> I don't think you need the distinction between 1 and 2. You can
> always use the pt_regs IP as a fallback. You can mark that the
> IP is precise with the MISC_EXACT flag in the sample header.
> This is how it's done with PEBS. What's wrong with that?
> It may actually be better than dropping samples silently as it
> may introduce some bias.

There is nothing wrong with it. I already implemented that the
MISC_EXACT flag is supported. But, the flag is basically not used in
the perf tool and there is no modifier or so to only get a precise
rip.

Supose you want to use perf-annotate you only want to get precise
rips. With the levels suggested above you can do so with:

 perf record -a -e r076:pp ... | perf annotate ...

(Note the double-p.)

For non-biased sampling (e.g. counting or statistic numbers) you take
level 1 and you get every sample:

 perf record -a -e r076:p ...

There is the lack of a modifier to evaluate MISC_EXACT the same way.
That's why my choice of the levels above. Didn't have a better idea.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


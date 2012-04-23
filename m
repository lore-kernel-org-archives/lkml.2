Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2DWJ5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:57:11 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:27988
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226Ab2DWJ5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:57:10 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2XFMZ-02-18F-02
X-M-MSG: 
Date: Mon, 23 Apr 2012 11:56:59 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120423095659.GS9747@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
 <1334398906.2528.49.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1334398906.2528.49.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.04.12 12:21:46, Peter Zijlstra wrote:
> On Mon, 2012-04-02 at 20:19 +0200, Robert Richter wrote:
> > + * We map IBS sampling to following precise levels:
> > + *
> > + *  1: RIP taken from IBS sample or (if invalid) from stack
> > + *  2: RIP always taken from IBS sample, samples with an invalid rip
> > + *     are dropped. Thus samples of an event containing two precise
> > + *     modifiers (e.g. r076:pp) only contain (precise) addresses
> > + *     detected with IBS.
> 
> 		/*
> 		 * precise_ip:
> 		 *
> 		 *  0 - SAMPLE_IP can have arbitrary skid
> 		 *  1 - SAMPLE_IP must have constant skid
> 		 *  2 - SAMPLE_IP requested to have 0 skid
> 		 *  3 - SAMPLE_IP must have 0 skid
> 		 *
> 		 *  See also PERF_RECORD_MISC_EXACT_IP
> 		 */
> 
> your 1 doesn't have constant skid. I would suggest only supporting 2 and
> letting userspace drop !PERF_RECORD_MISC_EXACT_IP records if so desired.

Ah, didn't notice the PERF_RECORD_MISC_EXACT_IP flag. Will set this
flag for precise events.

Problem is that this flag is not yet well supported, only perf-top
uses it to count the total number of exact samples. Esp. perf-annotate
and perf-report do not support it, and there are no modifiers to
select precise-only sampling (or is this level 3?).

Both might be useful: You might need only precise-rip samples (perf-
annotate usage), on the other side you want samples with every
clock/ops count overflow (e.g. to get a counting statistic). The
p-modifier specification (see perf-list) is not sufficient to select
both of it.

Another question I have: Isn't precise level 2 a special case of level
1 where the skid is constant and 0? The problem I see is, if people
want to measure precise rip, they simply use r076:p. Level 2 (r076:pp)
is actually better than 1, but they might think not to be able to
sample precise-rip if we throw an error for r076:p. Thus, I would
prefer to also allow level 1.

> That said, mixing the IBS pmu into the regular core pmu isn't exactly
> pretty..

IBS is currently the only way to do precise-rip sampling on amd cpus.
IBS events fit well with its corresponding perfctr events (0x76/
0xc1). So what don't you like with this approach? I will also post IBS
perf tool support where IBS can be directly used.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


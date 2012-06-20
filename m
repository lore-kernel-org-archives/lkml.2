Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2FTMl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:41:27 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:32408
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab2FTMl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:41:26 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I936eI1432Izz1202hzz8275bhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5X1WV-02-6EX-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 14:41:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] perf, x86: Add northbridge counter support for AMD
 family 15h
Message-ID: <20120620124114.GJ1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
 <CABPqkBS9hRxKLsecVK+AgRue6oqTtAg4=0Dpd5Z2VwAUja50fw@mail.gmail.com>
 <20120620092932.GH1478@erda.amd.com>
 <1340185084.21745.81.camel@twins>
 <20120620100031.GI1478@erda.amd.com>
 <CABPqkBRzeSB4SHMSnGbu+HfPyVMSwCUHKoeoa68UF4VrjjxKsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CABPqkBRzeSB4SHMSnGbu+HfPyVMSwCUHKoeoa68UF4VrjjxKsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.12 12:46:21, Stephane Eranian wrote:
> On Wed, Jun 20, 2012 at 12:00 PM, Robert Richter <robert.richter@amd.com> wrote:
> > On 20.06.12 11:38:04, Peter Zijlstra wrote:
> >> On Wed, 2012-06-20 at 11:29 +0200, Robert Richter wrote:
> >> > Second, since nb perfctr are implemented the same way as core
> >> > counters, the same code would have been used. Thus multiple (two) x86
> >> > pmus (struct x86_pmu) would reside in parallel in the kernel.
> >>
> >> Well, no. The I take it the uncore counters are nb wide, thus you need
> >> special goo to make counter rotation work properly, x86_pmu is unsuited
> >> for that.
> >
> > The code for nb and core counters is identical. There would be the
> > same nmi handler, same code to setup the event, same code to
> > start/stop cpus. The only difference are per-node msrs, even the msr
> > offset calculation is the same as for core counters on family 15h. It
> > would not make sense to duplicate all this code. And, as said, current
> > design does not fit to use x86_pmus in parallel or to easy reuse x86
> > functions. Separating nb counters would make the same sense as
> > implementing a separate pmu for fixed counters.
> >
> Being identical does not necessarily mean you have to copy the code,
> you can also simply call it.

You can't use two x86_pmu in parallel in the kernel. Code is not
designed for this. The effort of changing the code to support this is
very high.

> I don't see the explanation for the non-contiguous counter indexes.
> What's that about? With a separate PMU, would you have that problem.
> I see uncore CTL base MSRC001_0240, next is 0242, and so on. But
> that's already the case with core counters on Fam15h.

The counters reside in msrs MSRC001_0200 to MSRC001_027f with two msrs
per counter. This is room for 64 counters. NB counters start at index
32 which is MSRC001_0240.

> As Peter said, having your own PMU would alleviate the need for
> Patch 10. Those filters would simply not be visible to tools via
> sysfs.

That's what I explained in an earlier thread about pmu descriptions in
sysfs. It is not possible to describe a complex pmu in sysfs. My
preference that time was the use of pmu ops in userland and not a
single generic pmu that is configured by sysfs.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center


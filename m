Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2BFQhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:37:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46846 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2BFQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:37:43 -0500
Subject: Re: [BUG] perf: perf sched warning possibly due to clock
 granularity on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu, robert.richter@amd.com,
        eric.dumazet@gmail.com, Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <20120206153408.GA31237@aftab>
References: <20120206132546.GA30854@quad> <1328538403.2482.4.camel@laptop>
	 <20120206153408.GA31237@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 17:37:26 +0100
Message-ID: <1328546246.2482.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 16:34 +0100, Borislav Petkov wrote:
> + Andreas.
> 
> On Mon, Feb 06, 2012 at 03:26:43PM +0100, Peter Zijlstra wrote:
> > On Mon, 2012-02-06 at 14:25 +0100, Stephane Eranian wrote:
> > > In summary, two issues:
> > >   - Why is sched_clock_stable not set or even tested on recent AMD systems?
> 
> AFAICT, sched_clock_stable is set on Intel under the following conditions:
> 
>         /*
>          * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
>          * with P/T states and does not stop in deep C-states.
>          *
>          * It is also reliable across cores and sockets. (but not across
>          * cabinets - we turn it off in that case explicitly.)
>          */
>         if (c->x86_power & (1 << 8)) {
>                 set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>                 set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC);
>                 if (!check_tsc_unstable())
>                         sched_clock_stable = 1;
>         }
> 
> and yes, we can do CONSTANT_TSC and NONSTOP_TSC on the now older F10h
> already, so Bulldozer can do that too, implicitly.
> 
> I don't see why sched_clock_stable shouldn't be moved to generic x86
> code and set based on the two CPUID cap flags above.

stable means more than both those flags together.. 

 - CONSTANT_TSC means freq independent
 - NONSTOP_TSC means it doesn't get stopped in any C state

Together they make TSC completely C-state independent.
sched_clock_stable actually means that TSC is both _AND_ is consistent
across all CPUs in the entire system.




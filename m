Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab0GELPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:15:09 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40332 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab0GELPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:15:06 -0400
Date: Mon, 5 Jul 2010 20:14:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
       paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
Message-ID: <20100705111415.GA19699@linux-sh.org>
References: <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com> <1277464589.32034.276.camel@twins> <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com> <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop> <1277996555.1917.205.camel@laptop> <20100701153112.GA13511@console-pimps.org> <1277998793.1917.212.camel@laptop> <20100702025716.GA25499@linux-sh.org> <1278064323.1917.245.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278064323.1917.245.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 11:52:03AM +0200, Peter Zijlstra wrote:
> Right, so I was reading some of that code and I couldn't actually find
> where you keep consistency between the hardware counter value and the
> stored prev_count value.
> 
> That is, suppose I'm counting, the hardware starts at 0, hwc->prev_count
> = 0 and event->count = 0.
> 
> At some point, x we context switch this task away, so we ->disable(),
> which disables the counter and updates the values, so at that time
> hwc->prev = x and event->count = x, right?
> 
> Now suppose we schedule the task back in, so we do ->enable(), then what
> happens? sh_pmu_enable() finds an unused index, (disables it for some
> reason.. it should already be cleared if its not used, but I guess a few
> extra hardware writes dont hurt) and calls sh4a_pmu_enable() on it.
> 
I don't quite remember where the ->disable() came from, I vaguely recall
copying it from one of the other architectures, but it could have just
been a remnant of something I had for debug code. In any event, you're
correct, we don't seem to need it anymore.

> sh4a_pmu_enable() does 3 writes:
> 
>   PPC_PMCAT -- does this clear the counter value?

Yes, the counters themselves are read-only, so clearing is done through
the PMCAT control register.

>   PPC_CCBR  -- writes the ->config bits
>   PPC_CCBR  (adds CCBR_DUC, couldn't this be done in the 
>              previous write to this reg?)
> 
No, the DUC bit needs to be set by itself or the write is discarded on
some CPUs. Clearing it with other bits is fine, however. This is what
starts the counter running.

> Now assuming that enable does indeed clear the hardware counter value,
> shouldn't you also set hwc->prev_count to 0 again? Otherwise the next
> update will see a massive jump?
> 
I think that's a correct observation, but I'm having difficulty verifying
it on my current board since it seems someone moved the PMCAT register,
as the counters aren't being cleared on this particular CPU. I'll test on
the board I wrote this code for initially tomorrow and see how that goes.
It did used to work fine at least.

> Alternatively you could write the hwc->prev_count value back to the
> register.
> 
That would be an option if the counters weren't read-only, yes.

> If you eventually want to drop the chained counter support I guess it
> would make sense to have sh_perf_event_update() read and clear the
> counter so that you're always 0 based and then enforce an update from
> the arch tick hander so you never overflow.
> 
Yes, I'd thought about that too. I'll give it a go once I find out where
the other half of my registers disappeared to. As it is, it seems my bat
and I have an appointment to make.

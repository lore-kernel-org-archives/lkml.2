Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab0GBJwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:52:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0GBJwQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:52:16 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Fleming <matt@console-pimps.org>, Will Deacon <will.deacon@arm.com>,
       paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100702025716.GA25499@linux-sh.org>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
	 <1277477401.32034.670.camel@twins> <1277994970.1917.184.camel@laptop>
	 <1277996555.1917.205.camel@laptop>
	 <20100701153112.GA13511@console-pimps.org>
	 <1277998793.1917.212.camel@laptop>  <20100702025716.GA25499@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 11:52:03 +0200
Message-ID: <1278064323.1917.245.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-02 at 11:57 +0900, Paul Mundt wrote:
> At the moment it's not an issue since we have big enough counters that
> overflows don't really happen, especially if we're primarily using them
> for one-shot measuring.
> 
> SH-4A style counters behave in such a fashion that we have 2 general
> purpose counters, and 2 counters for measuring bus transactions. These
> bus counters can optionally be disabled and used in a chained mode to
> provide the general purpose counters a 64-bit counter (the actual
> validity in the upper half of the chained counter varies depending on the
> CPUs, but all of them can do at least 48-bits when chained). 

Right, so I was reading some of that code and I couldn't actually find
where you keep consistency between the hardware counter value and the
stored prev_count value.

That is, suppose I'm counting, the hardware starts at 0, hwc->prev_count
= 0 and event->count = 0.

At some point, x we context switch this task away, so we ->disable(),
which disables the counter and updates the values, so at that time
hwc->prev = x and event->count = x, right?

Now suppose we schedule the task back in, so we do ->enable(), then what
happens? sh_pmu_enable() finds an unused index, (disables it for some
reason.. it should already be cleared if its not used, but I guess a few
extra hardware writes dont hurt) and calls sh4a_pmu_enable() on it.

sh4a_pmu_enable() does 3 writes:

  PPC_PMCAT -- does this clear the counter value?
  PPC_CCBR  -- writes the ->config bits
  PPC_CCBR  (adds CCBR_DUC, couldn't this be done in the 
             previous write to this reg?)

Now assuming that enable does indeed clear the hardware counter value,
shouldn't you also set hwc->prev_count to 0 again? Otherwise the next
update will see a massive jump?

Alternatively you could write the hwc->prev_count value back to the
register.

If you eventually want to drop the chained counter support I guess it
would make sense to have sh_perf_event_update() read and clear the
counter so that you're always 0 based and then enforce an update from
the arch tick hander so you never overflow.



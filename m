Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0C3Sy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:54:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:40339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab0C3Syz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:54:55 -0400
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
 switch/migrate events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
In-Reply-To: <20100329224352.GC12254@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com>
	 <1269753066-17246-3-git-send-regression-fweisbec@gmail.com>
	 <1269852599.12097.159.camel@laptop> <20100329174723.GB5101@nowhere>
	 <1269885938.12097.367.camel@laptop>  <20100329224352.GC12254@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 20:54:52 +0200
Message-ID: <1269975292.5258.597.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-30 at 00:43 +0200, Frederic Weisbecker wrote:

> Actually I have doubts about what should be the strict sense
> of exclude_kernel.
> 
> Does that mean we exclude any event that happened in the kernel?
> Or does that mean we exclude the part that happened in the kernel?
> 
> Depending on the case, we do either.
> 
> In perf_swevent_hrtimer(), we simply go back to task_pt_regs()
> if exclude_kernel.
> 
> But in other software events, we don't such fix, we actually
> filter out the event if it is not user_mode().
> 
> So, I'm a bit confused on what to do.
> I'm tempted to adopt the meaning from perf_swevent_hrtimer()
> for software events too, I'm not sure...

Yes, that is indeed a good point. Problem is that perf_swevent_hrtimer()
is not quite correct either, since strictly speaking its timeline should
stop on the excluded region, but implementing that would make context
switches horribly expensive.

That said, the option that would be most correct is to simply not count
these events, and in that respect the current behaviour seems best.

Maybe we can make a new perf feature that would for each kernel event
(hw pmu included) report on the userspace state, would that be useful?



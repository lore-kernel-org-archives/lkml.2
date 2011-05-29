Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1E2KVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:21:32 -0400
Received: from service87.mimecast.com ([94.185.240.25]:59621 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750915Ab1E2KVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:21:31 -0400
Date: Sun, 29 May 2011 11:21:19 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Frank Rowand <frank.rowand@am.sony.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
Message-ID: <20110529102119.GC9489@e102109-lin.cambridge.arm.com>
References: <1306405979.1200.63.camel@twins>
 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
 <1306409575.1200.71.camel@twins>
 <1306412511.1200.90.camel@twins>
 <20110526122623.GA11875@elte.hu>
 <20110526123137.GG24876@n2100.arm.linux.org.uk>
 <20110526125007.GA27083@elte.hu>
 <BANLkTinUZ7EwN_nBCi_RQ9u8-LBcr_A74g@mail.gmail.com>
 <20110527120629.GA32617@elte.hu>
 <20110527205240.GT24876@n2100.arm.linux.org.uk>
MIME-Version: 1.0
In-Reply-To: <20110527205240.GT24876@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 29 May 2011 10:21:42.0008 (UTC) FILETIME=[34127780:01CC1DEA]
X-MC-Unique: 111052911212700201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 09:52:40PM +0100, Russell King - ARM Linux wrote:
> On Fri, May 27, 2011 at 02:06:29PM +0200, Ingo Molnar wrote:
> > The expectations are to have irqs off (we are holding the runqueue
> > lock if !__ARCH_WANT_INTERRUPTS_ON_CTXSW), so that's not workable i
> > suspect.
> 
> Just a thought, but we _might_ be able to avoid a lot of this hastle if
> we had a new arch hook in finish_task_switch(), after finish_lock_switch()
> returns but before the old MM is dropped.
...
> We could change switch_mm() to only do:
> 
> 1. flush branch predictor
> 2. set swapper_pg_dir tables
> 3. check ASID validity
> 4. set new ASID value

If we find that we ran out of ASIDs, we can't reset it across all the
other CPUs at this point as we have interrupts disabled. So here we
assume that we don't need to reset the ASIDs.

> At this point, we have no user mappings, and so nothing will be using the
> ASID at this point.  Then in a new post-finish_lock_switch() arch hook:
> 
> 5. check whether we need to do flushing as a result of ASID change
> 6. set new page tables

Can we actually not move points 1, 3 and 4 to the
post-finish_lock_switch() hook as well? We don't really care what's in
the ASID as long as we don't have any user mappings. The same goes for
the branch predictor (which may be wrongly placed already). This would
make the switch_mm() relatively simple and move the check_context() and
cpu_switch_mm() to the post-switch hook.

On A15, the ASID is part of TTBR0 so we set both of them at the same
time in the post-switch hook.

To avoid extra per-thread flags, we could set a per-cpu variable in
switch_mm() so that we know what to switch the page tables to in the
post-switch hook.

So I think this is feasible but it needs some intensive testing.

-- 
Catalin


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2EOL6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 07:58:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35130 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2EOL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 07:58:11 -0400
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        mou Chen <hi3766691@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, torvalds@linux-foundation.org
In-Reply-To: <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
	 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <CANQmPXj_81NBBrTYCkhUO1k1i4WVu0iHwY1_10wDVOFWCSkvsw@mail.gmail.com>
	 <CAKfTPtBhPpQyr1qugbMzq2nENh+zBT+zx_nWQpQ9NPbF=+ppcQ@mail.gmail.com>
	 <833A8DB8-1AB4-45E4-8D44-14A0D782807D@gmail.com>
	 <1337077714.27694.21.camel@twins>
	 <9093E8BA-80E4-4113-B036-0259E5FB44F1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 13:58:02 +0200
Message-ID: <1337083082.27020.151.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 14:35 +0300, Pantelis Antoniou wrote:
> 
> Throughput: MIPS(?), bogo-mips(?), some kind of performance counter?

Throughput is too generic a term to put a unit on. For some people its
tnx/s for others its frames/s neither are much (if at all) related to
MIPS (database tnx require lots of IO, video encoding likes FPU/SIMMD
stuff etc..).

> Latency: usecs(?)

nsec (chips are really really fast and only getting faster), but nsecs
of what :-) That is, which latency are we going to measure.

> Power: Now that's a tricky one, we can't measure power directly, it's a
> function of the cpu load we run in a period of time, along with any
> history of the cstates & pstates of that period. How can we collect
> information about that? Also we to take into account peripheral device
> power to that; GPUs are particularly power hungry. 

Intel provides some measure of CPU power drain on recent chips (iirc),
but yeah that doesn't include GPUs and other peripherals iirc.

> Thermal management: How to distribute load to the processors in such
> a way that the temperature of the die doesn't increase too much that
> we have to either go to a lower OPP or shut down the core all-together.
> This is in direct conflict with throughput since we'd have better performance 
> if we could keep the same warmed-up cpu going.

Core-hopping.. yay! We have the whole sensors framework that provides an
interface to such hardware, the question is, do chips have enough
sensors spread on them to be useful?

> Memory I/O: Some workloads are memory bandwidth hungry but do not need
> much CPU power. In the case of asymmetric cores it would make sense to move
> the memory bandwidth hog to a lower performance CPU without any impact. 
> Probably need to use some kind of performance counter for that; not going
> to be very generic. 

You're assuming the slower cores have the same memory bandwidth, isn't
that a dangerous assumption?

Anyway, so the 'problem' with using PMCs from within the scheduler is
that, 1) they're ass backwards slow on some chips (x86 anyone?) 2) some
userspace gets 'upset' if they can't get at all of them.

So it has to be optional at best, and I hate knobs :-) Also, the more
information you're going to feed this load-balancer thing, the harder
all that becomes, you don't want to do the full nm! m-dimensional bin
fit.. :-)




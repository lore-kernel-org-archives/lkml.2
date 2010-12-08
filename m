Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab0LHOoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:44:37 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47902 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0LHOog convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:44:36 -0500
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Venkatesh Pallipadi <venki@google.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20101208142814.GE9777@n2100.arm.linux.org.uk>
References: <19697.8378.717761.236202@pilspetsen.it.uu.se>
	 <19707.34405.791777.298955@pilspetsen.it.uu.se>
	 <20101205131702.GE9138@n2100.arm.linux.org.uk>
	 <20101205141921.GF9138@n2100.arm.linux.org.uk>
	 <19707.47304.977978.297596@pilspetsen.it.uu.se>
	 <20101205162151.GH9138@n2100.arm.linux.org.uk>
	 <1291812015.28378.24.camel@laptop>
	 <20101208125548.GA9777@n2100.arm.linux.org.uk>
	 <1291817076.28378.28.camel@laptop>
	 <20101208142814.GE9777@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 15:44:19 +0100
Message-ID: <1291819459.28378.64.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 14:28 +0000, Russell King - ARM Linux wrote:
> So, what I'm saying is that if wrapping in 4 seconds is a problem,
> then maybe we shouldn't be providing sched_clock() at all.

4 seconds should be perfectly fine, we call it at least every scheduler
tick (HZ) and NO_HZ will either have to limit the max sleep period or
provide its own sleep duration (using a more expensive clock) so we can
recover (much like GTOD already requires).

> Also, if wrapping below 64-bits is also a problem, again, maybe we
> shouldn't be providing it there either.  Eg:

That's mostly due to hysterical raisins and we should just fix that, the
simplest way is to use something like kernel/sched_clock.c to use
sched_clock() deltas to make a running u64 value.

Like said, John Stultz was already looking at doing something like that
because there's a number of architectures suffering this same problem
and they're all already using part of the clocksource infrastructure to
implement the sched_clock() interface simply because they only have a
single hardware resource.

One of the problems is I think the cycles2ns multiplication of the raw
clock, that makes dealing with wrap-around lots harder, so I guess we
should deal with the wrap on the raw clock values and then apply
cycles2ns on the delta or somesuch. But I expect the clocksource
infrastructure already has something like that, John?

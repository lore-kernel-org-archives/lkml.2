Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1GSWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:25:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40601 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1GSWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:25:55 -0400
Subject: Re: [PATCH 1/2] sched: Fix "divide error: 0000" in
 find_busiest_group
From: Peter Zijlstra <peterz@infradead.org>
To: Terry Loftin <terry.loftin@hp.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Bob Montgomery <bob.montgomery@hp.com>
In-Reply-To: <4E26032D.3070006@hp.com>
References: <4E25F006.2010205@hp.com> <1311110224.2617.1.camel@laptop>
	 <4E26032D.3070006@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jul 2011 00:30:21 +0200
Message-ID: <1311114621.2617.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 16:20 -0600, Terry Loftin wrote:
> On 07/19/2011 03:17 PM, Peter Zijlstra wrote:
> > On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
> >> Correct the protection expression in update_cpu_power() to avoid setting
> >> rq->cpu_power to zero.
> > 
> > Firstly you fail to mention what kernel this is again, secondly this
> > should never happen in the first place, so this fix is wrong. At best it
> > papers over another bug.
> 
> My Apologies, this was found on kernel 2.6.32.32, but the all
> the related code is the same in v3.0-rc7.  The patch is against
> v3.0-rc7.  I've done some limited testing of this on 2.6.32.32
> by modifying __cycles_2_ns() to add an offset to the TSC when
> it is read to simulate 208 days of uptime, but that kernel has
> only been running for a couple days.
> 
> I also agree this should never happen.  As the statement currently
> stands, it won't work - so it should either be corrected or removed.
> Here is the alternative patch:
> 

> -	if (!power)
> -		power = 1;

IIRC it can actually end up being 0 if the scale factors are small
enough, but what I couldn't see happening is how it can be > 2^32, which
is required for your initial patch to make a difference.

In that case the scale factors were _way_ out of bound, they're supposed
to be [0,SCHED_POWER_SCALE] and since we divide by SCHED_POWER_SCALE
after every factor the result should remain in that range.

Now clearly you've found that going haywire, so we need to find where
and why that happens and cure that.


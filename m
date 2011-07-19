Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab1GSWUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:20:19 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:1363 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab1GSWUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:20:18 -0400
Message-ID: <4E26032D.3070006@hp.com>
Date: Tue, 19 Jul 2011 16:20:29 -0600
From: Terry Loftin <terry.loftin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Bob Montgomery <bob.montgomery@hp.com>
Subject: Re: [PATCH 1/2] sched: Fix "divide error: 0000" in find_busiest_group
References: <4E25F006.2010205@hp.com> <1311110224.2617.1.camel@laptop>
In-Reply-To: <1311110224.2617.1.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2011 03:17 PM, Peter Zijlstra wrote:
> On Tue, 2011-07-19 at 14:58 -0600, Terry Loftin wrote:
>> Correct the protection expression in update_cpu_power() to avoid setting
>> rq->cpu_power to zero.
> 
> Firstly you fail to mention what kernel this is again, secondly this
> should never happen in the first place, so this fix is wrong. At best it
> papers over another bug.

My Apologies, this was found on kernel 2.6.32.32, but the all
the related code is the same in v3.0-rc7.  The patch is against
v3.0-rc7.  I've done some limited testing of this on 2.6.32.32
by modifying __cycles_2_ns() to add an offset to the TSC when
it is read to simulate 208 days of uptime, but that kernel has
only been running for a couple days.

I also agree this should never happen.  As the statement currently
stands, it won't work - so it should either be corrected or removed.
Here is the alternative patch:

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c26e2d..f9c9a89 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2549,9 +2549,6 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	power *= scale_rt_power(cpu);
 	power >>= SCHED_LOAD_SHIFT;

-	if (!power)
-		power = 1;
-
 	cpu_rq(cpu)->cpu_power = power;
 	sdg->cpu_power = power;
 }

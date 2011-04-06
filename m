Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab1DFL0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:26:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab1DFL0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:26:37 -0400
Subject: Re: [patch 13/15] sched: expire slack quota using generation
 counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <BANLkTimOP_EtyxEZ9pOEpgJPqEEic21eCA@mail.gmail.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.941304760@google.com> <1302010089.2225.1313.camel@twins>
	 <BANLkTimOP_EtyxEZ9pOEpgJPqEEic21eCA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 06 Apr 2011 13:26:21 +0200
Message-ID: <1302089181.2225.1380.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-06 at 00:22 -0700, Paul Turner wrote:
> 
> scratches head... erm right, I meant to pair this with a read barrier
> on querying the generation but balked when I realized that still
> yields an lfence on x86 since I didn't want to introduce that to the
> update_curr() path.
> 
> While we can probably do away with the barrier completely (it's not
> critical that we line them up perfectly with the new generation), I've
> been thinking about this one and I think I have something a little
> nicer that also reduces the shared cache hits.
> 
> We can take advantage of the fact that sched_clocks are already
> synchronized within 2 jiffies and store the quota's expiration,
> instead of a generation, when we refresh.
> 
> This effectively yields a fairly simple control flow (we can use
> rq->clock since we're always paired with update_rq_clock operations):
> a) our rq->clock < expiration always implies quota is valid
> 
> Obviously if our cpu clock is ahead of the one that issued the quota,
> our quota is still valid since the real deadline is even further
> behind
> Even if our cpu's clock is behind the max 1.99 jiffies the amount of
> time that the stale quota can remain valid is basically already within
> our potential margin of error since for a long running process we
> check on each tick edge anyway.
> 
>  b) our rq->clock > expiration
> 
> Again there's two cases, if our cpu clock is behind (or equal) then
> the deadline has indeed passed and the quota is expired.  This can be
> confirmed by comparing the global deadline with our local one (the
> global expiration will have advanced with quota refresh for this to be
> true).
> 
> We can also catch that our cpu is potentially ahead -- by the fact
> that our rq->clock > expiration but that the global expiration has not
> yet advanced.  In this case we recognize that our quota is still valid
> and extend our local expiration time by either the maximum margin of
> error or some fraction there of (say 1 jiffy) which is guaranteed to
> push us back in case a) above.  Again this is within our existing
> margin of error due to entity_tick() alignment.
> 
> This ends up looking a lot simpler and avoids much of the pressure on
> the global variable since we need to compare against it in the case
> where our clock passes expiration, once a quota period (as the
> extension will put us in case a where we know we don't need to
> consider it).
> 
> This ends up simpler than the generation muck and can be introduced
> cleanly earlier in the series, avoiding the churn mentioned above.
> 
> Make sense? 

Yes, that ought to work.

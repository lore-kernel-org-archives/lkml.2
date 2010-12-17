Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0LQMj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:39:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:36179 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0LQMj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:39:26 -0500
Subject: Re: [patch 2/2] sched: charge unaccounted run-time on entity
 re-weight
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <AANLkTi=h9vZm4nTnwq7+CeQjFpVV2QaovUP8KOi-gcXy@mail.gmail.com>
References: <20101216031016.186364650@google.com>
	 <20101216031038.159704378@google.com> <1292497424.6803.4573.camel@twins>
	 <AANLkTi=h9vZm4nTnwq7+CeQjFpVV2QaovUP8KOi-gcXy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 13:38:54 +0100
Message-ID: <1292589534.2266.182.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 14:31 -0800, Paul Turner wrote:

> That doesn't quite work.
> 
> The problem stems from:
> 
> - update_curr() accues time against current cfs_rq's timeline
>   - We always need to do this for entity placement
>   - Manipulation of the current cfs_rq's load affects its weights

> However the current cfs_rq in the problem case is a group entity which
> happens to be the current entity on the parenting se's group_cfs_rq
> (say that 10 times fast).
> 
> When we update that entity's (call it X) weight to reflect the
> interactions on its owned cfs_rq, the update isout of order with the
> subsequent update_curr() on the parent which is what actually accounts
> the accrued vruntime versus X (which was accumulated at old weight)
> 
> We need to either:
> 
> A) Get all of the update_currs() done up front, e.g. at the start of
> enqueue_task_fair add another for_each
> - I don't like this approach because it it becomes a concern that has
> to be implemented by all callers
> - There's also no point in issuing these if the entity in question
> isnt cfs_rq->curr since there's no time to account in that case
> 
> B) Change the reweights in enqueue/dequeue/etc to occur against the
> owned cfs_rq as opposed to the queueing cfs_rq.
> - This is not really clean in my mind since it steps outside of the
> semantic of we are "enqueuing E to T".  Instead of only really
> manipulating T we're adding "oh and we'll finish manipulations
> resulting from prior enqeues against E if it was a tree".

I knew there was a reason I did it like that early on ;-)

> C) Charge unaccounted time versus an entity before re-weighting it
> - I think this ends up being the nicest, we only end up issuing the
> extra update_currs when we need them, and the second becomes a nop
> since rq->clock doesn't move.  Not to mention it also blocks up this
> hole completely since it becomes always safe to reweight_entity().

Hrmm, I see what you mean, its not exactly pretty either, but I must
admit to not seeing a better solution at the moment.

OK, so your patch it is ;-)

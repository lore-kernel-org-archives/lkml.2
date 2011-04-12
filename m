Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1DLPPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:15:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34179 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756080Ab1DLPPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 11:15:21 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110412051512.GL9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <20110412051512.GL9673@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 10:15:18 -0500
Message-ID: <1302621318.2604.19.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-12 at 14:15 +0900, Tejun Heo wrote:
> > A fix might be to shunt more stuff off to workqueues, but that's
> > producing a more complex system which would be prone to entanglements
> > that would be even harder to spot.
> 
> I don't agree there.  To me, the cause for entanglement seems to be
> request_fn calling all the way through blocking destruction because it
> detected that the final put was called with sleepable context.  It's
> just weird and difficult to anticipate to directly call into sleepable
> destruction path from request_fn whether it had sleepable context or
> not.  With the yet-to-be-debugged bug caused by the conversion aside,
> I think simply using workqueue is the better solution.

So your idea is that all final puts should go through a workqueue?  Like
I said, that would work, but it's not just SCSI ... any call path that
destroys a queue has to be audited.

The problem is nothing to do with sleeping context ... it's that any
work called by the block workqueue can't destroy that queue.  In a
refcounted model, that's a bit nasty.

> > Perhaps a better solution is just not to use sync cancellations in
> > block?  As long as the work in the queue holds a queue ref, they can be
> > done asynchronously.
> 
> Hmmm... maybe but at least I prefer doing explicit shutdown/draining
> on destruction even if the base data structure is refcounted.  Things
> become much more predictable that way.

It is pretty much instantaneous.  Unless we're executing, we cancel the
work.  If the work is already running, we just let it complete instead
of waiting for it.

Synchronous waits are dangerous because they cause entanglement.

James



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1DMOP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:15:28 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55529 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab1DMOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:15:27 -0400
Subject: Re: Strange block/scsi/workqueue issue
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <20110413051139.GC24161@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
	 <20110411171803.GG9673@mtj.dyndns.org>
	 <1302569276.2558.9.camel@mulgrave.site>
	 <20110412025145.GJ9673@mtj.dyndns.org>
	 <1302583757.2558.21.camel@mulgrave.site>
	 <20110412051512.GL9673@mtj.dyndns.org>
	 <1302621318.2604.19.camel@mulgrave.site>
	 <20110413051139.GC24161@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 09:15:22 -0500
Message-ID: <1302704122.2597.13.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 14:11 +0900, Tejun Heo wrote:
> > > Hmmm... maybe but at least I prefer doing explicit shutdown/draining
> > > on destruction even if the base data structure is refcounted.  Things
> > > become much more predictable that way.
> > 
> > It is pretty much instantaneous.  Unless we're executing, we cancel the
> > work.  If the work is already running, we just let it complete instead
> > of waiting for it.
> > 
> > Synchronous waits are dangerous because they cause entanglement.
> 
> There are two different types of dangers involved.  One is of getting
> trapped into deadlock by recursing and ending up waiting for oneself.
> The other of continuing operation on objects which could be in dubious
> state.  I guess my point is that I prefer the former by a large
> margin.
> 
> The deadlocks are more reliable in reproducibility.  Lockdep and soft
> hang check can detect them easily and a single stack dump will point
> us right to where the problem is.  The latter is much trickier.

I agree, but this is a bit of a false dichotomy.  The hang will only
detect the thread waiting on itself.  Even in the flush model, we still
have to detect inappropriate object use because others may still have
references.

So, in the sync model, on blk_cleanup_queue() you flush the pending
requests and destroy the elevator.  However, because the queue is
refcounted, you still have to cope with the case where one of the
reference holders submits more I/O or does anything else with the queue.
This is what I don't like about the sync then shut down various bits
before the refcount goes to zero.  Now we don't have a fully functional
queue so we need state guards on all the entry points to detect this and
error out (that's some of the QUEUE_FLAG_DEAD checks we put in in the
patch).

In the async model, you can either do as above (state guards on the
entry points) and impose a shutting down state, or you can delay
destruction until final put.  The former is an identical solution to the
synchronous one, except that you don't have the flush.  The latter loses
the state guard on entry points requirements (because the queue is
always fully functional until final put.

>   The
> problem is more difficult to trigger and even when it triggers the
> effect often wouldn't be obvious.  Auditing for correctness is more
> difficult too - which fields are safe to access post-mortem? 

But in a refcounted model you always have to expect postmortem
operations ... you just have to make sure they're properly rejected.
This is true for both sync or async if you impose a dying or dead state
on the model.

>  Is there
> any chance that the ongoing operation might reach out to hardware
> which is already gone or claimed by another software entity?

Yes ... in fact SCSI fully expects this ... that's why they dead queue
check in the SCSI request function using a NULL ->queuedata signal
(another thing that wasn't working quite right).

We tear down the device in scsi_remove_device() including destroying the
queue.  If we go with the sync model for block, I'd actually move
blk_cleanup_queue() into that function.  There's no real point delaying
queue destruction to final put of the SCSI object, since we won't accept
I/O after scsi_remove_device() returns.

> In this particular case, IMHO it's reasonable for block layer to
> require that the destruction function not to be called directly from
> request queue path although it definitely could have used better
> documentation.

I think we've both stated our cases, so it's time for Jens to decide
what he wants to do.  Given that block already has a state model which
includes some QUEUE_FLAG_DEAD state guard checks, it probably makes
sense to enhance that, rather than to delay all destruction until final
put.

James



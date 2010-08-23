Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0HWVvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:51:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46288 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754117Ab0HWVve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:51:34 -0400
Date: Mon, 23 Aug 2010 17:51:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
In-Reply-To: <4C72D1BD.4060503@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1008231716430.1601-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Jens Axboe wrote:

> On 08/23/2010 09:17 PM, Alan Stern wrote:
> > Jens:
> > 
> > I want to implement runtime power management for the SCSI sd driver.  
> > The idea is that the device should automatically be suspended after a
> > certain amount of time spent idle.
> > 
> > The basic outline is simple enough.  If the device is in low power when
> > a request arrives, delay handling the request until the device can be
> > brought back to high power.  When a request completes and the request
> > queue is empty, schedule a runtime-suspend for the appropriate time in
> > the future.
> 
> So if it's in low power mode, you need to defer because you want to
> issue some special request first to bring it back to life?

Exactly.  And also because if the device is in low-power mode then its 
parent might be in low-power too, meaning that we would have to wait 
for both the parent and the device to return to full power before 
sending the request.

The PM framework is set up so that power-state changes are always done
in process context -- meaning in this case that a workqueue would be
needed.  The PM core has a special workqueue for just this purpose.  
But obviously a prep function can't sit around and wait for the work to 
get done.

> > The difficulty is that I don't know the right way these things should
> > interact with the request-queue management.  A request can be deferred
> > by making the prep_req_fn return BLKPREP_DEFER, right?  But then what
> 
> Right, that is used for resource starvation. So usually very short
> conditions.
> 
> > happens to the request and to the queue?  How does the runtime-resume
> > routine tell the block layer that the deferred request should be
> > restarted?
> 
> Internally, it uses the block queue plugging to set a timer to defer a
> bit. That's purely implementation detail and it will change in the
> not-so-distant future if I kill the per-queue plugging. The effect will
> still be the same though, the action will be automatically retried after
> some defined interval.

Hmm.  That doesn't sound quite like what I need.  Ideally the request
would go back to the head of the queue and stay there until the driver
tells the block layer to let it through (when the device is ready to 
accept it).

> > How does this all relate to the queue being stopped or plugged?
> 
> A stopped queue is usually the driver telling the block layer to bugger
> off for a while, and the driver will tell us when it's ok to resume
> operations.

Yes, that sounds more like it.  Put the request back on the queue 
and stop the queue.  If the prep fn calls blk_stop_queue() and then 
returns BLKPREP_DEFER, will that do it?

>  So we can't control that part. Plugging we can control. But

I probably didn't make it clear in the earlier message: The changes
to implement all this PM stuff will go in the driver, with nothing (or
almost nothing) changed in the block layer.  Hence stopping the queue
_is_ under my control.

Unless you think it would be better to change the block layer 
instead...

> if the device is plugged, the driver is idle _and_ we have IO pending.
> So you would not be entering a lower power mode at that point, and the
> driver should already be in an operationel state; when it got plugged,
> we should have issued the special req to send it into live mode.

Plugging doesn't seem like the right mechanism for this.

> > Another thing: The runtime-resume routine needs to send its own
> > commands to the device (to spin up a drive, for example).  These
> > commands must be sent before anything on the request queue, and they
> > must be handled right away even though the normal requests on the queue
> > are still deferred.
> 
> We can flag those requests as being of some category that is allowed to
> bypass the sleep state of the device. Handling right away can be
> accomplished by just inserting at the front and having that flag set.

Okay, good.  But if the queue is stopped when the requests are
inserted at the front (with the flag set), will they be allowed to go 
through to the driver?  In other words, is there a way to force certain 
requests to be processed even while the queue is stopped?

> > What's the right way to do all this?
> 
> It needs to be done carefully. A queue can go in and out of idle/busy
> state extremely fast. I did quite a few tricks on the queue timeout
> handling to ensure that it didn't have much overhead on a per-rq basis.
> So we could probably add an idle timer that is set to some suitable
> timeout for this and would be added when the queue first goes empty. If
> new requests come in, just let it simmer and defer checking the state to
> when it actually fires. If nothing has happened, issue a new
> q->power_mode(new_state) callback that would then queue a suitable
> request to change the power state of the device. Queueing a new request
> could check the state and issue a q->power_mode(RUNNING) or similar call
> to bring things back to life.
> 
> Just a few ideas...

The idle-time management can be handled in a couple of different ways,
and the PM core already contains routines to do it.  I'm not worried
about that (I have a very clear understanding of the PM core).  The 
interactions with the block layer are where I need help.

Speaking of which...  What is this q->power_mode stuff?  I haven't run
across it before and it doesn't seem to be mentioned in
include/linux/blkdev.h.  Is it connected with request_pm_state?  I
don't know what that is either, or how it is meant to be used.

Alan Stern


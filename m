Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0HWTxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 15:53:38 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37045 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0HWTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 15:53:35 -0400
Message-ID: <4C72D1BD.4060503@kernel.dk>
Date: Mon, 23 Aug 2010 21:53:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
References: <Pine.LNX.4.44L0.1008231501390.1601-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1008231501390.1601-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2010 09:17 PM, Alan Stern wrote:
> Jens:
> 
> I want to implement runtime power management for the SCSI sd driver.  
> The idea is that the device should automatically be suspended after a
> certain amount of time spent idle.
> 
> The basic outline is simple enough.  If the device is in low power when
> a request arrives, delay handling the request until the device can be
> brought back to high power.  When a request completes and the request
> queue is empty, schedule a runtime-suspend for the appropriate time in
> the future.

So if it's in low power mode, you need to defer because you want to
issue some special request first to bring it back to life?

> The difficulty is that I don't know the right way these things should
> interact with the request-queue management.  A request can be deferred
> by making the prep_req_fn return BLKPREP_DEFER, right?  But then what

Right, that is used for resource starvation. So usually very short
conditions.

> happens to the request and to the queue?  How does the runtime-resume
> routine tell the block layer that the deferred request should be
> restarted?

Internally, it uses the block queue plugging to set a timer to defer a
bit. That's purely implementation detail and it will change in the
not-so-distant future if I kill the per-queue plugging. The effect will
still be the same though, the action will be automatically retried after
some defined interval.

> How does this all relate to the queue being stopped or plugged?

A stopped queue is usually the driver telling the block layer to bugger
off for a while, and the driver will tell us when it's ok to resume
operations. So we can't control that part. Plugging we can control. But
if the device is plugged, the driver is idle _and_ we have IO pending.
So you would not be entering a lower power mode at that point, and the
driver should already be in an operationel state; when it got plugged,
we should have issued the special req to send it into live mode.

> Another thing: The runtime-resume routine needs to send its own
> commands to the device (to spin up a drive, for example).  These
> commands must be sent before anything on the request queue, and they
> must be handled right away even though the normal requests on the queue
> are still deferred.

We can flag those requests as being of some category that is allowed to
bypass the sleep state of the device. Handling right away can be
accomplished by just inserting at the front and having that flag set.

> What's the right way to do all this?

It needs to be done carefully. A queue can go in and out of idle/busy
state extremely fast. I did quite a few tricks on the queue timeout
handling to ensure that it didn't have much overhead on a per-rq basis.
So we could probably add an idle timer that is set to some suitable
timeout for this and would be added when the queue first goes empty. If
new requests come in, just let it simmer and defer checking the state to
when it actually fires. If nothing has happened, issue a new
q->power_mode(new_state) callback that would then queue a suitable
request to change the power state of the device. Queueing a new request
could check the state and issue a q->power_mode(RUNNING) or similar call
to bring things back to life.

Just a few ideas...

-- 
Jens Axboe


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0HXNiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:38:11 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42903 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0HXNiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:38:09 -0400
Message-ID: <4C73CB53.9030506@kernel.dk>
Date: Tue, 24 Aug 2010 15:38:27 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
References: <Pine.LNX.4.44L0.1008231716430.1601-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1008231716430.1601-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-23 23:51, Alan Stern wrote:
>>> happens to the request and to the queue?  How does the runtime-resume
>>> routine tell the block layer that the deferred request should be
>>> restarted?
>>
>> Internally, it uses the block queue plugging to set a timer to defer a
>> bit. That's purely implementation detail and it will change in the
>> not-so-distant future if I kill the per-queue plugging. The effect will
>> still be the same though, the action will be automatically retried after
>> some defined interval.
> 
> Hmm.  That doesn't sound quite like what I need.  Ideally the request
> would go back to the head of the queue and stay there until the driver
> tells the block layer to let it through (when the device is ready to 
> accept it).

It depends on where you want to handle it. If you want the driver to
reject it, then we don't have to change the block layer bits a lot. We
could add a DEFER_AND_STOP or something, which would never retry and it
would stop the queue. If the driver passed that back, then it would be
responsible for starting the queue at some point in the future.

>>> How does this all relate to the queue being stopped or plugged?
>>
>> A stopped queue is usually the driver telling the block layer to bugger
>> off for a while, and the driver will tell us when it's ok to resume
>> operations.
> 
> Yes, that sounds more like it.  Put the request back on the queue 
> and stop the queue.  If the prep fn calls blk_stop_queue() and then 
> returns BLKPREP_DEFER, will that do it?

I think it will be a lot cleaner to add specific support for this, as
per the DEFER_AND_STOP above.

>>  So we can't control that part. Plugging we can control. But
> 
> I probably didn't make it clear in the earlier message: The changes
> to implement all this PM stuff will go in the driver, with nothing (or
> almost nothing) changed in the block layer.  Hence stopping the queue
> _is_ under my control.
> 
> Unless you think it would be better to change the block layer 
> instead...

Doing it in the driver is fine. We can always make things more generic
and share them across drivers if there's sharing to be had there.

It also means we don't need special request types that are allowed to
bypass certain queue states, since the driver will track the state and
know what to defer and what to pass through.

>> It needs to be done carefully. A queue can go in and out of idle/busy
>> state extremely fast. I did quite a few tricks on the queue timeout
>> handling to ensure that it didn't have much overhead on a per-rq basis.
>> So we could probably add an idle timer that is set to some suitable
>> timeout for this and would be added when the queue first goes empty. If
>> new requests come in, just let it simmer and defer checking the state to
>> when it actually fires. If nothing has happened, issue a new
>> q->power_mode(new_state) callback that would then queue a suitable
>> request to change the power state of the device. Queueing a new request
>> could check the state and issue a q->power_mode(RUNNING) or similar call
>> to bring things back to life.
>>
>> Just a few ideas...
> 
> The idle-time management can be handled in a couple of different ways,
> and the PM core already contains routines to do it.  I'm not worried
> about that (I have a very clear understanding of the PM core).  The 
> interactions with the block layer are where I need help.
> 
> Speaking of which...  What is this q->power_mode stuff?  I haven't run
> across it before and it doesn't seem to be mentioned in
> include/linux/blkdev.h.  Is it connected with request_pm_state?  I
> don't know what that is either, or how it is meant to be used.

->power_mode() was just a suggested way to implement this, it doesn't
exist. But if you want to push it to the driver, then great, less work
for me :-)

Sounds like all you need is a way to return BLKPREP_DEFER_AND_STOP and
have the block layer stop the queue for you. When you need to restart,
you would insert a special request at the head of the queue and call
blk_start_queue() to get things going again.

The only missing bit would then be the idle detection. That would need
to be in the block layer itself, and the scheme I described should be
fine for that still.

-- 
Jens Axboe


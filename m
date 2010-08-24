Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0HXOma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:42:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43844 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752382Ab0HXOm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:42:27 -0400
Date: Tue, 24 Aug 2010 10:42:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
In-Reply-To: <4C73CB53.9030506@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1008241030340.1652-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Jens Axboe wrote:

> > Hmm.  That doesn't sound quite like what I need.  Ideally the request
> > would go back to the head of the queue and stay there until the driver
> > tells the block layer to let it through (when the device is ready to 
> > accept it).
> 
> It depends on where you want to handle it. If you want the driver to
> reject it, then we don't have to change the block layer bits a lot. We
> could add a DEFER_AND_STOP or something, which would never retry and it
> would stop the queue. If the driver passed that back, then it would be
> responsible for starting the queue at some point in the future.
> 
> >>> How does this all relate to the queue being stopped or plugged?
> >>
> >> A stopped queue is usually the driver telling the block layer to bugger
> >> off for a while, and the driver will tell us when it's ok to resume
> >> operations.
> > 
> > Yes, that sounds more like it.  Put the request back on the queue 
> > and stop the queue.  If the prep fn calls blk_stop_queue() and then 
> > returns BLKPREP_DEFER, will that do it?
> 
> I think it will be a lot cleaner to add specific support for this, as
> per the DEFER_AND_STOP above.

Okay, good.  I'll try to implement that and see how it goes.

> Sounds like all you need is a way to return BLKPREP_DEFER_AND_STOP and
> have the block layer stop the queue for you. When you need to restart,
> you would insert a special request at the head of the queue and call
> blk_start_queue() to get things going again.

Yes.

Suppose the driver needs to send two of these special requests before
going back to normal operation.  Won't restarting the queue for the
first special request also cause the following regular request to be
passed to the driver before the second special request can be inserted?  
Of course, the driver could cope with this simply by returning another
BLKPREP_DEFER_AND_STOP.

> The only missing bit would then be the idle detection. That would need
> to be in the block layer itself, and the scheme I described should be
> fine for that still.

Are you sure it needs to be in the block layer?  Is there no way for 
the driver's completion handler to tell whether the queue is now empty?  
Certainly it already has enough information to know whether the device 
is still busy processing another request.  When the device is no longer 
busy and the queue is empty, that's when the idle timer should be 
started or restarted.

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0H3QcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 12:32:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:32844 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754676Ab0H3QcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 12:32:12 -0400
Date: Mon, 30 Aug 2010 12:32:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
In-Reply-To: <4C73CB53.9030506@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1008301147140.1571-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Jens Axboe wrote:

> > Unless you think it would be better to change the block layer 
> > instead...
> 
> Doing it in the driver is fine. We can always make things more generic
> and share them across drivers if there's sharing to be had there.

After giving this some thought, I have decided that it would be best to
implement much of this in the block layer.  It's a simpler approach and
it offers greater generality.

The changes would be fairly small.  Two additional fields will be added
to struct request_queue: a PM status (active, suspending, suspended,
resuming) and a pointer to the queue's struct device (for carrying out
PM operations).  Actually I'm a little surprised there isn't already a
pointer to the struct device; it seems like a very natural thing to 
have.

There also will be four new functions for drivers/subsystems to call at
the beginning and end of their suspend and resume routines.

> It also means we don't need special request types that are allowed to
> bypass certain queue states, since the driver will track the state and
> know what to defer and what to pass through.

It turns out there already are a couple of special request types for
this: REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME.  It's not clear why
two different types are needed, but blk_execute_rq_nowait() contains a 
clue:

	/* the queue is stopped so it won't be plugged+unplugged */
	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
		q->request_fn(q);

The purpose for this is unclear.  It seems to have been added
specifically for the IDE driver, which is the only driver using these
request types.  (In fact, the entire request_pm_state structure also
isn't used anywhere else -- which indicates that it should be defined
in a private header for IDE alone instead of in blkdev.h.)  Maybe it
won't be needed after these changes.

My idea is that a queue shouldn't need to be explicitly stopped when
its device is suspended.  Instead, blk_peek_request() can check the
queue state and simply return NULL if the queue is suspending,
suspended, or resuming and the request type isn't REQ_TYPE_PM_SUSPEND
or _RESUME.  That should work, since blk_peek_request() is the only
path for moving requests from the queue to the driver, right?

> The only missing bit would then be the idle detection. That would need
> to be in the block layer itself, and the scheme I described should be
> fine for that still.

This is where I will need help.  From what I gather, a request's path
through the block layer starts at __elv_add_request() and ends at
blk_finish_request().  Updating a counter at these points should be
good enough -- except for elv_merge() and possibly other things I don't
know about.  Not to mention any changes you may be planning.

Basically I just need to call some new routines when a request is first
added to an idle queue and when a queue becomes idle because the last
request has completed.  Can you suggest the best way to do this?

Alan Stern


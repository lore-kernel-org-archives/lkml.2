Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab0I0PWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:22:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41884 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755783Ab0I0PWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:22:13 -0400
Date: Mon, 27 Sep 2010 11:22:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
In-Reply-To: <4C73FCBE.7020305@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1009271117000.1751-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Jens Axboe wrote:

> > Are you sure it needs to be in the block layer?  Is there no way for 
> > the driver's completion handler to tell whether the queue is now empty?  
> > Certainly it already has enough information to know whether the device 
> > is still busy processing another request.  When the device is no longer 
> > busy and the queue is empty, that's when the idle timer should be 
> > started or restarted.
> 
> To some extent there is, but there can be context outside of the queue
> it doesn't know about. That is the case for the plugging rework, for
> instance. That also removes the queue_empty() call. Then there's
> blk_fetch_request(), but that may return NULL while there's IO pending
> in the block layer - so not reliable for that either. The block layer is
> tracking this state anyway, if you are leaving it to the driver then it
> would have to check everytime it completes the last request it has. It's
> cheaper to do in the block layer.

I'm going to take your advice.  To make this work, I need to know when 
the number of pending requests increases from 0 and when it drops to 0.

The most direct approach is to keep a count of the number of pending
requests for each request_queue.  As far as I can tell, a request
enters the system in elv_insert(), so that's where the count should be
incremented (except in the ELEVATOR_INSERT_REQUEUE case).  And a
request leaves the system in blk_finish_request(), so that's where the
count should be decremented.

Am I missing anything?  What about elv_merge_requests()?

Alan Stern


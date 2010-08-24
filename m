Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0HXRI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:08:58 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43247 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab0HXRI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:08:57 -0400
Message-ID: <4C73FCBE.7020305@kernel.dk>
Date: Tue, 24 Aug 2010 19:09:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Runtime PM and the block layer
References: <Pine.LNX.4.44L0.1008241030340.1652-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1008241030340.1652-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-24 16:42, Alan Stern wrote:
>> Sounds like all you need is a way to return BLKPREP_DEFER_AND_STOP and
>> have the block layer stop the queue for you. When you need to restart,
>> you would insert a special request at the head of the queue and call
>> blk_start_queue() to get things going again.
> 
> Yes.
> 
> Suppose the driver needs to send two of these special requests before
> going back to normal operation.  Won't restarting the queue for the
> first special request also cause the following regular request to be
> passed to the driver before the second special request can be inserted?  
> Of course, the driver could cope with this simply by returning another
> BLKPREP_DEFER_AND_STOP.

For that special request, you are sure to have some ->end_io() hook to
know when it's complete. When that triggers, you queue the 2nd special
request. And so on, for how many you need.

>> The only missing bit would then be the idle detection. That would need
>> to be in the block layer itself, and the scheme I described should be
>> fine for that still.
> 
> Are you sure it needs to be in the block layer?  Is there no way for 
> the driver's completion handler to tell whether the queue is now empty?  
> Certainly it already has enough information to know whether the device 
> is still busy processing another request.  When the device is no longer 
> busy and the queue is empty, that's when the idle timer should be 
> started or restarted.

To some extent there is, but there can be context outside of the queue
it doesn't know about. That is the case for the plugging rework, for
instance. That also removes the queue_empty() call. Then there's
blk_fetch_request(), but that may return NULL while there's IO pending
in the block layer - so not reliable for that either. The block layer is
tracking this state anyway, if you are leaving it to the driver then it
would have to check everytime it completes the last request it has. It's
cheaper to do in the block layer.

-- 
Jens Axboe


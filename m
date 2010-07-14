Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab0GNGGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:06:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58656 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0GNGGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:06:08 -0400
Message-ID: <4C3D53AF.1060100@kernel.dk>
Date: Wed, 14 Jul 2010 08:05:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH|RFC] deadline: don't allow aliased requests to starve
 others
References: <x49mxtvpg6s.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49mxtvpg6s.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:14 PM, Jeff Moyer wrote:
> Hi,
> 
> In running a test case that tries to trip up the kernel's AIO
> implementation, we ran into a situation where no other I/O to the device
> under test would be completed.  The test program spawned (in this case)
> 100 threads, each of which performed the following in a loop:
> 
> open file O_DIRECT
> queue 1MB of read I/O from file using 16 iocbs
> close file
> repeat
> 
> The program does NOT wait for the I/O to complete.  The file length is
> only 4MB, meaning that you have 25 threads performing I/O on each of the
> 4 1MB regions.
> 
> Both deadline and cfq check for aliased requests in the sorted list of
> I/Os, and when an alias is found, the request in the rb tree is moved to
> the dispatch list.  So, what happens is that, with this workload, only
> requests from this program are moved to the dispatch list, starving out
> all other I/O.
> 
> I've attached a patch that fixes this using one approach.  The patch
> just implements a counter for aliased requests served in sequence, and
> dispatches from the fifo once the number of aliased requests serviced
> exceeds a certain value.  What that value should be set to is difficult
> to determine.  This should be a rare case, and you don't really want to
> go outside of the normal scheduling mechanism for I/Os.  So, there is a
> balance to be struck between dispatching requests in the alised request
> code path and allowing this starvation to go on, hoping it is a
> temporary situation (but ensuring progress).
> 
> Another approach I've implemented gets rid of the counter, and simply
> checks the fifo when dispatching an aliased request.
> 
> Jens, let me know which approach is more palatable and I'll spin up the
> appropriate patch for CFQ.

How about just skipping the counter, and always checking the fifo if
we have served one alias? I would prefer that, no need to make it
more complex than we have to.

It's one of those things that you think of when adding the alias
support, but don't envision every causing any issues in the real
world. But lets fix it, it definitely can happen as you demonstrated.

-- 
Jens Axboe


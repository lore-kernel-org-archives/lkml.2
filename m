Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab1JSRGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:06:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65051 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1JSRG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:06:29 -0400
Date: Wed, 19 Oct 2011 10:06:25 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 07/10] block: reorganize throtl_get_tg() and
 blk_throtl_bio()
Message-ID: <20111019170625.GD25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-8-git-send-email-tj@kernel.org>
 <20111019145622.GE1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019145622.GE1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 10:56:22AM -0400, Vivek Goyal wrote:
> A driver could call blk_cleanup_queue(), mark the queue DEAD and then
> free the driver provided spin lock. So once queue is DEAD one could
> not rely on queue lock still being there. That's the reason I did
> not try to take queue lock again if queue is marked DEAD.
>
> Now I see the change that blk_cleanup_queue will start poiting to
> internal queue lock (Thought it is racy). This will atleast make
> sure that some spinlock is around. So now this change should be
> fine.

The problem with the current code is that all those are not properly
synchronized.  Drivers shouldn't destroy lock or any other stuff until
blk_cleanup_queue() is complete and once queue cleanup is done block
layer shouldn't call out to driver.

Currently, the code has different opportunistic checks which can catch
most of those cases but unfortunatly I think it just makes the bugs
more obscure.

That said, we probably should be switching to internal lock once
clenaup is complete.

> > * blk_throtl_bio() indicates return status both with its return value
> >   and in/out param **@bio.  The former is used to indicate whether
> >   queue is found to be dead during throtl processing.  The latter
> >   whether the bio is throttled.
> > 
> >   There's no point in returning DEAD check result from
> >   blk_throtl_bio().  The queue can die after blk_throtl_bio() is
> >   finished but before make_request_fn() grabs queue lock.
> 
> The reason I was returning error in case of queue DEAD is that I
> wanted IO to now return with error instead of continuing to call
> q->make_request_fn(q, bio) which does not do queue dead check and
> assumes queue is still alive.
> 
> With this change, if queue is DEAD, bio will not be throttled and we
> will continue to submit bio to queue and I am not sure who will catch
> it in __make_request()?

The same thing - all that the check in blk-throtl does is somewhat
reducing the race window - without it the window starts after the DEAD
check in generic_make_request_checks().  One way or the other, this
doesn't make much meaningful difference and I think it just obscures
the bug both in behavior and code (it's being check here, it gotta be
safe!).  So, I just wanted to remove it before fixing it properly.

Thank you.

-- 
tejun

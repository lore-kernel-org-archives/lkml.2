Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab1BQPBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:01:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab1BQPB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:01:26 -0500
Date: Thu, 17 Feb 2011 10:01:22 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110217150122.GD9075@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
 <20110216155305.GC14653@redhat.com>
 <20110217113536.2bbf308e@notabene.brown>
 <20110217011029.GA6793@redhat.com>
 <20110217165501.47f3c26f@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217165501.47f3c26f@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:55:01PM +1100, NeilBrown wrote:
> On Wed, 16 Feb 2011 20:10:29 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > So is it possible to keep the spinlock intact when md is calling up
> > blk_cleanup_queue()?
> > 
> 
> It would be possible, yes - but messy.  I would probably end up just making
> ->queue_lock always point to __queue_lock, and then only take it at the
> places where I call 'block' code which wants to test to see if it is
> currently held (like the plugging routines).
> 
> The queue lock (and most of the request queue) is simply irrelevant for md.
> I would prefer to get away from having to touch it at all...
> 
> I'll see how messy it would be to stop using it completely and it can just be
> __queue_lock.
> 
> Though for me - it would be much easier if you just used __queue_lock .....

Ok, Thinking more about it, How about introducing another spin lock in
request queue, say q->throtl_lock. I seem to be using queue lock for
synchronization between blk-cgroup and throttling code and also for
integrity of throttling data structures when multiple threads are
operating. Looks like I might be able to get away using throtl_lock and
not rely on queue_lock at all.

Want to avoid using __queue_lock for two reasons.

- It is not clear when we are actually sharing the lock with the driver
  and when we are not. In future if there are interaction with other
  code on request queue, then it will be confusing. If we introduce
  throtl_lock, then for additional queue synchronization, one can take
  q->queue_lock also.

- Splitting the queue lock should probably be good as it will reduce the
  contention on q->queue_lock. If it is benefecial, then we should not
  use __queue_lock to actually reduce the contention. 

I will do this change and see whether it works or not.

Thanks
Vivek 

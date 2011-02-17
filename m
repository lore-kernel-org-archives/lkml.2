Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1BQBKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:10:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1BQBKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:10:32 -0500
Date: Wed, 16 Feb 2011 20:10:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110217011029.GA6793@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
 <20110216155305.GC14653@redhat.com>
 <20110217113536.2bbf308e@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217113536.2bbf308e@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 11:35:36AM +1100, NeilBrown wrote:
> On Wed, 16 Feb 2011 10:53:05 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Wed, Feb 16, 2011 at 06:31:14PM +1100, NeilBrown wrote:
> > > 
> > > 
> > > Hi,
> > > 
> > >  I recently discovered that blk_throtl_exit takes ->queue_lock when a blockdev
> > > is finally released.
> > > 
> > > This is a problem for because by that time the queue_lock doesn't exist any
> > > more.  It is in a separate data structure controlled by the RAID personality
> > > and by the time that the block device is being destroyed the raid personality
> > > has shutdown and the data structure containing the lock has been freed.
> > > 
> > > This has not been a problem before.  Nothing else takes queue_lock after
> > > blk_cleanup_queue.
> > 
> > I agree that this is a problem. blk_throtl_exit() needs queue lock to
> > avoid other races with cgroup code and for avoiding races for its
> > lists etc.
> > 
> > > 
> > > I could of course set queue_lock to point to __queue_lock and initialise that,
> > > but it seems untidy and probably violates some locking requirements.
> > > 
> > > Is there some way you could use some other lock - maybe a global lock, or
> > > maybe used __queue_lock directly ???
> > 
> > Initially I had put blk_throtl_exit() in blk_cleanup_queue() where it is
> > known that ->queue_lock is still around. Due to a bug, Jens moved it
> > to blk_release_queue(). I still think that blk_cleanup_queue() is a better
> > place to call blk_throtl_exit().
> 
> Why do you say that it is known that ->queue_lock is still around in
> blk_cleanup_queue?  In md it isn't. :-(
> Is there some (other) reason that it needs to be?

I think this is only true for devices having an elevator because
elevator_exit() will call cfq_exit_queue() and take queue lock. So request
based multipath devices should have it initialized till now.

But yes, for devices not running an elevator, there does not seem to be
any other component requiring queue lock to be still there.

Like elevator, throttling logic has data structures which need to be
cleaned up if driver decides to cleanup the queue. What is that point
till when we can use the queue->lock safely? If driver is providing
the spinlock embedded in a structue, then it would make logical sense
to call back the queue at some point of time and say that spinlock
is going away and cleanup any dependencies. I thought blk_cleanup_queue()
will be that call but looks like it is not true for all cases.

So is it possible to keep the spinlock intact when md is calling up
blk_cleanup_queue()?

Thanks
Vivek 

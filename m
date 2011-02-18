Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1BRB5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:57:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:44196 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1BRB5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:57:47 -0500
Date: Fri, 18 Feb 2011 12:57:39 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110218125739.562430c7@notabene.brown>
In-Reply-To: <20110217200010.GF9075@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
	<20110217200010.GF9075@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:00:11 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Feb 16, 2011 at 06:31:14PM +1100, NeilBrown wrote:
> > 
> > 
> > Hi,
> > 
> >  I recently discovered that blk_throtl_exit takes ->queue_lock when a blockdev
> > is finally released.
> > 
> > This is a problem for because by that time the queue_lock doesn't exist any
> > more.  It is in a separate data structure controlled by the RAID personality
> > and by the time that the block device is being destroyed the raid personality
> > has shutdown and the data structure containing the lock has been freed.
> 
> Hi Neil,
> 
> I am having a look at queue allocation in md and had few queries.
> 
> I was looking at md_alloc(), where we do
> 
> mddev->queue = blk_alloc_queue(GFP_KERNEL);
> blk_queue_make_request(mddev->queue, md_make_request);
> 
> call to blk_queue_make_request() will make sure queue_lock is initiliazed
> to internal __queue_lock.

That is a relatively recent change. commit a4e7d46407d in July 2009 by the
look of it.

> 
> Then I looked at raid0_run(), which is again setting the queue lock.
> 
> mddev->queue->queue_lock = &mddev->queue->__queue_lock;
> 
> I think this is redundant now as during md_alloc() we already did it.

Yep, it is now redundant.

> 
> Similar seems to be the case for linear.c and multipath.c
> 
> Following seem to be the cases where we overide the default lock.
> 
> raid1.c, raid5.c, raid10.c
> 
> I was going through the raid1.c, and I see that q->queue_lock has
> been initialized to &conf->deivce_lock. Can we do the reverse. Introduce
> spinlock pointer in conf and point it at queue->queue_lock? Anyway you
> mentioned that personality's data structure are freed before request
> queue is cleaned up, so there should not be any lifetime issues.

The reason it is this way is largely historical.  I don't recall the details
exactly but md data structures were always quite independent of request_queue.

The only reason I set ->queue_lock at all is because some blk functions
started checking that it was held ... something to do with plugging and
stacking limits I think.  See commit e7e72bf641b1 (may 2008) for more details.


> 
> Also  I was wondering how does it help sharing the lock between request
> queue and some other data structures in driver.

All it does is silence some warnings.

NeilBrown

> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


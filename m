Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab1BQUAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:00:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915Ab1BQUAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:00:17 -0500
Date: Thu, 17 Feb 2011 15:00:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110217200010.GF9075@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216183114.26a3613b@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 06:31:14PM +1100, NeilBrown wrote:
> 
> 
> Hi,
> 
>  I recently discovered that blk_throtl_exit takes ->queue_lock when a blockdev
> is finally released.
> 
> This is a problem for because by that time the queue_lock doesn't exist any
> more.  It is in a separate data structure controlled by the RAID personality
> and by the time that the block device is being destroyed the raid personality
> has shutdown and the data structure containing the lock has been freed.

Hi Neil,

I am having a look at queue allocation in md and had few queries.

I was looking at md_alloc(), where we do

mddev->queue = blk_alloc_queue(GFP_KERNEL);
blk_queue_make_request(mddev->queue, md_make_request);

call to blk_queue_make_request() will make sure queue_lock is initiliazed
to internal __queue_lock.

Then I looked at raid0_run(), which is again setting the queue lock.

mddev->queue->queue_lock = &mddev->queue->__queue_lock;

I think this is redundant now as during md_alloc() we already did it.

Similar seems to be the case for linear.c and multipath.c

Following seem to be the cases where we overide the default lock.

raid1.c, raid5.c, raid10.c

I was going through the raid1.c, and I see that q->queue_lock has
been initialized to &conf->deivce_lock. Can we do the reverse. Introduce
spinlock pointer in conf and point it at queue->queue_lock? Anyway you
mentioned that personality's data structure are freed before request
queue is cleaned up, so there should not be any lifetime issues.

Also  I was wondering how does it help sharing the lock between request
queue and some other data structures in driver.

Thanks
Vivek

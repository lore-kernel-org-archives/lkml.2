Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab2FAJ2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759148Ab2FAJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:28:40 -0400
Date: Fri, 1 Jun 2012 12:28:32 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Asias He <asias@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: Fix lock unbalance caused by lock disconnect
Message-ID: <20120601092832.GA20346@redhat.com>
References: <1337911859-22913-1-git-send-email-asias@redhat.com>
 <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com>
 <4FC2DFB6.6080701@redhat.com>
 <20120528102055.GA15202@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528102055.GA15202@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 07:20:55PM +0900, Tejun Heo wrote:
> Hello, Asias.
> 
> On Mon, May 28, 2012 at 10:15:18AM +0800, Asias He wrote:
> > >I don't think the patch description is correct.  The lock switcihng is
> > >inherently broken and the patch doesn't really fix the problem
> > >although it *might* make the problem less likely.  Trying to switch
> > >locks while there are other accessors of the lock is simply broken, it
> > >can never work without outer synchronization.
> > 
> > Since the lock switching is broken, is it a good idea to force all
> > the drivers to use the block layer provided lock? i.e. Change the
> > API from
> > blk_init_queue(rfn, driver_lock) to blk_init_queue(rfn). Any reason
> > not to use the block layer provided one.
> 
> I think hch tried to do that a while ago.  Dunno what happened to the
> patches.  IIRC, the whole external lock thing was about sharing a
> single lock across different request_queues.  Not sure whether it's
> actually beneficial enough or just a crazy broken optimization.

Looks like almost all drivers get it wrong.  And it's likely
something like a floppy driver doesn't need an optimization:
drivers/block/floppy.c:	disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);

The obvious use of this API is wrong. So how about introducing
a correct one, deprecating the broken one so we can start
slowly converting users?

Then if someone sees a real reason for the internal lock,
he will complain.




> > >Your patch might make
> > >the problem somewhat less likely simply because queue draining makes a
> > >lot of request_queue users go away.
> > 
> > Who will use the request_queue after blk_cleanup_queue()?
> 
> Anyone who still holds a ref might try to issue a new request on a
> dead queue.  ie. blkdev with filesystem mounted goes away and the FS
> issues a new read request after blk_cleanup_queue() finishes drainig.
> 
> Thanks.
> 
> -- 
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

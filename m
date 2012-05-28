Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2E1KVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:21:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2E1KVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:21:04 -0400
Date: Mon, 28 May 2012 19:20:55 +0900
From: Tejun Heo <tj@kernel.org>
To: Asias He <asias@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: Fix lock unbalance caused by lock disconnect
Message-ID: <20120528102055.GA15202@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337911859-22913-1-git-send-email-asias@redhat.com>
 <20120528000749.GA8305@dhcp-172-17-108-109.mtv.corp.google.com>
 <4FC2DFB6.6080701@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC2DFB6.6080701@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Asias.

On Mon, May 28, 2012 at 10:15:18AM +0800, Asias He wrote:
> >I don't think the patch description is correct.  The lock switcihng is
> >inherently broken and the patch doesn't really fix the problem
> >although it *might* make the problem less likely.  Trying to switch
> >locks while there are other accessors of the lock is simply broken, it
> >can never work without outer synchronization.
> 
> Since the lock switching is broken, is it a good idea to force all
> the drivers to use the block layer provided lock? i.e. Change the
> API from
> blk_init_queue(rfn, driver_lock) to blk_init_queue(rfn). Any reason
> not to use the block layer provided one.

I think hch tried to do that a while ago.  Dunno what happened to the
patches.  IIRC, the whole external lock thing was about sharing a
single lock across different request_queues.  Not sure whether it's
actually beneficial enough or just a crazy broken optimization.

> >Your patch might make
> >the problem somewhat less likely simply because queue draining makes a
> >lot of request_queue users go away.
> 
> Who will use the request_queue after blk_cleanup_queue()?

Anyone who still holds a ref might try to issue a new request on a
dead queue.  ie. blkdev with filesystem mounted goes away and the FS
issues a new read request after blk_cleanup_queue() finishes drainig.

Thanks.

-- 
tejun

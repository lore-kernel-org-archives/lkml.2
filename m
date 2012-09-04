Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab2IDWq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:46:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45075 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab2IDWqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:46:24 -0400
Date: Tue, 4 Sep 2012 15:46:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: FLUSH/FUA documentation & code discrepancy
Message-ID: <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
References: <8439412.RChiDciQdh@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8439412.RChiDciQdh@fat-tyre>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 04, 2012 at 02:32:01PM +0200, Philipp Reisner wrote:
> I think commit 1e87901e18 was wrong. Starting with that commit the REQ_FLUSH 
> and REQ_FUA bits get stripped away if the queue does not advertise REQ_FLUSH
> or REQ_FUA support.
> 
> But the REQ_FLUSH bit is also tested for when not merging requests
> (blk_queue_bio()) or when it comes to the elevator (blk_flush_plug_list()).
> 
> So, since this patch the elevator reorders write requests on queues that 
> do not have REQ_FLUSH or REQ_FUA set.
> 
> While on queues that have REQ_FLUSH or REQ_FUA set, the elevator does
> not reorder writes across FLUSHes.

Currently, FLUSH/FUA doesn't enforce any ordering requirement.  File
systems are responsible for draining all writes which have to happen
before and not issue further writes which should come after.  The use
of SOFTBARRIER there is mostly historical.  I *suspect* we should be
able to drop that as RQ_NOMERGE_FLAGS already contain FLUSH and FUA.
Not really looked through it tho.

> I have the impression every file system lets IO drain, and issues a
> flush afterwards with the blkdev_issue_flush() function. BTW that
> function turns into a non-obvious no-op as soon as the queue does not
> have the REQ_FUA or REQ_FLUSH bits set. It does not look like it is
> a no-op by intention.

So, yeah, it is no-op by intention.  We probably should make the
documentation clearer.

Thanks.

-- 
tejun

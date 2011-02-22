Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab1BVEUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 23:20:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59313 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab1BVEUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 23:20:17 -0500
Date: Tue, 22 Feb 2011 15:20:03 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        sergey.senozhatsky@gmail.com, tj@kernel.org, jmoyer@redhat.com,
        snitzer@redhat.com
Subject: Re: [PATCH 0/3] [RFC] block: Enforce that ->queue_lock is
 initialized during call to blk_cleanup_queue()
Message-ID: <20110222152003.09698a39@notabene.brown>
In-Reply-To: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011 22:53:34 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> Hi All,
> 
> Currently it is not clear what's the status of ->queue_lock when
> blk_cleanup_queue() is called. Now block throttle code (blk_throtl_exit())
> requires queue lock to be initialized as it takes the spin lock, so we need
> some kind of clear convention that when is it safe to assume that queue lock
> is initiliazed and blk_throtle_exit() can be called safely.
> 
> We recently ran into issues with loop driver which was trying to free
> up queue almost immediately after block_alloc_queue() due to some internal
> errors. Also NeilBrown complained that in current form, md provides its
> own spinlock and zaps that before blk_cleanup_queue() call and that will
> have issues with throttling code. Neil has not fixed the issue with
> md driver and queued up a patch in this tree.
> 
> So there is a need to make sure blk_throtl_exit() can be called safely
> and to also catch any errors if some drivers are not doing so. This
                                                   ^^^
"now" !!  I make that typo all the time too :-(

> patch series puts a WARN_ON(!q->queue_lock) in blk_cleanup_queue() and
> moves the queue lock initialization in queue allocation code. Also it
> move blk_throtl_exit() from release_queue() to cleanup_queue().

I'm not sure there is a lot of point in the WARN_ON.
Modules that replace ->queue_lock are unlikely to set it to NULL when
done, they will just free the structure that it points into.
This will already be caught if you compile with DEBUG_PAGEALLOC and
DEBUG_SPINLOCK (I think) and there is not much else you can do to catch
these.

Thanks,
NeilBrown


> 
> These pathes are only boot tested on one machine. Before I do more
> extensive testing, I wanted to throw it out there and figure out
> if it makes sense or not.
> 
> Thanks
> Vivek
> 
> Vivek Goyal (3):
>   block: Initialize ->queue_lock to internal lock at queue allocation
>     time
>   loop: No need to initialize ->queue_lock explicitly before calling
>     blk_cleanup_queue()
>   block: Move blk_throtl_exit() call to blk_cleanup_queue()
> 
>  block/blk-core.c       |   26 ++++++++++++++++++++++++--
>  block/blk-settings.c   |    7 -------
>  block/blk-sysfs.c      |    2 --
>  block/blk-throttle.c   |    2 +-
>  drivers/block/loop.c   |    3 ---
>  include/linux/blkdev.h |    2 --
>  6 files changed, 25 insertions(+), 17 deletions(-)


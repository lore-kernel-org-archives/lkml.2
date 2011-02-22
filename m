Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1BVORn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab1BVORm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:17:42 -0500
Date: Tue, 22 Feb 2011 09:17:32 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        sergey.senozhatsky@gmail.com, tj@kernel.org, jmoyer@redhat.com,
        snitzer@redhat.com
Subject: Re: [PATCH 0/3] [RFC] block: Enforce that ->queue_lock is
 initialized during call to blk_cleanup_queue()
Message-ID: <20110222141732.GA28269@redhat.com>
References: <1298346817-26144-1-git-send-email-vgoyal@redhat.com>
 <20110222152003.09698a39@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222152003.09698a39@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 03:20:03PM +1100, NeilBrown wrote:
> On Mon, 21 Feb 2011 22:53:34 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Hi All,
> > 
> > Currently it is not clear what's the status of ->queue_lock when
> > blk_cleanup_queue() is called. Now block throttle code (blk_throtl_exit())
> > requires queue lock to be initialized as it takes the spin lock, so we need
> > some kind of clear convention that when is it safe to assume that queue lock
> > is initiliazed and blk_throtle_exit() can be called safely.
> > 
> > We recently ran into issues with loop driver which was trying to free
> > up queue almost immediately after block_alloc_queue() due to some internal
> > errors. Also NeilBrown complained that in current form, md provides its
> > own spinlock and zaps that before blk_cleanup_queue() call and that will
> > have issues with throttling code. Neil has not fixed the issue with
> > md driver and queued up a patch in this tree.
> > 
> > So there is a need to make sure blk_throtl_exit() can be called safely
> > and to also catch any errors if some drivers are not doing so. This
>                                                    ^^^
> "now" !!  I make that typo all the time too :-(
> 
> > patch series puts a WARN_ON(!q->queue_lock) in blk_cleanup_queue() and
> > moves the queue lock initialization in queue allocation code. Also it
> > move blk_throtl_exit() from release_queue() to cleanup_queue().
> 
> I'm not sure there is a lot of point in the WARN_ON.
> Modules that replace ->queue_lock are unlikely to set it to NULL when
> done, they will just free the structure that it points into.
> This will already be caught if you compile with DEBUG_PAGEALLOC and
> DEBUG_SPINLOCK (I think) and there is not much else you can do to catch
> these.
> 

Ok, that makes sense. So I will drop the WARN_ON() part.

Patch3 also removes throtl_shutdown_timer_wq() call from blk_sync_queue().
The only driver user of blk_sync_queue() seems to be md. IIUC, md needs
it because md provides its own unplug function and it does not want
that function to be called any more as it accesses some "conf" data
structures which are going away.

If that's the case, then we don't have to worry about quiescing throtl
work as it does not call unplug function. It just calls
generic_make_request(bio) and by that time md queue should be either 
DEAD or it should be able to handle bios coming in and returning error
while it is cleaning up its data structures.

In fact cancelling the pending throtl work will hang disptch of throttled
bios so it is not a good idea. blk_throtl_exit() is the right way to
cleanup all the throtl related state.

Removing this call from blk_sync_queue() enables me to move
blk_throtl_exit() in blk_cleanup_queue() and that makes sure ->queue_lock
is valid hence blk_throtl_exit() can execute safely.

Thanks
Vivek


> Thanks,
> NeilBrown
> 
> 
> > 
> > These pathes are only boot tested on one machine. Before I do more
> > extensive testing, I wanted to throw it out there and figure out
> > if it makes sense or not.
> > 
> > Thanks
> > Vivek
> > 
> > Vivek Goyal (3):
> >   block: Initialize ->queue_lock to internal lock at queue allocation
> >     time
> >   loop: No need to initialize ->queue_lock explicitly before calling
> >     blk_cleanup_queue()
> >   block: Move blk_throtl_exit() call to blk_cleanup_queue()
> > 
> >  block/blk-core.c       |   26 ++++++++++++++++++++++++--
> >  block/blk-settings.c   |    7 -------
> >  block/blk-sysfs.c      |    2 --

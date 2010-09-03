Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0ICB57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64528 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab0ICB56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:57:58 -0400
Date: Thu, 2 Sep 2010 21:57:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Divyesh Shah <dpshah@google.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, arighi@develer.com
Subject: Re: [RFC PATCH] Bio Throttling support for block IO controller
Message-ID: <20100903015739.GB9450@redhat.com>
References: <20100901175830.GC22149@redhat.com>
 <20100902183932.GF2349@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902183932.GF2349@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:39:32AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 01, 2010 at 01:58:30PM -0400, Vivek Goyal wrote:
> > Hi,
> > 
> > Currently CFQ provides the weight based proportional division of bandwidth.
> > People also have been looking at extending block IO controller to provide
> > throttling/max bandwidth control.
> > 
> > I have started to write the support for throttling in block layer on 
> > request queue so that it can be used both for higher level logical
> > devices as well as leaf nodes. This patch is still work in progress but
> > I wanted to post it for early feedback.
> > 
> > Basically currently I have hooked into __make_request() function to 
> > check which cgroup bio belongs to and if it is exceeding the specified
> > BW rate. If no, thread can continue to dispatch bio as it is otherwise
> > bio is queued internally and dispatched later with the help of a worker
> > thread.
> > 
> > HOWTO
> > =====
> > - Mount blkio controller
> > 	mount -t cgroup -o blkio none /cgroup/blkio
> > 
> > - Specify a bandwidth rate on particular device for root group. The format
> >   for policy is "<major>:<minor>  <byes_per_second>".
> > 
> > 	echo "8:16  1048576" > /cgroup/blkio/blkio.read_bps_device
> > 
> >   Above will put a limit of 1MB/second on reads happening for root group
> >   on device having major/minor number 8:16.
> > 
> > - Run dd to read a file and see if rate is throttled to 1MB/s or not.
> > 
> > 	# dd if=/mnt/common/zerofile of=/dev/null bs=4K count=1024 iflag=direct
> > 	1024+0 records in
> > 	1024+0 records out
> > 	4194304 bytes (4.2 MB) copied, 4.0001 s, 1.0 MB/s
> > 
> >  Limits for writes can be put using blkio.write_bps_device file.
> > 
> > Open Issues
> > ===========
> > - Do we need to provide additional queue congestion semantics as we are
> >   throttling and queuing bios at request queue and probably we don't want
> >   a user space application to consume all the memory allocating bios
> >   and bombarding request queue with those bios.
> > 
> > - How to handle the current blkio cgroup stats file and two policies
> >   in the background. If for some reason both throttling and proportional
> >   BW policies are operating on request queue, then stats will be very
> >   confusing.
> > 
> >   May be we can allow activating either throttling or proportional BW
> >   policy per request queue and we can create a /sys tunable to list and
> >   chose between policies (something like choosing IO scheduler). The
> >   only downside of this apporach is that user also need to be aware of
> >   the storage hierachy and activate right policy at each node/request
> >   queue.
> > 
> > TODO
> > ====
> > - Lots of testing, bug fixes.
> > - Provide support for enforcing limits in IOPS.
> > - Extend the throttling support for dm devices also.
> > 
> > Any feedback is welcome.
> > 
> > Thanks
> > Vivek
> > 
> > o IO throttling support in block layer.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  block/Makefile            |    2 
> >  block/blk-cgroup.c        |  282 +++++++++++--
> >  block/blk-cgroup.h        |   44 ++
> >  block/blk-core.c          |   28 +
> >  block/blk-throttle.c      |  928 ++++++++++++++++++++++++++++++++++++++++++++++
> >  block/blk.h               |    4 
> >  block/cfq-iosched.c       |    4 
> >  include/linux/blk_types.h |    3 
> >  include/linux/blkdev.h    |   22 +
> >  9 files changed, 1261 insertions(+), 56 deletions(-)
> > 
> 
> [ . . . ]
> 
> > +void blk_throtl_exit(struct request_queue *q)
> > +{
> > +	struct throtl_data *td = q->td;
> > +	bool wait = false;
> > +
> > +	BUG_ON(!td);
> > +
> > +	throtl_shutdown_timer_wq(q);
> > +
> > +	spin_lock_irq(q->queue_lock);
> > +	throtl_release_tgs(td);
> > +	blkiocg_del_blkio_group(&td->root_tg.blkg);
> > +
> > +	/* If there are other groups */
> > +	if (td->nr_undestroyed_grps >= 1)
> > +		wait = true;
> > +
> > +	spin_unlock_irq(q->queue_lock);
> > +
> > +	/*
> > +	 * Wait for tg->blkg->key accessors to exit their grace periods.
> > +	 * Do this wait only if there are other undestroyed groups out
> > +	 * there (other than root group). This can happen if cgroup deletion
> > +	 * path claimed the responsibility of cleaning up a group before
> > +	 * queue cleanup code get to the group.
> > +	 *
> > +	 * Do not call synchronize_rcu() unconditionally as there are drivers
> > +	 * which create/delete request queue hundreds of times during scan/boot
> > +	 * and synchronize_rcu() can take significant time and slow down boot.
> > +	 */
> > +	if (wait)
> > +		synchronize_rcu();
> 
> The RCU readers are presumably not accessing the structure referenced
> by td?  If they can access it, then they will be accessing freed memory
> after the following function call!!!

Hi Paul,

Thanks for the review.

As per my understanding if wait = false, then there should not be any
RCU readers of tg->blkg->key (key is basically struct throtl_data *td) out
there hence it should be safe to to free "td" without calling
synchronize_rcu() or call_rcu().

Following are some details.

- We instanciate some throtl_grp structures as IO happens in a cgropu and
  these objects are put in a hash list (td->tg_list). These objects are
  put into another cgroup list (blkcg->blkg_list, blk-cgroup.c).

  Root group is only exception which is not allocated dynamically instead it
  is statically allocated as part of throtl_data structure.
  (struct throtl_grp root_tg);

- There are two group deletion paths. One is if cgroup is being deleted
  then we need to cleanup associated group and other is if device is
  going away then we need to cleanup all groups and td and request queue
  etc.

- The only user of RCU protected tg->blkg->key is cgroup deletion path
  and that path will be accessing this key only if it got the ownership
  of a group it wants to delete. Basically group deletion path can race
  between cgroup deletion event and device going away at the same time.

  In this case, both path will want to clean up a group and some kind of
  arbitration is needed. The path which is first able to take blkcg->lock
  and is able to delete group from blkcg->blkg_list, takes the
  responsibility of cleaning up the group.

  Now if there are no undestroyed groups (except root group which cgroup
  path will never try to destroy as root cgroup is not deleted), that
  means cgroup path will not try to free up any groups, that also means
  that there will be no other RCU readers of tg->blkg->key and hence
  it should be safe to free up "td" without synchronize_rcu()
  or call_rcu(). Am I missing something?
 
> 
> If they can access it, I suggest using call_rcu() instead of
> synchronize_rcu().  One way of doing this would be:
> 
> 	if (!wait) {
> 		call_rcu(&td->rcu, throtl_td_deferred_free);

if !wait, then as per my current understanding there are no RCU readers
out there and above step should not be required. The reason I don't want
to use call_rcu() is that though it will keep "td" around but request
queue will be gone (td->queue) and RCU reader path take request queue
spin lock and they will be trying to take lock which has been freed.

throtl_unlink_blkio_group() {
	spin_lock_irqsave(td->queue->queue_lock, flags);
}
 

> 	} else {
> 		synchronize_rcu();
> 		throtl_td_free(td);
> 	}

This is the step my code is already doing. If wait=true, then there are
RCU readers out there and wait for them to finish before freeing up
td.

Thanks
Vivek

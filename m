Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965207Ab2CFTRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab2CFTRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:17:41 -0500
Date: Tue, 6 Mar 2012 13:39:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [PATCHSET] blkcg: accumulated blkcg updates
Message-ID: <20120306183942.GC32148@redhat.com>
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
 <20120305210726.GC1263@google.com>
 <20120305210836.GD1263@google.com>
 <20120306150709.GA32148@redhat.com>
 <20120306162455.GB32148@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306162455.GB32148@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 11:24:55AM -0500, Vivek Goyal wrote:
> On Tue, Mar 06, 2012 at 10:07:09AM -0500, Vivek Goyal wrote:
> 
> [..]
> > 
> > My system is hanging during reboot. Last message I see is "Detaching DM
> > devices" and nothing happens after that. I shall have to do some more 
> > testing to figure out when did that start happening.
> 
> Ok, git bisect shows that very first patch to drain the queue is culprit.
> 
> 9e5b9f8 block: blk-throttle should be drained regardless of q->elevator
> 
> Will do some more debugging.

Hmm..., haven't reached to the bottom of the issue yet, but there is more
data.

- We are spinning in blk_drain_queue() as we think there is request on the
  request queue to be drained.

- The request queue we are spinning on, is created by dm.

- There is something queued on q->queue_head but we are not kicking queue
  as q->request_fn is empty. I think you put this code to avoid issues
  with loop etc. Though I am not sure why it is not a bug condition. If
  a request queue does not have a request function, its a bio based
  driver. Are these driver using q->queue_head to queue bios or something
  internal? If yes, then it is still a BUG() condition as driver should
  have cleaned up the queue before calling blk_cleanup_queue(). So I
  don't know why you are not treating it as a bug() condition.

Captured two backtraces of queue creation and when we are spinning in 
queue drain/cleanup.

CCing dm-devel. They might know what's happening.

Also there is no q->backing_dev_info.dev. So looks like either we never
registered a device or we cleaned up a device before calling
blk_cleanup_queue().

Thanks
Vivek

Queue creation backtrace.
------------------------
[   23.382675] ------------[ cut here ]------------
[   23.387628] WARNING: at block/blk-cgroup.c:1660 blkcg_init_queue+0x4b/0xb0()
[   23.394739] Hardware name: HP xw6600 Workstation
[   23.399426] Modules linked in: floppy [last unloaded: scsi_wait_scan]
[   23.406077] Pid: 2739, comm: lvm Tainted: G        W    3.3.0-rc3+ #3
[   23.412583] Call Trace:
[   23.415105]  [<ffffffff81037f2f>] warn_slowpath_common+0x7f/0xc0
[   23.421180]  [<ffffffff81037f8a>] warn_slowpath_null+0x1a/0x20
[   23.427080]  [<ffffffff8130b76b>] blkcg_init_queue+0x4b/0xb0
[   23.432811]  [<ffffffff812f2c2a>] blk_alloc_queue_node+0x22a/0x270
[   23.439057]  [<ffffffff812f2c83>] blk_alloc_queue+0x13/0x20
[   23.444700]  [<ffffffff815722ee>] dm_create+0x21e/0x520
[   23.449995]  [<ffffffff8157890e>] dev_create+0x5e/0x360
[   23.455289]  [<ffffffff81578e9a>] ctl_ioctl+0x15a/0x2c0
[   23.460586]  [<ffffffff8112110c>] ? might_fault+0x5c/0xb0
[   23.466053]  [<ffffffff815788b0>] ? dev_suspend+0x240/0x240
[   23.471693]  [<ffffffff81579013>] dm_ctl_ioctl+0x13/0x20
[   23.477075]  [<ffffffff81163658>] do_vfs_ioctl+0x98/0x560
[   23.482543]  [<ffffffff81150b9f>] ? fget_light+0x1df/0x490
[   23.488097]  [<ffffffff81154ada>] ? sys_newstat+0x2a/0x40
[   23.493564]  [<ffffffff81163bb1>] sys_ioctl+0x91/0xa0
[   23.498686]  [<ffffffff81843ad2>] system_call_fastpath+0x16/0x1b
[   23.504759] ---[ end trace 1de7f357c03667a3 ]---

Queue cleanup backtrace
------------------------
[  147.977010] ------------[ cut here ]------------
[  147.981696] WARNING: at block/blk-core.c:411
blk_drain_queue+0x124/0x180()
[  147.988636] Hardware name: HP xw6600 Workstation
[  147.993323] Modules linked in: floppy [last unloaded: scsi_wait_scan]
[  147.999976] Pid: 1, comm: systemd-shutdow Tainted: G        W
3.3.0-rc3+ #3
[  148.007307] Call Trace:
[  148.009831]  [<ffffffff81037f2f>] warn_slowpath_common+0x7f/0xc0
[  148.015911]  [<ffffffff81037f8a>] warn_slowpath_null+0x1a/0x20
[  148.021816]  [<ffffffff812f78c4>] blk_drain_queue+0x124/0x180
[  148.027630]  [<ffffffff812f7a24>] blk_cleanup_queue+0x104/0x1f0
[  148.033619]  [<ffffffff81571ebe>] __dm_destroy+0x1ee/0x260
[  148.039180]  [<ffffffff81572c43>] dm_destroy+0x13/0x20
[  148.044393]  [<ffffffff815783cd>] dev_remove+0x8d/0xf0
[  148.049601]  [<ffffffff81578e9a>] ctl_ioctl+0x15a/0x2c0
[  148.054895]  [<ffffffff81578340>] ? __hash_remove+0xd0/0xd0
[  148.060538]  [<ffffffff81579013>] dm_ctl_ioctl+0x13/0x20
[  148.065919]  [<ffffffff81163658>] do_vfs_ioctl+0x98/0x560
[  148.071389]  [<ffffffff8115bb13>] ? putname+0x33/0x50
[  148.076512]  [<ffffffff81145445>] ? kmem_cache_free+0x235/0x240
[  148.082499]  [<ffffffff81150b9f>] ? fget_light+0x1df/0x490
[  148.088055]  [<ffffffff81163bb1>] sys_ioctl+0x91/0xa0
[  148.093177]  [<ffffffff81843ad2>] system_call_fastpath+0x16/0x1b
[  148.099251] ---[ end trace 1de7f357c03667bc ]---
[  148.103939] Sleeping waiting in drain_queue. q=ffff880136f847a0 drain=1
queue_empty=0 q->request_fn=          (null)

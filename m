Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848Ab2B2TEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 14:04:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964992Ab2B2TEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 14:04:05 -0500
Date: Wed, 29 Feb 2012 14:03:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120229190354.GC5930@redhat.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120227182220.GD27677@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120227182220.GD27677@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 01:22:20PM -0500, Vivek Goyal wrote:
> On Thu, Feb 23, 2012 at 03:12:04PM -0800, Tejun Heo wrote:
> > On Thu, Feb 23, 2012 at 03:01:23PM -0800, Tejun Heo wrote:
> > > Hmmm... going through the thread again, ah, okay, I forgot about that
> > > completely.  Yeah, that is an actual problem.  Both __GFP_WAIT which
> > > isn't GFP_KERNEL and GFP_KERNEL are valid use cases.  I guess we'll be
> > > building async percpu pool in blkcg then.  Great.  :(
> > 
> > Vivek, you win. :) Can you please refresh the async alloc patch on top
> > of blkcg-stacking branch?  I'll rool that into this series and drop
> > the mempool stuff.
> 
> Hi Tejun,
> 
> Looks like there is one more issue. After booting kernel, I tried to read
> one of the cgroup files.
> 
> cat /sys/fs/cgroup/blkio/blkio.throttle.read_bps_device and it oopses.
> 
> Basically it looks like that we are getting a null dev pointer while we
> do following.
> 
> dev_name(blkg->q->backing_dev_info.dev);
> 
> I put some printk to verify backing_dev_info.dev is null. That means
> somehow we have a request queue and we did not call add_disk() on that?
> 
> I checked that queue is not in bypass mode or dead mode. So nobody called
> blk_cleanup_queue() on that.

Ok, more debugging revealed that culprit here is "floppy" driver module.
It instanciates a queue but never registers a disk against it. Better
skip such queues/groups. Here is the patch.


blk-cgroup: Skip a group if there is no disk associated with the queue

blk-cgroup code currently assumes that there is a device/disk associated
with every queue in the system. But modules like floppy, can instanciate
bunch of request queue and not register disk against all the queues. This
can lead to blkcg crashing.

Skip the queue/blkg which don't have any dev/disk associated with them.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

Index: tejun-misc/block/blk-cgroup.c
===================================================================
--- tejun-misc.orig/block/blk-cgroup.c	2012-02-28 00:33:36.000000000 -0500
+++ tejun-misc/block/blk-cgroup.c	2012-03-01 00:51:15.276346953 -0500
@@ -1136,9 +1136,22 @@ static void blkio_print_group_conf(struc
 	int plid = BLKIOFILE_POLICY(cft->private);
 	int fileid = BLKIOFILE_ATTR(cft->private);
 	struct blkg_policy_data *pd = blkg->pd[plid];
-	const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+	const char *dname;
+	struct device *dev;
 	int rw = WRITE;
 
+	dev = blkg->q->backing_dev_info.dev;
+
+	/*
+	 * Some drivers (like floppy), might instanciate a request queue
+	 * and not register any disk against that queue. So dev can be
+	 * null
+	 */
+	if (!dev)
+		return;
+
+	dname = dev_name(dev);
+
 	switch (plid) {
 		case BLKIO_POLICY_PROP:
 			if (pd->conf.weight)
@@ -1230,9 +1243,16 @@ static int blkio_read_blkg_stats(struct 
 	spin_lock_irq(&blkcg->lock);
 
 	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
-		const char *dname = dev_name(blkg->q->backing_dev_info.dev);
+		struct device *dev;
+		const char *dname;
+
 		int plid = BLKIOFILE_POLICY(cft->private);
 
+		dev = blkg->q->backing_dev_info.dev;
+		if (!dev)
+			continue;
+		dname = dev_name(dev);
+
 		if (pcpu) {
 			cgroup_total += blkio_get_stat_cpu(blkg, plid,
 							   cb, dname, type);

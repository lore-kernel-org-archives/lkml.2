Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab2GMKEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 06:04:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:43823 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab2GMKEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 06:04:38 -0400
Date: Fri, 13 Jul 2012 12:04:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <chris.mason@fusionio.com>
cc: Mike Galbraith <efault@gmx.de>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
In-Reply-To: <20120712170945.GJ32174@shiny>
Message-ID: <alpine.LFD.2.02.1207131153020.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net> <alpine.LFD.2.02.1207121253170.32033@ionos> <20120712170945.GJ32174@shiny>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Chris Mason wrote:
> On Thu, Jul 12, 2012 at 05:07:58AM -0600, Thomas Gleixner wrote:
> > On Thu, 12 Jul 2012, Mike Galbraith wrote:
> > > crash> struct rt_mutex 0xffff8801770601c8
> > > struct rt_mutex {
> > >   wait_lock = {
> > >     raw_lock = {
> > >       slock = 7966
> > >     }
> > >   }, 
> > >   wait_list = {
> > >     node_list = {
> > >       next = 0xffff880175eedbe0, 
> > >       prev = 0xffff880175eedbe0
> > >     }, 
> > >     rawlock = 0xffff880175eedbd8, 
> > 
> > Urgh. Here is something completely wrong. That should point to
> > wait_lock, i.e. the rt_mutex itself, but that points into lala land.
> 
> This is probably the memcpy you found later this morning, right?

As Mike found out, it looks like the culprit.
 
> The reader/writer part in btrfs is just an optimization.  If we need
> them to be all writer locks for RT purposes, that's not a problem.
> 
> But, before we go down that road, we do annotations trying
> to make sure lockdep doesn't get confused about lock classes.  Basically
> the tree is locked level by level.  So its safe to take eb->lock while
> holding eb->lock as long as you follow the rules.
> 
> Are additional annotations required for RT?

I don't think so. I'm sure it has been caused by the lock copying as
well. Walking the wrong list can cause complete confusion all over the
place. So lets wait for Mike beating the hell out of it.

Find the patch with a proper changelog below.

Thanks,

	tglx
------------------>
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 12 Jul 2012 15:30:02 +0200
Subject: btrfs: Init io_lock after cloning btrfs device struct

__btrfs_close_devices() clones btrfs device structs with
memcpy(). Some of the fields in the clone are reinitialized, but it's
missing to init io_lock. In mainline this goes unnoticed, but on RT it
leaves the plist pointing to the original about to be freed lock
struct.

Initialize io_lock after cloning, so no references to the original
struct are left.

Reported-and-tested-by: Mike Galbraith <efault@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 43baaf0..06c8ced 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -512,6 +512,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
 		new_device->writeable = 0;
 		new_device->in_fs_metadata = 0;
 		new_device->can_discard = 0;
+		spin_lock_init(&new_device->io_lock);
 		list_replace_rcu(&device->dev_list, &new_device->dev_list);
 
 		call_rcu(&device->rcu, free_device);

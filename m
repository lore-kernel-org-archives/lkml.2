Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab2GLNbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:31:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:39009 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2GLNbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:31:09 -0400
Date: Thu, 12 Jul 2012 15:31:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Galbraith <efault@gmx.de>
cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
In-Reply-To: <1342094233.7707.12.camel@marge.simpson.net>
Message-ID: <alpine.LFD.2.02.1207121514240.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net>  <1342082648.7338.171.camel@marge.simpson.net>  <1342086792.7707.9.camel@marge.simpson.net>  <alpine.LFD.2.02.1207121310420.32033@ionos> <1342094233.7707.12.camel@marge.simpson.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012, Mike Galbraith wrote:
> On Thu, 2012-07-12 at 13:43 +0200, Thomas Gleixner wrote: 
> > rawlock points to ...968 and the node_list to ...970.
> > 
> > struct rt_mutex {
> >         raw_spinlock_t          wait_lock;
> >         struct plist_head       wait_list;
> > 
> > The raw_lock pointer of the plist_head is initialized in
> > __rt_mutex_init() so it points to wait_lock. 
> > 
> > Can you check the offset of wait_list vs. the rt_mutex itself?
> > 
> > I wouldn't be surprised if it's exactly 8 bytes. And then this thing
> > looks like a copied lock with stale pointers to hell. Eew.
> 
> crash> struct rt_mutex -o
> struct rt_mutex {
>    [0] raw_spinlock_t wait_lock;
>    [8] struct plist_head wait_list;

Bingo, that makes it more likely that this is caused by copying w/o
initializing the lock and then freeing the original structure.

A quick check for memcpy finds that __btrfs_close_devices() does a
memcpy of btrfs_device structs w/o initializing the lock in the new
copy, but I have no idea whether that's the place we are looking for.

Thanks,

	tglx

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




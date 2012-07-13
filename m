Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab2GMGbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:31:18 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:45152 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751695Ab2GMGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:31:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19ER3kEuR1EH9FPkcJCbujcC/dVRNAsn98eqvVyr3
	ivJAZCfxV+8I3s
Message-ID: <1342161072.7380.65.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 13 Jul 2012 08:31:12 +0200
In-Reply-To: <alpine.LFD.2.02.1207121514240.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <1342082648.7338.171.camel@marge.simpson.net>
	 <1342086792.7707.9.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121310420.32033@ionos>
	 <1342094233.7707.12.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121514240.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 15:31 +0200, Thomas Gleixner wrote: 
> On Thu, 12 Jul 2012, Mike Galbraith wrote:
> > On Thu, 2012-07-12 at 13:43 +0200, Thomas Gleixner wrote: 
> > > rawlock points to ...968 and the node_list to ...970.
> > > 
> > > struct rt_mutex {
> > >         raw_spinlock_t          wait_lock;
> > >         struct plist_head       wait_list;
> > > 
> > > The raw_lock pointer of the plist_head is initialized in
> > > __rt_mutex_init() so it points to wait_lock. 
> > > 
> > > Can you check the offset of wait_list vs. the rt_mutex itself?
> > > 
> > > I wouldn't be surprised if it's exactly 8 bytes. And then this thing
> > > looks like a copied lock with stale pointers to hell. Eew.
> > 
> > crash> struct rt_mutex -o
> > struct rt_mutex {
> >    [0] raw_spinlock_t wait_lock;
> >    [8] struct plist_head wait_list;
> 
> Bingo, that makes it more likely that this is caused by copying w/o
> initializing the lock and then freeing the original structure.
> 
> A quick check for memcpy finds that __btrfs_close_devices() does a
> memcpy of btrfs_device structs w/o initializing the lock in the new
> copy, but I have no idea whether that's the place we are looking for.

Thanks a bunch Thomas.  I doubt I would have ever figured out that lala
land resulted from _copying_ a lock.  That's one I won't be forgetting
any time soon.  Box not only survived a few thousand xfstests 006 runs,
dbench seemed disinterested in deadlocking virgin 3.0-rt.

btrfs still locks up in my enterprise kernel, so I suppose I had better
plug your fix into 3.4-rt and see what happens, and go beat hell out of
virgin 3.0-rt again to be sure box really really survives dbench.

> 	tglx
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 43baaf0..06c8ced 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -512,6 +512,7 @@ static int __btrfs_close_devices(struct btrfs_fs_devices *fs_devices)
>  		new_device->writeable = 0;
>  		new_device->in_fs_metadata = 0;
>  		new_device->can_discard = 0;
> +		spin_lock_init(&new_device->io_lock);
>  		list_replace_rcu(&device->dev_list, &new_device->dev_list);
>  
>  		call_rcu(&device->rcu, free_device);
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



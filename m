Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933787Ab2GLL51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:57:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57906 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755379Ab2GLL5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:57:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+KSKMJSpOKZO9LeHb/2X5e3VREsKyxGAfsLTXR77
	uS6EE2w8418c8F
Message-ID: <1342094233.7707.12.camel@marge.simpson.net>
Subject: Re: 3.4.4-rt13: btrfs + xfstests 006 = BOOM.. and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 12 Jul 2012 13:57:13 +0200
In-Reply-To: <alpine.LFD.2.02.1207121310420.32033@ionos>
References: <1342072060.7338.102.camel@marge.simpson.net>
	 <1342082648.7338.171.camel@marge.simpson.net>
	 <1342086792.7707.9.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207121310420.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 13:43 +0200, Thomas Gleixner wrote: 
> On Thu, 12 Jul 2012, Mike Galbraith wrote:
> > On Thu, 2012-07-12 at 10:44 +0200, Mike Galbraith wrote: 
> > > On Thu, 2012-07-12 at 07:47 +0200, Mike Galbraith wrote: 
> > > > Greetings,
> > > > 
> > > > I'm chasing btrfs critters in an enterprise 3.0-rt kernel, and just
> > > > checked to see if they're alive in virgin latest/greatest rt kernel.  
> > > > 
> > > > Both are indeed alive and well, ie I didn't break it, nor did the
> > > > zillion patches in enterprise base kernel, so others may have an
> > > > opportunity to meet these critters up close and personal as well.
> > > 
> > > 3.2-rt both explodes and deadlocks as well.  3.0-rt (virgin I mean) does
> > > neither, so with enough re-integrate investment, it might be bisectable.
> > 
> > Nope, virgin 3.0-rt just didn't feel like it at the time.  Booted it
> > again to run hefty test over lunch, it didn't survive 1 xfstests 006,
> > much less hundreds.
> > 
> > crash> bt
> > PID: 7604   TASK: ffff880174238b20  CPU: 0   COMMAND: "btrfs-worker-0"
> >  #0 [ffff88017455d9c8] machine_kexec at ffffffff81025794
> >  #1 [ffff88017455da28] crash_kexec at ffffffff8109781d
> >  #2 [ffff88017455daf8] panic at ffffffff814a0661
> >  #3 [ffff88017455db78] __try_to_take_rt_mutex at ffffffff81086d2f
> >  #4 [ffff88017455dbc8] rt_spin_lock_slowlock at ffffffff814a2670
> >  #5 [ffff88017455dca8] rt_spin_lock at ffffffff814a2db9
> >  #6 [ffff88017455dcb8] schedule_bio at ffffffff81243133
> >  #7 [ffff88017455dcf8] btrfs_map_bio at ffffffff812477be
> >  #8 [ffff88017455dd68] __btree_submit_bio_done at ffffffff812152f6
> >  #9 [ffff88017455dd78] run_one_async_done at ffffffff812148fa
> > #10 [ffff88017455dd98] run_ordered_completions at ffffffff812493e8
> > #11 [ffff88017455ddd8] worker_loop at ffffffff81249dc9
> > #12 [ffff88017455de88] kthread at ffffffff81070266
> > #13 [ffff88017455df48] kernel_thread_helper at ffffffff814a9be4
> > crash> struct rt_mutex 0xffff880174530108
> > struct rt_mutex {
> >   wait_lock = {
> >     raw_lock = {
> >       slock = 7966
> >     }
> >   }, 
> >   wait_list = {
> >     node_list = {
> >       next = 0xffff880175ecc970, 
> >       prev = 0xffff880175ecc970
> >     }, 
> >     rawlock = 0xffff880175ecc968, 
> 
> Pointer into lala land again.

Yeah, and freed again.

> rawlock points to ...968 and the node_list to ...970.
> 
> struct rt_mutex {
>         raw_spinlock_t          wait_lock;
>         struct plist_head       wait_list;
> 
> The raw_lock pointer of the plist_head is initialized in
> __rt_mutex_init() so it points to wait_lock. 
> 
> Can you check the offset of wait_list vs. the rt_mutex itself?
> 
> I wouldn't be surprised if it's exactly 8 bytes. And then this thing
> looks like a copied lock with stale pointers to hell. Eew.

crash> struct rt_mutex -o
struct rt_mutex {
   [0] raw_spinlock_t wait_lock;
   [8] struct plist_head wait_list;
  [40] struct task_struct *owner;
  [48] int save_state;
  [56] const char *file;
  [64] const char *name;
  [72] int line;
  [80] void *magic;
}
SIZE: 88


-Mike


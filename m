Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab1E1LXy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 07:23:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1E1LXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 07:23:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ECzP1+xbqPMDvvpZt5Wlx/zMRL3aUE3QgXYcFC4H8hAGkJULNHUfrDla0W6imLZk0F
         u4wK7Fp+0tcDt11iC4Dr6hhkE6GVte1KXt+OFelOKI9HsFwPGFw4RvSOr4QV9UvCQ54P
         hV4/tAGjfKf3ggIQ67xPKB35tnpOt9roI6ToY=
Date: Sat, 28 May 2011 13:23:42 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] debugobjects: fix boot crash when both kmemleak and
 debugobjects are enabled (was: Re: early kernel crash when kmemleak is
 enabled)
Message-ID: <20110528112342.GA3068@joi.lan>
References: <20110515105505.GA21631@joi.lan>
 <20110519134218.GH627@htj.dyndns.org>
 <1305812924.26710.41.camel@e102109-lin.cambridge.arm.com>
 <20110519135425.GI627@htj.dyndns.org>
 <1305814133.26710.69.camel@e102109-lin.cambridge.arm.com>
 <20110527202503.GA2769@joi.lan>
 <alpine.LFD.2.02.1105272236050.3078@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105272236050.3078@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:37:54PM +0200, Thomas Gleixner wrote:
> On Fri, 27 May 2011, Marcin Slusarz wrote:
> > On Thu, May 19, 2011 at 03:08:53PM +0100, Catalin Marinas wrote:
> > > On Thu, 2011-05-19 at 14:54 +0100, Tejun Heo wrote:
> > > > On Thu, May 19, 2011 at 02:48:44PM +0100, Catalin Marinas wrote:
> > > > > Thanks for tracking this down. Untested (I can add a log afterwards):
> > > > >
> > > > > diff --git a/init/main.c b/init/main.c
> > > > > index 4a9479e..48df882 100644
> > > > > --- a/init/main.c
> > > > > +++ b/init/main.c
> > > > > @@ -580,8 +580,8 @@ asmlinkage void __init start_kernel(void)
> > > > >  #endif
> > > > >       page_cgroup_init();
> > > > >       enable_debug_pagealloc();
> > > > > -     kmemleak_init();
> > > > >       debug_objects_mem_init();
> > > > > +     kmemleak_init();
> > > > >       setup_per_cpu_pageset();
> > > > >       numa_policy_init();
> > > > >       if (late_time_init)
> > > > 
> > > > Heh, that was swift.  Yeap, seems to work here.  Please feel free to
> > > > add my Tested-by.
> > > 
> > > Thanks. I have two other minor kmemleak fixes, so I'll send Linus a pull
> > > request in the next day or so.
> > > 
> > 
> > With this patch applied kernel didn't panic, but kmemleak did not work either:
> > 
> > kmemleak: Early log buffer exceeded, please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
> > kmemleak: Kernel memory leak detector disabled
> > 
> > I increased DEBUG_KMEMLEAK_EARLY_LOG_SIZE from 400 to 1000, and it crashed in
> > exactly the same way:
> 
> ...
>  
> > The problem is: debugobjects want to use workqueues (system_wq actually), but they
> > are initialized much later in a boot process.
> > 
> > Attached patch fixes this issue for me.
> > 
> > 
> > diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> > index 9d86e45..a78b7c6 100644
> > --- a/lib/debugobjects.c
> > +++ b/lib/debugobjects.c
> > @@ -198,7 +198,7 @@ static void free_object(struct debug_obj *obj)
> >  	 * initialized:
> >  	 */
> >  	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
> > -		sched = !work_pending(&debug_obj_work);
> > +		sched = keventd_up() && !work_pending(&debug_obj_work);
> >  	hlist_add_head(&obj->node, &obj_pool);
> >  	obj_pool_free++;
> >  	obj_pool_used--;
> > 
> 
> Sigh, yes. Care to resend with changelog and signed-off-by ?
> 

Sure.

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] debugobjects: fix boot crash when both kmemleak and debugobjects are enabled

order of initialization look like this:

...
debugobjects
kmemleak
...(lots of other subsystems)...
workqueues (through early initcall)
...

debugobjects use schedule_work for batch freeing of its data and kmemleak
heavily use debugobjects, so when it comes to freeing and workqueues were
not initialized yet, kernel crashes:

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff810854d1>] __queue_work+0x29/0x41a
PGD 0
Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
(...)
Pid: 1, comm: swapper Not tainted 2.6.39-rc4-nv+ #721 Bochs Bochs
RIP: 0010:[<ffffffff810854d1>]  [<ffffffff810854d1>] __queue_work+0x29/0x41a
(...)
Call Trace:
 <IRQ>
 [<ffffffff81085910>] queue_work_on+0x16/0x1d
 [<ffffffff81085abc>] queue_work+0x29/0x55
 [<ffffffff81085afb>] schedule_work+0x13/0x15
 [<ffffffff81242de1>] free_object+0x90/0x95
 [<ffffffff81242f6d>] debug_check_no_obj_freed+0x187/0x1d3
 [<ffffffff814b6504>] ? _raw_spin_unlock_irqrestore+0x30/0x4d
 [<ffffffff8110bd14>] ? free_object_rcu+0x68/0x6d
 [<ffffffff8110890c>] kmem_cache_free+0x64/0x12c
 [<ffffffff8110bd14>] free_object_rcu+0x68/0x6d
 [<ffffffff810b58bc>] __rcu_process_callbacks+0x1b6/0x2d9
 [<ffffffff81095c9f>] ? tick_handle_periodic+0x1f/0x6c
 [<ffffffff810b5a5a>] rcu_process_callbacks+0x7b/0x83
 [<ffffffff810733b2>] __do_softirq+0x117/0x207
 [<ffffffff810b05d3>] ? handle_irq_event+0x47/0x5c
 [<ffffffff814bd0cc>] call_softirq+0x1c/0x30
 [<ffffffff81034bc4>] do_softirq+0x38/0x80
 [<ffffffff810730ed>] irq_exit+0x4e/0xa0
 [<ffffffff8103429a>] do_IRQ+0x97/0xae
 [<ffffffff814b6853>] common_interrupt+0x13/0x13
 <EOI>
 [<ffffffff8123d25f>] ? delay_tsc+0x48/0xcb
 [<ffffffff8123d32a>] __const_udelay+0x25/0x27
 [<ffffffff81aaae16>] timer_irq_works+0x3c/0x77
 [<ffffffff81aab422>] setup_IO_APIC+0x337/0x755
 [<ffffffff81aa956c>] native_smp_prepare_cpus+0x3a0/0x451
 [<ffffffff814b64b9>] ? _raw_spin_unlock_irq+0x19/0x34
 [<ffffffff81a9e52b>] kernel_init+0x4e/0x135
 [<ffffffff8123e0fe>] ? trace_hardirqs_on_thunk+0x3a/0x3c
 [<ffffffff814bcfd4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81063d70>] ? finish_task_switch+0x5a/0xcb
 [<ffffffff814b64b9>] ? _raw_spin_unlock_irq+0x19/0x34
 [<ffffffff814b68b1>] ? retint_restore_args+0xe/0xe
 [<ffffffff81a9e4dd>] ? parse_early_options+0x20/0x20
 [<ffffffff814bcfd0>] ? gs_change+0xb/0xb
Code: c9 c3 55 48 89 e5 41 57 41 56 41 55 49 89 f5 41 54 48 c7 c6 a0 b7 a3 81 53 41 89 fc 48 83 ec 28 48 89 d3 48 89 d7 e8 63 d7 1b 00
 f6 45 00 40 0f 84 6b 01 00 00 b8 09 00 00 00 83 3d 28 10 a0
RIP  [<ffffffff810854d1>] __queue_work+0x29/0x41a
 RSP <ffff880007c03c90>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Fatal exception in interrupt

...because system_wq is NULL.

Fix it by checking if workqueues susbystem was initialized before using.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: stable@kernel.org
---
 lib/debugobjects.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 9d86e45..a78b7c6 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -198,7 +198,7 @@ static void free_object(struct debug_obj *obj)
 	 * initialized:
 	 */
 	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = !work_pending(&debug_obj_work);
+		sched = keventd_up() && !work_pending(&debug_obj_work);
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;
-- 
1.7.4.1

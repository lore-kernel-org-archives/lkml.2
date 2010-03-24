Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0CXMXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab0CXMXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:23:04 -0400
Date: Wed, 24 Mar 2010 17:49:02 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Anton Blanchard <anton@samba.org>,
       tglx@linutronix.de, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100324121902.GJ15789@amit-x200.redhat.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <20100321043725.GA21566@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100321043725.GA21566@amit-x200.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Sun) Mar 21 2010 [10:07:25], Amit Shah wrote:
> On (Sun) Mar 21 2010 [08:04:39], Benjamin Herrenschmidt wrote:
> > On Fri, 2010-03-19 at 08:18 -0700, Greg Kroah-Hartman wrote:
> > > From: Amit Shah <amit.shah@redhat.com>
> > > 
> > > Alan pointed out a race in the code where hvc_remove is invoked. The
> > > recent virtio_console work is the first user of hvc_remove().
> > 
> > This causes hangs during boot on pseries machines. Haven't had a chance
> > to track that down yet, but please revert
> > e74d098c66543d0731de62eb747ccd5b636a6f4c for now.
> 
> I tested this with the virtio-console driver with multiple consoles on
> Linux-2.6.34-rc2 inside a KVM VM. I didn't face any lockups / badness,
> but the following popped up once on -smp 4.
> 
> Could this be the same bug that's causing a lockup for you?
> 
> Since the virtio-console isn't the primary console on my VM, I didn't
> see a lockup but maybe powerpc uses this as the primary console and the
> lockup is a result of this?
> 
> I've not investigated this; I might get around to it next week, but
> CC'ing the sched people on this one.

I just looked at this:

> (My .config is after the oops.)
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff8101f4dc>] task_is_waking+0x1/0x1f
> PGD 3d261067 PUD 3d013067 PMD 0 
> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> last sysfs file: /sys/devices/virtual/block/ram13/removable
> CPU 0 
> Modules linked in:
> 
> Pid: 573, comm: console_check Not tainted 2.6.34-rc2 #102 /Bochs
> RIP: 0010:[<ffffffff8101f4dc>]  [<ffffffff8101f4dc>]
> task_is_waking+0x1/0x1f
> RSP: 0018:ffff88003bdf5b48  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81646e30
> RDX: ffff88003bdf5b78 RSI: ffff88003bdf5ba0 RDI: 0000000000000000
> RBP: ffff88003bdf5b78 R08: 0000000000000000 R09: ffffffff81646e08
> R10: 0000000000000046 R11: 0000000000001130 R12: 00000000001d1d00
> R13: 0000000000000000 R14: ffff88003bdf5ba0 R15: 000000000000000f
> FS:  00007f330731b6f0(0000) GS:ffff880003800000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000003be78000 CR4: 00000000000006b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process console_check (pid: 573, threadinfo ffff88003bdf4000, task
> ffff88003bc3a2d0)
> Stack:
>  ffff88003bdf5b78 ffffffff8102058e 0000000000000000 0000000000000000
> <0> 0000000000000000 0000000000000000 ffff88003bdf5bd8 ffffffff81026f03
> <0> ffff88003ead8cd8 ffff88003eb10490 ffff88003bdf5bd8 ffffffff8118cea9
> Call Trace:
>  [<ffffffff8102058e>] ? task_rq_lock+0x24/0x98
>  [<ffffffff81026f03>] try_to_wake_up+0x4b/0x33b
>  [<ffffffff8118cea9>] ? resize_console+0x25/0x95
>  [<ffffffff8102721f>] wake_up_process+0x10/0x12
>  [<ffffffff8118c18e>] hvc_kick+0x1a/0x1c
>  [<ffffffff8118cbb4>] hvc_open+0xf6/0x102

And this suggests that hvc_kick() is called before hvc_task is
initialised, ie, before hvc_init() is called.

Does this help?

diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index ba55bba..50ac983 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -285,6 +285,9 @@ EXPORT_SYMBOL_GPL(hvc_instantiate);
 /* Wake the sleeping khvcd */
 void hvc_kick(void)
 {
+       if (!hvc_task)
+               return;
+
        hvc_kicked = 1;
        wake_up_process(hvc_task);
 }

		Amit

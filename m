Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2ASBkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:40:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:58164 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab2ASBkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:40:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113807735"
Subject: [patch]block: fix NULL icq_cache reference
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20120118160713.GA30664@google.com>
References: <20120117201823.GD19223@redhat.com>
	 <20120117214834.GD26207@google.com> <20120117220715.GB23527@redhat.com>
	 <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com>
	 <20120118010323.GA32160@htj.dyndns.org>
	 <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com>
	 <20120118011112.GB32160@htj.dyndns.org>
	 <1326850253.22361.619.camel@sli10-conroe>
	 <1326866602.22361.624.camel@sli10-conroe>
	 <20120118160713.GA30664@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 09:41:34 +0800
Message-ID: <1326937294.22361.649.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 08:07 -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 18, 2012 at 02:03:22PM +0800, Shaohua Li wrote:
> > Subject: block: fix NULL icq_cache reference
> > 
> > CPU0:					CPU1:
> > 					switch from cfq to noop
> > 					   elv_quiesce_start
> > C: get_request
> > A:   ioc_create_icq
> >       alloc icq with cfq
> > 					   B: do elevator switch
> > 					       ioc_clear_queue
> > 					   elv_quiesce_end
> >       insert icq to ioc
> > 					switch from noop to cfq
> > 					    elv_quiesce_start
> > 					    do elevator switch
> > 					       ioc_clear_queue
> > 					    elv_quiesce_end
> > CPU0 leaves some icq to ioc list after elevator is switching from cfq to noop.
> > in the second ioc_clear_queue, the ioc has icq in its list, but current
> > elevator is noop. so ioc_exit_icq will get a NULL et->icq_cache.
> > 
> > In above cases, if A runs after B, ioc_create_icq will have a NULL
> > et->icq_cache, this will trigger another crash.
> > 
> > Note, get_request caches et without lock hold. Between C and A, a elevator
> > switch can start. But we will have elvpriv++, elv_quiesce_start will drain
> > all requests first. So this will not trigger crash.
> 
> Thanks a lot for tracking it down.
> 
> Hmmm... but I'm having a difficult time following the description.
> Maybe we can simplify a bit?  e.g. sth like the following?
> 
>   Once a queue is quiesced, it's not supposed to have any elvpriv data
>   or icq's, and elevator switching depends on that.  Request alloc
>   path followed the rule for elvpriv data but forgot apply it to
>   icq's leading to the following crash during elevator switch.
> 
>   <oops log>
> 
>   Fix it by not allocating icq's if ELVPRIV is not set for the
>   request.
I'm trying to explain why there is a crash, but fine to use your
description.

> > Index: linux/block/blk-core.c
> > ===================================================================
> > --- linux.orig/block/blk-core.c	2012-01-18 12:44:13.000000000 +0800
> > +++ linux/block/blk-core.c	2012-01-18 12:45:28.000000000 +0800
> > @@ -872,11 +872,11 @@ retry:
> >  	spin_unlock_irq(q->queue_lock);
> >  
> >  	/* create icq if missing */
> > -	if (unlikely(et->icq_cache && !icq))
> > +	if (unlikely(et->icq_cache && !icq && (rw_flags & REQ_ELVPRIV)))
> >  		icq = ioc_create_icq(q, gfp_mask);
> >  
> >  	/* rqs are guaranteed to have icq on elv_set_request() if requested */
> > -	if (likely(!et->icq_cache || icq))
> > +	if (likely(!et->icq_cache || icq || !(rw_flags & REQ_ELVPRIV)))
> >  		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
> 
> Hmmm... I was trying to avoid adding a goto label with the double
> testing but with REQ_ELVPRIV test added, it looks more confusing.
> Maybe something like the following is better?
> 
> 	/* rqs are guaranteed to have icq on elv_set_request() if requested */
> 	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
> 		icq = ioc_create_icq(q, gfp_mask);
> 		if (!icq)
> 			goto fail_icq;
> 	}
> 	rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
>  fail_icq:
this is ok.

Subject: block: fix NULL icq_cache reference

Vivek reported a kernel crash:
[   94.217015] BUG: unable to handle kernel NULL pointer dereference at 000000000000001c
[   94.218004] IP: [<ffffffff81142fae>] kmem_cache_free+0x5e/0x200
[   94.218004] PGD 13abda067 PUD 137d52067 PMD 0
[   94.218004] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   94.218004] CPU 0
[   94.218004] Modules linked in: [last unloaded: scsi_wait_scan]
[   94.218004]
[   94.218004] Pid: 0, comm: swapper/0 Not tainted 3.2.0+ #16 Hewlett-Packard HP xw6600 Workstation/0A9Ch
[   94.218004] RIP: 0010:[<ffffffff81142fae>]  [<ffffffff81142fae>] kmem_cache_free+0x5e/0x200
[   94.218004] RSP: 0018:ffff88013fc03de0  EFLAGS: 00010006
[   94.218004] RAX: ffffffff81e0d020 RBX: ffff880138b3c680 RCX: 00000001801c001b
[   94.218004] RDX: 00000000003aac1d RSI: ffff880138b3c680 RDI: ffffffff81142fae
[   94.218004] RBP: ffff88013fc03e10 R08: ffff880137830238 R09: 0000000000000001
[   94.218004] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[   94.218004] R13: ffffea0004e2cf00 R14: ffffffff812f6eb6 R15: 0000000000000246
[   94.218004] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
[   94.218004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   94.218004] CR2: 000000000000001c CR3: 00000001395ab000 CR4: 00000000000006f0
[   94.218004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   94.218004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   94.218004] Process swapper/0 (pid: 0, threadinfo ffffffff81e00000, task ffffffff81e0d020)
[   94.218004] Stack:
[   94.218004]  0000000000000102 ffff88013fc0db20 ffffffff81e22700 ffff880139500f00
[   94.218004]  0000000000000001 000000000000000a ffff88013fc03e20 ffffffff812f6eb6
[   94.218004]  ffff88013fc03e90 ffffffff810c8da2 ffffffff81e01fd8 ffff880137830240
[   94.218004] Call Trace:
[   94.218004]  <IRQ>
[   94.218004]  [<ffffffff812f6eb6>] icq_free_icq_rcu+0x16/0x20
[   94.218004]  [<ffffffff810c8da2>] __rcu_process_callbacks+0x1c2/0x420
[   94.218004]  [<ffffffff810c9038>] rcu_process_callbacks+0x38/0x250
[   94.218004]  [<ffffffff810405ee>] __do_softirq+0xce/0x3e0
[   94.218004]  [<ffffffff8108ed04>] ? clockevents_program_event+0x74/0x100
[   94.218004]  [<ffffffff81090104>] ? tick_program_event+0x24/0x30
[   94.218004]  [<ffffffff8183ed1c>] call_softirq+0x1c/0x30
[   94.218004]  [<ffffffff8100422d>] do_softirq+0x8d/0xc0
[   94.218004]  [<ffffffff81040c3e>] irq_exit+0xae/0xe0
[   94.218004]  [<ffffffff8183f4be>] smp_apic_timer_interrupt+0x6e/0x99
[   94.218004]  [<ffffffff8183e330>] apic_timer_interrupt+0x70/0x80

Once a queue is quiesced, it's not supposed to have any elvpriv data or
icq's, and elevator switching depends on that.  Request alloc path
followed the rule for elvpriv data but forgot apply it to icq's
leading to the following crash during elevator switch. Fix it by not
allocating icq's if ELVPRIV is not set for the request.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Tested-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2012-01-19 08:41:01.000000000 +0800
+++ linux/block/blk-core.c	2012-01-19 08:49:06.000000000 +0800
@@ -872,13 +872,15 @@ retry:
 	spin_unlock_irq(q->queue_lock);
 
 	/* create icq if missing */
-	if (unlikely(et->icq_cache && !icq))
+	if ((rw_flags & REQ_ELVPRIV) && unlikely(et->icq_cache && !icq)) {
 		icq = ioc_create_icq(q, gfp_mask);
+		if (!icq)
+			goto fail_icq;
+	}
 
-	/* rqs are guaranteed to have icq on elv_set_request() if requested */
-	if (likely(!et->icq_cache || icq))
-		rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
+	rq = blk_alloc_request(q, icq, rw_flags, gfp_mask);
 
+fail_icq:
 	if (unlikely(!rq)) {
 		/*
 		 * Allocation failed presumably due to memory. Undo anything




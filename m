Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238Ab1ESNsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:48:55 -0400
Received: from service87.mimecast.com ([94.185.240.25]:40434 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932671Ab1ESNsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:48:54 -0400
Subject: Re: early kernel crash when kmemleak is enabled
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110519134218.GH627@htj.dyndns.org>
References: <20110515105505.GA21631@joi.lan>
	 <20110519134218.GH627@htj.dyndns.org>
Organization: ARM Limited
Date: Thu, 19 May 2011 14:48:44 +0100
Message-ID: <1305812924.26710.41.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 19 May 2011 13:48:51.0107 (UTC) FILETIME=[7C42F730:01CC162B]
X-MC-Unique: 111051914485002901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 14:42 +0100, Tejun Heo wrote:
> Hello,
> 
> On Sun, May 15, 2011 at 12:55:05PM +0200, Marcin Slusarz wrote:
> > [    0.100047] BUG: unable to handle kernel NULL pointer dereference at           (null)
> > [    0.101416] IP: [<ffffffff810854d1>] __queue_work+0x29/0x41a
> ...
> > [    0.110000] Call Trace:
> > [    0.110000]  <IRQ>
> > [    0.110000]  [<ffffffff81085910>] queue_work_on+0x16/0x1d
> > [    0.110000]  [<ffffffff81085abc>] queue_work+0x29/0x55
> > [    0.110000]  [<ffffffff81085afb>] schedule_work+0x13/0x15
> > [    0.110000]  [<ffffffff81242de1>] free_object+0x90/0x95
> > [    0.110000]  [<ffffffff81242f6d>] debug_check_no_obj_freed+0x187/0x1d3
> > [    0.110000]  [<ffffffff814b6504>] ? _raw_spin_unlock_irqrestore+0x30/0x4d
> > [    0.110000]  [<ffffffff8110bd14>] ? free_object_rcu+0x68/0x6d
> > [    0.110000]  [<ffffffff8110890c>] kmem_cache_free+0x64/0x12c
> > [    0.110000]  [<ffffffff8110bd14>] free_object_rcu+0x68/0x6d
> > [    0.110000]  [<ffffffff810b58bc>] __rcu_process_callbacks+0x1b6/0x2d9
> > [    0.110000]  [<ffffffff81095c9f>] ? tick_handle_periodic+0x1f/0x6c
> > [    0.110000]  [<ffffffff810b5a5a>] rcu_process_callbacks+0x7b/0x83
> > [    0.110000]  [<ffffffff810733b2>] __do_softirq+0x117/0x207
> > [    0.110000]  [<ffffffff810b05d3>] ? handle_irq_event+0x47/0x5c
> > [    0.110000]  [<ffffffff814bd0cc>] call_softirq+0x1c/0x30
> > [    0.110000]  [<ffffffff81034bc4>] do_softirq+0x38/0x80
> > [    0.110000]  [<ffffffff810730ed>] irq_exit+0x4e/0xa0
> > [    0.110000]  [<ffffffff8103429a>] do_IRQ+0x97/0xae
> > [    0.110000]  [<ffffffff814b6853>] common_interrupt+0x13/0x13
> 
> I can reproduce this reliably with your config too.  From a quick
> glance, the cause seems to be debug objects using RCU callback
> free_object() to free objects, which ends up being called before
> workqueue is initialized.  The offending object type is "rcu_head" and
> turning off CONFIG_DEBUG_OBJECTS_RCU_HEAD makes the problem go away.
> 
> Any ideas on how to fix this?

Thanks for tracking this down. Untested (I can add a log afterwards):

diff --git a/init/main.c b/init/main.c
index 4a9479e..48df882 100644
--- a/init/main.c
+++ b/init/main.c
@@ -580,8 +580,8 @@ asmlinkage void __init start_kernel(void)
 #endif
 	page_cgroup_init();
 	enable_debug_pagealloc();
-	kmemleak_init();
 	debug_objects_mem_init();
+	kmemleak_init();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)

-- 
Catalin



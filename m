Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1G0V4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:56:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:16729 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab1G0VtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,279,1309762800"; 
   d="scan'208";a="32826540"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: marcin.slusarz@gmail.com, catalin.marinas@arm.com, tj@kernel.org,
        dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com, ak@linux.intel.com,
        tglx@linutronix.de, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [76/99] debugobjects: Fix boot crash when kmemleak and debugobjects enabled
Message-Id: <20110727214915.A769F2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 161b6ae0e067e421b20bb35caf66bdb405c929ac upstream.

Order of initialization look like this:
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
...

because system_wq is NULL.

Fix it by checking if workqueues susbystem was initialized before using.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/20110528112342.GA3068@joi.lan
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/debugobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/lib/debugobjects.c
===================================================================
--- linux-2.6.35.y.orig/lib/debugobjects.c
+++ linux-2.6.35.y/lib/debugobjects.c
@@ -198,7 +198,7 @@ static void free_object(struct debug_obj
 	 * initialized:
 	 */
 	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = !work_pending(&debug_obj_work);
+		sched = keventd_up() && !work_pending(&debug_obj_work);
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;

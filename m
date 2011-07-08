Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1GHFEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:04:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1GHFEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:04:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:59 2011
Message-Id: <20110708001659.851819021@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [073/107] debugobjects: Fix boot crash when kmemleak and debugobjects enabled
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
Link: http://lkml.kernel.org/r/20110528112342.GA3068@joi.lan
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/debugobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -198,7 +198,7 @@ static void free_object(struct debug_obj
 	 * initialized:
 	 */
 	if (obj_pool_free > ODEBUG_POOL_SIZE && obj_cache)
-		sched = !work_pending(&debug_obj_work);
+		sched = keventd_up() && !work_pending(&debug_obj_work);
 	hlist_add_head(&obj->node, &obj_pool);
 	obj_pool_free++;
 	obj_pool_used--;



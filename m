Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1FTMns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:43:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:36468 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816Ab1FTMnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:43:45 -0400
Date: Mon, 20 Jun 2011 12:43:01 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Message-ID: <tip-161b6ae0e067e421b20bb35caf66bdb405c929ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        catalin.marinas@arm.com, marcin.slusarz@gmail.com,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, dipankar@in.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, marcin.slusarz@gmail.com,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, dipankar@in.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20110528112342.GA3068@joi.lan>
References: <20110528112342.GA3068@joi.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] debugobjects: Fix boot crash when kmemleak and debugobjects enabled
Git-Commit-ID: 161b6ae0e067e421b20bb35caf66bdb405c929ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 20 Jun 2011 12:43:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  161b6ae0e067e421b20bb35caf66bdb405c929ac
Gitweb:     http://git.kernel.org/tip/161b6ae0e067e421b20bb35caf66bdb405c929ac
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Sat, 28 May 2011 13:23:42 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 20 Jun 2011 14:38:43 +0200

debugobjects: Fix boot crash when kmemleak and debugobjects enabled

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
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/20110528112342.GA3068@joi.lan
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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

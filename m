Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2IDX6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:58:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36557 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2IDX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:58:19 -0400
Date: Tue, 4 Sep 2012 16:58:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH -stable] workqueue: UNBOUND -> REBIND morphing in
 rebind_workers() should be atomic
Message-ID: <20120904235812.GA2836@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-2-git-send-email-laijs@cn.fujitsu.com>
 <20120904233901.GC9092@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904233901.GC9092@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The compiler may compile the following code into TWO write/modify
instructions.

        worker->flags &= ~WORKER_UNBOUND;
        worker->flags |= WORKER_REBIND;

so the other CPU may temporarily see worker->flags which doesn't have
either WORKER_UNBOUND or WORKER_REBIND set and perform local wakeup
prematurely.

Fix it by using single explicit assignment via ACCESS_ONCE().

Because idle workers have another WORKER_NOT_RUNNING flag, this bug
doesn't exist for them; however, update it to use the same pattern for
consistency.

tj: Applied the change to idle workers too and updated comments and
    patch description a bit.

stable: Idle worker rebinding doesn't apply for -stable and
        WORKER_UNBOUND used to be WORKER_ROGUE.  Updated accordingly.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/workqueue.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9a3128d..d7eb05a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3441,14 +3441,17 @@ static int __cpuinit trustee_thread(void *__gcwq)
 
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
+		unsigned long worker_flags = worker->flags;
 
 		/*
 		 * Rebind_work may race with future cpu hotplug
 		 * operations.  Use a separate flag to mark that
-		 * rebinding is scheduled.
+		 * rebinding is scheduled.  The morphing should
+		 * be atomic.
 		 */
-		worker->flags |= WORKER_REBIND;
-		worker->flags &= ~WORKER_ROGUE;
+		worker_flags |= WORKER_REBIND;
+		worker_flags &= ~WORKER_ROGUE;
+		ACCESS_ONCE(worker->flags) = worker_flags;
 
 		/* queue rebind_work, wq doesn't matter, use the default one */
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2IQBNP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:13:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33691 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753674Ab2IQAua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:30 -0400
Message-Id: <20120917003636.724493257@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 076/135] workqueue: UNBOUND -> REBIND morphing in  rebind_workers() should be atomic
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 96e65306b81351b656835c15931d1d237b252f27 upstream.

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



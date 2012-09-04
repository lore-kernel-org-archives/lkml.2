Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2IDXjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:39:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53450 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2IDXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:39:06 -0400
Date: Tue, 4 Sep 2012 16:39:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] workqueue: UNBOUND -> REBIND morphing in rebind_workers()
 should be atomic
Message-ID: <20120904233901.GC9092@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346516916-1991-1-git-send-email-laijs@cn.fujitsu.com>
 <1346516916-1991-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346516916-1991-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d2ae38fc5e37b4bca3c4bec04a10dcf861a77b2b Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Sun, 2 Sep 2012 00:28:19 +0800

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

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
Applied to wq/for-3.6-fixes with some modifications.  Greg, this won't
apply cleanly to -stable.  Will post the backported version as a reply
to this message.

Thanks!

 kernel/workqueue.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..c462cd6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1396,12 +1396,15 @@ retry:
 	/* set REBIND and kick idle ones, we'll wait for these later */
 	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry) {
+			unsigned long worker_flags = worker->flags;
+
 			if (worker->flags & WORKER_REBIND)
 				continue;
 
-			/* morph UNBOUND to REBIND */
-			worker->flags &= ~WORKER_UNBOUND;
-			worker->flags |= WORKER_REBIND;
+			/* morph UNBOUND to REBIND atomically */
+			worker_flags &= ~WORKER_UNBOUND;
+			worker_flags |= WORKER_REBIND;
+			ACCESS_ONCE(worker->flags) = worker_flags;
 
 			idle_rebind.cnt++;
 			worker->idle_rebind = &idle_rebind;
@@ -1434,10 +1437,12 @@ retry:
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
+		unsigned long worker_flags = worker->flags;
 
-		/* morph UNBOUND to REBIND */
-		worker->flags &= ~WORKER_UNBOUND;
-		worker->flags |= WORKER_REBIND;
+		/* morph UNBOUND to REBIND atomically */
+		worker_flags &= ~WORKER_UNBOUND;
+		worker_flags |= WORKER_REBIND;
+		ACCESS_ONCE(worker->flags) = worker_flags;
 
 		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
 				     work_data_bits(rebind_work)))
-- 
1.7.7.3


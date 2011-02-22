Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1BVW3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:29:36 -0500
Received: from kroah.org ([198.145.64.141]:46773 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723Ab1BVWV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:40 2011
Message-Id: <20110222221840.910458675@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>
Subject: [39/70] workqueue: wake up a worker when a rescuer is leaving a gcwq
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 7576958a9d5a4a677ad7dd40901cdbb6c1110c98 upstream.

After executing the matching works, a rescuer leaves the gcwq whether
there are more pending works or not.  This may decrease the
concurrency level to zero and stall execution until a new work item is
queued on the gcwq.

Make rescuer wake up a regular worker when it leaves a gcwq if there
are more works to execute, so that execution isn't stalled.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/workqueue.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2009,6 +2009,15 @@ repeat:
 				move_linked_works(work, scheduled, &n);
 
 		process_scheduled_works(rescuer);
+
+		/*
+		 * Leave this gcwq.  If keep_working() is %true, notify a
+		 * regular worker; otherwise, we end up with 0 concurrency
+		 * and stalling the execution.
+		 */
+		if (keep_working(gcwq))
+			wake_up_worker(gcwq);
+
 		spin_unlock_irq(&gcwq->lock);
 	}
 



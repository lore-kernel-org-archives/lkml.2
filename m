Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab1EFATt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:19:49 -0400
Received: from kroah.org ([198.145.64.141]:32800 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404Ab1EFANR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:17 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:08 2011
Message-Id: <20110506001208.154973745@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>
Subject: [patch 09/38] workqueue: fix deadlock in worker_maybe_bind_and_lock()
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 5035b20fa5cd146b66f5f89619c20a4177fb736d upstream.

If a rescuer and stop_machine() bringing down a CPU race with each
other, they may deadlock on non-preemptive kernel.  The CPU won't
accept a new task, so the rescuer can't migrate to the target CPU,
while stop_machine() can't proceed because the rescuer is holding one
of the CPU retrying migration.  GCWQ_DISASSOCIATED is never cleared
and worker_maybe_bind_and_lock() retries indefinitely.

This problem can be reproduced semi reliably while the system is
entering suspend.

 http://thread.gmane.org/gmane.linux.kernel/1122051

A lot of kudos to Thilo-Alexander for reporting this tricky issue and
painstaking testing.

stable: This affects all kernels with cmwq, so all kernels since and
        including v2.6.36 need this fix.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Tested-by: Thilo-Alexander Ginkel <thilo@ginkel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/workqueue.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1283,8 +1283,14 @@ __acquires(&gcwq->lock)
 			return true;
 		spin_unlock_irq(&gcwq->lock);
 
-		/* CPU has come up inbetween, retry migration */
+		/*
+		 * We've raced with CPU hot[un]plug.  Give it a breather
+		 * and retry migration.  cond_resched() is required here;
+		 * otherwise, we might deadlock against cpu_stop trying to
+		 * bring down the CPU on non-preemptive kernel.
+		 */
 		cpu_relax();
+		cond_resched();
 	}
 }
 



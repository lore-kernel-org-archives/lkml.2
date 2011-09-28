Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1I1XIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:08:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab1I1Wpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:45:49 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.839085793@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Tuttle <ttuttle@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: [128/244] workqueue: lock cwq access in drain_workqueue
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Tuttle <ttuttle@chromium.org>

commit fa2563e41c3d6d6e8af437643981ed28ae0cb56d upstream.

Take cwq->gcwq->lock to avoid racing between drain_workqueue checking to
make sure the workqueues are empty and cwq_dec_nr_in_flight decrementing
and then incrementing nr_active when it activates a delayed work.

We discovered this when a corner case in one of our drivers resulted in
us trying to destroy a workqueue in which the remaining work would
always requeue itself again in the same workqueue.  We would hit this
race condition and trip the BUG_ON on workqueue.c:3080.

Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/workqueue.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3026,8 +3026,13 @@ reflush:
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		bool drained;
 
-		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
+		spin_lock_irq(&cwq->gcwq->lock);
+		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
+		spin_unlock_irq(&cwq->gcwq->lock);
+
+		if (drained)
 			continue;
 
 		if (++flush_cnt == 10 ||



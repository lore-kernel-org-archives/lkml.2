Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1KCBgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355Ab1KCBgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.102373825@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: [087/107] cfq: change the meaning of the cfqq_coop flag
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Jeff Moyer <jmoyer@redhat.com>

commit b3b6d0408c953524f979468562e7e210d8634150 upstream

The flag used to indicate that a cfqq was allowed to jump ahead in the
scheduling order due to submitting a request close to the queue that
just executed.  Since closely cooperating queues are now merged, the flag
holds little meaning.  Change it to indicate that multiple queues were
merged.  This will later be used to allow the breaking up of merged queues
when they are no longer cooperating.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -202,7 +202,7 @@ enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_prio_changed,	/* task priority has changed */
 	CFQ_CFQQ_FLAG_slice_new,	/* no requests dispatched in slice */
 	CFQ_CFQQ_FLAG_sync,		/* synchronous queue */
-	CFQ_CFQQ_FLAG_coop,		/* has done a coop jump of the queue */
+	CFQ_CFQQ_FLAG_coop,		/* cfqq is shared */
 	CFQ_CFQQ_FLAG_coop_preempt,	/* coop preempt */
 };
 
@@ -952,11 +952,8 @@ static struct cfq_queue *cfq_get_next_qu
 static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd,
 					      struct cfq_queue *cfqq)
 {
-	if (!cfqq) {
+	if (!cfqq)
 		cfqq = cfq_get_next_queue(cfqd);
-		if (cfqq && !cfq_cfqq_coop_preempt(cfqq))
-			cfq_clear_cfqq_coop(cfqq);
-	}
 
 	if (cfqq)
 		cfq_clear_cfqq_coop_preempt(cfqq);
@@ -1040,8 +1037,7 @@ static struct cfq_queue *cfqq_close(stru
  * assumption.
  */
 static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
-					      struct cfq_queue *cur_cfqq,
-					      bool probe)
+					      struct cfq_queue *cur_cfqq)
 {
 	struct cfq_queue *cfqq;
 
@@ -1060,11 +1056,6 @@ static struct cfq_queue *cfq_close_coope
 	if (!cfq_cfqq_sync(cfqq))
 		return NULL;
 
-	if (cfq_cfqq_coop(cfqq))
-		return NULL;
-
-	if (!probe)
-		cfq_mark_cfqq_coop(cfqq);
 	return cfqq;
 }
 
@@ -1248,7 +1239,7 @@ static struct cfq_queue *cfq_select_queu
 	 * cooperators and put the close queue at the front of the service
 	 * tree.  If possible, merge the expiring queue with the new cfqq.
 	 */
-	new_cfqq = cfq_close_cooperator(cfqd, cfqq, 0);
+	new_cfqq = cfq_close_cooperator(cfqd, cfqq);
 	if (new_cfqq) {
 		if (!cfqq->new_cfqq)
 			cfq_setup_merge(cfqq, new_cfqq);
@@ -2313,7 +2304,7 @@ static void cfq_completed_request(struct
 		 */
 		if (cfq_slice_used(cfqq) || cfq_class_idle(cfqq))
 			cfq_slice_expired(cfqd, 1);
-		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq, 1) &&
+		else if (cfqq_empty && !cfq_close_cooperator(cfqd, cfqq) &&
 			 sync && !rq_noidle(rq))
 			cfq_arm_slice_timer(cfqd);
 	}
@@ -2414,6 +2405,7 @@ cfq_merge_cfqqs(struct cfq_data *cfqd, s
 {
 	cfq_log_cfqq(cfqd, cfqq, "merging with queue %p", cfqq->new_cfqq);
 	cic_set_cfqq(cic, cfqq->new_cfqq, 1);
+	cfq_mark_cfqq_coop(cfqq->new_cfqq);
 	cfq_put_queue(cfqq);
 	return cic_to_cfqq(cic, 1);
 }



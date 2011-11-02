Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab1KCBgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:36:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933422Ab1KCBgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:36:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:58 2011
Message-Id: <20111102221458.014860210@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:14:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: [086/107] cfq: merge cooperating cfq_queues
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------


From: Jeff Moyer <jmoyer@redhat.com>

commit df5fe3e8e13883f58dc97489076bbcc150789a21 upstream.

When cooperating cfq_queues are detected currently, they are allowed to
skip ahead in the scheduling order.  It is much more efficient to
automatically share the cfq_queue data structure between cooperating processes.
Performance of the read-test2 benchmark (which is written to emulate the
dump(8) utility) went from 12MB/s to 90MB/s on my SATA disk.  NFS servers
with multiple nfsd threads also saw performance increases.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/cfq-iosched.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 2 deletions(-)

--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -118,6 +118,8 @@ struct cfq_queue {
 	sector_t last_request_pos;
 
 	pid_t pid;
+
+	struct cfq_queue *new_cfqq;
 };
 
 /*
@@ -1052,6 +1054,12 @@ static struct cfq_queue *cfq_close_coope
 	if (!cfqq)
 		return NULL;
 
+	/*
+	 * It only makes sense to merge sync queues.
+	 */
+	if (!cfq_cfqq_sync(cfqq))
+		return NULL;
+
 	if (cfq_cfqq_coop(cfqq))
 		return NULL;
 
@@ -1173,6 +1181,43 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd,
 }
 
 /*
+ * Must be called with the queue_lock held.
+ */
+static int cfqq_process_refs(struct cfq_queue *cfqq)
+{
+	int process_refs, io_refs;
+
+	io_refs = cfqq->allocated[READ] + cfqq->allocated[WRITE];
+	process_refs = atomic_read(&cfqq->ref) - io_refs;
+	BUG_ON(process_refs < 0);
+	return process_refs;
+}
+
+static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
+{
+	int process_refs;
+	struct cfq_queue *__cfqq;
+
+	/* Avoid a circular list and skip interim queue merges */
+	while ((__cfqq = new_cfqq->new_cfqq)) {
+		if (__cfqq == cfqq)
+			return;
+		new_cfqq = __cfqq;
+	}
+
+	process_refs = cfqq_process_refs(cfqq);
+	/*
+	 * If the process for the cfqq has gone away, there is no
+	 * sense in merging the queues.
+	 */
+	if (process_refs == 0)
+		return;
+
+	cfqq->new_cfqq = new_cfqq;
+	atomic_add(process_refs, &new_cfqq->ref);
+}
+
+/*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
  */
@@ -1201,11 +1246,14 @@ static struct cfq_queue *cfq_select_queu
 	 * If another queue has a request waiting within our mean seek
 	 * distance, let it run.  The expire code will check for close
 	 * cooperators and put the close queue at the front of the service
-	 * tree.
+	 * tree.  If possible, merge the expiring queue with the new cfqq.
 	 */
 	new_cfqq = cfq_close_cooperator(cfqd, cfqq, 0);
-	if (new_cfqq)
+	if (new_cfqq) {
+		if (!cfqq->new_cfqq)
+			cfq_setup_merge(cfqq, new_cfqq);
 		goto expire;
+	}
 
 	/*
 	 * No requests pending. If the active queue still has requests in
@@ -1516,11 +1564,29 @@ static void cfq_free_io_context(struct i
 
 static void cfq_exit_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
+	struct cfq_queue *__cfqq, *next;
+
 	if (unlikely(cfqq == cfqd->active_queue)) {
 		__cfq_slice_expired(cfqd, cfqq, 0);
 		cfq_schedule_dispatch(cfqd);
 	}
 
+	/*
+	 * If this queue was scheduled to merge with another queue, be
+	 * sure to drop the reference taken on that queue (and others in
+	 * the merge chain).  See cfq_setup_merge and cfq_merge_cfqqs.
+	 */
+	__cfqq = cfqq->new_cfqq;
+	while (__cfqq) {
+		if (__cfqq == cfqq) {
+			WARN(1, "cfqq->new_cfqq loop detected\n");
+			break;
+		}
+		next = __cfqq->new_cfqq;
+		cfq_put_queue(__cfqq);
+		__cfqq = next;
+	}
+
 	cfq_put_queue(cfqq);
 }
 
@@ -2342,6 +2408,16 @@ static void cfq_put_request(struct reque
 	}
 }
 
+static struct cfq_queue *
+cfq_merge_cfqqs(struct cfq_data *cfqd, struct cfq_io_context *cic,
+		struct cfq_queue *cfqq)
+{
+	cfq_log_cfqq(cfqd, cfqq, "merging with queue %p", cfqq->new_cfqq);
+	cic_set_cfqq(cic, cfqq->new_cfqq, 1);
+	cfq_put_queue(cfqq);
+	return cic_to_cfqq(cic, 1);
+}
+
 /*
  * Allocate cfq data structures associated with this request.
  */
@@ -2368,6 +2444,15 @@ cfq_set_request(struct request_queue *q,
 	if (!cfqq || cfqq == &cfqd->oom_cfqq) {
 		cfqq = cfq_get_queue(cfqd, is_sync, cic->ioc, gfp_mask);
 		cic_set_cfqq(cic, cfqq, is_sync);
+	} else {
+		/*
+		 * Check to see if this queue is scheduled to merge with
+		 * another, closely cooperating queue.  The merging of
+		 * queues happens here as it must be done in process context.
+		 * The reference on new_cfqq was taken in merge_cfqqs.
+		 */
+		if (cfqq->new_cfqq)
+			cfqq = cfq_merge_cfqqs(cfqd, cic, cfqq);
 	}
 
 	cfqq->allocated[rw]++;



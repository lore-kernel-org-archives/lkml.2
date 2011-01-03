Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab1ACNw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:52:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab1ACNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=FuxqiZJWhblMGp8xirCG+10vVHxOK+A/qbkUU1vkukI8MRVZfjhZ41zYoAoqRf4DjW
         NqayCjGK+KZHqbIHGgL9DuLLda8kIByo2sxatlEkHVCTHdfWfpyxKHjW08oEN28yThwB
         qWU6iF1AcBXi6MEDhm6zXhmSjgoxjTsG8SDwU=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org
Subject: [PATCH 23/32] net/ceph: make ceph_msgr_wq non-reentrant
Date: Mon,  3 Jan 2011 14:49:46 +0100
Message-Id: <1294062595-30097-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ceph messenger code does a rather complex dancing around multithread
workqueue to make sure the same work item isn't executed concurrently
on different CPUs.  This restriction can be provided by workqueue with
WQ_NON_REENTRANT.

Make ceph_msgr_wq non-reentrant workqueue with the default concurrency
level and remove the QUEUED/BUSY logic.

* This removes backoff handling in con_work() but it couldn't reliably
  block execution of con_work() to begin with - queue_con() can be
  called after the work started but before BUSY is set.  It seems that
  it was an optimization for a rather cold path and can be safely
  removed.

* The number of concurrent work items is bound by the number of
  connections and connetions are independent from each other.  With
  the default concurrency level, different connections will be
  executed independently.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Sage Weil <sage@newdream.net>
Cc: ceph-devel@vger.kernel.org
---
Only compile tested.  I think the dropping of backoff logic is safe
but am not completely sure.  Please verify it's actually okay.  Feel
free to take it into the subsystem tree or simply ack - I'll route it
through the wq tree.

Thanks.

 include/linux/ceph/messenger.h |    5 ----
 net/ceph/messenger.c           |   46 +--------------------------------------
 2 files changed, 2 insertions(+), 49 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index a108b42..c3011be 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -110,17 +110,12 @@ struct ceph_msg_pos {
 
 /*
  * ceph_connection state bit flags
- *
- * QUEUED and BUSY are used together to ensure that only a single
- * thread is currently opening, reading or writing data to the socket.
  */
 #define LOSSYTX         0  /* we can close channel or drop messages on errors */
 #define CONNECTING	1
 #define NEGOTIATING	2
 #define KEEPALIVE_PENDING      3
 #define WRITE_PENDING	4  /* we have data ready to send */
-#define QUEUED          5  /* there is work queued on this connection */
-#define BUSY            6  /* work is being done */
 #define STANDBY		8  /* no outgoing messages, socket closed.  we keep
 			    * the ceph_connection around to maintain shared
 			    * state with the peer. */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index b6ff4a1..dff633d 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -96,7 +96,7 @@ struct workqueue_struct *ceph_msgr_wq;
 
 int ceph_msgr_init(void)
 {
-	ceph_msgr_wq = create_workqueue("ceph-msgr");
+	ceph_msgr_wq = alloc_workqueue("ceph-msgr", WQ_NON_REENTRANT, 0);
 	if (!ceph_msgr_wq) {
 		pr_err("msgr_init failed to create workqueue\n");
 		return -ENOMEM;
@@ -1920,20 +1920,6 @@ bad_tag:
 /*
  * Atomically queue work on a connection.  Bump @con reference to
  * avoid races with connection teardown.
- *
- * There is some trickery going on with QUEUED and BUSY because we
- * only want a _single_ thread operating on each connection at any
- * point in time, but we want to use all available CPUs.
- *
- * The worker thread only proceeds if it can atomically set BUSY.  It
- * clears QUEUED and does it's thing.  When it thinks it's done, it
- * clears BUSY, then rechecks QUEUED.. if it's set again, it loops
- * (tries again to set BUSY).
- *
- * To queue work, we first set QUEUED, _then_ if BUSY isn't set, we
- * try to queue work.  If that fails (work is already queued, or BUSY)
- * we give up (work also already being done or is queued) but leave QUEUED
- * set so that the worker thread will loop if necessary.
  */
 static void queue_con(struct ceph_connection *con)
 {
@@ -1948,11 +1934,7 @@ static void queue_con(struct ceph_connection *con)
 		return;
 	}
 
-	set_bit(QUEUED, &con->state);
-	if (test_bit(BUSY, &con->state)) {
-		dout("queue_con %p - already BUSY\n", con);
-		con->ops->put(con);
-	} else if (!queue_work(ceph_msgr_wq, &con->work.work)) {
+	if (!queue_delayed_work(ceph_msgr_wq, &con->work, 0)) {
 		dout("queue_con %p - already queued\n", con);
 		con->ops->put(con);
 	} else {
@@ -1967,15 +1949,6 @@ static void con_work(struct work_struct *work)
 {
 	struct ceph_connection *con = container_of(work, struct ceph_connection,
 						   work.work);
-	int backoff = 0;
-
-more:
-	if (test_and_set_bit(BUSY, &con->state) != 0) {
-		dout("con_work %p BUSY already set\n", con);
-		goto out;
-	}
-	dout("con_work %p start, clearing QUEUED\n", con);
-	clear_bit(QUEUED, &con->state);
 
 	mutex_lock(&con->mutex);
 
@@ -1994,28 +1967,13 @@ more:
 	    try_read(con) < 0 ||
 	    try_write(con) < 0) {
 		mutex_unlock(&con->mutex);
-		backoff = 1;
 		ceph_fault(con);     /* error/fault path */
 		goto done_unlocked;
 	}
 
 done:
 	mutex_unlock(&con->mutex);
-
 done_unlocked:
-	clear_bit(BUSY, &con->state);
-	dout("con->state=%lu\n", con->state);
-	if (test_bit(QUEUED, &con->state)) {
-		if (!backoff || test_bit(OPENING, &con->state)) {
-			dout("con_work %p QUEUED reset, looping\n", con);
-			goto more;
-		}
-		dout("con_work %p QUEUED reset, but just faulted\n", con);
-		clear_bit(QUEUED, &con->state);
-	}
-	dout("con_work %p done\n", con);
-
-out:
 	con->ops->put(con);
 }
 
-- 
1.7.1


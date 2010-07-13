Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab0GMPO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:14:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab0GMPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:14:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH|RFC] deadline: don't allow aliased requests to starve others
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 13 Jul 2010 11:14:19 -0400
Message-ID: <x49mxtvpg6s.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In running a test case that tries to trip up the kernel's AIO
implementation, we ran into a situation where no other I/O to the device
under test would be completed.  The test program spawned (in this case)
100 threads, each of which performed the following in a loop:

open file O_DIRECT
queue 1MB of read I/O from file using 16 iocbs
close file
repeat

The program does NOT wait for the I/O to complete.  The file length is
only 4MB, meaning that you have 25 threads performing I/O on each of the
4 1MB regions.

Both deadline and cfq check for aliased requests in the sorted list of
I/Os, and when an alias is found, the request in the rb tree is moved to
the dispatch list.  So, what happens is that, with this workload, only
requests from this program are moved to the dispatch list, starving out
all other I/O.

I've attached a patch that fixes this using one approach.  The patch
just implements a counter for aliased requests served in sequence, and
dispatches from the fifo once the number of aliased requests serviced
exceeds a certain value.  What that value should be set to is difficult
to determine.  This should be a rare case, and you don't really want to
go outside of the normal scheduling mechanism for I/Os.  So, there is a
balance to be struck between dispatching requests in the alised request
code path and allowing this starvation to go on, hoping it is a
temporary situation (but ensuring progress).

Another approach I've implemented gets rid of the counter, and simply
checks the fifo when dispatching an aliased request.

Jens, let me know which approach is more palatable and I'll spin up the
appropriate patch for CFQ.

Cheers,
Jeff

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index b547cbc..7950319 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -23,6 +23,12 @@ static const int writes_starved = 2;    /* max times reads can starve a write */
 static const int fifo_batch = 16;       /* # of sequential requests treated as one
 				     by the above parameters. For throughput. */
 
+/*
+ * If this many alias requests are served without dispatching from the
+ * normal dispatch routine, dispatch any expired requests.
+ */
+#define ALIAS_MAX_BATCH		8
+
 struct deadline_data {
 	/*
 	 * run time data
@@ -41,7 +47,7 @@ struct deadline_data {
 	unsigned int batching;		/* number of sequential requests made */
 	sector_t last_sector;		/* head position */
 	unsigned int starved;		/* times reads have starved writes */
-
+	unsigned int alias_served;	/* number of alias dispatches in a row */
 	/*
 	 * settings that change how the i/o scheduler behaves
 	 */
@@ -73,14 +79,44 @@ deadline_latter_request(struct request *rq)
 	return NULL;
 }
 
+/*
+ * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
+ * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
+ */
+static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
+{
+	struct request *rq = rq_entry_fifo(dd->fifo_list[ddir].next);
+
+	/*
+	 * rq is expired!
+	 */
+	if (time_after(jiffies, rq_fifo_time(rq)))
+		return 1;
+
+	return 0;
+}
+
 static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 {
 	struct rb_root *root = deadline_rb_root(dd, rq);
 	struct request *__alias;
 
-	while (unlikely(__alias = elv_rb_add(root, rq)))
+	while (unlikely(__alias = elv_rb_add(root, rq))) {
+
 		deadline_move_request(dd, __alias);
+
+		if (++dd->alias_served >= ALIAS_MAX_BATCH) {
+			int data_dir = rq_data_dir(rq);
+			while (!list_empty(&dd->fifo_list[data_dir]) &&
+			       deadline_check_fifo(dd, data_dir)) {
+				struct request *__rq;
+				__rq = rq_entry_fifo(dd->fifo_list[data_dir].next);
+				deadline_move_request(dd, __rq);
+			}
+			dd->alias_served = 0;
+		}
+	}
 }
 
 static inline void
@@ -222,23 +258,6 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
 }
 
 /*
- * deadline_check_fifo returns 0 if there are no expired requests on the fifo,
- * 1 otherwise. Requires !list_empty(&dd->fifo_list[data_dir])
- */
-static inline int deadline_check_fifo(struct deadline_data *dd, int ddir)
-{
-	struct request *rq = rq_entry_fifo(dd->fifo_list[ddir].next);
-
-	/*
-	 * rq is expired!
-	 */
-	if (time_after(jiffies, rq_fifo_time(rq)))
-		return 1;
-
-	return 0;
-}
-
-/*
  * deadline_dispatch_requests selects the best request according to
  * read/write expire, fifo_batch, etc
  */

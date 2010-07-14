Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab0GNPJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059Ab0GNPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:09:52 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] cfq-iosched: don't allow aliased requests to starve others
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 14 Jul 2010 11:09:48 -0400
Message-ID: <x49zkxuaymb.fsf@segfault.boston.devel.redhat.com>
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

The attached patch fixes this problem by issuing all expired requests in
the aliased request handling code.  The reason I opted to issue all
expired requsts is because if we only service a single one, I still see
really awful interactivity;  an ls would take over 5 minutes to
complete.  With the attached patch, the ls took about 7 seconds to
complete.

Comments, as always, are welcome.

Cheers,
Jeff

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 7982b83..0d8d2cd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -417,6 +417,7 @@ static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
+static struct request *cfq_check_fifo(struct cfq_queue *cfqq);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
 static struct cfq_io_context *cfq_cic_lookup(struct cfq_data *,
@@ -1394,10 +1395,22 @@ static void cfq_add_rq_rb(struct request *rq)
 
 	/*
 	 * looks a little odd, but the first insert might return an alias.
-	 * if that happens, put the alias on the dispatch list
+	 * If that happens, put the alias on the dispatch list, but don't
+	 * allow issuing of aliased requests to starve out the queue.
 	 */
-	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL)
+	while ((__alias = elv_rb_add(&cfqq->sort_list, rq)) != NULL) {
+		int fifo_checked = cfq_cfqq_fifo_expire(cfqq);
+		struct request *__rq;
+
 		cfq_dispatch_insert(cfqd->queue, __alias);
+		cfq_clear_cfqq_fifo_expire(cfqq);
+		while ((__rq = cfq_check_fifo(cfqq))) {
+			cfq_dispatch_insert(cfqd->queue, __rq);
+			cfq_clear_cfqq_fifo_expire(cfqq);
+		}
+		if (fifo_checked)
+			cfq_mark_cfqq_fifo_expire(cfqq);
+	}
 
 	if (!cfq_cfqq_on_rr(cfqq))
 		cfq_add_cfqq_rr(cfqd, cfqq);

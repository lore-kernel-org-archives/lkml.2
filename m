Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0GNRCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:02:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51991 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513Ab0GNRCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:02:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] deadline-iosched: don't allow aliased requests to starve others
References: <x494og2cfjd.fsf@segfault.boston.devel.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 14 Jul 2010 13:02:33 -0400
In-Reply-To: <x494og2cfjd.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's
	message of "Wed, 14 Jul 2010 10:19:02 -0400")
Message-ID: <x49vd8iatee.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Hi,
>
> In running a test case that tries to trip up the kernel's AIO
> implementation, we ran into a situation where no other I/O to the device
> under test would be completed.  The test program spawned (in this case)
> 100 threads, each of which performed the following in a loop:
>
> open file O_DIRECT
> queue 1MB of read I/O from file using 16 iocbs
> close file
> repeat
>
> The program does NOT wait for the I/O to complete.  The file length is
> only 4MB, meaning that you have 25 threads performing I/O on each of the
> 4 1MB regions.
>
> Both deadline and cfq check for aliased requests in the sorted list of
> I/Os, and when an alias is found, the request in the rb tree is moved to
> the dispatch list.  So, what happens is that, with this workload, only
> requests from this program are moved to the dispatch list, starving out
> all other I/O.
>
> The attached patch fixes this problem by issuing all expired requests in
> the aliased request handling code.  The reason I opted to issue all
> expired requsts is because if we only service a single one, I still see
> really awful interactivity;  an ls would take over 5 minutes to
> complete.  With the attached patch, the ls took about 7 seconds to
> complete.

It occured to me that this doesn't solve the problem of starving WRITE
I/O.  So, this patch fixes that as well, tested with a dd if=/dev/zero
of=outfile bs=1M count=1 oflag=sync while.

Cheers,
Jeff

diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index b547cbc..62abb42 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -73,14 +73,48 @@ deadline_latter_request(struct request *rq)
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
+static void
+deadline_dispatch_expired(struct deadline_data *dd)
+{
+	int data_dir;
+
+	for (data_dir = 0 /* READ */; data_dir <= 1 /* WRITE */; data_dir++) {
+		while (!list_empty(&dd->fifo_list[data_dir]) &&
+		       deadline_check_fifo(dd, data_dir)) {
+			struct request *rq;
+			rq = rq_entry_fifo(dd->fifo_list[data_dir].next);
+			deadline_move_request(dd, rq);
+		}
+	}
+}
+
 static void
 deadline_add_rq_rb(struct deadline_data *dd, struct request *rq)
 {
 	struct rb_root *root = deadline_rb_root(dd, rq);
 	struct request *__alias;
 
-	while (unlikely(__alias = elv_rb_add(root, rq)))
+	while (unlikely(__alias = elv_rb_add(root, rq))) {
 		deadline_move_request(dd, __alias);
+		deadline_dispatch_expired(dd);
+	}
 }
 
 static inline void
@@ -222,23 +256,6 @@ deadline_move_request(struct deadline_data *dd, struct request *rq)
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

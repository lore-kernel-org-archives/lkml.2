Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1KUSnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:43:24 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45485 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab1KUSnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:43:22 -0500
Date: Mon, 21 Nov 2011 10:43:16 -0800
From: Tejun Heo <tj@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, rjw@sisk.pl,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] dmatest: don't use set_freezable_with_signal()
Message-ID: <20111121184316.GH15314@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 981ed70d8e (dmatest: make dmatest threads freezable) made
dmatest kthread use set_freezable_with_signal(); however, the
interface is scheduled to be removed in the next merge window.

The problem is that unlike userland tasks there's no default place
which handles signal pending state and it isn't clear who owns and/or
is responsible for clearing TIF_SIGPENDING.  For example, in the
current code, try_to_freeze() clears TIF_SIGPENDING but it isn't sure
whether it actually owns the TIF_SIGPENDING nor is it race-free -
ie. the task may continue to run with TIF_SIGPENDING set after the
freezable section.

Unfortunately, we don't have wait_for_completion_freezable_timeout().
This patch open codes it and uses wait_event_freezable_timeout()
instead and removes timeout reloading - wait_event_freezable_timeout()
won't return across freezing events (currently racy but fix scheduled)
and timer doesn't decrement while the task is in freezer.  Although
this does lose timer-reset-over-freezing, given that timeout is
supposed to be long enough and failure to finish inside is considered
irrecoverable, I don't think this is worth the complexity.

While at it, move completion to outer scope and explain that we're
ignoring dangling pointer problem after timeout.  This should give
slightly better chance at avoiding oops after timeout.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Guennadi, Dan, how does this look?  If it's okay, do you guys mind
routing this through pm tree?  I have some patches stacked on top
removal of freezable_with_signal and it would be much easier to route
these together.

Thank you.

 drivers/dma/dmatest.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index eb1d864..baa6b8d 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -214,9 +214,18 @@ static unsigned int dmatest_verify(u8 **bufs, unsigned int start,
 	return error_count;
 }
 
-static void dmatest_callback(void *completion)
+/* poor man's completion - we want to use wait_event_freezable() on it */
+struct dmatest_done {
+	bool			done;
+	wait_queue_head_t	*wait;
+};
+
+static void dmatest_callback(void *arg)
 {
-	complete(completion);
+	struct dmatest_done *done = arg;
+
+	done->done = true;
+	wake_up_all(done->wait);
 }
 
 /*
@@ -235,7 +244,9 @@ static void dmatest_callback(void *completion)
  */
 static int dmatest_func(void *data)
 {
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(done_wait);
 	struct dmatest_thread	*thread = data;
+	struct dmatest_done	done = { .wait = &done_wait };
 	struct dma_chan		*chan;
 	const char		*thread_name;
 	unsigned int		src_off, dst_off, len;
@@ -306,9 +317,6 @@ static int dmatest_func(void *data)
 		struct dma_async_tx_descriptor *tx = NULL;
 		dma_addr_t dma_srcs[src_cnt];
 		dma_addr_t dma_dsts[dst_cnt];
-		struct completion cmp;
-		unsigned long start, tmo, end = 0 /* compiler... */;
-		bool reload = true;
 		u8 align = 0;
 
 		total_tests++;
@@ -391,9 +399,9 @@ static int dmatest_func(void *data)
 			continue;
 		}
 
-		init_completion(&cmp);
+		done.done = false;
 		tx->callback = dmatest_callback;
-		tx->callback_param = &cmp;
+		tx->callback_param = &done;
 		cookie = tx->tx_submit(tx);
 
 		if (dma_submit_error(cookie)) {
@@ -407,20 +415,20 @@ static int dmatest_func(void *data)
 		}
 		dma_async_issue_pending(chan);
 
-		do {
-			start = jiffies;
-			if (reload)
-				end = start + msecs_to_jiffies(timeout);
-			else if (end <= start)
-				end = start + 1;
-			tmo = wait_for_completion_interruptible_timeout(&cmp,
-								end - start);
-			reload = try_to_freeze();
-		} while (tmo == -ERESTARTSYS);
+		wait_event_freezable_timeout(done_wait, done.done,
+					     msecs_to_jiffies(timeout));
 
 		status = dma_async_is_tx_complete(chan, cookie, NULL, NULL);
 
-		if (tmo == 0) {
+		if (!done.done) {
+			/*
+			 * We're leaving the timed out dma operation with
+			 * dangling pointer to done_wait.  To make this
+			 * correct, we'll need to allocate wait_done for
+			 * each test iteration and perform "who's gonna
+			 * free it this time?" dancing.  For now, just
+			 * leave it dangling.
+			 */
 			pr_warning("%s: #%u: test timed out\n",
 				   thread_name, total_tests - 1);
 			failed_tests++;

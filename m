Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0GETqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 15:46:04 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42250 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab0GETqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 15:46:01 -0400
Message-ID: <4C323677.9040209@kernel.dk>
Date: Mon, 05 Jul 2010 21:45:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regression] Crash in wb_clear_pending()
References: <AANLkTikoCiIoo4nfmoFGBMOkc4lNKTU_ouE15EmV1j-h@mail.gmail.com> <20100705085550.GA26775@elte.hu> <20100705164022.GA26995@infradead.org> <20100705171125.GB26202@elte.hu> <20100705171420.GA29697@elte.hu> <20100705182003.GA12332@infradead.org> <4C323177.3070606@kernel.dk> <20100705193200.GA2917@infradead.org>
In-Reply-To: <20100705193200.GA2917@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/10 21.32, Christoph Hellwig wrote:
> On Mon, Jul 05, 2010 at 09:24:39PM +0200, Jens Axboe wrote:
>> The oops itself looks like a recurrence of the missing RCU grace or
>> too early stack wakeup, which should be a 1-2 liner once it's found.
> 
> See the previous thread.  There's at least two issues:
> 
>  - wb_do_writeback checks work->state after it's been freed when we do
>    the second test_bit for WS_ONSTACK
>  - bdi_work_free accesses work->state after waking up the caller doing
>    bdi_wait_on_work_done, which might have re-used the stack space
>    allocated for the work item.
> 
> The fix for that is to get rid of the fragile work->state stuff and the
> bit wakeups by just using a completion and using that as indicator
> for the stack wait.  That's the main change the above patch does.  In
> addition it also merges the two structures used for the writeback
> requests.  Onl doing the completion and earlier list removal would
> be something like the untested patch below:

If those two late ON_STACK checks is the only issue left there,
why not just apply the below for 2.6.35?

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 0609607..15ce6ab 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -90,12 +90,13 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 static void bdi_work_free(struct rcu_head *head)
 {
 	struct bdi_work *work = container_of(head, struct bdi_work, rcu_head);
+	int on_stack = test_bit(WS_ONSTACK, &work->state);
 
 	clear_bit(WS_INPROGRESS, &work->state);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&work->state, WS_INPROGRESS);
 
-	if (!test_bit(WS_ONSTACK, &work->state))
+	if (!on_stack)
 		kfree(work);
 }
 
@@ -854,6 +855,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 
 	while ((work = get_next_work_item(bdi, wb)) != NULL) {
 		struct wb_writeback_args args = work->args;
+		int on_stack = test_bit(WS_ONSTACK, &work->state);
 
 		/*
 		 * Override sync mode, in case we must wait for completion
@@ -865,7 +867,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		 * If this isn't a data integrity operation, just notify
 		 * that we have seen this work and we are now starting it.
 		 */
-		if (!test_bit(WS_ONSTACK, &work->state))
+		if (!on_stack)
 			wb_clear_pending(wb, work);
 
 		wrote += wb_writeback(wb, &args);
@@ -874,7 +876,7 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 		 * This is a data integrity writeback, so only do the
 		 * notification when we have completed the work.
 		 */
-		if (test_bit(WS_ONSTACK, &work->state))
+		if (on_stack)
 			wb_clear_pending(wb, work);
 	}
 

-- 
Jens Axboe


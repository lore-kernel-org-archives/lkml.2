Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab2LAOi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:38:59 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49433 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2LAOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:38:58 -0500
Date: Sat, 1 Dec 2012 06:38:52 -0800
From: Tejun Heo <tj@kernel.org>
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
Message-ID: <20121201143852.GA2685@htj.dyndns.org>
References: <50A78AA9.5040904@iskon.hr>
 <20121130225200.GB6021@htj.dyndns.org>
 <20121130225545.GC6021@htj.dyndns.org>
 <50B9E4C1.2050002@iskon.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B9E4C1.2050002@iskon.hr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Dec 01, 2012 at 12:06:41PM +0100, Zlatko Calusic wrote:
> I have good news. The patch fixes the regression!
> 
> To doublecheck and provide you additional data, I updated to the latest Linus
> kernel (commit 7c17e48), recompiled (WITHOUT the patch), rebooted and this is
> what vmstat 1 looks like:

Awesome, can you please test the following patch too?  Thanks!

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 042d221..94964d1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1364,6 +1364,11 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 	BUG_ON(timer_pending(timer));
 	BUG_ON(!list_empty(&work->entry));
 
+	if (!delay) {
+		__queue_work(cpu, wq, &dwork->work);
+		return;
+	}
+
 	timer_stats_timer_set_start_info(&dwork->timer);
 
 	/*
@@ -1417,9 +1422,6 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	bool ret = false;
 	unsigned long flags;
 
-	if (!delay)
-		return queue_work_on(cpu, wq, &dwork->work);
-
 	/* read the comment in __queue_work() */
 	local_irq_save(flags);
 
